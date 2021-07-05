---
layout: post
title:  "Generating Krona plots from Kraken data"
author: at
categories: [ metagenomics, tutorial ]
hidden: true
---


![krona]({{ site.baseurl }}{% link assets/images/krona.png %})

[Krona](https://github.com/marbl/Krona/wiki) is a tool to generate interactive HTML plots of hierarchical data.
Before importing metagenomics data, its useful to try the tool with a minimal example.

### Installing Krona

As usual we can use conda to install Krona:

```
conda install -c bioconda krona
```

The only difference is that - if we pay attention to the installation messages - we need to type
an extra command at the end to download the taxonomy database (this requires an Internet connection):

```
ktUpdateTaxonomy.sh
```

### Generating a first Krona plot

We can create a minimal _tsv_ file to test how Krona works creating a syntetic TSV file
with (at least) two columns: **counts** and [**NCBI TaxonomyID**](https://www.ncbi.nlm.nih.gov/taxonomy).
 
{% gist ce32a5ba207ebe50c6f14f89919c9168 %}

now we can generate a first plot with:
```
ktImportTaxonomy -m 1 -o krona-test.html input.tsv 
```

By default, the column where to take the taxonomy is the second, while we specify the
"magnitude" with `-m 1`, as we used the first column to store the _raw counts_.

:mag: The output is [available here]({{ site.baseurl }}{% link data/krona/krona-test.html %})


### Generating the Krona plot from Kraken or Bracken reports

If we examine out minimal file we had two relevant columns:
* counts (`-m`)
* NCBI Taxonomy ID (`-t`)

In a Kraken report, these are in columns 3 and 5, respectively:

```
ktImportTaxonomy -t 5 -m 3 -o krona.html Kraken.report 
```

Krona can also work on multiple samples:

```
ktImportTaxonomy -t 5 -m 3 -o multi-krona.html *.report 
```

:bulb: Kraken keep track of the unclassified reads, while we loose this datum with Bracken.

### Citation

Ondov, B.D., Bergman, N.H. & Phillippy, A.M. [Interactive metagenomic visualization in a Web browser](https://doi.org/10.1186/1471-2105-12-385). BMC Bioinformatics 12, 385 (2011). 