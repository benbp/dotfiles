# Add to C:\Users\<user>\Documents\WindowsPowerShell
# for cmder, remove -NoProfile from the powershell startup task

Import-Module PSReadLine

function acis { cd C:\Repos\EngSys\Acis\Legacy\src }
function acisinit { cd C:\Repos\EngSys\Acis\Legacy; .\init.ps1 }

function prof { vim $PROFILE }
function profile { vim $PROFILE }

function gits { git status }
function gitp { git push }
function gitpf { git push -f }
function gita { git add -u }
function gitd { git diff --staged }
function gitm($msg) { git commit -m $msg }
function gitam($msg) { git add -u; git commit -m $msg }
function gitl { git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit }
function gitlg($n) { git log -n $n }
function copybranch {
    git branch | awk '/\*/ {print $2;}' | clip
}
function gitgrep($term) { git grep -i --color --break --heading --line-number $term }
function gitrb($n) { git rebase -i HEAD~$n }

if (Test-Path alias:gs) { del alias:gs -Force }
if (Test-Path alias:gp) { del alias:gp -Force }
if (Test-Path alias:gpf) { del alias:gpf -Force }
if (Test-Path alias:ga) { del alias:ga -Force }
if (Test-Path alias:gd) { del alias:gd -Force }
if (Test-Path alias:gm) { del alias:gm -Force }
if (Test-Path alias:gam) { del alias:gam -Force }
if (Test-Path alias:gl) { del alias:gl -Force }
if (Test-Path alias:glg) { del alias:glg -Force }
if (Test-Path alias:ggrep) { del alias:ggrep -Force  }
if (Test-Path alias:grb) { del alias:grb -Force }
if (Test-Path alias:cgb) { del alias:cgb -Force }

Set-Alias gs gits
Set-Alias gp gitp
Set-Alias gpf gitpf
Set-Alias ga gita
Set-Alias gd gitd
Set-Alias gm gitm
Set-Alias gam gitam
Set-Alias gl gitl
Set-Alias glg gitlg
Set-Alias ggrep gitgrep
Set-Alias grb gitrb
Set-Alias cgb copybranch

Set-PSReadLineOption -EditMode Vi
Set-PSReadlineKeyHandler -Chord "j,k" -Function ViCommandMode

Set-PSReadlineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory
Set-PSReadlineKeyHandler -Key Ctrl+k -Function ClearScreen

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
$global:PSReadlineMarks = @{}

Set-PSReadlineKeyHandler -Key Ctrl+Shift+j `
                         -BriefDescription MarkDirectory `
                         -LongDescription "Mark the current directory" `
                         -ScriptBlock {
    param($key, $arg)

    $key = [Console]::ReadKey($true)
    $global:PSReadlineMarks[$key.KeyChar] = $pwd
}

Set-PSReadlineKeyHandler -Key Ctrl+j `
                         -BriefDescription JumpDirectory `
                         -LongDescription "Goto the marked directory" `
                         -ScriptBlock {
    param($key, $arg)

    $key = [Console]::ReadKey()
    $dir = $global:PSReadlineMarks[$key.KeyChar]
    if ($dir)
    {
        cd $dir
        [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
    }
}

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
