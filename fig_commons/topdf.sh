#!/bin/sh

for filename in *.fig
do
  echo "File $filename"
  echo  `basename $filename .fig`.pdf
 fig2dev -L pdf $filename  `basename $filename .fig`.pdf
done
