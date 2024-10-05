-- Load your custom hub library (you can host it on GitHub or another platform)
local CustomHub =  loadstring(game:HttpGet("https://raw.githubusercontent.com/Frenzybn/frenzyscript/refs/heads/main/FrenzyHubUi"))()

-- Key system configuration
_G.KeyInput = "string"
local savedKeyPath = "CustomHubConfig/KeyExpiration"

-- Function to save the expiration time of the key
local function SaveKeyExpiration(expirationTime)
    writefile(savedKeyPath, tostring(expirationTime))
end

-- Function to load the expiration time of the key
local function LoadKeyExpiration()
    if isfile(savedKeyPath) then
        return tonumber(readfile(savedKeyPath))
    else
        return nil
    end
end

-- Function to check if the subscription is still active
local function IsSubscriptionActive()
    local expirationTime = LoadKeyExpiration()
    if expirationTime then
        return os.time() < expirationTime
    else
        return false
    end
end

-- Function to convert date to timestamp
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

-- Function to fetch keys from a Pastebin link
local function GetKeysFromPastebin()
    local keyUrl = 'https://pastebin.com/raw/B9h0fG6e'  -- Replace with your Pastebin link
    local response = game:HttpGet(keyUrl)
    local keys = {}

    for line in response:gmatch("[^\r\n]+") do -- Split keys and expiration dates
        local key, expiration = line:match("([^|]+)|([^|]+)")
        if key and expiration then
            table.insert(keys, {key = key, expiration = expiration})
        end
    end
    return keys
end

-- Function to check if the entered key is valid
local function IsKeyValid(enteredKey)
    local keys = GetKeysFromPastebin()
    for _, data in pairs(keys) do
        local key = data.key
        local expirationDate = data.expiration
        local expirationTime = ConvertToTimestamp(expirationDate)

        if enteredKey == key and os.time() < expirationTime then
            return true, expirationTime
        end
    end
    return false, nil
end

-- Function to load the main custom hub if the key is valid
function LoadCustomHub()
    -- Insert the logic to load your custom hub's main UI and features
    print("Loading Custom Hub...")
    -- Example: loading a custom feature
    CustomHub:InitializeFeatures()
end

-- Function to initialize custom hub features
function CustomHub:InitializeFeatures()
    -- Example of creating a feature tab in your custom hub
    print("Feature 1: Auto Farm Enabled")
    print("Feature 2: ESP Enabled")
    -- Add more features for your custom hub here
end

-- Custom UI window for key entry and verification
local Window = CustomHub:CreateWindow({
    Name = "Custom Hub Key System",
    LoadingTitle = "Welcome to Custom Hub",
    LoadingSubtitle = "Please enter your key to continue",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "CustomHubConfig"
    },
    KeySystem = true
})

-- Create a tab for key verification
local Tab = Window:CreateTab("Key Verification", 4483345998)

-- Input box for the key entry
Tab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "Enter your key",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        _G.KeyInput = Value -- Store the user's entered key
    end
})

-- Button to verify the key
Tab:CreateButton({
    Name = "Check Key",
    Callback = function()
        if IsSubscriptionActive() then
            CustomHub:Notify({
                Title = "Subscription Active",
                Content = "Your subscription is still active.",
                Duration = 5,
                Image = 4483345998
            })
        else
            local isValid, expirationTime = IsKeyValid(_G.KeyInput) -- Check if the key is valid
            if isValid then
                SaveKeyExpiration(expirationTime) -- Save the expiration time
                CustomHub:Notify({
                    Title = "Key Accepted",
                    Content = "Subscription active until " .. os.date("%Y-%m-%d %H:%M:%S", expirationTime),
                    Duration = 5,
                    Image = 4483345998
                })
                wait(1) -- Give some time before proceeding
                CustomHub:Destroy() -- Destroy the current window
                LoadCustomHub() -- Load the custom hub
            else
                CustomHub:Notify({
                    Title = "Invalid Key",
                    Content = "The key is either incorrect or expired.",
                    Duration = 5,
                    Image = 4483345998
                })
            end
        end
    end
})

CustomHub:LoadConfiguration()
