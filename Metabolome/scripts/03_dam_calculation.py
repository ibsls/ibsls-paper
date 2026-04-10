#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
dam_calculation.py
dam_calculation
Example script for differential abundance metabolite (DAM) analysis.

USAGE
-----
Run from the command line as follows:

    python dam_calculation.py --input example_input.tsv --output dam_results.tsv --fdr-threshold 0.05

ARGUMENTS
---------
--input
    Path to the input tab-delimited file.

--output
    Path to the output tab-delimited file.
    Default: dam_results.tsv

--fdr-threshold
    FDR threshold used to determine significance.
    Default: 0.05

INPUT FILE FORMAT
-----------------
The input file must be a tab-delimited text file with a header line.
It must contain at least the following four columns:

    common_id
    common_name
    gc_values
    fl_values

COLUMN DESCRIPTIONS
-------------------
common_id
    Unique identifier for the metabolite.

common_name
    Human-readable metabolite name.

gc_values
    Comma-separated replicate-level concentration values for the GC group.

fl_values
    Comma-separated replicate-level concentration values for the FL group.

EXAMPLE INPUT
-------------
common_id	common_name	gc_values	fl_values
EX001	Example_metabolite	152,146,165,133,119,132	168,208,167,146,124,193

OUTPUT
------
The output is a tab-delimited file containing the following columns:

    common_id
    common_name
    n_gc
    n_fl
    gc_mean
    fl_mean
    u_stat
    p_value
    fdr
    log2fc
    regulation
    significant

