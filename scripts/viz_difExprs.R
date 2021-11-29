suppressMessages(library("rtracklayer"))
suppressMessages(library("tidyverse"))
suppressMessages(library("Biobase"))

exprs.viz <- function(gene, gxprs_file, amlUp_file, amlDown_file){
  gset <- readRDS(gxprs_file)
  aml.up <- as.list(read.table(amlUp_file))
  aml.down <- as.list(read.table(amlDown_file))
  
  regulated <- append(aml.up[[1]], aml.down[[1]])
  
  gene.symbl <- as.list(fData(gset)$`Gene symbol`)
  exprs.data <- as_tibble(exprs(gset))
  
  if(!any(regulated == gene))
    stop("The input gene has not either down or up regulated!")
  else{
    
    idx <- which(gene.symbl == gene)
    pre.gex <- t(as.matrix(exprs.data[idx,]))
    gex <- tibble("exprs"=pre.gex[,1])
    pht <- tibble("phenotype"=gset$description)
    gdata <- tibble(gex, pht)
    
    plot <- gdata %>%
      ggplot(aes(x=phenotype, y=exprs, fill=phenotype)) +
      geom_violin(trim = FALSE) +
      geom_boxplot(width=0.1, fill="white") +
      #scale_fill_brewer(palette="RdBu") +
      labs(title=paste("plot of gene:", gene),x="phenotype", y = "gene expression") +
      ylab("gene expression") +
      theme_bw()
    pdf(NULL)
    ggsave("results/gene_exprs.png", width = 7, height = 7)
    return(plot)
  }
}

func.args <- commandArgs(trailingOnly = TRUE)
exprs.viz(func.args[1], func.args[2], func.args[3], func.args[4])