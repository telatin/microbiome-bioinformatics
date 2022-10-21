---
layout: post
title:  "Gathering the (virome) reads"
author: at
categories: [ virome, tutorial ]
image: assets/images/virome.jpg
hidden: true
---

An example dataset can be gathered from the paper by
Liang et al. "[The stepwise assembly of the neonatal virome is modulated by breastfeeding](https://www.nature.com/articles/s41586-020-2192-1)" (2020).

The reads are available from the NCBI SRA under the accession number [PRJNA524703](https://www.ncbi.nlm.nih.gov/sra/?term=PRJNA524703).

From the study, we selected 10 samples (5 C-section delivery and 5 vaginal delivery), having the 
following IDs (and partial metadata):

Sample|Subject_id|Sample_source|Study_group|Infant_feeding_type|Infant_formula_type|Infant_delivery_type|Infant_gender
----------|---|-----|-------|-------|--------------|-----------------------|---
SRR8653245|373|Stool|Month 4|Formula|cow-milk based|C-Section without labor|Female
SRR8653218|357|Stool|Month 4|Formula|cow-milk based|C-Section without labor|Male
SRR8653221|359|Stool|Month 4|Formula|cow-milk based|C-Section without labor|Male
SRR8653248|368|Stool|Month 4|Formula|cow-milk based|C-Section without labor|Male
SRR8653247|365|Stool|Month 4|Formula|soy-protein based|C-Section without labor|Female
SRR8653084|389|Stool|Month 4|Formula|cow-milk based|Spontaneous vaginal delivery|Female
SRR8652914|394|Stool|Month 4|Formula|cow-milk based|Spontaneous vaginal delivery|Female
SRR8652969|398|Stool|Month 4|Formula|cow-milk based|Spontaneous vaginal delivery|Male
SRR8652861|340|Stool|Month 4|Formula|cow-milk based|Spontaneous vaginal delivery|Female
SRR8653090|376|Stool|Month 4|Formula|cow-milk based|Spontaneous vaginal delivery|Female

These 10 samples were re-analysed in our [*MetaPhage pipeline* paper](https://journals.asm.org/doi/10.1128/msystems.00741-22), and we will call them the "full" dataset.

## Downloading the reads using Docker

Create a file with a list of desired SRA codes, called `list.txt`. 
An example of the content can be:

```text
SRR8653245
SRR8653218
SRR8653221
SRR8653084
SRR8652914
SRR8652969
```

Then we can use a NextFlow pipeline to automatically download the reads (and the needed tools).
If we use Miniconda as dependency manager, we can run the following command:


```bash
nextflow run telatin/getreads -r main \
  --list list.txt -profile conda
```

:bulb: If Docker is available, we can replace the `-profile conda` with `-profile docker`.

---

## The programme

* :one:[**Gathering the reads**:
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
