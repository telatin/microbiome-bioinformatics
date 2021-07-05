
## 2. Re-estimate kraken2 species abundances using bracken

Kraken2’s raw read assignments is not really suitable for looking at the relative abundances of species, as kraken2 ignores ambiguous reads leading to an underestimation of some species relative abundances. Bracken re-estimates species abundances from the kraken output by probabilistically re-distributing reads in the taxonomic tree. If you want to find out more, read and cite: https://peerj.com/articles/cs-104/

### 2.1 Get relative species abundances using bracken

Create the output folder

    mkdir -p ~/profiling/bracken

Run bracken on kraken2 report files created in **1.**. Make sure to set the correct read length with the `-r` flag as this is important for bracken to work correctly. The `-l S` setting means that we want to re-estimate species abundances.

    bracken -d standard-2021 -i ~/profiling/kraken2/Sample8.report -o ~/profiling/bracken/Sample8.bracken -r 150 -l S

Do run bracken on all of the samples, use a simple for-loop like so:

    DB=/data/db/kraken2/standard-2021
    DIR=~/profiling/kraken2
    OUT=~/profiling/bracken

    mkdir -p $OUT

    for K2 in $DIR/Sample*.report;
    do
        sample=$(basename ${K2%.report})
        echo "Re-estimating abundances with bracken for" $K2
        bracken \
            -d $DB \
            -i $K2 \
            -o ${OUT}/${sample}.bracken \
            -w ${OUT}/${sample}_bracken_species.report \
            -r 150 \
            -l S
    done

---

## 3. Combine single sample abundance estimates into one table

Since we have to run kraken2 and bracken on a per-sample basis, it is helpful to combine the report files into a single table containing all observations and species before we jump into R. I wrote a small script that should do the merging of bracken (or kraken2) reports for you. 

    python /data/shared/scripts/merge_profiling_reports.py -i ~/profiling/bracken/ -o combi

This produces 2 files:

`combi_rel_abund.csv` - contains table for all samples with bracken relative abundances and taxonimic assignments 

`combi_read_numbers.csv`- contains table for all samples with bracken read counts and taxonimic assignments 


We will use these files for the data exploration and analysis on day 3.
