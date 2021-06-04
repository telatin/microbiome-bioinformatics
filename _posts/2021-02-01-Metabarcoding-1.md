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

If we don't have `conda` installed and available, we first need to
[install Miniconda]({{ site.baseurl }}{% link _posts/2021-01-01-Install-Miniconda.md %}).

## Installing Qiime2 (2021.4)

The [installation](https://docs.qiime2.org/2021.2/install/native/#install-qiime-2-within-a-conda-environment) 
is usually performed using Miniconda as a package manager 
(that will download the required dependencies).
We will use `mamba`, a (faster) drop-in replacement for `conda`.

```bash
wget https://data.qiime2.org/distro/core/qiime2-2021.4-py38-linux-conda.yml
mamba env create -n qiime2-2021.4 --file qiime2-2021.4-py38-linux-conda.yml
rm qiime2-2021.4-py38-linux-conda.yml
```

To activate the environment:
```bash
conda activate qiime2-2021.4
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
significantly, both in the R1 and in the R2 reads.

```bash
qiime dada2 denoise-paired \
      --i-demultiplexed-seqs reads.qza \
      --p-trunc-len-f 235 \
      --p-trunc-len-r 154 \
      --p-n-threads 32 \
      --o-table table.qza \
      --o-representative-sequences repseqs.qza \
      --o-denoising-stats dada-stats.qza
```

:information_source:
An alternative method to denoise the sequences is **Deblur**, that we cover in 
a [separate page]({{ site.baseurl }}{% link _posts/2021-02-01-Metabarcoding-deblur.md %}).

## Tree

```bash
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences repseqs.qza \
  --o-alignment aligned-repseqs.qza \
  --o-masked-alignment masked-aligned-repseqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza
  ```

## Taxonomy 
```bash
wget "https://data.qiime2.org/2021.4/common/silva-138-99-515-806-nb-classifier.qza"

qiime feature-classifier classify-sklearn \
  --i-classifier gg-13-8-99-515-806-nb-classifier.qza \
  --i-reads repseqs.qza \
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

### Taxonomy (alternative)

```bash
wget -O "sepp-refs-gg-13-8.qza" \
    "https://data.qiime2.org/2021.4/common/sepp-refs-gg-13-8.qza"
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
        --i-representative-sequences repseqs.qza \
        --i-reference-database sepp-refs-gg-13-8.qza \
        --p-threads 1 \
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
       --i-table table.qza \
       --i-tree insertion-tree.qza \
       --o-filtered-table filtered-table-deblur.qza \
       --o-removed-table removed-table.qza
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

## Bibliography

* Bolyen, E., Rideout, J.R., Dillon, M.R. et al. (2019) **Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2**. _Nat Biotechnol._ [doi: 10.1038/s41587-019-0209-9](https://doi.org/10.1038/s41587-019-0209-9)
* Estaki, M., Jiang, L., Bokulich, N. A., McDonald, D., González, A., Kosciolek, T., Martino, C., Zhu, Q., Birmingham, A., Vázquez-Baeza, Y., Dillon, M. R., Bolyen, E., Caporaso, J. G., & Knight, R. (2020). **QIIME 2 enables comprehensive end-to-end analysis of diverse microbiome data and comparative studies with publicly available data**. _Current Protocols in Bioinformatics_ [doi: 10.1002/cpbi.100](https://doi.org/10.1002/cpbi.100)
