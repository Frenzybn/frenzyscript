local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Түлхүүр болон хугацаа хадгалах хувьсагчууд
_G.KeyInput = "string"
local savedKeyPath = "SubscriptionConfig/KeyExpiration"

-- Түлхүүрийн хугацааг хадгалах функц
local function SaveKeyExpiration(expirationTime)
    writefile(savedKeyPath, tostring(expirationTime))
end

-- Түлхүүрийн хугацааг ачаалах функц
local function LoadKeyExpiration()
    if isfile(savedKeyPath) then
        return tonumber(readfile(savedKeyPath))
    else
        return nil
    end
end

-- Түлхүүрийн хугацаа хүчинтэй эсэхийг шалгах функц
local function IsSubscriptionActive()
    local expirationTime = LoadKeyExpiration()
    if expirationTime then
        return os.time() < expirationTime
    else
        return false
    end
end

-- Date-г timestamp болгон хувиргах функц
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

-- Pastebin дээрх түлхүүр болон хугацааг татах функц
local function GetKeysFromPastebin()
    local keyUrl = 'https://pastebin.com/raw/B9h0fG6e'  -- Таны оруулсан Pastebin линк
    local response = game:HttpGet(keyUrl)
    local keys = {}
    
    for line in response:gmatch("[^\r\n]+") do  -- Түлхүүрүүдийг newline-аар салгаж массив болгон хадгалах
        local key, expiration = line:match("([^|]+)|([^|]+)")
        if key and expiration then
            table.insert(keys, {key = key, expiration = expiration})
        end
    end
    return keys
end

-- Түлхүүрийг шалгах функц
local function IsKeyValid(enteredKey)
    local keys = GetKeysFromPastebin()
    for _, data in pairs(keys) do
        local key = data.key
        local expirationDate = data.expiration
        local expirationTime = ConvertToTimestamp(expirationDate)

        -- Хэрэв түлхүүр зөв бөгөөд хугацаа дуусаагүй бол
        if enteredKey == key and os.time() < expirationTime then
            return true, expirationTime
        end
    end
    return false, nil
end

-- Зөв түлхүүр байвал ачааллах функц
function MakeScriptHub()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Frenzybn/frenzyscript/refs/heads/main/FrenzyHub.lua"))()  -- Таны оруулсан скрипт
end

-- Rayfield цонх үүсгэх
local Window = Rayfield:CreateWindow({
   Name = "BloxFruit Script under 🚧",
   LoadingTitle = "All Devs Hub",
   LoadingSubtitle = "by All Devs",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "AllDevs"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

-- "Key" табыг үүсгэх
local Tab = Window:CreateTab("Key System", 4483345998)

-- Textbox хэрэглэгчийн түлхүүрийг оруулахад
Tab:CreateInput({
    Name = "Enter key",
    PlaceholderText = "Enter your key here",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        _G.KeyInput = Value
    end
})

-- Түлхүүр шалгах товч
Tab:CreateButton({
    Name = "Check Key",
    Callback = function()
        if IsSubscriptionActive() then
            Rayfield:Notify({
                Title = "Subscription Active",
                Content = "Your subscription is still active.",
                Duration = 5,
                Image = 4483345998
            })
        else
            local isValid, expirationTime = IsKeyValid(_G.KeyInput)  -- Түлхүүр зөв эсэхийг шалгах
            if isValid then
                SaveKeyExpiration(expirationTime)  -- Түлхүүрийн хугацааг хадгалах
                MakeScriptHub()  -- Зөв түлхүүрийг оруулсан тул скриптийг ачаална
                Rayfield:Notify({
                    Title = "Key Accepted",
                    Content = "Your subscription is now active until " .. os.date("%Y-%m-%d %H:%M:%S", expirationTime),
                    Duration = 5,
                    Image = 4483345998
                })
            else
                Rayfield:Notify({
                    Title = "Invalid Key",
                    Content = "The key you entered is either incorrect or expired.",
                    Duration = 5,
                    Image = 4483345998
                })
            end
        end
    end
})

Rayfield:LoadConfiguration()
