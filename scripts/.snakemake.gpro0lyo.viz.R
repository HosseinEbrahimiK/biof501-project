
######## Snakemake header ########
library(methods)
Snakemake <- setClass(
    "Snakemake",
    slots = c(
        input = "list",
        output = "list",
        params = "list",
        wildcards = "list",
        threads = "numeric",
        log = "list",
        resources = "list",
        config = "list",
        rule = "character"
    )
)
snakemake <- Snakemake(
    input = list('data/ExpressionSet.Rds', "viz_data" = 'data/ExpressionSet.Rds'),
    output = list('results/pheatmap.pdf', 'results/boxplot.pdf', 'results/PCA_samples.pdf', "pheatmap" = 'results/pheatmap.pdf', "boxplot" = 'results/boxplot.pdf', "pca" = 'results/PCA_samples.pdf'),
    params = list(),
    wildcards = list(),
    threads = 1,
    log = list(),
    resources = list(),
    config = list(),
    rule = 'visualization'
)
######## Original script #########
library("Biobase")
library("ggplot2")
library("pheatmap")

gset <- readRDS('data/ExpressionSet.Rds')

ex <- exprs(gset)
df.exprs <- as.data.frame(ex)
?
pdf("results/boxplot.pdf", width = 15, height = 10)
boxplot(df.exprs, col="orange") 
dev.off()

pdf("results/pheatmap.pdf", width = 20, height = 20)
pheatmap(cor(ex), labels_row = gset$description, labels_col = gset$description)
dev.off()

scale.df.exprs <- t(scale(t(ex), scale = F))
pc <- prcomp(scale.df.exprs)

pcr <- data.frame(pc$rotation[,1:3], Group=gset$description)
pdf("results/PCA_samples.pdf")
ggplot(pcr, aes(PC1, PC2, color=Group)) + geom_point(size=3) + theme_bw()
dev.off()
