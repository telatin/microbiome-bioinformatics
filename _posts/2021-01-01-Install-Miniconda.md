---
layout: post
title:  "Install Miniconda"
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

### Miniconda: a popular solution

Miniconda is a package manager that was developed to simplify the installation
of Python tools and the creation of isolated environments (to allow, for example,
the insulation of conflicting packages).

Miniconda quickly became a fantastic solution to the problem providing:
* a package manager that runs in the user space (not requiring `sudo` privilege)
* an easy way to add new packages to the repository (in fact, _repositories_)

## Installing conda

The latest version is
**[available from the offical website](https://docs.conda.io/en/latest/miniconda.html)**.
There are installer for Linux, macOS and Linux, and based on different versions
of Python: copy the link for your platform and the version desired (avoid Python 2.7
and 32-bit versions):

![get link]({{ site.baseurl }}{% link assets/images/conda-link.png %})

Here a typical workflow (changing the URL accordingly), that will install
Miniconda in your home directory (`~/miniconda3`).

```bash
wget -O install.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
bash install.sh
```

This will start an _interactive_ process that will ask some questions 
(to accept the license and to start the initializer).

When the process is finished you'll be asked to restart your shell
(_i. e._ to log out and login again, 
or simply try typing `source ~/.bashrc` on most systems)


## Repositories

Conda allows to install packages from a *default channel* (mainly containing python
  modules), but also supports third party channels. There are three channels that
  can be of particular interest in (bio)data science:

* `bioconda` contains bioinformatics programs (and bioinformatics R libraries)
* `conda-forge` contains updated versions of commonly used command-line utilities
* `r` specializes on R libraries

For example, to check if `samtools` is available in bioonda, and which versions:
```bash
conda search -c bioconda samtools
```

To install it you can either accept the last compatible version:
```bash
conda search -c bioconda samtools
```

or specify the version you require:
```bash
conda search -c bioconda samtools=1.10
```

To install a package, simply replace _search_ with _install_. 
If you also add `-y` you will not be prompted and will try to install directly.

```bash
conda install -y -c bioconda vsearch
```

We can add some channels to a configuration file so that conda always checks them
when searching. This will make some searches slower so I generally only add `conda-forge`,
but adding also `bioconda` can be appropriate. Avoid adding `r`: it's massive and 
rarely used in bioinformatics (most biological R packages are available in `bioconda`).

To add some channels in your configuration file, create (or edit) the `~/.condarc` file as
follows:
```
channels:
  - defaults
  - conda-forge
  - bioconda
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
conda create -n myenv1
```

### Activate the environment

To _use_ an environment we need first to *activate* it:
```bash
conda activate myenv1
```

When the environment is active, 
you will no longer be able to access the packages you installed 
in the _base_ environment, and if you install a package now it will
belong to the _active_ environment.

```bash
conda install -c bioconda vsearch=2.17
```

### Deactivate the environment

To return to the previous environment:
```
conda deactivate
```

### List your environments

To get a list of the environments in your system:
```
conda info --envs
```


### Delete an environment
To be used with care:
```
conda remove -n ENVIRONMENT_NAME --all
```

## Using mamba for faster installations

Sometimes we require a lot of packages to be installed and this will trigger a long
process called "solving the environment". There is a drop-in replacement for Conda
called mamba, that  you can install from conda-forge:
```bash
conda install -y -c conda-forge mamba
```

Then just replace "conda" with "mamba" to use it, for example:
```bash
mamba search -c bioconda seqfu
```

and to install (for example):
```bash
mamba install -c bioconda seqfu
```

---

See also:
 * [Introdution to conda by _Astrobiomike_](https://astrobiomike.github.io/unix/conda-intro)
 * [:film_projector: Install Miniconda (video)](https://www.youtube.com/watch?v=bbIG5d3bOmk)
