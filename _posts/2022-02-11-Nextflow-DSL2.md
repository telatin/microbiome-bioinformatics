---
layout: post
title:  "Nextflow: implementing a simple pipeline"
author: at
categories: [ nextflow, tutorial ]
image: assets/images/nextflow.jpg
---

## First, let's run the pipeline!

:movie_camera: [Screencast of this step](https://www.youtube.com/watch?v=Ovv_fKIS8us&ab_channel=AndreaTelatin)

Before starting from scratch, we can see an interesting feature of Nextflow: we can execute pipelines
from a Github repository, without the need of downloading them first.

1. Move to the directory of the repository
2. If you didnt download the small dataset, do it now (`bash getdata.sh`)
3. Activate the conda environment with the needed tools

We must specify a release, in this case we will use the "main" branch:

```bash
nextflow run telatin/nextflow-example -r main --reads 'data/*_R{1,2}.fastq.gz' --outdir denovo-example
```

This means that developing our pipeline using a public repository, we can also instantly run it on any
machine!

### Execution and output

Nextflow will update us on the progress of the pipeline printing the pipeline status on our terminal:

```text
Denovo Pipeline
===================================
reads        : data/*_R{1,2}.fastq.gz
outdir       : denovo-example

executor >  local (11)
[84/8b8eb4] process > fastp (filter T7) [100%] 3 of 3 ✔
[c1/81b198] process > assembly (T7)     [100%] 3 of 3 ✔
[c4/00a269] process > prokka (T7)       [100%] 3 of 3 ✔
[ca/858462] process > quast (quast)     [100%] 1 of 1 ✔
[1e/bb26e6] process > multiqc           [100%] 1 of 1 ✔
Completed at: 12-Jan-2022 16:41:20
Duration    : 1m 14s
CPU hours   : 0.1
Succeeded   : 11
```

As we discussed, every process is executed in its separate directory,
by default in our `./work/`. Try to inspect some of the woking directories!

Check the output files produced in the _denovo-example_ directory. 
The HTML report is like :mag: [**MultiQC report**]({{ site.baseurl }}{% link attachments/denovo_report.html %}).


## Building the pipeline step by step

The repository contains a set of workflows (`assembly_0.nf`, ...). Each step adds some complexity but they are
all executable. This page guides to the added features.

### Script 0: Getting parameters

`assembly_0.nf` has two purposes: collecting the parameters required by the pipeline, namely _input_ and _outdir_
(this is something we already [tried]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-first-steps.md %})).
The _input_ parameter is used to create a **channel**, that will be the source of data for our pipeline.

This first script has no processes, but will print the content of the channel via the `.view()` method. The output will be
a "dictionary" of labels and an array of paths (two elements: forward and reverse pair):
```text
[T7, [/vol/data/T7_R1.fastq.gz, /vol/data/T7_R2.fastq.gz]]
[SRR12825099, [/vol/data/SRR12825099_R1.fastq.gz, /vol/data/SRR12825099_R2.fastq.gz]]
[GCA009944615, [/vol/data/GCA009944615_R1.fastq.gz, /vol/data/GCA009944615_R2.fastq.gz]]
```

The script has an optional parameter, `--collect`, that shows what happens if we collect the channel (we merge).
To discard the _keys_ we can use the map method (`.map{it -> it[1]}`), so our output will be a single list of paths.


```text
[/vol/data/T7_R1.fastq.gz, /vol/data/T7_R2.fastq.gz, /vol/data/SRR12825099_R1.fastq.gz, /vol/data/SRR12825099_R2.fastq.gz, /vol/data/GCA009944615_R1.fastq.gz, /vol/data/GCA009944615_R2.fastq.gz]
```

:bulb: As an exercise, try removing the `.map{}` method and see the difference!

### Script 1: Getting parameters

`assembly_1.nf` is our first bioinformatics workflow, as simple as:

```groovy
workflow {
    fastp( reads )
    // Assembly takes as output the `reads` from "fastp"
    assembly( fastp.out.reads )
    // prokka takes as input the output of "assembly"
    prokka( assembly.out ) 
}
```

The `fastp` process is a good model of a typical module. 

The **input** is a tuple of a label (Sample ID)
and a path (the reads). Being paired end the `$reads` variable will be an array with forward (`$reads[0]`)
and reverse (`$reads[1]`) reads.

