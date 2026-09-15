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
        debugargs { "-Mode=App" }
    filter "platforms:Win64-Editor"
        debugargs { "-Mode=Editor" }
    filter {}

	characterset "Unicode"
    flags { "MultiProcessorCompile" }

	filter "action:vs*"
        toolset "msc"

    filter "toolset:msc"
        defines { "NX_MSVC" }
    	disablewarnings { "4244", "4267", "4251" }

    filter "platforms:Win64*"
        defines { "NX_WINDOWS" }
        architecture "x64"
		system "windows"

    filter "platforms:*-Editor"
        defines { "NX_EDITOR" }

    filter "configurations:Debug"
        defines { "NX_DEBUG" }
        symbols "On"
        optimize "Off"

    filter "configurations:Release"
        defines { "NX_RELEASE" }
        symbols "On"
        optimize "On"

    filter "configurations:Distrib"
        defines { "NX_DISTRIB" }
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
		NexusEngine .. "Sources/",
		NexusEngine .. "Libraries/"
    }

	libdirs
	{
		NexusFramework .. "Builds/NexusFramework" .. LinkFramework,
		NexusEngine .. "Builds/NexusEngine" .. LinkEngine,
		NexusEngine .. "Builds/NexusApp" .. LinkEngine,
		NexusEngine .. "Builds/ImGui" .. LinkEngine,
	}

	links
	{
		Framework,
		Engine,
		App,
		ImGui
	}

	defines
	{
		"NX_SANDBOX_APP_DLL"
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
		NexusEngine .. "Sources/",
		NexusEngine .. "Libraries/"
    }

	libdirs
	{
		NexusFramework .. "Builds/NexusFramework" .. LinkFramework,
		NexusEngine .. "Builds/NexusEngine" .. LinkEngine,
		NexusEngine .. "Builds/NexusApp" .. LinkEngine,
		NexusEngine .. "Builds/NexusEditor" .. LinkEngine,
		NexusEngine .. "Builds/ImGui" .. LinkEngine,
	}

	links
	{
		Framework,
		Engine,
		App,
		Editor,
		SandboxApp,
		ImGui
	}

	defines
	{
		"NX_SANDBOX_EDITOR_DLL"
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
