function Start-TrelloAuthorization {
  param(
    [ValidateNotNullOrEmpty()]
    [TrelloNet.Scope]$Scope = [TrelloNet.Scope]::ReadWrite,

    [ValidateNotNullOrEmpty()]
    [TrelloNet.Expiration]$Expiration = [TrelloNet.Expiration]::oneday,

    [int]$LocalPort = 8080
  )
  $Trello = Get-Trello
  $Key = Get-TrelloApplicationKey

  switch ($Scope) {
    "ReadOnly" {
      $ScopeString = "read"
    }
    "ReadOnlyAccount" {
      $ScopeString = "read,account"
    }
    "ReadWrite" {
      $ScopeString = "read,write"
    }
    "ReadWriteAccount" {
      $ScopeString = "read,write,account"
    }
    default {
      Write-Error "Unknown scope $Scope"
      return
    }
  }

  switch ($Expiration) {
    "OneDay" {
      $ExpirationString = "1day"
    }
    "OneHour" {
      $ExpirationString = "1hour"
    }
    "ThirtyDays" {
      $ExpirationString = "30days"
    }
    "never" {
      $ExpirationString = "never"
    }
    default {
      Write-Error "Unknown expiration $Expiration"
      return
    }
  }

  $ReturnUrl = [Web.HttpUtility]::UrlEncode("http://localhost:$LocalPort/AuthorizeTrelloShell.html")
  $Url = "https://trello.com/1/authorize?scope=$ScopeString&expiration=$ExpirationString&name=TrelloShell&key=$($Key.Key)&return_url=$ReturnUrl&callback_method=fragment"
  $AuthorizationCallback = New-FileHandler -Path (Join-Path $Script:ModuleRoot "html")
  $ExtractToken = {
    $Request.QueryString["token"]
    Send-Response "TrelloShell Authorized, you may close this window"
    Stop-WebServer
  }
  #$Trello.GetAuthorizationUrl("TrelloShell", $Scope, $Expiration)
  Start-Process $Url
  $Token = Start-WebServer -IPAddress "localhost" -Port $LocalPort -Routes @{"AuthorizeTrelloShell.html"=$AuthorizationCallback; "ExtractToken"=$ExtractToken }
  $Trello.Authorize($Token)
}
Export-ModuleMember -Function Start-TrelloAuthorization