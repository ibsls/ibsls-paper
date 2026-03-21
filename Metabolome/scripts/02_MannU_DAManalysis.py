## Differential abundance analysis

`02_MannU_DAManalysis.py` performs two-group differential abundance analysis for metabolite abundance tables in which each group column contains comma-separated replicate values.

### Input format
The input table should contain:
- one identifier column (default: `CommonID`)
- two or more group columns
- comma-separated replicate values in each group cell

Example:

| CommonID | WT_GC | WT_FL | KO_GC | KO_FL |
|---|---|---|---|---|
| Ala | 331,287,299,325,533,393 | 231,227,334,337,352,312 | 169,245,293,385,406,326 | 333,461,128,491,359,365 |

### Example command

```bash
python 02_MannU_DAManalysis.py \
  --input metabolite_table.tsv \
  --group1 WT_GC \
  --group2 WT_FL \
  --output WT_FL_vs_WT_GC.tsv
