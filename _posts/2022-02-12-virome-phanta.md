---
layout: post
title:  "Profiling viromes with Phanta"
author: at
categories: [ virome, tutorial, tools ]
image: assets/images/virome.jpg
hidden: true
---

Phanta profiling requires these steps:

1. Creating an environment with the required dependencies (only once)
2. Cloning the Phanta repository (only once)
3. Downloading the database (only once)
4. Generating a "Sample Sheet" file
5. Running Phanta

We already described the first two steps in the [previous post]({{ site.baseurl }}{% link _posts/2022-02-11-virome-tools.md %}), and the repository of the tool explains well the whole process too.

## Setup

Phanta's installation is not automated, but all its dependencies can be 
installed using an environment file for Miniconda.

```bash
# Get the Phanta repository and make its environment
git clone https://github.com/bhattlab/phanta.git
mamba env create -n phanta_env --file phanta/phanta_env.yaml
conda activate phanta_env
```
Databases have to be downloaded from Dropbox, and stored in a convenient location.

```bash
# Download the database, keep track of the location
mkdir -p phanta_dbs/default_V1
cd phanta_dbs/default_V1
wget https://www.dropbox.com/sh/3ktsdqlcph6x95r/AACGSj0sxYV6IeUQuGAFPtk8a/database_V1.tar.gz
tar xvzf database_V1.tar.gz
```

## How to run Phanta

The command looks like this:

```bash
REPO_DIR=/path/to/phanta_repo/
snakemake -s $REPO_DIR/Snakefile \
   --configfile config.yaml --jobs 99 --cores 1 --max-threads 90
```

So what do we need to put in the `config.yaml` file? Some boilerplate
(as found in the [template file](https://github.com/bhattlab/phanta/blob/main/config.yaml))
and the following paths:
```text
database: /path-to/phanta_dbs/default_V1
outdir: /path-to//phanta-out
pipeline_directory: /path-to/phanta_repo
sample_file:  /path/to/metadata.txt
```
---

Some elements are ready to go:

* Database: full path too the `default_V1` directory as downloaded during the setup
* Outdir: the desired output directory (create it first)
* Pipeline directory: simply the full path to phanta's repository
  
For the sample file, you can generate one with SeqFu:

```bash
seqfu metadata /path/to/reads | grep -v sample-id > /path/to/metadata.txt
```

## The programme

* :one: [Gathering the reads]({{ site.baseurl }}{% link _posts/2022-02-10-virome-reads.md %}):
  downloading and subsampling reads from public repositories (optional)
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-02-11-virome-tools.md %}):
  we will use Miniconda to manage our dependencies
* :three: **Reads by reads profiling**:
  using Phanta to quickly profile the bacterial and viral components of a microbial community
* :four:  [_De novo_ mining]({{ site.baseurl }}{% link _posts/2022-02-13-virome-denovo.md %}):
  assembly based approach, using VirSorter as an example miner
* :five:  [Viral taxonomy]({{ site.baseurl }}{% link _posts/2022-02-14-virome-taxonomy.md %}):
  *ab initio* taxonomy profiling using vConTACT2
* :six:  [MetaPhage overview]({{ site.baseurl }}{% link _posts/2022-02-15-virome-metaphage.md %}):
  what is MetaPhage, a reads to report pipeline for viral metagenomics

:arrow_left: [Back to the main page]({{ site.baseurl }}{% link _posts/2022-02-01-Virome.md %})
