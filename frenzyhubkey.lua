-- Load Hydra Hub Library
local HydraHub = loadstring(game:HttpGet('https://raw.githubusercontent.com/StepBroFurious/Script/main/HydraHubUi.lua'))()

-- Key and expiration variables
_G.KeyInput = "string"
local savedKeyPath = "HydraConfig/KeyExpiration"

-- Function to save expiration time
local function SaveKeyExpiration(expirationTime)
    writefile(savedKeyPath, tostring(expirationTime))
end

-- Function to load expiration time
local function LoadKeyExpiration()
    if isfile(savedKeyPath) then
        return tonumber(readfile(savedKeyPath))
    else
        return nil
    end
end

-- Check if subscription is still active
local function IsSubscriptionActive()
    local expirationTime = LoadKeyExpiration()
    if expirationTime then
        return os.time() < expirationTime
    else
        return false
    end
end

-- Convert date to timestamp
local function ConvertToTimestamp(dateString)
    local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
    local year, month, day, hour, minute, second = dateString:match(pattern)
    return os.time({
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day),
        hour = tonumber(hour),
        min = tonumber(minute),
        sec = tonumber(second)
    })
end

-- Fetch keys from Pastebin
local function GetKeysFromPastebin()
    local keyUrl = 'https://pastebin.com/raw/B9h0fG6e'  -- Pastebin link
    local response = game:HttpGet(keyUrl)
    local keys = {}
    
    for line in response:gmatch("[^\r\n]+") do -- Parse keys and expiration dates
        local key, expiration = line:match("([^|]+)|([^|]+)")
        if key and expiration then
            table.insert(keys, {key = key, expiration = expiration})
        end
    end
    return keys
end

-- Validate the key
local function IsKeyValid(enteredKey)
    local keys = GetKeysFromPastebin()
    for _, data in pairs(keys) do
        local key = data.key
        local expirationDate = data.expiration
        local expirationTime = ConvertToTimestamp(expirationDate)

        -- Return true if key is valid and not expired
        if enteredKey == key and os.time() < expirationTime then
            return true, expirationTime
        end
    end
    return false, nil
end

-- Load Hydra Hub if key is valid
function LoadHydraHub()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/StepBroFurious/Script/main/HydraHubUi.lua"))() -- Load Hydra Hub
end

-- Create Hydra Hub window
local Window = HydraHub:CreateWindow({
    Name = "Hydra Hub Key System",
    LoadingTitle = "Hydra Hub",
    LoadingSubtitle = "Please enter your key...",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "HydraHubConfig"
    },
    KeySystem = true
})

-- Create "Key" tab
local Tab = Window:CreateTab("Key Verification", 4483345998)

-- Input for key entry
Tab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "Enter your key here",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        _G.KeyInput = Value -- Store entered key
    end
})

-- Button to check key
Tab:CreateButton({
    Name = "Check Key",
    Callback = function()
        if IsSubscriptionActive() then
            HydraHub:Notify({
                Title = "Subscription Active",
                Content = "Your subscription is still active.",
                Duration = 5,
                Image = 4483345998
            })
        else
            local isValid, expirationTime = IsKeyValid(_G.KeyInput) -- Validate the key
            if isValid then
                SaveKeyExpiration(expirationTime) -- Save expiration
                HydraHub:Notify({
                    Title = "Key Accepted",
                    Content = "Subscription active until " .. os.date("%Y-%m-%d %H:%M:%S", expirationTime),
                    Duration = 5,
                    Image = 4483345998
                })
                wait(1)
                HydraHub:Destroy() -- Destroy current UI
                LoadHydraHub() -- Load Hydra Hub
            else
                HydraHub:Notify({
                    Title = "Invalid Key",
                    Content = "The key is either incorrect or expired.",
                    Duration = 5,
                    Image = 4483345998
                })
            end
        end
    end
})

HydraHub:LoadConfiguration()
