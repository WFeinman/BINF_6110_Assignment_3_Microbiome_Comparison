
## Introduction:

Microbiomes describe populations of multiple species of microorganisms living in the same environment, their genomes, and how they interact with each other. Said interactions are incredibly complex nested affairs with multiple co-operating/competing species, metabolite exchanges, and bio-film layering dynamics. On top of ecological considerations, these communities can have a dramatic impact on human health. Gut microbiomes in particular, with their role in digestion and dysbiosis leading to a wide variety of adverse health outcomes, are crucially important to understand. (Conlon & Bird, 2014) (Hills et al., 2019) (Vishwakarma Bhanupratap Harishchandra, 2024)

Shotgun metagenomics represent a potent avenue to do so, allowing a broad overview of the biome of interest. Traditional methods such as meta-barcoding have focused on identifying specific genetic amplicons to efficiently identify species, such as 16s PCR. This focus on amplicons allows useful population data from a small amount of recorded genetic information, albeit with with a   Shotgun metagenomics, on the other hand, instead sequences all DNA present within a sample, fragmenting it and reconstructing genetic material based on pre-existing reference genomes.  (De Filippis et al., 2019)

This presents a number of advantages and tradeoffs. Compared to metabarcoding, shotgun metagenomics is expensive (both computationally and fiscally), but gives a much more involved view of the dynamics at play, allowing functional gene profiles to be gleaned directly from the data supplied. With this, differences in metabolite production or species phenotype can be associated with and tied to identifiable differences in the samples genomic profiles, rather than having to be solely inferred from prior knowledge on taxa trends. Additionally, it helps avoid primer bias from PCR-centric approaches. (Quince et al., 2017)

Raw data from these mechanisms, however, must be analyzed. To do so, several metrics are of use
Alpha diversity is a measure of the diversity that exists within a local environment. Beta diversity compares the ratio of a local environment's diversity to that of the wider region. Comparative abundance works directly with taxa of note to draw parallels to subjects of interest, while care must be taken to ensure connections are not spurious or false positives. (Tuomisto, 2010)

In this paper, we'll be examining an example metagenomics dataset from human gut microbiota in Italy, as an illustrative example of how metagenomic techniques can be applied to investigate the impact of diet and geographic separation on gut microbiomes. A variety of methods will be used and examined, to show what conclusions can be inferred even from limited data, and what techniques require a large dedicated dataset to confirm those conclusions with statistical confidence. (De Filippis et al., 2019)


## Methods:

Six gut microbiome metagenomic fastq files were selected for this project, representing 3 humans with omnivorous diets and 3 humans with vegetarian diets. (De Filippis et al., 2019)

Using bash, Fastq files containing shotgun metagenomic data of human gut microbiome data are downloaded with the fasterq download tool. A fastqc quality control check is performed to ensure read fidelity. As these fastq files consist of short 150bp sequences, megahit genome assembly is performed to collect raw reads into longer coherent sequences. Once assembled, the kraken2 taxonomic classifier is used to determine which species are present in which samples. Bracken is then used to quantify said species' abundance, feeding the results into a .biom table for each metagenomic sample, then combining those tables for easier downstream analysis.

Switching to R, the collected biom tables are first read in. Using phyloseq, a physeq object is generated for each table, enabling package interactions. A rarefaction curve is generated with vegan to ensure the samples are properly loaded and populated with species. Sample metadata is loaded and merged with their corresponding entries in the physeq objects. Taxa of the same type are grouped together, and their relative taxa abundance across dietary groups and city of sample origin was compared with ggplot.

Alpha diversity within each sample was plotted, and compared to both diet and city. A wide array of alpha diversity measures were used, to identify potential metrics to distinguish population groups via internal diversity.

Beta diversity was plotted using Bray and Jaccard distances, combined with PCOA and NMDS. Similarly, these are used to identify potential metrics for distinguishing populations groups via external factors, such as principal components commonly shared by members of one group, but not the other.

ANCOMBC-2 analysis was conducted as a conservative test of whether the correlations identified could be said to match a significant trend, or whether they could be sufficiently explained by expected false-positive rates (q) from the data size. It should be noted that in order to run effectively on a single computer in the shell-scripting portion of the code, sample size was restricted to 6 metagenomes. As such, individual observations are unlikely to reach the traditional significance threshold of q = 0.05,. Trends identified, then, should be taken as potential avenues fore more intensive study, rather than definitive correlation.

