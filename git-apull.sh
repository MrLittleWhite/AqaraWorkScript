#!/bin/bash

NAME=$1

# 颜色
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RESET="\033[0m"

cd ..

checkout_branch() {
    
    git fetch --all

    branch=$(git branch -r | grep "${NAME}" | head -n 1 | sed 's/origin\///' | xargs)

    if [[ -n "$branch" ]]; then
    
        if git rev-parse --verify "$branch" &>/dev/null; then
            echo -e "${GREEN}本地分支 '$branch' 已存在，切换到该分支...${RESET}"
            if git checkout "$branch"; then
                echo -e "${GREEN}成功切换到分支 '$branch'！${RESET}"
            else
                echo -e "${RED}错误: 切换分支 '$branch' 失败！${RESET}"
            fi
        else
            echo -e "${WHITE}本地分支不存在，正在创建并检出远程分支 '$branch'...${RESET}"
            if git checkout -b "$branch" "origin/$branch"; then
                echo -e "${GREEN}成功创建并检出分支 '$branch'！${RESET}"
            else
                echo -e "${RED}错误: 创建并检出 '$branch' 失败！${RESET}"
            fi
        fi
    else
        echo -e "${YELLOW}未找到\"${NAME}\"的相关分支${RESET}"
    fi
}



if [ -z "$NAME" ]; then

    echo -e "${YELLOW}正在拉取分支最新代码${RESET}\n"
    
    for d in *; do [[ -d $d/.git ]] && pushd $d && git pull && sleep 1 || echo -e "\033[31mgit pull failed in $d\033[0m" && popd>/dev/null; done;
else
    
    echo -e "${GREEN}正在远程检出对应分支${RESET}\n"

    for d in *; do [[ -d $d/.git ]] && pushd $d && checkout_branch && sleep 1 && git pull && sleep 1 || echo -e "\033[31mgit pull failed in $d\033[0m" && popd>/dev/null; done;
fi



