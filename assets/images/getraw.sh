#!/bin/bash

for FILE in raw/*;
do
  OUT=$(basename $FILE | cut -f1 -d-)

  echo $OUT: $FILE
  if [ ! -e "$OUT.jpg" ]; then
   convert -resize 900x900\> "$FILE" "$OUT.jpg"
  fi
done
