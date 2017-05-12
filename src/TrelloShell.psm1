param($LibPath)

if(!$LibPath) {
  $LibPath = "$PSScriptRoot\Lib"
}
Add-Type -Path "$LibPath\Newtonsoft.Json.dll" -ErrorAction Stop
Add-Type -Path "$LibPath\System.Net.Http.Formatting.dll" -ErrorAction Stop
Add-Type -Path "$LibPath\System.Web.Http.dll" -ErrorAction Stop
Add-Type -Path "$LibPath\Manatee.Json.dll" -ErrorAction Stop
Add-Type -Path "$LibPath\Manatee.Trello.dll" -ErrorAction Stop
Add-Type -Path "$LibPath\Manatee.Trello.ManateeJson.dll" -ErrorAction Stop
Add-Type -Path "$LibPath\Manatee.Trello.WebApi.dll" -ErrorAction Stop

$Script:ModuleRoot = $PSScriptRoot

# Implement your module commands in this script.
dir $PSScriptRoot\ExportedFunctions\*.ps1 -Exclude *.Test.ps1 | ForEach-Object {
  . $_.Fullname
}

# Export only the functions using PowerShell standard verb-noun naming.
Export-ModuleMember -Function *-*
