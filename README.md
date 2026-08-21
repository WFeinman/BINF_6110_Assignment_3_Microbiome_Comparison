# BINF_6110_Assignment_3_Microbiome_Comparison
Comparison of omnivore and vegetarian human microbiomes. This project consists of 3 main parts, a shell script, an r script, and a written report.


**Shell Script:** Under "Assignment_3_shell_codev3.sh". This will download 6 fastq files, assemble them, and eventually convert them into a set of biom tables. The script is very computationally intensive by necessity of large file sizes, and would take hours to days to run on a single machine. As such, the end products have been uploaded as "all_biom_table.biom", "omn_biom_table.biom", and "veg_biom_table.biom", for use in the R script.



**R Script:** Under "BINF_6110_Assignment_3_R_Code_v4.R". This will analyze the supplied biom tables for alpha diversity, beta diversity, taxonomic diversity, and differential abundance, plotting results. The resultant figures are included in the written report.



**Written Report:** Under "6110 Assignment 3 - Shotgun Metagenomics Exploration.md".
