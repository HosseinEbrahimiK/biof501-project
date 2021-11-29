suppressMessages(library("Biobase"))
suppressMessages(library("limma"))

gset <- readRDS('data/GSE48558_series_matrix.Rds')

ex <- exprs(gset)

# log2 transform with median checking
qx <- as.numeric(quantile(ex, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T))
LogC <- (qx[5] > 100) ||
  (qx[6]-qx[1] > 50 && qx[2] > 0)
if (LogC) { 
ex[which(ex <= 0)] <- NaN
ex <- log2(ex)
}

ex <- limma::normalizeQuantiles(ex)

exprs(gset) <- ex

groups <- pData(gset)$`phenotype:ch1`
groups <- factor(groups)

gset$description <- groups

saveRDS(gset, "data/ExpressionSet.Rds")