Finally, a network analysis using NetCoMi is plotted to visually represent taxonomic clusters in the data group in the form of commonly co-occurring genus. Once again, the small illustrative sample size should be noted as caution against definitive correlation, especially due to the high number of genus relative to the dataset.



## Results:
Rarefaction Curves:
![[Pasted image 20260821060434.png]]**Figure 1:** Rarefaction curve for omnivore samples.
![[Pasted image 20260821060534.png]]
**Figure 2:** Rarefaction curve for vegetarian samples.

![[Pasted image 20260821060740.png]]
**Figure 3:** Relative phylum abundance comparing samples based on dietary groups.

![[Pasted image 20260821061001.png]]
**Figure 4:** Relative phylum abundance comparing samples based on city of origin. Note that elevated presence of Pseudomonadota and the absence of Verrucomicrobiota distinguishedBari groups, while the inverse distinguished the Turin group.

![[Pasted image 20260821062320.png]]
**Figure 5:** Alpha diversity metrics, grouping by diet. Note that Shannon diversity was the only marker to cleanly distinguish the two groups, with vegetarians displaying a slightly, but clearly, elevated diversity metric omnivores.


![[Pasted image 20260821062407.png]]
**Figure 6:** Alpha diversity metrics, grouping by city.

![[Pasted image 20260821063335.png]]
**Figure 7:** Beta diversity metric: Bray distance using PCOA, comparing diet groups.
![[Pasted image 20260821063517.png]]
**Figure 8:** Beta diversity metric. Jaccard distance using PCOA, comparing cities.

![[Pasted image 20260821065509.png]]
![[Pasted image 20260821065525.png]]
**Figures 9 and 10:** ANCOMBC-2 analysis characterrizing significance (or lack thereof) of taxa associations. Note that a q chance exceeding 0.5 indicates false discovery is very likely. Also note that PERMANOVA is a conservative estimator.

![[Pasted image 20260821073612.png]]
![[Pasted image 20260821073626.png]]
**Figures 11 and 12:** ANCOMBC-2 analysis characterizing significance of taxa association with ciy. Note that the Pseudomonadota phylum possesses a near-significant negative correlation with Turin, though the small sample size does not allow it to cross the traditional threshold of significance of q<0.05.


![[Pasted image 20260821074555.png]]
**Figure 13:** NetCoMi association network analysis of the top 50 co-occurring genus. For illustrative purposes, as small sample size relative to genus count cautions against drawing confident correlations.



## Discussion:

As a side note, the importance of sample quality control was emphasized during the preparation of this bioinformatic work flow, as one candidate fastq file (SRR8146938) was almost entirely composed of viral genetic material, rather than bacterial as intended during collection.

The Shannon alpha diversity index indicates that vegetarian microbiomes are consistently more diverse than their omnivorous counterparts, and exhibit a more even population distribution among their taxa. This may support the original study, which suggests fiber rich diets select for bacterial strains with a stronger potential for complex carbohydrate degradation, encouraging a diverse population. (De Filippis et al., 2019)

The phylum Pseudomonadota proved the single most confident geographic identifier in this dataset, clearly identifiable in the differential abundance comparison. Pseudomonadota is a highly complex and well-populated group, associated with both benign and pathogenic health outcomes. Prior research indicates roughly half of sequenced Pseudomonadota genes identified in a set of 1473 oral metagenomes were unique to each metagenome. In addition to the internal complexity of the gut microbiome, it also interacts with other microbiomes. Pseudomonadota's main pathway to the gut is likely oral-fecal transmission, passing through both the oral microbiome and many external environments in the interim. (Deo & Deshmukh, 2019) (Leão et al., 2023) (Singh et al., 2017) (Zhang et al., 2018)


As such, while their difference in presence between geographic locations can be confirmed with relative confidence, the impact of that difference on health from this sample set cannot. Pseudomonadota's presence in this sample set also illustrates a catch when attempting small scale metagenomics: Due to the diverse nature of bacteria, observations from a small scale dataset on broad factors such as phylum have less explicative power by virtue of the variety contained within a given phylum. However, attempting to ascertain further details from species level distinctions run into scaling problems *because* of the species variety, as increased species variety necessitates more metagenome samples in order to draw statistically relevant conclusions. Which, in turn, carries the chance of including yet more species in the dataset, increasing the statistical load. It is by no means an indefinite positive feedback loop, but care needs to be taken in experimental design. (Quince et al., 2017)

