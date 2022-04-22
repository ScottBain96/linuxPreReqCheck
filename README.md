Creating a script to automate pre-requisite check for ITOM agent linux/macOS for test environments.

Tested on Ubuntu, Fedora and centOS7.

Currently checks for following pre-requisites:

-user running the script
-OS details
-python command and required path (if python2 is installed but not configured for python command, it will also identify this)
-python3 command and required path
-if python path does not match pre-requisite, it will provide all found paths (for both python and python3)
-python library sqlite3 (for both python and python3)
-python library lib2to3 (python3)
-drops current session sudo password if used and then attempts to create required folders, to check if NOPASSWD is set correctly (folder is deleted after successfull creation)
-provides list of available commands for user running the script
-net-tools package (checks either with YUM or with DPKG, depending on which one is available).
