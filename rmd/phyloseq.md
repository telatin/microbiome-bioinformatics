---
title: "CLIMB Big Data 16S Workshop - Day 3"
author: "Rebecca Ansorge, Andrea Telatin"
output:
  html_document:
    df_print: paged
  pdf_document: default
---

## Exploring (and plotting) our PhyloSeq object

First, let's import our libraries:
```{r}
library(phyloseq)
library(ggplot2)
```

Then, with a single command (and a single file involved) we can load our experiment,
as the phyloseq object contains:

* Metadata
* Feature table
* Taxonomy
* Tree

```{r}
my_physeq <- readRDS("tutorial/phyloseq.rds")
```

### Counts per sample
Our metadata contains the _raw reads_ per sample, but the feature table is
the product of several steps, each can result in some data loss.
We can add a column with the sum of the feature counts:

```{r}
# Sum the values of the feature table (columns)
my_sums <- as.data.frame(sample_sums(my_physeq), optional=FALSE, col.names=c("1"))

# Give to the column a user-friendly name
colnames(my_sums)<-"sample_sums"

# Plot
ggplot(my_sums, aes(x=row.names(my_sums),y=sample_sums)) + 
  geom_point() +
  theme(
    axis.text.x = element_text(angle = 45, hjust=1)
  ) +
  xlab("Samples") + ylab("Counts") + ggtitle("Mothur SOP: Counts per sample")
```

### Alpha diversity
We start our data exploration by plotting alpha diversity metrics. Phyloseq has a range of metrics to choose from and it depends on your question and dataset which of the metrics you want to know. For these metrics you should always use the raw counts and NOT relative abundances. One thing that is influencing alpha diversity estimates is library size. We saw in the initial data exploration that library size (sample sums) differed quite a lot for some of the samples. To have the datasets more comparable we can rarefy the data, meaning we reduce the sample sums to the count of the sample with the lowest count. If your data contain some samples with very low counts, this is not always advisable as you will loose a lot of information. In this case however, most samples are in a similar range, and we have only a few higher outliers, so we decide to rarefy.

```{r}
# rarefy 
my_physeq_rare <- rarefy_even_depth(my_physeq, sample.size = min(sample_sums(my_physeq)), rngseed = 19)
```

Our new phyloseq object should be evenly populated. Let's check:
```{r}
# check rarefication effect on library size 
my_rsums<-as.data.frame(sample_sums(my_physeq_rare), optional=FALSE, col.names=c("1"))

colnames(my_rsums)<-"sample_sums"

# Plot
ggplot(my_rsums, aes(x=row.names(my_rsums),y=sample_sums)) + 
  geom_point() +
  theme(
    axis.text.x = element_text(angle = 45, hjust=1)
  ) +xlab("Samples") + ylab("Counts") + ggtitle("Mothur SOP: Rarefaction")
```
We fist plot an overview of 4 alpha diversity measures and color the data by our metadata category ‘Time’. Note: We receive a warning that there are no signletons in the data. This is not automatically a problem but it is important to pay attention to these warnings to make sure, the data haven’t been filtered or otherwise pre-processed.


```{r}

# plot multiple alpha diversity measures and color by metadata
my_alpha <- plot_richness(my_physeq_rare, 
                          measures = c("Observed", "Chao1", "Shannon"), 
                          color="Timepoint") 

```

The great thing about the plots created by phyloseq, is that they are customizable as normal ggplot objects. So you can easily adjust these plots according to your need. For example we can now add a title and caption to the plot.

```{r}
# customize plot using ggplot features
my_alpha + 
  ggtitle("Alpha diversity - overview") + 
  labs(caption = "Alpha diversity calculated on unfiltered data (Features with 0 counts in all samples were removed)")
```
Especially, when having a lot of samples, we might want to compare the alpha diversity between groups of samples. 

For example here we group by ‘Timepoint’ groups and ‘Mock’ dataset.


```{r}
# group samples
my_alpha2 <- plot_richness(my_physeq_rare, 
                           measures = c("Observed"), 
                           x="Timepoint", 
                           color = "Timepoint") 
my_alpha2 
```
And again we can add additional ggplot layers, such as a violon plot.


```{r}
# add ggplot layers
my_alpha2 + 
  geom_violin(fill=NA)
```


### Taxonomic profiles

