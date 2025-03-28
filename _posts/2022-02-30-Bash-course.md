---
layout: post
title:  "Linux Command Line for Bioinformatics"
author: at
categories: [ bash, tutorial ]
image: assets/images/code.jpg
hidden: false
---

> A tutorial on the Linux command line (CLI) and its use in bioinformatics.



## Programme

- :one: [The first commands]({{ site.baseurl }}{% link _posts/2022-03-01-Bash-1.md %}) - Open a terminal and start trying the first commands (like *pwd*, *cd*, *mkdir*, *man*, *wget*) and familiarise with absolute and relative paths.
- :two: [Text files and the command line]({{ site.baseurl }}{% link _posts/2022-03-02-Bash-2.md %}) - Some more commands (like *find*), and a first look at text files and their manipulation (*wc*, *head*, *tail*, *grep*).
- :three: [Redirection]({{ site.baseurl }}{% link _posts/2022-03-03-Bash-3.md %}) - how to save the output from programs, and the difference between *standard output* and *standard error*.
- :four: [Pipes]({{ site.baseurl }}{% link _posts/2022-03-03-Bash-4.md %}) - combining multiple commands with UNIX pipes
- :five: [IGV: A quick overview]({{ site.baseurl }}{% link _posts/2022-03-22-IGV.md %}) - Using IGV to inspect common file formats
- :six: [SSH and remote servers]({{ site.baseurl }}{% link _posts/2022-03-04-Bash-ssh.md %}) - Working on a remote server from the command line or using VS Code
- :seven: Some file formats:
  - [FASTA files]({{ site.baseurl }}{% link _posts/2022-03-30-Bash-fasta.md %}) - how sequences are stored in FASTA files
  -  [SAM files]({{ site.baseurl }}{% link _posts/2022-03-30-Bash-SAM.md %}) - the Sequence Alignment/Map format, and how to manipulate it with *samtools*
  -  [A list of common formats]({{ site.baseurl }}{% link _posts/2022-03-29-Bash-formats.md %})

See also:
- :page_with_curl: [Miniconda and Mamba]({{ site.baseurl }}{% link _posts/2021-01-01-Install-Miniconda.md %}) - Solving the dependency hell of bioinformatics software (and how to install Miniconda and Mamba to do this)
- :book: [Bash learning resources]({{ site.baseurl }}{% link _posts/2022-03-31-Bash-resources.md %}) - Links to other resources to learn Bash
- :star: [A bonus track on word frequencies]({{ site.baseurl }}{% link _posts/2022-10-24-Words-distribution.md %}) - Zipf distribution: a video worth watching and the invite to try analyzing texts to see if they follow Zipf's law