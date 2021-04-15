---
layout: post
title:  "Install Miniconda"
author: at
categories: [ bash, tutorial ]
image: assets/images/anaconda.jpg
hidden: true
---

## The problem

A typical bioinformatics workflow involves dozens of different tools, sometimes
each requiring a broad range of libraries and other dependencies. Installing all
of them is a tedious task sometimes, an impossible task when different packages
require different versions of the same tool.

There are two main solutions to the problem: one is to rely on **containers** (which
resolve the problem of conflicting packages, but does not necessarily simplify
the installation of the packages) or **package managers**.

## Miniconda: a popular solution

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

This will start an _interactive_ process that will ask some questions (to accept the license
  and to start the initializer).

When the process is finished you'll be asked to restart your shell
(_i. e._ to log out and login again, or
  simply type `source ~/.bashrc` on most systems)

## The bioconda repository

Conda allows to install packages from a default channel (mainly containing python
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

## Using mamba for faster installations

Sometimes we require a lot of packages to be installed and this will trigger a long
process called "solving the environment". There is a drop-in replacement for Conda
called mamba, that  you can install from conda-forge:
```bash
conda install -y -c conda-forge mamba
```

Then just replace "conda" with "mamba" to use it, for example:
```bash
mamba search -c bioconda covtobed
```

and to install (for example):
```bash
mamba install -c bioconda covtobed
```

---

See also:
 * [Introdution to conda by _Astrobiomike_](https://astrobiomike.github.io/unix/conda-intro)
 * [:video: Install Miniconda (video)](https://www.youtube.com/watch?v=bbIG5d3bOmk)
