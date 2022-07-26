@echo off
set mod=%~dp0
cd MODBUILDER
lua.exe AutoHexModBuilder.lua %mod%





timeout /t 10





