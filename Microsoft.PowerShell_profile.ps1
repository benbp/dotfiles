Import-Module PSReadLine

# $sheep = $(Get-Emoji 'SHEEP')

[ScriptBlock]$PsPrompt = {
    $realLastExitCode = $LASTEXITCODE

    # $host.UI.RawUI.WindowTitle = $pwd.ProviderPath
    $truncatedPwd = ($pwd.ProviderPath.Split("\") | Select -Last 2 ) -Join "/"
    # Microsoft.PowerShell.Utility\Write-Host $truncatedPwd $sheep " " -NoNewLine -ForegroundColor "DarkGray"

    # Microsoft.PowerShell.Utility\Write-Host $truncatedPwd "$" -NoNewLine -ForegroundColor "DarkGray"
    Microsoft.PowerShell.Utility\Write-Host "$" -NoNewLine -ForegroundColor "DarkGray"

    # Set-ItemProperty -Path "HKLM:\Terminal" -Name "cwd" -Value $pwd.ProviderPath
    # $pwd.ProviderPath | Out-File -FilePath C:\Users\bebroder\.psmeta -Encoding ascii -NoNewLine

    $global:LASTEXITCODE = $realLastExitCode
    return " "
}
Set-Item -Path function:\prompt  -Value $PsPrompt  -Options ReadOnly -force

function changedir($dir) {
    if ($dir -eq "-") {
        popd
    } elseif ($dir -eq $null) {
        pushd $HOME
    } else {
        pushd $dir
    }

    # pushHyperStatusline
}

del alias:cd -Force
Set-Alias cd changedir

Set-Alias cf ConvertFrom-Json
Set-Alias ct ConvertTo-Json

function cpf($f) { $env:CurrentFileYank=$(dir $f).FullName }
function pf { cp $env:CurrentFileYank . }

function prof { vim $PROFILE }

if (Test-Path alias:gb) { del alias:gb -Force }
if (Test-Path alias:gf) { del alias:gf -Force }
if (Test-Path alias:gco) { del alias:gco -Force }
if (Test-Path alias:gs) { del alias:gs -Force }
if (Test-Path alias:gp) { del alias:gp -Force }
if (Test-Path alias:gpl) { del alias:gpl -Force }
if (Test-Path alias:ga) { del alias:ga -Force }
if (Test-Path alias:gau) { del alias:gau -Force }
if (Test-Path alias:gd) { del alias:gd -Force }
if (Test-Path alias:gds) { del alias:gds -Force }
if (Test-Path alias:gm) { del alias:gm -Force }
if (Test-Path alias:gam) { del alias:gam -Force }
if (Test-Path alias:gmm) { del alias:gmm -Force }
if (Test-Path alias:gl) { del alias:gl -Force }
if (Test-Path alias:glg) { del alias:glg -Force }
if (Test-Path alias:ggrep) { del alias:ggrep -Force  }
if (Test-Path alias:grb) { del alias:grb -Force }
if (Test-Path alias:cgb) { del alias:cgb -Force }

function gitbranch { git branch $args }
function gitfetch { git fetch --all }

$prevGitBranches = New-Object System.Collections.Stack
function gitcheckout {
    if ($args -eq "hi") {
        $prevGitBranches
        return
    }
    if ($args -eq "-") {
        $lastBranch = $prevGitBranches.Peek()
        git checkout $lastBranch
        if ($LASTEXITCODE -eq 0) {
            $prevGitBranches.Pop()
        }

        # pushHyperStatusline

        return
    }

    $currentBranch = git rev-parse --abbrev-ref head
    $prevGitBranches.Push($currentBranch)
    git checkout $args

    # pushHyperStatusline
}

function gitstatus { git status }
function gitpush { git push $args }
function gitpull { git pull }
function gitadd { git add $args }
function gitaddu { git add -u }
function gitamend { git commit --amend --no-edit }
function gitdiff { git diff }
function gitdiffstaged { git diff --staged }
function gitcommit { git commit -m $args }
function gitaddcommit { git add -u; git commit -m $args }
function gitlogpretty { git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit }
function gitlognum($n) { git log -n $n }
function copybranch {
    git branch | awk '/\*/ {print $2;}' | clip
}
function gitgrep { git grep -i --color --break --heading --line-number $args }
function gitrebase($n) { git rebase -i HEAD~$n }
function gitroot() { git rev-parse --show-toplevel }

Set-Alias gco gitcheckout
Set-Alias gb gitbranch
Set-Alias gf gitfetch
Set-Alias gs gitstatus
Set-Alias gp gitpush
Set-Alias gpl gitpull
Set-Alias ga gitadd
Set-Alias gau gitaddu
Set-Alias gd gitdiff
Set-Alias gds gitdiffstaged
Set-Alias gm gitcommit
Set-Alias gam gitaddcommit
Set-Alias gmm gitamend
Set-Alias gl gitlogpretty
Set-Alias glg gitlognum
Set-Alias ggrep gitgrep
Set-Alias grb gitrebase
Set-Alias cgb copybranch

Set-PSReadLineOption -EditMode Vi
Set-PSReadlineKeyHandler -Chord "j,k" -Function ViCommandMode
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -PredictionSource History

function t { Invoke-Pester }
function tt($tag) { Invoke-Pester -Tag $tag }
function bk($line, $path) { Set-PSBreakpoint -Line $line $path }
function rk($line, $path) { Get-PSBreakpoint | Remove-PSBreakpoint }

function EnableVimJk { Set-PSReadlineKeyHandler -Chord "j,k" -Function ViCommandMode }
function DisableVimJk { Remove-PSReadlineKeyHandler -Chord "j,k" }

Set-Alias envim EnableVimJk
Set-Alias disvim DisableVimJk

Set-PSReadlineKeyHandler -Key Ctrl+k -ScriptBlock {
    if (Get-PSReadlineKeyHandler | ? { $_.Key -eq "j,k" }) {
        Remove-PSReadlineKeyHandler -Chord "j,k"
    } else {
        Set-PSReadlineKeyHandler -Chord "j,k" -Function ViCommandMode
    }
}

Set-PSReadlineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory
Set-PSReadlineKeyHandler -Key Ctrl+l -Function ClearScreen

#Set-PSReadlineKeyHandler -Chord Ctrl+L -ScriptBlock {
#    # pushHyperStatusLine
#}

Set-PSReadlineKeyHandler -Chord Ctrl+p -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('$(pwd).Path')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# Searching for commands with up/down arrow is really handy.  The
# option "moves to end" is useful if you want the cursor at the end
# of the line while cycling through history like it does w/o searching,
# without that option, the cursor will remain at the position it was
# when you used up arrow, which can be useful if you forget the exact
# string you started the search on.
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Clipboard interaction is bound by default in Windows mode, but not Emacs mode.
Set-PSReadlineKeyHandler -Key Shift+Ctrl+C -Function Copy
Set-PSReadlineKeyHandler -Key Ctrl+V -Function Paste

Set-PSReadlineKeyHandler -Key Tab -Function Complete

# Sometimes you enter a command but realize you forgot to do something else first.
# This binding will let you save that command in the history so you can recall it,
# but it doesn't actually execute.  It also clears the line with RevertLine so the
# undo stack is reset - though redo will still reconstruct the command line.
Set-PSReadlineKeyHandler -Key Alt+w `
                         -BriefDescription SaveInHistory `
                         -LongDescription "Save current line in history but do not execute" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
}


# F1 for help on the command line - naturally
Set-PSReadlineKeyHandler -Key F1 `
                         -BriefDescription CommandHelp `
                         -LongDescription "Open the help window for the current command" `
                         -ScriptBlock {
    param($key, $arg)

    $ast = $null
    $tokens = $null
    $errors = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

    $commandAst = $ast.FindAll( {
        $node = $args[0]
        $node -is [System.Management.Automation.Language.CommandAst] -and
            $node.Extent.StartOffset -le $cursor -and
            $node.Extent.EndOffset -ge $cursor
        }, $true) | Select-Object -Last 1

    if ($commandAst -ne $null)
    {
        $commandName = $commandAst.GetCommandName()
        if ($commandName -ne $null)
        {
            $command = $ExecutionContext.InvokeCommand.GetCommand($commandName, 'All')
            if ($command -is [System.Management.Automation.AliasInfo])
            {
                $commandName = $command.ResolvedCommandName
            }

            if ($commandName -ne $null)
            {
                Get-Help $commandName -ShowWindow
            }
        }
    }
}


#
# Ctrl+Shift+j then type a key to mark the current directory.
# Ctrj+j then the same key will change back to that directory without
# needing to type cd and won't change the command line.

#
#$global:PSReadlineMarks = @{}
#
#Set-PSReadlineKeyHandler -Key Ctrl+Shift+j `
#                         -BriefDescription MarkDirectory `
#                         -LongDescription "Mark the current directory" `
#                         -ScriptBlock {
#    param($key, $arg)
#
#    $key = [Console]::ReadKey($true)
#    $global:PSReadlineMarks[$key.KeyChar] = $pwd
#}
#
#Set-PSReadlineKeyHandler -Key Ctrl+j `
#                         -BriefDescription JumpDirectory `
#                         -LongDescription "Goto the marked directory" `
#                         -ScriptBlock {
#    param($key, $arg)
#
#    $key = [Console]::ReadKey()
#    $dir = $global:PSReadlineMarks[$key.KeyChar]
#    if ($dir)
#    {
#        cd $dir
#        [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
#    }
#}

Set-PSReadlineKeyHandler -Key Alt+j `
                         -BriefDescription ShowDirectoryMarks `
                         -LongDescription "Show the currently marked directories" `
                         -ScriptBlock {
    param($key, $arg)

    $global:PSReadlineMarks.GetEnumerator() | % {
        [PSCustomObject]@{Key = $_.Key; Dir = $_.Value} } |
        Format-Table -AutoSize | Out-Host

    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}

Set-PSReadlineOption -CommandValidationHandler {
    param([System.Management.Automation.Language.CommandAst]$CommandAst)

    switch ($CommandAst.GetCommandName())
    {
        'git' {
            $gitCmd = $CommandAst.CommandElements[1].Extent
            switch ($gitCmd.Text)
            {
                'cmt' {
                    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
                        $gitCmd.StartOffset, $gitCmd.EndOffset - $gitCmd.StartOffset, 'commit')
                }
            }
        }
    }
}

