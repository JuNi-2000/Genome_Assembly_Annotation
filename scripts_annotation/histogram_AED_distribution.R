library(ggplot2)
data <- read.table('./assembly.all.maker.renamed.gff.AED.txt', header = TRUE)

names(data) <- c('AED', 'cum_percentile')

ggplot(data, aes(x = AED, y = cum_percentile)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Histogram of AED Values", x = "AED", y = "Cumulative percentiles")

