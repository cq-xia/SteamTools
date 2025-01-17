param([string]$version = '1.0.0',$configuration='Release',$token='')
$ErrorActionPreference = 'Stop'

Write-Host 'dotnet SDK info'
dotnet --info

$publishtool_tfm = 'net6.0'
$output_dir = "..\src\ST.Client.Desktop.Avalonia.App\bin\$configuration\Publish"
$proj_path = "..\src\ST.Client.Desktop.Avalonia.App\ST.Client.Avalonia.App.csproj"

$publishtool_dir = "..\src\ST.Tools.Publish"
$publishtool_exe = "$publishtool_dir\bin\$configuration\$publishtool_tfm\p.exe"

$build_pubxml_dir = "..\src\ST.Client.Desktop.Avalonia.App\Properties\PublishProfiles"

$build_pubxml_winx64_fd = "fd-win-x64.pubxml"
$build_pubxml_winx64 = "win-x64.pubxml"
$build_pubxml_osxx64 = "osx-x64.pubxml"
$build_pubxml_linuxx64 = "linux-x64.pubxml"
$build_pubxml_linuxarm64 = "linux-arm64.pubxml"

function Build-PublishTool
{
    dotnet build -c Release -f $publishtool_tfm $publishtool_dir\ST.Tools.Publish.csproj

    if ($LASTEXITCODE) { exit $LASTEXITCODE }

    $dev=''
    if($configuration -eq 'Debug')
    {
        $dev = "-dev 1"
    }
    
    & $publishtool_exe ver -token $token $dev

    if ($LASTEXITCODE) { exit $LASTEXITCODE }

    # build App
    Build-App fd-win-x64
    Build-App win-x64
    Build-App osx-x64
    Build-App linux-x64
    Build-App linux-arm64

    & $publishtool_exe full -token $token $dev

    if ($LASTEXITCODE) { exit $LASTEXITCODE }
}

function Build-App
{
    param([string]$rid)

    Write-Host "Building App $version $rid"

    $publishDir = "$output_dir\$rid"

    Remove-Item $publishDir -Recurse -Force -Confirm:$false -ErrorAction Ignore

    if($rid -eq 'fd-win-x64'){ $pubxml = "$build_pubxml_dir\$build_pubxml_winx64_fd" }
    if($rid -eq 'win-x64'){ $pubxml = "$build_pubxml_dir\$build_pubxml_winx64" }
    if($rid -eq 'osx-64'){ $pubxml = "$build_pubxml_dir\$build_pubxml_osxx64" }
    if($rid -eq 'linux-x64'){ $pubxml = "$build_pubxml_dir\$build_pubxml_linuxx64" }
    if($rid -eq 'linux-arm64'){ $pubxml = "$build_pubxml_dir\$build_pubxml_linuxarm64" }

    if($configuration -eq 'Debug'){ $pubxml = "dev-$pubxml" }

    dotnet publish $proj_path -c $configuration /p:PublishProfile=$pubxml

    if ($LASTEXITCODE) { exit $LASTEXITCODE }
}

if([String]::IsNullOrEmpty($token))
{
    Write-Host "Undefined Token: $token"
    exit -1
}

Build-PublishTool