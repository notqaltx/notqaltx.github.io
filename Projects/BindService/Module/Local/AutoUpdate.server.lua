local HTTPService = game:GetService("HttpService")

local settings = {
	AutoUpdate = {
		IsAuto = true,
		UpdateTime = 360
	},
	LocalVersion = "v0.2"
}
function fetchLatestReleaseVersion(owner, repo)
	local url = string.format("https://api.github.com/repos/%s/%s/releases/latest", owner, repo)
	local success, result = pcall(function()
		return HTTPService:GetAsync(url, true)
	end)
	if success then
		local jsonData = HTTPService:JSONDecode(result)
		if jsonData and jsonData.tag_name then
			return jsonData.tag_name
		else
			warn("Failed to parse JSON data from GitHub response")
			return nil
		end
	else
		warn(string.format("Failed to fetch latest release version: %s\
			If BindService contains not in Server-Side Service (ex. ServerScriptService, Workspace), that it mostly like won't work.", result))
		return nil
	end
end
local function autoUpdate()
	local latestVersion = fetchLatestReleaseVersion("notqaltx", "notqaltx.github.io")
	if latestVersion ~= settings.LocalVersion then
		return warn(string.format("BindService Update Available!\
			Local Version: %s\
			Latest Version: %s", settings.LocalVersion, latestVersion))
	else
		warn("BindService is up to date.")
		return true
	end
end
spawn(function()
	while task.wait(settings.AutoUpdate.UpdateTime) do autoUpdate() end
end)