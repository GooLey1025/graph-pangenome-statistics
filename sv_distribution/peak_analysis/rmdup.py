from collections import defaultdict
import csv

# 读取文件并去重
file_path = "blast_results.txt"
unique_results = {}  # 存储每个序列名称的最佳结果

with open(file_path, "r") as file:
    for line in file:
        # 分割每一行
        parts = line.strip().split()
        if len(parts) < 2:
            continue

        # 提取序列名称、TE 名称和 E-value
        seq_name = parts[0]
        te_part = parts[1]
        evalue = float(parts[-2])  # E-value 是倒数第二列

        # 提取 TE 名称（# 和 / 之间的部分）
        if "#" in te_part and "/" in te_part:
            te_name = te_part.split("#")[1].split("/")[0]
        else:
            te_name = "Unknown"

        # 如果序列名称已存在，保留 E-value 最小的一行
        if seq_name in unique_results:
            if evalue < unique_results[seq_name]["evalue"]:
                unique_results[seq_name] = {"te_name": te_name, "evalue": evalue}
        else:
            unique_results[seq_name] = {"te_name": te_name, "evalue": evalue}

# 统计每个 length 的 TE 比例
length_te_count = defaultdict(lambda: defaultdict(int))  # 存储每个 length 的 TE 计数
total_counts = defaultdict(int)  # 存储每个 length 的总计数

for seq_name, data in unique_results.items():
    # 提取 length 值（从 id=_MINIGRAPH_|s99_length=244 中提取 244）
    if "length=" in seq_name:
        length = seq_name.split("length=")[-1]
    else:
        length = "Unknown"

    # 统计 TE 数量
    te_name = data["te_name"]
    length_te_count[length][te_name] += 1
    total_counts[length] += 1

# 将结果保存为 CSV 文件
output_file = "te_proportion_results.csv"
with open(output_file, "w", newline="") as csvfile:
    writer = csv.writer(csvfile)
    # 写入表头
    writer.writerow(["Length", "TE", "Count", "Proportion"])

    # 写入数据
    for length, te_counts in length_te_count.items():
        total = total_counts[length]
        for te_name, count in te_counts.items():
            proportion = (count / total) * 100
            writer.writerow([length, te_name, count, f"{proportion:.2f}%"])

print(f"Results saved to {output_file}")
