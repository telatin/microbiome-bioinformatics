---
layout: post
title:  "Micromamba package manager"
author: at
categories: [ bash, tutorial ]
image: assets/images/anaconda.jpg
hidden: true
---

## The problem and its solution

A typical bioinformatics workflow involves dozens of different tools, sometimes
each requiring a broad range of libraries and other dependencies. Installing all
of them is a tedious task sometimes, an impossible task when different packages
require different versions of the same tool.

There are two main solutions to the problem: one is to rely on **containers** (which
resolve the problem of conflicting packages, but does not necessarily simplify
the installation of the packages) or **package managers**.

### Micromamba: a modern solution

Micromamba is a package manager that was developed to simplify the installation
of Python tools and the creation of isolated environments (to allow, for example,
the insulation of conflicting packages).

Micromamba quickly became a fantastic solution to the problem providing:
* a package manager that runs in the user space (not requiring `sudo` privilege)
* an easy way to add new packages to the repository (in fact, _repositories_)

## Installing conda

The latest version is
**[available from the offical website](https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html)**.

In MacOS you might have "brew" installed, thus you can install micromamba with:

```bash
brew install micromamba
```

Otherwise, the installation is automated by a script (works for both Linux and MacOs):

```bash
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
```


## Repositories

Conda allows to install packages from a *default channel* (mainly containing python
  modules), but also supports third party channels. There are three channels that
  can be of particular interest in (bio)data science:

* `bioconda` contains bioinformatics programs (and bioinformatics R libraries)
* `conda-forge` contains updated versions of commonly used command-line utilities
 

For example, to check if `samtools` is available in bioonda, and which versions:

```bash
micromamba search -c bioconda samtools
```
:bulb: use the [Bioconda website](https://bioconda.github.io/) instead to search quickly


To install it you can either accept the last compatible version:
```bash
micromamba search -c bioconda samtools
```

or specify the version you require:
```bash
micromamba search -c bioconda samtools=1.10
```

To install a package, simply replace _search_ with _install_. 
If you also add `-y` you will not be prompted and will try to install directly.

```bash
micromamba install -y -c bioconda vsearch
```

We can add some channels to a configuration file so that conda always checks them
when searching. This will make some searches slower so I generally only add `conda-forge`,
but adding also `bioconda` can be appropriate. Avoid adding `r`: it's massive and 
rarely used in bioinformatics (most biological R packages are available in `bioconda`).

To add some channels in your configuration file, create (or edit) the `~/.mambarc` file as
follows:
```yaml
channels:
  - conda-forge  
  - bioconda  
channel_alias: https://repo.prefix.dev/  
```

## Creating and using environments

Conda simplifies installing package, but a problem remains: conflicting versions.
You may want to use _samtools 1.10_, for example, but another tool installed an 
older version because it's not yet ready to support a more recent one. 

Conda allows to create _environments_, that are isolated rooms where you can install
packages independently from other rooms.

### Create a new environment

We need to choose a unique name for our new environment, in this example _myenv1_ (usually it's the name of a tool (like _qiime2-2020.1_) or a task (like _denovo_):

```bash
micromamba create -n myenv1
```

You can create a new environment and simultaneously install some packages, for example

```bash
micromamba create -n mapping --yes "samtools>=1.9" minimap2 bwa=0.7 
```

* the `-y` or `--yes` switch will automatically accept the suggested packages and proceed with installation

### Activate the environment

To _use_ an environment we need first to *activate* it:
```bash
micromamba activate myenv1
```

When the environment is active, 
you will no longer be able to access the packages you installed 
in the _base_ environment, and if you install a package now it will
belong to the _active_ environment.

```bash
micromamba install -c bioconda vsearch=2.17
```

:bulb: When running "install" check that you are in the correct environment

### Deactivate the environment

To return to the previous environment:
```
micromamba deactivate
```

### List your environments

To get a list of the environments in your system:
```
micromamba env list
```


### Delete an environment
To be used with care:
```
micromamba remove -n ENVIRONMENT_NAME --all
```
 

---

See also:
 * [Introdution to conda by _Astrobiomike_](https://astrobiomike.github.io/unix/conda-intro)
 * [:film_projector: Install Miniconda (video)](https://www.youtube.com/watch?v=bbIG5d3bOmk)
