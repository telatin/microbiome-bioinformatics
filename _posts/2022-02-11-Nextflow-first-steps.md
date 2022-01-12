---
layout: post
title:  "Nextflow: first steps"
author: at
categories: [ nextflow, tutorial ]
image: assets/images/nextflow.jpg
---

## Installing Nextflow

[Nextflow](https://www.nextflow.io/) has a great documentation (and community support), so [the installation instructions](https://www.nextflow.io/docs/latest/getstarted.html#installation) are the right place to start checking.

Java is required, and you can check if you have it by typing:

```bash
java -version
```

:warning: If you `java` is installed in a specific environment, you will need that environment to be active every time you run Nextflow.
In most cases it's better to have a system installation of Java and Nextflow installed in your home: in this way you will be able to run the same Nextflow from any environment.

```bash
# Download and generate the nextflow executable
curl -s https://get.nextflow.io | bash
chmod +x ./nextflow

# Place the program where you can execute it (in your $PATH)
# in our example we have a $HOME/bin directory
mv ./nextflow ~/bin/
```

## DSL2

Before we start, it's important to stress that we are in the middle of a big transition in Nextflow from its original
syntax (now referred to as DSL1) and a completely different paradigm (called DSL2). Nextflow is a "Domain Specific Language" (DSL)
built upon [Groovy](https://groovy-lang.org/).

The first language required writing a single file with all the instructions, where every process was a block connected to other blocks
via its input and output: the filtering step would emit filtered reads, that are the input of the assembly step, for example. 

The new version, **DSL2**, is a radical change that allows:

* Separating the description of each step with their interconnection
* Each step (process) can be now written in separate files (as modules), that can be **reused**
* Not only the processes can be reused, but also **(sub)workflows** can be combined.

This preamble is to warn you that a lot of training material will refer to DSL1 (and there is nothing bad in learning that, too!)

## First script

Our repository contains the pipeline and some example files. 
It can be useful to clone it to have the files at hand (and downloading some toy files).

```bash
# Clone the repository
git clone https://github.com/telatin/nextflow-example
# Enter its directory
cd nextflow-example
# Download sample files
bash getdata.sh
```

In the `first-steps` directory you will find some very basic examples. Our first task is to be able to receive parameters from the user.

:warning: When launching a pipeline from the command line we will have some parameters for our workflow, while others will be for Nextflow (the runtime)
itself: parameters with a single dash (like `-resume`) are for Nextflow runtime, while those with double dashes (like `--input`) will be passed
to the workflow itself.

The first script is:

```nextflow
// setup a "default" parameter
params.ref = "ecoli.fa"

// Initialize a parameter that you expect
params.input = false

// Print some parameters to the console
println " TEST THE --input PARAMETER"
println "-----------------------------------------------------"
println "Reference: " + params.ref
println "Input:     " + params.input
```

The initial section initialise the two parameters we want to use: _ref_ and _input_. While we set a default
value for _ref_, we simply set _input_ as false.
We later print (with `println`) the content of the two variables. Try executing the pipeline with or without
passing parameters, or just one of the two.

```
nextflow run first-steps/01-params.nf --input reads/ --ref otherref.fa
```

:warning: at every execution a "work directory" is created, called `./work` if not otherwise specified, and a new
log file (`.nextflow.log`) is generated. Our first examples do not have processes so their use is very limited.

## Creating channels

One of the core concepts of Nextflow are the _data channels_, the directory contains two scripts that create channels
using DSL1 (`02-channels-dsl1.nf`) and DSL2 (`03-channels-dsl2.nf`), respectively. Note that
[a superb DSL1 tutorial](https://seqera.io/training/#_processes_and_channels)
is available from the company born to offer support to Nextflow (Sequera Labs). I would recommend going through it at your
pace to have a better understanding, and it covers some DSL2 syntax at the end, too.

:notebook:  Try to execute, edit and re-execute the `02-channels-dsl1.nf` script, inspecting what happens in the `./work` directory

### A data channel in DSL2

A core concept in our example is the ability to create an populate a channel with read pairs, so let's see the core steps
from the channels DSL2 example:

```groovy
// Enable DSL2 (it's not the default, yet)
nextflow.enable.dsl=2
// We can put a default value to the `--dir` parameter
params.dir = 'data/*.fastq.gz'
// Create a channel 
read_ch = Channel.fromPath( params.dir, checkIfExists: true )
// View the content of the channel
read_ch.view()
```

The snippet above will create a channel where each file is an item, printing a list of _absolute paths_: each item
of the channel can be sent to a process, when we will start building the pipeline.

A common input of bioinformatics workflows are _paired-end datasets_. Let's update the above script to take as input
our small dataset in the "_data_" directory:

```groovy
// Enable DSL2 (it's not the default, yet)
nextflow.enable.dsl=2
// Here we need to use both an initial wildcard and a defined pattern for the two pairs,
// like R{1,2} or {for,rev}...
params.dir = 'data/*_R{1,2}.fastq.gz'
// Create a channel 
read_ch = Channel.fromFilePairs( params.dir, checkIfExists: true )
// View the content of the channel
read_ch.view()
```

Now our channel is organised like a dictionary of keys (sample names) and
values (a list of paths, forward and reverse respectively):

```text
[T7, [/qi/isp/climb/data/T7_R1.fastq.gz, /qi/isp/climb/data/T7_R2.fastq.gz]]
[SRR12825099, [/qi/isp/climb/data/SRR12825099_R1.fastq.gz, /qi/isp/climb/data/SRR12825099_R2.fastq.gz]]
[GCA009944615, [/qi/isp/climb/data/GCA009944615_R1.fastq.gz, /qi/isp/climb/data/GCA009944615_R2.fastq.gz]]
```

### A first process

The `04-wc.nf` is the first script that contains an actual workflow, even though only
composed by a single process. The process (`NUM_LINES()`) takes as input a gzipped file,
and prints the file name and the number of lines (the output is - unusually - just the standard output).

To try the script run:
```
nextflow run first-steps/04-wc.nf  --input 'data/*.gz'
```

The output will be something like:

```text
N E X T F L O W  ~  version 21.10.0
Launching `first-steps/04-wc.nf` [admiring_hoover] - revision: 7f9b4d3c06
executor >  local (6)
[dd/a0a2e8] process > NUM_LINES (3) [100%] 6 of 6 ✔
T7_R1.fastq.gz 334712
SRR12825099_R1.fastq.gz 156992
GCA009944615_R2.fastq.gz 71280
...
```

the first part is telling us that the execution has a nickname (admiring_hoover), and that a
process (called `NUM_LINES`), has been executed successfully on 6 files over 6. For debug purposes,
its also worth noting that each process has a unique identifier (like `dd/a0a2e8`: we can only see
the last of the six executions).

If you `dir ./work` you will see that there are directories with two characters, each containing
one or more directories. For example dd/a0a2e8 is the beginning of a path that we can complete with the
tab autocompletion:

```bash
# Change your path accordingly!
ls -la work/dd/a0a2e8b8970265f5b18bb61ce41ac6/
```

The output is something like:
```text
-rw-rw-r-- 1 ubuntu ubuntu    0 Jan 12 16:11 .command.begin
-rw-rw-r-- 1 ubuntu ubuntu    0 Jan 12 16:11 .command.err
-rw-rw-r-- 1 ubuntu ubuntu   22 Jan 12 16:11 .command.log
-rw-rw-r-- 1 ubuntu ubuntu   22 Jan 12 16:11 .command.out
-rw-rw-r-- 1 ubuntu ubuntu 9350 Jan 12 16:11 .command.run
-rw-rw-r-- 1 ubuntu ubuntu   74 Jan 12 16:11 .command.sh
-rw-rw-r-- 1 ubuntu ubuntu  200 Jan 12 16:11 .command.trace
-rw-rw-r-- 1 ubuntu ubuntu    1 Jan 12 16:11 .exitcode
lrwxrwxrwx 1 ubuntu ubuntu   33 Jan 12 16:11 T7_R2.fastq.gz -> /qi/isp/climb/data/T7_R2.fastq.gz
```

This _magic_ directory is where the process was executed: a file called `.command.sh` is the script 
containing the programs we described. The directory contains (via symlinks) all the input files,
in our case just "T7_R2.fastq.gz".

The output of the process is saved as `.command.out` and the standard error to `.command.err`, while
the exit status is saved in `.exitcode`.


### Collecting outputs

A pipeline is a set of processes communicating files to each other. A minimal example is
`05-longest-file.nf`, that extends our previous _wc_ to print the files with the highest
number of lines.


We are now (almost) ready to build our pipeline...
--- 

## The workshop programme

* :one: [A *de novo* assembly pipeline]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-denovo.md %}): we will design a simple workflow to assemble and annotate microbial genomes
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-containers.md %}): we will use Miniconda to gather our required tools, and generate Docker and Singularity containers manually (Nextflow can automate this step, but it's good to practice manually first)
* :three: **First steps with Nextflow**: we will install Nextflow and run a couple of test scripts
* :four: [The *de novo* pipeline in Nextflow]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-DSL2.md %}): we will implement our pipeline in Nextflow

:arrow_left: [Back to the Nextflow main page]({{ site.baseurl }}{% link _posts/2022-01-10-Nextflow-start.md %})