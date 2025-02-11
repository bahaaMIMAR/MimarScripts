# Load the necessary assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Write-Host -ForegroundColor Blue "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@&   @@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@      @@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @        @@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        @@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@        @@@@@@@@@@@@@@    @@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@      @ @@@@@@@@           @@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@      @@@  @@@@@@@           @@@@@@@@ @@@
@@@@@@@@@@@@@@@@@@@@      @@@@@@  @@@@@@@@          @@@@@@    @@
@@@@@@@@@@@@@@@@@     @@@@@@@@@@  @@@@@@@@@@@      @@@@@       @
@@@@@@@@@@@@@@     @@@@@@@@@@@@@  @@@@@@@@  @@@@@   @@         @
@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@  @@@@@@@@    @@@@              
@@@@@@@@@   @@@@@@@@@@@@@@@@@@@   @@@@@@@       @@@@@@@@@@@@@@@@
@@@@@@   @@@@@@@@@@@@@@@@@@@@@@   @@@@@@          @@@@@@@@@@@@@@
@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@   @@        @@@@@@@@@@@@@@@@@@@@
& @@@@@@@@@@@@@@@@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@"

#Get the current theme
$appsTheme = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -ErrorAction SilentlyContinue
if ($appsTheme -eq 0) {
    $WinTheme = "Dark"
} else {
    $WinTheme = "Light"
}

# Enable visual styles
[System.Windows.Forms.Application]::EnableVisualStyles()

# Create a function for the main script logic
function Run-Script {
    param (
        [string]$directoryPath
    )

    # Get all files in the directory
    $files = Get-ChildItem -Path $directoryPath -File

    # Get all subfolders in the directory
    $folders = Get-ChildItem -Path $directoryPath -Directory

    # Collect folder base names (excluding "_files")
    $folderBaseNames = @{}
    foreach ($folder in $folders) {
        $folderBaseName = $folder.Name -replace "_files$", ""
        $folderBaseNames[$folderBaseName] = $true
    }

    foreach ($file in $files) {
        $fileBaseName = $file.BaseName

        # Check if there's no matching folder base name
        if (-not $folderBaseNames.ContainsKey($fileBaseName)) {
            # Delete the file
            Remove-Item -Path $file.FullName -Force
        }
    }

    # Show a message when the script is done
    [System.Windows.Forms.MessageBox]::Show("Script completed successfully.")
}

# Create the GUI components
$form = New-Object System.Windows.Forms.Form
$form.Text = "MIMAR | Delete Empty XML Test"
$form.Size = New-Object System.Drawing.Size(450, 215)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.TopMost = $true

$label = New-Object System.Windows.Forms.Label
$label.Text = "Directory:"
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(60, 20)

$label2 = New-Object System.Windows.Forms.Label
$label2.Text = "Mimar Scripts | Bahaa Barakat"
$label2.Location = New-Object System.Drawing.Point(10, 157)
$label2.Size = New-Object System.Drawing.Size(200, 20)
$label2.Font = New-Object System.Drawing.Font("Segoe UI", 7, [System.Drawing.FontStyle]::Regular)
$label2.ForeColor = [System.Drawing.Color]::Gray

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(80, 20)
$textBox.Size = New-Object System.Drawing.Size(270, 20)

$buttonBrowse = New-Object System.Windows.Forms.Button
$buttonBrowse.Text = "Browse"
$buttonBrowse.Location = New-Object System.Drawing.Point(365, 20)
$buttonBrowse.Size = New-Object System.Drawing.Size(60, 20)
$buttonBrowse.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBox.Text = $folderBrowser.SelectedPath
    }
})

$buttonRun = New-Object System.Windows.Forms.Button
$buttonRun.Text = "Run Script"
$buttonRun.Location = New-Object System.Drawing.Point(10, 70)
$buttonRun.Size = New-Object System.Drawing.Size(415, 80)
$buttonRun.Add_Click({
    if ($textBox.Text -ne "") {
        Run-Script -directoryPath $textBox.Text
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a directory.")
    }
})

$form.Controls.Add($label)
$form.Controls.Add($textBox)
$form.Controls.Add($buttonBrowse)
$form.Controls.Add($buttonRun)
$form.Controls.Add($label2)

#Defining Colors
if ($WinTheme -eq "Dark") {
    $lightcolor = [System.Drawing.Color]::FromArgb(31, 31, 31)
    $txtcolor = [System.Drawing.Color]::FromArgb(240, 240, 240)
    $buttonRun.FlatStyle = 'Flat'
    $buttonRun.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
    $buttonRun.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    $buttonBrowse.FlatStyle = 'Flat'
    $buttonBrowse.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
    $buttonBrowse.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    #$buttonBrowse.Height = 23
    $textBox.BorderStyle = 'FixedSingle'
    $textBox.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
    $textBox.ForeColor = [System.Drawing.Color]::FromArgb(255, 255, 255)
} else {
    $lightcolor = [System.Drawing.Color]::SystemColor
    $txtcolor = [System.Drawing.Color]::SystemColor
    #$buttonBrowse.Height = 23
}
#
$form.BackColor = $lightcolor
$form.ForeColor = $txtcolor

# Show the form
$form.ShowDialog()
