---
layout: post
title:  "Metabarcoding workshop (day 1)"
author: at
categories: [ metabarcoding, 16S, tutorial ]
image: assets/images/green-bact.jpg
hidden: true
---

## Installing Qiime2

The [installation](https://docs.qiime2.org/2021.2/install/native/#install-qiime-2-within-a-conda-environment) is usually performed using Miniconda as a package manager (that will
download the required dependencies). We will use `mamba`, a (faster) drop-in replacement for `conda`.

```bash
wget https://data.qiime2.org/distro/core/qiime2-2021.2-py36-linux-conda.yml
mamba env create -n qiime2-2021.2 --file qiime2-2021.2-py36-linux-conda.yml
# OPTIONAL CLEANUP
rm qiime2-2021.2-py36-linux-conda.yml
```

To activate the environment:
```bash
conda activate qiime2-2021.2
```


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
 echo $fileR1; fastp -i $fileR1 -I ${fileR1/_R1/_R2} -o reads-trimmed/$(basename $fileR1) \
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
