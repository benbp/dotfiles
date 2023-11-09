param(
    [parameter(Mandatory = $true)]
    [string]$PullRequestNumber
)

$prs = curl --silent https://github.com/Azure/azure-sdk-tools/pull/$PullRequestNumber `
        | grep -oP '\KAzure.azure-sdk-for-.*.pull.[0-9]*\"' `
        | sed 's/\"//' `
        | grep -v issues `
        | % { "https://github.com/$_" }

foreach ($pr in $prs) {
    $title = (gh pr view $pr --json 'title' | ConvertFrom-Json).title
    if ($title -notlike 'Sync eng/common*') {
        continue
    }
    $checks = (gh pr view $pr --json 'statusCheckRollup' | ConvertFrom-Json).statusCheckRollup
    
    # Old check enforcer
    # if ($checks | ? { $_.name -eq "check-enforcer" -and $_.status -eq "COMPLETED" } ) {
    # New check enforcer
    if ($checks | ? { $_.context -eq "https://aka.ms/azsdk/checkenforcer" -and $_.state -eq "SUCCESS" } ) {
        Write-Host "-----------------------------------------------------------------------"
        Write-Host "$pr - SUCCESS"
        Write-Host "-----------------------------------------------------------------------"
        continue
    }

    $pending = $checks | ? {
        $_.__typename -eq "CheckRun" `
        -and $_.status -ne "COMPLETED"
        # -and $_.name -ne "check-enforcer"
    }

    $failed = $checks | ? {
        $_.__typename -eq "CheckRun" `
        -and $_.status -ne "COMPLETED" -and $_.status -ne "IN_PROGRESS" -and $_.status -ne "QUEUED" `
        -and $_.conclusion -ne "SUCCESS"
        # -and $_.name -ne "check-enforcer"
    }
    
    if ($pending -or $failed) {
        Write-Host "-----------------------------------------------------------------------"
        Write-Host $pr
        Write-Host "-----------------------------------------------------------------------"
        if ($pending) {
            Write-Host "-> PENDING"
        }
        foreach ($p in $pending) {
            Write-Host "---> $($p.name)"
        }
        if ($failed) {
            Write-Host "-> FAILED"
        }
        foreach ($f in $failed) {
            Write-Host "---> [$($f.name)] - $($f.detailsUrl)"
        }
    } else {
        Write-Host "$pr - CHECK ENFORCER PENDING"
    }
}
