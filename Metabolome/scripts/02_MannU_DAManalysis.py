#!/usr/bin/env python3
"""
02_MannU_DAManalysis.py

Standalone differential abundance analysis for metabolite tables used in ibSLS.

This script performs two-group differential abundance analysis for each
metabolite using a custom implementation of the two-sided Mann–Whitney U test,
followed by Benjamini–Hochberg false discovery rate (FDR) correction.

Input format
------------
A tab-delimited or comma-delimited table in which:
- the first column contains metabolite identifiers (e.g. CommonID)
- each remaining column corresponds to one experimental group
- each cell contains comma-separated replicate values for that metabolite/group

Example:
CommonID    WT_GC                   WT_FL                   KO_GC                   KO_FL
Ala         331,287,299,325,533     231,227,334,337,352     169,245,293,385,406     333,461,128,491,359
Arg         56.1,52.1,35.8,69.5     36.3,35.7,49.8,50.2     45.1,47.1,75.1,111      61.2,67,25.9,94.8

Usage
-----
python 02_MannU_DAManalysis.py \
    --input metabolite_table.tsv \
    --group1 WT_GC \
    --group2 WT_FL \
    --output DAM_results.tsv

Notes
-----
- Replicate values are expected to be comma-separated within each group column.
- Missing values such as '', 'NA', 'NaN', and 'null' are ignored.
- This script provides a standalone implementation of the statistical logic
  used in the ibSLS metabolome workflow.
- Numerical results may not be identical to all settings of external
  statistical libraries.
"""

from __future__ import annotations

import argparse
import math
from typing import Dict, List, Tuple

import pandas as pd


def comb(n: int, k: int) -> int:
    """Return the number of combinations (n choose k)."""
    if k < 0 or k > n:
        return 0
    return math.factorial(n) // (math.factorial(k) * math.factorial(n - k))


def custom_mann_whitney_u_test(
    x: List[float],
    y: List[float],
    correction: bool = False,
) -> Tuple[float, float]:
    """
    Perform a two-sided Mann–Whitney U test using a custom implementation.

    Parameters
    ----------
    x, y : list of float
        Numeric observations for the two independent groups.
    correction : bool, default False
        Whether to apply continuity correction for the normal approximation.

    Returns
    -------
    (u_stat, p_value) : tuple of float
        u_stat is U1, defined for group x.
        p_value is the two-sided P value.
    """
    n1 = len(x)
    n2 = len(y)
    if n1 == 0 or n2 == 0:
        return float("nan"), float("nan")

    N = n1 + n2

    # Compute U1
    u1 = 0.0
    for xi in x:
        for yj in y:
            if xi > yj:
                u1 += 1.0
            elif xi == yj:
                u1 += 0.5

    combined = x + y
    sorted_combined = sorted(combined)
    ties_exist = any(
        sorted_combined[i] == sorted_combined[i - 1]
        for i in range(1, len(sorted_combined))
    )

    use_exact = (not ties_exist) and (N <= 25)

    if use_exact:
        dp = [[{} for _ in range(n2 + 1)] for _ in range(n1 + 1)]
        dp[0][0] = {0: 1}

        for i in range(n1 + 1):
            for j in range(n2 + 1):
                current = dp[i][j]
                if not current:
                    continue

                if i < n1:
                    for u, count in current.items():
                        new_u = u + j
                        dp[i + 1][j][new_u] = dp[i + 1][j].get(new_u, 0) + count

                if j < n2:
                    for u, count in current.items():
                        dp[i][j + 1][u] = dp[i][j + 1].get(u, 0) + count

        dist = dp[n1][n2]
        total = comb(N, n1)

        u_obs = u1 if u1 <= (n1 * n2 / 2.0) else (n1 * n2 - u1)

        cdf_less = sum(count for u_val, count in dist.items() if u_val < u_obs)
        pmf_at = dist.get(u_obs, 0)

        p_one = (cdf_less + 0.5 * pmf_at) / total
        p_value = min(1.0, 2.0 * p_one)

    else:
        mean_u = n1 * n2 / 2.0

        if not ties_exist:
            variance = n1 * n2 * (N + 1) / 12.0
        else:
            tie_counts: Dict[float, int] = {}
            for val in combined:
                tie_counts[val] = tie_counts.get(val, 0) + 1

            tie_term = 0.0
            for t in tie_counts.values():
                if t > 1:
                    tie_term += (t**3 - t)

            variance = n1 * n2 / 12.0 * (N + 1 - tie_term / (N * (N - 1)))

        if variance <= 0:
            return u1, float("nan")

        t_stat = u1 if u1 <= mean_u else (n1 * n2 - u1)

        if correction:
            t_stat_corr = t_stat + 0.5 if u1 <= mean_u else t_stat - 0.5
        else:
            t_stat_corr = t_stat

        z = (mean_u - t_stat_corr) / math.sqrt(variance)
        phi = lambda z_val: 0.5 * (1.0 + math.erf(z_val / math.sqrt(2.0)))
        p_value = min(1.0, 2.0 * (1.0 - phi(abs(z))))

    return u1, p_value


