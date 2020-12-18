---
layout: post
title:  "Bash script safety net"
author: at
categories: [ bash, tutorial ]
image: assets/images/coding.jpg
---

We can instruct our scripts to stop when a problem is found with the `set -euo pipefail` directive.

In the past articles we introduced some small examples of Bash scripts:
 - [what they are]({{ site.baseurl }}{% link _posts/2019-01-01-Bash-tutorial-1 %}),
 - [how to loop]({{ site.baseurl }}{% link _posts/2019-01-02-Bash-tutorial-2 %}) and
 - [how to check conditions]({{ site.baseurl }}{% link _posts/2019-01-03-Bash-tutorial-3 %}).
The last topic is very important, as it let us make our scripts safer.
Unfortunately checking for every possible error is time consuming,
and the more “_if conditions_” we have to write, the more errors we end to add to our scripts.

Here’s why, before introducing further topics for Bash scripting,
I’d like to introduce a safety net to prevent some common mistakes.

The following script is an hypothetical pipeline looping through _.fastq_ files,
trimming, aligning and finally converting the aligned SAM file to BAM¹.


{% gist 1fb5c5997d4bf20d56f61aa1c65e6a9c %}

## What can possibly go wrong?
- First, there is a typo: we pretend to align **$IPUT**, instead of _$INPUT_. Since the variable was never declared, Bash will not find any value and so will pass to bwa “trimmed_” as filename. That does not exist.
- Suppose that we moved the reference. The variable is valid and contains a value, but the bwa program is not able to perform the alignment and will fail. We will not easily spot the error: the script will go on and convert an empty SAM file into BAM…

The two problems are: using uninitiated (thus empty) variables, and not stopping the script execution if a program fails.

##How can we solve these problems?

Adding a single line at the beginning of the script (just after the shebang):
set -euo pipefail
This instruction² will make the script fail, and exit, when one of the above problems if found. In particular, the switches used are:
- **-e**, will cause the script to exit if a single program fails.
- **-o**, if you use pipes (we did in the past articles), the -e would only be triggered if the last program of the pipe fails. With -o also the other will be checked.
- **-u**, for unbound variables. When this is added, if a variable has not been declared before, the script will fail.
- **-x**, this is not put in the example, but can be useful in some cases: it will cause the script to print every command before executing it. Useful when debugging or testing scripts.

Our script has still an unfixed problem: the “*.fastq” will be expanded only if
we have at least one .fastq
file in our current directory. To solve this we can add this directive:

```bash
shopt -s failglob
```

It’s a directive that — similarly to “_set -euo pipefail_” will be active throughout
the whole script, and will make the script fail when a shell expansion fails.

## Check if a variable is set

If you use the -u switch, and you didn’t define a variable,
checking if it has a value will cause the script to terminate, unless you check
it with the following syntax:

{% gist c737f960ee64a047507d6f37827ee980 %}

## Safety net make life harder

You know this from everyday experience: sometimes a safety device (like a lab coat)
requires extra time and steps and for small tasks, we believe we can simply skip it.
As a beginner, you’ll find most of the safety nets to create more problems than the
one they solve and you might be tempted never using them. I perfectly understand
this feeling, being myself a beginner in many topics, but it’s important to — at
least — being aware of the possible problems that not using a safety net could bring.

_Presented at the lecture on Metagenomics Analysis, [La Sapienza — Rome, December 2018](https://www.instagram.com/p/BrQbXGunDSn/?utm_source=ig_web_copy_link)_
