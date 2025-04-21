@echo off

set Root=%~dp0..\..\

pushd %Root%builds\package\
call NexusSandbox.exe DebugFolder=debugpackage
popd

if errorlevel 1 (pause) else (exit /b 0)
