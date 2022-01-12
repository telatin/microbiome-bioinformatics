---
layout: post
title:  "Nextflow: designing our pipeline"
author: at
categories: [ nextflow, tutorial ]
image: assets/images/nextflow.jpg
---

## Our goal

We want to process the raw output of *whole genome shotgun* experiments performed on bacterial isolates.

Our **input** is a directory with the FASTQ files (paired end), and we can start drafting that we require files
having a name like `SampleName_R1.fastq.gz` (and its paired `SampleName_R2.fastq.gz`). The user is expected to
provide - in our quest for a simple pipeline - only two parameters:

* the **input directory**, that must contains the paired end FASTQ files
* the **output directory**, that will be created and populated (optional: a default will be used if not specified)

We want to assemble each sample (producing the FASTA file with the contigs, we will use [shovill](https://github.com/tseemann/shovill)),
annotate the contigs (with a general annotation program, 
[Prokka](https://github.com/tseemann/prokka#readme), and an AMR detection tool, [Abricate](https://github.com/tseemann/abricate#readme)).
So far we are doing some common steps from the [torstyverse](https://twitter.com/pathogenomenick/status/1175349205180829699).

We also want to collect some statistics and summaries: a report from the quality filtering tool ([fastp](https://github.com/OpenGene/fastp)),
statistics on the assemblies ([QUAST](http://bioinf.spbau.ru/quast)). 

There is a fantastic tool to generate a report: [MultiQC](https://multiqc.info/), which natively supports fastp, prokka and QUAST. We will need
to do some manual manipulation to add also Abricate.

### First steps

Each sample is represanted by a pair of files, and there are some steps that can be linearly (one block after
the other), for example the quality filtering, assembly and annotation:

![Assembly steps]({{ site.baseurl }}{% link assets/images/nf/nextflow2.png %})

### Collecting steps

There are some steps where we need to wait all the samples to be processed: 
the summary from Abricate (which is produced using all the Abricate outputs), 
QUAST (which will compare all the assemblies) and finally
MultiQC that collects output from multiple steps.

![Abricate and QUAST]({{ site.baseurl }}{% link assets/images/nf/nextflow5.png %})


### But we don't reinvent the wheel

If your goal is to have a powerful tool to analyse loads of isolates using several tools,
Robert Petit III developed [**Bactopia**](https://bactopia.github.io/), that is
*also* based on Nextflow DSL2!

This tutorial aims at giving a kick start on workflow development using Nextflow, and
sparkling interest on learning Nextflow more.

--- 

## The programme

* :one: [A de novo assembly pipeline]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-denovo.md %}): we will design a simple workflow to assemble and annotate microbial genomes
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-containers.md %}): we will use Miniconda to gather our required tools, and generate Docker and Singularity containers manually (Nextflow can automate this step, but it's good to practice manually first)
* :three: [First steps with Nextflow]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-first-steps.md %}): we will install Nextflow and run a couple of test scripts
* :four: [The Denovo pipeline in Nextflow]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-DSL2.md %}): we will implement our pipeline in Nextflow
