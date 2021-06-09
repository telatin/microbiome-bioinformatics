---
layout: post
title:  "A primer on Dadaist2"
author: at
categories: [ metabarcoding, 16S, tutorial ]
image: assets/images/green-bact.jpg
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
* `-m` link to the metadata file (if not supplied a blank one will be generated and used)
  
## The output directory

Notable files:
* **rep-seqs.fasta** representative sequences (ASVs) in FASTA format
* **rep-seqs-tax.fasta** representative sequences (ASVs) in FASTA format, with taxonomy labels as comments
* **feature-table.tsv** table of raw counts (after cross-talk removal if specified)
* **taxonomy.tsv** a text file with the taxonomy of each ASV (used to add the labels to the _rep-seqs-tax.fasta_)
* copy of the **metadata.tsv** file

Subdirectories:
* **MicrobiomeAnalyst** a set of files formatted to be used with the online (also available offline as R package) software [MicrobiomeAnalyst](https://www.microbiomeanalyst.ca/MicrobiomeAnalyst/upload/OtuUploadView.xhtml).
* **Rhea** a directory with files to be used with the [Rhea pipeline](https://lagkouvardos.github.io/Rhea/), as well as some pre-calculated outputs (Normalization and Alpha diversity are done by default, as they don't require knowledge about metadata categories)
* **R** a directory with the PhyloSeq object
