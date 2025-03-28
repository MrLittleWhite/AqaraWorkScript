#!/bin/bash

set -e

LOGFILE="$HOME/Desktop/git_log.txt"
COMMITFILE="$HOME/Desktop/commit_log.txt"

declare TRANSLATED_TEXT
NON_JIRA_MODE=0
# 获取 Jira Issue Key
ISSUE_KEY=$1
TARGET_DIR=$2
MESSAGE_COMMAND=$1
MESSAGE_CHINESE=$2

# 颜色
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
RESET="\033[0m"

function translate {

    set -e

    CONTENT=$1

    echo -e "${GREEN}aigchub-api.aqara.com正在翻译: ${RESET}${YELLOW}${CONTENT}${RESET}\n"

    ESCAPE_CONTENT="{
    \"model\": \"gpt-3.5-turbo\",
    \"stream\": false,
    \"prompt\": \"Translate the following Chinese text into English and give the translated English result directly without Chinese: ${CONTENT}\"
}"
    
    echo -e "${BLUE}${ESCAPE_CONTENT}${RESET}"

    RESPONSE_JSON=$(curl --max-time 5 --retry 5 --url https://aigchub-api.aqara.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer sk-Q0vaFgs1WY4UXhsUE003877eCbCe4dA3959f38Ab44E02f22" \
        -d "$ESCAPE_CONTENT")
    
    echo -e "raw JSON:\n"
    echo "$RESPONSE_JSON" | jq -M
    echo -e "\n"
      
    TRANSLATED_TEXT=$(echo $RESPONSE_JSON | jq -r '.choices[0].message.content')
    
}

function commit {

    set -e

    if [ $NON_JIRA_MODE -eq 0 ]; then
    
        echo -e "${YELLOW}使用 jira-cli 获取 Issue 详情，并提取标题（Summary)${RESET}\n"
        RAW_JSON=$(jira issue view $ISSUE_KEY --raw)
        
        TITLE=$(echo $RAW_JSON | jq -r '.fields.summary')
    else
        TITLE="$MESSAGE_CHINESE"
    fi
    
    echo -e "${GREEN}成功获取标题: ${RESET}${YELLOW}${TITLE}${RESET}\n"
    
    translate "${TITLE}"
#    TRANSLATED_TEXT=$(${TRANSLATED_LOG} | tail -n 1)
    
    echo -e "${BLUE}获取翻译结果: ${RESET}${YELLOW}${TRANSLATED_TEXT}${RESET}\n"
    
    if [ -z "$TRANSLATED_TEXT" ] || [ "$TRANSLATED_TEXT" == "null" ]; then
        echo -e "${RED}翻译失败${RESET}\n"
        exit 1
    fi

    SUBJECT_TEXT="feat: $TRANSLATED_TEXT"
    if [ $NON_JIRA_MODE -eq 0 ]; then
        ISSUE_URL="https://jira.aqara.com/browse/$ISSUE_KEY"
        DESCRIPTION_TEXT=$(echo -e "${TITLE}\n$ISSUE_URL")
    else
        DESCRIPTION_TEXT="$TITLE"
    fi

    echo -e "${YELLOW}${SUBJECT_TEXT}${RESET}\n"
    echo -e "${GREEN}${DESCRIPTION_TEXT}${RESET}\n"

    pwd

    git commit -m "$SUBJECT_TEXT" -m "$DESCRIPTION_TEXT"
    git push
    
    echo -e "${BLUE}写入记录${COMMITFILE}${RESET}"
    if [ -e "$COMMITFILE" ]; then
        echo "${TITLE}" >> "$COMMITFILE"
        echo -e "${GREEN}${TITLE}${RESET}"
    else
        touch "$COMMITFILE"
        echo "${TITLE}" > "$COMMITFILE"
        echo -e "${GREEN}${TITLE}${RESET}"
    fi
    
    if [ $NON_JIRA_MODE -eq 0 ]; then
        echo "${ISSUE_URL}" >> "$COMMITFILE"
        echo -e "${GREEN}${ISSUE_URL}${RESET}"
    else
        echo "${SUBJECT_TEXT}" >> "$COMMITFILE"
        echo -e "${GREEN}${SUBJECT_TEXT}${RESET}"
    fi
}

ORIGINAL_PATH=$(pwd)

if [ -n "$MESSAGE_COMMAND" ] && [ "$MESSAGE_COMMAND" == "-c" ]; then

    TARGET_DIR=$3
    NON_JIRA_MODE=1
    
    if [ -z "$MESSAGE_CHINESE" ]; then
        echo -e "${RED}提交的中文内容不能为空${RESET}\n"
        exit 1
    fi
    
fi

# 检查用户是否输入了内容
if [ -z "$TARGET_DIR" ]; then
    cd ..
    echo -e "${YELLOW}请输入目标文件夹名称，当前目录直接输入回车${RESET}\n"
    read -e -p "> " TARGET_DIR
else
    if [ "$TARGET_DIR" == "." ]; then
        commit
        exit
    fi
    cd ..
fi


if [ -z "$TARGET_DIR" ]; then
    cd "$ORIGINAL_PATH"
    commit
else
    # 检查目标文件夹是否存在
    if [ -d "$TARGET_DIR" ]; then
        cd "$TARGET_DIR" # 进入目标文件夹，如果失败则退出脚本
        echo -e "${GREEN}进入目标文件夹: $TARGET_DIR${RESET}\n"

        commit
    else
        echo -e "${RED}目标文件夹不存在: $TARGET_DIR${RESET}\n"
        exit 1
    fi
fi

