#!/bin/bash

cd ~/Library/Developer/Xcode/UserData/CodeSnippets

git add .
git commit -m "feat: add snippets"

export https_proxy=http://127.0.0.1:8118
export http_proxy=http://127.0.0.1:8118
git push origin main
unset http_proxy
unset https_proxy
