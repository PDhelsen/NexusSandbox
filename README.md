# Nexus Sandbox

Nexus Sandbox is a small project made with NexusEngine.

# Supported Platform, Compiler,  Requirements

Nexus Sandbox is supported only Windows and MSCV compiler (it uses a few MSCV instrics functions).
The project generates the visual studio files with Premake.
Both Premake and Visual Studio build tools are expected to be available through environment variables in order to run the Scripts.

# How to build ?

It is required to have built and deploy NexusFramework and NexusEngine first as the sandbox is based on it.

Run the Scripts/Solution/Solution.bat to generate the Visual Studio files, then run the Scripts/Build/Command/Build* to build the solution.
Similarly to the framework and the engine, the sandbox exe can be deployed as a standalone packaged app, run the Scripts/Package/Package* first then Scripts/Deploy <path>. 