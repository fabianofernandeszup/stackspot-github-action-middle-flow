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

secret_stk_login=$(curl --location --request POST "https://idm.stackspot.com/realms/$realm/protocol/openid-connect/token" \
    --header "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "client_id=$client_id" \
    --data-urlencode "grant_type=client_credentials" \
    --data-urlencode "client_secret=$client_secret" | jq .access_token)

http_code=$(curl -s -o script.sh -w '%{http_code}' https://workflow-api.v1.stackspot.com/workflows/$execution_id --header "Authorization: Bearer $secret_stk_login";)
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
    chmod +x script.sh
    echo "------------------------------------------------------------------------------------------"
    echo "---------------------------------------- Starting ----------------------------------------"
    echo "------------------------------------------------------------------------------------------"
    bash script.sh
    echo "------------------------------------------------------------------------------------------"
    echo "----------------------------------------  Ending  ----------------------------------------"
    echo "------------------------------------------------------------------------------------------"
fi