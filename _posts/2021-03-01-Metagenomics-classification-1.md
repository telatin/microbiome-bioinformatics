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
  
## Preparing our workbench

We will use Miniconda throughout this workshop. This is generally a great tool
to install packages and manage conflicting/multiple versions of libraries and 
tools, but in this case it's also the required way to install Qiime2.

If we don't have _conda_ installed and available, 
we first need to
[install Miniconda]({{ site.baseurl }}{% link _posts/2021-01-01-Install-Miniconda.md %})
and then _mamba_.

When we are ready with _conda_ (and _mamba_) installed, we can install a couple of utilities
that we will use later:
 
```
mamba install -c conda-forge -c bioconda seqfu seqkit
```

## Our dataset

## Initial QC

## Host removal

## Reads filtering