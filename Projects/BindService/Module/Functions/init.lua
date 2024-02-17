local Functions = {}

local modules = {
	Settings = require(script.Parent:WaitForChild("Local").Settings),
	Errors = require(script.Errors),
	Validators = require(script.Validators),
	Attributes  = require(script.Attributes)
}
local uis = game:GetService("UserInputService")
local binds = {}

local function createBuffer(callback, debounce, ...)
	local keys = {...}
	if type(debounce) ~= "number" or debounce <= 0 then
		return modules.Errors.handleInvalidInputError("createBuffer", "debounce", "number (>= 0)")
	end
	local buffer = {
		active = false,
		keys = keys,
		callback = callback,
		debounce = debounce,
		lastActivationTime = 0,
		preloadedInputs = {}
	}
	setmetatable(buffer, {
		__index = {
			activate = function(self)
				local currentTime = os.clock()
				if currentTime - self.lastActivationTime >= self.debounce then
					self.active = true
					for _, input in ipairs(self.preloadedInputs) do
						input()
					end
					self.callback()
					self.lastActivationTime = currentTime
				end
			end,
			deactivate = function(self)
				self.active = false
			end,
		},
		__call = function(self)
			if self.active then
				self.callback()
			end
		end,
	})
	return buffer
end
local function validInput(funcName, name, callback, debounce, keys)
	local validation = modules.Validators.validateInputBinding(funcName, name, callback, debounce, keys)
	if not validation.valid then
		return modules.Errors.handleInvalidInputError("BindKeyPresses", validation.paramName, validation.expectedType)
	end
	return true
end
local function checkAttribute(bind, name)
	if not bind.attributes then
		error("No attributes found for the bind: " .. name)
		return false
	end
	return true
end

