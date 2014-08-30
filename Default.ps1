Properties {
  if(!$OutDir) {
    $OutDir = "bin"
  }

  if(!$ProjectDir) {
    $ProjectDir = $PSake.build_script_dir
  }

  if(!$TargetDir) {
    $TargetDir = Join-Path $ProjectDir $OutDir
  }

  if(!$ProjectName) {
    $ProjectName = Split-Path $ProjectDir -Leaf
  }

  if(!$BasePath) {
    $BasePath = Join-Path $ProjectDir $ProjectName
  }
}

Task default -Depends PackageRestore

function Get-Nuget {
  $Nuget = (Join-Path $ProjectDir -ChildPath ".nuget\nuget.exe")
  Assert (Test-Path $Nuget) "Nuget.exe not found at $Nuget"
  return $Nuget
}

Task Clean -Depends CleanPackages {
  if(Test-Path $TargetDir) {
    rm -Recurse $TargetDir -Force
  }
}

Task CleanPackages {
  $PackagesFolder = Join-Path $ProjectDir "Packages"
  $BinFolder = Join-Path $Basepath "bin"
  $Routes = Join-Path $BasePath "PowerShellRoutes"

  $PackagesFolder,$BinFolder,$Routes | %{
    if(Test-Path $_) {
        rm $_ -Recurse
    }
  }
}
    
Task PackageRestore -Depends CleanPackages {
  $Nuget = Get-Nuget
  Assert ([Reflection.Assembly]::LoadFile($Nuget)) "Unable to load nuget.exe assembly"

  $PackagesDir = Join-Path $ProjectDir "packages"
  $SolutionOutputDir = Join-Path $BasePath "bin"
  $PackagesConfig = Join-Path $ProjectDir "packages.config"

  if(!(Test-Path $SolutionOutputDir)) {
    mkdir $SolutionOutputDir > $null
  }

  exec { &$Nuget restore $PackagesConfig -OutputDirectory $PackagesDir }
  exec { &$Nuget install PowerShellRoutes -OutputDirectory $BasePath -ExcludeVersion }
  #exec { &$Nuget install Newtonsoft.Json -Version 6.0.4 -OutputDirectory $PackagesDir }
  #exec { &$Nuget install TrelloNet -Version 0.6.2 -OutputDirectory $PackagesDir }

  $TargetFramework = [Nuget.VersionUtility]::DefaultTargetFramework

  dir $PackagesDir | %{
    $CompatibleVersions = @()
    $LibFolder = Join-Path $_.FullName "lib"
    dir $LibFolder | %{
      $FrameworkVersion = [System.Runtime.Versioning.FrameworkName[]]@([Nuget.VersionUtility]::ParseFrameworkName($_.BaseName))
      if([Nuget.VersionUtility]::IsCompatible($TargetFramework, $FrameworkVersion)) {
        $CompatibleVersions += [PSCustomObject]@{Path=$_.BaseName;Version=$FrameworkVersion[0]}
      }
    }
    $HighestVersion = $CompatibleVersions | Sort-Object -Property Version -Descending | Select-Object -First 1
    if($HighestVersion) {
      $PackageContents = Join-Path $LibFolder "$($HighestVersion.Path)\*"
      Copy-Item $PackageContents $SolutionOutputDir -Recurse
    }
  }
}

Task Pack -Depends PackageRestore {
  $Nuget = Get-Nuget

  $NuSpec = (Join-Path $ProjectDir "$ProjectName.nuspec")
  Assert (Test-Path $NuSpec) "NuSpec file not found at $NuSpec"

  if(!(Test-Path $TargetDir)) {
    mkdir $TargetDir > $null
  }

  $NuSpecXml = [Xml](Get-Content -Raw -Path $NuSpec)
  $NuSpecVersion = [Version]($NuSpecXml.Package.Metadata.Version)
  $VersionDate = [DateTime]::Now.ToString("yyyyMMdd")
  $OutputVersion = New-Object System.Version($NuSpecVersion.Major, $NuSpecVersion.Minor, $VersionDate)

  exec { &$Nuget pack $NuSpec -OutputDirectory $TargetDir -BasePath $BasePath -NoPackageAnalysis -NonInteractive -Version $OutputVersion }
}