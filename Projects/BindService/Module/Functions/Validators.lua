local Validators = {}

local function validateInputBinding(funcName, name, callback, debounce, keys)
	local validation = {
		valid = true,
		paramName = "",
		expectedType = "",
	}

	if type(name) ~= "string" then
		validation.valid = false
		validation.paramName = "name"
		validation.expectedType = "string"
		return validation
	end

	if type(callback) ~= "function" then
		validation.valid = false
		validation.paramName = "callback"
		validation.expectedType = "function"
		return validation
	end

	if type(debounce) ~= "number" or debounce < 0 then
		validation.valid = false
		validation.paramName = "debounce"
		validation.expectedType = "number (>= 0)"
		return validation
	end

	if type(keys) == "table" then
		-- If keys is a table, validate each key code
		for _, key in ipairs(keys) do
			if typeof(key) ~= "EnumItem" or (key.EnumType ~= Enum.KeyCode and key.EnumType ~= Enum.UserInputType) then
				validation.valid = false
				validation.paramName = "keys"
				validation.expectedType = "table of Enum.KeyCode or Enum.UserInputType values"
				return validation
			end
		end
	elseif typeof(keys) == "EnumItem" and (keys.EnumType == Enum.KeyCode or keys.EnumType == Enum.UserInputType) then
		-- If keys is a single Enum.KeyCode or Enum.UserInputType value, convert it to a table
		keys = {keys}
	else
		validation.valid = false
		validation.paramName = "keys"
		validation.expectedType = "table of Enum.KeyCode or Enum.UserInputType values"
		return validation
	end

	return validation
end

local validatorsMeta = {
	__index = function(_, key)
		if key == "validateInputBinding" then
			return function(...)
				return validateInputBinding(...)
			end
		else
			return nil
		end
	end,
	__metatable = "The metatable is locked",
	__newindex = function()
		error("Attempt to modify read-only table")
	end
}
return setmetatable({}, validatorsMeta)