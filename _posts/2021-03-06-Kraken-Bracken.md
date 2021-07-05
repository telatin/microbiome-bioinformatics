---
layout: post
title:  "Running Kraken and Bracken with a script"
author: at
categories: [ metagenomics, tutorial ]
hidden: true
---

A more complex script to perform a 
[**for loop**](https://telatin.github.io/articles/02-bash.html)
is available from GitHub as shown below:

{% gist fa79d013707a293c0c3ff019abc7313d %}

## Some notes on how to make a script

This script requires a parameter from the user (the _input directory_). 
Bash will store the first variable in `$1`. 
If the script is launched without any argument, 
we should check that the first variable is not 
set, we should warn the user:

```bash
# Let's check if the user supplied a variable name
if [  -z ${1+x} ]; then
  echo "This script requires a parameter: directory (with paired reads)"
  exit 1
fi
```

* See [how to check if a variable is set](https://telatin.github.io/articles/06-bash.html)

## Introducing some checks

If the database is not where we think it is, Kraken will fail. 
We can check that `hash.k2d` is present in the directory. This is 
one of the _three_ files composing a Kraken database.

Bracken has some extra files, that are _read length_ dependent,
so we should also check that Bracken can run.

```bash
# Let's check the Database is present
if [[ ! -e "$DB"/hash.k2d ]]; then
  echo "Kraken2 database not found at $DB"
  exit 1
fi

if [[ ! -e "$DB"/database${READLEN}mers.kmer_distrib ]]; then
  echo "Bracken database not found at $DB/database${READLEN}mers.kmer_distrib"
  exit 1
fi
```

* See how to write [**if statements**](https://telatin.github.io/articles/03-bash.html)

## A for loop to run Kraken and Bracken

As usual we prepare a [**for loop**](https://telatin.github.io/articles/02-bash.html),
manipulating the variables:
 * Replacing "_R1" with "_R2" to get the second pair 
   * :warning: this should be changed if our files have different tags
 * Truncating the _basename_ on the first underscore to get the Sample name

```bash
for FILE1 in $1/*_R1*;
do
  FILE2=${FILE1/_R1/_R2}
  BASE=$(basename $FILE1  |  cut -f1 -d_)
  echo "Sample: $BASE (input files: $FILE1 and $FILE2)"
done   
```

## Safety net

If kraken fails, what is the point of running Kraken?
This is why we have the `set -euo pipefail` instruction.

* See [more about the **safety net**](https://telatin.github.io/articles/04-bash.html)