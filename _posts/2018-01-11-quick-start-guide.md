---
layout: post
title:  "Microbiology from the Command Line"
author: at
categories: [ Jekyll ]
image: assets/images/breakfast.jpg
featured: true
hidden: true
---

This website collects some notes, tutorials and handsout used for
*microbial bioinformatics training* events.

#### Building a pipeline with Nextflow DSL2

[**Programme page**]({{ site.baseurl }}{% link _posts/2022-01-01-Nextflow-start.md %})

* :one: [A *de novo* assembly pipeline]({{ site.baseurl }}{% link _posts/2022-01-11-Nextflow-denovo.md %}): we will design a simple workflow to assemble and annotate microbial genomes
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-01-12-Nextflow-containers.md %}): we will use Miniconda to gather our required tools, and generate Docker and Singularity containers manually (Nextflow can automate this step, but it's good to practice manually first)
* :three: [First steps with Nextflow]({{ site.baseurl }}{% link _posts/2022-01-13-Nextflow-first-steps.md %}): we will install Nextflow and run a couple of test scripts
* :four: [The *de novo* pipeline in Nextflow]({{ site.baseurl }}{% link _posts/2022-01-14-Nextflow-DSL2.md %}): we will implement our pipeline in Nextflow

#### Metabarcoding workshop

* Day1 - [Introduction, Qiime2 and QC]({{ site.baseurl }}{% link _posts/2021-02-01-Metabarcoding-1.md %})
* Day2 - [From the feature table to diversity analyses]({{ site.baseurl }}{% link _posts/2021-02-02-Metabarcoding-2.md %})
* Day3 - [Analyse your data in R]({{ site.baseurl }}{% link _posts/2021-02-03-Metabarcoding-3.md %})

[Metabarcoding Workshop Programme]({{ site.baseurl }}{% link _posts/2021-03-20-CLIMB-Metabarcoding.md %})

#### Metagenomics workshop: classifying your reads

* Day1 - [Introduction and preliminary aspects]({{ site.baseurl }}{% link _posts/2021-03-01-Metagenomics-classification-1.md %})
* Day2 - [Kraken2, Bracken, Krona and MultiQC]({{ site.baseurl }}{% link _posts/2021-03-02-Metagenomics-classification-2.md %})
* Day3 - [Analyse your data in R]({{ site.baseurl }}{% link _posts/2021-03-03-Metagenomics-classification-3.md %})

[Kraken2 Workshop Programme]({{ site.baseurl }}{% link _posts/2021-03-20-CLIMB-Metagenomics.md %})

#### Introduction to the Bash scripting

You learnt how to work from the command line, and now want to start automating
your actions with scripts. This is a gentle introduction for you.

* [Introduction and first examples]({{ site.baseurl }}{% link _posts/2019-01-02-Bash-tutorial-2.md %})
* [For loops]({{ site.baseurl }}{% link _posts/2019-01-02-Bash-tutorial-2.md %})
* [`if` conditionals]({{ site.baseurl }}{% link _posts/2019-01-03-Bash-tutorial-3.md %})
* [Safety net]({{ site.baseurl }}{% link _posts/2019-01-04-Bash-tutorial-4.md %})
* [Getting parameters]({{ site.baseurl }}{% link _posts/2019-01-05-Bash-tutorial-5.md %})
