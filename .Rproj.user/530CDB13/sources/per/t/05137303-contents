if (!requireNamespace("BiocManager", quietly = TRUE))
  suppressMessages(install.packages("BiocManager"))

suppressMessages(BiocManager::install("GEOquery"))
suppressMessages(BiocManager::install("rtracklayer"))
suppressMessages(BiocManager::install("Biobase"))
suppressMessages(BiocManager::install("limma"))
suppressMessages(install.packages("tidyverse", repos = "http://cran.us.r-project.org"))
suppressMessages(install.packages("pheatmap", repos = "http://cran.us.r-project.org"))

suppressMessages(library("GEOquery"))

gset <- getGEO("GSE48558", GSEMatrix =TRUE, AnnotGPL=TRUE)
if (length(gset) > 1) idx <- grep("GPL6244", attr(gset, "names")) else idx <- 1
gset <- gset[[idx]]

saveRDS(gset, "data/GSE48558_series_matrix.Rds")