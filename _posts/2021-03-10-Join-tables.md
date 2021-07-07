---
layout: post
title:  "Join tabular files"
author: at
categories: [ metagenomics, tutorial ]
hidden: true
---

When performing multiple operations on the same dataset, as some of you pointed out 
during the workshop, we often want to collate metadata.
R is the ideal choice for doing so, but also the command line can help.

We will prepare a table summarising:
* The raw reads number
* The reads number after host removal
* The reads number after quality filter


## Preparing the data

We will use a command (`join`) that can zip files sharing an identifier. In order
to do so the files must have the same column and in the same order.

In our workshop directory we have the three directories, let's check their content with:

```
ls reads
ls reads-no-host
ls filt
```

We can see that the second folder has a slightly different naming scheme (`_1` instead of `_R1`).

### How to count the reads

We can count the reads of each directory. Let's practice first with one:

```bash
seqfu count filt/*.gz
```

The output is:
```
filt/Sample4_R1.fq.gz   905794  Paired
filt/Sample6_R1.fq.gz   827941  Paired
filt/Sample13_R1.fq.gz  938220  Paired
filt/Sample22_R1.fq.gz  678168  Paired
filt/Sample3_R1.fq.gz   915797  Paired
filt/Sample25_R1.fq.gz  913842  Paired
filt/Sample30_R1.fq.gz  879807  Paired
filt/Sample31_R1.fq.gz  901878  Paired
```

We clearly are interested in the first two columns, but also we are not intereted in the path (`filt/`) as it would 
make the identifier different. _SeqFu_ has an option to fix this (`-b`).

### Counting with a loop

```
for DIR in reads reads-no-host filt;
do
  seqfu count -b $DIR/*.gz  |  cut -f 1,2 | sort   | sed 's/_1/_R1/' > ${DIR}.counts
done
```

## How join works

Join can only work with two files:

```
join reads.counts reads-no-host.counts
```

The output will be:
```
Sample13_R1.fq.gz 1000000 989840
Sample22_R1.fq.gz 1000000 758380
Sample25_R1.fq.gz 1000000 972564
Sample30_R1.fq.gz 1000000 944690
Sample31_R1.fq.gz 1000000 983343
Sample3_R1.fq.gz 1000000 989295
Sample4_R1.fq.gz 1000000 982321
Sample6_R1.fq.gz 1000000 920125
```

So we can use an intermediate file:
```
join reads.counts reads-no-host.counts > tmp.txt

Then we can prepare the header line, and add the columns after manipulating the strings a little bit,
so that we convert the space to comma and we strip the suffix:
```
echo 'Sample,Reads,NoHost,Filtered' > table.csv
join tmp.txt filt.counts | sed 's/ /,/g'  | sed 's/_R1.fq.gz//' >> table.csv
```