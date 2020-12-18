---
layout: post
title:  "If, then. Condition checking for Bash scripts"
author: at
categories: [ bash, tutorial ]
image: assets/images/coding.jpg
---

The idea to check if some condition is true before executing some commands is
very simple and useful. The Bash syntax, for historical reasons, is probably
the ugliest you’ll ever see but after a while it will stop scaring you
(and your aesthetic taste).

The general syntax for the if statement is:

```bash
if [[ condition ]]
then
       commands...
else
       other commands...
fi
```

Spaces after the brackets are very important.
Of course there are several conditions that we could be potentially be interested to check,
usually we compare a variable with some content: to do so we must use the
appropriate comparison operators, that are different for strings and numbers:

Spaces after the brackets are very important.
Of course there are several **conditions** that we could be potentially be interested to check,
usually we compare a variable with some content: to do so we must use the
appropriate comparison operators, that are different for strings and numbers:

| Operator | Meaning                             |  Example                       |
|:---------|:------------------------------------|:-------------------------------|
| **>**    | Comes before alphabetically         | `if [[ $a > $b ]]`             |
| **<**    | Comes first alphabetically          | `if [[ cat < dog ]]`           |
| **=**    | Equal (strings)                     | `if [[ $path = "/usr/bin/" ]]` |
| **-lt**  | less than (integers)                | `if [[ 1 -lt 10 ]]`            |
| **-gt**  | greater than (integers)             | `if [[ $number -gt 0 ]]`       |
| **-eq**  | Equal (integers)                    | `if [[ $status -eq 0 ]]`       |
| **-ne**  | Not equal (integers)                | `if [[ $year -ne 2018 ]]`      |
| **-e**   | File exists                         | `if [[ -e "$bam_index" ]]`     |
| **-d**   | File exists, and its a directory    | `if [[ -d "/tmp" ]]`           |
| **-f**   | File exists, and its a regular file | `if [[ -f ~/.bashrc ]]`        |
| **-s**   | File exists and its not empty       | `if [[ -s "$output" ]]`        |


As you can see from the table (but there are [many more](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals)),
there are also operators to test files.
Suppose that the script rely on a database stored in the `$GENOME` variable.
What if the file is not there?
You can test if the file exists before executing the command requiring it:

```bash
if [[ -f "$GenomeReference" ]]
then
       bwa mem -t $Threads $GenomeReference $InputReads > $Output
else
       echo "Genome db not found: $GenomeReference"
       exit
fi
```

If you remember our work-in-progress script to process all the “.sam” files in our current directory and transforming them to BAM files, a small nice touch could be check that the SAM file exists and it’s not empty. This has to be done inside the for loop, so we also see how to nest two different structures:

{% gist 1bde71a8b5aa7562abc6e09b93785d2b %}

Bash support **pattern matching**, that is a “grep like” test on a string.

---

**Exercise**: you are now able to fix a major problem of the above script.
As we mentioned earlier, the shell expansion of `*.sam` works only if there
is at least one file ending by “.sam” in the current directory. If not the
list is not expanded and it will be taken literally as “`*.sam`”,
having samtools to process a nonsense filename…
Using an if statement, you’ll be able to fix the problem.
Try, then [check the solution](https://gist.github.com/telatin/40525157f1a169712030316e181947f5)!
