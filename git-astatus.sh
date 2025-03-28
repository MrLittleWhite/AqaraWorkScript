#!/bin/bash

cd ..

for d in *; do [[ -d $d/.git ]] && pushd $d && git status || echo -e "\033[31mgit status failed in $d\033[0m" && popd>/dev/null; done;
