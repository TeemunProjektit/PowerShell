<# 
Version 3.1 
#>
clear-host
import-module activedirectory

function Set-Menu {
    write-host ****************************** -ForegroundColor red
    write-host * Service Desk -apustaja 3.1 *   -ForegroundColor red
    write-host ****************************** -ForegroundColor red
    Write-Host "`nActive Directory search" -ForegroundColor White -BackgroundColor Green
    write-host "`n1." -ForegroundColor red -NoNewline; write-host " Find AD user"
    write-host 2. -ForegroundColor red -NoNewline; write-host " Find AD group"
    write-host 3. -ForegroundColor Red -NoNewline; write-host " Export user AD groups"
    write-host 4. -ForegroundColor Red -NoNewline; write-host " Export AD group members"
    write-host 5. -ForegroundColor Red -NoNewline; write-host " Unlock AD account"
    Write-Host "`nPassword generator" -ForegroundColor white -BackgroundColor Green
    write-host "`n7." -ForegroundColor Red -NoNewline; write-host " Generate password"
    Write-Host "`nOther" -ForegroundColor white -BackgroundColor Green
    write-host "`n8." -ForegroundColor Red -NoNewline; write-host " Exit "

}

function Get-Information {

    $key = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    switch ($key.character) {
    
        '1' {
            Clear-Host
            [string]$NameFirst = Read-Host "`nUser First Name"
            [string]$NameLast = Read-Host "User Last Name"
            [string]$FullName = "*$NameFirst* *$NameLast*"
            [string]$Login = Read-Host "User Login Name"
            [string]$LoginName = "*$Login*"
            if (!$NameFirst -and !$NameLast) {
                write-host "`nSearch 1: Username not found"
            }
            else {
                write-host
                Get-ADUser -Filter { name -like $FullName } -properties * | select-object name, samaccountname, LockedOut, PasswordLastSet, PasswordExpired | sort-object name | format-table
            }
            try {
                Get-ADUser -Identity $LoginName -properties * | select-object name, samaccountname, LockedOut, PasswordLastSet, PasswordExpired | sort-object name | format-table
                Read-Host "`nPress Enter to return"
                Clear-Host
                break
            }
            catch {
                write-host "`nSearch 2: Login name not found"
                Read-Host "`nPress Enter to return"
            }
            finally {
                Clear-Host
            }
            break
        }
        '2' {
            Clear-Host
            [string]$ADgroup = Read-Host "`nAD-group name"
            [string]$ADgroupName = "*$ADgroup*"
            if (!$AdGroupName) {
                write-host "`nAD group not found"
            }
            else {
                 
                try {
                    Get-ADGroup -Filter { name -like $AdGroupName } -properties * | select-object name, info | sort-object name | format-table -wrap -autosize
                    Read-Host "`nPress Enter to return"
                    Clear-Host
                    break
                }
                catch {
                    write-host "`nAD-group not found"
                    Read-Host "`nPress Enter to return"
                }
                finally {
                    Clear-Host
                }
                break
            }
        }
        '3' {
            Clear-Host
            Write-Host "`nExport user's AD-groups as .TXT to desktop"
            [string]$UserID = Read-Host "`nUser ID"
            [string]$User = "$UserID"
            if (!$UserID) {
                write-host "`nEmpty value"
                Read-Host "`nPress Enter to return"
                Clear-Host
                break
            }
            elseif (Get-ADUser -Identity $User) {
                write-host
                Get-ADUser -Identity $User -properties memberof  |
                Select-Object -expandproperty memberof | get-adgroup -properties name -ErrorAction SilentlyContinue | 
                Select-Object name | sort-object name |
                #Out-File "C:\"
                Out-File "c:\Users\$env:USERNAME\Desktop\$User ADGroups.txt"
                write-host "$User ADGroups.txt exported to c:\Users\$env:USERNAME\Desktop\"
                Read-Host "`nPress Enter to return"
                Clear-Host
                break
            }
            else {
                write-host "`nUsername not found"
                Read-Host "`nPress Enter to return"
                Clear-Host
                break
            }
        }
        '4' {
            Clear-Host
            Write-Host
            Write-Host "Export AD-group members as .TXT to desktop"
            Write-Host
            [string]$ADGroup = Read-Host "AD Group Name"
            [string]$Group = "$ADGroup"
            if (!$ADGroup) {
                write-host "`nEmpty value"
                Read-Host "`nPress Enter to return"
                Clear-Host
                break
            }
            else {
                try {
                    Get-Adgroup -identity $Group -ErrorAction Stop | out-null
                    Get-AdGroupMember -identity $Group | Select-Object name | Sort-Object name | Out-File "c:\Users\$env:USERNAME\Desktop\$Group Members.txt"
                    write-host "`n$Group Members.txt exported to C:\Users\$env:USERNAME\Desktop\"
                    Read-Host "`nPress Enter to return"
                }
                catch {
                    write-host "`nAD group not found"
                    Read-Host "`nPress Enter to return"
                }
                finally {
                    Clear-Host
                }
                break
            }
        }
        '5' {
            Clear-Host
            Write-Host "`nUnlock AD-account:"
            [string]$UserID = Read-Host "`nUser ID"
            [string]$User = "$UserID"
            if (!$UserID) {
                write-host "`nEmpty value"
                Read-Host "`nPress Enter to return"
                Clear-Host
                break
            }
            elseif (Get-ADUser -Identity $User) {
                write-host
                Unlock-ADAccount $User
                write-host "User account $User unlocked:"
                write-host
                Get-ADUser -Identity $User -properties * | select-object name, samaccountname, LockedOut, PasswordLastSet, PasswordExpired | sort-object name | format-table
                Read-Host "`nPress Enter to return"
                Clear-Host
                break
            }
            else {
                write-host "`nUsername not found"
                Read-Host "`nPress Enter to return"
                Clear-Host
                break
            }
        }
        '7' {
            Clear-Host
        
            $words = get-content .\wordlist.txt
           
            $salasana = [string](0..9 | Get-Random) + ((Get-Random -inputobject $words -Count 2) -join (0..9 | Get-Random))
            $salasana
        
            Read-Host "`nPress Enter to return"
            Clear-Host
            break
        }
        '8' {
            exit
        }
    }
}

while ($True) {

    Set-Menu
    Get-Information

}

exit