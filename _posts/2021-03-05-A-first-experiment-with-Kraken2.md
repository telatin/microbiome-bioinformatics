---
layout: post
title:  "A first experiment with Kraken2"
author: at
categories: [ metagenomics, tutorial ]
hidden: true
---

Our goal here is to create a small and artificial set of sequences to be classified using Kraken2,
to practice with its parameters and its output formats.

## A known reference

You can select your favourite genome, or use the one we placed in:

```
/data/shared/genomes/GCF_000027325.1_ASM2732v1_genomic.fna.gz
```

This is the complete genome of _Mycoplasma genitalium_, that just happen to be a relative small genome,
as confirmed by _seqfu stats_ 
(we add `-b`to print the filename, and not the path, 
and `-n`to have a screen-friendly table):

```
seqfu stats -b -n /data/shared/genomes/GCF_000027325.1_ASM2732v1_genomic.fna.gz
```

## Making it into pieces

Sometimes it is useful to simulate a _whole genome shotgun_, in order to have a synthetic dataset that
should resemble a real sequencing experiment. One of such tools, [art](https://www.niehs.nih.gov/research/resources/software/biostatistics/art/index.cfm)
can generate Illumina datasets.

To test Kraken2, however, we want to start with a systematic approach: shredding the genome
into pieces of known length but without sequencing errors and sampling biases. _fu-shred_, from 
the _seqfu suite_, can do exactly that, specifying:
* the desired fragments length (`--length`, or `-l` for short)
* and their distance (`--step`, or `-s`)

```
# Create a directory for this experiment
mkdir ~/myco-test
fu-shred -l 100 -s 10 /data/shared/genomes/GCF_000027325.1_ASM2732v1_genomic.fna.gz > ~/myco-test/fragments.fq
```

## Classify our dataset with Kraken2

A curated collection of Krakent2 databases is available from [BenLangmead lab](https://benlangmead.github.io/aws-indexes/k2).
We have some Kraken2 databases in `/data/db/kraken2/`, and we are specifically going to use:
```
/data/db/kraken2/standard-16gb/
```

:bulb: If you set the *$KRAKEN2_DEFAULT_DB* you can omit the database in the command. 
For example with `export KRAKEN2_DEFAULT_DB=/data/db/kraken2/standard-16gb/`.

the full command to generate both a summary report and the detailed output would be:
```
kraken2 --db /data/db/kraken2/standard-16gb/ \
  --report ~/myco-test/report.txt
  --threads 4 > ~/myco-test/kraken-output.tsv
```

The program will print to the standard error, at the end of the execution, a summary of the operation:
```
57998 sequences (5.80 Mbp) processed in 0.971s (3582.9 Kseq/m, 358.29 Mbp/m).
  55100 sequences classified (95.00%)
  2898 sequences unclassified (5.00%)
```

It's interesting to see that, even if we have subsequences from a reference genome with no errors, a fraction
of the _fragments_ has not been classified at all.
