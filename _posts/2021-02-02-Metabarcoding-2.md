---
layout: post
title:  "Metabarcoding workshop (day 2)"
author: at
categories: [ metabarcoding, 16S, tutorial ]
image: assets/images/green-bact.jpg
---

Yesterday we introduced the whole workflow to analyze 16S reads, and the powerful framework that Qiime2
introduced that:

* ensures reproducibility with tightly controlled Conda environments
* enforces descriptive commands (no short options, and self descriptive plug-in names)
* introduces a new file package (the "artifact" [_sic_]) that propagates metadata and allows for type check
* and more!

Today we will complete our first tutorial adding a taxonomy classification using a classifier, and exploring the diversity of the samples with an _all-in-one_ Qiime plugin.

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

:bulb: the very same table is stored in text format in the _data artifact_, so you can view it from the 
terminal - for example - with this command:
```
qax view taxonomy.qza | less -S -x 20
```

This visualization is relatively raw, but provides an important insight: 
the confidence of the classification (_i. e._ the confidence at the last reported rank). 

For some features we might be interested in performing a manual inspection. 
We can use _qax_ and _seqfu_ to extract a feature by name, for example as:
```
qax view repseqs.qza | seqfu grep -n '0a3cf58d4ca062c13d42c9db4ebcbc53'
```

A more common visualization is provided by the
**bar plots** that requires, in addition to the 
feature table and the taxonomy, also the _metadata file_:

```bash
qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization taxa-bar-plots.qzv
```

:mag: view artifact: [taxa-bar-plots.qzv](https://view.qiime2.org/visualization/?type=html&src=https%3A%2F%2Fdl.dropbox.com%2Fs%2F96au5a96x0m61xp%2Ftaxa-bar-plots.qzv%3Fdl%3D1)
Note how you can make use of the metadata to order your samples.

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

#### Exploring the output
:pencil:  The program produces _4 artifacts_, which can be viewed (you can use the links above). "Emperor" is
a plug-in to visualize 3D-plots in the browser, allowing to customise the aspect. This plugin is used to plot
the PCoA of **[Beta diversity](https://en.wikipedia.org/wiki/Beta_diversity)** metrices: 
[Bray-Curtis](https://en.wikipedia.org/wiki/Bray%E2%80%93Curtis_dissimilarity#:~:text=In%20ecology%20and%20biology%2C%20the,on%20counts%20at%20each%20site.), Jackard and [Unifrac](https://en.wikipedia.org/wiki/UniFrac) (weighted means that the abundance of 
each feature is taken into account, while unwheighted attempts to simplify the distance in a presence/absence
fashion.)

:pencil:  Try to extract the content of one _regular_ artifact to understand how the data is encoded 
(for example _shannon\_vector.qza_). If the artifacts contain a single text file, that can be viewed 
with Qax (e.g. `qax view core-metrics-results/shannon_vector.qza`).

:book: An in-depth tutorial (based on Python, with with great explanations in plain English) [is available here](http://readiab.org/book/latest/3/1#1).

## From Qiime to R

If we adopt the qiime2R package, we can (finally!) generate a PhyloSeq object direcly from our
artifacts. This transition involves two worlds: the command line where we ran Qiime2 (usually a powerful remote server) and RStudio in a workstation with a GUI (Mac, Windows, or Linux).

1) If our RStudio has the library _qiime2R_, or if we can/want to install it, 
we can simply transfer the relevant artifacts and metadata to our workstation.
2) If we want to use _qiime2R_ in the remote server we can use the command line interface (as the GUI is not reqlly required) as described below
3) We can extract the artifacts content and import those (ase described after "qiime2R")
4) We can also use Dadaist from our server to create the phyloseq object (see at the end)

### qiime2R

