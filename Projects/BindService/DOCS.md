# BindService Documentation

## Introduction
BindService is a module designed to simplify input handling in Roblox games. It provides functions to create, manage, and customize input bindings, allowing developers to easily map user inputs to specific actions in their games.

## Installation
To use BindService in your Roblox game, follow these steps:
1. Insert the BindService module script into your game's hierarchy.
2. Require the BindService module in your scripts using `require(script.Parent.BindService)`.

## Functions

### Bindings

#### `BindService.BindKeyPresses(name: string, callback: function, debounce: number, ...keys: Enum.KeyCode)`
Binds a callback function to a combination of keyboard keys.

- `name`: A unique identifier for the binding.
- `callback`: The function to be called when the key combination is pressed.
- `debounce`: The minimum time (in seconds) between each activation of the callback.
- `...keys`: A list of `Enum.KeyCode` values representing the keys to be pressed.

#### `BindService.BindMouseButtonPresses(name: string, callback: function, debounce: number, attributes: table, ...mouseButtons: Enum.UserInputType)`
Binds a callback function to a combination of mouse buttons.

- `name`: A unique identifier for the binding.
- `callback`: The function to be called when the mouse button combination is pressed.
- `debounce`: The minimum time (in seconds) between each activation of the callback.
- `attributes`: Additional attributes for the binding.
- `...mouseButtons`: A list of `Enum.UserInputType` values representing the mouse buttons to be pressed.

#### `BindService.BindInputEvent(name: string, callback: function, debounce: number, inputType: Enum.UserInputType)`
Binds a callback function to a specific type of user input event.

- `name`: A unique identifier for the binding.
- `callback`: The function to be called when the specified input event occurs.
- `debounce`: The minimum time (in seconds) between each activation of the callback.
- `inputType`: The type of user input event to listen for (e.g., `Enum.UserInputType.MouseMovement`).

#### `BindService.BindInputEnded(name: string, callback: function, debounce: number, inputType: Enum.UserInputType)`
Binds a callback function to a specific type of user input ending event.

- `name`: A unique identifier for the binding.
- `callback`: The function to be called when the specified input ending event occurs.
- `debounce`: The minimum time (in seconds) between each activation of the callback.
- `inputType`: The type of user input event to listen for (e.g., `Enum.UserInputType.MouseButton1`).

#### `BindService.SetInputBindings(bindings: table)`
Sets multiple input bindings at once.

- `bindings`: A table containing multiple bindings, where the keys are the binding names and the values are tables containing the binding details.

### Attributes

#### `BindService.AddBindAttribute(name: string, attributeName: any, attributeValue: any)`
Adds an attribute to a specific input binding.

- `name`: The name of the input binding.
- `attributeName`: The name of the attribute to add.
- `attributeValue`: The value of the attribute to add.

#### `BindService.SetBindAttribute(name: string, attributeName: any, attributeValue: any)`
Sets the value of an attribute for a specific input binding.

- `name`: The name of the input binding.
- `attributeName`: The name of the attribute to set.
- `attributeValue`: The new value of the attribute.

#### `BindService.GetBindAttribute(name: string, attributeName: any): any`
Gets the value of a specific attribute for a given input binding.

- `name`: The name of the input binding.
- `attributeName`: The name of the attribute to retrieve.

#### `BindService.RemoveBindAttribute(name: string, attributeName: any)`
Removes a specific attribute from an input binding.

- `name`: The name of the input binding.
- `attributeName`: The name of the attribute to remove.

### Unbinding

#### `BindService.Unbind(name: string)`
Unbinds a previously bound input binding.

- `name`: The name of the input binding to unbind.

#### `BindService.UnbindAll()`
Unbinds all input bindings.

### Listening

#### `BindService.ListenToInput(callback: function)`
Starts listening for user input events and calls the provided callback function when an input event occurs.

- `callback`: The function to be called when an input event occurs.

### Input Profiles

#### `BindService.SaveInputProfile(profileName: string, bindings: table)`
Saves a set of input bindings as a named input profile.

- `profileName`: The name of the input profile to save.
- `bindings`: A table containing the input bindings to be saved.

#### `BindService.LoadInputProfile(profileName: string): table`
Loads a previously saved input profile.

- `profileName`: The name of the input profile to load.

#### `BindService.DeleteInputProfile(profileName: string)`
Deletes a previously saved input profile.

- `profileName`: The name of the input profile to delete.

### Input Filtering

#### `BindService.AddInputFilter(inputType: Enum.UserInputType, filterFunction: function)`
Adds a filter function to restrict certain types of user inputs.

- `inputType`: The type of user input to filter.
- `filterFunction`: The function used to determine if the input is allowed.

#### `BindService.RemoveInputFilter(inputType: Enum.UserInputType)`
Removes a filter function for a specific type of user input.

- `inputType`: The type of user input to remove the filter from.

#### `BindService.IsInputAllowed(inputType: Enum.UserInputType): boolean`
Checks if a specific type of user input is allowed based on the registered filter functions.

- `inputType`: The type of user input to check.

### Input Mapping

#### `BindService.AddInputMapping(inputType: Enum.UserInputType, mappedInputType: Enum.UserInputType)`
Maps one input type to another, allowing for custom input remapping.

- `inputType`: The original input type to be mapped.
- `mappedInputType`: The input type to map to.

#### `BindService.RemoveInputMapping(inputType: Enum.UserInputType)`
Removes a custom input mapping for a specific input type.

- `inputType`: The original input type to remove the mapping from.

#### `BindService.GetMappedInput(inputType: Enum.UserInputType): Enum.UserInputType`
Gets the mapped input type for a specific input type.

- `inputType`: The original input type to retrieve the mapped input for.

## Usage Example
```lua
local BindService = require(game:GetService("ServerScriptService").BindService)

-- Define a callback function
local function MoveForward()
    -- Move the player forward
end

-- Bind the "W" key to the MoveForward function
BindService.BindKeyPresses("MoveForward", MoveForward, 0.5, Enum.KeyCode.W)
```

## Feel free to adjust the documentation according to your specific module's implementation and requirements.