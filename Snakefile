rule all:
	input:
		upregulated_genes="results/upregulated.txt",
		downegulated_genes="results/downregulated.txt",
		pheatmap="results/pheatmap.pdf",
		boxplot="results/boxplot.pdf",
		pca="results/PCA_samples.pdf",
		gene_exprs_viz="results/gene_exprs.png"
		

rule download_geneExp:
	output:
		downloaded_data="data/GSE48558_series_matrix.Rds"
	script:
		"scripts/dataset.R"


rule pre_process:
	input:
		inp_data=rules.download_geneExp.output.downloaded_data
	output:
		clean_data="data/ExpressionSet.Rds"
	script:
		"scripts/pre_process.R"


rule visualization:
	input:
		viz_data=rules.pre_process.output.clean_data
	output:
		pheatmap="results/pheatmap.pdf",
		boxplot="results/boxplot.pdf",
		pca="results/PCA_samples.pdf"
	script:
		"scripts/viz.R"


rule diff_exprs_analysis:
	input:
		exprs_data=rules.pre_process.output.clean_data
	output:
		upregulated_genes="results/upregulated.txt",
		downegulated_genes="results/downregulated.txt"
	script:
		"scripts/diffExprs.R"


rule diff_exprs_violin:
	input:
		gene_exprs=rules.pre_process.output.clean_data,
		aml_up=rules.diff_exprs_analysis.output.upregulated_genes,
		aml_down=rules.diff_exprs_analysis.output.downegulated_genes
	output:
		gene_exprs_viz="results/gene_exprs.png"
	shell:
		"""
			#!/bin/bash

			read -p "Please enter the gene symbol: " gene
			Rscript scripts/viz_difExprs.R $gene {input.gene_exprs} {input.aml_up} {input.aml_down}

			exit 0
		"""
