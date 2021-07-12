# Installation script for times when FoxitReader bundles its installer with a wrapper setup.
#
# Original source of chocolateyInstall.ps1 in the repository: chocolateyInstall.wrapper.ps1
# (chocolateyInstall.wrapper.ps1 will be automatically copied to chocolateyInstall.ps1 by
#  the update.ps1 AU script.)

$ErrorActionPreference = 'Stop'

# See the comments in  https://github.com/ComFreek/chocolatey-packages/blob/master/foxitreader/update.ps1
# on the &language=German part.
$url32       = 'https://www.foxit.com/downloads/latest.html?product=Foxit-Reader&platform=Windows&package_type=exe&language=German&version=11.0.0.49893'
$checksum32  = '6d33ca56b5c6e7f412ff7e7af6a78036df4e7affd1754975ca9a0a89df9d570c'

function Uninstall-PreviousVersion {
	Write-Output 'Uninstalling previous version...'

	$packageArgs = @{
		packageName   = $env:ChocolateyPackageName
		softwareName  = 'Foxit Reader'
		fileType      = 'EXE'
		silentArgs    = "/VERYSILENT /norestart"
		validExitCodes= @(0)
	}

	[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

	if ($key.Count -eq 1) {
		$packageArgs['file'] = $($key[0].UninstallString)
		Uninstall-ChocolateyPackage @packageArgs
	} elseif ($key.Count -gt 1) {
		Write-Warning "$($key.Count) matches found!"
		Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
		Write-Warning "Please alert package maintainer the following keys were matched:"
		$key | % {Write-Warning "- $($_.DisplayName)"}
	}
}

<#
.SYNOPSIS
Download the current version and unwrap the inner native installer.

Return a tuple ($pathToUnwrappedNativeInstaller, $tmpDirectory) where
$tmpDirectory is the directory where the native installer is contained
and which should ideally be deleted after installation.
#>
function Download-CurrentVersion {
	Write-Output 'Downloading current version...' | Out-Null

	# FoxitReader has recently changed to a "wrapped" setup program:
	# The above $url32 will download a wrapper setup EXE, which is more or less
	# a GUI interface to the wrapped inner setup EXE.
	#
	# The wrapper setup neither accepts CLI arguments for silencing nor for
	# configuration as far as we know.
	# Therefore, after downloading the wrapper setup, we extract the wrapped
	# setup EXE and run it manually in Install-CurrentVersion.

	$toolsDir = $(Split-Path -Parent $MyInvocation.ScriptName)
	$wrapperSetupDownloadPath = $(Join-Path $toolsDir "wrapper-setup.exe")
	$wrapperSetupUnzippedPath = $(Join-Path $toolsDir "wrapper-setup-extracted")

	$wrapperDownloadArgs = @{
		PackageName    = 'foxitreader'
		FileFullPath   = $wrapperSetupDownloadPath
		Url            = $url32
		Checksum       = $checksum32
		ChecksumType   = 'sha256'
		Options = @{
			Headers = @{
				# In addition on the '/de/' part in the URL (which actually forces
				# an English language setup), also specify the desired language as
				# an HTTP header even though this had no effect in the past.
				'Accept-Language' = 'de-DE'
			}
		}
	}

	$wrapperUnzipArgs = @{
		PackageName    = 'foxitreader'
		FileFullPath   = $wrapperSetupDownloadPath
		Destination    = $wrapperSetupUnzippedPath
	}

	Get-ChocolateyWebFile @wrapperDownloadArgs | Out-Null
	Get-ChocolateyUnzip @wrapperUnzipArgs | Out-Null

	# Do not use gci -File parameter to retain PS 2 compatibility
	$wrappedSetupPath =
		Get-ChildItem `
			-Path $(Join-Path $wrapperSetupUnzippedPath '$PLUGINSDIR') `
			'FoxitReader*Setup*.exe' `
		| Where {! $_.PSIsContainer} | Select -First 1 -ExpandProperty FullName

	# Continue and don't fail in case AV software locks files
	Remove-Item $wrapperSetupDownloadPath -Recurse -Force -ErrorAction Continue

	return $wrappedSetupPath, $wrapperSetupUnzippedPath
}

function Install-CurrentVersion([string] $installerPath) {
	Write-Output 'Installing current version...'

	$installationArgs = @{
		PackageName    = 'foxitreader'
		FileType       = 'EXE'
		File           = $installerPath
		silentArgs     = '/verysilent'
		validExitCodes = @(0)
	}
	Write-Host $installerPath
	Install-ChocolateyInstallPackage @installationArgs
}

Write-Output 'Downloading current version and then uninstalling previous version (if any) before performing installation of the current version.'

$tmpDirectory = $null

try {
	$installerPath, $tmpDirectory = Download-CurrentVersion
	Uninstall-PreviousVersion
	Install-CurrentVersion $installerPath
}
finally {
	if (-not ($null -eq $tmpDirectory)) {
		# Continue and don't fail in case AV software locks files
		Remove-Item $tmpDirectory -Recurse -Force -ErrorAction Continue
	}
}
