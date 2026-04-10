#!/usr/bin/env python3
# coding: UTF-8

# Generate compact count tables for DESeq2 from a merged gene expression table.
#
# Required input files:
#   - sample_list.tsv
#   - merged.genes.results.txt
#
# Input assumptions:
#   sample_list.tsv must contain at least:
#     - sample ID in column 1
#     - tissue in column 2
#     - group in column 3
#   merged.genes.results.txt must contain expected_count columns named as:
#     SAMPLEID|expected_count
#
# Output:
#   - count_table.tsv
#
# Notes:
#   - Each output cell contains comma-separated replicate counts for one group.

def main():
    sample_dict = {}
    sample_list = []

    ref_file = open("sample_list.tsv", "r")
    lines = ref_file.readlines()
    ref_file.close()

    for line in lines[1:]:
        line_items = line.strip().split("\t")
        sample_id = line_items[0]
        tissue = line_items[1]
        category = line_items[2]

        if tissue not in sample_dict:
            sample_dict[tissue] = {}
        if category not in sample_dict[tissue]:
            sample_dict[tissue][category] = []

        sample_dict[tissue][category].append(sample_id)
        sample_list.append(sample_id)

    print("# Sample:", len(sample_list))

    expression_dict = {}
    ref_file = open("merged.genes.results.txt", "r")
    lines = ref_file.readlines()
    ref_file.close()

    header = lines[0].strip().split("\t")

    c = 0
    for line in lines[1:]:
        line_items = line.strip().split("\t")
        gene_id = line_items[0]
        expression_dict[gene_id] = {}

        for i, e in enumerate(header):
            if e.endswith("|expected_count"):
               sample_id = e.split("|")[0]
               expression_dict[gene_id][sample_id] = line_items[i]
        
        c += 1
        if c % 1000 == 0:
            print(c)

    first_gene = next(iter(expression_dict))
    sample_with_expression = sorted(expression_dict[first_gene].keys())
    print("# Sample with expression:", len(sample_with_expression))

    sample_with_expression_with_annotation = list(set(sample_with_expression) & set(sample_list))
    print("# Sample with expression and annotation:", len(sample_with_expression_with_annotation))

    output_file = open("count_table.tsv", "w")

    header = ["GeneID"]
    for tissue, v1 in sorted(sample_dict.items()):
        for category, v2 in sorted(v1.items()):
            header.append("%s_%s" % (tissue, category))
    output_file.write("\t".join(header) + "\n")

    c = 0
    for gene_id, v1 in sorted(expression_dict.items()):
        output_items = [gene_id]

        for tissue, v2 in sorted(sample_dict.items()):
            for category, v3 in sorted(v2.items()):
                count_list = []
                for sample_id in v3:
                    count_list.append(v1[sample_id])
                output_items.append(",".join(count_list))

        output_file.write("\t".join(output_items) + "\n")
        c += 1
        print(c)

    output_file.close()


if __name__ == "__main__":
    main()