Overall, shotgun metagenomics has a wealth of potential avenues of investigation, tempered by the logistic and computational complexity of conducting it. There are an almost infinite number of potential factors to meaningfully investigate, and link to functional genomic data, tempered by the increasing sample and processing workload testing those factors requires.


## Research References:


Conlon, M., & Bird, A. (2014). The Impact of Diet and Lifestyle on Gut Microbiota and Human Health. _Nutrients_, _7_(1), 17–44. [https://doi.org/10.3390/nu7010017](https://doi.org/10.3390/nu7010017)

De Filippis, F., Pasolli, E., Tett, A., Tarallo, S., Naccarati, A., De Angelis, M., Neviani, E., Cocolin, L., Gobbetti, M., Segata, N., & Ercolini, D. (2019). Distinct Genetic and Functional Traits of Human Intestinal Prevotella copri Strains Are Associated with Different Habitual Diets. _Cell Host & Microbe_, _25_(3), 444-453.e3. [https://doi.org/10.1016/j.chom.2019.01.004](https://doi.org/10.1016/j.chom.2019.01.004)

Deo, P., & Deshmukh, R. (2019). Oral microbiome: Unveiling the fundamentals. _Journal of Oral and Maxillofacial Pathology_, _23_(1), 122. [https://doi.org/10.4103/jomfp.JOMFP_304_18](https://doi.org/10.4103/jomfp.JOMFP_304_18)

Hills, R., Pontefract, B., Mishcon, H., Black, C., Sutton, S., & Theberge, C. (2019). Gut Microbiome: Profound Implications for Diet and Disease. _Nutrients_, _11_(7), 1613. [https://doi.org/10.3390/nu11071613](https://doi.org/10.3390/nu11071613)

Leão, I., De Carvalho, T. B., Henriques, V., Ferreira, C., Sampaio-Maia, B., & Manaia, C. M. (2023). Pseudomonadota in the oral cavity: A glimpse into the environment-human nexus. _Applied Microbiology and Biotechnology_, _107_(2–3), 517–534. [https://doi.org/10.1007/s00253-022-12333-y](https://doi.org/10.1007/s00253-022-12333-y)

Quince, C., Walker, A. W., Simpson, J. T., Loman, N. J., & Segata, N. (2017). Shotgun metagenomics, from sampling to analysis. _Nature Biotechnology_, _35_(9), 833–844. [https://doi.org/10.1038/nbt.3935](https://doi.org/10.1038/nbt.3935)

Singh, R. K., Chang, H.-W., Yan, D., Lee, K. M., Ucmak, D., Wong, K., Abrouk, M., Farahnik, B., Nakamura, M., Zhu, T. H., Bhutani, T., & Liao, W. (2017). Influence of diet on the gut microbiome and implications for human health. _Journal of Translational Medicine_, _15_(1), 73. [https://doi.org/10.1186/s12967-017-1175-y](https://doi.org/10.1186/s12967-017-1175-y)

Tuomisto, H. (2010). A diversity of beta diversities: Straightening up a concept gone awry. Part 1. Defining beta diversity as a function of alpha and gamma diversity. _Ecography_, _33_(1), 2–22. [https://doi.org/10.1111/j.1600-0587.2009.05880.x](https://doi.org/10.1111/j.1600-0587.2009.05880.x)

Vishwakarma Bhanupratap Harishchandra. (2024). _The Gut Microbiome: A Comprehensive Review of Its Role in Human Health and Disease_. [https://doi.org/10.13140/RG.2.2.11888.88329](https://doi.org/10.13140/RG.2.2.11888.88329)

Zhang, Y., Wang, X., Li, H., Ni, C., Du, Z., & Yan, F. (2018). Human oral microbiota and its modulation for oral health. _Biomedicine & Pharmacotherapy_, _99_, 883–893. [https://doi.org/10.1016/j.biopha.2018.01.146](https://doi.org/10.1016/j.biopha.2018.01.146)


## Package Versions and References:

**Bash:**
fasterq-dump : 3.0.3
MEGAHIT v1.2.9
Kraken version 2.17.1
Bracken v3.0.1

SRA Toolkit. NCBI. https://github.com/ncbi/sra-tools

Li, D., Liu, C-M., Luo, R., Sadakane, K., and Lam, T-W., (2015) MEGAHIT: An ultra-fast single-node solution for large and complex metagenomics assembly via succinct de Bruijn graph. Bioinformatics, doi: 10.1093/bioinformatics/btv033 [PMID: 25609793].

Li, D., Luo, R., Liu, C.M., Leung, C.M., Ting, H.F., Sadakane, K., Yamashita, H. and Lam, T.W., 2016. MEGAHIT v1.0: A Fast and Scalable Metagenome Assembler driven by Advanced Methodologies and Community Practices. Methods.

Wood, D. E., Lu, J., & Langmead, B. (2019). Improved metagenomic analysis with Kraken 2. _Genome Biology_, _20_(1), 257. [https://doi.org/10.1186/s13059-019-1891-0](https://doi.org/10.1186/s13059-019-1891-0)

Lu, J., Breitwieser, F. P., Thielen, P., & Salzberg, S. L. (2017). Bracken: Estimating species abundance in metagenomics data. _PeerJ Computer Science_, _3_, e104. [https://doi.org/10.7717/peerj-cs.104](https://doi.org/10.7717/peerj-cs.104)


**R:**
R-4.6.1
phyloseq: 1.56.0
biomformat: 1.40.0
vegan: 2.7-5
ggplot2: 4.0.3
Biostrings: 2.80.1
ANCOMBC: 2.14.0
stringr: 1.6.0
NetCoMi: 1.3.0

 R Core Team (2025). _R: A Language and Environment for Statistical Computing_. R Foundation for Statistical Computing, Vienna, Austria. <https://www.R-project.org/>.
 
McMurdie and Holmes (2013) phyloseq: [An R Package for Reproducible Interactive Analysis and Graphics of Microbiome Census Data](http://dx.plos.org/10.1371/journal.pone.0061217). PLoS ONE. 8(4):e61217

McMurdie P, Paulson J (2026). _biomformat: An interface package for the BIOM file format_. [doi:10.18129/B9.bioc.biomformat](https://doi.org/10.18129/B9.bioc.biomformat). R package version 1.40.0, [https://bioconductor.org/packages/biomformat](https://bioconductor.org/packages/biomformat).

Oksanen J, Simpson G, Blanchet F, Kindt R, Legendre P, Minchin P, O'Hara R, Solymos P, Stevens M, Szoecs E, Wagner H, Bedward M, Bolker B, Borcard D, Carvalho G, De Caceres M, Durand S, Evangelista H, Hannigan G, Hill M, Lahti L, Martino C, Ouellette M, Ribeiro Cunha E, Smith T, Stier A, Ter Braak C, Weedon J (2026). _vegan: Community Ecology Package_. R package version 2.8-0, [https://vegandevs.github.io/vegan/](https://vegandevs.github.io/vegan/).

Wickham H (2016). _ggplot2: Elegant Graphics for Data Analysis_. Springer-Verlag New York. ISBN 978-3-319-24277-4. [https://ggplot2.tidyverse.org](https://ggplot2.tidyverse.org).

Pagès H, Aboyoun P, Gentleman R, DebRoy S (2026). _Biostrings: Efficient manipulation of biological strings_. R package version 2.81.6, [https://bioconductor.org/packages/Biostrings](https://bioconductor.org/packages/Biostrings).

Lin H, Peddada SD (2020). “Analysis of compositions of microbiomes with bias correction.” _Nature Communications_, **11**(1), 1-11. [https://www.nature.com/articles/s41467-020-17041-7](https://www.nature.com/articles/s41467-020-17041-7).

Lin H, Eggesbo M, Peddada SD (2022). “Linear and nonlinear correlation estimators unveil undescribed taxa interactions in microbiome data.” _Nature Communications_, **13**(1), 1-16. [https://www.nature.com/articles/s41467-022-32243-x](https://www.nature.com/articles/s41467-022-32243-x).

Lin H, Peddada SD (2024). “Multigroup analysis of compositions of microbiomes with covariate adjustments and repeated measures.” _Nature Methods_, **21**(1), 83-91. [https://www.nature.com/articles/s41592-023-02092-7](https://www.nature.com/articles/s41592-023-02092-7).

Wickham H (2025). _stringr: Simple, Consistent Wrappers for Common String Operations_. R package version 1.6.0, [https://stringr.tidyverse.org](https://stringr.tidyverse.org).

Stefanie Peschel, (2025). NetCoMi: Network Construction and Comparison for Microbiome Data. R package version 1.2.0. https://netcomi.de

