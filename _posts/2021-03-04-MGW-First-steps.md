---
layout: post
title:  "Warming up: welcome to our server"
author: at
categories: [ metagenomics, tutorial ]
hidden: true
---



1. Log in into the server
2. You should find a directory called `sequences` in your home.
3. List the files in that directory <span class="spoiler">(for example with `ls -l ~/sequences`)</span>
4. The files are compressed, we will try not to decompress them as it's a good practice in metagenomics (to save lots of disk space and time)
5. To count the sequences in FASTA files, we can use grep or dedicated tools.
   1. Try with `grep`first <span class="spoiler">`zcat FILE | grep -c '>'`</span>
   2. We have SeqFu installed in our machine, so we can test `seqfu stats --nice sequences/*gz`.