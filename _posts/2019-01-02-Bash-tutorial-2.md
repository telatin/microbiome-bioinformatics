---
layout: post
title:  "Powerful things you can do with the Markdown editor"
author: at
categories: [ bash, tutorial ]
image: assets/images/coding.jpg
---

# A small introduction to Bash scripting

_After using the Linux terminal for a while, everyone wants to be able to write simple “scripts” to perform repetitive tasks. They looks like recipes, with the main difference of having a Chef — the shell interpreter — that is able to cook without any further help from us. This short series introduces to Bash scripting._

## “Hello world”-like script
A script is simply a text file with Bash commands: whatever we are used to type on the terminal can potentially become a line in our script.
So, using your favorite text editor, type the following lines and save them as “hello_world.sh”¹, and this will be your first script!

{% gist 0204188b1899a4cfe2ed8c3b954b47ff %}

First: note the very first line. It’s called **“shebang”** and its a special instruction
to specify who is going to interpret our script.
Bash is usually located at `/bin/bash`, so the special “`#!`”
followed by the absolute path of the interpreter of our script should always be the first line of our scripts.

The second thing we can note is that any line beginning with a # sign (excepting the shebang) is ignored.
It’s useful, and almost essential, to comment our scripts. This will make our life easier when we edit them some weeks after we first wrote them.
This script only has a real shell command, the echo command that basically will print to the terminal the string we supply.
We can try it immediately invoking “bash” followed by the path to the file we just created, like:

```
bash hello_world.sh
```

We should note that the output is simply “Hello, world!”: the comments and the
commands themselves are not visible by the user.

Finally, we can make our script executable, so that we won’t need to directly invoke the “bash” interpreter, but simply typing the path to our script will give us the expected output. We only need to add the executable permission once (with chmod), then every time we need to invoke it we can simply type the file path.

```
chmod +x hello_world.sh
./hello_world.sh
```

The second command assumes the script is in our current directory,
but note that we must specify the full relative path (starting with “./”),
while we usually imply it when passing file paths as arguments to programs
(like we did with “bash hello_world.sh”.

## Where is the script? Where are we?

Let’s now create a second script to clarify a concept often confusing
the beginners (we can call it _count_files.sh_).

{% gist 7cdb0e482d2fc4f900ff91482f46e2ef %}

Again we use the “echo” command, this time with the -n switch,
that will print the text we specify without adding a new line at the end.
This script contains two commands: _pwd_, telling our current directory, and ls piped into _wc_,
giving us the total number of files (and directories) in the current position.

Let’s suppose that the file has been saved in our home directory.
If we execute it from there we’ll get, as expected, the total number of files in that directory.
But if we execute it from another path, let’s say from _/tmp_, the result will change.
This happens because what matters is where the script has been invoked from, not the script’s position in the file system.

## A first introduction to variables

A script can be a simple list of commands. Even in this simple case can be really useful,
but there are some feature making them powerful: variables, loops and conditionals. We’ll see all of them in this series of short articles.

A variable is like a labelled box that can store a piece of information,
that — as the name suggests — can change from time to time.
Using the variable name we will be able to access its content.

Suppose that you have an E. coli database somewhere (e.g. `/db/coli/K12.fa`)
that you routinely use to perform alignments. Within a single script you might
be using it several times. If you create a variable called `REFERENCE`,
for example, and you assign to it the path to your genome database, you make the
script more flexible. For example, changing the path once,
the whole script will adapt to a new computer
(where the K-12 genome could be somewhere else),
or to a new organism if you need to perform the same analysis using _Salmonella_.

Variables are created using an assignation command, and can be accessed prepending
a “`$`” sign before their name. An example script printing a location and the
current date will make this distinction clear:

{% gist 9fb0f76663a8e7c4a26a412b39fd11fc %}

In this script we initialized a variable called “CITY” with an assignation command.
Note that spaces before or after the “=” are not allowed.
If we move to another city, we simply need to change line 5.
This variable is not going to change unless we edit the script.

On the other hand, we want to create a variable with the current date.
To do so we assign to the box labelled as “`DATE`” the output of a shell command
(`date`, indeed). Note the syntax used to do this:

```
VARIABLE_NAME=$(shell command)
```

Both line 5 and line 8 will produce no visible effect,
as they are merely storing some information inside two boxes.
To make use of a variable we can retrieve it using the `$NAME` notation.
In this script we did simply print its content using an _echo_ command.

_Norwich, 2018–02–03. Originally [published here](https://medium.com/ngs-sh/a-small-introduction-to-bash-scripting-part-1-683c3633b724)_
