---
layout: post
title:  "A simple workflow with USEARCH"
author: at
categories: [ metabarcoding, 16S, tutorial ]
---

## What is USEARCH
**[USEARCH](https://drive5.com/usearch/) is a popular package for metabarcoding analyses
developed by Robert Edgar, and (partially) described in a set of [papers](https://drive5.com/usearch/manual/citation.html).


## Preprocessing


:bulb: USEARCH does not accept compressed files as input, so you will need to `gunzip` any
compressed files.


The first step is to merge the paired ends with [fastq_mergepairs](https://drive5.com/usearch/manual/merge_options.html).
```
usearch -fastq_mergepairs reads/*R1* -relabel @ -fastq_maxdiffs 20 -fastqout merge.fq -threads 12
```

We can check the average merged read size with SeqFu:
```
seqfu stats --nice merge.fq
```

To remove low quality reads, we can use [fastq_filter](https://drive5.com/usearch/manual/cmd_fastq_filter.html).
Here we set a maximum number of expected errors (calculated using the quality scores), and a minimum length (in this case
from the hypothesis that 16S is very conserved in length and a big variation is usually due to errors).
```
usearch -fastq_filter merge.fq -relabel filt -fastq_maxee 0.7 --fastq_minlen 200 -fastq_maxns 0 -fastaout filtered.fa -threads 12
```

We need to discard the duplicate reads with [fastx_uniques](https://drive5.com/usearch/manual/cmd_fastx_uniques.html), 
but we must keep track of how many duplicates each read had (`-sizeout)
```
usearch -fastx_uniques filtered.fa -fastaout uniq.fa -sizeout
```

## Representative sequences

USEARCH famously offers a **clustering algorithm**, but recently ships also a **denoising method** called UNOISE3: we can either perform an OTU picking or an ASV detection.
We will try the latter.
```
usearch -unoise3 uniq.fa -zotus asv.fa
```

## OTU Table
Generation of a _feature table_. This is done mapping the merged reads to the representative sequences, and thus requires that
the merged reads were relabeled prepending the sample ID to each read name (see the merging step with `-relabel @`).
This can be a time consuming step.
```
usearch -otutab merge.fq -db asv.fa -otutabout otutab_raw.tsv 
```

## What to do next?

USEARCH can be used for:
* [Taxonomy classification](https://drive5.com/usearch/manual/taxonomy.html) (requires formatting of the database or [downloading](https://drive5.com/usearch/manual/sintax_downloads.html) one)
* [Diversity analysis](https://drive5.com/usearch/manual/pipe_diversity.html)
* and more...