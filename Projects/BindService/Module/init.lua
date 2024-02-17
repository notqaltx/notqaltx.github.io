--[[
	▒█▀▀█ ▒█░▒█ ▒█▀▀▀ ▒█▀▀▀ ▒█▀▀▀ ▒█▀▀█ 　 ▒█▀▀▀█ ▒█▀▀▀ ▒█▀▀█ ▀█▀ ▒█░░▒█ ▒█▀▀█ ▒█▀▀▀ 
	▒█▀▀▄ ▒█░▒█ ▒█▀▀▀ ▒█▀▀▀ ▒█▀▀▀ ▒█▄▄▀ 　 ░▀▀▀▄▄ ▒█▀▀▀ ▒█▄▄▀ ▒█░ ░▒█▒█░ ▒█░░░ ▒█▀▀▀ 
	▒█▄▄█ ░▀▄▄▀ ▒█░░░ ▒█░░░ ▒█▄▄▄ ▒█░▒█ 　 ▒█▄▄▄█ ▒█▄▄▄ ▒█░▒█ ▄█▄ ░░▀▄▀░ ▒█▄▄█ ▒█▄▄▄
	
	BindService
]]

local BindService = {}
local HTTPService = game:GetService("HttpService")

local settings = {
	ModuleID = 16296841857,
	ModuleLastID = nil,
	AutoUpdate = {
		IsAuto = true,
		UpdateTime = 30
	},
	LocalVersion = "1.0.0"
}
local function __init()
--	local InsertService = game:GetService("InsertService")
--	if settings.AutoUpdate.IsAuto then
--		local str = "BindService Update Available!\
--					Current Version: %s \
--					Latest Version: %s"
	
--		--if settings.ModuleLastID ~= Latest then
--		--	warn(string.format(str, settings.LocalVersion, Latest, "%q"))
--		--else
--		--	warn("BindService is already up to date.")
--		--end
--	end
	-- Get the current version
	local currentVersion = BindService.Version

	-- Retrieve the latest version stored in the DataStore
	local success, latestVersion = pcall(function()
		return versionDataStore:GetAsync("LatestVersion")
	end)

	if success then
		-- Compare the latest version with the current version
		if latestVersion > currentVersion then
			-- An update is available
			print("Update available! Downloading...")

			-- Retrieve the updated module code from the DataStore
			local success, updatedModule = pcall(function()
				return versionDataStore:GetAsync("UpdatedModule")
			end)

			if success then
				-- Replace the existing BindService module with the updated one
				game.ServerScriptService.BindService:ClearAllChildren() -- Clear existing module
				local updatedModuleScript = Instance.new("ModuleScript")
				updatedModuleScript.Name = "BindService"
				updatedModuleScript.Source = updatedModule
				updatedModuleScript.Parent = game.ServerScriptService
				print("Update complete!")
			else
				warn("Failed to retrieve updated module from DataStore.")
			end
		else
			print("No updates available.")
		end
	else
		warn("Failed to retrieve latest version from DataStore.")
	end
end
local metatable = {
	__index = function(self, key)
		local modules = {
			Functions = require(script.Functions),
			Features = require(script.Features)
		}
		for _, module in pairs(modules) do
			if module[key] then
				return module[key]
			end
		end
		return nil
	end,
	__metatable = "The metatable is locked",
	__newindex = function(table, key, value)
		error("Attempt to modify read-only table")
	end,
	__tostring = function(table)
		local str = "BindService: {\n"
		for key, _ in pairs(table) do
			str = str .. "  " .. key .. "\n"
		end
		str = str .. "}"
		return str
	end
}
--spawn(function()
--	while true do __init()
--		task.wait(settings.AutoUpdate.UpdateTime)
--	end
--end)
setmetatable(BindService, metatable)
return BindService