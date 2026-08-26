#!/usr/bin/env bash

set -euo pipefail

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
project_root=$(cd -- "$script_dir/.." && pwd)
cd "$project_root"

project_version=$(sed -n 's/^version = "\([^"]*\)"/\1/p' pyproject.toml)
package_version=$(sed -n 's/^__version__ = "\([^"]*\)"/\1/p' src/panmetis/__init__.py)
version=${1:-$project_version}

[[ -n "$version" ]] || fail "could not determine the distribution version"
[[ "$project_version" == "$package_version" ]] || fail "version declarations do not match"
[[ "$version" == "$project_version" ]] || fail "requested version $version does not match project version $project_version"

shopt -s nullglob
sdist_artifacts=(dist/panmetis-"$version"*.tar.gz)
wheel_artifacts=(dist/panmetis-"$version"-*.whl)
shopt -u nullglob

[[ ${#sdist_artifacts[@]} -eq 1 ]] || fail "expected one sdist for $version, found ${#sdist_artifacts[@]}"
[[ ${#wheel_artifacts[@]} -eq 1 ]] || fail "expected one wheel for $version, found ${#wheel_artifacts[@]}"

verification_tmp=$(mktemp -d)
trap 'rm -rf "$verification_tmp"' EXIT

find src/panmetis/skills -type f -printf '%P\n' | LC_ALL=C sort > "$verification_tmp/source"
[[ -s "$verification_tmp/source" ]] || fail "source skill tree is empty"

sdist_prefix="panmetis-$version/src/panmetis/skills/"
tar -tzf "${sdist_artifacts[0]}" |
  awk -v prefix="$sdist_prefix" '
    index($0, prefix) == 1 {
      path = substr($0, length(prefix) + 1)
      if (path != "" && substr(path, length(path), 1) != "/") print path
    }
  ' > "$verification_tmp/sdist"

wheel_prefix="panmetis/skills/"
unzip -Z1 "${wheel_artifacts[0]}" |
  awk -v prefix="$wheel_prefix" '
    index($0, prefix) == 1 {
      path = substr($0, length(prefix) + 1)
      if (path != "" && substr(path, length(path), 1) != "/") print path
    }
  ' > "$verification_tmp/wheel"

verify_tree() {
  local label=$1
  local actual=$2
  local sorted="$verification_tmp/$label-sorted"
  local duplicates="$verification_tmp/$label-duplicates"

  LC_ALL=C sort "$actual" > "$sorted"
  uniq -d "$sorted" > "$duplicates"
  if [[ -s "$duplicates" ]]; then
    printf 'duplicate %s skill entries:\n' "$label" >&2
    sed 's/^/  /' "$duplicates" >&2
    fail "$label contains duplicate skill entries"
  fi

  if ! diff -u "$verification_tmp/source" "$sorted"; then
    fail "$label skill tree does not match source"
  fi
}

verify_tree sdist "$verification_tmp/sdist"
verify_tree wheel "$verification_tmp/wheel"

skill_count=$(wc -l < "$verification_tmp/source")
printf 'verified %s: one sdist and one wheel, each containing all %s skill files exactly once\n' "$version" "$skill_count"
