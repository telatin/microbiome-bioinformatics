---
layout: post
title:  "Taxonomic profiling of whole metagenome shotgun (day 1)"
author: at
categories: [ metagenomics, tutorial ]
image: assets/images/xray-bact.jpg
---

> On our first day we well cover the concepts behind taxonomic classification using Kraken2 (and Bracken), and see how to remove host reads and perform the quality checks (and filtering).


## Some links, before we start

This is an intermediate workshop and some knowledge of Unix is required, but
we will be at different levels so... here some usful links:

* [Log in via SSH](https://github.com/telatin/learn_bash/wiki/Connect-via-SSH)
* [Using GNU screen](https://github.com/telatin/learn_bash/wiki/Using-%22screen%22)
    * [.screenrc file](https://gist.github.com/telatin/66fab72e9bf0dda9984cad8d97c6174b)
* [A Unix CLI tutorial (basic)](http://www.ee.surrey.ac.uk/Teaching/Unix/unix1.html)
* **A primer on bash scripting (intermediate)**
  * [Introduction](https://telatin.github.io/articles/01-bash.html)
  * ["for" loops](https://telatin.github.io/articles/02-bash.html)
  * ["if-then"](https://telatin.github.io/articles/03-bash.html)
  * [Scripts safety net](https://telatin.github.io/articles/04-bash.html)
  * [Getting parameters](https://telatin.github.io/articles/05-bash.html)

## Preparing our workbench

:movie_camera: [Installing Miniconda screencast](https://www.youtube.com/watch?v=28PzHzGLtHk&t=2s)

We will use Miniconda throughout this workshop. This is generally a great tool
to install packages and manage conflicting/multiple versions of libraries and 
tools, but in this case it's also the required way to install Qiime2.

If we don't have _conda_ installed and available, 
we first need to
[**install Miniconda**]({{ site.baseurl }}{% link _posts/2021-01-01-Install-Miniconda.md %})
and then _mamba_.

When we are ready with _conda_ (and _mamba_) installed, we can install a some of the 
of the tools which we'll use later:
 
```
mamba install -c conda-forge -c bioconda seqfu
```

We can create an _ad hoc_ environment, called for example "metax" (here we split the command on multiple lines):
```
mamba create -n metax \
  -c conda-forge -c bioconda  \
  seqkit kraken2 bracken entrez-direct krona fastp fastqc multiqc
```

:bulb: To be able to use the tools, you will need to activate the environment with `conda activate metax`. Do deactivate
it, simply `conda deactivate`.

:sos: Problems installing conda? We are here to help!

## Reclaim your home

Write your name in a file so that we know who is using each account:

```
echo "Name Surname" > ~/.name
```

## Our dataset

We have a set of samples from an ongoing study gut metagenomics by 
Aimee Parker (Quadram Institute) and co-workers. Part of her study
has been [described in a pre-print](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3811833), 
we took some samples to practice our classification skills. This is a small selection of the dataset
and we also subsampled the total reads to make the computation faster.

 * Sample\_3 ([FastQC R1]({{ '/data/fastqc/Sample3_R1_fastqc.html' | prepend: site.baseurl }}), [FastQC R2]({{ '/data/fastqc/Sample3_R2_fastqc.html' | prepend: site.baseurl }}))
 * Sample\_6 ([FastQC R1]({{ '/data/fastqc/Sample6_R1_fastqc.html' | prepend: site.baseurl }}), [FastQC R2]({{ '/data/fastqc/Sample6_R2_fastqc.html' | prepend: site.baseurl }}))
 * Sample\_30 ([FastQC R1]({{ '/data/fastqc/Sample30_R1_fastqc.html' | prepend: site.baseurl }}), [FastQC R2]({{ '/data/fastqc/Sample30_R2_fastqc.html' | prepend: site.baseurl }}))
 * Sample\_4 ([FastQC R1]({{ '/data/fastqc/Sample4_R1_fastqc.html' | prepend: site.baseurl }}), [FastQC R2]({{ '/data/fastqc/Sample4_R2_fastqc.html' | prepend: site.baseurl }}))
 * Sample\_22 ([FastQC R1]({{ '/data/fastqc/Sample22_R1_fastqc.html' | prepend: site.baseurl }}), [FastQC R2]({{ '/data/fastqc/Sample22_R2_fastqc.html' | prepend: site.baseurl }}))
 * Sample\_25 ([FastQC R1]({{ '/data/fastqc/Sample25_R1_fastqc.html' | prepend: site.baseurl }}), [FastQC R2]({{ '/data/fastqc/Sample25_R2_fastqc.html' | prepend: site.baseurl }}))
 * Sample\_13 ([FastQC R1]({{ '/data/fastqc/Sample13_R1_fastqc.html' | prepend: site.baseurl }}), [FastQC R2]({{ '/data/fastqc/Sample13_R2_fastqc.html' | prepend: site.baseurl }}))
 * Sample\_31 ([FastQC R1]({{ '/data/fastqc/Sample31_R1_fastqc.html' | prepend: site.baseurl }}), [FastQC R2]({{ '/data/fastqc/Sample31_R2_fastqc.html' | prepend: site.baseurl }}))

We have the reads in `/data/workshop/reads`. You can use that source directory directly, or - for simplicity - make
a _symbolic link_ of that directory in your home, as shown below:

```
cd
mkdir kraken-ws
ln -s /data/workshop/reads/ kraken-ws
```

## Initial QC

:movie_camera: [A FastQC tutorial](https://www.youtube.com/watch?v=lUk5Ju3vCDM)

A common approach to have a "snapshot" of the quality of the reads is **FastQC**,
that produces HTML reports for each analysed file. From the command line can 
be invoked as:
```
mkdir -p FastQC
fastqc --outdir FastQC --threads 4 reads/*_R[1,2]*gz 
```

:bulb: To view the HTML file you will need to copy the to your computer using scp (natively
supported by Mac and Linux) or a program supporting the protocol, like WinSCP.

Sometimes it can be useful to have some data on our files from the command line:

 * We can count the reads with `seqfu count reads/*gz`
 * We can get insights on the quality scores with `seqfu qual reads/*gz`
 * We can even inspect a single file with `seqfu view reads/Sample3_R2.fq.gz | less -SR` (remember to use `q` to quit less)

## Host removal

We will use [kraken2](https://ccb.jhu.edu/software/kraken2/),
the same program we will use to classify our reads, also to flag (and remove) the host reads.

First create a directory for your decontaminated output in your workshop directory:

```
mkdir ~/kraken-ws/reads-no-host
```

To view the settings of kraken2 you can run `kraken2 -h`.

Now can try to run the host decontamination for one sample (_e.g._ Sample8). 

:bulb: Make sure you have the conda environment with your kraken2 installation activated. 

```bash
kraken2 --db /data/db/kraken2/mouse_GRCm39 --threads 5 --confidence 0.5 \
  --minimum-base-quality 22 \
  --report ~/kraken-ws/reads-no-host/Sample8.report \
  --unclassified-out ~/kraken-ws/reads-no-host/Sample8#.fq \
  --paired /data/shared/reads/Sample8_R1.fastq.gz /data/shared/reads/Sample8_R2.fastq.gz > ~/kraken-ws/reads-no-host/Sample8.txt 
```

* `/data/db/kraken2/mouse_GRCm39` is the path to the kraken2 database for host (see optional part below to see how you can create your own custom database)
* `~/kraken-ws/reads-no-host/` is out output directory
* `Sample8` is our sample name 
* `--report ~/kraken-ws/reads-no-host//Sample8.report` is going to create the report that describes the amount of contamination
* `--unclassified-out ~/kraken-ws/reads-no-host//Sample8#.fq.gz` is needed to collect the reads that don't match the host database, hence represent contamination-free reads
* `~/kraken-ws/reads-no-host/Sample8.txt` will save the read-by-read report. :bulb: you usually will discard it so you can redirect to `/dev/null` instead

The kraken2 output will be unzipped and therefore taking up a lot iof disk space. So best we gzip the fastq reads again before continuing.
```bash
pigz -p 6 ~/kraken-ws/reads-no-host/Sample8_*.fq
```

Since we have multiple samples, we need to run the command for all reads. This can be done using a for-loop. Save the following into a script `removehost.sh` 

```
DB=/data/db/kraken2/mouse_GRCm39
DIR=/data/workshop/reads/
OUT=~/kraken-ws/reads-no-host

mkdir -p "$OUT/"

for R1 in $DIR/Sample*_R1.fq.gz;
do
    # We cut the sample name on the first _ and store it in $sample 
    sample=$(basename $R1 | cut -f1 -d_)

    # We infer the second pair replacing _R1 with _R2
    R2=${R1/_R1/_R2}
    
    echo "removing mouse contamination from $sample"
    echo "Reads: $R1 / $R2"
    kraken2 \
        --db $DB \
        --threads 8 \
        --confidence 0.5 \
        --minimum-base-quality 22 \
        --report $OUT/${sample}.report \
        --unclassified-out $OUT/${sample}#.fq > /dev/null \
        --paired $R1 $R2
    pigz ${OUT}/*.fq
done
```

Now run the script with 

```
bash removehost.sh
```

:link: See [Host removal]({{ site.baseurl }}{% link _posts/2021-03-04-Host-removal.md %})
 

## Reads filtering


[fastp](https://github.com/OpenGene/fastp#readme) was designed
to have "good defaults", but it's always a good idea to check
what our options are to tweak the parameters.

Some notes:
 * When processing paired-end reads the input is specified with `-i file_R1.fq` and `-I file_R2.fq`.
 * Similarly, the two output files are specified with `-o filtered_R1.fq` and `-O filtered_R2.fq`.
 * During the process, a report can be saved in both HTML (`-h report.html`) and JSON (`-j report.json`) formats.
 * All the other paramters will affect what files are retained / discarded


### Running fastp over a single sample

Let's first try with a single sample, where we ask to perform an automatic adapter detection on the paired-end
reads (it's enabled by default for single-end datasest) 
and requiring a minimum length after filtration (`-l INT`):
```
cd ~/kraken-ws/
mkdir fastp-test
fastp -i reads-no-host/Sample3_1.fq.gz -I reads-no-host/Sample3_2.fq.gz \
   -o fastp-test/Sample3_R1.fq.gz -O fastp-test/Sample3_R2.fq.gz \
   -l 100 --detect_adapter_for_pe 
```


:bulb: Note that Kraken will split the paired reads in files tagged as `_1`and `_2`. 
We are restoring the more common `_R1` and `_R2` nomenclature with the output of _fastp_.

We should find the output FASTQ files in the `fastp-test` subdirectory.


To quickly check the amount of reads before and after filtering:
```
seqfu stats --nice {reads,reads-no-host,fastp-test}/Sample3_*1.fq.gz
```
This will print a screen-friendly table.

From the table we can see the reads-loss and also the effect on the read
length:
```
┌───────────────────────────────┬─────────┬───────────┬───────┬─────┬─────┬─────┬───────┬─────┬─────┐
│ File                          │ #Seq    │ Total bp  │ Avg   │ N50 │ N75 │ N90 │ auN   │ Min │ Max │
├───────────────────────────────┼─────────┼───────────┼───────┼─────┼─────┼─────┼───────┼─────┼─────┤
│ reads/Sample3_R1.fq.gz        │ 1000000 │ 150000000 │ 150.0 │ 150 │ 150 │ 150 │ 0.000 │ 150 │ 150 │
│ reads-no-host/Sample3_1.fq.gz │ 989295  │ 148394250 │ 150.0 │ 150 │ 150 │ 150 │ 0.000 │ 150 │ 150 │
│ fastp-test/Sample3_R1.fq.gz   │ 915797  │ 135443988 │ 147.9 │ 150 │ 150 │ 150 │ 0.006 │ 100 │ 150 │
└───────────────────────────────┴─────────┴───────────┴───────┴─────┴─────┴─────┴───────┴─────┴─────┘
```


By default, _fastp_ also saves a report (called _fastp.html_) in the current
directory. An [**example report**]({{ '/data/fastp/Sample3.html' | prepend: site.baseurl }}) allows to see
that in a single report we have data on the reads _before_ and _after_ the quality filter.


### Processing multiple samples with a script

To process multiple samples we can make a [for loop](https://telatin.github.io/articles/02-bash.html), but it's wise
to make a script instead of typing the whole command (if we make an error, we can quickly fix it, and we keep track
of our command):


```bash

mkdir -p filt
mkdir -p reports

for i in reads-no-host/*_1*gz;
do
  echo "Processing sample $i";
  fastp  -w 8 -i $i -I ${i/_1/_2} \
   -o filt/$(basename ${i/_1/_R1}) -O filt/$(basename  ${i/_1/_R2}) \
   -h reports/$(basename $i | cut -f 1 -d _).html -j reports/$(basename $i | cut -f 1 -d _).json \
   --detect_adapter_for_pe \
   --length_required 100 \
   --overrepresentation_analysis;
done
```

To run the script:
```
bash filter.sh
```


---

If you arrived at this point, you deserve your coffee and an emoji-medal: :medal_sports:

If you have spare time and want to experiment something more:

* [A first experiment with Kraken2]({{ site.baseurl }}{% link _posts/2021-03-05-A-first-experiment-with-Kraken2.md %})
* [How to build a custom "host" database for Kraken2]({{ site.baseurl }}{% link _posts/2021-03-05-Build-a-kraken2-database.md %})