To plot the taxonomic profiles, we can transform the counts into relative abundances. It is possible to do additional filtering to remove los abundant taxa, certain samples, or to just keep the top taxa. Information on how to do this can be found [https://joey711.github.io/phyloseq/preprocess.html](https://joey711.github.io/phyloseq/preprocess.html).

```{r}
# transform counts to relative abundances
my_physeq_rel <- transform_sample_counts(my_physeq, function(ASV) ASV / sum(ASV))
```
To produce stacked bar charts, we need to choose the taxonomic level that we are interested in and agglomerate the OTUs belonging to the sampe taxon.

Stacked bar chart at Phylum level:


```{r}
# agglomerate at Phylum level
my_phyla <- tax_glom(my_physeq_rel,taxrank = "Phylum")

# stacked bar plot for Phyla 
my_bar_phyla <- plot_bar(my_phyla, fill="Phylum") + 
  scale_fill_discrete(na.value="grey90") + 
  ggtitle("Relative abundances at Phylum level") 
my_bar_phyla
```

Stacked bar chart at **Class** level:

```{r}
# agglomerate at Class level
my_class <- tax_glom(my_physeq_rel,taxrank = "Class")

# stacked bar plot for Class 
my_bar_class <- plot_bar(my_class, fill="Class") + 
  scale_fill_discrete(na.value="grey90") + 
  ggtitle("Relative abundances at Class level") 
my_bar_class
```

Another way to plot the relative abundances, can be bubble plots. These are useful, if you want to add more information. Also, it might be easier to separate more taxa in one plot, as a bar plot with too many colors get hard to read. To create a bubble plot we have to tweak phyloseq a little bit, as this plot is not implemented by default.

We first agglomerate data at **Genus** level and then create a bar plot object

```{r}
my_genera = tax_glom(my_physeq_rel, "Genus")
my_bar_gen <- plot_bar(my_genera) 
```

Then we have to remove the plot layer itself (since we don’t want a stacked bar chart).

```{r}
my_bar_gen$layers <- my_bar_gen$layers[-1]
```

Now we need to add our plot layer using ggplot2. 

First, we will save a variable `maxC` that contains the maximum relative abundance 
for a single genus to help us create an appropriate size legend in the plot. 

Then, we create and customize the actual plot itself. 
Even though we are showing the *genuses* we can add extra information as color (or shape). 
In this case we *color by phylum* and can therefore clearly see that most detected Genera 
belong to the *Firmicutes* Phylum. 

Finally, we split the plot into separate facets by metadata category.

```{r}
# sets maximum relative abundance for figure legend dimensions
maxC<-max(otu_table(my_genera)) 

# replace with bubble plot instead of bars
my_bubble_gen <- my_bar_gen + 
    geom_point(aes_string(x="Sample", y="Genus", size="Abundance", color = "Phylum"), alpha = 0.7) +
    scale_size_continuous(limits = c(0.001,maxC)) +
    xlab("Sample") +
    ylab("Genus") +
    ggtitle("Relative abundances at Genus level") + 
    labs(caption = "Abundances below 0.001 were considered absent")

# Plot
my_bubble_gen +
  facet_grid(. ~ Timepoint, scales = "free_x", space="free")
```

### Beta diversity

To visualize how dissimilar or dissimilar the taxonomic composition is between samples, 
we can do an **ordination**.
Phyloseq offers a range of distance metrics and ordination methods and it depends on your data which one is the most appropriate to use. 

Here we will use an MDS/PCoA ordination on Bray-Curtis dissimilarities. For other options see instructions [here](https://joey711.github.io/phyloseq/plot_ordination-examples.html).

We first create the ordination, 
then plot the ordination and finally customize the plot by increasing symbol size.
  
```{r}
# Bray-curtis MDS
my_ordination <- ordinate(my_physeq_rel, 
                    method="MDS", 
                    distance="bray")

# Prepare plot
my_pcoa <- plot_ordination(my_physeq_rel, 
                           my_ordination, 
                           color="Timepoint")

# Plot!
my_pcoa + 
  geom_point(size=3)
```

We can see in the above ordination plot that the Mock sample is driving a lot of the separation.
But the **Mock** sample is more of a control and we are not actually interested in this sample. We want to know the difference between time points. 
In this case we can **remove the Mock sample** and just look at the data that we want to compare.

To do that we use the `prune_samples()` function from phyloseq. 
We can now check the phyloseq object and see that instead of 20 samples we have only 19 as expected.
```{r}
# remove Mock sample
my_noMock <- prune_samples(sample_names(my_physeq_rel)!="Mock",my_physeq_rel)
my_noMock
```


```{r}
# Prepare new ordination withouth the mock
my_ordination_mockless <- ordinate(my_noMock, 
                     method="MDS", 
                     distance="bray")

# Prepare a new plot
my_pcoa_nomock <- plot_ordination(my_noMock, 
                           my_ordination_mockless, 
                           color="Timepoint")

# And visualize!
my_pcoa_nomock + 
  geom_point(size=3) 
```



