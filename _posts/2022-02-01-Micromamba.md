---
layout: post
title:  "Fast bioinformatics containers with Micromamba"
author: at
categories: [ docker, singularity, conda, tutorial ]
image: assets/images/total_landscaping.jpg
hidden: true
---

## From Conda to Docker

Miniconda environments are an easy to use and flexible way of organising dependencies,
and to ensure reproducibility as each environment can be shared as a YAML file.

In this short note, we will see how to generate an environment to be used to generate
a Docker container.

### Generating the environment

We will use **mamba** to quickly generate a new environment with the tools we need 
(see :book: [**Miniconda tutorial**]({{ site.baseurl }}{% link _posts/2021-01-01-Install-Miniconda.md %})).

For this example we will use a set of tools from bioconda. If needed, we can specify the exact version,
or a version range (e. g. `samtools>=1.14`).

```bash
mamba env create -n MyEnv -c conda-forge -c bioconda -y \
  fastp  bwa "seqfu>1.9" "samtools=1.14"
```

### Save the environment as a file

A handy feature of Miniconda is the possibility of saving the current environment
to a YAML file. 

:bulb: Adding `--no-builds` will skip the build specification from the YAML file.

```bash
# Activate the generated environment first
conda activate MyEnv

# Export the environment, removing the first and last line
# that specify the environment name and prefix (path)
conda env export | head -n -1 | tail -n +2 > environment.yaml
```

### Dockerfile

[Micromamba](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html) is a striped-down
version of conda, based on **mamba**, and is available as a docker image, that we can use 
to make a Dockerfile.

```dockerfile
FROM mambaorg/micromamba:0.19.1
RUN mkdir /home/mambauser/eggnog
COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yaml /tmp/env.yaml
ARG MAMBA_DOCKERFILE_ACTIVATE=1
RUN micromamba install -y --file env.yaml && \
     micromamba clean --all --yes
```

To build the image:

```bash
docker build -t imagename .
```

:bulb: By default, Docker will run as a root (thus requiring _sudo_). To allow your
user to run _sudo-less_ docker commands:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

### Singularity

If you push your docker container to a hub, from there you can pull the image
as a singularity container. If using [Docker Hub](https://hub.docker.com/), for example:

1. `docker login` with your username and password (required once)
2. Build the image tagging it as `username/imagename:version`
3. Push the image to the repository with `docker push username/imagename:version`

To generate the Singularity image:

```bash
singularity pull docker://username/imagename:version
```