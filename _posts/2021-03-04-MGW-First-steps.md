---
layout: post
title:  "Warming up: welcome to our server"
author: at
categories: [ metagenomics, tutorial ]
hidden: true
---



### First steps
1. Log in into the server
2. You should find a directory called `sequences` in your home.
3. List the files in that directory <span class="spoiler">(for example with **ls -l ~/sequences**)</span>
4. The files are compressed, we will try not to decompress them as it's a good practice in metagenomics (to save lots of disk space and time)
5. To count the sequences in FASTA files, we can use grep or dedicated tools.
   * Try with `grep` first <span class="spoiler">(for example with **zcat FILE | grep -c '>'**, or **cat FILE | gzip -d | grep -c \\>** if _zcat_ is not available)</span>
   * We have SeqFu installed in our machine, so we can test `seqfu stats --nice sequences/*gz`.

### A finished bacterial genome

1. The file `GCF_000027325.fasta.gz` contains a finished bacterial genome, as we saw from the stats it's a single sequence.
2. Print the name of the first sequence<span class="spoiler">,for example with **zcat ./sequences/GCF_000027325.fasta.gz | grep  \\>**</span> 
3. _(Optional)_ Now print the first lines of the file, and copy a small portion (~200 nucleotides) in a new file in FASTA format, 
calling it `~/sequences/myco-bit.fa`, and calling the sequence itself `Seq1`.
   * You can use the `nano` editor - that is widely available in most servers - or an improved alternative called `micro`.

### Making symbolic links

* Sometimes it's useful to make in our favourite locations a _link_ to files existing elsewhere. Remember that the link will break if we move/remove the source file.
We have an Illumina paired end sample stored in `/data/cami/simple_R1.fq.gz` (and its corresponding R2). The command to make symbolic links is `ln -s SOURCE DESTINATION`.

Try:

```
ln -s /data/cami/simple_* ~/sequences/
```

* With `ls -l`, note how symbolic links are rendered.
* SeqFu has tools resembling the GNU commands but for sequences, like `seqfu head`, `seqfu tail`, `seqfu grep`, plus other utilities. Try `seqfu head`.
* Count the reads present in the files,for example with `seqfu count sequences/simple*`
   * This command can take some time, why don't we save its output to a file instead: `seqfu count sequences/simple_* > sequences/simple_counts.txt &` (the final `&` will send the process to the background)
* We now want to make a subsample. To do this we can use `seqfu head --skip 10 FILE > SUBSAMPLED`. Let's try a "for loop":

```
mkdir subsampled

for FQFILE in sequences/simple_R*; 
do 
   echo $i; 
   seqfu head --skip 10 $FQFILE > subsampled/$(basename $FQFILE); 
done
```

