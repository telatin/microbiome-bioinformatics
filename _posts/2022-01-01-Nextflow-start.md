---
layout: post
title:  "Nextflow DSL2 tutorial"
author: at
categories: [ nextflow, tutorial ]
image: assets/images/nf/nextflow-main.jpg
featured: true
---

## The problem

Every bioinformatics analysis can be described as a set of interconnected tasks.
A primitive approach to automate the execution of multiple commands is writing a
*script*, but this leaves a broad range of untackled issues:

* We need to manually manage the **dependencies**
* We will tailor our script to the machine we are working on:
  how can we **migrate** the pipeline to a different machine (for example, an HPC cluster or to the cloud!)?
* How can we **orchestrate each task**
  (some tasks require fewer resources and can run in parallel, other require more memory etc.)?
* If we need to **share** our pipeline will the process easy?
* We will need to **version** our script using a repository
* The final script will be probably long,
  is it going to be **readable**, and **updatable**?

## The solution

A workflow is more than a set of instructions, so a **workflow language** should allow to describe the connections between tasks,
and also how to configure the execution of each of them.

There are dedicated system to generate workflows (design) and to execute them. Some popular alternatives
are:

* **[Nextflow](https://www.nextflow.io/)** (a workflow language based on Groovy)
* **[Snakemake](https://snakemake.github.io/)** (a workflow language based on Python, and modeled after GNU Make, where each task is defined)
* **[CWL](https://www.commonwl.org/)** (a language that does not ship a single executor/interpreter, but can be used in different setups, for example using [Toil](https://toil.readthedocs.io/en/latest/))

All the solutions are rapidly evolving, and features present in one might be adopted from the other in a few months.
We picked **Nextflow** because it was born with several key features like scalability and reproducibility, and it's widely adopted, but
you might want to have a look around and see if Snakemake (for example) can work better for you. Specifically, we start directly introducing
Nextflow latest syntax (DSL2), that introduced dramatic changes to the initial implementation (giving great advantages as a result).


## The workshop

With this website and its companion repository, we will build a basic *de novo* assembly pipeline, using tools available from
[BioConda](https://bioconda.github.io) and building a Nextflow pipeline using the DSL2 syntax.

![Workflow scheme]({{ site.baseurl }}{% link assets/images/nf/nf-demo.gif %})

## The repository

The code we will develop is stored in a dedicated repository: [github.com/telatin/nextflow-example](https://github.com/telatin/nextflow-example).
The repository contains several "snapshots" of the pipeline to make it easier to reconstruct how it was built.

## The programme

* :one: [A *de novo* assembly pipeline]({{ site.baseurl }}{% link _posts/2022-01-11-Nextflow-denovo.md %}): we will design a simple workflow to assemble and annotate microbial genomes
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-01-12-Nextflow-containers.md %}): we will use Miniconda to gather our required tools, and generate Docker and Singularity containers manually (Nextflow can automate this step, but it's good to practice manually first)
* :three: [First steps with Nextflow]({{ site.baseurl }}{% link _posts/2022-01-13-Nextflow-first-steps.md %}): we will install Nextflow and run a couple of test scripts
* :four: [The *de novo* pipeline in Nextflow]({{ site.baseurl }}{% link _posts/2022-01-14-Nextflow-DSL2.md %}): we will implement our pipeline in Nextflow



_Part of the CLIMB Workshop [Bioinformatics skills for Microbial Genomics](https://www.climb.ac.uk/bioinformatics-skills-microbial-genomics/) (02-02-2022)_
 