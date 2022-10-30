---
layout: post
title:  "Gathering the (virome) tools"
author: at
categories: [ virome, tutorial, tools ]
image: assets/images/virome.jpg
hidden: true
---

## Install "conda" (and "mamba")

:warning: Conda is pre-installed in EBAME VMs. Check the [EBAME-7 notes]({{ site.baseurl }}{% link _posts/2022-02-02-virome-ebame.md %}) for more details.

**Miniconda** is a package manager widely adopted in bioinformatics,
as it allows to install and manage software packages with minimal
effort and also to create isolated environments for each project,
which can be exported and shared with others.

**Mamba** is a drop-in replacement for the conda package manager,
which is faster and more efficient than conda. In simple terms, replacing
`conda` with `mamba` will speed up the installations, as long as Mamba
itself was installed with `conda install -c conda-forge mamba`.

* Read more [about Miniconda and Mamba]({{ site.baseurl }}{% link _posts/2021-01-01-Install-Miniconda.md %})

## What tools

* A de novo assembly program, such as MegaHit or Spades. They are both readily available from BioConda
* One or more viral mining tools, such as VirSorter2 (BioConda)
* A classifier: Phanta



---

## The programme

* :zero: [EBAME-22 notes]({{ site.baseurl }}{% link _posts/2022-02-02-virome-ebame.md %}): EBAME-7 specific notes
* :one: [Gathering the reads]({{ site.baseurl }}{% link _posts/2022-02-10-virome-reads.md %}):
  downloading and subsampling reads from public repositories (optional)
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-02-11-virome-tools.md %}):
  we will use Miniconda to manage our dependencies
* :three: [Reads by reads profiling]({{ site.baseurl }}{% link _posts/2022-02-12-virome-phanta.md %}):
  using Phanta to quickly profile the bacterial and viral components of a microbial community
* :four:  [_De novo_ mining]({{ site.baseurl }}{% link _posts/2022-02-13-virome-denovo.md %}):
  assembly based approach, using VirSorter as an example miner
* :five:  [Viral taxonomy]({{ site.baseurl }}{% link _posts/2022-02-14-virome-taxonomy.md %}):
  *ab initio* taxonomy profiling using vConTACT2
* :six:  [MetaPhage overview]({{ site.baseurl }}{% link _posts/2022-02-15-virome-metaphage.md %}):
  what is MetaPhage, a reads to report pipeline for viral metagenomics

:arrow_left: [Back to the main page]({{ site.baseurl }}{% link _posts/2022-02-01-Virome.md %})
