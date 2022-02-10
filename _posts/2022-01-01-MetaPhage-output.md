---
layout: post
title:  "Metaphage"
author: at
categories: [ nextflow  ]
image: assets/images/code.jpg
hidden: true
---

## What is MetaPhage

MetaPhage is a Nextflow pipeline for viromics analyses (more info coming soon).

### Running the pipeline with a test dataset

1. Download the required databases using `db_manager.py` supplied in the repository. We will save them in the `./db` subdirectory of the repository
2. Either create the conda environment or use a Singularity image (we will use the latter)
3. Download the example dataset (for example using `get_example.py`)
4. Update the configuration file with the paths of your system as documented in the pipeline manual
5. Run the pipeline `nextflow run main.nf --readPath $DIR --metaPath $DIR`

### Output report

:star: [Pipeline report]({{ site.baseurl }}{% link attachments/metaphage/index.html %}): we will design a simple workflow to assemble and annotate microbial genomes


### Pipeline execution introspection

* [Nextflow execution report]({{ site.baseurl }}{% link attachments/metaphage/report.html %})
* [Nextflow timeline]({{ site.baseurl }}{% link attachments/metaphage/timeline.html %})