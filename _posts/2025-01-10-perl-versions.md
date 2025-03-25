---
layout: post
title:  "Major Perl 5 versions"
author: at
categories: [ perl ]
image: assets/images/coding.jpg
---

Perl has been the scripting language enabling the first bioinformatics radiation,
for example ["saving" the human genome project](https://bioperl.org/articles/How_Perl_saved_human_genome.html).

Python is now the best choice for bioinformatics projects thanks to its clear syntax, great support for Object Oriented Programming,
fantastic ecosystem for data analysis (Pandas, Seaborn, scikit-learn...), and we are not recommending using Perl for new projects here.

There is, though, a good amount of working and useful legacy software, and Perl itself is constantly updated.

The recommendation is to install the latest version that you can on your system, but in terms of syntax:

Here we list recent versions, with a traffic light system where, focusing on the syntax an not the interpreter:

* 🔵 are modern releases that can be avoided
* 🟢 versions are sufficiently recent to be considered valid interpreters, but better avoiding targeting them as minimum requirement
* 🟠 are relatively old interpreters, but targeting them as minimum version is reasonable
* 🔴 there is no need to allow your code to run on these versions



| Status  | Version | Release Date | Major Feature |
|---------|---------|--------------|--------------|
| 🔵      | 5.40.0  | 2024 | New `__CLASS__` keyword and no longer experimental `try/catch` |
| 🔵      | 5.38.0  | 2023 | New class feature with API hooks and performance enhancements |
| 🔵      | 5.36.0  | 2022 | Subroutine signatures no longer experimental, added `defer` blocks |
| 🔵      | 5.34.0  | 2021 | Experimental try/catch syntax |
| 🔵      | 5.32.0  | 2020 | Experimental isa operator and chained comparisons |
| 🟢      | 5.30.0  | 2019 | Variable length lookbehind in regular expression patterns |
| 🟢      | 5.28.0  | 2018 | String/number-specific bitwise ops no longer experimental |
| 🟢      | 5.26.0  | 2017 | Lexical subroutines no longer experimental, indented here-documents |
| 🟢      | 5.24.0  | 2016  | Postfix dereferencing no longer experimental |
| 🟠      | 5.22.0  | 2015 | Double diamond operator, experimental bitwise operators |
| 🟠      | 5.20.0  | 2014 | Experimental subroutine signatures, key/value slice syntax |
| 🟠      | 5.18.0  | 2013 | Experimental lexical subroutines and regex character set operations |
| 🟠      | 5.16.0  | 2012 | `__SUB__` for currently-executing subroutine |
| 🔴      | 5.14.0  | 2011 | Non-destructive substitution (s///r) |
| 🔴      | 5.12.0  | 2010 | The `...` operator, implicit strictures with version |
| 🔴      | 5.10.0  | 2007 | Defined-or operator (//), switch feature, smart match operator |
| 🔴      | 5.8.0   | 2002 | Unicode 3.2.0 support, interpreter threads, improved PerlIO |
| 🔴      | 5.6.0   | 2000 | Internal UTF-8 representation, experimental Unicode support |
| 🔴      | 5.005   | 1998 | EXPR foreach EXPR syntax, experimental reliable signals |
| 🔴      | 5.000   | 1994 | Objects, references, lexical variables, modules |

data from [Wikipedia](https://en.wikipedia.org/wiki/Perl_5_version_history) and [Perl delta](https://metacpan.org/dist/perl/view/pod/perldelta.pod).
