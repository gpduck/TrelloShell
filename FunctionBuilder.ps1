

function Get-TrelloAssembly {
    [AppDomain]::CurrentDomain.GetAssemblies() | ?{$_.FullName -like "TrelloNet,*"}
}

function Find-ForMethods {
    param(
        $TypeName
    )
    $A = Get-TrelloAssembly
    $Type = $A.GetType($TypeName, $true)
    $Type.GetMethods() | ?{$_.name -like "for*"}
}

<#
.EXAMPLE
  New-TrelloFunction -FunctionName Get-TrelloBoard -ObjectName Boards
#>
function New-TrelloFunction {
    param(
        $FunctionName,
        $ObjectName
    )
    $Trello = Get-Trello

    $TypeName = $Trello."$ObjectName".GetType().FullName
    
    $ForMethods = Find-ForMethods $TypeName

    $FunctionParameters = $ForMethods | %{
        if($_.Name -match "For(?<Name>.+)") {
            $FParameterSetName  = $_.Name
            $ParameterIndex = 0
            $_.GetParameters() | %{
                $FParameterName = $_.Name
                $FparameterType = $_.ParameterType.FullName
                $FParameterMandatory = !$_.HasDefaultValue
                $FParameterPipeline = $ParameterIndex++ -eq 0
                "    [Parameter(Mandatory=`$$FParameterMandatory,ValueFromPipeline=`$$FParameterPipeline`,ParameterSetName='$FParameterSetName')]`r`n    [$FParameterType]`$$FParameterName"
            }
        } else {
            Write-Warning "Skipping method $($_.Name)"
        }
    }
    $FunctionParameters += '    [String]$Name'
    $ParamBlock = @"
  param(
$($FunctionParameters -join ",`r`n`r`n")
  )
"@
    $Function = @"
function $FunctionName {
$ParamBlock
  begin {
    `$Trello = Get-Trello
  }
  process {
    `$WhereScript = {
      if(`$Name) {
        `$_.Name -like `$Name
      } else {
        `$True
      }
    }
    Invoke-TrelloObjectMethod -Object `$Trello.$ObjectName -Name `$PSCmdlet.ParameterSetName -Parameters `$PSBoundParameters | where -FilterScript `$WhereScript
  }
}
Export-ModuleMember -Function $FunctionName
"@
    $Function
}