#Installations if required:
#BiocManager::install("dada2")
#BiocManager::install("ShortRead")
#BiocManager::install("phyloseq")
#BiocManager::install("Biostrings")
#BiocManager::install(“vegan")
#BiocManager::install("ANCOMBC")
#BiocManager::install("microbiome")

#If ANCOMBC library load is bugged, run below: 
#pak::pkg_install("FrederickHuangLin/ANCOMBC@bugfix")


#For NetCoMi installation (note: requires R 4.6+):
#devtools::install_github("GraceYoon/SPRING")
#devtools::install_github("stefpeschel/NetCoMi", 
#repos = c("https://cloud.r-project.org/",
          #BiocManager::repositories()))


##Library Imports ----
library(phyloseq)
library(biomformat)
library(vegan)

library(ggplot2)
#library(dada2)
library(Biostrings)

library(ANCOMBC)
library(stringr)
library(NetCoMi)

# Omnivore Accessions
#Omn_1: SRR8146935 (Turin, italy)
#Omn_2: SRR8146936 (Turin, italy)
#Omn_3: SRR8146956 (Bari, Italy)

# Vegetarian Accessions
#Veg_1: SRR8146937 (Bari, Italy)
#Veg_2: SRR8146939 (Turin, italy)
#Veg_3: SRR8146940 (Turin, italy)


##Object preparation ----

# Read the BIOM files

omn_biom_data <- read_biom("omn_biom_table.biom")

veg_biom_data <- read_biom("veg_biom_table.biom")

all_biom_data <- read_biom("all_biom_table.biom")



# Build phyloseq object
omn_physeq <- import_biom(omn_biom_data)

# Verify
sample_names(omn_physeq)
taxa_names(omn_physeq)


#The same, but for vegetarian data
# Build phyloseq object
veg_physeq <- import_biom(veg_biom_data)

# Verify
sample_names(veg_physeq)
taxa_names(veg_physeq)


#The same, but for all data
# Build phyloseq object
all_physeq <- import_biom(all_biom_data)

# Verify
sample_names(all_physeq)
taxa_names(all_physeq)


#metadata table setup

samdf <- data.frame(sample_names=c("SRR8146935_bracken_species", "SRR8146936_bracken_species", "SRR8146956_bracken_species", "SRR8146937_bracken_species", "SRR8146939_bracken_species", "SRR8146940_bracken_species"), ID=c("Omn_1", "Omn_2", "Omn_3", "Veg_1", "Veg_2", "Veg_3"), Diet=c("Omn", "Omn", "Omn", "Veg", "Veg", "Veg"), City=c("Turin", "Turin", "Bari", "Bari", "Turin", "Turin"))

#need to explicitly set sample names as row names to merge with physeq object
rownames(samdf) <- samdf$sample_names
sample_data(all_physeq) <- samdf




#Assigning OTU tables and rarefacation curves for analysis
omn_otu_table <- as.data.frame(t(otu_table(omn_physeq)))
omn_rare_curve <- rarecurve(omn_otu_table, step = 1)

veg_otu_table <- as.data.frame(t(otu_table(veg_physeq)))
veg_rare_curve <- rarecurve(veg_otu_table, step = 1)

all_otu_table <- as.data.frame(t(otu_table(all_physeq)))
all_rare_curve <- rarecurve(all_otu_table, step = 1)


##Visualizing relative abundance: -----
omn_physeq_rel <- transform_sample_counts(omn_physeq, function(x) x / sum(x))

omn_physeq_phy <- tax_glom(omn_physeq_rel, taxrank = "Rank2")

df_omn <- psmelt(omn_physeq_phy)

