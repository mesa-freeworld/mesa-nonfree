#!/bin/bash

for branch in stable testing unstable; do
    repo_dir=docs/${branch}/x86_64
    mkdir -p "$repo_dir"

    db_path="$repo_dir/mesa-nonfree.db.tar.gz"
    files_path="$repo_dir/mesa-nonfree.files.tar.gz"
    rm -f "$db_path" "$files_path"
    repo-add --sign --new --remove --prevent-downgrade "$repo_dir"/mesa-nonfree.db.tar.gz "$repo_dir"/*.zst
    rm "$repo_dir"/*.old*
done
