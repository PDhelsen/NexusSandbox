@echo off

set Root=%~dp0..\..\

pushd %Root%
call %Root%builds\artifacts\NexusEditor.exe %*
popd %Current%

if errorlevel 1 (pause) else (exit /b 0)
