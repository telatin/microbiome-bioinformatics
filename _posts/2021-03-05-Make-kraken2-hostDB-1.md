
# Kraken2 - Build custom host database (optional)

In this case above we proivided a kraken2 database for you to use. However, most of the times, you would need to create a database for your own host. 

## 1. Human host 

For human reads this is easy ans kraken2 is well prepared. 

Let's create a folder for the database

    mkdir ~/kraken2_human_db

Now download the human library (this will take a while a couple of minutes)

    kraken2-build --download-library human --db kraken2_human_db/ --threads 4

Download NCBI tax info (this will take a while a couple of minutes)

    kraken2-build --download-taxonomy --db kraken2_human_db/

Build the database

    kraken2-build --build --db kraken2_human_db/ --threads 4

Clean up to save space
    
    kraken2-build --clean --db kraken2_human_db/


## 2. Custom host (example: mouse)

If your host is not included in kraken2 databases, this is a little bit more complicated. You need to provide your host genome in fasta format. We downloaded the mouse genome for you here `/data/db/kraken2/mouse_GRCm39/GCF_000001635.27_GRCm39_genomic.fna`

Very important is to add the NCBI taxid to contig names like `|kraken:taxid|10090`. To do this we create a folder `mouseDB` to save the modified genome. 

    mkdir ~/mouse_GRCm39

Then we add the taxid.

    sed 's/ Mus/\|kraken:taxid\|10090 Mus/g' /data/db/kraken2/mouse_GRCm39/GCF_000001635.27_GRCm39_genomic.fna > ~/mouse_GRCm39/GCF_000001635.27_GRCm39_genomic_taxid.fna

Check for the first contig in the mouse genome that this is the case:

    grep ">" ~/mouse_GRCm39/GCF_000001635.27_GRCm39_genomic_taxid.fna | head -1

Now you need to add your fasta file to a new database which we named `mouse_GRCm39`

    kraken2-build --add-to-library ~/mouse_GRCm39/GCF_000001635.27_GRCm39_genomic_taxid.fna --db ~/mouse_GRCm39 --threads 5

Next we tell kraken2 to build the taxonomy

    kraken2-build --download-taxonomy --db ~/mouse_GRCm39

And finally, we build the database

    kraken2-build --build --db ~/mouse_GRCm39

*Yay!* Now you are ready to use this database for your host decontamination using your own database.

---
