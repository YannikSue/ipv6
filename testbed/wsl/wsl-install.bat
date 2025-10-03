@echo off
echo ------------------------------------------------------------------------------
rem set the distribution to install, see: "wsl --list --online" for available options
set INSTALL_DISTRO=Debian
rem set the distribution name
set INSTALL_NAME=Debian-IPv6
echo (Re-)Install a "%INSTALL_DISTRO%" distro with the name "%INSTALL_NAME%" ...

echo ------------------------------------------------------------------------------
rem echo --- TODO: Install wsl ---
rem not sure if we want to do this here, a lot can go wrong ...

echo --- Update wsl ---
wsl --update

echo --- Show wsl version ---
wsl --version

rem TODO: check for a minimum wsl version?

echo --- Show installed distributions ---
wsl --list --verbose

echo ------------------------------------------------------------------------------
echo --- DELETE "old" %INSTALL_NAME% distro ---
rem TODO: Add a check wether %INSTALL_NAME% is actually installed
echo THE FOLLOWING WILL COMPLETELY DELETE AN INSTALLED "%INSTALL_NAME%" DISTRIBUTION!
echo Press Ctrl+C to abort!
rem TODO: ask for specific user confirmation
pause
wsl --unregister %INSTALL_NAME%

echo ------------------------------------------------------------------------------
echo --- Install "new" %INSTALL_NAME% distro ---
echo The following installs a new "%INSTALL_NAME%" distribution!
echo After installation enter a new user and password AND THEN EXIT AGAIN!

wsl --install %INSTALL_DISTRO% --name %INSTALL_NAME%
rem there seems to be no way to create user/pass automatically
rem --no-launch only avoids asking for the user/pass until the first login

echo ------------------------------------------------------------------------------
echo --- Switch default distro to %INSTALL_NAME% ---
wsl --set-default %INSTALL_NAME%

echo --- Set user to root ---
wsl --manage %INSTALL_NAME% --set-default-user root

echo --- Show installed distributions ---
wsl --list --verbose

echo --- Show current version ---
wsl bash -c "cat /etc/os-release | grep PRETTY_NAME"
