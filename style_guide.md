# Tutorial Writing Style Guide

A reference for maintaining a consistent voice and structure across all tutorials on this site,
derived from the existing posts.

---

## Voice and Perspective

**Use "we", not "you".**
Write as if you and the reader are working through the problem together.

- "We will use Miniconda throughout this workshop." ✓
- "You should use Miniconda throughout this workshop." ✗

**State prerequisites honestly.**
Say what background is expected at the top of the page. Immediately follow with links for
readers who need to catch up — do not apologise for the requirement.

**Be warm, not condescending.**
Occasional encouragement is fine ("you deserve your coffee and an emoji-medal :medal_sports:"),
but keep it sparse and genuine.

---

## Page Structure

Every tutorial page follows the same skeleton:

1. **Front matter** — `layout`, `title`, `author`, `categories`, `image`; add `hidden: true` for
   pages that are part of a series but should not appear on the homepage index.
2. **One-paragraph framing** — what problem we are solving and why it matters.
3. **Setup / installation** — conda/mamba environment creation, database downloads, etc.
4. **Single-sample walkthrough** — always demonstrate on *one* sample before scaling up.
5. **Multi-sample script** — introduce the loop or wrapper script once the reader understands the
   command.
6. **Checking / validating results** — show what success looks like.
7. **Optional / advanced extras** — at the very end, clearly marked as optional.
8. **The programme** — numbered list of all pages in the series, with the current page shown in
   plain text (no link) and all others linked.

---

## Emoji Icon System

Emoji are used as a **semantic legend**, not decoration. Use them consistently.

| Emoji | Shortcode | Meaning |
|-------|-----------|---------|
| 💡 | `:bulb:` | Tip, hint, or variant worth trying |
| ✏️ | `:pencil:` | Exercise or task for the reader |
| 🔍 | `:mag:` | Link to view an example output or artifact |
| 📖 | `:book:` | Optional deeper reading |
| ⚠️ | `:warning:` | Important caveat or common mistake |
| ℹ️ | `:information_source:` | Alternative approach |
| ➡️ | `:arrow_right:` | Navigation to the next page |
| ⬅️ | `:arrow_left:` | Navigation back |
| 🎬 | `:movie_camera:` | Link to a screencast |
| 🆘 | `:sos:` | Known problem / ask for help |

Do not use emoji for any purpose not listed above.

---

## Code Blocks

**Always tag the language.**

````markdown
```bash
command --flag value
```
````

Common tags used in this site: `bash`, `r`, `text`.

Use `text` for terminal output that the reader should not type.

**Variables go at the top of scripts, in UPPER_CASE.**

```bash
DB=/data/db/kraken2/mouse_GRCm39
DIR=/data/workshop/reads/
OUT=~/kraken-ws/reads-no-host
```

This makes it obvious which values a reader needs to customise.

**Split long commands across lines with `\`.**

```bash
kraken2 --db $DB \
    --threads 8 \
    --confidence 0.5 \
    --report $OUT/${sample}.report \
    --paired $R1 $R2
```

**Comment inside scripts to explain non-obvious lines.**

```bash
# We infer the second pair replacing _R1 with _R2
R2=${R1/_R1/_R2}
```

Comments explain *why* or *what*, not the trivially obvious.

---

## Explaining Commands

**Show the command first, then unpack its parts.**
The code block is the anchor; prose and bullet lists follow it.

After a command with several flags, add a bullet list using this format:

```markdown
where:
* `--flag VALUE` — plain-English description of what it does
* `--other-flag` — plain-English description
```

**Include real terminal output.**
Paste the actual output (in a `text` code block) so readers know what success looks like.

```text
┌──────────┬──────┬───────────┐
│ File     │ #Seq │ Total bp  │
├──────────┼──────┼───────────┤
│ sample1  │ 745  │ 2,684,355 │
└──────────┴──────┴───────────┘
```

---

## Pedagogical Pacing

**Single sample before loop, always.**
Introduce every new tool with the simplest possible command on a single file.
Add the loop or batch script only after the reader has seen the tool work.

**Label prototype scripts explicitly.**

> "For the records, we write here a prototype of script with a loop..."

This signals the reader should adapt it rather than copy blindly.

**Keep optional content strictly optional.**
Advanced extras, alternative tools, and further reading go at the bottom of the page,
clearly separated from the main walkthrough. Never embed them mid-flow.

---

## Linking

**Link tool names to their primary reference on first mention.**
Prefer the PubMed DOI for published tools, the GitHub README otherwise.

```markdown
[MegaHit](https://pubmed.ncbi.nlm.nih.gov/25609793/) is a fast assembler...
```

**Do not over-link.**
Link a tool once per page. Do not link common Unix commands or well-known concepts
unless the target is genuinely useful to the reader.

**Link to example visualisations with `:mag:`.**

```markdown
:mag: view artifact: [taxonomy.qzv](https://view.qiime2.org/...)
```

---

## Sentence and Paragraph Style

- Short sentences. Short paragraphs. One idea per paragraph.
- Use contractions ("let's", "we'll", "it's") — the tone is conversational.
- Use exact bioinformatics terminology without over-explaining it; the audience is assumed
  to be intermediate-level bioinformaticians.
- Avoid filler phrases: "In this section we will...", "As we can see...", "Note that...".
  Lead directly with the point.

---

## Front Matter Checklist

```yaml
---
layout: post
title:  "Short, descriptive title"
author: at
categories: [ primary-category, secondary-category, tutorial ]
image: assets/images/relevant-image.jpg
hidden: false   # true if this is a sub-page in a series
---
```

Common category values: `metabarcoding`, `metagenomics`, `virome`, `bash`, `tutorial`, `tools`, `16S`.
