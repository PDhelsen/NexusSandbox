@echo off
setlocal enabledelayedexpansion

set Root=%~dp0..\..\..\

set Project=""
set Platform=""
set Configuration=""
for /F "tokens=1-3 delims=_" %%A in ("%1") do (
    set Project=%%A
    set Platform=%%B
    set Configuration=%%C
)

set Target=!Platform:Win64-Editor=NexusEditor!
set Target=!Target:Win64=NexusApp!

set Artifacts=%Root%builds\artifacts\%Target%\
set Binaries=%Root%builds\binaries\%Project%_%Platform%_%Configuration%\
robocopy %Binaries% %Artifacts% *.lib *.dll *.exe /it /is /e /v

set FrameworkPlatform=%Platform:-Editor=%
set Framework=%NexusFramework%\Builds\NexusFramework_!FrameworkPlatform!_%Configuration%\
robocopy !Framework! %Artifacts% *.lib *.dll *.exe /it /is /e /v

set Engine=%NexusEngine%\Builds\NexusEngine_%Platform%_%Configuration%\
robocopy !Engine! %Artifacts% *.lib *.dll *.exe /it /is /e /v
set Editor=%NexusEngine%\Builds\NexusEditor_%Platform%_%Configuration%\
robocopy !Editor! %Artifacts% *.lib *.dll *.exe /it /is /e /v
set App=%NexusEngine%\Builds\NexusApp_%Platform%_%Configuration%\
robocopy !App! %Artifacts% *.lib *.dll *.exe /it /is /e /v
set Starter=%NexusEngine%\Builds\NexusStarter_%Platform%_%Configuration%\
robocopy !Starter! %Artifacts% *.lib *.dll *.exe /it /is /e /v

if errorlevel 1 (pause) else (exit /b 0)
