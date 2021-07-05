---
layout: post
title:  "Taxonomic profiling of whole metagenome shotgun (day 2)"
author: at
categories: [ metagenomics, tutorial ]
image: assets/images/xray-bact.jpg
---

> Today we will use Braken to recalibrate our estimations, and a set of scripts to merge multiple samples in a single table, and see how to filter it. We will prepare a MultiQC report with our QC, Kraken2 and Bracken data.


## A small test on Kraken2


## Taxonomy profiling with Kraken2

We can now profile our samples, saving both the "raw" output and the report. 
We should be now familiar with `for` loops, so why don't you write yours using the
following template?

:warning: Save it as `~/kraken.sh` so that we can check it!

```
DB={fill_this}
for READS_FOR in ~/kraken-ws/filt/*_R1*.gz;
do
    READS_REV=${READS_FOR/_R1/_R2}
    kraken2 {fill_this}
done
```

:bulb: In the next paragraphs you'll find a complete script that does Kraken and Bracken 
in one go.

## Bracken

[Bracken](https://github.com/jenniferlu717/Bracken) will use as input the _Kraken2 report_ 
(not the tabular output), and needs to know the read
length of our library (we can check it with SeqFu stats, for example).

The general syntax is:
```
bracken -d MY_DB -i INPUT -o OUTPUT -w OUTREPORT -r READ_LEN -l LEVEL -t THRESHOLD
```

Where:
 * *MY_DB* is the database, that should be the same used for Kraken2 (and adapted for Bracken)
 * *INPUT* is the report produced by Kraken2
 * *OUTPUT* is the tabular output, while *OUTREPORT* is a _Kraken style_ report (recalibrated)
 * *LEVEL* is the taxonomic level (usually `S` for _species_)
 * *THRESHOLD*  it's the minimum number of reads required (default is 10)

Run bracken on one of the samples, and check the output files produced.


## A combined script for Kraken and Bracken

To put together some of the information written in the Bash scripting notes, 
we can create a `classify.sh` script to process a directory of paired-end
reads and produce two output folders (in the directory where the script
was invoked):

* kraken (containing the reports as `*.report` and raw output as `*.tsv`)
* bracken (containing the reports as `*.breport`and tabular output as `*.tsv`)

We hosted the source on GitHub, and you can quickly download it as:
```
wget "https://gist.githubusercontent.com/telatin/fa79d013707a293c0c3ff019abc7313d/raw/kraken.sh"
```

and run it as:
```
bash classify.sh [input_dir]
```

The source:
{% gist fa79d013707a293c0c3ff019abc7313d %}


## MultiQC
