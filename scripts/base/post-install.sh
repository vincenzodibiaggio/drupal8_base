#!/bin/sh

# Replace .gitignore with .gitignore.final"
mv -f .gitignore.final .gitignore

# Remove Git related files and directories
rm -r .git
rm README.md
