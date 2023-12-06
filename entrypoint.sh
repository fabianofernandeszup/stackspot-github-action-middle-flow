#!/bin/bash -l

echo "execution-id $1"
echo "client-id $2"
echo "client-secret $3"
echo "realm $4"
echo "debug $5"
echo "repository-url $6"

execution_id=$1
client_id=$2
client_secret=$3
realm=$4
debug=$5
repo_url=$6

secret_stk_login=$(curl --location --request POST "https://idm.stackspot.com/realms/$realm/protocol/openid-connect/token" \
    --header "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "client_id=$client_id" \
    --data-urlencode "grant_type=client_credentials" \
    --data-urlencode "client_secret=$client_secret" | jq -r .access_token)

echo ""
echo https://workflow-api.v1.stackspot.com/workflows/$execution_id | base64
echo ""
echo "Bearer $secret_stk_login" | base64
echo ""

http_code=$(curl -s -o script.sh -w '%{http_code}' https://workflow-api.v1.stackspot.com/workflows/$execution_id --header "Authorization: Bearer $secret_stk_login";)
pwd
ls -lha
if [[ "$http_code" -ne "200" ]]; then
    echo "------------------------------------------------------------------------------------------"
    echo "---------------------------------------- Debug Starting ----------------------------------"
    echo "------------------------------------------------------------------------------------------"
    echo "HTTP_CODE:" $http_code
    echo "RESPONSE_CONTENT:"
    cat script.sh
    exit $http_code
    echo "------------------------------------------------------------------------------------------"
    echo "---------------------------------------- Debug Ending ------------------------------------"
    echo "------------------------------------------------------------------------------------------"
else
    echo "HTTP_CODE:" $http_code
    chmod +x script.sh
    echo "------------------------------------------------------------------------------------------"
    echo "---------------------------------------- Starting ----------------------------------------"
    echo "------------------------------------------------------------------------------------------"
    bash script.sh
    echo "------------------------------------------------------------------------------------------"
    echo "----------------------------------------  Ending  ----------------------------------------"
    echo "------------------------------------------------------------------------------------------"
fi