---
layout: post
title:  "Bash script getting parameters from the users"
author: at
categories: [ bash, tutorial ]
image: assets/images/coding.jpg
---


> A basic introduction on passing parameters to shell scripts

Our [simple script]({{ site.baseurl }}{% link _articles/02-bash.md %})
converting all files from SAM to BAM assumes they all are in
the current directory, that is we first we need to enter into it,
then execute the script. What if we want to supply the **directory path** to the script?

There are some special variables created by Bash when a script is executed.
The **$#** variable contains the number of arguments received.
Then each argument is inside variables **$1**, **$2**, …
The fifth parameter is, of course, **$5**.

A simple example:

{% gist 3b6db7b657bfa370392854642c7fbb20 %}

Letting our script to receive parameters prompt us to check that they are consistent and valid: the user can always type a mistake, and this should be checked before executing the script real commands.

To expand our script that converts SAM files to BAM, we can pretend to receive a single argument, the directory containing the .sam files we want to process. We can then decide what to do if nothing is passed: for this example, I decided to keep the original behavior (that is assuming that the current directory is to be processed).

If a parameter is passed, it’s important to check that its a valid directory with the `-d` operator:

{% gist 429e58f23c48c105badb17204f9b286e %}

As you can see with some simple concepts we have been able to draft a fairly simple script that performs some commands and — perhaps more importantly — checks that everything is going as expected.

## Further steps

What if we expect three parameters and the user provided only two? It is possible to check the number of parameters passed with $#, but this will become soon limiting when you’ll want to implement also optional parameters.
A tutorial on a more advanced argument parsing is soon to come.

_Norwich, Mar 9, 2018. Originally [published here](https://medium.com/ngs-sh/bash-script-getting-parameters-from-the-users-part-5-104fca1c2937)_
