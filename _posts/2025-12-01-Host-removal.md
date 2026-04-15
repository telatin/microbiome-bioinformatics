---
layout: post
title:  "Host removal: why Deacon"
author: at
categories: [ metagenomics ]
image: assets/images/host.jpg
hidden: false
---

If you've ever sequenced a clinical or environmental microbial sample,
you've almost certainly encountered the problem of **host contamination**. 

Human (or animal) DNA ends up in your library alongside the microbial DNA you actually care about, and unless you remove it efficiently, 
it wastes sequencing capacity, compute time, and (what's worse!) may retain sensitive patient genomic data that you have no legal right to store or process.

We [described mapping based approaches]({{ site.baseurl }}/{% link 2021-03-04-Host-removal.md %})
and now we want to focus on a modern minimizer-based approach: Deacon.
 

## What makes it hard?

At first glance, the problem seems simple: align reads to the human reference genome, discard the ones that map. 
In practice, this breaks down in several ways.

1. The reference genome is not the population: the canonical human reference genome is, in effect, an average. Reads from individuals of diverse ancestry — carrying variants, insertions, or alternative alleles not well-represented in GRCh38 — may simply not align. They slip through your filter undetected.
2. Aligners are error-tolerant by design: general-purpose aligners like Minimap2 and Bowtie2 are built to tolerate mismatches and indels. This is great when you want to find divergent reads; it is a problem when you are trying to confirm that a read is *not* human. Microbial or viral reads can spuriously map to the human genome, causing over-depletion of the signal you care about.
3. Endogenous viral elements blur the boundary: the human genome contains fossils of ancient viral integrations — endogenous retroviruses and related elements. A read from a present-day virus that shares sequence similarity with these elements may be flagged as human. The closer the pathogen is to something that has previously integrated into a vertebrate genome, the worse this problem becomes.
4. Pan-genomes don't scale with alignment: the ideal solution would be to index *all* known human haplotypes. The Human Pan Genome Reference Consortium has published ~50 diploid assemblies — roughly 100 haploid assemblies, or ~300 Gb of sequence. Passing that into a conventional read aligner is, as Andrew Page put it bluntly: *"eye-watering"* on cloud compute. At the scale of 60 Gb per sample for a metagenomics run, even basic mapping costs are already prohibitive for routine production work.


## The False Positive / False Negative Trade-off

The sensitivity vs. specificity problem is not uniform — it depends heavily on what you are looking for.

| Scenario | Risk |
|---|---|
| Mycobacterium tuberculosis in sputum | Low — minimal k-mer overlap with human genome |
| Gut virome from rectal biopsy | High — EVEs, HERVs, and low-complexity regions create false positives |
| Unknown environmental metagenome | Unpredictable — depends on community composition |

Example: increasing Kraken2 database size improves sensitivity but may push shared k-mers to a lower taxonomic rank,
effectively *un-classifying* human reads rather than flagging them.

---

## Traditional approaches

### Alignment-based (Bowtie2 / Minimap2)

The most common strategy, used in tools like [nf-core/taxprofiler](https://nf-co.re/taxprofiler). Map reads to a host reference; discard mapped reads; pass the rest to a classifier.

**Strengths:** Conceptually simple, well-understood error model.  
**Weaknesses:** Does not scale to pan-genomes; fights aligner heuristics (e.g. Minimap2 ignores top 1% most-abundant minimizers by default, which can *reduce* sensitivity when multiple human assemblies are indexed); SAM-stream processing is computationally wasteful for reads that will simply be thrown away.

### Kraken2

k-mer classification against a custom database. Highly sensitive with a large, densely sampled database but requires substantial RAM (100+ GB for a comprehensive database) and can demote human k-mers to lower taxonomic ranks when they are shared with microbial sequences.

### Hostile

Developed by Bede Constantinidis as a Python wrapper around Bowtie2 (short reads) and Minimap2 (long reads), with a focus on:

- Low resource footprint — runnable on a laptop
- Streamlined installation and package management
- Cloud-compatible index retrieval
- Correct handling of stdin/stdout streams for single and paired reads

Hostile addressed the *operational* problems of existing tools but remained fundamentally limited by the alignment paradigm. It could not scale to pan-genomes without hitting the heuristics baked into its underlying aligners.


## A modern approach: Deacon

The key insight motivating *Deacon* is that alignment is wasteful when the goal is binary filtering (i.e. we don't care *where* in the genome the reads come from)

Instead, Deacon uses **minimizers** — deterministic, subsampled k-mer representations — to index reference sequences. This approach has several advantages:

- **Pan-genome scalability**: minimizers naturally encode genetic diversity without storing redundant sequence. Adding more human haplotypes increases index sensitivity with far less memory growth than a full alignment index.
- **Speed**: sequence search against a minimizer index runs at gigabases per second.
- **Generality**: the same approach works for any reference — human, mouse, plant, or a custom gene/pan-genome of interest. You choose whether matching reads are kept or discarded.
- **Format flexibility**: FASTA or FASTQ, compressed or uncompressed, files or streams.

The tool is available on GitHub (link in podcast show notes) and represents a fundamental architectural shift from *hostile* rather than an incremental update.

### Database choice still matters

No depletion tool is better than its reference. For human samples, a pan-genome reference will outperform a single haplotype. 
The choice of minimizer density (how densely the genome is sampled) controls the sensitivity/specificity dial.

