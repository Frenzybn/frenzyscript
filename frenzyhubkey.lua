local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Key system", 
    HidePremium = false, 
    SaveConfig = true, 
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

-- Таны Pastebin-ээс скриптийг ачаалах хэсэг
function MakeScriptHub()
    loadstring(game:HttpGet("https://pastebin.com/raw/WjJ5GPt9"))()  -- Таны хийх ёстой Pastebin линк байна
end

-- Түлхүүр зөв үед мэдэгдэл гаргах функц
function CorrectKeyNotification()
    OrionLib:MakeNotification({
        Name = "Correct Key!",
        Content = "lionware.exe has been loaded.",
        Image = "rbxassetid://4483345998",
        Time = 3
    })
end

-- Түлхүүр буруу үед мэдэгдэл гаргах функц
function IncorrectKeyNotification()
    OrionLib:MakeNotification({
        Name = "Incorrect Key!",
        Content = "lionware.exe has not been loaded.",
        Image = "rbxassetid://4483345998",
        Time = 3
    })
end

-- "Key" табыг үүсгэх
local Tab = Window:MakeTab({
	Name = "Key",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Хэрэглэгчийн түлхүүр оруулах Textbox
Tab:AddTextbox({
	Name = "Enter key",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
		_G.KeyInput = Value  -- Хэрэглэгчийн оруулсан түлхүүрийг хадгална
	end	  
})

-- Түлхүүр шалгах товчлуур
Tab:AddButton({
	Name = "Check Key",
	Callback = function()
      	if _G.KeyInput == _G.Key then  -- Хэрэв оруулсан түлхүүр зөв байвал
            MakeScriptHub()  -- Скрипт ачаална
            CorrectKeyNotification()  -- Зөв түлхүүрийн мэдэгдэл гаргана
        else
            IncorrectKeyNotification()  -- Буруу түлхүүрийн мэдэгдэл гаргана
        end
  	end    
})

-- Скриптийг эхлүүлэх
OrionLib:Init()