local functionsHandler = {
	-- // Bindings
	BindKeyPresses = function(name, callback, debounce, ...)
		local keys = {...}
		local validationResult = validInput("BindKeyPresses", name, 
			callback, debounce, unpack(keys))
		if not validationResult then return end
		
		if type(keys[1]) == "table" then
			keys = keys[1]
		end
		local buffer = createBuffer(callback, debounce, keys)
		local connection = uis.InputBegan:Connect(function(input)
			if modules.Settings.DebugMode then
				print("InputBegan event fired.")
			end
			local allKeysPressed = true
			for _, key in ipairs(keys) do
				if not uis:IsKeyDown(key) then
					allKeysPressed = false
					break
				end
			end
			if allKeysPressed then
				buffer:activate()
			elseif modules.Settings.DebugMode then
				print("Not all keys pressed.")
			end
		end)
		binds[name] = {buffer = buffer, connection = connection, attributes = {}}
	end,

	BindMouseButtonPresses = function(name, callback, debounce, ...)
		local inputs = {...}
		local validationResult = validInput("BindMouseButtonPresses", name, 
			callback, debounce, unpack(inputs))
		if not validationResult then return end
		
		if type(inputs[1]) == "table" then
			inputs = inputs[1]
		end
		local buffer = createBuffer(callback, debounce, inputs)
		local connection = uis.InputBegan:Connect(function(input)
			for _, mouseButton in ipairs(inputs) do
				if input.UserInputType == mouseButton then
					buffer:activate()
					break
				end
			end
		end)
		binds[name] = {buffer = buffer, connection = connection, attributes = {}}
	end,

	BindInputEvent = function(name, callback, debounce, inputType)
		local validationResult = modules.Errors.validInput("BindInputEvent", name, 
			callback, debounce, inputType)
		if not validationResult then return end
		
		local buffer = createBuffer(callback, debounce)
		local connection = uis.InputChanged:Connect(function(input)
			if input.UserInputType == inputType then
				buffer:activate()
			end
		end)
		binds[name] = {buffer = buffer, connection = connection, attributes = {}}
	end,

	BindInputEnded = function(name, callback, debounce, inputType)
		local validationResult = modules.Errors.validInput("BindInputEnded", name, 
			callback, debounce, inputType)
		if not validationResult then return end
		
		local buffer = createBuffer(callback, debounce)
		local connection = uis.InputEnded:Connect(function(input)
			if input.UserInputType == inputType then
				buffer:activate()
			end
		end)
		binds[name] = {buffer = buffer, connection = connection, attributes = {}}
	end,

	SetInputBindings = function(bindings)
		local validationResult = validInput("SetInputBindings", bindings)
		if not validationResult then return end

		for name, keys in pairs(bindings) do
			local validationResult = validInput("SetInputBindings", name, keys.callback, keys.debounce, keys.keys)
			if not validationResult then return end

			local buffer = createBuffer(keys.callback, keys.debounce, unpack(keys.keys))
			local connection = uis.InputBegan:Connect(function(input)
				if modules.Settings.DebugMode then
					print("InputBegan event fired.")
				end
				local allKeysPressed = true
				for _, key in ipairs(buffer.keys) do
					if not uis:IsKeyDown(key) then
						allKeysPressed = false
						break
					end
				end
				if allKeysPressed then
					buffer:activate()
				elseif modules.Settings.DebugMode then
					print("Not all keys pressed.")
				end
			end)
			binds[name] = {buffer = buffer, connection = connection, attributes = {}}
		end
	end,
	-- ..
	
	-- // Attributes
	AddBindAttribute = function(name, attributeName, attributeValue)
		local bind = binds[name]
		if not bind then
			return error("No bind found with the specified name: "..name)
		end
		local attributeType = typeof(attributeValue)
		if not modules.Attributes[attributeType] then
			return error("Unsupported attribute value type: "..attributeType)
		end
		if not bind.attributes then
			bind.attributes = {}
		end
		bind.attributes[attributeName] = attributeValue
	end,

	SetBindAttribute = function(name, attributeName, attributeValue)
		local bind = binds[name]
		if not bind then
			return error("No bind found with the specified name: "..name)
		end
		local checkResult = checkAttribute(bind, name)
		if not checkResult then return end
		
		local attributeType = typeof(attributeValue)
		if not modules.Attributes[attributeType] then
			return error("Unsupported attribute value type: "..attributeType)
		end
		bind.attributes[attributeName] = attributeValue
	end,

	GetBindAttribute = function(name, attributeName)
		local bind = binds[name]
		if not bind then
			return error("No bind found with the specified name: "..name)
		end
		local checkResult = checkAttribute(bind, name)
		if not checkResult then return end
		return function()
			if bind.attributes[attributeName] == nil then
				local str = "No attribute found in %s with name: `%s`"
				return error(string.format(str, name, attributeName))
			end
			return bind.attributes[attributeName]
		end
	end,

	RemoveBindAttribute = function(name, attributeName)
		local bind = binds[name]
		if not bind then
			return error("No bind found with the specified name: "..name)
		end
		local checkResult = checkAttribute(bind, name)
		if not checkResult then return end
		bind.attributes[attributeName] = nil
	end,
	-- ..
	
	-- // Input Buffer Preloading
	PreloadInputs = function(name, ...)
		local preloadedInputs = {...}
		local success, err = pcall(function()
			local bind = binds[name]
			if not bind then
				error("No bind found with the specified name: "..name)
			end
			bind.preloadedInputs = preloadedInputs
		end)
		if success then
			print("Preloading successful for bind: " .. name)
			return true
		else
			warn("Preloading failed for bind `"..name.."`: "..err)
			return false
		end
	end,
	-- ..

	-- // Unbind
	Unbind = function(name)
		if type(name) ~= "string" then
			return modules.Errors.handleInvalidInputError("Unbind", "name", "string")
		end
		local bind = binds[name]
		if bind then
			bind.connection:Disconnect()
			binds[name] = nil
		elseif not bind then
			return error("No function named '" .. name .. "' is currently bound")
		end
	end,

	UnbindAll = function()
		local numBinds = 0
		for _ in pairs(binds) do numBinds = numBinds + 1 end
		if numBinds == 0 then
			return warn("No functions are currently bound!")
		else
			for _, bind in pairs(binds) do
				bind.connection:Disconnect()
			end
		end
		binds = {}
	end
	-- ..
}

local functionsMeta = {
	__index = functionsHandler,
	__metatable = "The metatable is locked",
	__newindex = function(table, key, value)
		error("Attempt to modify read-only table")
	end,
	__tostring = function(table)
		local str = "Functions: {\n"
		for key, _ in pairs(table) do
			str = str .. "  " .. key .. "\n"
		end
		str = str .. "}"
		return str
	end
}
return setmetatable({}, functionsMeta)