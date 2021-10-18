#!/bin/bash

TMP_FILE_TOC=/tmp/mdtoc.md
TMP_FILE_CONTENT=/tmp/mdbody.md
README_MD=README1.md

# Dump separate Markdown content from mds/*.md
cat mds/*.md > $TMP_FILE_CONTENT

# Generate TOC from $TMP_FILE_CONTENT
# Download gh-md-toc (Table of Content generator) from https://github.com/ekalinin/github-markdown-toc
echo "# Table of content" > $TMP_FILE_TOC
echo " " >> $TMP_FILE_TOC
cat $TMP_FILE_CONTENT | gh-md-toc - >> $TMP_FILE_TOC
echo " " >> $TMP_FILE_TOC

# Combined $TMP_FILE_TOC and $TMP_FILE_CONTENT to $README_MD
cat $TMP_FILE_TOC $TMP_FILE_CONTENT > $README_MD

