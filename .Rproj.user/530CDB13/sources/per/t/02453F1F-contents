suppressMessages(library("Biobase"))
suppressMessages(library("limma"))

gset <- readRDS('data/ExpressionSet.Rds')

design <- model.matrix(~ description + 0, gset)
colnames(design) <- levels(gset$description)
fit <- lmFit(gset, design)
cont.matrix <- makeContrasts(Leukemia-Normal, levels = design)
fit2 <- contrasts.fit(fit, cont.matrix)
fit2 <- eBayes(fit2, 0.01)
tT <- topTable(fit2, adjust.method="fdr", sort.by="B", number = Inf)

tT <- subset(tT, select=c("Gene.symbol", "Gene.ID", "adj.P.Val", "logFC"))

aml.up <- subset(tT, logFC > 1 & adj.P.Val < 0.05)
aml.up.genes <- unique(aml.up$Gene.symbol)
aml.up.genes <- unique(as.character(strsplit2(aml.up.genes, "///")))
write.table(aml.up.genes, file="results/upregulated.txt", quote = F, row.names = F, col.names = F)

aml.down <- subset(tT, logFC < -1 & adj.P.Val < 0.05)
aml.down.genes <- unique(aml.down$Gene.symbol)
aml.down.genes <- unique(as.character(strsplit2(aml.down.genes, "///")))
write.table(aml.down.genes, file="results/downregulated.txt", quote = F, row.names = F, col.names = F)