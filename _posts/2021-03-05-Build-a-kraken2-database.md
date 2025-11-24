---
layout: post
title:  "Build a custom host database for Kraken2"
author: ra
categories: [ metagenomics, tutorial ]
hidden: true
---

In our workshop we provided a Kraken2 database for you to use. However, most of the time, you would need to create a database for your own host. For the creation of a human database, Kraken2 already provides pre-processed databases.
But sometimes you need to build a custom database. 

Here we can practice with the coronavirus genome which is small enough to keep computation times and storage space minimal.

## Custom host (example: coronavirus)

Let's create a custom database for the SARS-CoV-2 coronavirus (NCBI RefSeq: NC_045512.2).


### Adding taxonomy information

Kraken2 requires NCBI taxonomy IDs in sequence headers to correctly classify reads. The format is `|kraken:taxid|TAXID` appended to each sequence name. For SARS-CoV-2, the taxid is 2697049.

First, create a directory for the database:

```bash
# Create directory for the custom database
mkdir ~/coronaDB
```

Then append the taxid to sequence headers using _seqfu_:

```bash
# Append taxid to sequence headers
seqfu cat --append "|kraken:taxid|2697049" /data/shared/db-genome/NC_045512.2.fasta.gz > ~/coronaDB/NC_045512.2_taxid.fasta
```

Verify the modification worked:
```bash
# Verify the taxid was added to headers
grep ">" ~/coronaDB/NC_045512.2_taxid.fasta
```

You should see the header now includes `|kraken:taxid|2697049`.

### Building the database

Add the genome to the database library:

```bash
# Add genome to library
kraken2-build \
  --add-to-library ~/coronaDB/NC_045512.2_taxid.fasta \
  --db ~/coronaDB \
  --threads 4
```

Download the NCBI taxonomy tree (required for classification):

```bash
# Download NCBI taxonomy
kraken2-build --download-taxonomy --db ~/coronaDB
```

This downloads `taxdump.tar.gz` and creates the taxonomy structure.

Build the k-mer database (this is the most time-consuming step):

```bash
# Build the Kraken2 database
kraken2-build --build --db ~/coronaDB --threads 4
```

This creates the hash table and minimizer database used for classification.

Clean up intermediate files to save disk space:

```bash
# Remove intermediate files to save space
kraken2-build --clean --db ~/coronaDB
```

This removes downloaded taxonomy files and temporary data, keeping only the final database.

### Using your custom database

To classify reads and separate host from non-host sequences:

```bash
# Classify reads and remove host sequences
kraken2 --db ~/coronaDB \
  --threads 4 \
  --unclassified-out host_removed#.fastq \
  --classified-out host_classified#.fastq \
  --paired input_R1.fastq input_R2.fastq
```

The `#` symbol is replaced with `_1` and `_2` for paired-end reads. Unclassified reads (non-host) go to `host_removed_*.fastq`, while classified reads (host) go to `host_classified_*.fastq`.

## Notes

- Replace `2697049` with your organism's NCBI taxid (find it at [NCBI Taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy))
- For larger genomes, increase memory and threads accordingly
- The database size scales with genome complexity and k-mer diversity