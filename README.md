Comments for this clone of wxHaskell
====================================

Some instructions for use on Windows.
Install wxWidgets in MSYS2/MinGW64 shell:

```console
$ pacman -Syu
$ # Restart MSYS2
$ pacman -Su
$ # Restart MSYS2
$ pacman -S mingw-w64-x86_64-wxmsw3.1
$
$ # ln in MSYS2 just makes a copy so it's better
$ # to use CMD: mklink or PowerShell New-item
$ ln -s /mingw64/bin/wx-config-3.1 /mingw64/bin/wx-config
$ ln -s /mingw64/include/wx-3.1 /mingw64/include/wx
$
$ # Make a small wxWidgets application and test building it
$ g++ HelloWorldApp.cpp `wx-config --libs` `wx-config --cxxflags` -o HelloWorldApp
$ # A lot of dll's must be available to execute it.
```

Clone and install wxHaskell

```console
$ git clone git@github.com:gussen/wxHaskell.git
$ cd wxHaskell
$
$ cd .\wxdirect
$ cabal build
$ cabal install
$ cd ..
$ # Copying 'wxdirect.exe' to 'C:\Users\mg\AppData\Roaming\cabal\bin\wxdirect.exe'
$
$ cabal install .\wxc
$ cabal install .\wxcore
$ cabal install .\wx
```

Make a wxHaskell application, e.g. wx_hello, and build it

```console
$ # Goto the directory where wxHaskell is a subdirectory
$ git clone git@github.com:gussen/wx_hello.git
$ cd wx_hello
$ cabal build
```

wxHaskell
=========

wxWidgets wrapper for Haskell


Status
======

Builds & compiles
- against: wxWidgets (http://www.wxwidgets.org/) 2.9.3 up to and including 3.0.3
- with: Haskell platform (http://www.haskell.org/platform/) 8.2.1, GHC 8.4.1
- on: MacOSX 10.8.4, 64 bits Haskell platform; Windows 8.1 (32 and 64 bit)

Patches until 2017-11-05 have been merged.

All packages have cabal version 0.93.0.0


Build & installation
====================

See <https://wiki.haskell.org/WxHaskell>


Platform specifics
==================

MacOSX:
- 20130725: homebrew (http://brew.sh/) does not yet install wxWidgets 2.9.5 (by means of 'brew install wxmac').
