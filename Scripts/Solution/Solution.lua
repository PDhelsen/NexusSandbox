Root = os.realpath(os.getcwd() .. "/../../"):gsub("\\", "/")
NexusFramework = os.getenv('NexusFramework') .. "/"
NexusEngine = os.getenv('NexusEngine') .. "/"

Name = "%{prj.name}"
OutputDirectory = "%{prj.name}_%{cfg.platform}_%{cfg.buildcfg}"
OutputName = "%{cfg.buildtarget.basename}%{cfg.buildtarget.extension}"
LinkFramework = "_%{cfg.platform:gsub('-Editor', '')}_%{cfg.buildcfg}"
LinkEngine = "_%{cfg.platform}_%{cfg.buildcfg}"

Framework = "NexusFramework"
Engine = "NexusEngine"
App = "NexusApp"
Editor = "NexusEditor"
Starter = "NexusStarter"
Utility = "NexusUtility"
Project = "NexusProject"
Sandbox = "NexusSandbox"

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
Target = Binaries .. OutputDirectory .. "/"
Object = Intermediates .. OutputDirectory .. "/"

PostBuild = Scripts .. "Build/Steps/PostBuild.bat " .. OutputDirectory .. " " .. OutputName

workspace (Sandbox)
    location (Root)

    platforms { "Win64", "Win64-Editor" }
    configurations { "Debug", "Release", "Distrib" }

	startproject (Sandbox .. "-App")
	debugcommand (NexusEngine .. "NexusEditor.exe")
	debugdir (Root)
    filter "platforms:Win64"
        debugargs { "Target=App" }
    filter "platforms:Win64-Editor"
        debugargs { "Target=Editor" }
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

group "Misc"
	project (Utility)
group ""

project (Sandbox .. "-App")
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
		NexusFramework .. "Libraries/",
		NexusEngine .. "Sources/"
    }

	libdirs
	{
		NexusFramework .. "Builds/NexusFramework" .. LinkFramework,
		NexusEngine .. "Builds/NexusEngine" .. LinkEngine,
		NexusEngine .. "Builds/NexusApp" .. LinkEngine,
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


project (Sandbox .. "-Editor")
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
		NexusFramework .. "Libraries/",
		NexusEngine .. "Sources/"
    }

	libdirs
	{
		NexusFramework .. "Builds/NexusFramework" .. LinkFramework,
		NexusEngine .. "Builds/NexusEngine" .. LinkEngine,
		NexusEngine .. "Builds/NexusApp" .. LinkEngine,
		NexusEngine .. "Builds/NexusEditor" .. LinkEngine,
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

-- ----------------------------------------------------------------------------------
project (Utility)
    location (Code)

    kind "Utility"

    targetdir (Target)
	objdir (Object)

    files
    {
        Code .. "**.natvis",
		NexusFramework .. "Sources/" .. "**.natvis",
		NexusEngine .. "Sources/" .. "**.natvis",
    }
