Root = os.realpath(os.getcwd() .. "/../../"):gsub("\\", "/")
NexusFramework = os.getenv('NexusFramework') .. "/"
NexusEngine = os.getenv('NexusEngine') .. "/"

Name = "%{prj.name}"
Output = "%{prj.name}_%{cfg.platform}_%{cfg.buildcfg}"
Link = "_%{cfg.platform:gsub('-Editor', '')}_%{cfg.buildcfg}"

Framework = "NexusFramework"
Engine = "NexusEngine"
App = "NexusApp"
Editor = "NexusEditor"
Starter = "NexusStarter"
Utility = "NexusUtility"
Project = "NexusProject"
Sandbox = "NexusSandbox"
SandboxApp = "NexusSandbox-App"
SandboxEditor = "NexusSandbox-Editor"

Builds = Root .. "builds/"
Configs = Root .. "Configs/"
Libraries = Root .. "Libraries/"
Scripts = Root .. "Scripts/"
Sources = Root .. "Sources/"

Artifacts = Builds .. "artifacts/"
Binaries = Builds .. "binaries/"
Intermediates = Builds .. "intermediates/"
Code = Sources .. Name .. "/"
External = Libraries .. Name .. "/"
Target = Binaries .. Output .. "/"
Object = Intermediates .. Output .. "/"

PostBuild = Scripts .. "Build/Steps/PostBuild.bat " .. Output

workspace (Sandbox)
    location (Root)

    platforms { "Win64", "Win64-Editor" }
    configurations { "Debug", "Release", "Distrib" }

	startproject (SandboxApp)
	debugdir (Root)
	debugcommand (Artifacts .. App .. "/" .. App .. ".exe")
	filter "platforms:*-Editor"
		debugcommand (Artifacts .. Editor .. "/" .. Editor .. ".exe")
	filter {}

	characterset "Unicode"
    flags { "MultiProcessorCompile" }

	filter "action:vs*"
        toolset "msc"

    filter "toolset:msc"
        defines { "NEXUS_MSVC" }

    filter "platforms:Win64*"
        defines { "NEXUS_WINDOWS" }
        architecture "x64"
		system "windows"

    filter "platforms:*-Editor"
        defines { "NEXUS_EDITOR" }

    filter "configurations:Debug"
        defines { "NEXUS_DEBUG" }
        symbols "On"
        optimize "Off"

    filter "configurations:Release"
        defines { "NEXUS_RELEASE" }
        symbols "On"
        optimize "On"

    filter "configurations:Distrib"
        defines { "NEXUS_DISTRIB" }
        symbols "Off"
        optimize "On"

project (SandboxApp)
    location (Code)

    kind "SharedLib"
    language "C++"
	cppdialect "C++20"

	targetname (Project .. "-App")
	targetdir (Target)
	objdir (Object)

    files
    {
        Code .. "**.h",
        Code .. "**.cpp",
    }

    includedirs
    {
        Sources,
		NexusFramework .. "Sources/",
		NexusEngine .. "Sources/"
    }

	libdirs
	{
		NexusFramework .. "Builds/NexusFramework" .. Link,
		NexusEngine .. "Builds/NexusEngine" .. Link,
		NexusEngine .. "Builds/NexusApp" .. Link
	}

	links
	{
		Framework,
		Engine,
		App
	}

	defines
	{
		"NEXUS_SANDBOX_APP_DLL"
	}

    postbuildcommands
    {
        PostBuild
    }


project (SandboxEditor)
    location (Code)

    kind "SharedLib"
    language "C++"
	cppdialect "C++20"

	targetname (Project .. "-Editor")
	targetdir (Target)
	objdir (Object)

    files
    {
        Code .. "**.h",
        Code .. "**.cpp",
    }

    includedirs
    {
        Sources,
		NexusFramework .. "Sources/",
		NexusEngine .. "Sources/"
    }

	libdirs
	{
		NexusFramework .. "Builds/NexusFramework" .. Link,
		NexusEngine .. "Builds/NexusEngine" .. Link,
		NexusEngine .. "Builds/NexusApp" .. Link,
		NexusEngine .. "Builds/NexusEditor" .. Link
	}

	links
	{
		Framework,
		Engine,
		App,
		Editor,
		SandboxApp
	}

	defines
	{
		"NEXUS_SANDBOX_EDITOR_DLL"
	}

    postbuildcommands
    {
        PostBuild
    }
