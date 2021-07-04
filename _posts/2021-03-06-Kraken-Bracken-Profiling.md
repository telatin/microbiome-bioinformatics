---
layout: post
title:  "Profile the community using kraken2"
author: ra
categories: [ metagenomics, tutorial ]
hidden: true
---


To determine the microbial composition in your samples, one method to get this information is taxonomic read profiling. Here you compare your reads to a database of interest. *Kraken2* is a popular tool, but there are other tools like *metaphlan3* that use similar approaches. One thing to remember when using this reference-based approach is, that you are blind to everything that is not in your database. Unknown organisms will not be detected this way. To persue a reference-free approach, you would have to perform an assembly-based approach which can detect unknown taxa, but on the other hand this is more limited to detect low abundant taxa. 

This means the read profiling will strongly depend on the choice of database, which should be adjusted according to your aim and study.

## 1. Read profiling using kraken2 

Here we are using a standard kraken2 database. But remember, that you have full control over the database you are using and you can even build your own custom database.

Create a folder for your profiling output

    mkdir -p ~/profiling/kraken2

Run kraken2 profiling on a single sample (e.g. Sample8). It is important to save the kraken2 report using `--report ~/profiling/kraken2/Sample8.report` to allow the downstream analysis.

    kraken2 --db /data/db/kraken2/standard-2021 --threads 8 --confidence 0.5 --minimum-base-quality 22 --report ~/profiling/kraken2/Sample8.report > ~/profiling/kraken2/Sample8.txt --paired filt/Sample8_R1.fastq.gz filt/Sample8_R2.fastq.gz 

You can explore the output files. You will have the read-by-read classification...

    head ~/profiling/kraken2/Sample8.txt

... and a summarising report

    head ~/profiling/kraken2/Sample8

Since we have multiple samples, we need to run the command for all reads. This can be done using a for-loop.

    DB=/data/db/kraken2/standard-2021
    DIR=~/filt
    OUT=~/profiling/kraken2 # redo with clean reads

    mkdir -p "$OUT/"

    for R1 in $DIR/Sample*_R1.fq.gz;
    do
        sample=$(basename ${R1%_R1.fq.gz})
        R2=${R1%_R1.fq.gz}_R2.fq.gz
        echo "profiling sample" $sample
        echo "Read1:" $R1
        echo "Read2:" $R2
        kraken2 \
            --db $DB \
            --threads 20 \
            --confidence 0.5 \
            --minimum-base-quality 22 \
            --report $OUT/${sample}.report  > $OUT/${sample}.txt \
            --paired $R1 $R2
    done

---

## 2. Re-estimate kraken2 species abundances using bracken

Kraken2’s raw read assignments is not really suitable for looking at the relative abundances of species, as kraken2 ignores ambiguous reads leading to an underestimation of some species relative abundances. Bracken re-estimates species abundances from the kraken output by probabilistically re-distributing reads in the taxonomic tree. If you want to find out more, read and cite: https://peerj.com/articles/cs-104/

### 2.1 Get relative species abundances using bracken

Create the output folder

    mkdir -p ~/profiling/bracken

Run bracken on kraken2 report files created in **1.**. Make sure to set the correct read length with the `-r` flag as this is important for bracken to work correctly. The `-l S` setting means that we want to re-estimate species abundances.

    bracken -d standard-2021 -i ~/profiling/kraken2/Sample8.report -o ~/profiling/bracken/Sample8.bracken -r 150 -l S

Do run bracken on all of the samples, use a simple for-loop like so:

    DB=/data/db/kraken2/standard-2021
    DIR=~/profiling/kraken2
    OUT=~/profiling/bracken

    mkdir -p $OUT

    for K2 in $DIR/Sample*.report;
    do
        sample=$(basename ${K2%.report})
        echo "Re-estimating abundances with bracken for" $K2
        bracken \
            -d $DB \
            -i $K2 \
            -o ${OUT}/${sample}.bracken \
            -w ${OUT}/${sample}_bracken_species.report \
            -r 150 \
            -l S
    done

---

## 3. Combine single sample abundance estimates into one table

Since we have to run kraken2 and bracken on a per-sample basis, it is helpful to combine the report files into a single table containing all observations and species before we jump into R. I wrote a small script that should do the merging of bracken (or kraken2) reports for you. 

    python /data/shared/scripts/merge_profiling_reports.py -i ~/profiling/bracken/ -o combi

This produces 2 files:

`combi_rel_abund.csv` - contains table for all samples with bracken relative abundances and taxonimic assignments 

`combi_read_numbers.csv`- contains table for all samples with bracken read counts and taxonimic assignments 


