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


We can now profile our samples, saving both the "raw" output and the report. We should be now familiar with `for` loops,
and Bash scripts, so let's go a bit further with a script that you can call `classify.sh`:

```
# A script to perform a Kraken / Bracken classification of a directory containing _R1 and _R2 files

# Let's check if the user supplied a variable name
if [ ! -z ${1+x} ]
```


## A combined script for Kraken and Bracken

To put together some of the information written in the Bash scripting notes, 
we can create a `classify.sh` script to process a directory of paired-end
reads and produce two output folders (in the directory where the script
was invoked):

* kraken (containing the reports as `*.report` and raw output as `*.tsv`)
* bracken (containing the reports as `*.breport`and tabular output as `*.tsv`)

Here the source:

{% gist fa79d013707a293c0c3ff019abc7313d %}