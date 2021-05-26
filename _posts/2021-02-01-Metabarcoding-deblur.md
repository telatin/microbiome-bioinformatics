---
layout: post
title:  "Denoising with Deblur"
author: at
categories: [ metabarcoding, 16S, tutorial ]
hidden: true
---

Deblur is an alternative method to produce
a set of _denoised sequences_. While DADA2 can 
natively support paired-end reads, Deblur can
only manage single-end reads.

We can merge the paired end reads using VSEARCH,
that is available as a Qiime2 plugin

### Merge reads with VSEARCH

The complete documentation of the 
[q2-vsearch](https://docs.qiime2.org/2021.4/plugins/available/vsearch/join-pairs/)
plugin contains all the available parameters.

This subprogram merge the overlapping pairs to produce a set of single-end FASTQ
file, and will work only when the amplicon are designed with the overlap.

```bash
qiime vsearch join-pairs \
     --i-demultiplexed-seqs raw-reads.qza \
     --o-joined-sequences joined-reads.qza \
     --p-threads 8
```

### Sequence quality control and feature table construction

This method filters sequence based on quality scores and the presence of
  ambiguous base calls.

```bash
qiime quality-filter q-score \
      --i-demux joined-reads.qza \
      --o-filtered-sequences joined-filtered.qza \
      --o-filter-stats joined-filter-stats.qza
```


###  Denoising with deblur

Deblur requires to process a set of single end reads
truncated at the same length (which now should be
decided after)

```bash
qiime deblur denoise-16S \
      --i-demultiplexed-seqs joined-filtered.qza \
      --p-trim-length 245 \
      --p-sample-stats \
      --p-jobs-to-start 32 \
      --o-stats deblur-stats.qza \
      --o-representative-sequences rep-seqs-deblur.qza \
      --o-table table-deblur.qza
```

As usual, we can produce visualization artifacts to summarize the content of:

* representative sequences
* denoising statistics
* feature table

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