--[[
		____  _           _______                 _  
	   / __ )(_)___  ____/ / ___/___  ______   __(_)_______
	  / __  / / __ \/ __  /\__ \/ _ \/ ___/ | / / / ___/ _ \
	 / /_/ / / / / / /_/ /___/ /  __/ /   | |/ / / /__/  __/
	/_____/_/_/ /_/\__,_//____/\___/_/    |___/_/\___/\___/

	BindService Module Documentation
	GitHub: https://github.com/notqaltx/notqaltx.github.io/Projects/BindService
	Documentation Site: https://notqaltx.github.io/Projects/BindService/Documentation

	Welcome to the BindService module documentation! This module provides a flexible system for managing input bindings in Roblox games. With BindService, you can easily create, manage, and customize input bindings for various game actions.

	Getting Started
	To start using BindService in your game, follow these steps:

	1. Require the Module: Insert the BindService module into your game and require it in your scripts:
	-- Example:
	local BindService = require(game:GetService("ReplicatedStorage").BindService)

	2. Create Input Bindings: Use BindService functions to create input bindings for your game actions. You can bind keys, mouse buttons, and other input events to specific functions in your game.

	3. Handle Input Events: Implement the functions that will be called when the bound inputs are triggered. These functions will execute the corresponding game actions.

	4. Customize Input Parameters: Customize input buffering parameters, such as debounce time, to fine-tune the responsiveness of your input bindings.

	5. Manage Input Profiles: Save and load input profiles to allow players to customize their control schemes.

	Features

	Input Binding Functions

	BindKeyPresses: Binds a function to one or more keyboard keys.
	BindMouseButtonPresses: Binds a function to one or more mouse buttons.
	BindInputEvent: Binds a function to a specific input event.
	BindInputEnded: Binds a function to the end of a specific input event.
	SetInputBindings: Sets multiple input bindings at once.
	Unbind: Unbinds a previously bound function.
	UnbindAll: Unbinds all currently bound functions.

	Attribute Management

	AddBindAttribute: Adds a custom attribute to a specific input binding.
	SetBindAttribute: Sets the value of a custom attribute for a specific input binding.
	GetBindAttribute: Retrieves the value of a custom attribute for a specific input binding.
	RemoveBindAttribute: Removes a custom attribute from a specific input binding.

	Input Profile Management

	SaveInputProfile: Saves a set of input bindings as a named profile.
	LoadInputProfile: Loads a saved input profile.
	DeleteInputProfile: Deletes a saved input profile.

	Input Filtering and Mapping

	AddInputFilter: Adds a filter function to restrict certain input types.
	RemoveInputFilter: Removes a previously added input filter.
	IsInputAllowed: Checks if a specific input type is allowed based on registered filters.
	AddInputMapping: Maps one input type to another for input abstraction.
	RemoveInputMapping: Removes a previously set input mapping.
	GetMappedInput: Retrieves the mapped input type for a given input.

	Usage Examples

	Binding Keyboard Keys

	BindService.BindKeyPresses("MoveForward", function()
		-- Code to move the player forward
	end, Enum.KeyCode.W)

	Customizing Input Attributes

	BindService.AddBindAttribute("MoveForward", "speed", 10)

	Saving and Loading Input Profiles

	BindService.SaveInputProfile("DefaultControls", {
		MoveForward = {Keys = {Enum.KeyCode.W}, Callback = function() ... },
		MoveBackward = {Keys = {Enum.KeyCode.S}, Callback = function() ... },
		Jump = {Keys = {Enum.KeyCode.Space}, Callback = function() ... }
	})

	Credits
	BindService was created by notqaltx.
]]

local BindService = {}
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
setmetatable(BindService, metatable)
return BindService