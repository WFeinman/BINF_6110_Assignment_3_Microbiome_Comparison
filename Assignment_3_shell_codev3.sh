#!/bin/bash

#Files being accessed are quite large (roughly 30Gb per Accession number), and the script has difficulties downloading them automatically. As such, download commands commented out, manually copy them over to bash console if needed.
#Fastq tile downloads:
# Omnivore Accessions
#fasterq-dump SRR8146935
#fasterq-dump SRR8146936
#fasterq-dump SRR8146956

# Vegeterian Accessions
#fasterq-dump SRR8146937
#fasterq-dump SRR8146939
#fasterq-dump SRR8146940

#kraken database used (~8 Gb)
#wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08_GB_20251015.tar.gz
tar -xvf k2_standard_08_GB_20251015.tar.gz



#Genome assembly with Megahit (paired short read inputs):
# Template: megahit -1 pe_1.fq -2 pe_2.fq -o out

megahit -1 SRR8146935_1.fastq -2 SRR8146935_2.fastq -o SRR8146935_megahit_out
megahit -1 SRR8146936_1.fastq -2 SRR8146936_2.fastq -o SRR8146936_megahit_out
megahit -1 SRR8146956_1.fastq -2 SRR8146956_2.fastq -o SRR8146956_megahit_out

megahit -1 SRR8146937_1.fastq -2 SRR8146937_2.fastq -o SRR8146937_megahit_out
megahit -1 SRR8146939_1.fastq -2 SRR8146939_2.fastq -o SRR8146939_megahit_out
megahit -1 SRR8146940_1.fastq -2 SRR8146940_2.fastq -o SRR8146940_megahit_out
  




#template kraken2 commands from instruction + github
##kraken2 --paired --classified-out cseqs#.fq seqs_1.fq seqs_2.fq
##kraken2 --db . --confidence 0.15 --memory-mapping --threads 32 --output stool_sample.kraken --report stool_sample.report stool_sample.fastq.gz


kraken2 --db . --confidence 0.15 --memory-mapping --threads 24 --output SRR8146935.kraken --report SRR8146935.report SRR8146935_megahit_out/final.contigs.fa
kraken2 --db . --confidence 0.15 --memory-mapping --threads 24 --output SRR8146936.kraken --report SRR8146936.report SRR8146936_megahit_out/final.contigs.fa
kraken2 --db . --confidence 0.15 --memory-mapping --threads 24 --output SRR8146956.kraken --report SRR8146956.report SRR8146956_megahit_out/final.contigs.fa

kraken2 --db . --confidence 0.15 --memory-mapping --threads 24 --output SRR8146937.kraken --report SRR8146937.report SRR8146937_megahit_out/final.contigs.fa
kraken2 --db . --confidence 0.15 --memory-mapping --threads 24 --output SRR8146939.kraken --report SRR8146939.report SRR8146939_megahit_out/final.contigs.fa
kraken2 --db . --confidence 0.15 --memory-mapping --threads 24 --output SRR8146940.kraken --report SRR8146940.report SRR8146940_megahit_out/final.contigs.fa



#template bracken code from instruction
#bracken -d . -i stool_sample.report -o stool_sample.bracken

bracken -d . -i SRR8146935.report -o SRR8146935.bracken -t 0
bracken -d . -i SRR8146936.report -o SRR8146936.bracken -t 0
bracken -d . -i SRR8146956.report -o SRR8146956.bracken -t 0

bracken -d . -i SRR8146937.report -o SRR8146937.bracken -t 0
bracken -d . -i SRR8146939.report -o SRR8146939.bracken -t 0
bracken -d . -i SRR8146940.report -o SRR8146940.bracken -t 0


#template biom code from instruction
#kraken-biom stool_sample_bracken_species.report
#json format used to work with phyloseq R package downstream.

kraken-biom SRR8146935_bracken_species.report -o SRR8146935_biom_table.biom --fmt json
kraken-biom SRR8146936_bracken_species.report -o SRR8146936_biom_table.biom --fmt json
kraken-biom SRR8146956_bracken_species.report -o SRR8146956_biom_table.biom --fmt json

kraken-biom SRR8146937_bracken_species.report -o SRR8146937_biom_table.biom --fmt json
kraken-biom SRR8146939_bracken_species.report -o SRR8146939_biom_table.biom --fmt json
kraken-biom SRR8146940_bracken_species.report -o SRR8146940_biom_table.biom --fmt json


kraken-biom SRR8146935_bracken_species.report SRR8146936_bracken_species.report SRR8146956_bracken_species.report \
 -o omn_biom_table.biom --fmt json
 
kraken-biom SRR8146937_bracken_species.report SRR8146939_bracken_species.report SRR8146940_bracken_species.report \
 -o veg_biom_table.biom --fmt json
 
kraken-biom SRR8146937_bracken_species.report SRR8146939_bracken_species.report SRR8146940_bracken_species.report \
 SRR8146935_bracken_species.report SRR8146936_bracken_species.report SRR8146956_bracken_species.report \
 -o all_biom_table.biom --fmt json
