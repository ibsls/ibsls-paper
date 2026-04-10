#!/usr/bin/env python3
# coding: UTF-8

# Generate compact concentration tables for difference abundant metabolite analysis.
#
# Required input files:
#   - sample_list.tsv
#   - merged.concentration.tsv
#
# Input assumptions:
#   sample_list.tsv must contain at least:
#     - sample ID in column 1
#     - group in column 2
#   merged.concentration.tsv must contain sample ID which described in sample_list.tsv
#
# Output:
#   - metabolite_input_data.tsv
#
# Notes:
#   - Each output cell contains comma-separated replicate concentrations for one group.

def main():
    sample_dict = {}
    sample_list = []

    ref_file = open("sample_list.tsv", "r")
    lines = ref_file.readlines()
    ref_file.close()

    for line in lines[1:]:
        line_items = line.strip().split("\t")
        sample_id = line_items[0]
        category = line_items[1]

        if category not in sample_dict:
            sample_dict[category] = []

        sample_dict[category].append(sample_id)
        sample_list.append(sample_id)

    print("# Sample:", len(sample_list))

    concentration_dict = {}
    annotation_dict = {}
    ref_file = open("merged.concentration.tsv", "r")
    lines = ref_file.readlines()
    ref_file.close()

    header = lines[0].strip().split("\t")

    c = 0
    for line in lines[1:]:
        line_items = line.strip().split("\t")
        metabolite_id = line_items[0]
        metabolite_annotation = line_items[1]
        annotation_dict[metabolite_id] = metabolite_annotation
        concentration_dict[metabolite_id] = {}

        for i, e in enumerate(header):
            if e in sample_list:
               sample_id = e
               concentration_dict[metabolite_id][sample_id] = line_items[i]

        c += 1
        if c % 1000 == 0:
            print(c)

    first_metabolite = next(iter(concentration_dict))
    sample_with_concentration = sorted(concentration_dict[first_metabolite].keys())
    print("# Sample with concentration:", len(sample_with_concentration))

    sample_with_concentration_with_annotation = list(set(sample_with_concentration) & set(sample_list))
    print("# Sample with concentration and annotation:", len(sample_with_concentration_with_annotation))

    output_file = open("metabolite_input_data.tsv", "w")

    header = ["common_id", "common_name"]
    group_list = ["group_1", "group_2"]
    for i, category in enumerate(sorted(sample_dict.keys())):
        header.append(group_list[i])
        print('%s ---> %s' % (group_list[i], category))
    output_file.write("\t".join(header) + "\n")

    c = 0
    for metabolite_id, v1 in sorted(concentration_dict.items()):
        output_items = [metabolite_id, annotation_dict[metabolite_id]]

        for category, v2 in sorted(sample_dict.items()):
            concentration_list = []
            for sample_id in v2:
                concentration_list.append(v1[sample_id])
            output_items.append(",".join(concentration_list))

        output_file.write("\t".join(output_items) + "\n")
        c += 1
        print(c)

    output_file.close()


if __name__ == "__main__":
    main()
