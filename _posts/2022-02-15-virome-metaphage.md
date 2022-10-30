---
layout: post
title:  "MetaPhage, automated reads-to-report pipeline"
author: at
categories: [ virome, tutorial, metaphage ]
image: assets/images/virome.jpg
hidden: true
---

[MetaPhage](https://mattiapandolfovr.github.io/MetaPhage/) is a complete reads-to-report pipeline for viral metagenomics. It is a Nextflow pipeline that can be run on a local machine or on a cluster. It is designed to be easy to use and to provide a complete report of the analysis. 

[![MetaPhage pipeline]([/assets/images/metaphage/metaphage.png](https://github.com/MattiaPandolfoVR/MetaPhage/raw/dev/figures/metaphage.drawio.svg))](https://mattiapandolfovr.github.io/MetaPhage/)

See:
* [a quick overview]({{ site.baseurl }}{% link _posts/2022-01-01-MetaPhage-output.md %})
* [MetaPhage paper](https://journals.asm.org/doi/full/10.1128/msystems.00741-22?rfr_dat=cr_pub++0pubmed&url_ver=Z39.88-2003&rfr_id=ori%3Arid%3Acrossref.org) (Open Access)


---

## The programme

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
* :six:  **MetaPhage overview**:
  what is MetaPhage, a reads to report pipeline for viral metagenomics

:arrow_left: [Back to the main page]({{ site.baseurl }}{% link _posts/2022-02-01-Virome.md %})
