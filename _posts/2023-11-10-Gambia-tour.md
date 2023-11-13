---
layout: post
title:  "A very short bioinformatics tutorial using CLIMB notebooks"
author: at
categories: [ climb ]
image: assets/images/laptop.jpg
hidden: false
---

This walkthrough can be completely performed on any Linux terminal where Miniconda/Mamba have been installed, including a web based terminal offered by [CLIMB BIG DATA](https://climb.ac.uk) new notebooks.

:arrow_right: Check the documentation for the [CLIMB Notebooks](https://docs.climb.ac.uk)

## Summary

This workshop is a brief bioinformatics tutorial that covers several key steps in the analysis of bacterial sequencing data. Here's a concise summary of the content:

Getting the Data:

Obtain raw sequencing data in FASTQ format from publicly available sources.
Download paired-end sequencing data for two bacterial samples, "Sample1" and "Sample2," and store them in a "data" directory.
Creating the Environment:

* Create a dedicated conda environment (e.g., "bactdemo") for bioinformatics tools.
  * Install necessary tools like skesa, seqfu, multiqc, quast, kraken2, and fastp within the environment.
  * Activate the created environment for isolation and effective management of analysis dependencies.

* Counting the Raw Reads:
  * Use SeqFu to perform statistics on the raw sequencing data.
  * Generate MultiQC-compatible statistics for the data, saving the results in a "stats_mqc.txt" file.
  * Quality Filtering:

* Utilize Fastp to remove sequencing adapters and low-quality reads from the raw data.
  * Create a new directory for trimmed data, and apply Fastp to both "Sample1" and "Sample2" datasets.

* Running Kraken2:
  * Profile the raw reads with Kraken2 to screen for contamination.
  * Set a default Kraken2 database path and run Kraken2 on both "Sample1" and "Sample2" datasets.
  * Store the Kraken2 reports in a "kraken" directory.

* *De Novo* Assembly:
  * Perform de novo assembly of the sequencing reads using Skesa.
  * Create an output directory for the assembled contigs and assemble both "Sample1" and "Sample2" datasets.

* Assembly Metrics Evaluation:
  * Evaluate the quality of the genome assembly using Quast.
  * Generate various metrics, including the number of large contigs, N50, and the number of predicted genes, for the assembled contigs.
  * Save the Quast results in a "quast" directory.

* Creating a Report:
  * Use MultiQC to create an HTML report summarizing various aspects of the analysis.
  * The report includes information on read counts, Kraken profiling, and Quast assembly metrics.

Throughout the workshop, specific commands and tools are provided, allowing participants to follow along and perform each step of the analysis. Additionally, external resources and links are provided for further reference and in-depth understanding of the tools and concepts involved in the analysis. A final HTML report can be generated to visualize and share the results of the analysis.

## Workshop

### Getting the data

One of the initial steps in most analyses is obtaining the raw sequencing data.

In this tutorial, we will use publicly available FASTQ files as input data for our bacterial isolate assembly. 
These FASTQ files contain the DNA sequencing reads that we will later assemble into a genome.

The code provided below demonstrates how to create a directory for the output and then download the FASTQ files for two bacterial samples. 
These samples, referred to as "Sample1" and "Sample2," represent the paired-end sequencing data, which typically consists of two files per sample: one for the forward reads (R1) and another for the reverse reads (R2).

```bash
# Create a directory for the output
mkdir -p data/

curl --silent -L "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR128/099/SRR12825099/SRR12825099_1.fastq.gz" -o "data/Sample1_R1.fastq.gz"
curl --silent -L "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR128/099/SRR12825099/SRR12825099_2.fastq.gz" -o "data/Sample1_R2.fastq.gz"
curl --silent -L "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR129/042/SRR12971242/SRR12971242_1.fastq.gz" -o "data/Sample2_R1.fastq.gz"
curl --silent -L "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR129/042/SRR12971242/SRR12971242_2.fastq.gz" -o "data/Sample2_R2.fastq.gz"
        
```

Here's a breakdown of what each part of the code does:

* `mkdir -p data/`: This command creates a directory named "data" where we will store the downloaded sequencing data. The `-p` flag is to avoid complaints if the directory already exists.

* `curl`: The curl command is used to download files from the internet. It retrieves the specified FASTQ files from the provided FTP URLs and saves them with appropriate names in the "data" directory.

* `--silent` and `-L`: These options are used with **curl** to make the download process silent (no progress information) and to follow redirects if the URLs provided point to other locations.

### Creating the environment


In a CLIMB notebook you will find conda and mamba pre-installed, but you will need to create a dedicated environment for your tools (i.e. you will not be able to install programs on the "base" environment).

Creating a dedicated conda environment for your bioinformatics tools is a good practice to isolate dependencies and manage your analysis environment effectively. 


Let's expand on the process of creating the environment and activating it:

```bash
mamba create -n bactdemo skesa seqfu multiqc quast kraken2 fastp
conda activate bactdemo
```

Here's what each part of the code does:

* `mamba create -n bactdemo`: This command creates a new conda environment named "bactdemo." You can replace "bactdemo" with a name of your choice if needed.

* `skesa seqfu multiqc quast ...`: These are the names of the packages (bioinformatics tools) that you want to install within the "bactdemo" environment. Adjust this list as necessary to include the specific tools you need for your bacterial isolate assembly.

* `conda activate bactdemo`: Activating the environment ensures that you are working within the isolated environment and have access to the tools installed in that environment. You should see the environment name in your command prompt, indicating that you are now working within the "bactdemo" environment.

By creating and activating this dedicated environment, you can keep your analysis environment clean and organized, making it easier to manage dependencies and run your bioinformatics tools effectively for bacterial isolate assembly.

:arrow_right: To know more about [conda](https://telatin.github.io/microbiome-bioinformatics/Install-Miniconda/)


### Counting the raw reads

[SeqFu](https://telatin.github.io/seqfu2) is a FASTQ/FASTA toolkit with several subcommands, including *stats*:

```bash
seqfu stats --multiqc data/stats_mqc.txt data/*R1*gz
```

* `seqfu stats`: This part of the command invokes the seqfu tool to perform statistics on the specified input data.

* `--multiqc data/stats_mqc.txt`: The --multiqc flag indicates that you want to generate MultiQC-compatible statistics. The results will be saved to a file named "stats_mqc.txt" in the "data" directory. MultiQC is a tool for creating summarized reports from different bioinformatics analyses.

* `data/*R1*gz`: This part of the command specifies the input files for read counting and statistics generation. data/*R1*gz is a file glob pattern that matches files in the "data" directory with names containing "R1" and ending in ".gz," typically representing the forward reads of paired-end sequencing data.

:arrow_right: To know more about [seqfu](https://telatin.github.io/seqfu2)

### Quality filter

Fastp is a powerful and user-friendly tool in the realm of bioinformatics, designed specifically for the efficient and precise removal of sequencing adapters and low-quality reads from raw sequencing data. As part of the data preprocessing pipeline, Fastp employs advanced algorithms to identify and trim adapter sequences, ensuring that only high-quality reads are retained for downstream analysis. By streamlining this crucial step, Fastp not only enhances the accuracy and reliability of subsequent analyses but also significantly reduces the computational resources and time required for data processing. Its versatility and ease of use make Fastp an invaluable asset for researchers and bioinformaticians working with next-generation sequencing data, facilitating the generation of clean and reliable datasets for a wide range of genomic and transcriptomic studies.

```bash
mkdir -p trimmed

# This is a single command split across multiple lines! Copy/paste the full command!
fastp --detect_adapter_for_pe --json trimmed/Sample1.json -w 4 -q 20 \
  -i data/Sample1_R1.fastq.gz -I  data/Sample1_R2.fastq.gz \
  -o  trimmed/Sample1_R1.fastq.gz -O trimmed/Sample1_R2.fastq.gz 

# This is another single command split across multiple lines!
fastp --detect_adapter_for_pe --json trimmed/Sample2.json -w 4 -q 20 \
  -i data/Sample2_R1.fastq.gz -I  data/Sample2_R2.fastq.gz \
  -o  trimmed/Sample2_R1.fastq.gz -O trimmed/Sample2_R2.fastq.gz 
```

:arrow_right: To know more about [fastp](https://github.com/OpenGene/fastp/)

### Running Kraken2

We can profile the raw reads with a metagenomics profiler to screen for contamination.
We will use a compact database, and not every read can be assigned to the species level even in ideal circumstances (think about sequences like prophages, transposons...), but if we find a relative high amount of unexpected classifications this may require some further investigaation.

```bash
# Create a directory to store Kraken2 reports
mkdir -p kraken

# Set the default Kraken2 database path
export KRAKEN2_DEFAULT_DB=/shared/public/db/kraken2/k2_standard_08gb/

# Run Kraken2 for Sample1
kraken2 --threads 4 --paired --report kraken/Sample1.tsv trimmed/Sample1_R{1,2}.fastq.gz > /dev/null

# Run Kraken2 for Sample2
kraken2 --threads 4 --paired --report kraken/Sample2.tsv trimmed/Sample2_R{1,2}.fastq.gz > /dev/null
```

This is how we ran kraken2:
* To specify the database (to be used multiple times) we used the `export  KRAKEN2_DEFAULT_DB=/path/to/database` command, which writes the path in an environment variable.
* `--threads 4`: Specifies the number of CPU threads to use for the analysis. You can adjust this number based on your system's capabilities.
* `--paired`: Indicates that the input data consists of paired-end reads.
* `--report kraken/Sample1.tsv`: Specifies the path where the Kraken2 report will be saved. In this case, it's saved as "kraken/Sample1.tsv."
* `data/Sample1_R{1,2}.fastq.gz`: Specifies the input FASTQ files for "Sample1," which are the forward and reverse reads.
* `> /dev/null`: This part of the command redirects the standard output to /dev/null, effectively suppressing any verbose output from Kraken2. This can be helpful when running Kraken2 in a script or when you don't need to see the detailed classification results on the console.

:arrow_right: To know more about [kraken2](https://ccb.jhu.edu/software/kraken2/)

### *De novo* assembly

*De novo* assembly is a computational process in genomics and bioinformatics that involves reconstructing the complete genome or a significant portion of it from raw sequencing data, such as DNA sequencing reads. Unlike reference-based assembly, where existing reference genomes are used as templates for alignment, de novo assembly is performed without prior knowledge of a closely related reference genome.

Here we use **Skesa** to assemble the reads.

:hourglass: This step can require several minutes
```bash
# Create output directory
mkdir -p contigs

# Assemble Sample1
skesa --cores 4 --reads trimmed/Sample1_R1.fastq.gz,data/Sample1_R2.fastq.gz > contigs/Sample1.fasta

# Assemble Sample2
skesa --cores 4 --reads trimmed/Sample1_R1.fastq.gz,data/Sample1_R2.fastq.gz > contigs/Sample2.fasta
```

:arrow_right: To know more about [genome assembly with short reads](https://www.illumina.com/Documents/products/technotes/technote_denovo_assembly_ecoli.pdf) and [skesa](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwij18bJ976CAxXITKQEHWwBCPsQFnoECBgQAQ&url=https%3A%2F%2Fgithub.com%2Fncbi%2FSKESA&usg=AOvVaw2hOhnjrZq0IToKEJB8ChC6&opi=89978449).
### Assembly metrics evaluation 

Evaluating the quality of a genome assembly is a crucial step in any genome sequencing project. One commonly used tool for assessing assembly quality is Quast (Quality Assessment Tool for Genome Assemblies). Quast provides a comprehensive set of metrics and visualizations to help researchers gauge the accuracy and completeness of their genome assembly.  

```bash
mkdir -p quast
quast -o quast/ -t 4 contigs/*.fasta
```

Quast will create a PDF report and some TSV tables with various metrics, in particular:

* Number of large contigs (i.e., longer than 500 bp) and total length of them.
Length of the largest contig.
* N50 (length of a contig, such that all the contigs of at least the same length together cover at least 50% of the assembly).
* Number of predicted genes, discovered either by GeneMark.hmm (for prokaryotes), GeneMark-ES or GlimmerHMM (for eukaryotes), or MetaGeneMark (for metagenomes).
:arrow_right: To learn more about [quast](https://github.com/ablab/quast).

### Creating a report

We can use [MultiQC](https://multiqc.info) to create an HTML report of:
* reads counts
* Kraken profiling
* Quast output

```bash
multiqc -o report data/ trimmed/ kraken/ quast/
```

In the report directory you will find the [html report](https://ifrqmra-tower-zero.s3.climb.ac.uk/report.html).
