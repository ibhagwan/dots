# Set working directory
# Set-Location $PSScriptRoot
# [Environment]::CurrentDirectory = $PSScriptRoot

$GitDir  = Split-Path (git -C ${PSScriptRoot} rev-parse --git-dir) -Parent
$DotCmd  = "git -c status.showUntrackedFiles=no --git-dir=${GitDir}\.git -C ${HOME}"
$RepoUrl = Invoke-Expression "${DotCmd} config --get remote.origin.url"

Write-Host "[1;34mBASEDIR:[0;33m  ${PSScriptRoot}[0m"
Write-Host "[1;34mGIT_DIR:[0;33m  ${GitDir}\.git[0m"
Write-Host "[1;34mREPO_URL:[0;33m ${RepoUrl}[0m"
Write-Host "[1;34mDOT_CMD:[0;33m  ${DotCmd}[0m"
Write-Host ""

# set current git worktree to $HOME
Write-Host "[1;32mConfiguring repo[0m [0;34mcore.worktree=[0;33m${HOME}[0m"
git -C ${PSScriptRoot} config core.worktree ${HOME}

# configure repo to not display untracked files
Write-Host "[1;32mConfiguring repo[0m [0;34mstatus.showUntrackedFiles=[0;33mno[0m"
git -C ${PSScriptRoot} config --local status.showUntrackedFiles no

if (Test-Path -Path ${GitDir}/Install.ps1) {
    # pull latest
    echo "[1;32mPulling[0m from [0;33m${RepoUrl}[1;32m...[0m"
    iex "${DotCmd} pull --ff-only --progress --rebase=true"
} else {
    # new install, reset to HEAD (expands into $HOME)
    echo "[1;32mNew install, resetting to [0;33mHEAD[1;32m...[0m"
    iex "${DotCmd} reset --hard HEAD"
}

# update submodules
# echo "[1;32mUpdating submodules...[0m"
# iex "${DotCmd} submodule update --init --recursive"

# setup repo symbolic link at $HOME (requires Admin / Developer mode)
# echo "[1;32mSetup repo link [0m [0;33m$HOME\.git[0m -> [0;33m$GitDir\.git[0m"
# New-Item -ItemType SymbolicLink -Path ${HOME}\.git -Target ${GitDir}\.git -Force

# Deleting local copies
if ( ${HOME} -ne ${GitDir} ) {
    echo "[1;32mDeleting local copies in[0;33m ${GitDir} [0m..."
    ForEach ($path in iex "${DotCmd} ls-tree --name-only HEAD")
    {
        if (Test-Path -Path ${GitDir}\${path}) {
            echo "[0;34mRemove-Item ${GitDir}\${path}[0m"
            Remove-Item -Recurse -Force ${GitDir}\${path}
        }
    }
}

# We don't need an alias, create a global function instead
# which behaves like an alias, e.g. `dot status`
# Explore the contents of the function with:
#  ls function:dot | Select -ExpandProperty ScriptBlock 
#  Get-Command dot | Select -ExpandProperty ScriptBlock
# Remove-Alias -Force -Name dot
# Set-Alias -Name dot -Value global:Dot -Scope Global
iex "Function global:dot { & ${DotCmd} `$args }"
echo "[1;32mCreated the [0;33mdot[1;32m alias.[0m"
