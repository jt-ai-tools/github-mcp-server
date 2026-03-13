#!/bin/bash

# 取得所有需要翻譯的檔案清單
FILES=$(./scripts/list_md_files.sh)
MISSING=0

for FILE in $FILES; do
    # 取得副檔名
    EXT="${FILE##*.}"
    # 取得檔名（不含副檔名）
    BASE="${FILE%.*}"
    # 中文版檔名
    ZH_FILE="${BASE}_zh_TW.${EXT}"

    if [ ! -f "$ZH_FILE" ]; then
        echo "缺少翻譯: $FILE -> $ZH_FILE"
        MISSING=$((MISSING + 1))
    fi
done

if [ $MISSING -eq 0 ]; then
    echo "恭喜！所有檔案都已完成翻譯。"
    exit 0
else
    echo "共有 $MISSING 個檔案尚未翻譯。"
    exit 1
fi
