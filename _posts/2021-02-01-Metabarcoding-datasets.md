---
layout: post
title:  "Metabarcoding datasets (16S, ITS)"
author: at
categories: [ metabarcoding, 16S, tutorial ]
hidden: true
---


## Mothur MiSeq SOP

:bar_chart: The dataset contains 20 samples, sequenced Paired-End.

:book: Kozich JJ, _et al._ (2013)
**Development of a dual-index sequencing strategy and curation pipeline for analyzing amplicon sequence data on the MiSeq Illumina sequencing platform**.
Applied and Environmental Microbiology.

:package: Available from [Mothur Wiki](https://mothur.org/wiki/miseq_sop/)

```bash
# Subsample
wget "https://mothur.s3.us-east-2.amazonaws.com/wiki/miseqsopdata.zip"
```




## Mouse diet (16S)

Diet-induced obesity (DIO) is proposed to cause impairments in intestinal barrier integrity, but contradictory results have been published and it appears that the outcomes depend on other environmental factors. We therefore assessed whether the hygienic status of animal facilities alters the gut barrier in DIO mice.

:bar_chart: The dataset contains 478 samples, sequenced single ended (**V4** region).

:book: Müller VM _et al._ (2016)

**Gut barrier impairment by high-fat diet in mice depends on housing conditions**.
Mol Nutr Food Res. [doi](https://doi.org/10.1002/mnfr.201500775).

:package: ENA [PRJEB13041](https://www.ebi.ac.uk/ena/browser/view/PRJEB13041) - a TSV file with the reads URIs can be found [here](https://github.com/telatin/microbiome-bioinformatics/releases/download/2021.6/mouse-reads.tsv)



## ECAM Study (16S, large dataset)

The samples are a subset of the ECAM study (that is used for variouse Qiime2 tutorials),
which consists of monthly fecal samples collected from children at birth up to
24 months of life, as well as corresponding fecal samples collected from the
mothers throughout the same period.

:warning: This is a Single End dataset, so at the moment it's not supported by Dadaist.

:bar_chart: The dataset contains 24 samples, sequenced Paired-End (**V3-V4** region).

:book: Bokulich NA, _et al._. (2016)
**Antibiotics, birth mode, and diet shape microbiome maturation during early life**.
Sci Transl Med.  [doi](https://doi.org/10.1126/scitranslmed.aad7121).

:package: Available from QIITA: [project 12802](https://qiita.ucsd.edu/study/description/12802)

```bash
wget -O dataset.zip "https://qiita.ucsd.edu/public_artifact_download/?artifact_id=81253"
unzip dataset.zip
```
