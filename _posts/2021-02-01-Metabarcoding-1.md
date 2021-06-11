---
layout: post
title:  "Metabarcoding workshop (day 1)"
author: at
categories: [ metabarcoding, 16S, tutorial ]
image: assets/images/qiime.jpg
---

## Preparing our workbench

We will use Miniconda throughout this workshop. This is generally a great tool
to install packages and manage conflicting/multiple versions of libraries and 
tools, but in this case it's also the required way to install Qiime2.

If we don't have _conda_ installed and available, 
we first need to
[install Miniconda]({{ site.baseurl }}{% link _posts/2021-01-01-Install-Miniconda.md %})
and then _mamba_.

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
to correctly. [Seqfu metadata]() can be used to prepare a "blank" file in the correct format, to be 
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

## Metabarcoding tutorials 

Here we will describe how to use **Qiime 2** to analyse the dataset (see below).
Two alternative tutorials are also available:
* [USEARCH tutorial]({{ site.baseurl }}{% link _posts/2021-02-01-Metabarcoding-with-USEARCH.md %}) - this is an instructive (simplified) workflow, that allow for an easy inspection of the intermediate files.
* [Dadaist2 tutorial]({{ site.baseurl }}{% link _posts/2021-02-01-Metabarcoding-with-Dadaist.md %}) - this pipeline can be used to quickly produce a PhyloSeq object and offers some degree of customisation
  
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

After activating the environment, we can install more packages. We'll use two
utilities for this workshop (while USEARCH is already installed):
```
mamba install -c conda-forge -c bioconda seqfu qax
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
  echo -e "${n%.fastq.gz}\t$PWD/$FOR\t$PWD/$REV" >> manifest.tsv;
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

:information_source:
An alternative method to denoise the sequences is **Deblur**, that we cover in 
a [separate page]({{ site.baseurl }}{% link _posts/2021-02-01-Metabarcoding-deblur.md %}).

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

## Taxonomy 

A key step in our analysis, but also a step that is error prone and should be checked carefully, 
is the assignment of a taxonomic classification to our sequences.
For this step we need a reference database, [Silva](https://www.arb-silva.de/) being a widely adopted choice.

```bash
wget "https://data.qiime2.org/2021.4/common/silva-138-99-515-806-nb-classifier.qza"

qiime feature-classifier classify-sklearn \
  --i-classifier silva-138-99-515-806-nb-classifier.qza \
  --i-reads repseqs.qza \
  --p-n-jobs 8 \
  --o-classification taxonomy.qza
```

A tabular visualization can be generated, as usual:
```bash
qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv
```

But a more common visualization is provided by the
barplots:

```bash
qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization taxa-bar-plots.qzv
```


### Taxonomic classification

```bash
wget https://github.com/BenKaehler/readytowear/raw/master/data/gg_13_8/515f-806r/human-stool.qza
wget https://github.com/BenKaehler/readytowear/raw/master/data/gg_13_8/515f-806r/ref-seqs.qza
wget https://github.com/BenKaehler/readytowear/raw/master/data/gg_13_8/515f-806r/ref-tax.qza
```

```bash
qiime feature-classifier fit-classifier-naive-bayes \
       --i-reference-reads ref-seqs.qza \
       --i-reference-taxonomy ref-tax.qza \
       --i-class-weight human-stool.qza \
       --o-classifier gg138_v4_human-stool_classifier.qza

qiime feature-classifier classify-sklearn \
       --i-reads rep-seqs-deblur.qza \
       --i-classifier gg138_v4_human-stool_classifier.qza \
       --o-classification bespoke-taxonomy.qza
```

```bash
qiime metadata tabulate \
       --m-input-file bespoke-taxonomy.qza \
       --m-input-file rep-seqs-deblur.qza \
       --o-visualization bespoke-taxonomy.qzv

```

```bash
qiime diversity core-metrics-phylogenetic \
       --i-table table-deblur.qza \
       --i-phylogeny insertion-tree.qza \
       --p-sampling-depth 3000 \
       --m-metadata-file metadata.tsv \
       --p-n-jobs-or-threads 32 \
       --output-dir all-core-metrics-results
