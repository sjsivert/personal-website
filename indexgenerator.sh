#! /usr/bin/env bash

for article in $(ls articles); do
	echo $article
	pandoc \
	--standalone \
	--template template.html \
	"articles/$article" \
	-o "public/$(basename $article .md).html"
done

rm -f _index.md

current_year="-"
for name in $(find articles -type f -exec basename {} \; | sort -ur | sed 's/\.md//'); do
  year=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\1/')
  month=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\2/')
  day=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\3/')
  title=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\4/')
  nice_title=$(echo "$year-$month-$day - $(echo ${title:0:1} | tr  '[a-z]' '[A-Z]' )${title:1}" | sed -e 's/-/ /g')
  if [ $year != $current_year ]; then
    echo -e "\n## $year\n" >> _index.md
  fi
  current_year=$year
  echo "- [$nice_title](public/$name.html)" >> _index.md

done

pandoc \
	--standalone \
	--template template.html \
	_index.md \
	-o index.html
