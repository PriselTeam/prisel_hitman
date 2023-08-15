PriselHitman = {}

local function Include(f) return include("prisel_hitman/"..f) end
local function AddCSLua(f) return AddCSLuaFile("prisel_hitman/"..f) end
local function IncludeAdd(f) return Include(f), AddCSLua(f) end

IncludeAdd("config.lua")
IncludeAdd("sh_functions.lua")


if SERVER then

	Include("server/sv_functions.lua")
	Include("server/sv_hooks.lua")
	Include("server/sv_network.lua")

	AddCSLua("client/cl_functions.lua")
	AddCSLua("client/cl_hooks.lua")
	AddCSLua("client/cl_network.lua")

else

	Include("client/cl_functions.lua")
	Include("client/cl_hooks.lua")
	Include("client/cl_network.lua")

end

resource.AddFile("materials/prisel_hitman/logo_prisel_hitman.png")