NOTES
-----
- Concentration values are treated as raw metabolite concentrations.
- Missing-like values such as '', '-', 'NA', 'NaN', 'None', and 'null' are ignored.
- Metabolites with no valid values in either group are skipped.
- The Mann-Whitney U test and Benjamini-Hochberg correction follow the current database logic.
"""

from __future__ import print_function
import math
import csv
import argparse


MISSING_LIKE = set(['', '-', 'NA', 'NaN', 'None', 'null'])


def comb(n, k):
    """Calculate the binomial coefficient (nCk)."""
    return math.factorial(n) // (math.factorial(k) * math.factorial(n - k))


def mannwhitneyu(x, y, correction=False):
    """
    Improved two-sided Mann-Whitney U test.

    Parameters:
      x, y : lists of numeric values from two independent groups
      correction : apply continuity correction if True (default: False)

    Returns:
      (U_stat, p_value)
        U_stat : U1 statistic for the first group
        p_value: two-sided p-value

    Notes:
      - For each x value, 1 is added for each y value smaller than x,
        and 0.5 is added for ties.
      - If there are no ties and the total sample size is <= 25,
        an exact p-value is computed using dynamic programming with
        mid-p correction.
      - Otherwise, a normal approximation with tie-corrected variance
        is used.
    """
    n1 = len(x)
    n2 = len(y)
    N = n1 + n2

    # Step 1: Calculate U1
    U1 = 0.0
    for xi in x:
        for yj in y:
            if xi > yj:
                U1 += 1
            elif xi == yj:
                U1 += 0.5

    # Step 2: Check for ties
    combined = x + y
    sorted_combined = sorted(combined)
    ties_exist = any(sorted_combined[i] == sorted_combined[i - 1] for i in range(1, len(sorted_combined)))

    # Step 3: Select exact or asymptotic calculation
    use_exact = (not ties_exist) and (N <= 25)

    if use_exact:
        dp = [[{} for _ in range(n2 + 1)] for _ in range(n1 + 1)]
        dp[0][0] = {0: 1}

        for i in range(n1 + 1):
            for j in range(n2 + 1):
                if i < n1:
                    for u, count in dp[i][j].items():
                        new_u = u + j
                        dp[i + 1][j][new_u] = dp[i + 1][j].get(new_u, 0) + count
                if j < n2:
                    for u, count in dp[i][j].items():
                        dp[i][j + 1][u] = dp[i][j + 1].get(u, 0) + count

        dist = dp[n1][n2]
        total = comb(N, n1)

        U_obs = U1 if U1 <= n1 * n2 / 2.0 else n1 * n2 - U1

        cdf_less = sum(count for u_val, count in dist.items() if u_val < U_obs)
        pmf_at = dist.get(U_obs, 0)
        p_one = (cdf_less + 0.5 * pmf_at) / total
        p_value = 2 * p_one
        if p_value > 1:
            p_value = 1.0
    else:
        mean_U = n1 * n2 / 2.0
        if not ties_exist:
            variance = n1 * n2 * (N + 1) / 12.0
        else:
            tie_counts = {}
            for val in combined:
                tie_counts[val] = tie_counts.get(val, 0) + 1
            tie_term = 0
            for t in tie_counts.values():
                if t > 1:
                    tie_term += (t ** 3 - t)
            variance = n1 * n2 / 12.0 * (N + 1 - tie_term / (N * (N - 1)))

        T_stat = U1 if U1 <= mean_U else (n1 * n2 - U1)
        if correction:
            T_stat_corr = T_stat + 0.5 if U1 <= mean_U else T_stat - 0.5
        else:
            T_stat_corr = T_stat

        z = (mean_U - T_stat_corr) / math.sqrt(variance)
        phi = lambda z_val: 0.5 * (1 + math.erf(z_val / math.sqrt(2)))
        p_value = 2 * (1 - phi(abs(z)))
        if p_value > 1:
            p_value = 1.0

    return U1, p_value


def benjamini_hochberg_dict(p_dict):
    """
    Apply the Benjamini-Hochberg procedure to a dictionary of p-values.

    Parameters:
      p_dict : dict
        Dictionary with variable names as keys and raw p-values as values

    Returns:
      dict
        Dictionary with variable names as keys and adjusted p-values as values
    """
    keys = list(p_dict.keys())
    p_values = [p_dict[k] for k in keys]
    m = len(p_values)

    if m == 0:
        return {}

    sorted_indices = sorted(range(m), key=lambda i: p_values[i])
    sorted_keys = [keys[i] for i in sorted_indices]
    sorted_p = [p_values[i] for i in sorted_indices]

    adjusted = [0.0] * m
    adjusted[m - 1] = sorted_p[m - 1]
    for i in range(m - 2, -1, -1):
        adjusted[i] = min(sorted_p[i] * m / float(i + 1), adjusted[i + 1])

    adjusted = [min(1.0, a) for a in adjusted]
    fdr_dict = {sorted_keys[i]: adjusted[i] for i in range(m)}
    return fdr_dict


def parse_numeric_list(raw):
    """
    Convert a comma-separated numeric string into a list of floats.
    Skip missing-like values such as '-', '', 'NA', etc.
    """
    vals = []
    if raw is None:
        return vals

    for x in str(raw).split(','):
        s = x.strip().strip('"').strip("'")
        if s in MISSING_LIKE:
            continue
        try:
            vals.append(float(s))
        except (TypeError, ValueError):
            continue
    return vals


def safe_mean(vals):
    """Return the mean of a numeric list, or None if empty."""
    if not vals:
        return None
    return sum(vals) / float(len(vals))


def safe_log2fc(gc_mean, fl_mean):
    """
    Calculate log2(FL / GC).
    Add a small pseudocount when either value is <= 0.
    """
    try:
        gc = float(gc_mean)
        fl = float(fl_mean)
    except (TypeError, ValueError):
        return None

    pseudo = 1e-9
    gc = gc if gc > 0 else pseudo
    fl = fl if fl > 0 else pseudo

    try:
        v = math.log(fl / gc, 2)
    except (ValueError, ZeroDivisionError):
        return None

    if not math.isfinite(v):
        return None
    return v


def run_dam_analysis(rows, fdr_threshold):
    """
    Run DAM analysis on input rows.

    Parameters:
      rows : list of dicts with keys:
        - common_id
        - common_name
        - gc_values
        - fl_values
      fdr_threshold : float
        Threshold for significance based on adjusted p-value
    """
    p_dict = {}
    stat_dict = {}
    order = []

    for row in rows:
        metabolite_id = row['common_id']
        common_name = row['common_name']
        gc_list = parse_numeric_list(row['gc_values'])
        fl_list = parse_numeric_list(row['fl_values'])

        if (not gc_list) or (not fl_list):
            continue

        gc_mean = safe_mean(gc_list)
        fl_mean = safe_mean(fl_list)

        if gc_mean is None or fl_mean is None:
            continue

        u_stat, p_value = mannwhitneyu(gc_list, fl_list, correction=False)

        p_dict[metabolite_id] = p_value
        stat_dict[metabolite_id] = {
            'common_name': common_name,
            'gc_list': gc_list,
            'fl_list': fl_list,
            'gc_mean': gc_mean,
            'fl_mean': fl_mean,
            'u_stat': u_stat,
            'p_value': p_value,
        }
        order.append(metabolite_id)

    fdr_dict = benjamini_hochberg_dict(p_dict)

    results = []
    for metabolite_id in order:
        d = stat_dict[metabolite_id]
        gc_mean = d['gc_mean']
        fl_mean = d['fl_mean']
        fdr = fdr_dict[metabolite_id]
        log2fc = safe_log2fc(gc_mean, fl_mean)

        if gc_mean <= fl_mean:
            regulation = 'up'
        else:
            regulation = 'down'

        significant = 'yes' if fdr <= fdr_threshold else 'no'

        results.append({
            'common_id': metabolite_id,
            'common_name': d['common_name'],
            'n_gc': len(d['gc_list']),
            'n_fl': len(d['fl_list']),
            'gc_mean': gc_mean,
            'fl_mean': fl_mean,
            'u_stat': d['u_stat'],
            'p_value': d['p_value'],
            'fdr': fdr,
            'log2fc': log2fc,
            'regulation': regulation,
            'significant': significant,
        })

    results.sort(key=lambda x: x['fdr'])
    return results


def read_input_tsv(path):
    """Read input rows from a tab-delimited file."""
    rows = []
    with open(path, 'r') as f:
        reader = csv.DictReader(f, delimiter='\t')
        for row in reader:
            rows.append(row)
    return rows


def write_output_tsv(results, path):
    """Write analysis results to a tab-delimited file."""
    fieldnames = [
        'common_id',
        'common_name',
        'n_gc',
        'n_fl',
        'gc_mean',
        'fl_mean',
        'u_stat',
        'p_value',
        'fdr',
        'log2fc',
        'regulation',
        'significant',
    ]
    with open(path, 'w') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, delimiter='\t', lineterminator='\n')
        writer.writeheader()
        for row in results:
            writer.writerow(row)


def main():
    parser = argparse.ArgumentParser(description='Example DAM analysis script')
    parser.add_argument('--input', required=True, help='Input TSV file')
    parser.add_argument('--output', default='dam_results.tsv', help='Output TSV file')
    parser.add_argument('--fdr-threshold', type=float, default=0.05, help='FDR threshold')
    args = parser.parse_args()

    rows = read_input_tsv(args.input)
    results = run_dam_analysis(rows, args.fdr_threshold)
    write_output_tsv(results, args.output)

    print('Input rows: %d' % len(rows))
    print('Output rows: %d' % len(results))
    print('Results written to: %s' % args.output)

    if results:
        print('')
        print('Top result:')
        top = results[0]
        for key in [
            'common_id', 'common_name', 'n_gc', 'n_fl', 'gc_mean', 'fl_mean',
            'u_stat', 'p_value', 'fdr', 'log2fc', 'regulation', 'significant'
        ]:
            print('%s: %s' % (key, top[key]))


if __name__ == '__main__':
    main()