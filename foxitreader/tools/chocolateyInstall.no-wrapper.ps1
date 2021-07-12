# Installation script for times when FoxitReader bundles its installer *without* a wrapper setup.
#
# Original source of chocolateyInstall.ps1 in the repository: chocolateyInstall.no-wrapper.ps1
# (chocolateyInstall.no-wrapper.ps1 will be automatically copied to chocolateyInstall.ps1 by
#  the update.ps1 AU script.)

$ErrorActionPreference = 'Stop'

# See the comments in  https://github.com/ComFreek/chocolatey-packages/blob/master/foxitreader/update.ps1
# on the &language=German part.
$url32       = 'https://www.foxit.com/downloads/latest.html?product=Foxit-Reader&platform=Windows&package_type=exe&language=German&version=11.0.0.49893'
$checksum32  = '6d33ca56b5c6e7f412ff7e7af6a78036df4e7affd1754975ca9a0a89df9d570c'

$installationArgs = @{
	PackageName    = 'foxitreader'
	FileType       = 'EXE'
	Url            = $url32
	Checksum       = $checksum32
	ChecksumType   = 'sha256'
	silentArgs     = '/verysilent'
	validExitCodes = @(0)
}

Install-ChocolateyPackage @installationArgs
