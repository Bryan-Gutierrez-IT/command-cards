#!/bin/bash

if [ $# -gt 1 ]; then
    echo "Usage: $0 [history_file]" 1>&2
    exit 1
fi

hist_file="${1:-$HOME/.bash_history}"

if [ ! -f "$hist_file" ]; then
    echo "Error: history file not found: $hist_file" 1>&2
    exit 1
fi

source "$(dirname "$0")/settings.sh"
echo "Settings loaded." 1>&2

mkdir -p "$build_dir"

cmds_full=$(mktemp "$build_dir/cmds_full.XXXX")
cmds_stats=$(mktemp "$build_dir/cmds_stats.XXXX")
count_stats=$(mktemp "$build_dir/count_stats.XXXX")

cat "$hist_file" > "$cmds_full"

echo "History copied to $cmds_full" 1>&2

awk -f history_scrape.awk "$cmds_full" > "$cmds_stats" 2> "$count_stats"
echo "Command stats written to $cmds_stats" 1>&2
echo "Count stats written to $count_stats" 1>&2

cmds_rank=$(mktemp "$build_dir/cmds_rank.XXXX")

sort -t, -k2,2nr "$cmds_stats" | \
awk -F, 'BEGIN{OFS=","} {print $0, NR}' > "$cmds_rank"

echo "Ranked command stats written to $cmds_rank" 1>&2

cards_html="$build_dir/cards.html"

IFS=, read -r total_exec total_cmds total_args total_redirs < "$count_stats"

sed -E \
    -e "s|EXECUTIONS|$total_exec|g" \
    -e "s|COMMANDS|$total_cmds|g" \
    -e "s|ARGUMENTS|$total_args|g" \
    -e "s|REDIRECTS|$total_redirs|g" \
    "$templates_dir/html/index_top" > "$cards_html"

declare -A rarity_map
declare -A flavor_map

while IFS=, read -r name rarity desc; do
    rarity_map["$name"]="$rarity"
    flavor_map["$name"]="$desc"
done < "$data_dir/commands.csv"

while IFS=, read -r cmd execs avgargs redir last rank; do
    rarity="${rarity_map[$cmd]}"
    [ -z "$rarity" ] && rarity="Common"
    
    flavor="${flavor_map[$cmd]}"
    [ -z "$flavor" ] && flavor="No flavor text."

    mastery=$(awk "BEGIN { printf \"%d\", ($execs/$rank)*10 }")
    if [ "$mastery" -gt 100 ]; then
        mastery=100
    fi

    sed -E \
        -e "s|RARITY|$rarity|g" \
        -e "s|COMMAND_NAME|$cmd|g" \
        -e "s|LAST_RUN|$last|g" \
        -e "s|TOTAL_EXECUTIONS|$execs|g" \
        -e "s|RANK|$rank|g" \
        -e "s|ARG_DENSITY|$avgargs|g" \
        -e "s|REDIRECTION|$redir|g" \
        -e "s|MASTERY|$mastery|g" \
	-e "s|FLAVOR_TEXT|$flavor|g" \
	"$templates_dir/html/card" >> "$cards_html"
done < "$cmds_rank"

cat "$templates_dir/html/index_bot" >> "$cards_html"

cp "$cards_html" "$web_dir/cards.html"
cp "$templates_dir/style/styles.css" "$web_dir/styles.css"
echo "cards.html written to $cards_html" 1>&2
echo "cards.html deployed to $web_dir/cards.html" 1>&2
