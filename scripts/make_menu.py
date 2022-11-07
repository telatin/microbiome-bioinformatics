#!/usr/bin/env python
"""
Given a collection of Markdown files, create a menu with links
"""

import argparse
import os
import re

def get_Menu(files):
    """
    Scan files and populate a PATH => TITLE dictionary
    """
    menu = {}

    for file in files:
        with open(file, mode="r") as f:

            for line in f:
                if line.startswith("title:"):
                    title = line.split(":", 1)[1].strip()
                    # Strip surrounding quotes
                    title = title.strip('"').strip("'")
                    menu[file] = title
                    break
    return menu

def render_menu(menu_dictionary, print_numbers=False):

    menu = "\n\n---\n\n## Programme\n"
    numbers = {
        1: ":one:",
        2: ":two:",
        3: ":three:",
        4: ":four:",
        5: ":five:",
        6: ":six:",
        7: ":seven:",
        8: ":eight:",
        9: ":nine:",
        10: ":keycap_ten:",
    }
    # Sort menu dictionary by key
    menu_dictionary = {k: menu_dictionary[k] for k in sorted(menu_dictionary.keys())}
    c = 0
    emoji = ""

    for path, title in menu_dictionary.items():
        c = c + 1
        if print_numbers:
            if c in numbers:
                emoji = numbers[c]
            else:
                # combine all the individual digits
                emoji = "".join([numbers[int(d)] for d in str(c)])

            

        menu += f"- {emoji} [{title}]({{% link {path} %}})\n"    

    return menu

def main():
    args = argparse.ArgumentParser("Create a menu from a collection of Markdown files")
    args.add_argument("FILES", help="Input Markdown files", nargs="+")
    args.add_argument("-n", "--numbers", help="Number the menu items", action="store_true")
    args.add_argument("-w", "--write", help="Write the menu to all the files", action="store_true")
    args = args.parse_args()

   
    menu_dictionary = get_Menu(args.FILES)
    menu = render_menu(menu_dictionary, args.numbers)

    if args.write:
        for file in args.FILES:
            # If the file already has a menu, replace it (see if contains "---\n\n## Programme\n")
            # Otherwise, append it to the file
            with open(file, mode="r") as f:
                content = f.read()
                if re.search(r"---\n\n## Programme\n", content):
                    content = re.sub(r"---\n\n## Programme\n.*", menu, content, flags=re.DOTALL)
                else:
                    content += menu
            print("====== ", file)
            print(content)
    else:
        print(menu)

if __name__ == "__main__":
    main()

"""

---

## The programme

* :zero: [EBAME-22 notes]({{ site.baseurl }}{% link _posts/2022-02-02-virome-ebame.md %}): EBAME-7 specific notes
* :one: [Gathering the reads]({{ site.baseurl }}{% link _posts/2022-02-10-virome-reads.md %}):
  downloading and subsampling reads from public repositories (optional)
* :two: [Gathering the tools]({{ site.baseurl }}{% link _posts/2022-02-11-virome-tools.md %}):
  we will use Miniconda to manage our dependencies
* :three: [Reads by reads profiling]({{ site.baseurl }}{% link _posts/2022-02-12-virome-phanta.md %}):
  using Phanta to quickly profile the bacterial and viral components of a microbial community
* :four:  [_De novo_ mining]({{ site.baseurl }}{% link _posts/2022-02-13-virome-denovo.md %}):
  assembly based approach, using VirSorter as an example miner
* :five:  [Viral taxonomy]({{ site.baseurl }}{% link _posts/2022-02-14-virome-taxonomy.md %}):
  *ab initio* taxonomy profiling using vConTACT2
* :six:  MetaPhage overview:
  what is MetaPhage, a reads to report pipeline for viral metagenomics
  
"""