# Installation script for times when FoxitReader bundles its installer *without* a wrapper setup.
#
# Original source of chocolateyInstall.ps1 in the repository: chocolateyInstall.no-wrapper.ps1
# (chocolateyInstall.no-wrapper.ps1 will be automatically copied to chocolateyInstall.ps1 by
#  the update.ps1 AU script.)

$ErrorActionPreference = 'Stop'

# See the comments in  https://github.com/ComFreek/chocolatey-packages/blob/master/foxitreader/update.ps1
# on the &language=German part.
$url32       = 'https://www.foxit.com/downloads/latest.html?product=Foxit-Reader&platform=Windows&package_type=exe&language=German&version=11.0.1.49938'
$checksum32  = 'd6281d2029e46a2203dbf94d302f26213e264be2dee108e7cfd209bb13b15666'

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
