---
layout: post
title:  "Tools: using Miniconda and containers"
author: at
categories: [ nextflow, tutorial ]
image: assets/images/nextflow.jpg
---

## Gathering the tools

We will use `nextflow` itself to orchestrate our pipeline, which will use:

* Fastp, for read filtering
* Shovill, to assemble the reads
* Abricate, to identify AMR genes
* Prokka, to perform a full annotation
* MultiQC, to generate an HTML report

We can create a Miniconda [(see tutorial)]({{ site.baseurl }}{% link _posts/2021-01-01-Install-Miniconda.md %})
environment with the tools we need.
If we have specific requirements for one or more tools, we can pin its version. 

As an example, we will request Shovill to be 1.1.0 and MultiQC greater or equal to 1.10. 

```bash
# Create a new environment called "DenovoPipeline" with the requested tools
conda create -n DenovoPipeline fastp shovill=1.1.0 abricate prokka "multiqc>=1.10"
```

To experiment with our tools we will need to activate the environment, with:

```bash
conda activate DenovoPipeline
```

### Sharing our environment

Note that this command will produce a different environment if run in two months: some tools might be updated.
This can be true even if you pin all the versions: some of their dependencies might be updated! 

We can export our current environment as a YAML file that will allow us to 

```bash
# Save the current environment as "denovo.yaml"
conda env export --file denovo.yaml
```

### Creating a container from our environment

:movie_camera: Need a refresher [video on Docker](https://youtu.be/iqqDU2crIEQ)?
or [on Singularity](https://www.youtube.com/watch?v=vEjLuX0ClN0&ab_channel=SanDiegoSupercomputerCenter)?

Basing our workflow on conda packages allows us to generate a containers with the same dependencies.

We can build either a Docker or Singularity image. 

We can either install Miniconda and then create an environment from the YAML file, or start from a
Miniconda image that has conda already installed and proceed. Note that if you push your Docker image
to a public hub, like Docker Hub, you can create a Singularity image from that.

In our repository you will find a directory with a Dockerfile (to build a Docker image, in our example we 
will start from Miniconda) and a Singularity definition file (to build a Singularity image, in this case
from an empty Centos image).

* [:open_file_folder: Definition files (repository)](https://github.com/telatin/nextflow-example/tree/main/deps)

---

## The programme

* :one: [A de novo assembly pipeline]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-denovo.md %}): we will design a simple workflow to assemble and annotate microbial genomes
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-containers.md %}): we will use Miniconda to gather our required tools, and generate Docker and Singularity containers manually (Nextflow can automate this step, but it's good to practice manually first)
* :three: [First steps with Nextflow]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-first-steps.md %}): we will install Nextflow and run a couple of test scripts
* :four: [The Denovo pipeline in Nextflow]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-DSL2.md %}): we will implement our pipeline in Nextflow

:arrow_left: [Back to the Nextflow main page]({{ site.baseurl }}{% link _posts/2022-01-10-Nextflow-start.md %})