---
layout: post
title:  "EBAME-7 Viromics notes"
author: at
categories: [ virome, tutorial, ebame]
image: assets/images/virome.jpg
hidden: true
---

This "virome primer" is designed to provide a short overview on viromics
and the tools available to analyse viral metagenomes. 
The tutorial is agnostic to the environment, and can be followed on any
linux system. This page has some notes specific for the Virtual Machines
used during the [EBAME-7 Workshop](https://maignienlab.gitlab.io/ebame7/).

## Databases and datasets location

We have a dedicated partition for databases and datasets, which we can link
to a `$VIR` variable for easier access.

:information_source: Copy and paste the following commands to setup your VM for the Viromic tutorial!

```bash
# To make it permanent
mkdir -p $HOME/bin/
echo 'export VIR=/ifb/data/public/teachdata/ebame-2022/virome/' >> ~/.bashrc
echo 'export PATH=$PATH:$HOME/bin:/ifb/data/public/teachdata/ebame-2022/virome/bin/' >> ~/.bashrc
echo 'export PHANTA_DIR=/ifb/data/public/teachdata/ebame-2022/virome/phanta/' >> ~/.bashrc
echo 'export PHANTA_DB=/ifb/data/public/teachdata/ebame-2022/virome/phanta_dbs/default_V1/' >> ~/.bashrc
echo 'shopt -s direxpand' >> ~/.bashrc

# Load the settings
source ~/.bashrc
```

To check that the variable is set correctly, you can run:

```bash
ls $VIR/
```

it should list (more or less) the following files:

```text
drwxrwxr-x 2 ubuntu ubuntu         530 Oct 25 14:56 bin
drwxrwxr-x 2 ubuntu ubuntu         492 Oct 20 14:36 dataset
drwxrwxr-x 2 ubuntu ubuntu         843 Oct 20 14:38 dataset-full
drwxrwxr-x 6 ubuntu ubuntu         292 Oct 25 14:56 phanta
drwxrwxr-x 4 ubuntu ubuntu         110 Oct 21 08:55 phanta-out
drwxrwxr-x 3 ubuntu ubuntu          28 Oct 20 10:35 phanta_dbs
drwxrwx--- 2 ubuntu ubuntu         152 Aug  2 21:52 test_dataset
drwxrwxr-x 7 ubuntu ubuntu         398 Oct 20 14:19 vcontact2
-rw-rw-r-- 1 ubuntu ubuntu        4110 Oct 20 11:04 vcontact2.yaml
drwxrwxr-x 7 ubuntu ubuntu         153 Oct 19 14:41 virsorter2
```

## What do we have?

* **Datasets**, both the full dataset and a very reduced one are available at `$VIR/dataset-full` and `$VIR/dataset`, respectively.
* **Phanta**, the virome aware profiler, is available at `$VIR/phanta`
  * **Phanta Database** is available at `$VIR/phanta_dbs/default_V1`
* **VirSorter 2** is downloaded to `$VIR/virsorter2`
* **vConTACT2** is downloaded to `$VIR/vcontact2` and its environment is available at `$VIR/vcontact2.yaml`


## Create environments

We will use conda to create environments for the different tools.

```bash
mamba env create -n phanta --yes --file ${VIR}/phanta/phanta_env.yaml
```

Optionally, you can create an environment to run vConTACT2:

```bash
mamba env create -n vcontact2 --yes --file ${VIR}/vcontact2.yaml
```
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
