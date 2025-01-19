#! /usr/bin/env bash

root_dir="www/"
articles_dir="www/articles"

# Convert articles to html
for article in $(ls articles); do
  # Check if the markdown file has 'published: true'
  if grep -q "published: true" "articles/$article"; then
    echo "Generating HTML for $article"
    pandoc \
      --standalone \
      --template templates/blog_template.html \
      "articles/$article" \
      -o "www/public/$(basename $article .md).html"
  else
    echo "Skipping $article (not published)"
  fi
done

rm -f "www/_index.md"

# Create article navigation page
# Create article navigation page
echo '<div class="posts">' > www/_index.md
echo '  <h2>Recent Posts</h2>' >> www/_index.md
echo '  <ul>' >> www/_index.md

for name in $(find articles -type f -exec basename {} \; | sort -ur | sed 's/\.md//'); do
  # Check if the markdown file has 'published: true'
  if grep -q "published: true" "articles/$name.md"; then
    year=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\1/')
    month=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\2/')
    day=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\3/')
    title=$(echo $name | sed -E 's/([0-9]{4})-([0-9]{2})-([0-9]{2})-(.*)/\4/' | sed 's/-/ /g')
    # Capitalize first letter of title
    title=$(echo ${title:0:1} | tr '[a-z]' '[A-Z]')${title:1}
    
    # Convert month number to name
    case $month in
      "01") month_name="January" ;;
      "02") month_name="February" ;;
      "03") month_name="March" ;;
      "04") month_name="April" ;;
      "05") month_name="May" ;;
      "06") month_name="June" ;;
      "07") month_name="July" ;;
      "08") month_name="August" ;;
      "09") month_name="September" ;;
      "10") month_name="October" ;;
      "11") month_name="November" ;;
      "12") month_name="December" ;;
    esac
    
    echo "    <li>" >> www/_index.md
    echo "      <span class=\"date\">$month_name $day, $year</span>" >> www/_index.md
    echo "      <a href=\"/public/$name.html\">$title</a>" >> www/_index.md
    echo "    </li>" >> www/_index.md
  else
    echo "Skipping $name (not published)"
  fi
done

echo "  </ul>" >> www/_index.md
echo "</div>" >> www/_index.md

pandoc \
  --standalone \
  --template templates/index_template.html \
  www/_index.md \
  -o www/index.html