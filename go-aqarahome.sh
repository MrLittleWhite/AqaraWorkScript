#!/bin/bash

# 颜色
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RESET="\033[0m"

DOCUMENTS_PATH="/Users/yunzhi.liu-a2105/Documents/aqarahome"
DESKTOP_PATH="/Users/yunzhi.liu-a2105/Desktop/Lumi/aqarahome"

PATH_INDEX=$1

# 首次检查使用黄色提示
if [ -z "$PATH_INDEX" ] || [ "$PATH_INDEX" == "0" ]; then
    echo -e "${YELLOW}请选择AqaraHome目录，1：Documents，2：Desktop，0：退出${RESET}\n"
    read -e -p "> " PATH_INDEX
fi

# 输入错误使用红色提示
while [ "$PATH_INDEX" != "1" ] && [ "$PATH_INDEX" != "2" ] && [ "$PATH_INDEX" != "0" ]
do
    echo -e "${RED}请选择AqaraHome目录，1：Documents，2：Desktop，0：退出${RESET}\n"
    read -e -p "> " PATH_INDEX
done

if [ "$PATH_INDEX" == "1" ] || [ "$PATH_INDEX" == "." ] ; then
    if [ ! -d "$DOCUMENTS_PATH" ]; then
        echo "${RED}目标目录不存在：$DOCUMENTS_PATH${RESET}"
        exit 1
    else
        cd "$DOCUMENTS_PATH"
        echo -e "${GREEN}当前目录：$(pwd)${RESET}"
    fi
    exit
fi

if [ "$PATH_INDEX" == "2" ]; then
    if [ ! -d "$DESKTOP_PATH" ]; then
        echo "${RED}目标目录不存在：$DESKTOP_PATH${RESET}"
        exit 1
    else
        cd "$DESKTOP_PATH"
        echo -e "${GREEN}当前目录：$(pwd)${RESET}"
    fi
    exit
fi
