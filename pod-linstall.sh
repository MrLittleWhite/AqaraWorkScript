#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RESET="\033[0m"

unset http_proxy
unset https_proxy

pod cache clean --all

if [ $? -ne 0 ]; then
    echo -e "${RED}pod cache clean -all${RESET}\n"
    # 处理错误，比如退出脚本
    exit 1
fi

local=0 pod install

if [ $? -ne 0 ]; then
    echo -e "${RED}local=0 pod install${RESET}\n${GREEN}enable proxy & pod install again${RESET}"


    export https_proxy=http://127.0.0.1:8118
    export http_proxy=http://127.0.0.1:8118
    
    local=0 pod install
    
    if [ $? -ne 0 ]; then
    #    echo -e "${RED}pod cache clean -all${RESET}\n"
    
        unset http_proxy
        unset https_proxy
    
        exit 1
    fi
fi

unset http_proxy
unset https_proxy

open AqaraHome.xcworkspace
