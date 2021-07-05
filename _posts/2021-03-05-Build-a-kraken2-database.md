---
layout: post
title:  "Build a custom host database for Kraken2"
author: ra
categories: [ metagenomics, tutorial ]
hidden: true
---

In our workshop we proivided a kraken2 database for you to use. 
However, most of the times, you would need to create a database for your own host. 
For the creation of a human database kraken to already provides pre-processed databases. 
But sometimes you need to build a custom database. 
Here we can practise the corona virus genome which is small enough to keep computation times and storage space minimal.


## Custom host (example: corona virus)

If your host is not included in kraken2 databases, this is a little bit more complicated. 
You need to provide your host genome in fasta format. 
We downloaded the corona virus genome for you to try the database creation here `git `

Very important is to add the NCBI taxid for your genome to contig names like `|kraken:taxid|2697049`. To do this we create a folder `coronaDB` to save the modified genome. 

    mkdir ~/coronaDB

Then we add the taxid. We can use _seqfu_ for this:

    seqfu cat --append "|kraken:taxid|2697049" /data/shared/db-genome/NC_045512.2.fasta.gz > ~/coronaDB/NC_045512.2_taxid.fasta

Let's check that the taxid was indeed appended:

    grep ">" ~/coronaDB/NC_045512.2_taxid.fasta

Now you need to add your fasta file to a new database which we named `coronaDB`

    kraken2-build --add-to-library ~/coronaDB/NC_045512.2_taxid.fasta --db ~/coronaDB --threads 4

Next we tell kraken2 to build the taxonomy (this will take a few minutes)

    kraken2-build --download-taxonomy --db ~/coronaDB

And now, we build the database

    kraken2-build --build --db ~/coronaDB

Finally, we need to clean up a little

    kraken2-build --clean --db ~/coronaDB

*Yay!* Now you are ready to use this database for your host decontamination using your own database.

