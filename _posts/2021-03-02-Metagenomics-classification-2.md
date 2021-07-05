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


## MultiQC report

[MultiQC](https://multiqc.info) is a fantastic tool that can aggregate outputs from different bioinformatics
programs in a single report. We will combine our _fastp_ and _Kraken2_ classifications
to have a single report.

It works with a bit of magic: it scans all your files to check if some looks like a bioinformatic output. Sometimes the filename is important as well, for example 
for _fastp_ it will use the `.json` file, that should be in the `*.fastp.json` format.

```
cd ~/kraken-ws
for i in reports/*.json;
dd
  mv $i ${i/json/fastp.json}
done
```

We can first create a report just based on FASTP with: 

```
multiqc -o fastp-report reports/
```

With *-o* we specify the output directory, then we need to tell where MultiQC should scan for known files.
The output should be similar to [this one](https://telatin.github.io/microbiome-bioinformatics/data/multiqc/fastp-report/).
If you check your report, you will notice that MultiQC thinks our samples are called _Samplename\_1_, because 
it's taken from the first pair. 

We want to remove the `_1` to make it mergeable with Kraken:

```
sed -i 's/_1//' reports/*.json
```

Now we can combine _fastp_ and _Kraken2_:
```
multiqc -o multiqc reports/ kraken/
```

:mag: The output should be [like this one](https://telatin.github.io/microbiome-bioinformatics/data/multiqc/)

## Krona plots

[krona]({{ site.baseurl }}{% link _posts/2021-03-06-Kraken-to-Krona.md %})

