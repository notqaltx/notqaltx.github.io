-- Features Module
local Features = {}
local uis = game:GetService("UserInputService")
local keystrokes = require(script.Keystrokes)

local inputFilters, inputMappings, inputProfiles = {}, {}, {}
local inputFeaturesMeta = {
	inputFilters = {
		__index = inputFilters,
		__newindex = function(_, inputType, filterFunction)
			inputFilters[inputType] = filterFunction
		end
	},
	inputMappings = {
		__index = inputMappings,
		__newindex = function(_, inputType, mappedInputType)
			inputMappings[inputType] = mappedInputType
		end
	},
	inputProfiles = {
		__index = inputProfiles,
		__newindex = function(_, profileName, bindings)
			inputProfiles[profileName] = bindings
		end
	},
	ListenForInput = function() keystrokes.ListenForInput() end
	--StopListening = function(inputConnection)
	--	keystrokes.StopListening(inputConnection)
	--end
}

-- Input Filtering
function Features.AddInputFilter(inputType, filterFunction)
	rawset(inputFilters, inputType, filterFunction)
end

function Features.RemoveInputFilter(inputType)
	inputFilters[inputType] = nil
end

function Features.IsInputAllowed(inputType)
	local filter = inputFilters[inputType]
	if filter then
		return filter()
	else
		return true
	end
end

-- Input Mapping
function Features.AddInputMapping(inputType, mappedInputType)
	rawset(inputMappings, inputType, mappedInputType)
end

function Features.RemoveInputMapping(inputType)
	inputMappings[inputType] = nil
end

function Features.GetMappedInput(inputType)
	return inputMappings[inputType] or inputType
end

-- Input Profiles
function Features.SaveInputProfile(profileName, bindings)
	rawset(inputProfiles, profileName, bindings)
end

function Features.LoadInputProfile(profileName)
	return inputProfiles[profileName]
end

function Features.DeleteInputProfile(profileName)
	inputProfiles[profileName] = nil
end

local featuresMeta = {
	__index = function(self, key)
		return inputFeaturesMeta[key]
	end,
	__newindex = function()
		error("Attempt to modify read-only table")
	end
}

return setmetatable(Features, featuresMeta)