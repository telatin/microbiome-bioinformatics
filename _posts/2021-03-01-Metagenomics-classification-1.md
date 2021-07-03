---
layout: post
title:  "Taxonomic profiling of whole metagenome shotgun (day 1)"
author: at
categories: [ metagenomics, tutorial ]
image: assets/images/xray-bact.jpg
---

> On our first day we well cover the concepts behind taxonomic classification using Kraken2 (and Bracken), and see how to remove host reads and perform the quality checks (and filtering).


## Before we start

This is an intermediate workshop and some knowledge of Unix is required, but
we will be at different levels so... here some usful links:

* [Log in via SSH](https://github.com/telatin/learn_bash/wiki/Connect-via-SSH)
* [Using GNU screen](https://github.com/telatin/learn_bash/wiki/Using-%22screen%22)
    * [.screenrc file](https://gist.github.com/telatin/66fab72e9bf0dda9984cad8d97c6174b)
* [A Unix CLI tutorial (basic)](http://www.ee.surrey.ac.uk/Teaching/Unix/unix1.html)
* **A primer on bash scripting (intermediate)**
  * [Introduciton](https://telatin.github.io/articles/01-bash.html)
  * [for loops](https://telatin.github.io/articles/02-bash.html)
  * [if then](https://telatin.github.io/articles/03-bash.html)
  * [safety net](https://telatin.github.io/articles/04-bash.html)
  * [getting parameters](https://telatin.github.io/articles/05-bash.html)

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
  seqkit seqfu kraken2 bracken entrez-direct bwa samtools fastp fastqc
```

:bulb: To be able to use the tools, you will need to activate the environment with `conda activate metax`. Do deactivate
it, simply `conda deactivate`.

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

## Reads filtering


[fastp](https://github.com/OpenGene/fastp#readme) was designed
to have "good defaults", but it's always a good idea to check
what our options are to tweak the parameters.

Some notes:
 * When processing paired-end reads the input is specified with `-i file_R1.fq` and `-I file_R2.fq`.
 * Similarly, the two output files are specified with `-o filtered_R1.fq` and `-O filtered_R2.fq`.
 * During the process, a report can be saved in both HTML (`-h report.html`) and JSON (`-j report.json`) formats.
 * All the other paramters will affect what files are retained / discarded
  
To process multiple samples we can make a [for loop](https://telatin.github.io/articles/02-bash.html), but it's wise
to make a script instead of typing the whole command (if we make an error, we can quickly fix it, and we keep track
of our command):


```bash filter.sh

mkdir -p filt
mkdir -p reports

for i in reads/*R1*gz;
do
  fastp  -w 16 -i $i -I ${i/R1/R1} \
   -o filt/$(basename $i) -O filt/$(basename  ${i/_R1/_R2}) \
   -h reports/$(basename $i | cut -f 1 -d _).html -j reports/$(basename $i | cut -f 1 -d _).json \
   -w 16 \
   --detect_adapter_for_pe \
   --length_required 100 \
   --overrepresentation_analysis;
 done
```

To run the script:
```
bash filter.sh
```