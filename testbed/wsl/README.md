# Installation Part 1/2: WSL

This page describes the preparation of WSL for the IPv6 testbed.

A general testbed introduction can be found at: [testbed](..)

## Overview

![Testbed Overview](../../images/ipv6_testbed_wsl.svg "Testbed Overview")

The following will prepare the colored portions. After that, the greyed out parts will be prepared in [debian](../debian/).

## WSL Debian Installation (wsl-install.bat)

The following installs a fresh Debian 13 named "Debian-IPv6" into WSL including all the required files and settings. It is usually needed to be run only once on a Windows machine but can also be used to completely start from scratch if something went really bad with the testbed.

TODO: The following assumes WSL 2 itself is already installed

Open cmd (or Powershell) and cd to the testbed folder.

Call [wsl-install.bat](wsl-install.bat) to install Debian into WSL:

```
C:\Users\ulfl\Nextcloud\Documents\github.ulflulfl.ipv6\testbed>wsl-install.bat
.
--- Update wsl ---
Es wird nach Updates gesucht.
Die neueste Version von Windows-Subsystem für Linux ist bereits installiert.
<<< SNIP >>>
--- Show installed distributions ---
  NAME            STATE           VERSION
* Debian-IPv6     Running         2
  Debian          Running         2
  Ubuntu-22.04    Stopped         2
--- DELETE "old" Debian-IPv6 distro ---
THE FOLLOWING WILL COMPLETELY DELETE AN INSTALLED "Debian-IPv6" DISTRIBUTION!
Press Ctrl+C to abort!
Drücken Sie eine beliebige Taste . . .
```
It now asks to remove a previously installed "Debian-IPv6" (all other installed WSL distros will remain untouched).

**:warning: WARNING: If you have previously installed a distro named "Debian-IPv6" (which should only be the case if you have used wsl-install.bat before), the distro will be DELETED from WSL and every stored work in it will be lost!**

Press any key to continue or Ctrl+C to abort!

New installation of "Debian-IPv6" only takes a few seconds ...
```
Registrierung wird aufgehoben.
Der Vorgang wurde erfolgreich beendet.
The following installs a new "Debian-IPv6" distribution!
After installation enter a new user and password AND THEN EXIT AGAIN!
--- Install "new" Debian-IPv6 distro ---
Herunterladen: Debian GNU/Linux
Wird installiert: Debian GNU/Linux
Die Verteilung wurde erfolgreich installiert. Sie kann über "wsl.exe -d Debian-IPv6" gestartet werden.
Debian-IPv6 wird gestartet...
```
After installation, the newly installed  "Debian-IPv6" is started and asks for a user and password (the values don't really matter as we will use the root user later on).

**After providing the credentials, enter `exit` for the installation to continue!**
```
Please create a default UNIX user account. The username does not need to match your Windows username.
For more information visit: https://aka.ms/wslusers
Enter new UNIX username: ulfl
New password:
Retype new password:
passwd: password updated successfully
usermod: no changes
ulfl@delle:/mnt/c/Users/ulfl/Nextcloud/Documents/github.ulflulfl.ipv6/testbed$
exit
```
After some settings are changed, the installation shows distribution infos and returns to Windows:
```
--- Switch default distro to Debian-IPv6 ---
Der Vorgang wurde erfolgreich beendet.
--- Set user to root ---
Der Vorgang wurde erfolgreich beendet.
--- Link testbed files to Debian-IPv6 ---
--- Show installed distributions ---
  NAME            STATE           VERSION
* Debian-IPv6     Running         2
  Debian          Running         2
  Ubuntu-22.04    Stopped         2
--- Show current version ---
PRETTY_NAME="Debian GNU/Linux 13 (trixie)"

C:\Users\ulfl\Nextcloud\Documents\github.ulflulfl.ipv6\testbed>
```

If you see "trixie" in the PRETTY_NAME, wsl is running and it has installed and is using Debian 13 -> GOOD

Various WSL usage hints can be found at: [wsl-usage.md](wsl-usage.md)

---

## Start WSL Debian (wsl-start.bat)

For everyday work ...

Call [wsl-start.bat](wsl-start.bat) to prepare Debian distro and start WSL:

```
C:\Users\ulfl\Nextcloud\Documents\github.ulflulfl.ipv6\testbed>wsl-start.bat
--- Switch default distro to Debian-IPv6 ---
Der Vorgang wurde erfolgreich beendet.
--- Set user to root ---
Der Vorgang wurde erfolgreich beendet.
--- Link testbed files to Debian-IPv6 ---
--- Start wsl ---
23:02:07 root@delle ~ #
```

If you have ran `wsl-start.bat` before and haven't change any wsl settings, simply running `wsl` should work as well.

... and `cd ipv6` (which is the testbed's debian folder):

```
23:02:07 root@delle ~ # cd ipv6
23:02:47 root@delle ~/ipv6 #
```

Now continue with the instructions in [debian](../debian)