ggplot(df_omn, aes(x = Sample, y = Abundance, fill = Rank2)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(y = "Relative Abundance", x = "Sample")

#As above, with Veg:
veg_physeq_rel <- transform_sample_counts(veg_physeq, function(x) x / sum(x))

veg_physeq_phy <- tax_glom(veg_physeq_rel, taxrank = "Rank2")

df_veg <- psmelt(veg_physeq_phy)

ggplot(df_veg, aes(x = Sample, y = Abundance, fill = Rank2)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(y = "Relative Abundance", x = "Sample")

#As above, with all:
all_physeq_rel <- transform_sample_counts(all_physeq, function(x) x / sum(x))

all_physeq_phy <- tax_glom(all_physeq_rel, taxrank = "Rank2")

df_all <- psmelt(all_physeq_phy)


ggplot(df_all, aes(x = ID, y = Abundance, fill = Rank2)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(y = "Relative Abundance", 
       x = "Sample") +
  facet_wrap(~Diet, scales="free_x")

ggplot(df_all, aes(x = ID, y = Abundance, fill = Rank2)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(y = "Relative Abundance", 
       x = "Sample") +
  facet_wrap(~City, scales="free_x")


#Other Phylogeny Comparisons -----
#Class
all_physeq_phy_cls <- tax_glom(all_physeq_rel, taxrank = "Rank3")

df_all_cls <- psmelt(all_physeq_phy_cls)

ggplot(df_all_cls, aes(x = ID, y = Abundance, fill = Rank3)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(y = "Relative Abundance", 
       x = "Sample") +
  facet_wrap(~Diet, scales="free_x")


#Order
all_physeq_phy_ord <- tax_glom(all_physeq_rel, taxrank = "Rank4")

df_all_ord <- psmelt(all_physeq_phy_ord)

ggplot(df_all_ord, aes(x = ID, y = Abundance, fill = Rank4)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(y = "Relative Abundance", 
       x = "Sample") +
  facet_wrap(~Diet, scales="free_x")


#Family
all_physeq_phy_fam <- tax_glom(all_physeq_rel, taxrank = "Rank5")

df_all_fam <- psmelt(all_physeq_phy_fam)

ggplot(df_all_fam, aes(x = ID, y = Abundance, fill = Rank5)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(y = "Relative Abundance", 
       x = "Sample") +
  facet_wrap(~Diet, scales="free_x")



##Alpha diversity----
#Quick plot richness check for diversity stats
plot_richness(omn_physeq)

plot_richness(veg_physeq)

plot_richness(all_physeq, x="Sample", color="Diet")
plot_richness(all_physeq, x="Sample", color="City")


#Beta Diversity ----
# Diet PCoA with bray-curtis
ord.pcoa.bray <- ordinate(all_physeq, method="PCoA", distance="bray")
plot_ordination(all_physeq, ord.pcoa.bray, color="Diet", title="Bray PCoA") + geom_point(size = 4)

# Diet NMDS with the same distance measure 
ord.nmds.bray <- ordinate(all_physeq, method="NMDS", distance="bray")
plot_ordination(all_physeq, ord.nmds.bray, color="Diet", title="Bray NMDS") + geom_point(size = 4)

# Diet Jaccard distance
ord.pcoa.jaccard <- ordinate(all_physeq, method="PCoA", distance="jaccard")
plot_ordination(all_physeq, ord.pcoa.jaccard, color="Diet", title="Jaccard PCOA") + geom_point(size = 4)

# Bray-curtis takes into account abundance, while Jaccard only cares about presence/absence. 
# What does it mean if they both do a good job of splitting the data?


# City PCoA with bray-curtis
ord.pcoa.bray <- ordinate(all_physeq, method="PCoA", distance="bray")
plot_ordination(all_physeq, ord.pcoa.bray, color="City", title="Bray PCoA") + geom_point(size = 4)

# City NMDS with the same distance measure 
ord.nmds.bray <- ordinate(all_physeq, method="NMDS", distance="bray")
plot_ordination(all_physeq, ord.nmds.bray, color="City", title="Bray NMDS") + geom_point(size = 4)

# City Jaccard distance
ord.pcoa.jaccard <- ordinate(all_physeq, method="PCoA", distance="jaccard")
plot_ordination(all_physeq, ord.pcoa.jaccard, color="City", title="Jaccard PCOA") + geom_point(size = 4)



#PERMANOVA analysis to determine significant factors
metadata <- as(sample_data(all_physeq), "data.frame")
adonis2(phyloseq::distance(all_physeq, method = "bray") ~ Diet,
        data = metadata)

metadata <- as(sample_data(all_physeq), "data.frame")
adonis2(phyloseq::distance(all_physeq, method = "bray") ~ City,
        data = metadata)


#Unfortunately, no significant results. Process shown below for completion
ancombc.out <- ancombc2(data = all_physeq, tax_level = "Rank2",
                        fix_formula = "City", rand_formula = NULL,
                        p_adj_method = "holm", pseudo_sens = TRUE,
                        prv_cut = 0, lib_cut = 0, s0_perc = 0.05,
                        group = "City", struc_zero = TRUE, neg_lb = TRUE)

ancombc.out$zero_ind
ancombc.out$res


ancombc.out_fam <- ancombc2(data = all_physeq, tax_level = "Rank5",
                        fix_formula = "City", rand_formula = NULL,
                        p_adj_method = "holm", pseudo_sens = TRUE,
                        prv_cut = 0, lib_cut = 0, s0_perc = 0.05,
                        group = "City", struc_zero = TRUE, neg_lb = TRUE)

ancombc.out_fam$zero_ind


ancombc.out_gen <- ancombc2(data = all_physeq, tax_level = "Rank6",
                           fix_formula = "City", rand_formula = NULL,
                           p_adj_method = "holm", pseudo_sens = TRUE,
                           prv_cut = 0, lib_cut = 0, s0_perc = 0.05,
                           group = "City", struc_zero = TRUE, neg_lb = TRUE)


ancombc.out_sp <- ancombc2(data = all_physeq, tax_level = "Rank7",
                            fix_formula = "City", rand_formula = NULL,
                            p_adj_method = "holm", pseudo_sens = TRUE,
                            prv_cut = 0, lib_cut = 0, s0_perc = 0.05,
                            group = "City", struc_zero = TRUE, neg_lb = TRUE)

#ancombc.out_sp$zero_ind
#ancombc.out_sp$res

ancombc.sig <- subset(ancombc.out$res, q_CityTurin < 0.15)
ancombc.sig

ancombc.sig_fam <- subset(ancombc.out_fam$res, q_CityTurin < 0.15)
ancombc.sig_fam

ancombc.sig_gen <- subset(ancombc.out_gen$res, q_CityTurin < 0.15)
ancombc.sig_gen

ancombc.sig_sp <- subset(ancombc.out_sp$res, q_CityTurin < 0.15)
ancombc.sig_sp


ggplot(ancombc.out$res, aes(x = lfc_CityTurin, y = reorder(taxon, lfc_CityTurin))) +
  geom_point(aes(color = q_CityTurin  < 0.15), size = 3) +
  geom_errorbar(aes(xmin = lfc_CityTurin - se_CityTurin , 
                    xmax = lfc_CityTurin + se_CityTurin )) +
  geom_vline(xintercept = 0, color = "red") +
  labs(x = "Log Fold Change (City of Turin)", 
       y = "Phylum")

ggplot(ancombc.out_gen$res, aes(x = lfc_CityTurin, y = reorder(taxon, lfc_CityTurin))) +
  geom_point(aes(color = q_CityTurin  < 0.15), size = 3) +
  geom_errorbar(aes(xmin = lfc_CityTurin - se_CityTurin , 
                    xmax = lfc_CityTurin + se_CityTurin )) +
  geom_vline(xintercept = 0, color = "red") +
  labs(x = "Log Fold Change (City of Turin)", 
       y = "Genus")

#The same, but for diet
ancombc.out_diet <- ancombc2(data = all_physeq, tax_level = "Rank2",
                        fix_formula = "Diet", rand_formula = NULL,
                        p_adj_method = "holm", pseudo_sens = TRUE,
                        prv_cut = 0, lib_cut = 0, s0_perc = 0.05,
                        group = "Diet", struc_zero = TRUE, neg_lb = TRUE)
ancombc.out_diet$res


ancombc.out_diet_gen <- ancombc2(data = all_physeq, tax_level = "Rank6",
                             fix_formula = "Diet", rand_formula = NULL,
                             p_adj_method = "holm", pseudo_sens = TRUE,
                             prv_cut = 0, lib_cut = 0, s0_perc = 0.05,
                             group = "Diet", struc_zero = TRUE, neg_lb = TRUE)
ancombc.out_diet_gen$res

ggplot(ancombc.out_diet$res, aes(x = lfc_DietVeg, y = reorder(taxon, lfc_DietVeg))) +
  geom_point(aes(color = q_DietVeg  < 0.50), size = 3) +
  geom_errorbar(aes(xmin = lfc_DietVeg - se_DietVeg , 
                    xmax = lfc_DietVeg + se_DietVeg )) +
  geom_vline(xintercept = 0, color = "red") +
  labs(x = "Log Fold Change (Vegetarian Diet)", 
       y = "Phylum")

ggplot(ancombc.out_diet_gen$res, aes(x = lfc_DietVeg, y = reorder(taxon, lfc_DietVeg))) +
  geom_point(aes(color = q_DietVeg  < 0.50), size = 3) +
  geom_errorbar(aes(xmin = lfc_DietVeg - se_DietVeg , 
                    xmax = lfc_DietVeg + se_DietVeg )) +
  geom_vline(xintercept = 0, color = "red") +
  labs(x = "Log Fold Change (Vegetarian Diet)", 
       y = "Genus")


#Network Analysis
#NOTE: Unfortunately, 6 samples is not enough for a robust association of 50+ genus. Code included below for illustration purposes.
# Agglomerate to genus level
ps_genus <- tax_glom(all_physeq, taxrank = "Rank6")

# Rename taxa and make Genus names unique
ps_genus_renamed <- renameTaxa(
  ps_genus, 
  pat = "<name>", 
  substPat = "<name>_<subst_name>(<subst_R>)", 
  numDupli = "Rank6"
)

# Construct network from phyloseq object

net <- netConstruct(data = ps_genus_renamed, 
                    taxRank = "Rank6", 
                    measure = "pearson", 
                    filtTax = "highestFreq", 
                    filtTaxPar = list(highestFreq = 50))

net_analysed <- netAnalyze(net)

# Plot
plot(net_analysed)

