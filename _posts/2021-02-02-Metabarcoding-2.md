---
layout: post
title:  "Metabarcoding workshop (day 2)"
author: at
categories: [ metabarcoding, 16S, tutorial ]
image: assets/images/green-bact.jpg
---

Yesterday we analysed a well-known dataset with Qiime 2, producing a set of artifacts
containing everything needed to perform a _diversity analysis_.

This powerful command will perform a set of analyses starting from:
* The feature table
* The phylogenetic tree of the features (ASVs)
* The metadata file

The output is a set of artifacts which will be placed in the directory specified with 
`--output-dir`. The analyses will produce both output files (_*.qza_) and associated
visualizations (_*.qzv_).

* bray_curtis_distance_matrix.qza
* bray_curtis_emperor.qzv
* bray_curtis_pcoa_results.qza
* evenness_vector.qza
* faith_pd_vector.qza
* jaccard_distance_matrix.qza
* jaccard_emperor.qzv
* jaccard_pcoa_results.qza
* observed_features_vector.qza
* rarefied_table.qza
* shannon_vector.qza
* unweighted_unifrac_distance_matrix.qza
* unweighted_unifrac_emperor.qzv
* unweighted_unifrac_pcoa_results.qza
* weighted_unifrac_distance_matrix.qza
* weighted_unifrac_emperor.qzv
* weighted_unifrac_pcoa_results.qza

The command is:
```
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 3000 \
  --m-metadata-file sample-metadata.tsv \
  --output-dir core-metrics-results
```

:pencil: The program produces _4 artifacts_, which can be viewed.

:pencil: Try to extract the content of one _regular_ artifact to understand how the data is encoded (for example _rarefied\_rable.qza_).