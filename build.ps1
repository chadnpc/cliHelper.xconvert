﻿using namespace System
using namespace System.IO
using namespace System.Management.Automation
#.SYNOPSIS
#   cliHelper.xconvert buildScript v0.1.9
#.DESCRIPTION
#   A custom Psake buildScript for the module cliHelper.xconvert.
#.EXAMPLE
#   Running ./build.ps1 will only "Init, Compile & Import" the module; That's it, no tests.
#   To run tests Use:
#   ./build.ps1 -Task Test
#   This Will build the module, Import it and run tests using the ./Test-Module.ps1 script.
#.EXAMPLE
#   ./build.ps1 -Task deploy
#   Will build the module, test it and deploy it to PsGallery
#.LINK
#   https://github.com/chadnpc/cliHelper.xconvert/blob/main/build.ps1
#.NOTES
#   Author   : Alain Herve
#   Copyright: Copyright © 2024 Alain Herve. All rights reserved.
#   License  : MIT
[cmdletbinding(DefaultParameterSetName = 'task')]
param(
  [parameter(Mandatory = $false, Position = 0, ParameterSetName = 'task')]
  [ValidateScript({
      $task_seq = [string[]]$_; $IsValid = $true
      $Tasks = @('Clean', 'Compile', 'Test', 'Deploy')
      foreach ($name in $task_seq) {
        $IsValid = $IsValid -and ($name -in $Tasks)
      }
      if ($IsValid) {
        return $true
      } else {
        throw [System.ArgumentException]::new('Task', "ValidSet: $($Tasks -join ', ').")
      }
    }
  )][ValidateNotNullOrEmpty()][Alias('t')]
  [string[]]$Task = 'Test',

  # Module buildRoot
  [Parameter(Mandatory = $false, Position = 1, ParameterSetName = 'task')]
  [ValidateScript({
      if (Test-Path -Path $_ -PathType Container -ea Ignore) {
        return $true
      } else {
        throw [System.ArgumentException]::new('Path', "Path: $_ is not a valid directory.")
      }
    })][Alias('p')]
  [string]$Path = (Resolve-Path .).Path,

  [Parameter(Mandatory = $false, ParameterSetName = 'task')]
  [string[]]$RequiredModules = @(),

  [parameter(ParameterSetName = 'task')]
  [Alias('i')]
  [switch]$Import,

  [parameter(ParameterSetName = 'help')]
  [Alias('h', '-help')]
  [switch]$Help
)

begin {
  if ($PSCmdlet.ParameterSetName -eq 'help') { Get-Help $MyInvocation.MyCommand.Source -Full | Out-String | Write-Host -f Green; return }
  $IsGithubRun = ![string]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable('GITHUB_WORKFLOW'))
  if ($($IsGithubRun ? $true : $(try { (Test-Connection "https://www.github.com" -Count 2 -TimeoutSeconds 1 -ea Ignore -Verbose:$false | Select-Object -expand Status) -contains "Success" } catch { Write-Warning "Test Connection Failed. $($_.Exception.Message)"; $false }))) {
    $req = Invoke-WebRequest -Method Get -Uri https://raw.githubusercontent.com/chadnpc/PsCraft/refs/heads/main/Public/Build-Module.ps1 -SkipHttpErrorCheck -Verbose:$false
    if ($req.StatusCode -ne 200) { throw "Failed to download Build-Module.ps1" }
    $t = New-Item $([IO.Path]::GetTempFileName().Replace('.tmp', '.ps1')) -Verbose:$false; Set-Content -Path $t.FullName -Value $req.Content; . $t.FullName; Remove-Item $t.FullName -Verbose:$false
  } else {
    $m = Get-InstalledModule PsCraft -Verbose:$false -ea Ignore
    $b = [IO.FileInfo][IO.Path]::Combine($m.InstalledLocation, 'Public', 'Build-Module.ps1')
    if ($b.Exists) { . $b.FullName }
  }
}
process {
  $shouldInstalldotnet = $( if (!(Get-Command dotnet -CommandType Application -ErrorAction Ignore)) { $true } elseif ([string]::IsNullOrWhiteSpace((dotnet --list-sdks)) -or !((dotnet --list-sdks) -match '9\.\d+\.\d+')) { $true } else { $false } )
  if ($shouldInstalldotnet) {
    if ($IsWindows) {
      winget install --id=Microsoft.DotNet.SDK.9 -e
    }
  }
  Build-Module -Task $Task -Path $Path -Import:$Import
}