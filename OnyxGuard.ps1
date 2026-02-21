Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$OnyxGuard                       = New-Object system.Windows.Forms.Form
$OnyxGuard.ClientSize            = New-Object System.Drawing.Point(1100,850)
$OnyxGuard.text                  = "OnyxGuard"
$OnyxGuard.TopMost               = $false
$OnyxGuard.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#FAFAFC ")

$HeaderPanel                     = New-Object system.Windows.Forms.Panel
$HeaderPanel.height              = 115
$HeaderPanel.width               = 1100
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
$SubPanel.width                  = 1100
$SubPanel.Anchor                 = 'top,right,left'
$SubPanel.location               = New-Object System.Drawing.Point(0,114)
$SubPanel.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#0056B3 ")


$OnyxGuard.controls.AddRange(@($HeaderPanel,$SubPanel))
$HeaderPanel.controls.AddRange(@($Title,$ByText))

$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Location = New-Object System.Drawing.Point(20, 150) 
$TabControl.Size = New-Object System.Drawing.Size(1060, 680) 
$TabControl.Font = New-Object System.Drawing.Font('Segoe UI', 10)
$TabControl.Anchor = 'Top, Bottom, Left, Right'
$TabControl.Padding = New-Object System.Drawing.Point(0, 0)

$TabPage1 = New-Object System.Windows.Forms.TabPage
$TabPage1.Text = "Security Dashboard"
$TabPage1.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#FAFAFC")
$TabPage1.Padding = New-Object System.Windows.Forms.Padding(15)

$TabPage2 = New-Object System.Windows.Forms.TabPage
$TabPage2.Text = "Configuration"
$TabPage2.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#FAFAFC")
$TabPage2.Padding = New-Object System.Windows.Forms.Padding(15)

$TabPage3 = New-Object System.Windows.Forms.TabPage
$TabPage3.Text = "Threat Hunting"
$TabPage3.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#FAFAFC")
$TabPage3.Padding = New-Object System.Windows.Forms.Padding(15)

#Dashboard content
$OverallScorePanel = New-Object System.Windows.Forms.Panel
$OverallScorePanel.Size = New-Object System.Drawing.Size(285, 115)
$OverallScorePanel.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$OverallScorePanel.BorderStyle = 'FixedSingle'
$OverallScorePanel.Location = New-Object System.Drawing.Point(
    [math]::Round(($TabPage1.ClientSize.Width - $OverallScorePanel.Width) / 2),
    20
)

$OverallScoreLabel = New-Object System.Windows.Forms.Label
$OverallScoreLabel.Text = "Overall Hardening Score:"
$OverallScoreLabel.Font = New-Object System.Drawing.Font('Segoe UI', 8, [System.Drawing.FontStyle]::Bold)
$OverallScoreLabel.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#676767")
$OverallScoreLabel.AutoSize = $true
$OverallScoreLabel.Location = New-Object System.Drawing.Point(10, 10)
$OverallScorePanel.Controls.Add($OverallScoreLabel)

$OverallHardeningScoreValue = 8 #Placeholder add logic later to calculate actual score (Idk how ima do it)
if ($OverallHardeningScoreValue -ge 8) {
	$OverallScoreColorValue = "#28a745" 
} elseif ($OverallHardeningScoreValue -ge 5) {
	$OverallScoreColorValue = "#ffc107" 
} else {
	$OverallScoreColorValue = "#dc3545" 
}

$OverAllScoreValueLabel = New-Object System.Windows.Forms.Label
$OverAllScoreValueLabel.Text = $OverallHardeningScoreValue
$OverAllScoreValueLabel.Font = New-Object System.Drawing.Font('Segoe UI', 30, [System.Drawing.FontStyle]::Bold)
$OverAllScoreValueLabel.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($OverallScoreColorValue)
$OverAllScoreValueLabel.AutoSize = $true
$OverAllScoreValueLabel.Location = New-Object System.Drawing.Point(125, 20) 
$OverallScorePanel.Controls.Add($OverAllScoreValueLabel)

$ScoreMaxLabel = New-Object System.Windows.Forms.Label
$ScoreMaxLabel.Text = "/10"
$ScoreMaxLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Bold)
$ScoreMaxLabel.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#A0A0A0") 
$ScoreMaxLabel.AutoSize = $true
$ScoreMaxLabel.Location = New-Object System.Drawing.Point(
    ($OverAllScoreValueLabel.Location.X + $OverAllScoreValueLabel.Width + -3), 
    45 
)
$OverallScorePanel.Controls.Add($ScoreMaxLabel)

$TabPage1.Controls.Add($OverallScorePanel)
$TabPage1.Add_Resize({
    $OverallScorePanel.Location = New-Object System.Drawing.Point(
        [math]::Round(($TabPage1.ClientSize.Width - $OverallScorePanel.Width) / 2),
        $OverallScorePanel.Location.Y
    )
})

$ScanScoreButton = New-Object System.Windows.Forms.Button
$ScanScoreButton.Text = "Run Score Scan"
$ScanScoreButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#003366")
$ScanScoreButton.Size = New-Object System.Drawing.Size(150, 34)
$ScanScoreButton.Location = New-Object System.Drawing.Point(935, 70)
$ScanScoreButton.Font = New-Object System.Drawing.Font('Segoe UI',10,[System.Drawing.FontStyle]::Bold)
$ScanScoreButton.Anchor = 'Top, Right'
$ScanScoreButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$ScanScoreButton.FlatStyle = 'Flat'
$HeaderPanel.controls.Add($ScanScoreButton)

#Configuration content
$ScanConfigButton = New-Object System.Windows.Forms.Button
$ScanConfigButton.Text = "Run Configuration"
$ScanConfigButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#003366")
$ScanConfigButton.Size = New-Object System.Drawing.Size(150, 34)
$ScanConfigButton.Location = New-Object System.Drawing.Point(935, 70)
$ScanConfigButton.Font = New-Object System.Drawing.Font('Segoe UI',10,[System.Drawing.FontStyle]::Bold)
$ScanConfigButton.Anchor = 'Top, Right'
$ScanConfigButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$ScanConfigButton.FlatStyle = 'Flat'
$HeaderPanel.controls.Add($ScanConfigButton)

$TabControl.TabPages.AddRange(@($TabPage1, $TabPage2, $TabPage3))

#Misc Logic
$ScanScoreButton.Visible = $true
$ScanConfigButton.Visible = $false

$TabControl.Add_SelectedIndexChanged({
	if ($TabControl.SelectedTab -eq $TabPage1) {
		$ScanScoreButton.Visible = $true
		$ScanConfigButton.Visible = $false
	} elseif ($TabControl.SelectedTab -eq $TabPage2) {
		$ScanScoreButton.Visible = $false
		$ScanConfigButton.Visible = $true
	} else {
		$ScanScoreButton.Visible = $false
		$ScanConfigButton.Visible = $false
	}
})

$OnyxGuard.Controls.Add($TabControl)

[void]$OnyxGuard.ShowDialog()
