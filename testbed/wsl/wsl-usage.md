# WSL Usage
Quick hints how to use WSL.

Beware that a lot of internet information about WSL is outdated!

## Check WSL Installation

### WSL Version

Check the installed wsl version with `wsl --version`:

```
C:\Users\ulfl\Nextcloud\Documents\github.ulflulfl.ipv6\testbed>wsl --version
WSL-Version: 2.5.10.0
<<< SNIP >>>
```

You can use `wsl –update` to update it. Not sure if the normal Windows Update mechanism also updates WSL.

### Installed Distros

List installed distros with `wsl --list --verbose`:
```
C:\Users\ulfl\Nextcloud\Documents\github.ulflulfl.ipv6\testbed>wsl --list --verbose
  NAME            STATE           VERSION
* Debian          Running         2
  Ubuntu-22.04    Stopped         2
```

There should be an entry "Debian" and it should be "Running" with (WSL) version 2. The asterisk should mark Debian as the currently active distribution. Use `wsl –set-default Debian` if that's not the case.

### Installed Debian Version

You can issue commands to run inside Debian directly from the Windows command line. For example, check the installed Debian version with `wsl cat /etc/os-release`:
```
C:\Users\ulfl\Nextcloud\Documents\github.ulflulfl.ipv6\testbed>wsl cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 13 (trixie)"
<<< SNIP >>>
```

---

## WSL Daily work

### Login to the Distro

Start wsl from cmd.exe or PowerShell simply with `wsl`:

```
C:\Users\ulfl\Nextcloud\Documents\github.ulflulfl.ipv6\testbed>wsl
root@delle:/mnt/c/Users/ulfl/Nextcloud/Documents/github.ulflulfl.ipv6/testbed#
```

The prompt "root@delle" indicates the switch into the distro.

### Work Inside the Distro

#### Mounts

You can access the files of the Windows machine with the `/mnt` path:

```
cd /mnt/c/Users/ulfl
```

#### GUI Programs (e.g. Wireshark)

You can start Linux GUI programs that will be displayed as a Window in Windows.

```
root@delle:~# wireshark
```

If started in the background using an ampersand `wireshark &`, it won't block the console but may sometimes cause "funny" console output.

Obviously, the program must exist in the distro (`sudo apt install wireshark`).

### Work in Windows

#### Windows Explorer

You can directly access the files of the Debian Distro in the Windows Explorer by clicking on the linux penguin to the left or with the address:

\\\wsl.localhost\Debian

In former times there were often warnings to not alter any files this way, but it seems this was fixed in the meantime.

### Issue Commands from Windows into the Distro

You can issue commands to run inside Debian directly from the Windows command line. For example, check the installed Debian version with `wsl cat /etc/os-release`:
```
C:\Users\ulfl\Nextcloud\Documents\github.ulflulfl.ipv6\testbed>wsl cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 13 (trixie)"
<<< SNIP >>>
```

Sometimes cmd.exe causes trouble, e.g. when you concatenate commands with &&. In this case you can use something like:

`wsl bash -c "apt update && apt upgrade -y"`

### Logout of the Distro

Call exit or use the shortcut Ctrl+D:

```
root@delle:~# exit
logout

C:\Users\ulfl\Nextcloud\Documents\github.ulflulfl.ipv6\testbed>
```

### Stop WSL

WSL will stay running in the background! You can stop it with `wsl --shutdown`:

```
C:\Users\ulfl\Nextcloud\Documents\github.ulflulfl.ipv6\testbed>wsl --shutdown
```

There is no further output. TODO: How to check if WSL is really shut down?
