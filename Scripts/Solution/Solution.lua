Framework = "NexusFramework"
Engine = "NexusEngine"
App = "NexusApp"
Editor = "NexusEditor"
Starter = "NexusStarter"
Utility = "NexusUtility"
Project = "NexusProject"
Sandbox = "NexusSandbox"
GTest = "GTest"
YamlCpp = "yaml-cpp"
ImGui = "ImGui"
ModeApp = "-App"
ModeEditor = "-Editor"

ProjectName = "%{prj.name}"
OutputDirectory = "%{prj.name}_%{cfg.platform}_%{cfg.buildcfg}"
OutputName = "%{cfg.buildtarget.basename}%{cfg.buildtarget.extension}"
LinkConfigFramework = "_%{cfg.platform:gsub('-Editor', '')}_%{cfg.buildcfg}"
LinkConfigEngine = "_%{cfg.platform}_%{cfg.buildcfg}"
Language = "C++"
LanguageVersion = "C++20"
Systems = 
{
    Windows = "windows"
}
Platforms = 
{
    Win64 = "Win64",
	Win64Editor = "Win64-Editor"
}
Configurations = 
{
    Debug  = "Debug",
    Release = "Release",
    Distrib = "Distrib"
}
Compilers = 
{
    Msvc = "msc"
}
Tools = 
{
    VisualStudio = "vs*"
}
Warnings = 
{
    "4244", "4251", "4267", "4275"
}

Root = os.realpath(os.getcwd() .. "/../../"):gsub("\\", "/")
InstallFramework = os.getenv(Framework) .. "/"
InstallEngine = os.getenv(Engine) .. "/"

Builds = Root .. "builds/"
Configs = Root .. "Configs/"
Libraries = Root .. "Libraries/"
Scripts = Root .. "Scripts/"
Sources = Root .. "Sources/"

Artifacts = Builds .. "artifacts/"
Binaries = Builds .. "binaries/"
Intermediates = Builds .. "intermediates/"
FirstParty = Sources .. ProjectName .. "/"
ThirdParty = Libraries .. ProjectName .. "/"
Target = Binaries .. OutputDirectory .. "/"
Object = Intermediates .. OutputDirectory .. "/"

Includes = 
{
    Sources,
    Libraries,
    InstallFramework .. "Sources/",
    InstallFramework .. "Libraries/",
    InstallEngine .. "Sources/",
    InstallEngine .. "Libraries/"
}

LibrariesIncludes = 
{
	InstallFramework .. "Builds/" .. Framework .. LinkConfigFramework,
	InstallFramework .. "Builds/" .. GTest .. LinkConfigFramework,
	InstallFramework .. "Builds/" .. YamlCpp .. LinkConfigFramework,
    InstallEngine .. "Builds/" .. Engine .. LinkConfigEngine,
    InstallEngine .. "Builds/" .. App .. LinkConfigEngine,
    InstallEngine .. "Builds/" .. ImGui .. LinkConfigEngine,
}

Links = 
{
    Framework,
    GTest,
    YamlCpp,
    Engine,
    App,
    ImGui
}

Defines = 
{
	"GTEST_LINKED_AS_SHARED_LIBRARY",
	'IMGUI_USER_CONFIG="NexusEngine/External/ImGui/Config.h"'
}

PostBuild = Scripts .. "Build/Steps/PostBuild.bat " .. OutputDirectory .. " " .. OutputName

workspace (Sandbox)
    location (Root)

    platforms { Platforms.Win64, Platforms.Win64Editor }
    configurations { Configurations.Debug, Configurations.Release, Configurations.Distrib }

	startproject (Sandbox .. ModeApp)
	debugcommand (InstallEngine .. Editor .. ".exe")
	debugdir (Root)
	filter ("platforms:" .. Platforms.Win64)
		debugargs { "-Mode=App" }
	filter ("platforms:" .. Platforms.Win64Editor)
		debugargs { "-Mode=Editor" }
	filter ""

	characterset "Unicode"
    flags { "MultiProcessorCompile" }
    staticruntime "off"

	filter ("action:" .. Tools.VisualStudio)
        toolset (Compilers.Msvc)

    filter ("toolset:" .. Compilers.Msvc)
        defines { "NX_MSVC", "_CRT_SECURE_NO_WARNINGS" }
    	disablewarnings (Warnings)

    filter ("platforms:" .. Platforms.Win64 .. "*")
        defines { "NX_WINDOWS" }
		system (Systems.Windows)
        architecture "x64"

	filter ("platforms:*" .. ModeEditor)
        defines { "NX_EDITOR" }

    filter ("configurations:" .. Configurations.Debug)
        defines { "NX_DEBUG" }
        symbols "On"
        optimize "Off"

    filter ("configurations:" .. Configurations.Release)
        defines { "NX_RELEASE" }
        symbols "On"
        optimize "On"

    filter ("configurations:" .. Configurations.Distrib)
        defines { "NX_DISTRIB" }
        symbols "Off"
        optimize "On"

    filter ""

group "Misc"
	project (Utility)
group ""

-- ----------------------------------------------------------------------------------
project (Sandbox .. ModeApp)
    location (FirstParty)

    kind "SharedLib"
    language (Language)
	cppdialect (LanguageVersion)

	targetname (Project .. ModeApp)
	targetdir (Target)
	objdir (Object)

    files
    {
        FirstParty .. "**.h",
        FirstParty .. "**.cpp",
    }

    includedirs
    {
        Includes
    }

	libdirs
	{
		LibrariesIncludes
	}

	links
	{
		Links
	}

	defines
	{
		Defines,
        "NX_SANDBOX_APP_DLL"
	}

    postbuildcommands
    {
        PostBuild
    }


project (Sandbox .. ModeEditor)
    location (FirstParty)

    kind "SharedLib"
    language (Language)
	cppdialect (LanguageVersion)

	targetname (Project .. ModeEditor)
	targetdir (Target)
	objdir (Object)

    files
    {
        FirstParty .. "**.h",
        FirstParty .. "**.cpp",
    }

    includedirs
    {
        Includes
    }

	libdirs
	{
		LibrariesIncludes,
        InstallEngine .. "Builds/" .. Editor .. LinkConfigEngine,
	}

	links
	{
		Links,
        Editor
	}

	defines
	{
		Defines,
		"NX_SANDBOX_EDITOR_DLL"
	}

    postbuildcommands
    {
        PostBuild
    }

-- ----------------------------------------------------------------------------------
project (Utility)
    location (FirstParty)

    kind "Utility"

    targetdir (Target)
	objdir (Object)

    files
    {
        FirstParty .. "**.natvis",
		InstallFramework .. "Sources/" .. "**.natvis",
		InstallEngine .. "Sources/" .. "**.natvis",
    }
