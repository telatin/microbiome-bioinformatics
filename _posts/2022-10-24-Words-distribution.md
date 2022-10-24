---
layout: post
title:  "Word distribution, and example project for Python beginners"
author: at
categories: [ python, distribution, project ]
hidden: false
---

Counting the number of occurrences of each word in a text is a common task in computational linguistics. 
It is also a good example of how to use Python to process text files. 
With this post I hope to set a nice goal for beginners.


## The background

Counting words is trivial, but I'd like to set the wider background on the topic
with this video which summarizes in simple word the main concepts:

[![Video thumbnail](https://img.youtube.com/vi/fCn8zs912OE/3.jpg) Video: The Zipf Mystery (VSauce) ](https://www.youtube.com/watch?v=fCn8zs912OE")

This video can inspire all sort of projects, from simple word counting to more complex plot makers!

## Getting the text files

From GitHub we can download a couple of large text files like:
* [Harry Potter Book 1](https://raw.githubusercontent.com/formcept/whiteboard/master/nbviewer/notebooks/data/harrypotter/Book%201%20-%20The%20Philosopher's%20Stone.txt")
* [Moby Dick](https://gist.githubusercontent.com/StevenClontz/4445774/raw/1722a289b665d940495645a5eaaad4da8e3ad4c7/mobydick.txt)

And if you really want to scale up your project, you can download loads of books from [Project Gutenberg](https://www.gutenberg.org/), like:

```bash
# See https://www.gutenberg.org/policy/robot_access.html#how-to-get-certain-ebook-files
wget -w 2 -m -H "http://www.gutenberg.org/robot/harvest?filetypes[]=txt&langs[]=en"
```

:bulb: note that if each file has a licence at the top/end, some words counts will be inflated (this can be
mitigate by our cleanup code)

## A first attempt

A first task can be to write a script that will print the first *n* words in a text file, sorted by frequency.
To do so, the script should be able to take as input a text file and a number *n*.

We need to:

1. Parse the arguments (see [here](https://realpython.com/lessons/sysargv-in-depth/))
2. [Read the file](https://realpython.com/read-write-files-python/) content as string
3. Split the string into words (for example splitting on spaces, but some polishing would be welcome *i.e.* removing punctuation)
4. Iterating over the words counting each unique occurrence, incrementing values of a dictionary (are "Word" and "word" the same word?)
5. Sorting the dictionary by value (see [this webpage](https://realpython.com/sort-python-dictionary/))
6. Printing the first *n* words

A very simple implementation is [available here (v.0)](https://github.com/telatin/learn_bash/blob/master/scripts/gutenwords_0.py).
For a beginner the only hard part would be to sort the dictionary by value, but from a task-oriented point of view
it's a matter of Googling the task. The first time it will look like magic, but it will bring you closer to your goal,
and with the time you will be able to understand better what's going on.

The output (for Harry Potter's book) is something like:

```text
the     3654    4.39%
and     2139    2.57%
to      1827    2.20%
a       1578    1.90%
Harry   1254    1.51%
of      1233    1.48%
was     1150    1.38%
he      1020    1.23%
in      898     1.08%
his     892     1.07%
```

## Spicing up the code

Some improvements should be made on the starting script:

1. Using the [argparse](https://docs.python.org/3/howto/argparse.html) library for a more robust and flexible argument parsing (v.1)
2. Adding some cleanup on the words, removing punctuation and converting to lowercase. We should use a function for this. (v.1)
3. Adding the possibility to load any number of text files (v.2)

The results are [available here (v1)](https://github.com/telatin/learn_bash/blob/master/scripts/gutenwords_1.py) and [here (v2)](https://github.com/telatin/learn_bash/blob/master/scripts/gutenwords_2.py)

## Going further

A next step can be plotting the results. The output of our script is a three columsn table, which can be 
easily imported in R.

Alternatively, there are also Python libraries for plotting, like [matplotlib](https://matplotlib.org/).


A first script is available as
[`gutenwords-topandplot.py`](https://github.com/telatin/learn_bash/blob/master/scripts/gutenwords-topandplot.py),
which contains a refactoring where we use *generators* to get lines and words. 
A simple histogram plot is also added.

![Example plot](https://raw.githubusercontent.com/telatin/learn_bash/master/files/gutenberg-freq.png)

A more detailed Zipf's law plot is the next step.
There is a **[detailed tutorial](https://www.thepythoncode.com/article/plot-zipfs-law-using-matplotlib-python)**
on how to use make it, and its code has been adapted to our previous scripts as
[`gutenwords-plotzipf.py`](https://github.com/telatin/learn_bash/blob/master/scripts/gutenwords-plotzipf.py).

![Example plot](https://raw.githubusercontent.com/telatin/learn_bash/master/files/gutenberg-plot.png)



