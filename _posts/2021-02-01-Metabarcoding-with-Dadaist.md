---
layout: post
title:  "A primer on Dadaist2"
author: at
categories: [ metabarcoding, 16S, tutorial ]
---

## What is Dadaist2

[**Dadaist2**](https://github.com/quadram-institute-bioscience/dadaist2) is a pipeline built around DADA2, 
optimized to streamline the workflow from the raw reads to R.

It's both a _monolithic_ pipeline (one command to perform the whole analysis) and a set of 
[tools](https://quadram-institute-bioscience.github.io/dadaist2/pages/).

## Installing Dadaist2

The easiest way is currently using _mamba_ (conda is too slow for this):
```
mamba create -n dadaist -c conda-forge -c bioconda dadaist2
```

## Getting one reference database

A dedicated tool, [dadaist2-getdb](https://quadram-institute-bioscience.github.io/dadaist2/pages/dadaist2-getdb.html)
is used to download reference databases. 

A list of the available databases is obtainable via `dadaist2-getdb --list`.

For this example we will download Silva and store it in our home directory:
```
dadaist2-getdb -d decipher-silva-138 -o ~/refs/
```

## Running the pipeline with default parameters

To have a first feeling of the workflow we can run the pipeline with:
```
dadaist2 -i reads/ -o dadaist-output -t 12 -d ~/ref/SILVA_SSU_r138_2019.RData
```

where:
* `-i` is the input directory with paired end reads, identified with R1 and R2 (can be changed)
* `-o` is the output directory (will be created)
* `-t` is the number of computing cores
* `-d` is the reference database to use

This will produce a directory with this structure:
```
dadaist-output/
├── MicrobiomeAnalyst                <--- all files for Microbiome Analyst
│   ├── metadata.csv
│   ├── rep-seqs.tree
│   ├── seqs.fa
│   ├── table.csv
│   └── taxonomy.csv
├── R
│   └── phyloseq.rds                 <--- PhyloSeq object
├── Rhea
│   ├── OTUs-Seqs.fasta
│   ├── OTUs-Table.tab
│   ├── OTUs-Tree.tre
│   ├── OTUs_Table-norm-rel-tax.tab
│   ├── OTUs_Table-norm-rel.tab
│   ├── OTUs_Table-norm-tax.tab
│   ├── OTUs_Table-norm.tab
│   ├── RarefactionCurve.pdf
│   ├── RarefactionCurve.tab
│   ├── alpha-diversity.tab
│   └── mapping_file.tab
├── dada2_raw.tsv                   
├── dada2_stats.tsv
├── dadaist.log
├── dadaist2.html
├── feature-table.tsv              <--- feature table
├── metadata.tsv
├── qc
│   ├── F3D0.json
|   |   ....
│   ├── quality_R1.pdf
│   └── quality_R2.pdf
├── rep-seqs-tax.fasta            <--- ASV with taxonomy
├── rep-seqs.fasta
├── rep-seqs.msa
├── rep-seqs.tree
└── taxonomy.txt
```