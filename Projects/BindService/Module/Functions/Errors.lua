local Errors = {}

Errors.INVALID_INPUT_ERROR = "Invalid input: %s is expected to be %s."
Errors.TYPE_ERROR = "Type error: %s is expected to be of type %s."
Errors.UNKNOWN_ERROR = "An unknown error occurred."

local Validators = require(script.Parent.Validators)
local function createErrorHandler(errorType)
	return function(funcName, paramName, expectedType, minValue)
		local errorMessage = errorType == "INVALID_INPUT_ERROR" and Errors.INVALID_INPUT_ERROR or Errors.TYPE_ERROR
		local formattedMessage = string.format(errorMessage, paramName, expectedType)
		error(string.format("%s in function %s", formattedMessage, funcName), 2)
	end
end
local errorHandlers = {
	handleInvalidInputError = createErrorHandler("INVALID_INPUT_ERROR"),
	handleTypeError = createErrorHandler("TYPE_ERROR"),
	handleUnknownError = function()
		error(Errors.UNKNOWN_ERROR, 2)
	end
}
local errorMeta = {
	__index = function(_, key)
		local handler = errorHandlers[key]
		if handler then
			return function(...)
				handler(...)
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
return setmetatable({}, errorMeta)