[Qiime2R](https://rdrr.io/github/jbisanz/qiime2R/man/qza_to_phyloseq.html) is a nice R library
that allows to create a PhyloSeq object directly from the Qiime 2 artifacts.  It's a nice addition
to your RStudio set of libraries, and I recommend to install it as it simplifies the workflow from
the server where Qiime 2 generated the artifacts to your statistical explorarion and analysis of
the data.

#### Installing qiime2R in our server (headless)
We can create an _ad hoc_ environment that will contain R, and the required packages to import the artifacts.
The package _r-qiime2r_ is available from the developer's channel (rujinlong), but misses _dplyr_ for full 
functionality so we will install that as well (from _conda-forge_). _qax_ can also help.
```
mamba create -n q2import -c conda-forge -c bioconda -c rujinlong r-qiime2r r-dplyr qax

conda activate q2import
```

#### Importing artifacts using _qiime2R_

In our _q2import_ environment we have R, qiime2R and of course phyloseq.

:warning: _qiime2R_ requires the metadata to be in "Qiime 2" format (with an extra line after the header),
like this [sample-metadata.tsv](https://gist.github.com/telatin/7b5b2e86eeef59db4b13ec42d98acb3b#file-sample-metadata-tsv).
Qiime metadata is forward compatible, meaning that Qiime 2 itself can accept Qiime 1 metadata files.

After opening "R" (type `R` from the environment) we can create a phyloseq object with a simple command:

```r
# These are "R" commands, not to be typeed from the shell prompt
library("dplyr")
library("qiime2R")
ps <- qza_to_phyloseq(features="table.qza", tree="rooted-tree.qza", metadata="sample-metadata.tsv", taxonomy="taxonomy.qza")

# Check the ps object
ps
# phyloseq-class experiment-level object
# otu_table()   OTU Table:         [ 235 taxa and 20 samples ]
# sample_data() Sample Data:       [ 20 samples by 3 sample variables ]
# tax_table()   Taxonomy Table:    [ 235 taxa by 7 taxonomic ranks ]
# phy_tree()    Phylogenetic Tree: [ 235 tips and 233 internal nodes ]
# refseq()      DNAStringSet:      [ 235 reference sequences ]
```

#### Saving (and reading) the PhyloSeq object to file

This can be useful for sharing our whole experiment as a single file, and also to load it from our
usual "R Studio" setup (with its libraries) if we create it in a server.

```r
# Save an object to file
saveRDS(ps, file = "phyloseq.rds")
```

:bulb: Then you can move the _phyloseq.rds_ file to the location with you RStudio environment and,
from RStudio:
```
# load an object from file
ps <- readRDS(file = "phyloseq.rds")
```

## Importing without qiime2R

PhyloSeq is able to load a very broad range of formats, so there are many
ways to import files. I came up with the following procedure, but there are 
probably better alternatives (suggestions welcome).

The taxonomy is in a "peculiar format", so we will combine it with the feature
table to have a more compact _table with taxonomy_. 

From the bash we can prepare the text files:

```bash
# Prepare table
qax extract table.qza
biom convert --to-tsv -i table.biom -o table.raw
tail -n +2 table.raw > table.tsv

# Taxonomy
qax extract taxonomy.qza
cut -f 2 taxonomy.tsv | sed '1s/Taxon/Consensus Lineage/' > taxonomy.column

# Combine taxonomy and matrix
paste table.tsv taxonomy.column > table-tax.tsv

# Extract tree and sequences
qax extract repseqs.qza
qax extract rooted-tree.qza
```

Then an "R script" as follows (call it `import.R`):

```R
library("phyloseq")
data = import_qiime("table-tax.tsv", "sample-metadata.tsv", "rooted-tree.nwk", "repseqs.fasta")
data
saveRDS(data, file = "phyloseq.rds")
```

to be executed as:
```
Rscript --vanilla import.R
```

### The Dadaist way

:bulb: Dadaist2 has [a script](https://quadram-institute-bioscience.github.io/dadaist2/pages/dadaist2-importq2.html)
automating this process called `dadaist2-importq2`. 
This feature was added recently
and will be improved in future releases. At the moment will save the PhyloSeq object (only).

```
dadaist2-importq2 --feature-table table.qza \
  --tree rooted-tree.qza  \
  --metadata sample-metadata.tsv  \
  --rep-seqs repseqs.qza  \
  --taxonomy taxonomy.qza \
  --output-phyloseq qiime-phyloseq.rds \
  --verbose
```