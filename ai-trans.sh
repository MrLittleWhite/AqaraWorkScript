#!/bin/bash -i

set -e

TITLE=$1

#    #https://azure.microsoft.com/zh-cn/pricing/details/cognitive-services/translator/
#    API_KEY="DfxORmDa5trbEq3lHXkJHc66dxnOeSgCaqR7NM79Pp0cZ1NAoOpJJQQJ99ALAC3pKaRXJ3w3AAAbACOGIKyb"
#    API_URL="https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&from=zh&to=en"
#    REGION="eastasia"
#
#    RESPONSE_JSON=$(curl -s -X POST "$API_URL" \
#      -H "Ocp-Apim-Subscription-Key: $API_KEY" \
#      -H "Ocp-Apim-Subscription-Region: $REGION" \
#      -H "Content-Type: application/json" \
#      -d "[{'Text':'$TITLE'}]")
#
#    echo -e "raw JSON:\n"
#    echo "$RESPONSE_JSON" | jq -M
#    echo -e "\n"
#
#    TRANSLATED_TEXT=$(echo $RESPONSE_JSON | jq -r '.[0].translations[0].text')

RESPONSE_JSON=$(curl https://aigchub-api.aqara.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer sk-Q0vaFgs1WY4UXhsUE003877eCbCe4dA3959f38Ab44E02f22" \
    -d '{
    "model": "gpt-3.5-turbo",
    "stream": false,
    "prompt": "Translate the following Chinese text into English: '$TITLE'"
    }')

echo -e "raw JSON:\n" > $(tty)
echo "$RESPONSE_JSON" | jq -M > $(tty)
echo -e "\n" > $(tty)
  
TRANSLATED_TEXT=$(echo $RESPONSE_JSON | jq -r '.choices[0].message.content')

echo "$TRANSLATED_TEXT"

exit 0
