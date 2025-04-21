@echo off

set Root=%~dp0..\..\
call %Root%Scripts\Package\Package.bat Release Win64
