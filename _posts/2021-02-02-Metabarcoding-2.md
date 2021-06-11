---
layout: post
title:  "Metabarcoding workshop (day 2)"
author: at
categories: [ metabarcoding, 16S, tutorial ]
image: assets/images/green-bact.jpg
---

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

:mag: view artifact: [taxonomy.qzv](https://view.qiime2.org/visualization/?type=html&src=https%3A%2F%2Fdl.dropbox.com%2Fs%2Fzen8877w0qwvezk%2Ftaxonomy.qzv%3Fdl%3D1)

This visualization is relatively raw, but provides an important insight: the confidence of the classification. For some
features we might be interested in performing a manual inspection. We can use _qax_ and _seqfu_ to extract a feature by name:
```
qax view repseqs.qza | seqfu grep -n '0a3cf58d4ca062c13d42c9db4ebcbc53'
```

A more common visualization is provided by the
**bar plots** that requires, in addition to the feature table and the taxonomy, aslo the _metadata file_:

```bash
qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization taxa-bar-plots.qzv
```

:mag: view artifact: [taxa-bar-plots.qzv](https://view.qiime2.org/visualization/?type=html&src=https%3A%2F%2Fdl.dropbox.com%2Fs%2F96au5a96x0m61xp%2Ftaxa-bar-plots.qzv%3Fdl%3D1)

## Diversity analysis

This powerful command will perform a set of analyses starting from:
* The feature table
* The phylogenetic tree of the features (ASVs)
* The metadata file

The output is a set of artifacts which will be placed in the directory specified with 
`--output-dir`. The analyses will produce both output files (_*.qza_) and associated
visualizations (_*.qzv_).

* bray_curtis_distance_matrix.qza
* bray_curtis_emperor.qzv ([:mag: view](https://view.qiime2.org/visualization/?type=html&src=https%3A%2F%2Fdl.dropbox.com%2Fs%2Fr762ann0ezp4x35%2Fbray_curtis_emperor.qzv%3Fdl%3D1))
* bray_curtis_pcoa_results.qza
* evenness_vector.qza
* faith_pd_vector.qza
* jaccard_distance_matrix.qza
* jaccard_emperor.qzv ([:mag: view](https://view.qiime2.org/visualization/?type=html&src=https%3A%2F%2Fdl.dropbox.com%2Fs%2Fkod19si5z6ribws%2Fjaccard_emperor.qzv%3Fdl%3D1))
* jaccard_pcoa_results.qza
* observed_features_vector.qza
* rarefied_table.qza
* shannon_vector.qza
* unweighted_unifrac_distance_matrix.qza
* unweighted_unifrac_emperor.qzv ([:mag: view](https://view.qiime2.org/visualization/?type=html&src=https%3A%2F%2Fdl.dropbox.com%2Fs%2Fmyoes2ac3ms386c%2Funweighted_unifrac_emperor.qzv%3Fdl%3D1))
* unweighted_unifrac_pcoa_results.qza
* weighted_unifrac_distance_matrix.qza
* weighted_unifrac_emperor.qzv ([:mag: view](https://view.qiime2.org/visualization/?type=html&src=https%3A%2F%2Fdl.dropbox.com%2Fs%2F530mxvgnxsvw6z3%2Fweighted_unifrac_emperor.qzv%3Fdl%3D1))
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

#### Key concepts
* Alpha versus beta diversity
   * *Alpha diversity*: Who is there? How many are there?
   * *Beta diversity*: How similar are pairs of samples?

* Weighted and unweighted
 * Unweighted metrics only account for whether an organism is present or absent
 * Weighted metrics account for abundance

* Phylogenetic versus non-phylogenetic metrics
  * non-phylogenetic metrics treat all ASVs as being equally related
  * phylogenetic metrics incorporate evolutionary relationships between the ASVs

:pencil: The program produces _4 artifacts_, which can be viewed (you can use the links above). "Emperor" is
a plug-in to visualize 3D-plots in the browser, allowing to customise the aspect. This plugin is used to plot
the PCoA of **[Beta diversity](https://en.wikipedia.org/wiki/Beta_diversity)** metrices: 
[Bray-Curtis](https://en.wikipedia.org/wiki/Bray%E2%80%93Curtis_dissimilarity#:~:text=In%20ecology%20and%20biology%2C%20the,on%20counts%20at%20each%20site.), Jackard and [Unifrac](https://en.wikipedia.org/wiki/UniFrac) (weighted means that the abundance of 
each feature is taken into account, while unwheighted attempts to simplify the distance in a presence/absence
fashion.)

:pencil: Try to extract the content of one _regular_ artifact to understand how the data is encoded 
(for example _shannon\_vector.qza_). If the artifacts contain a single text file, that can be viewed 
with Qax (e.g. `qax view core-metrics-results/shannon_vector.qza`).


## From Qiime to R

If we adopt the qiime2R package, we can (finally!) generate a PhyloSeq object direcly from our
artifacts.

### Installing the packages

We can create an _ad hoc_ environment that will contain R, and the required packages to import the artifacts:
```
mamba create -n q2import -c rujinlong r-qiime2r r-dplyr

conda activate q2import
```


### Importing

After opening "R" we can create a phyloseq object with a simple command:

```r
library("dplyr")
library("qiime2R")
ps <- qza_to_phyloseq(features="table.qza", tree="rooted-tree.qza", metadata="sample-metadata.tsv", taxonomy="taxonomy.qza")
ps
# phyloseq-class experiment-level object
# otu_table()   OTU Table:         [ 235 taxa and 19 samples ]
# sample_data() Sample Data:       [ 19 samples by 2 sample variables ]
# tax_table()   Taxonomy Table:    [ 235 taxa by 7 taxonomic ranks ]
# phy_tree()    Phylogenetic Tree: [ 235 tips and 233 internal nodes ]
```

### Saving (and reading) the PhyloSeq object to file

This can be useful for sharing our whole experiment as a single file, and also to load it from our
usual "R Studio" setup (with its libraries) if we create it in a server.

```r
saveRDS(ps, file = "phyloseq.rds")

# conversely:
ps <- readRDS(file = "phyloseq.rds")
```