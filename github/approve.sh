function approve_sync() {
    # curl https://api.github.com/repos/Azure/azure-sdk-tools/issues/$1/timeline \
    #     | jq '.[].source | select(.issue.title != null) | select(.issue.title | contains("Sync eng/common")) | .issue.html_url' \
    #     | xargs -I % bash -c 'gh pr review --approve %'

    curl --silent https://github.com/Azure/azure-sdk-tools/pull/$1 \
        | grep -oP '\KAzure.azure-sdk-for-.*.pull.[0-9]*\"' \
        | sed 's/\"//' \
        | grep -v issues \
        | xargs -I % bash -c 'echo https://github.com/% && gh pr review --approve https://github.com/%'
}

