
<# 
.NAME
    OnyxGuard 

#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$OnyxGuard                       = New-Object system.Windows.Forms.Form
$OnyxGuard.ClientSize            = New-Object System.Drawing.Point(1000,700)
$OnyxGuard.text                  = "OnyxGuard"
$OnyxGuard.TopMost               = $false
$OnyxGuard.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#FAFAFC ")

$HeaderPanel                     = New-Object system.Windows.Forms.Panel
$HeaderPanel.height              = 115
$HeaderPanel.width               = 1000
$HeaderPanel.Anchor              = 'top,right,left'
$HeaderPanel.location            = New-Object System.Drawing.Point(0,-1)
$HeaderPanel.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#003366")

$Title                           = New-Object system.Windows.Forms.Label
$Title.text                      = "OnyxGuard"
$Title.AutoSize                  = $true
$Title.width                     = 25
$Title.height                    = 25
$Title.location                  = New-Object System.Drawing.Point(23,17)
$Title.Font                      = New-Object System.Drawing.Font('Segoe UI',35,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Title.ForeColor                 = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$ByText                          = New-Object system.Windows.Forms.Label
$ByText.text                     = "by Johann Weingertner"
$ByText.AutoSize                 = $true
$ByText.width                    = 25
$ByText.height                   = 10
$ByText.location                 = New-Object System.Drawing.Point(60,88)
$ByText.Font                     = New-Object System.Drawing.Font('Segoe UI',10)
$ByText.ForeColor                = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$SubPanel                        = New-Object system.Windows.Forms.Panel
$SubPanel.height                 = 6
$SubPanel.width                  = 1000
$SubPanel.Anchor                 = 'top,right,left'
$SubPanel.location               = New-Object System.Drawing.Point(0,114)
$SubPanel.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#0056B3 ")

$OnyxGuard.controls.AddRange(@($HeaderPanel,$SubPanel))
$HeaderPanel.controls.AddRange(@($Title,$ByText))







[void]$OnyxGuard.ShowDialog()