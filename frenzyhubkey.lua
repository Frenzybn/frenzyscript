local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/ionlyusegithubformcmods/1-Line-Scripts/main/Mobile%20Friendly%20Orion')))()
local Player = game.Players.LocalPlayer -- This Will Reveal The Player Name

local Window = OrionLib:MakeWindow({
	Name = "Subscription System with 1-Day Key",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "OrionTest",
	IntroText = "Loading Script..."
}) -- This Will Load The Script Hub

-- Function to get the correct key and expiration date from Pastebin
local function getKeyDataFromPastebin()
	local keyUrl = 'https://pastebin.com/B9h0fG6e' -- Replace with your Pastebin raw URL
	local response = game:HttpGet(keyUrl)
	
	-- Split the response into key and expiration date
	local key, expiration = response:match("([^|]+)|([^|]+)")
	return key, expiration
end

-- Function to check if the key is still valid based on expiration date
local function isKeyExpired(expirationDate)
	local currentTime = os.time()
	local expirationTime = os.time({
		year = tonumber(expirationDate:sub(1,4)),
		month = tonumber(expirationDate:sub(6,7)),
		day = tonumber(expirationDate:sub(9,10)),
		hour = tonumber(expirationDate:sub(12,13)),
		min = tonumber(expirationDate:sub(15,16)),
		sec = tonumber(expirationDate:sub(18,19))
	})
	return currentTime > expirationTime
end

-- Fetch the correct key and its expiration date from Pastebin
getgenv().Key, getgenv().ExpirationDate = getKeyDataFromPastebin()
getgenv().KeyInput = "" -- Require for the key to work

local Tab = Window:MakeTab({
	Name = "Key",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
}) -- Making A Tab

-- Textbox for entering the key
Tab:AddTextbox({
	Name = "Enter Key",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		getgenv().KeyInput = Value
	end
})

-- Button to check the key
Tab:AddButton({
	Name = "Check Key",
	Callback = function()
		if getgenv().KeyInput == getgenv().Key then
			if isKeyExpired(getgenv().ExpirationDate) then
				OrionLib:MakeNotification({
					Name = "Expired Key!",
					Content = "The key you entered has expired.",
					Image = "rbxassetid://4483345998",
					Time = 5
				})
			else
				OrionLib:MakeNotification({
					Name = "Checking Key",
					Content = "Checking the key you entered...",
					Image = "rbxassetid://4483345998",
					Time = 5
				})
				wait(2)
				OrionLib:MakeNotification({
					Name = "Correct Key!",
					Content = "The key you entered is correct.",
					Image = "rbxassetid://4483345998",
					Time = 5
				})
				wait(1)
				OrionLib:Destroy()
				wait(.3)
				MakeScriptHub()
			end
		else
			OrionLib:MakeNotification({
				Name = "Incorrect Key!",
				Content = "The key you entered is incorrect.",
				Image = "rbxassetid://4483345998",
				Time = 5
			})
		end
	end
})

OrionLib:Init() -- Require If The Script Is Done
