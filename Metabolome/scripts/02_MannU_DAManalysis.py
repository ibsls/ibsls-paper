#!/usr/bin/env python3

import sys
import math
from math import comb

def mannwhitneyu(x, y, correction=False, method="auto", use_midp=False):

    x = list(x)
    y = list(y)

    n1 = len(x)
    n2 = len(y)
    N = n1 + n2

    if n1 == 0 or n2 == 0:
        raise ValueError("x and y must both contain at least one observation.")

    U1 = 0.0
    for xi in x:
        for yj in y:
            if xi > yj:
                U1 += 1.0
            elif xi == yj:
                U1 += 0.5

    combined = x + y
    sorted_combined = sorted(combined)
    ties_exist = any(
        sorted_combined[i] == sorted_combined[i - 1]
        for i in range(1, len(sorted_combined))
    )

    if method == "auto":
        use_exact = (not ties_exist) and (N <= 25)
    elif method == "exact":
        if ties_exist:
            raise ValueError("Exact method in this implementation does not support ties.")
        use_exact = True
    elif method == "asymptotic":
        use_exact = False
    else:
        raise ValueError("method must be one of {'auto', 'exact', 'asymptotic'}")

    if use_exact:
        U1_int = int(U1)

        dp = [[{} for _ in range(n2 + 1)] for _ in range(n1 + 1)]
        dp[0][0] = {0: 1}

        for i in range(n1 + 1):
            for j in range(n2 + 1):
                current = dp[i][j]
                if not current:
                    continue

                if i < n1:
                    nxt = dp[i + 1][j]
                    for u, count in current.items():
                        new_u = u + j
                        nxt[new_u] = nxt.get(new_u, 0) + count

                if j < n2:
                    nxt = dp[i][j + 1]
                    for u, count in current.items():
                        nxt[u] = nxt.get(u, 0) + count

        dist = dp[n1][n2]
        total = comb(N, n1)

        U_obs = min(U1_int, n1 * n2 - U1_int)

        cdf_less = sum(count for u, count in dist.items() if u < U_obs)
        pmf_at = dist.get(U_obs, 0)
        cdf_le = cdf_less + pmf_at

        if use_midp:
            p_value = 2.0 * (cdf_less + 0.5 * pmf_at) / total
        else:
            p_value = 2.0 * cdf_le / total

        p_value = min(1.0, p_value)
        return U1, p_value

    mean_U = n1 * n2 / 2.0

    if not ties_exist:
        variance = n1 * n2 * (N + 1) / 12.0
    else:
        tie_counts = {}
        for v in combined:
            tie_counts[v] = tie_counts.get(v, 0) + 1

        tie_term = sum((t**3 - t) for t in tie_counts.values() if t > 1)
        variance = n1 * n2 / 12.0 * (N + 1 - tie_term / (N * (N - 1)))

    if variance <= 0:
        return U1, 1.0

    T_stat = min(U1, n1 * n2 - U1)
    T_stat_corr = T_stat + 0.5 if correction else T_stat

    z = (mean_U - T_stat_corr) / math.sqrt(variance)

    phi = lambda zval: 0.5 * (1.0 + math.erf(zval / math.sqrt(2.0)))
    p_value = 2.0 * (1.0 - phi(abs(z)))
    p_value = min(1.0, p_value)

    return U1, p_value
