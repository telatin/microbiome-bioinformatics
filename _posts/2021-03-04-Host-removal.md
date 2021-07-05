---
layout: post
title:  "Remove host contamination from shotgun data"
author: ra
categories: [ metagenomics, tutorial ]
hidden: true
---


If you are working with host-associate microbiome, we are usually only interested in the microbial fraction and not the host DNA. 
In fact, host DNA can intefere with the read profiling and assembly. 
If you are working with a human host, there is also ethical components involved which requires you to remove and discard host DNA 
if you don't have the ethical approval to keep these. In this case it is essential, that host DNA is removed directly from the raw reads before doing anything else. 
If you are working with non-human host, it is less important to remove host contamination as the first step, 
and you can play around with doing so before or after quality trimming.

There are different ways to remove host contamination from shotgun reads. 
The principle is to match your reads to the host reference genome and collect all reads that don't match it. 

## Kraken2 for host removal

We are using **kraken2**, a program that uses exact k-mer matches to classify reads. 

Cite: *Wood DE, Lu J, Langmead B. Improved metagenomic analysis with Kraken 2 (2019). Genome Biology. 2019 Nov;p. 76230*

First create a directory for your decontaminated output in your home directory

    mkdir ~/nomouse

To view the settings of kraken2 you can run `kraken2 -h`.

Now can try to run the host decontamination for one sample (e.g. Sample8). Make sure you have the conda environment with your kraken2 installation activated. 

    kraken2 --db /data/db/kraken2/mouse_GRCm39 --threads 5 --confidence 0.5 \
      --minimum-base-quality 22 \
      --report ~/nomouse/Sample8.report \
      --unclassified-out ~/nomouse/Sample8#.fq \
      --paired /data/shared/reads/Sample8_R1.fastq.gz /data/shared/reads/Sample8_R2.fastq.gz > ~/nomouse/Sample8.txt 


* `/data/db/kraken2/mouse_GRCm39` is the path to the kraken2 database for host (see optional part below to see how you can create your own custom database)
* `nomouse/` is out output directory
* `Sample8` is our sample name 
* `--report nomouse/Sample8.report` is going to create the report that describes the amount of contamination
* `--unclassified-out nomouse/Sample8#.fq.gz` is needed to collect the reads that don't match the host database, hence represent contamination-free reads
* `nomouse/Sample8.txt` is collecting the read classification from stdout

The kraken2 output will be unzipped and therefore taking up a lot iof disk space. So best we gzip the fastq reads again before continuing.

    pigz -p 6 ~/nomouse/Sample8_*.fq

Since we have multiple samples, we need to run the command for all reads. This can be done using a for-loop. Save the following into a script `removehost.sh` 

    DB=/data/db/kraken2/mouse_GRCm39
    DIR=/data/workshop/reads/
    OUT=~/nomouse

    mkdir -p "$OUT/"

    for R1 in $DIR/Sample*_R1.fq.gz;
        do
            sample=$(basename ${R1%_R1.fq.gz})
            R2=${R1%_R1.fq.gz}_R2.fq.gz
            echo "removing mouse contamination from" $sample
            echo "Read1:" $R1
            echo "Read2:" $R2
        kraken2 \
            --db $DB \
            --threads 8 \
            --confidence 0.5 \
            --minimum-base-quality 22 \
            --report $OUT/${sample}.report \
            --unclassified-out $OUT/${sample}#.fq > $OUT/${sample}.txt \
            --paired $R1 $R2

        pigz ${OUT}/*.fq
    done

Now run the script with:

    bash removehost.sh

---

