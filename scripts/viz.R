suppressMessages(library("Biobase"))
suppressMessages(library("ggplot2"))
suppressMessages(library("pheatmap"))

gset <- readRDS('data/ExpressionSet.Rds')

ex <- exprs(gset)
df.exprs <- as.data.frame(ex)

pdf("results/boxplot.pdf", width = 15, height = 10)
boxplot(df.exprs, col="orange") 
end <- dev.off()

pdf("results/pheatmap.pdf", width = 20, height = 20)
pheatmap(cor(ex), labels_row = gset$description, labels_col = gset$description)
end <- dev.off()

scale.df.exprs <- t(scale(t(ex), scale = F))
pc <- prcomp(scale.df.exprs)

pcr <- data.frame(pc$rotation[,1:3], Group=gset$description)
pdf("results/PCA_samples.pdf")
ggplot(pcr, aes(PC1, PC2, color=Group)) + geom_point(size=3) + theme_bw()
end <- dev.off()
