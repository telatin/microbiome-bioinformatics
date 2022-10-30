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

:warning: See Ebame specific notes and skip this section

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

## How to run Phanta (the manual way)

The command looks like this:

```bash
REPO_DIR=/path/to/phanta_repo/
snakemake -s $REPO_DIR/Snakefile \
   --configfile "config.yaml" --jobs 99 --cores 1 --max-threads 90
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

Some elements are ready to go:

* Database: full path too the `default_V1` directory as downloaded during the setup
* Outdir: the desired output directory (create it first)
* Pipeline directory: simply the full path to phanta's repository
  
For the sample file, you can generate one with [SeqFu](https://github.com/telatin/seqfu2/):

```bash
# SeqFu can be installed via:
# conda install -c bioconda -c conda-forge seqfu
seqfu metadata /path/to/reads | grep -v sample-id > /path/to/metadata.txt
```

## Autorun

The previous command can be automated by creating a script that runs the
command for us, but it's important to check that the environment is activated.

1. Get the script

```bash
wget -O $HOME/bin/runPhanta.py "https://gist.githubusercontent.com/telatin/4f404fc7d677a73d662d3d9c80021ea4/raw/1631ad6d8b7b5d3df5a6d3ca13f427580b43e5b8/run-phanta.py"
chmod +x $HOME/bin/runPhanta.py
```

2. Check that the script runs:

```bash
runPhanta.py -h
```

3. Ensure you have the `$PHANTA_DIR` and `$PHANTA_DB` environment variables set:

```bash
echo "Phanta is in ${PHANTA_DIR:=NOT_INSTALLED}"
echo "Phanta database is in ${PHANTA_DB:=NOT_INSTALLED}"
```

4. Check you input directory, to see the tag denoting forward and reverse reads:

```bash
ls -l $DATASET_DIR
```

By default the program assumes the tags are `_1` and `_2`, but you can change them with the `-f` and `-r` options,
if the reads are named differently (for example `_R1` and `_R2`).

5. Run the program:

```bash
runPhanta.py -i ${VIR}/dataset-full/ -c 16 -o ~/phanta-out --verbose
```

Where:

* `-i` is the input directory (where the reads are)
* `-o` is the output directory (where the results will be stored)
* `-c` is the number of cores to use
* `--verbose` will keep us informed of the progress

## The output

The output is a directory with two subdirectories:
* **classification**: the results from the taxonomy profiling of each sample
* **final_merged_outputs**: the combined tables
  * *counts.txt*:  provides the number of fragments assigned to each taxon
  * *relative_read_abundance.txt*: same but normalized out of the total number of reads
  * *relative_taxonomic_abundance.txt*: same but abundances are corrected for genome length
  * *total_reads.tsv*: a table with the total number of reads per sample, useful for normalization purposes

The output files can be filtered at a desired taxonomic level with scripts provided [in the repository](https://github.com/bhattlab/phanta#filtering-merged-tables-to-a-specific-taxonomic-level).

---

## The programme

* :zero: [EBAME-22 notes]({{ site.baseurl }}{% link _posts/2022-02-02-virome-ebame.md %}): EBAME-7 specific notes
* :one: [Gathering the reads]({{ site.baseurl }}{% link _posts/2022-02-10-virome-reads.md %}):
  downloading and subsampling reads from public repositories (optional)
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-02-11-virome-tools.md %}):
  we will use Miniconda to manage our dependencies
* :three: Reads by reads profiling:
  using Phanta to quickly profile the bacterial and viral components of a microbial community
* :four:  [_De novo_ mining]({{ site.baseurl }}{% link _posts/2022-02-13-virome-denovo.md %}):
  assembly based approach, using VirSorter as an example miner
* :five:  [Viral taxonomy]({{ site.baseurl }}{% link _posts/2022-02-14-virome-taxonomy.md %}):
  *ab initio* taxonomy profiling using vConTACT2
* :six:  [MetaPhage overview]({{ site.baseurl }}{% link _posts/2022-02-15-virome-metaphage.md %}):
  what is MetaPhage, a reads to report pipeline for viral metagenomics

:arrow_left: [Back to the main page]({{ site.baseurl }}{% link _posts/2022-02-01-Virome.md %})
