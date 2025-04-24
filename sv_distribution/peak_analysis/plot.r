
# 加载必要的库
library(ggplot2)
library(dplyr)
library(scales)

# 1. 数据加载
# 读取 CSV 文件
data <- read.csv("te_proportion_results.csv")

# 检查数据
print("原始数据：")
print(head(data))

# 2. 数据处理
# 将 Proportion 列转换为数值（去掉百分号）
data$Proportion <- as.numeric(sub("%", "", data$Proportion))

# 检查转换后的数据
print("转换后的数据：")
print(head(data))

# 3. 绘图
# 绘制堆积柱状图
p <- ggplot(data, aes(x = factor(Length), y = Proportion, fill = TE)) +
  geom_bar(stat = "identity", position = "stack", width = 0.7) +
  scale_fill_manual(values = hue_pal()(length(unique(data$TE)))) +  # 使用鲜艳的颜色
  labs(
    title = "TE Proportion by Length",
    x = "Length",
    y = "Proportion (%)",
    fill = "Transposable Element (TE)"
  ) +
  theme_minimal() +  # 使用 ggplot2 的默认主题
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),  # 旋转 x 轴标签
    legend.position = "bottom"  # 图例放在底部
  )

# 打印图形
print(p)

# 4. 保存图形
ggsave("te_proportion_plot.png", plot = p, width = 8, height = 6, dpi = 300)
ggsave("te_proportion_plot.pdf", plot = p, width = 8, height = 6)  # 保存为 PDF
