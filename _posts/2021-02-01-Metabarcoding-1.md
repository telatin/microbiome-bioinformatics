---
layout: post
title:  "Metabarcoding workshop (day 1)"
author: at
categories: [ metabarcoding, 16S, tutorial ]
image: assets/images/qiime.jpg
---

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
mamba install -c conda-forge -c bioconda seqfu qax
```

## Getting the raw reads

We will analyse a very famous dataset from Pat Schloss, 
author of [Mothur](https://mothur.org/), that he used to prepare a 
[tutorial](https://mothur.org/wiki/miseq_sop/)
for his own tool.

```bash
wget https://mothur.s3.us-east-2.amazonaws.com/wiki/miseqsopdata.zip
unzip miseqsopdata.zip
rm miseqsopdata.zip
```

The archive we extracted produced a couple of directories, one of which
containing the reads and some text files we will use to extract some metadata.
We will now make a dedicated directory for our reads, and compress them:

```bash
mkdir reads
mv MiSeq_SOP/*fastq reads
gzip reads/*fastq
```

:bulb: Some more 
[toy datasets]({{ site.baseurl }}{% link _posts/2021-02-01-Metabarcoding-datasets.md %}).

### A first look

[SeqFu count](https://telatin.github.io/seqfu2/tools/count.html)
 can be used to count the reads in each sample. 
 When reading Paired End datasets,
will also ensure that both files have the same amount of reads:
```
seqfu count reads/*.fastq.gz
```
For more informations on the reads size statistics, 
[SeqFu stats](https://telatin.github.io/seqfu2/tools/stats.html) can be used instead:
```
seqfu stats -n -b reads/*R1*.fastq.gz
```

When dealing with old datasets, it's good to ensure their quality encoding
(the modern being _Illumina 1.8_). [SeqFu qual](https://telatin.github.io/seqfu2/tools/qual.html) can be used for this:
```
seqfu qual reads/*R1*.fastq.gz
```

:bulb: The last column of the report is the position on the reads where the quality drops (according to
customizable parameters). This was designed to help automating DADA2.

### Preparing the metadata

Most metabarcoding experiments rely on the metadata associated to each sample, and it's important 
to correctly. [Seqfu metadata](https://telatin.github.io/seqfu2/tools/metadata.html) can be used to prepare a "blank" file in the correct format, to be 
extended with as many columns as needed. A useful addition is the possibility to add the full path of
the analysed files as an extra column and the reads count too (which can be useful to understand some
differences in diversity in undersampled samples).

```
seqfu metadata --format qiime2 reads/ > sample-metadata.tsv
```

In our dataset the samples have been collected at different times from birth, reported in the file name
as `D{number}` which indicates the number of days.

:pencil: Add a "Timepoint" column to the file, classifing the samples with D(1..100) as _Early_ and
the others as _Late_. Label the Mock community as _Mock_.
:mag: The result should [look like this](https://gist.github.com/telatin/7b5b2e86eeef59db4b13ec42d98acb3b).

## Metabarcoding tutorials 

Here we will describe how to use **Qiime 2** to analyse the dataset (see below).
Two alternative tutorials are also available:

* [USEARCH tutorial]({{ site.baseurl }}{% link _posts/2021-02-01-Metabarcoding-with-USEARCH.md %}) - this is an instructive (simplified) workflow, that allow for an easy inspection of the intermediate files.
* [Dadaist2 tutorial]({{ site.baseurl }}{% link _posts/2021-02-01-Metabarcoding-with-Dadaist.md %}) - this pipeline can be used to quickly produce a PhyloSeq object and offers some degree of customisation
* [Lotus tutorial](https://github.com/telatin/lotus-tutorial#readme) - Lotus has been a tool providing an easy access to multiple strategies for OTU picking (clustering). 
The [new version](https://github.com/hildebra/lotus2), currently under development, also supports DADA2 denoising.

## Installing Qiime2 (2021.4)

The [installation](https://docs.qiime2.org/2021.2/install/native/#install-qiime-2-within-a-conda-environment) 
is usually performed using Miniconda as a package manager 
(that will download the required dependencies).
We will use `mamba`, a (faster) drop-in replacement for `conda`, but conda will work as well.

```bash
wget https://data.qiime2.org/distro/core/qiime2-2021.4-py38-linux-conda.yml
mamba env create -n qiime2-2021.4 --file qiime2-2021.4-py38-linux-conda.yml
rm qiime2-2021.4-py38-linux-conda.yml
```

To activate the environment:
```bash
conda activate qiime2-2021.4
```

## Importing the reads in Qiime

As discussed, we need to build a new artifact containing our raw reads.
There are different type of libraries (single-end, paired-end) and setups
(demultiplexed or not). 

We have a set of demultiplexed Illumina paired-end reads, which is the
most common setup nowadays. 

Check [Qiime2 importing page](https://docs.qiime2.org/2021.4/tutorials/importing/#sequence-data-with-sequence-quality-information-i-e-fastq) for more information.

If our reads have the filenames in the format produced by Illumina demultiplexing
(something like *Sample1_S1_L001_R1_001.fastq.gz*) we can directly import the folder
containing the reads:

```bash
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path reads \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path raw-reads.qza
```

Just to make the tutorial a little bit more complete, we also show how to import
generic paired end files assuming we can discriminate R1 and R2 by the filename.


### Alternative method: manifest file

If the reads have a different naming scheme, we can either rename them or prepare
a _manifest file_ that tells to Qiime which file is what. For paired end reads
it should contain three coluns: sample name, forward file and reverse file.

The generation can be automated, as long as we know where to find the sample name
(in our case it's the first part before the "_"), the forward file (contains "_R1")
and the reverse file (contains "_R2"):

```bash
echo -e 'sample-id\tforward-absolute-filepath\treverse-absolute-filepath' > manifest.tsv
for FOR in reads/*_R1*fastq.gz;
do
  n=$(basename $FOR | cut -f1 -d_);
  REV=${FOR/_R1_/_R2_}
  echo $n
  echo -e "$n\t$PWD/$FOR\t$PWD/$REV" >> manifest.tsv;
done
```

:bulb: SeqFu contains a [function](https://telatin.github.io/seqfu2/tools/metadata.html) 
to prepare metadata templates from a directory containing
reads (the default output format is indeed a _manifest file_). Try and compare the result.
```bash
seqfu metadata reads/ > alt-manifest.tsv
```

After having prepared such "manifest file", we can simply:

```bash
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path manifest.tsv \
  --output-path reads.qza \
  --input-format PairedEndFastqManifestPhred33V2
```


## A first visualization: quality scores

Before starting the analysis, let's see how Qiime2 allows us to visualize
```bash
qiime demux summarize \
      --i-data raw-reads.qza \
      --o-visualization raw-reads.qzv
```

The visualization files can be viewed from 
[https://view.qiime2.org](https://view.qiime2.org),
just by dragging and dropping the file. 
This requires the transfer of the artifact to the local computer, alternatively
we can click the link below to see the visualization artifact.

:mag: view artifact: [reads.qzv](https://view.qiime2.org/visualization/?type=html&src=https%3A%2F%2Fdl.dropbox.com%2Fs%2Fzuvb1n7499fhsie%2Freads.qzv%3Fdl%3D1)


## Denoising with DADA2

[DADA2](https://benjjneb.github.io/dada2/tutorial.html)
is an R package that can denoise the reads to identify
the representative sequences and produce the feature table.

The key step is to identify the boundaries where the quality drops
significantly, both in the R1 and in the R2 reads (either with the 
visual inspection of the artifacts or using 
[SeqFu qual](https://telatin.github.io/seqfu2/tools/qual.html)).

:bulb: Change the number of working threads based on the availability on
the used system

```bash
qiime dada2 denoise-paired \
      --i-demultiplexed-seqs raw-reads.qza \
      --p-trunc-len-f 235 \
      --p-trunc-len-r 154 \
      --p-n-threads 12 \
      --o-table table.qza \
      --o-representative-sequences repseqs.qza \
      --o-denoising-stats dada-stats.qza
```

:information_source: An alternative method to denoise the sequences is **Deblur**, that we cover in 
a [separate page]({{ site.baseurl }}{% link _posts/2021-02-01-Metabarcoding-deblur.md %}).

DADA2 is the core step in this microbiome analysis workflow as it both produces:
* our representative sequences
* the feature table

### A quick preview of the Mock community: a command line example

Let's try to estimate the number of ASVs found in the "Mock" sample, which is an artificial community generated
from the genomic DNA from 21 bacterial strains.

 First we can extract the artifact with:
```
# With Qax (more portable as does not require Qiime2 and its environment active), will produce _table.biom_:
qax extract table.qza

# or natively with Qiime 2 (will produce a directory with the UUID of the artifact):
qiime tools extract --input-path table.qza --output-path .
```

The extracted file is a BIOM file, that can be converted to a tabular format with:
```
biom convert --to-tsv -i table.biom -o table.tsv
```

The Mock sample is the last, it's number 20 (so column 21). Let's have a look:
```
cut -f 1,21 table.tsv | sort -n -k 2 | tail -n 50
```

An to count any number larger than a threshold:
```
cut -f 1,21 table.tsv | sort -n -k 2 | awk '$2 > 2.0' | wc -l
```

## Tree

Some _diversity metrics_ are based on the tree of the representative sequences. 
Qiime has several options to generate one, for example the
[align-to-tree-mafft-fasttree](https://docs.qiime2.org/2021.4/plugins/available/phylogeny/align-to-tree-mafft-fasttree/).

```bash
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences repseqs.qza \
  --o-alignment aligned-repseqs.qza \
  --o-masked-alignment masked-aligned-repseqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza
  ```

:book: It can be an interesting exercise to reproduce the step manually starting from the _representative sequences_
using [MAFFT](https://mafft.cbrc.jp/alignment/software/) and [FastTree](http://www.microbesonline.org/fasttree/).



---


## Primary bibliography

* Bolyen, E., Rideout, J.R., Dillon, M.R. et al. (2019) **Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2**. _Nat Biotechnol._ [doi: 10.1038/s41587-019-0209-9](https://doi.org/10.1038/s41587-019-0209-9)
* Estaki, M., Jiang, L., Bokulich, N. A., McDonald, D., González, A., Kosciolek, T., Martino, C., Zhu, Q., Birmingham, A., Vázquez-Baeza, Y., Dillon, M. R., Bolyen, E., Caporaso, J. G., & Knight, R. (2020). **QIIME 2 enables comprehensive end-to-end analysis of diverse microbiome data and comparative studies with publicly available data**. _Current Protocols in Bioinformatics_ [doi: 10.1002/cpbi.100](https://doi.org/10.1002/cpbi.100)
* Kozich JJ, Westcott SL, Baxter NT, Highlander SK, Schloss PD. (2013) **Development of a dual-index sequencing strategy and curation pipeline for analyzing amplicon sequence data on the MiSeq Illumina sequencing platform.** _Appl Environ Microbiol._ [doi: 10.1128/AEM.01043-13](https://doi.org/10.1128/AEM.01043-13) 
