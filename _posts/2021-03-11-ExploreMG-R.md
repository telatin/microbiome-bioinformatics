# Explore your data in R

You can either work with R studio on your local computer or with our R studio servers. 

## Check classified and host reads across samples

As a firt warm up in R let's explore some of the read statistics from kraken.

We need a metadata file which can be found here

    /data/shared/Rfiles/metadata_sub.csv

We are also using the two files `classification_counts.csv` and `hostread_counts.csv` that you created in yesterdays session. If you haven’t created those files, then we provided these files for you here:

    /data/shared/Rfiles/classification_counts.csv

    /data/shared/Rfiles/hostread_counts.csv

Make sure you copy this file to your current working directory or specify the correct path to the file when importing into the R studio server.
If you are copying the files to your local computer you can copy the entire folder `/data/shared/Rfiles` which will also contain the files for the next exercise.

When you are all set up follow the instruction in the following R markdown

[Exercise 1]({{ site.baseurl }}/data/kraken-r/2021-03-30-Explore_readQ_exercise.html)

We also provided you with the output and solutions, so you know how this should look like. 

[Solution 1]({{ site.baseurl }}/data/kraken-r/2021-03-31-Explore_readQ_solutions.html)


## Let's analyse bracken relative abundances in R

To make the R exploration more fun, we supply you with a slightly larger dataset. This dataset has undegone the same workflow as your own data, but including more samples. After you run this with our dataset, you can also go back to your dataset and play with it as well in a similar way. We need a metadata file and the merged bracken relative abundance table.

For now use the following data:

    /data/shared/Rfiles/metadata_extended.csv

    /data/shared/Rfiles/merged_rel_abund_extended.csv

Either download them to your local computer to work with your own RStudio installation or make sure in the server you specify the correct path.

Then, when you are ready, follow the exercises in the markdown

[Exercise 2]({{ site.baseurl }}/data/kraken-r/2021-03-32-ExploreMGprofiles_exercise.html)

We also provided you with the output and solutions, so you know how this should look like. 

[Solution 2]({{ site.baseurl }}/data/kraken-r/2021-03-33-ExploreMGprofiles_solutions.html)