## Combine single sample abundance estimates into one table

Since we have to run kraken2 and bracken on a per-sample basis, it is helpful to combine the report files into a single table containing all observations and species before we jump into R. I wrote a small script that should do the merging of bracken (or kraken2) reports for you. 

To use it we need to install pandas first

    pip install pandas

The you can merge either a kraken2 or bracken report with

    python /data/shared/scripts/merge_profiling_reports.py -i bracken/ -o merged

This produces 2 files:

`merged_rel_abund.csv` - contains table for all samples with bracken relative abundances and taxonimic assignments 

`merged_read_numbers.csv`- contains table for all samples with bracken read counts and taxonimic assignments 

We will use these files for the data exploration and analysis on day 3.

But feel free to sneak peak with `head merged_rel_abund.csv`.