The **script** section will be executed in a directory where Nextflow symbolically links the input files.
Note that we use `${task.cpus}` as number of threads: this means that the actual number of threads will
be determined by the configuration of the script.
The process must produce **output** files: in this case the process will emit two named channels: _reads_
with the filtered reads, and _json_ with the JSON report.

```groovy
process fastp {
    tag "filter $sample_id"

    input:
    tuple val(sample_id), path(reads) 
    
    output:
    tuple val(sample_id), path("${sample_id}_filt_R*.fastq.gz"), emit: reads
    path("${sample_id}.fastp.json"), emit: json
 
    script:
    """
    fastp -i ${reads[0]} -I ${reads[1]} \\
      -o ${sample_id}_filt_R1.fastq.gz -O ${sample_id}_filt_R2.fastq.gz \\
      --detect_adapter_for_pe -w ${task.cpus} -j ${sample_id}.fastp.json
    """  
}  
```

### Script 2: collect all the output files

`assembly_2.nf` introduces more steps: _quast_ and _multiqc_. They both require to collect
the output files from all the samples.
Quast will simply need all the assemblies, we will use `.collect()` from the output channel 
from the assembly step.

On the other hand [MultiQC](https://multiqc.info/) will collect the output from multiple channels,
and we will use the [mix operator](https://www.nextflow.io/docs/latest/operator.html#mix).

### Script 3: Doing more with MultiQC

`assembly_3.nf` will bring prokka into our MultiQC report. By default, MultiQC uses the name
from the species in the Prokka log, but we don't have this information so we will tweak
the MultiQC command passing a configuration string. MultiQC itself is a world worth exploring!

### Script 4: custom scripts

In `assembly_4.nf` we add Abricate for AMR detection. The summary is not recognized by MultiQC
but we can easily create a MultiQC friendly table with a custom script. In this way we showcase
that programs placed in the `./bin` subdirectory of the script will be exposed in our processes.

### Script 5: reusable modules

In `assembly_5.nf` we refactored the script placing all the processes in external files, that
we import like:

```groovy
include { FASTP; MULTIQC } from './modules/qc'
include { SHOVILL; PROKKA; QUAST } from './modules/assembly'
include { ABRICATE; ABRICATE_SUMMARY } from './modules/amr'
```

As you can see we adopted the convention of using uppercase module names. This makes
the scripts more readable.

:bulb: The _nf-core_ community has a growing list of extremely well [curated modules](https://github.com/nf-core/modules)

### Configuration

Configuring Nextflow requires a separate course. In simple terms a file called
`nextflow.config` placed in the script's directory is loaded by default.

Something that we can pass are default parameters (they will overwrite defaults
written in the script itself):

```groovy
params {
    outdir   = './denovo'
}
```

Other important settings include the executor (_slurm_, _local_,...), containers
(_docker_, _singularity_,...). 
Inspiration from [nf-core pipelines](https://github.com/nf-core/) will help 
seeing the potential, and the [config documentation](nextflow.io/docs/latest/config.html)
is the obligate stop.


### Execution information

Our configuration file automatically saves the timeline, report and diagram of processes
of each execution. See [tracing and visualization](https://www.nextflow.io/docs/latest/tracing.html?highlight=timeline) from the docs.

* [:mag: Execution report (html)]({{ site.baseurl }}{% link attachments/nf-execution-report.html)
* [:mag: Execution timeline (html)]({{ site.baseurl }}{% link attachments/nf-timeline.html)
* [:mag: Diagram (svg)]({{ site.baseurl }}{% link attachments/nf-dag.svg)

---


## The programme

* :one: [A *de novo* assembly pipeline]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-denovo.md %}): we will design a simple workflow to assemble and annotate microbial genomes
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-containers.md %}): we will use Miniconda to gather our required tools, and generate Docker and Singularity containers manually (Nextflow can automate this step, but it's good to practice manually first)
* :three: [First steps with Nextflow]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-first-steps.md %}): we will install Nextflow and run a couple of test scripts
* :four: **The *de novo* pipeline in Nextflow**: we will implement our pipeline in Nextflow

:arrow_left: [Back to the Nextflow main page]({{ site.baseurl }}{% link _posts/2022-01-10-Nextflow-start.md %})