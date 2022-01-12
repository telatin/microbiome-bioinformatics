---
layout: post
title:  "Nextflow: implementing a simple pipeline"
author: at
categories: [ nextflow, tutorial ]
image: assets/images/nextflow.jpg
---

## First, let's run the pipeline!

Before starting from scratch, we can see an interesting feature of Nextflow: we can execute pipelines
from a Github repository, without the need of downloading them first.

1. Move to the directory of the repository
2. If you didnt download the small dataset, do it now (`bash getdata.sh`)
3. Activate the conda environment with the needed tools

We must specify a release, in this case we will use the "main" branch:

```bash
nextflow run telatin/nextflow-example -r main --reads 'data/*_R{1,2}.fastq.gz' --outdir denovo-example
```

This means that developing our pipeline using a public repository, we can also instantly run it on any
machine!

### Execution and output

Nextflow will update us on the progress of the pipeline printing the pipeline status on our terminal:

```text
Denovo Pipeline
===================================
reads        : data/*_R{1,2}.fastq.gz
outdir       : denovo-example

executor >  local (11)
[84/8b8eb4] process > fastp (filter T7) [100%] 3 of 3 ✔
[c1/81b198] process > assembly (T7)     [100%] 3 of 3 ✔
[c4/00a269] process > prokka (T7)       [100%] 3 of 3 ✔
[ca/858462] process > quast (quast)     [100%] 1 of 1 ✔
[1e/bb26e6] process > multiqc           [100%] 1 of 1 ✔
Completed at: 12-Jan-2022 16:41:20
Duration    : 1m 14s
CPU hours   : 0.1
Succeeded   : 11
```

As we discussed, every process is executed in its separate directory,
by default in our `./work/` 

Check the output files produced in the _denovo-example_ directory. 
The HTML report is like :mag: [**MultiQC report**]({{ site.baseurl }}{% link attachments/multiqc_report.html %}).

---


## The programme

* :one: [A *de novo* assembly pipeline]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-denovo.md %}): we will design a simple workflow to assemble and annotate microbial genomes
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-containers.md %}): we will use Miniconda to gather our required tools, and generate Docker and Singularity containers manually (Nextflow can automate this step, but it's good to practice manually first)
* :three: [First steps with Nextflow]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-first-steps.md %}): we will install Nextflow and run a couple of test scripts
* :four: **The *de novo* pipeline in Nextflow**: we will implement our pipeline in Nextflow

:arrow_left: [Back to the Nextflow main page]({{ site.baseurl }}{% link _posts/2022-01-10-Nextflow-start.md %})