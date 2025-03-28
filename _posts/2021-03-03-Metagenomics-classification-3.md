---
layout: post
title:  "Taxonomic profiling of whole metagenome shotgun (day 3)"
author: ra
categories: [ metagenomics, tutorial ]
image: assets/images/xray-bact.jpg
---

## An introduction to the "Tidyverse"

We saw this morning that a coherent ecosystem of libraries, called [the tidyverse](https://www.tidyverse.org), is 
available for R, that makes our life easier when doing data analysis.

You can check the worked example we had using the [ChickWeight dataset]({{ site.baseurl }}/data/tidyverse/).
Resources:
* [:book: **R for Data Science**](https://r4ds.had.co.nz/index.html)
* [A slideshow on the tidyverse](https://oliviergimenez.github.io/intro_tidyverse/#13)
* [Slides and R markdown](https://github.com/LukaIgnjatovic/DataCamp_-_Track_-_Data_Scientist_with_R_-_Course_03_-_Introduction_to_the_Tidyverse)

## Joining data from the command line

We saw how to _join_ tabular data from the command line, producing a table with
the raw counts, the counts after host removal and the counts after filtering:
```
Sample,Reads,NoHost,Filtered
Sample13,1000000,989840,938220
Sample22,1000000,758380,678168
Sample25,1000000,972564,913842
Sample30,1000000,944690,879807
Sample31,1000000,983343,901878
Sample3,1000000,989295,915797
Sample4,1000000,982321,905794
Sample6,1000000,920125,827941
```

The result was saved to a file called `/data/shared/Rfiles/filtering.csv`, and you
will find the instructions to generate it here:

* [Joining tutorial]({{ site.baseurl }}{% link _posts/2021-03-10-Join-tables.md %})


## Explore your Kraken/Bracken data in R

 
:information_source: You can either work with R studio on your local computer or with our R studio servers. 

### Plot read counts

As a firt warm up in R let's explore some of the read statistics. 
You just created a table `filtering.csv` from your data. 
We will import this table into R and create a plot to visualize the data.

If you have not created the table you can find it also here

    /data/shared/Rfiles/filtering.csv

Make sure you copy it over or specify the correct path when importing into R.

Follow these commands in Rstudio to create the plot

:question: [Exercise 1]({{ site.baseurl }}/data/kraken-r/Explore_readtable_exercise.html)

And here you can see the solutions

:envelope: [Solution 1]({{ site.baseurl }}/data/kraken-r/Explore_readtable_solutions.html)

### Check classified and host reads across samples

Now let's explore some of the read statistics from kraken.

We need a metadata file which can be found here

    /data/shared/Rfiles/metadata_sub.csv

We are also using the two files `classification_counts.csv` and `hostread_counts.csv` that you created in yesterdays session. 
If you haven’t created those files, then we provided these files for you here:

    /data/shared/Rfiles/classification_counts.csv

    /data/shared/Rfiles/hostread_counts.csv

Make sure you copy these files to your current working directory or specify 
the correct path to the file when importing into the R studio server.
If you are copying the files to your local computer you can copy the entire 
folder `/data/shared/Rfiles` which will also contain the files for the next exercise.

When you are all set up follow the instruction in the following R markdown

:question: [Exercise 2]({{ site.baseurl }}/data/kraken-r/2021-03-30-Explore_readQ_exercise.html)

We also provided you with the output and solutions, so you know how this should look like. 

:envelope: [Solution 2]({{ site.baseurl }}/data/kraken-r/2021-03-31-Explore_readQ_solutions.html)


### Let's analyse bracken relative abundances in R

To make the R exploration more fun, we supply you with a slightly larger dataset. This dataset has undegone the same workflow as your own data, but including more samples. After you run this with our dataset, you can also go back to your dataset and play with it as well in a similar way. We need a metadata file and the merged bracken relative abundance table.

For now use the following data:

    /data/shared/Rfiles/metadata_extended.csv

    /data/shared/Rfiles/merged_rel_abund_extended.csv

Either download them to your local computer to work with your own RStudio installation or make sure in the server you specify the correct path.

Then, when you are ready, follow the exercises in the markdown. 

Here we will

- Import and explore the data
- Plot community composition
- Explore beta diversity and compare samples from different groups
- Have a sneak peak on species that are differentially abundant between groups

:question: [Exercise 3]({{ site.baseurl }}/data/kraken-r/2021-03-32-ExploreMGprofiles_exercise.html)

We also provided you with the output and solutions, so you know how this should look like. 

:envelope: [Solution 3]({{ site.baseurl }}/data/kraken-r/2021-03-33-ExploreMGprofiles_solutions.html)