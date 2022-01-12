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

--- 

## The workshop programme

* :one: [A *de novo* assembly pipeline]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-denovo.md %}): we will design a simple workflow to assemble and annotate microbial genomes
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-containers.md %}): we will use Miniconda to gather our required tools, and generate Docker and Singularity containers manually (Nextflow can automate this step, but it's good to practice manually first)
* :three: **First steps with Nextflow**: we will install Nextflow and run a couple of test scripts
* :four: [The *de novo* pipeline in Nextflow]({{ site.baseurl }}{% link _posts/2022-02-11-Nextflow-DSL2.md %}): we will implement our pipeline in Nextflow

:arrow_left: [Back to the Nextflow main page]({{ site.baseurl }}{% link _posts/2022-01-10-Nextflow-start.md %})