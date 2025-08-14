@echo off

set Root=%~dp0..\..\

set Configuration=%1
if [%Configuration%] == [] (set /p Configuration=Enter configuration:)
set Platform=%2
if [%Platform%] == [] (set /p Platform=Enter platform:)

set Package=%Root%builds\package\
set Binaries=%Root%builds\binaries\

if exist %Package% rmdir /s /q %Package%
mkdir %Package%

robocopy %NexusFramework%\Builds\yaml-cpp_%Platform%_%Configuration%\ %Package% *.dll /it /is /e /v
robocopy %NexusFramework%\Builds\NexusFramework_%Platform%_%Configuration%\ %Package% *.dll /it /is /e /v

robocopy %NexusEngine%\Builds\NexusEngine_%Platform%_%Configuration%\ %Package% *.dll /it /is /e /v
robocopy %NexusEngine%\Builds\NexusApp_%Platform%_%Configuration%\ %Package% *.dll /it /is /e /v
robocopy %NexusEngine%\Builds\NexusStarter_%Platform%_%Configuration%\ %Package% *.exe /it /is /e /v
robocopy %NexusEngine%\Builds\Glfw_%Platform%_%Configuration%\ %Package% *.dll /it /is /e /v
robocopy %NexusEngine%\Builds\ImGui_%Platform%_%Configuration%\ %Package% *.dll /it /is /e /v

robocopy %Binaries%NexusSandbox-App_%Platform%_%Configuration% %Package% *.dll /it /is /e /v
rename %Package%NexusStarter.exe NexusSandbox.exe

if errorlevel 1 (pause) else (exit /b 0)
