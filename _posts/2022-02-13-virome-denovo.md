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

:bulb: Choose a single sample and assemble it with MegaHIT. 


For the records, we write here a prototype of script with a loop to assemble a set of paired-end reads,
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

VirSorter 2 comes with a [good documentation](https://github.com/jiarong/VirSorter2#readme).

#### Setup

VirSorter can be easily installed from BioConda. If you didn't do it already, create a "vs2" environment 
with `virstorter=2` and activate it.

The first step is to download the database:

```bash
# Install the package
mamba create -n virsorter2 -c conda-forge -c bioconda --yes virsorter=2
conda activate virsorter2

# One time database download [this may have been done for you in training servers]
virsorter setup -d $OUTPUT_DB_PATH -j 4
```

#### Running VirSorter

When the database is installed, you can run VirSorter on a single assembly:

```bash
virsorter run -w $OUT -d $VIR/virsorter2/ -i $CONTIGS -j 16 [--use-conda-off]
```

where:
* `-w OUTPUT_DIR` is the output directory path
* `-d PATH_DB` is the path to the VirSorter2 database and environments
* `-i CONTIGS_FASTA` is the fasta file produced by the assembler
* `-j THREADS` is the number of jobs to run in parallel
* `--use-conda-off` will allow to work with offline servers (requires a different installation)

### (parallel) VirFinder

We can install a [parallelised version](https://github.com/quadram-institute-bioscience/parallel-virfinder) of 
[VirFinder](https://github.com/jessieren/VirFinder) using conda:

```bash
mamba install -c bioconda -c conda-forge parallel-virfinder
```

to use it:

```bash
parallel-virfinder.py -i CONTIGS -o OUTPUT -f FASTA_OUTPUT -n 16  [-s MIN_SCORE -p MAX_P_VALUE]
```

MIN_SCORE and MAX_P_VALUE are supplied with defaults values, but you can change them if you want.

* `-i CONTIGS` is the fasta file produced by the assembler (input)
* `-f OUTPUT` is the set of viral contigs (output)
* `-o OUTPUT` is the tabular output 


## Checking the results

```bash
# In the base environment
mamba install -c bioconda checkv

# Download the databases (a subdirectory will be created)
checkv download_database  ~/checkv-dbs/
```

To run checkv:

```bash
checkv  end_to_end -d ~/checkv-db/checkv-db-v1.4/ -t 16 input-contigs.fa output-dir
```

The output directory includes:
* viruses.fna
* proviruses.fna
* complete_genomes.tsv:  detailed overview of putative complete genomes identified
* quality_summary.tsv: report on the program's modules for each contig

For example, when running on the output of VirSorter2 on one sample in the dataset, CheckV discarded
30% of the contigs:

```text
┌──────────────────────┬──────┬───────────┬──────────┬────────┬───────┬───────┬───────────┬─────┬─────────┐
│ File                 │ #Seq │ Total bp  │ Avg      │ N50    │ N75   │ N90   │ auN       │ Min │ Max     │
├──────────────────────┼──────┼───────────┼──────────┼────────┼───────┼───────┼───────────┼─────┼─────────┤
│ final-viral-combined │ 745  │ 2,684,355 │ 3,603.16 │ 19,811 │ 3,156 │ 1,197 │ 28,566.17 │ 228 │ 124,265 │
│ viruses              │ 716  │ 1,833,389 │ 2,560.60 │ 6,124  │ 1,956 │ 911   │ 17,494.67 │ 228 │ 70,755  │
└──────────────────────┴──────┴───────────┴──────────┴────────┴───────┴───────┴───────────┴─────┴─────────┘
```

---

## The programme

* :zero: [EBAME-22 notes]({{ site.baseurl }}{% link _posts/2022-02-02-virome-ebame.md %}): EBAME-7 specific notes
* :one: [Gathering the reads]({{ site.baseurl }}{% link _posts/2022-02-10-virome-reads.md %}):
  downloading and subsampling reads from public repositories (optional)
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-02-11-virome-tools.md %}):
  we will use Miniconda to manage our dependencies
* :three: [Reads by reads profiling]({{ site.baseurl }}{% link _posts/2022-02-12-virome-phanta.md %}):
  using Phanta to quickly profile the bacterial and viral components of a microbial community
* :four:  _De novo_ mining:
  assembly based approach, using VirSorter as an example miner
* :five:  [Viral taxonomy]({{ site.baseurl }}{% link _posts/2022-02-14-virome-taxonomy.md %}):
  *ab initio* taxonomy profiling using vConTACT2
* :six:  [MetaPhage overview]({{ site.baseurl }}{% link _posts/2022-02-15-virome-metaphage.md %}):
  what is MetaPhage, a reads to report pipeline for viral metagenomics

:arrow_left: [Back to the main page]({{ site.baseurl }}{% link _posts/2022-02-01-Virome.md %})
