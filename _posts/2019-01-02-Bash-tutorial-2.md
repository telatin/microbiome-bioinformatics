---
layout: post
title:  "for loops in Bash scripting"
author: at
categories: [ bash, tutorial ]
image: assets/images/coding.jpg
---

After a small [introduction]({{ site.baseurl }}{% link _posts/2019-01-02-Bash-tutorial-2.md %}) to Bash scripting,
we finally create a first bioinformatics script…
introducing one of the **loops** we can use with the shell.
A loop is a structure that allows to perform a set of commands a number of times.

The **for loop**, specifically, iterates the commands using a list of terms. Here and example of the syntax:

{% gist 9633dbeaa5afc6c81571a52f3623be26 %}

You can see the highlighted keywords: _for, in, do, done_.
The loop works using a list of elements (in the example three names),
a variable that each time will contain each item of the list, and finally a set
of instructions (commands) to be executed, between do and done.

Indenting these commands is not required, but make the code clearer.

## A real world example
When you have a list of SAM files and you want to convert all of them in (sorted)
BAM format, you have a good example of when a for loop can come to use:

{% gist 55fc0523ecf6cde0a7ea48ce445640c3 %}

Line 5 assign to a variable the total number of .sam files in the current directory (see previous post).
Line 8 declares the for loop, using `$SamFile` as variable, and `*.sam` instead of the list.
This works because the shell will expand this writing to a list of file name¹.

In this script we see a new way of retrieving the content of a variable: `${Variable}` instead of `$Variable`,
that allows us to concatenate the content with other strings².

## “Find and replace” inside a variable
The script has an annoying bug: if we have a file called alignment.sam,
it will create a BAM file called alignment.sam.bam.
This because we simply added “.bam” at the end of the filename.

Bash has a feature called variable substitution. It works with this syntax `${VariableName/WhatToFind/Replacement}`:

```
variable='Hello World!'
echo ${variable/World/Universe}
```

To see this in action we have a small example:

{% gist ed49059220bbf1ad7ba93d73713409e5 %}

## Now try yourself!

Use the variable substitution as shown in the above example to fix the “all_sam_to_bam.sh” script,
and have it creating nicer output file names!
If you want to see the solution, [have a look here](https://gist.github.com/telatin/e82050c1d1831281beb40ef70886c222).

_Norwich, 2018–02–22_

---

¹ This script has a problem here: if there are no files in the directory, the shell expansion will not work. We will fix this later!

² If we have a variable called Variable and its content is “NAME” and we want to print the string “NAME2”, how can we do this? If we type:
```
echo "$Variable2"
```
The shell will try to look for the content of a variable called “Variable2”, that does not exist. Here the correct version:
```
echo "${Variable}2"
```