```

```bash
```

```bash
```

```bash
```

```bash
```
---


---
## Getting the data

The samples are a subset of the ECAM study, which consists of monthly fecal samples collected from children at birth up to 24 months of life, as well as corresponding fecal samples collected from the mothers throughout the same period
```bash
wget -O dataset.zip "https://qiita.ucsd.edu/public_artifact_download/?artifact_id=81253"
unzip dataset.zip
```

:bulb: It's a good practice to use quotes around URLs as they can contain special characters,
like `&`, that would be interpreted as instructions for the shell.

## Understanding Qiime2 workflow

```bash
 for fileR1 in per_sample_FASTQ/98546/*R1*;
 do
   echo $fileR1
   fastp -i $fileR1 -I ${fileR1/_R1/_R2} -o reads-trimmed/$(basename $fileR1) \
     -O reads-trimmed/$(basename  ${fileR1/_R1/_R2}) -Q -f 17 -F 21 -w 8 \
     -h per_sample_FASTQ/$(basename $fileR1|cut -f1 -d.).html \
     -j per_sample_FASTQ/$(basename $fileR1|cut -f1 -d.).json;
done
```

### Preparing a manifest

```bash
echo -e 'sample-id\tabsolute-filepath' > manifest.tsv
for i in per_sample_FASTQ/81253/*gz;
do
  n=$(basename $i);
  echo -e "${n%.fastq.gz}\t$PWD/$i" >> manifest.tsv;
done
```

```bash
qiime tools import \
       --input-path manifest.tsv \
       --type 'SampleData[SequencesWithQuality]' \
       --input-format SingleEndFastqManifestPhred33V2 \
       --output-path raw-reads.qza
```
```bash
qiime demux summarize \
      --i-data raw-reads.qza \
      --o-visualization raw-reads.qzv
```
### Sequence quality control and feature table construction
```bash
qiime quality-filter q-score \
       --i-demux raw-reads.qza \
       --o-filtered-sequences demux-filtered.qza \
       --o-filter-stats demux-filter-stats.qza
```


####  Denoising with deblur
```bash
qiime deblur denoise-16S \
       --i-demultiplexed-seqs demux-filtered.qza \
       --p-trim-length 150 \
       --p-sample-stats \
       --p-jobs-to-start 4 \
       --o-stats deblur-stats.qza \
       --o-representative-sequences rep-seqs-deblur.qza \
       --o-table table-deblur.qza
```

```bash
qiime deblur visualize-stats \
       --i-deblur-stats deblur-stats.qza \
       --o-visualization deblur-stats.qzv

qiime feature-table tabulate-seqs \
       --i-data rep-seqs-deblur.qza \
       --o-visualization rep-seqs-deblur.qzv

qiime feature-table summarize \
       --i-table table-deblur.qza \
       --m-sample-metadata-file metadata.tsv \
       --o-visualization table-deblur.qzv

```

```bash
wget -O "sepp-refs-gg-13-8.qza" \
    "https://data.qiime2.org/2019.10/common/sepp-refs-gg-13-8.qza"
```

We will use the fragment-insertion tree-building method as described by
_Janssen et al._ (2018) using the sepp action of the `q2-fragment-insertion` plugin,
which has been shown to outperform traditional alignment-based methods with
short 16S amplicon data. This method aligns our unknown short fragments to
full-length sequences in a known reference database and then places them onto
a fixed tree.
Note that this plugin has only been tested and benchmarked on 16S data against
the Greengenes reference database (_McDonald et al._, 2012),
so if you are using different data types you should consider
the alternative methods mentioned below.
```bash
qiime fragment-insertion sepp \
        --i-representative-sequences rep-seqs-deblur.qza \
        --i-reference-database sepp-refs-gg-13-8.qza \
        --p-threads 48 \
        --o-tree insertion-tree.qza \
        --o-placements insertion-placements.qza
```
Once the insertion tree is created, you must filter **your feature table** so that
it only contains fragments that are in the insertion tree.
This step is needed because SEPP might reject the insertion of some fragments,
such as erroneous sequences or those that are too distantly related to the
reference alignment and phylogeny.

Features in your feature table without a
corresponding phylogeny will cause diversity computation to fail, because
branch lengths cannot be determined for sequences not in the tree.
```bash
qiime fragment-insertion filter-features \
       --i-table table-deblur.qza \
       --i-tree insertion-tree.qza \
       --o-filtered-table filtered-table-deblur.qza \
       --o-removed-table removed-table.qza
```


 

## Primary bibliography

* Bolyen, E., Rideout, J.R., Dillon, M.R. et al. (2019) **Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2**. _Nat Biotechnol._ [doi: 10.1038/s41587-019-0209-9](https://doi.org/10.1038/s41587-019-0209-9)
* Estaki, M., Jiang, L., Bokulich, N. A., McDonald, D., González, A., Kosciolek, T., Martino, C., Zhu, Q., Birmingham, A., Vázquez-Baeza, Y., Dillon, M. R., Bolyen, E., Caporaso, J. G., & Knight, R. (2020). **QIIME 2 enables comprehensive end-to-end analysis of diverse microbiome data and comparative studies with publicly available data**. _Current Protocols in Bioinformatics_ [doi: 10.1002/cpbi.100](https://doi.org/10.1002/cpbi.100)
* Kozich JJ, Westcott SL, Baxter NT, Highlander SK, Schloss PD. (2013) **Development of a dual-index sequencing strategy and curation pipeline for analyzing amplicon sequence data on the MiSeq Illumina sequencing platform.** _Appl Environ Microbiol._ [doi: 10.1128/AEM.01043-13](https://doi.org/10.1128/AEM.01043-13) 
