#!/usr/bin/env bash
# Gives repositories the organization's standard labels, from labels.json next
# to this script's directory: creates the missing ones and fixes the color or
# description of those that differ. It never deletes a label, so labels a
# repository adds for itself (release-please's "autorelease: …", for example)
# stay. For a new repository, the organization's default labels (Settings →
# Repository → Repository labels) do the same when it's created.
#
#   sync-labels.sh [--dry-run] [repository...]
#
#   --dry-run    only print what would change
#   repository   names in yapindo-frontend; every repository that isn't archived by default
#
# Needs the GitHub CLI, signed in as someone who can manage the repositories' labels.
set -euo pipefail

org=yapindo-frontend
labels="$(cd "$(dirname "$0")/.." && pwd)/labels.json"
dry=false
if [ "${1:-}" = --dry-run ]; then
  dry=true
  shift
fi

if [ $# -gt 0 ]; then
  repos=("$@")
else
  repos=()
  while IFS= read -r r; do repos+=("$r"); done < <(
    gh repo list "$org" --limit 1000 --no-archived --json name --jq '.[].name' | sort
  )
fi

changes=0
for repo in "${repos[@]}"; do
  current=$(gh label list -R "$org/$repo" --limit 1000 --json name,color,description)
  while IFS=$'\t' read -r name color description; do
    # GitHub matches label names without regard to case.
    have=$(jq -r --arg n "$name" \
      '[.[] | select((.name | ascii_downcase) == ($n | ascii_downcase))][0] // empty | "\(.color | ascii_downcase)\t\(.description)"' \
      <<< "$current")
    if [ -z "$have" ]; then
      action=create
    elif [ "$have" != "$color"$'\t'"$description" ]; then
      action=update
    else
      continue
    fi
    echo "$repo: $action $name"
    changes=$((changes + 1))
    $dry || gh label create "$name" -R "$org/$repo" --color "$color" --description "$description" --force > /dev/null
  done < <(jq -r '.[] | [.name, (.color | ascii_downcase), .description] | @tsv' "$labels")
done

if $dry; then
  echo "$changes change(s) to make, in ${#repos[@]} repositories"
else
  echo "$changes change(s) made, in ${#repos[@]} repositories"
fi
