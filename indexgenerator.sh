#! /usr/bin/env bash

root_dir="www/"
articles_dir="www/articles"

# Convert articles to html
for article in $(ls articles); do
	echo $article
	pandoc \
	--standalone \
	--template template.html \
	"articles/$article" \
	-o "www/public/$(basename $article .md).html"
done

rm -f "www/_index.md"

# Create article navigation page
current_year="-"
for name in $(find articles -type f -exec basename {} \; | sort -ur | sed 's/\.md//'); do
  year=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\1/')
  month=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\2/')
  day=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\3/')
  title=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\4/')
  nice_title=$(echo "$year-$month-$day - $(echo ${title:0:1} | tr  '[a-z]' '[A-Z]' )${title:1}" | sed -e 's/-/ /g')
  if [ $year != $current_year ]; then
    echo -e "\n## $year\n" >> www/_index.md
  fi
  current_year=$year
  echo "- [$nice_title](public/$name.html)" >> _index.md

done

pandoc \
	--standalone \
	--template index_template.html \
	_index.md \
	-o www/index.html
