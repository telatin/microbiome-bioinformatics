---
layout: post
title:  "De novo assembly of viromes"
author: at
categories: [ virome, tutorial, tools ]
image: assets/images/virome.jpg
hidden: true
---

To identify putative viral sequences without using a classifier, we can use a de novo assembly approach.
We first need to perform a standard metagenome assembly, then we need to process the contigs using a viral miner,
a tool aiming at identifying viral sequences in the assembly.

## Assembly

[MegaHit](https://pubmed.ncbi.nlm.nih.gov/25609793/) is a fast assembler that also handle metagenomic datasets.
We can install it with conda, even in a dedicated environment such as:

```bash
mamba create -n denovo -c conda-forge -c bioconda --yes megahit seqfu quast
```

To assemble a single dataset, the command is like:


```bash
# Using 16 cores
megahit -1 reads_1.fastq.gz -2 reads_2.fastq.gz -o assembly -t 16
```
To assemble a set of paired-end reads we can use a bash loop,
where we iterate over the forward reads and we will infer the name of the reverse reads:

```bash
# Modify this script according to your needs
FWD_TAG="_1.fq.gz"   # Suffix specific to R1 reads
REV_TAG="_2.fq.gz"   # Suffix specific to R2 reads
READS=/path/to/reads # Path to reads, READS=$VIR/dataset  (For EBAME7)
mkdir -p assembly    # Where to save the output
for R1 in $READS/*${FWD_TAG};
do
   R2=${R1/$FWD_TAG/$REV_TAG}             # Infer file R2
   SAMPLE=$(basename ${R1/$FWD_TAG/})     # Extract sample name
   echo Processing $SAMPLE
   megahit -1 $R1 -2 $R2 -o assembly/$SAMPLE -t 16
done
```

## Assembly metrics

You can quickly gather an overview of your assemblies using [SeqFu stats](https://telatin.github.io/seqfu2/tools/stats.html):

```bash
seqfu stats -n -t assembly/*/final.contigs.fa
```

Or you can use [Quast](http://bioinf.spbau.ru/metaquast) to get a more detailed report.


## Viral mining

There are several tools that can be used to identify viral sequences in a metagenomic assembly. In this tutorial we focus on 
two tools:
[VirSorter2](https://github.com/jiarong/VirSorter2), a complete pipeline, and
[VirFinder](https://github.com/jessieren/VirFinder), an R package.

### VirSorter 2 (EBAME)

```bash
cd 
cp -r $VIR/virsorter2/ .
virsorter run -w $OUT -d ~/virsorter2/ -i $CONTIGS -j 16
```

where:
* `-w OUTPUT_DIR` is the output directory path
* `-d PATH_DB` is the path to the VirSorter2 database and environments
* `-i CONTIGS_FASTA` is the fasta file produced by the assembler
* `-j THREADS` is the number of jobs to run in parallel

### (parallel) VirFinder

We can install a [parallelised version](https://github.com/quadram-institute-bioscience/parallel-virfinder) of 
[VirFinder](https://github.com/jessieren/VirFinder) using conda:

```bash
mamba install -c bioconda -c conda-forge parallel-virfinder
```

to use it:
```bash
parallel-virfinder.py -i CONTIGS -o OUTPUT -f FASTA_OUTPUT -n 16  -s MIN_SCORE -p MAX_P_VALUE
```

MIN_SCORE and MAX_P_VALUE are supplied with defaults values, but you can change them if you want.

* `-i CONTIGS` is the fasta file produced by the assembler (input)
* `-f OUTPUT` is the set of viral contigs (output)
* `-o OUTPUT` is the tabular output 
  
---

## The programme

* :zero: [EBAME-22 notes]({{ site.baseurl }}{% link _posts/2022-02-02-virome-ebame.md %}): EBAME-7 specific notes
* :one: [Gathering the reads]({{ site.baseurl }}{% link _posts/2022-02-10-virome-reads.md %}):
  downloading and subsampling reads from public repositories (optional)
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-02-11-virome-tools.md %}):
  we will use Miniconda to manage our dependencies
* :three: [Reads by reads profiling]({{ site.baseurl }}{% link _posts/2022-02-12-virome-phanta.md %}):
  using Phanta to quickly profile the bacterial and viral components of a microbial community
* :four:  [_De novo_ mining]({{ site.baseurl }}{% link _posts/2022-02-13-virome-denovo.md %}):
  assembly based approach, using VirSorter as an example miner
* :five:  [Viral taxonomy]({{ site.baseurl }}{% link _posts/2022-02-14-virome-taxonomy.md %}):
  *ab initio* taxonomy profiling using vConTACT2
* :six:  [MetaPhage overview]({{ site.baseurl }}{% link _posts/2022-02-15-virome-metaphage.md %}):
  what is MetaPhage, a reads to report pipeline for viral metagenomics

:arrow_left: [Back to the main page]({{ site.baseurl }}{% link _posts/2022-02-01-Virome.md %})
