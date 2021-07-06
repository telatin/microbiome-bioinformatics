---
layout: post
title:  "Taxonomic profiling of whole metagenome shotgun (day 2)"
author: at
categories: [ metagenomics, tutorial ]
image: assets/images/xray-bact.jpg
---

> Today we will use Braken to recalibrate our estimations, and a set of scripts to merge multiple samples in a single table, and see how to filter it. We will prepare a MultiQC report with our QC, Kraken2 and Bracken data.


## A small test on Kraken2

* See [a first tutorial on Kraken2]({{ site.baseurl }}{% link _posts/2021-03-05-A-first-experiment-with-Kraken2.md %})

After making a very small test, we can also try with the CAMI mock sample, that you might have in `~/sequences/`,
or that you can find in `/data/cami/`.


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

:bulb: In the **next** paragraphs you'll find a complete script that does Kraken and Bracken 
in one go, but you can see a [Kraken2 solution here](https://gist.github.com/telatin/6594faebe6f8497f9a9365a83c9369d5).



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

* **kraken** (containing the reports as `*.report` and raw output as `*.tsv`)
* **bracken** (containing the reports as `*.breport` and tabular output as `*.tsv`)

We hosted the source on GitHub, and you can quickly download it as:
```
wget "https://gist.githubusercontent.com/telatin/fa79d013707a293c0c3ff019abc7313d/raw/kraken.sh"
```

and run it as:
```
bash classify.sh [input_dir]
```

* See the [full code]({{ site.baseurl }}{% link _posts/2021-03-06-Kraken-Bracken.md %})


## MultiQC report

[MultiQC](https://multiqc.info) is a fantastic tool that can aggregate outputs from different bioinformatics
programs in a single report. We will combine our _fastp_ and _Kraken2_ classifications
to have a single report.

* [See the MultiQC tutorial]({{ site.baseurl }}{% link _posts/2021-03-06-MultiQC.md %})


## Krona plots

Krona is a flexible tool to generate interactive pie charts. We have a dedicated tutorial on 
how to produce an HTML interactive plot using Krona.

The procedure works both on Kraken2 and Bracken _report_ files.

* [See the Krona tutorial]({{ site.baseurl }}{% link _posts/2021-03-06-Kraken-to-Krona.md %})



## Combining the reports 

Since we have to run kraken2 and bracken on a per-sample basis, 
it is helpful to combine the report files into a single table containing all observations 
and species before we jump into R. 
I wrote a small script that should do the merging of bracken (or kraken2) reports for you. 

To use it we need to install pandas first

```
conda install pandas
```

The you can merge either a kraken2 or bracken reports with

```
python /data/shared/scripts/merge_profiling_reports.py -i bracken/ -o merged
```

:package: [merge_profiling_reports.py](https://gist.github.com/telatin/9c5e38e52e1d97f8b4cf93928a859166) source
  
This produces 2 files in the same directory where the input files are (in our example _./bracken_):

* `merged_rel_abund.csv`:    contains table for all samples with bracken relative abundances and taxonimic assignments 
* `merged_read_numbers.csv`: contains table for all samples with bracken read counts and taxonimic assignments 

We will use these files for the data exploration and analysis on day 3.

But feel free to sneak peak with `head merged_rel_abund.csv`.

---

Optional track: [Kaiju]({{ site.baseurl }}{% link _posts/2021-03-10-Kaiju.md %})