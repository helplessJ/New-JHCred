Function New-StoredSecureString {
<#
    .description
This function will create the stored password file in C:\users\[username] location.
The name of the document is deternimed by parameter ExportPassFile
    .example
New-StoredSecureString -ExportPassFile 'o365'
     
A prompt will appear, anything typed in the prompt will be saved to $home\0365.txt
#>


  [cmdletbinding()]
  param(
        [Parameter(Mandatory = $true)]
        [string]$ExportPassFile
       )
      
    $storePath = Join-Path -Path $home -ChildPath "$ExportPassFile.txt"
    Read-Host 'Enter Password' -AsSecureString | ConvertFrom-SecureString | Out-File $storePath
    
}


Function New-CredentialFromStoredCred {
  <#
      .description
      This function will take a stored password file and bind it with a username to create a user credential object.
      .example
      $exampleCredential = New-CredentialFromStoredCred -Username 'testuser@contoso.com' -StoredCred "$home\o365.txt"

      Will hold a user credential in $exampleCredential which can then be used with commandlets that support the -Credential parameter (IE: Move-ADObject [adobject] -Credential $exampleCredential)
  #>
  [cmdletbinding()]
   param(
    [Parameter(Mandatory = $true)]
    [string]$Username,
    
    [Parameter(Mandatory = $true)]
    [ValidateScript({Test-Path -path $_})]
    [string]$StoredCred
         )
         
   New-Object pscredential -ArgumentList ($Username, (Get-Content $StoredCred | ConvertTo-SecureString -AsPlainText -Force))
   
}
