$Script:ModuleRoot = $PSScriptRoot

dir (Join-Path -Path $Script:ModuleRoot -ChildPath "ExportedFunctions\*.ps1") | %{
	. $_.Fullname
}