local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Subscription Key System", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "SubscriptionConfig",  
    IntroText = "Loading lionstarter.dll..."
})

OrionLib:MakeNotification({
	Name = "lionware notifier",
	Content = "lionware.exe has been loaded.",
	Image = "rbxassetid://4483345998",
	Time = 3
})

_G.Key = "LION4ZP"  -- Таны зөв түлхүүр
_G.KeyInput = "string"
_G.SubscriptionDuration = 86400 -- 1 өдөр (секундээр)

local savedKeyPath = "SubscriptionConfig/KeyExpiration"

local function SaveKeyExpiration(expirationTime)
    writefile(savedKeyPath, tostring(expirationTime))
end

local function LoadKeyExpiration()
    if isfile(savedKeyPath) then
        return tonumber(readfile(savedKeyPath))
    else
        return nil
    end
end

local function IsSubscriptionActive()
    local expirationTime = LoadKeyExpiration()
    if expirationTime then
        return os.time() < expirationTime
    else
        return false
    end
end

function MakeScriptHub()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Frenzybn/frenzyscript/refs/heads/main/FrenzyHub.lua"))() 
end

function CorrectKeyNotification()
    OrionLib:MakeNotification({
        Name = "Correct Key!",
        Content = "lionware.exe has been loaded.",
        Image = "rbxassetid://4483345998",
        Time = 3
    })
end

function IncorrectKeyNotification()
    OrionLib:MakeNotification({
        Name = "Incorrect Key!",
        Content = "lionware.exe has not been loaded.",
        Image = "rbxassetid://4483345998",
        Time = 3
    })
end

local Tab = Window:MakeTab({
	Name = "Key",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddTextbox({
	Name = "Enter key",
	Default = "",
	TextDisappear = false,  -- Оруулсан текстийг үлдээх
	Callback = function(Value)
		_G.KeyInput = Value
	end	  
})

Tab:AddButton({
	Name = "Check Key",
	Callback = function()
        if IsSubscriptionActive() then
            MakeScriptHub()
            CorrectKeyNotification()
        elseif _G.KeyInput == _G.Key then  
            local expirationTime = os.time() + _G.SubscriptionDuration  
            SaveKeyExpiration(expirationTime)  
            MakeScriptHub()  
            CorrectKeyNotification()  
        else
            IncorrectKeyNotification()  
        end
  	end    
})

OrionLib:Init()
