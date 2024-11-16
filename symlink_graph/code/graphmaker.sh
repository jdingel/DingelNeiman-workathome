#!/bin/bash
#Script to generate graph of tasks

echo -e 'digraph G {' > ../output/graph.txt

find ../../*/code -maxdepth 1 -name "Makefile" | xargs grep -o 'input.*:.*output' |
sed 's/\.\.\/\.\.\///g' | #Drop leading relative path ../../ from start of line
sed 's/\/code\/Makefile:input.*:/ \->/' | sed 's/\/output$//' | sed 's/ | / /' | #Drop folders and file names; show only tasks
awk -F' -> ' '{ print $2 "->" $1}' | #Flip order to reflect task flow, not symbolic link direction
sort | uniq | sed 's/^ //' >> ../output/graph.txt

echo '}' >> ../output/graph.txt
