$Script:ModuleRoot = $PSScriptRoot

dir (Join-Path -Path $Script:ModuleRoot -ChildPath "ExportedFunctions\*.ps1") | %{
	. $_.Fullname
}


function Invoke-TrelloObjectMethod {
    param(
        $Object,
        $Name,
        $Parameters
    )
    $Trello = Get-Trello

    $Method = $Object.GetType().GetMethod($Name)
    $ParameterValues = @()
    $MethodParameters = $Method.GetParameters()
    $ParameterValues = New-Object object[]($MethodParameters.Length)
    $MethodParameters | %{
        if($Parameters.ContainsKey($_.name)) {
            $ParameterValues[$_.Position] = $Parameters[$_.Name] -as $_.ParameterType
        } else {
            if($_.HasDefaultValue) {
                $ParameterValues[$_.Position] = $_.DefaultValue
            } else {
                Write-Error "Cannot find value for parameter $($_.Name)"
                return
            }
        }
    }
    $Method.Invoke($Object, $ParameterValues)
}
#Invoke-TrelloObjectMethod -Object Lists -Name ForBoard -Parameters @{board=$b}