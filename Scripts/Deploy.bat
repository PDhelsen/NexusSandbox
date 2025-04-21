@echo off

set Root=%~dp0..\

set Target=%1
if [%Target%] == [] (set /p Target=Enter target directory:)

set Deploy=%Target%\NexusSandbox\
if exist %Deploy% rmdir /s /q %Deploy%
mkdir %Deploy%

robocopy %Root%builds\package %Deploy% /it /is /e /v

if errorlevel 1 (pause) else (exit /b 0)