def benjamini_hochberg_dict(p_dict: Dict[str, float]) -> Dict[str, float]:
    """
    Apply Benjamini–Hochberg FDR correction to a dictionary of P values.
    """
    if not p_dict:
        return {}

    keys = list(p_dict.keys())
    p_values = [p_dict[k] for k in keys]
    m = len(p_values)

    sorted_indices = sorted(range(m), key=lambda i: p_values[i])
    sorted_keys = [keys[i] for i in sorted_indices]
    sorted_p = [p_values[i] for i in sorted_indices]

    adjusted = [0.0] * m
    adjusted[m - 1] = sorted_p[m - 1]

    for i in range(m - 2, -1, -1):
        adjusted[i] = min(sorted_p[i] * m / (i + 1), adjusted[i + 1])

    adjusted = [min(1.0, a) for a in adjusted]
    return {sorted_keys[i]: adjusted[i] for i in range(m)}


def infer_sep(path: str) -> str:
    """Infer input delimiter from file extension."""
    lower = path.lower()
    if lower.endswith(".csv"):
        return ","
    return "\t"


def parse_replicate_string(value) -> List[float]:
    """
    Parse a comma-separated replicate string into a list of floats.

    Examples
    --------
    '1.2,2.3,3.4' -> [1.2, 2.3, 3.4]
    """
    if pd.isna(value):
        return []

    if isinstance(value, (int, float)):
        return [float(value)]

    text = str(value).strip()
    if text == "":
        return []

    missing_tokens = {"na", "nan", "null", "none", ""}
    parsed = []

    for token in text.split(","):
        token = token.strip()
        if token.lower() in missing_tokens:
            continue
        parsed.append(float(token))

    return parsed


def run_analysis(
    df: pd.DataFrame,
    id_col: str,
    group1: str,
    group2: str,
    continuity_correction: bool = False,
) -> pd.DataFrame:
    """Run per-metabolite two-group differential abundance analysis."""
    if id_col not in df.columns:
        raise ValueError(f"Identifier column not found: {id_col}")
    if group1 not in df.columns:
        raise ValueError(f"Group column not found: {group1}")
    if group2 not in df.columns:
        raise ValueError(f"Group column not found: {group2}")

    results = []
    raw_p_dict: Dict[str, float] = {}

    for _, row in df.iterrows():
        metabolite = str(row[id_col])

        x = parse_replicate_string(row[group1])
        y = parse_replicate_string(row[group2])

        if len(x) == 0 or len(y) == 0:
            u_stat = float("nan")
            p_value = float("nan")
            mean_group1 = float("nan")
            mean_group2 = float("nan")
            sd_group1 = float("nan")
            sd_group2 = float("nan")
            median_group1 = float("nan")
            median_group2 = float("nan")
            log2_fc = float("nan")
        else:
            u_stat, p_value = custom_mann_whitney_u_test(
                x, y, correction=continuity_correction
            )

            s1 = pd.Series(x, dtype=float)
            s2 = pd.Series(y, dtype=float)

            mean_group1 = float(s1.mean())
            mean_group2 = float(s2.mean())
            sd_group1 = float(s1.std(ddof=1)) if len(s1) > 1 else float("nan")
            sd_group2 = float(s2.std(ddof=1)) if len(s2) > 1 else float("nan")
            median_group1 = float(s1.median())
            median_group2 = float(s2.median())

            log2_fc = math.log2((median_group2 + 1e-9) / (median_group1 + 1e-9))

            if not math.isnan(p_value):
                raw_p_dict[metabolite] = p_value

        results.append(
            {
                id_col: metabolite,
                "group1": group1,
                "group2": group2,
                "n_group1": len(x),
                "n_group2": len(y),
                "mean_group1": mean_group1,
                "mean_group2": mean_group2,
                "sd_group1": sd_group1,
                "sd_group2": sd_group2,
                "median_group1": median_group1,
                "median_group2": median_group2,
                "log2FC_group2_vs_group1": log2_fc,
                "U_statistic": u_stat,
                "p_value": p_value,
            }
        )

    result_df = pd.DataFrame(results)

    fdr_dict = benjamini_hochberg_dict(raw_p_dict)
    result_df["FDR"] = result_df[id_col].map(fdr_dict)

    return result_df.sort_values(["p_value", id_col], na_position="last")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Perform two-group differential abundance analysis for metabolite "
            "tables containing comma-separated replicate values."
        )
    )
    parser.add_argument(
        "--input",
        required=True,
        help="Input metabolite table (.tsv/.txt or .csv).",
    )
    parser.add_argument(
        "--output",
        required=True,
        help="Output results table (.tsv).",
    )
    parser.add_argument(
        "--id-col",
        default="CommonID",
        help="Identifier column name (default: CommonID).",
    )
    parser.add_argument(
        "--group1",
        required=True,
        help="Name of the first group column.",
    )
    parser.add_argument(
        "--group2",
        required=True,
        help="Name of the second group column.",
    )
    parser.add_argument(
        "--continuity-correction",
        action="store_true",
        help="Apply continuity correction in the normal approximation.",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    sep = infer_sep(args.input)
    df = pd.read_csv(args.input, sep=sep, dtype=str)

    result_df = run_analysis(
        df=df,
        id_col=args.id_col,
        group1=args.group1,
        group2=args.group2,
        continuity_correction=args.continuity_correction,
    )

    result_df.to_csv(args.output, sep="\t", index=False)


if __name__ == "__main__":
    main()
