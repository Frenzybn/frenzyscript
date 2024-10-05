-- Load your custom hub library
local CustomHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Frenzybn/frenzyscript/refs/heads/main/FrenzyHubUi"))()

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
        return os.time() < expirationTime -- Check if current time is before expiration
    else
        return false
    end
end

-- Function to convert a date string into a timestamp
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
    local keyUrl = 'https://pastebin.com/raw/B9h0fG6e' -- Replace with your Pastebin link
    local response = game:HttpGet(keyUrl)
    local keys = {}

    for line in response:gmatch("[^\r\n]+") do -- Split keys and expiration dates from each line
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

        if enteredKey == key and os.time() < expirationTime then -- Check if key is valid and not expired
            return true, expirationTime
        end
    end
    return false, nil
end

-- Function to load the main custom hub if the key is valid
function LoadCustomHub()
    print("Loading Custom Hub...") -- Debug message for when the hub loads
    CustomHub:InitializeFeatures() -- Call to initialize features of your hub
end

-- Function to initialize custom hub features (Add more features here as necessary)
function CustomHub:InitializeFeatures()
    print("Feature 1: Auto Farm Enabled")
    print("Feature 2: ESP Enabled")
end

-- Зөв түлхүүр байвал ачааллах функц
function MakeScriptHub()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Frenzybn/frenzyscript/refs/heads/main/FrenzyHub.lua"))()  -- Load Frenzy Hub script
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
    KeySystem = true -- Enable key system
})

-- Create a tab for key verification
local Tab = Window:CreateTab("Key Verification", 4483345998) -- Add custom icon ID

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
        if IsSubscriptionActive() then -- If subscription is still active
            CustomHub:Notify({
                Title = "Subscription Active",
                Content = "Your subscription is still active.",
                Duration = 5,
                Image = 4483345998
            })
            MakeScriptHub() -- Load Frenzy Hub
        else
            local isValid, expirationTime = IsKeyValid(_G.KeyInput) -- Validate the entered key
            if isValid then
                SaveKeyExpiration(expirationTime) -- Save the expiration time
                CustomHub:Notify({
                    Title = "Key Accepted",
                    Content = "Subscription active until " .. os.date("%Y-%m-%d %H:%M:%S", expirationTime),
                    Duration = 5,
                    Image = 4483345998
                })
                wait(1) -- Wait before proceeding
                CustomHub:Destroy() -- Destroy the key input UI
                LoadCustomHub() -- Load the custom hub
                MakeScriptHub() -- Load Frenzy Hub
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

-- Load the configuration for the hub (any other configurations go here)
CustomHub:LoadConfiguration()
