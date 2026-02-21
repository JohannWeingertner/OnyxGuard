Write-Host "
         _________.__       .__          __                _________.__        
        /   _____/|__| ____ |__| _______/  |_  ___________/   _____/|__|__  ___
        \_____  \ |  |/    \|  |/  ___/\   __\/ __ \_  __ \_____  \ |  \  \/  /
        /        \|  |   |  \  |\___ \  |  | \  ___/|  | \/        \|  |>    < 
       /_______  /|__|___|  /__/____  > |__|  \___  >__| /_______  /|__/__/\_ \
               \/         \/        \/            \/             \/          \/
,_._._._._._._._._|__________________________________________________________,
|_|_|_|_|_|_|_|_|_|_________________________________________________________/
                  !
                                               By Johann Weingertner
         
" -ForegroundColor Blue

Write-Host "
Choose Option:

(1) Check and Configure Users
(2) Sets UAC to Highest Level
(3) Configure Local Security Policies
(4) Configure Group Policies
(5) Configure Windows Settings
(6) Configure Windows Defender
(7) Enable RDP
(8) Disable RDP
(9) 
" -ForegroundColor White

$Value = Read-Host "Enter your choice"

if ($Value -eq 1) {
    Write-Host "You chose option 1" -ForegroundColor Blue

    $plainPasswordText = "Patri0t1234!?"
    $securePassword = ConvertTo-SecureString $plainPasswordText -AsPlainText -Force

    $allowedUsersInput = Read-Host "Please input allowed users (comma separated)"
    $allowedUsers = $allowedUsersInput -split '\s*,\s*'

    $currentUser = $env:USERNAME

    $currentUsers = Get-LocalUser | Where-Object { $_.Name -notmatch "^(Administrator|Guest|DefaultAccount|WDAGUtilityAccount)$" }

    foreach ($user in $currentUsers) {
        if ($user.Name -ne $currentUser -and $allowedUsers -notcontains $user.Name) {
            Remove-LocalUser -Name $user.Name -ErrorAction SilentlyContinue
            Write-Host ""
            Write-Host "----------------> [Deleted user: $($user.Name)] <----------------" -ForegroundColor Blue
            Write-Host ""
        }
        else {
            Set-LocalUser -Name $user.Name -Password $securePassword -ErrorAction SilentlyContinue

            cmd.exe /c "net user $($user.Name) /logonpasswordchg:yes"

            cmd.exe /c "wmic useraccount where name='$($user.Name)' set PasswordExpires=true"
        }
    }

    $defaultAccounts = @("Administrator", "Guest", "DefaultAccount", "WDAGUtilityAccount")
    foreach ($defaultUser in $defaultAccounts) {
        $userObj = Get-LocalUser -Name $defaultUser -ErrorAction SilentlyContinue
        if ($userObj -and $userObj.Enabled -eq $true) {
            Disable-LocalUser -Name $defaultUser -ErrorAction SilentlyContinue
        }
    }

    Write-Host ""
    Write-Host "Finished Configuring Users. Stopping Script." -ForegroundColor Blue
    Write-Host "" 

    Pause
    Exit
}

if ($Value -eq 2) {
    Write-Host "You chose option 2" -ForegroundColor Blue

  
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

    Set-ItemProperty -Path $registryPath -Name "EnableLUA" -Value 1

    Set-ItemProperty -Path $registryPath -Name "ConsentPromptBehaviorAdmin" -Value 2

    Set-ItemProperty -Path $registryPath -Name "ConsentPromptBehaviorUser" -Value 3

    Set-ItemProperty -Path $registryPath -Name "PromptOnSecureDesktop" -Value 1

    Write-Host ""
    Write-Host "Finished Configuring UAC. Stopping Script." -ForegroundColor Blue
    Write-Host ""

    Pause
    Exit

}

