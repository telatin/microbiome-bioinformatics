---
layout: post
title:  "Bioinformatics file formats"
author: at
categories: [ formats ]
image: assets/images/code.jpg
hidden: true
---

> Here we introduce some of the most used bioinformatics formats.

### FASTA format

The FASTA format is used to store one or more sequences, and it's used
for DNA or protein sequences.
Generic extensions include *.fa* and *.fasta*. Some databanks tried to
add extra details with extensions like *.fna* for nucleic acids or 
*.faa* for aminoacidic sequences.

* [FASTA format: a tutorial]({{ site.baseurl }}{% link _posts/2022-03-30-Bash-fasta.md %})
* [FASTA format (Wikipedia)](https://en.wikipedia.org/wiki/FASTA_format)
  
### FASTQ format

The FASTQ format is used to store the output of sequencing machines, and
stores the sequence as determined by the process of "base calling", and
an associated *Phred quality score* for each base.

* [FASTQ format (Wikipedia)](https://en.wikipedia.org/wiki/FASTQ_format)

### BED format

The BED format stores the coordinates of a set of features relative to
a specific reference sequence. In it's simplest incarnation it is just a
TSV (tab-separated values) file with these columns:

1. **Chromosome (sequence) name** (required)
2. **Feature start (0-based)** (required)
3. **Feature end (1-based)** (required)
4. Feature name
5. Score
6. Strand
7. ...

* [BED format (Wikipedia)](https://en.wikipedia.org/wiki/BED_(file_format))
  
### GFF/GTF format

* [GFF/GTF formats (Embl)](https://www.ensembl.org/info/website/upload/gff.html?redirect=no)
  
### SAM format

The Sequence Alignment/Map (SAM) format is a generic format for storing
the output of sequence alignment programs. It is a tab-delimited text
with a header starting with `@` and a body with the alignment records.

You can see a demo SAM file [here](https://gist.github.com/telatin/0e5238286ee1e4a2bda09ecda42cd3f1).


* [SAM format: a first tutorial]({{ site.baseurl }}{% link _posts/2022-03-30-Bash-SAM.md %})
* :book: [SAM format specification (PDF)](https://samtools.github.io/hts-specs/SAMv1.pdf)  

### VCF format

The Variant Call Format (VCF) is a text file format for storing the 
differences of a set of sequenced genomes compared with a reference sequence.
It's header lines start with `##`, and the column names start with `#`.

An example of a VCF file, with its lengthy header and only two variants detected 
is shown below:

{% gist 3d24df591d5e33818854a369feb66b13 %}

* [VCF format (Broad Institute)](https://gatk.broadinstitute.org/hc/en-us/articles/360035531692-VCF-Variant-Call-Format)