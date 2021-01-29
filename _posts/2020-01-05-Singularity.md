---
layout: post
title:  "Singularity for bioinformatics"
author: at
categories: [ singularity ]
image: assets/images/cyberspace.jpg
---

> A basic introduction to Singularity containers

## What is a container?

In simple words, a container is an isolated system that shares with the host
only the kernel, allowing the installation of a custom set of libraries,
dependencies and tools that will not conflict with the existing installation
in the host.

It's a more _isolated_ system if compared with a _"conda environment"_, but
not as independent as a complete virtualization (_e.g._ VirtualBox): the
former shares several libraries and building tools with the host system, the
latter will create a virtual computer (a dedicated processor, that can even
be different to the real one, a dedicated RAM, that is necessarily a fraction
of the total installed RAM...).

As a rule of the thumb, virtualization is _necessary_ only when the current
architecture (_e.g._ CPU) or system (_e.g._ Windows is required but Linux is
installed) cannot support a specific software. In all the other cases, a
**container** is the ideal solution that will guarantee to work in a more robust
fashion when compared with conda environments, and in a more _portable_ way.


## What is Singularity?

The most popular containerization ecosystem is _Docker_. Singularity became the
Docker alternative for academics working with HPCs. Singularity allows to execute
software available in a **container** with some interesting features:

- The container runs in the **user space**: no root access is required
- The container can "see" the filesystem of the host as any other tool
- A container is a single file: it's easy to share them and use the same container in
multiple servers

## How does it work?

Suppose you have a Singularity image containing the assembly software "SPAdes",
this means you can simply run SPAdes from the container.

In a native installation you can run SPAdes as:

```bash
spades.py -1 path/to/read_R1.fq -2 path/to/read_R2.fq -o contigs/
```

A singularity container is stored in an **image** that is a single file. There are
several possibilities when it come to its extension: from no extension at all,
to `.sif`, `.simg` (singularity image). Let's assume our image is called
_spades-3.14.simg_, we can execute it as:

```bash
singularity run path/to/spades-3.14.simg  -1 path/to/read_R1.fq -2 path/to/read_R2.fq -o contigs/
```

As simple as this!

## More about running software from an image

A singularity image is a complete Linux system, so it carries a lot of software in it.
When building an image the user can define an "entry point", that is a default binary
to be executed. In the SPAdes example we defined `spades.py` to be such default binary,
hence we didn't need to specify its name in our previous example.

If we want to execute a specific binary (suppose `spades-bwa`, also shipped with SPAdes),
the syntax is _singularity exec BINARY_:

```bash
singularity exec path/to/spades-3.14.simg spades-bwa --help
```

When debugging an image we might want to see the world from its inside, that is
having a shell from its system. This can be simply done with:

```bash
singularity shell path/to/spades-3.14.simg
```

This will open a shell inside the container, and when we are done we can simply type
`exit` to return to our host shell. Remember that inside that shell you'll have only
the tool installed with it (for example: `nano`) and the image itself will be (should be)
write only.

## Some notes on Singularity for bioinformatics

I'll post some basic guide on how to install singularity and how to build a custom
image soon.

Meanwhile some notes are [available in a dedicated repository](https://telatin.github.io/singularities).
