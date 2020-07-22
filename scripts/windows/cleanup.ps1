#!/bin/sh

Remove-Item -Path "${env:USERPROFILE}\VBoxGuestAdditions.iso" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "${env:USERPROFILE}\windows.iso" -Force -ErrorAction SilentlyContinue
