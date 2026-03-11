#!/bin/bash

source "$(dirname "$0")/settings.sh"
echo "Settings loaded."

repo_dir=$(cd "$(dirname "$0")/.." && pwd)

sudo mkdir -p "$install_dir"
sudo mkdir -p "$web_dir"

sudo chmod 755 "$install_dir"
sudo chmod 755 "$web_dir"

sudo cp -r "$repo_dir/scripts" "$install_dir/"
sudo cp -r "$repo_dir/templates" "$install_dir/"
sudo cp -r "$repo_dir/data" "$install_dir/"

echo "Project installed to $install_dir"
echo "Web directory prepared at $web_dir"
