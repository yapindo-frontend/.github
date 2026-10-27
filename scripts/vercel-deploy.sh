#!/usr/bin/env bash
# Deploys a commit to Vercel from your machine the way the shared workflow does
# (.github/workflows/vercel-deploy.yml): only the committed files, without git
# metadata, so Vercel doesn't refuse it because the commit's author has no seat.
# For when the workflow can't run; the fix still goes through a pull request.
#
# Run it in the app's repository:
#   VERCEL_TOKEN=... vercel-deploy.sh <team> <project> <prod|preview|environment> [ref]
#
#   team         yapindo-fe-s-team or yapindo-frontend-2
#   environment  a custom environment, such as dev (staging)
#   ref          the commit to deploy, HEAD by default; uncommitted changes are left out
#   VERCEL_TOKEN the team's token; without it, the account you logged in with (vercel login)
#
# After an Instant Rollback a production deploy doesn't go live by itself:
# undo the rollback, or `vercel promote <url>`.
set -euo pipefail

if [ $# -lt 3 ]; then
  sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'
  exit 2
fi
team=$1 project=$2 target=$3 ref=${4:-HEAD}

case $target in
  prod) args=(--prod) ;;
  preview) args=() ;;
  *) args=("--target=$target") ;;
esac

sha=$(git rev-parse --verify "$ref^{commit}")
repo=$(git remote get-url origin | sed -E 's#^.*[:/]([^/]+/[^/]+)$#\1#; s#\.git$##')
actor=$(gh api user --jq .login 2>/dev/null || git config user.name)
name=$(git rev-parse --abbrev-ref "$ref" 2> /dev/null || true)
[ -n "$name" ] || name=$ref

echo "Deploying $repo $(git log -1 --format='%h %s' "$sha")"
echo "to $project ($team), $target"
if [ "$target" = prod ]; then
  read -r -p "This goes to production. Continue? [y/N] " answer
  [ "$answer" = y ] || exit 1
fi

dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
git archive "$sha" | tar -x -C "$dir"
cd "$dir"

npx -y vercel@latest link --yes --project "$project" --scope "$team"
npx -y vercel@latest deploy ${args[@]+"${args[@]}"} \
  --meta actor="$actor" \
  --meta triggeredBy="$actor" \
  --meta repo="$repo" \
  --meta ref="$name" \
  --meta sha="$sha" \
  --meta run=manual