if ($Value -eq 3) {
    Write-Host "You chose option 3" -ForegroundColor Blue

    secedit /export /cfg c:\secpol.cfg
    
    (GC C:\secpol.cfg) -Replace "PasswordHistorySize = 0","PasswordHistorySize = 24" | Out-File C:\secpol.cfg
    (GC C:\secpol.cfg) -Replace "MaximumPasswordAge = -1","MaximumPasswordAge = 60" | Out-File C:\secpol.cfg
    (GC C:\secpol.cfg) -Replace "MinimumPasswordAge = 0","MinimumPasswordAge = 1" | Out-File C:\secpol.cfg
    (GC C:\secpol.cfg) -Replace "MinimumPasswordLength = 0","MinimumPasswordLength = 12" | Out-File C:\secpol.cfg
    (GC C:\secpol.cfg) -Replace "PasswordComplexity = 0","PasswordComplexity = 1" | Out-File C:\secpol.cfg
    (GC C:\secpol.cfg) -Replace "ClearTextPassword = 1","ClearTextPassword = 0" | Out-File C:\secpol.cfg
    (GC C:\secpol.cfg) -Replace "LockoutBadCount = 0","LockoutBadCount = 10" | Out-File C:\secpol.cfg
    (GC C:\secpol.cfg) -Replace "LockoutDuration = 10","LockoutDuration = 30" | Out-File C:\secpol.cfg
    (GC C:\secpol.cfg) -Replace "ResetLockoutCount = 10","ResetLockoutCount = 30" | Out-File C:\secpol.cfg
    (GC C:\secpol.cfg) -Replace "EnableAdminAccount = 1","EnableAdminAccount = 0" | Out-File C:\secpol.cfg
    (GC C:\secpol.cfg) -Replace "EnableGuestAccount = 1","EnableGuestAccount = 0" | Out-File C:\secpol.cfg
    
    secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
    Remove-Item C:\secpol.cfg -Force

    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy" -Name "Enabled" -Value 1 -Type DWord
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LimitBlankPasswordUse" -Value 1 -Type DWord
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "TurnOffAnonymousBlock" -Value -1 -Type DWord
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "RestrictAnonymousSAM" -Value 1 -Type DWord
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "RestrictAnonymous" -Value 1 -Type DWord
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "DisableDomainCreds" -Value 1 -Type DWord
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "EveryoneIncludesAnonymous" -Value 0 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DontDisplayLockedUserId" -Value 1 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableCAD" -Value 0 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DontDisplayLastUserName" -Value 1 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DontDisplayLastUserName" -Value 1 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "MaxDevicePasswordFailedAttempts" -Value 10 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "InactivityTimeoutSecs" -Value 900 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LegalNoticeText" -Value "Warning: This system is restricted to authorized users only. Unauthorized access is prohibited and will be prosecuted." -Type String
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LegalNoticeCaption" -Value "SECURITY WARNING" -Type String
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name "RequireSecuritySignature" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name "EnableSecuritySignature" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name "EnablePlainTextPassword" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -Name "autodisconnect" -Value 15 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -Name "EnableS4U2SelfForClaims" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -Name "RequireSecuritySignature" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -Name "EnableSecuritySignature" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -Name "EnableForcedLogoff" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" -Name "SmbServerNameHardeningLevel" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole" -Name "SecurityLevel" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ShutdownWithoutLogon" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography" -Name "ForceKeyProtection" -Value 2 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" -Name "ObCaseInsensitive" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name "ProtectionMode" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "AuditBaseObjects" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "FullPrivilegeAuditing" -Value 1 -Type Binary -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "SCENoApplyLegacyAuditPolicy" -Value 1 -Type DWord -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "CrashOnAuditFail" -Value 1 -Type DWord -Force



    auditpol /set /category:"Account Logon" /success:enable /failure:enable
    auditpol /set /category:"Account Management" /success:enable /failure:enable
    auditpol /set /category:"Detailed Tracking" /success:enable /failure:enable
    auditpol /set /category:"DS Access" /success:enable /failure:enable
    auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable
    auditpol /set /category:"Object Access" /success:enable /failure:enable
    auditpol /set /category:"Policy Change" /success:enable /failure:enable
    auditpol /set /category:"Privilege Use" /success:enable /failure:enable
    auditpol /set /category:"System" /success:enable /failure:enable
    auditpol /set /subcategory:"Credential Validation" /success:enable /failure:enable
    auditpol /set /subcategory:"Kerberos Authentication Service" /success:enable /failure:enable
    auditpol /set /subcategory:"Kerberos Service Ticket Operations" /success:enable /failure:enable
    auditpol /set /subcategory:"Other Account Logon Events" /success:enable /failure:enable
    auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable
    auditpol /set /subcategory:"Computer Account Management" /success:enable /failure:enable
    auditpol /set /subcategory:"Security Group Management" /success:enable /failure:enable
    auditpol /set /subcategory:"Distribution Group Management" /success:enable /failure:enable
    auditpol /set /subcategory:"Application Group Management" /success:enable /failure:enable
    auditpol /set /subcategory:"Other Account Management Events" /success:enable /failure:enable
    auditpol /set /subcategory:"Process Creation" /success:enable /failure:enable
    auditpol /set /subcategory:"Process Termination" /success:enable /failure:enable
    auditpol /set /subcategory:"DPAPI Activity" /success:enable /failure:enable
    auditpol /set /subcategory:"RPC Events" /success:enable /failure:enable
    auditpol /set /subcategory:"Plug and Play Events" /success:enable /failure:enable
    auditpol /set /subcategory:"Token Right Adjusted Events" /success:enable /failure:enable
    auditpol /set /subcategory:"Directory Service Access" /success:enable /failure:enable
    auditpol /set /subcategory:"Directory Service Changes" /success:enable /failure:enable
    auditpol /set /subcategory:"Directory Service Replication" /success:enable /failure:enable
    auditpol /set /subcategory:"Detailed Directory Service Replication" /success:enable /failure:enable
    auditpol /set /subcategory:"Logon" /success:enable /failure:enable
    auditpol /set /subcategory:"Logoff" /success:enable /failure:enable
    auditpol /set /subcategory:"Account Lockout" /success:enable /failure:enable
    auditpol /set /subcategory:"IPSec Main Mode" /success:enable /failure:enable
    auditpol /set /subcategory:"IPSec Quick Mode" /success:enable /failure:enable
    auditpol /set /subcategory:"IPSec Extended Mode" /success:enable /failure:enable
    auditpol /set /subcategory:"Special Logon" /success:enable /failure:enable
    auditpol /set /subcategory:"Other Logon/Logoff Events" /success:enable /failure:enable
    auditpol /set /subcategory:"Network Policy Server" /success:enable /failure:enable
    auditpol /set /subcategory:"User / Device Claims" /success:enable /failure:enable
    auditpol /set /subcategory:"Group Membership" /success:enable /failure:enable
    auditpol /set /subcategory:"File System" /success:enable /failure:enable
    auditpol /set /subcategory:"Registry" /success:enable /failure:enable
    auditpol /set /subcategory:"Kernel Object" /success:enable /failure:enable
    auditpol /set /subcategory:"SAM" /success:enable /failure:enable
    auditpol /set /subcategory:"Certification Services" /success:enable /failure:enable
    auditpol /set /subcategory:"Application Generated" /success:enable /failure:enable
    auditpol /set /subcategory:"Handle Manipulation" /success:enable /failure:enable
    auditpol /set /subcategory:"File Share" /success:enable /failure:enable
    auditpol /set /subcategory:"Filtering Platform Packet Drop" /success:enable /failure:enable
    auditpol /set /subcategory:"Filtering Platform Connection" /success:enable /failure:enable
    auditpol /set /subcategory:"Other Object Access Events" /success:enable /failure:enable
    auditpol /set /subcategory:"Detailed File Share" /success:enable /failure:enable
    auditpol /set /subcategory:"Audit Policy Change" /success:enable /failure:enable
    auditpol /set /subcategory:"Authentication Policy Change" /success:enable /failure:enable
    auditpol /set /subcategory:"Authorization Policy Change" /success:enable /failure:enable
    auditpol /set /subcategory:"MPSSVC Rule-Level Policy Change" /success:enable /failure:enable
    auditpol /set /subcategory:"Filtering Platform Policy Change" /success:enable /failure:enable
    auditpol /set /subcategory:"Other Policy Change Events" /success:enable /failure:enable
    auditpol /set /subcategory:"Non Sensitive Privilege Use" /success:enable /failure:enable
    auditpol /set /subcategory:"Other Privilege Use Events" /success:enable /failure:enable
    auditpol /set /subcategory:"Sensitive Privilege Use" /success:enable /failure:enable
    auditpol /set /subcategory:"IPsec Driver" /success:enable /failure:enable
    auditpol /set /subcategory:"Other System Events" /success:enable /failure:enable
    auditpol /set /subcategory:"Security State Change" /success:enable /failure:enable
    auditpol /set /subcategory:"Security System Extension" /success:enable /failure:enable
    auditpol /set /subcategory:"System Integrity" /success:enable /failure:enable

    
    Write-Host ""
    Write-Host "WARNING: I didn't get to add all settings, so please make sure to review the settings." -ForegroundColor Red
    Write-Host ""
    Wirte-Host "Make sure to enable Audits for passwords in password policies" -ForegroundColor Red
    Write ""

}

if ($Value -eq 4) {
    Write-Host "You chose option 4" -ForegroundColor Blue
}

if ($Value -eq 5) {
    Write-Host "You chose option 5" -ForegroundColor Blue
}

if ($Value -eq 6) {
    Write-Host "You chose option 6" -ForegroundColor Blue
}

if ($Value -eq 7) {
    Write-Host "You chose option 7" -ForegroundColor Blue
}

if ($Value -eq 8) {
    Write-Host "You chose option 8" -ForegroundColor Blue

}

