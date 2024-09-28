local Flux = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/fluxlib.txt"))()

local win = Flux:Window("Auto Cursed Dual Katana", "Baseplate", Color3.fromRGB(255, 110, 48), Enum.KeyCode.LeftControl)
local tab = win:Tab("Auto Farm", "http://www.roblox.com/asset/?id=6023426915")

tab:Label("Auto Cursed Dual Katana Script")

tab:Button("Start Auto Cursed Dual Katana", "Automatically farms Cursed Dual Katana.", function()
    getgenv().AutoCDK = true
    
    local function AutoCDK()
        local Cursed, DoorProgress = WaitPart(Map, "Turtle", "Cursed")

        local function MasterySwords()
            local TushitaM, YamaM = ItemMastery("Tushita"), ItemMastery("Yama")

            if TushitaM and TushitaM < 350 then
                if not VerifyTool("Tushita") then
                    FireRemote("LoadItem", "Tushita")
                end
            elseif YamaM and YamaM < 350 then
                if not VerifyTool("Yama") then
                    FireRemote("LoadItem", "Yama")
                end
            else
                return false
            end
            EquipToolTip("Sword")

            local Enemie = GetEnemies({"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"})
            if Enemie then
                PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos)
                pcall(function() ActiveHaki() BringNPC(Enemie, true) end)
            else
                PlayerTP(CFrame.new(-9513, 164, 5786))
            end
            return true
        end

        local function IndentifyQuest()
            if VerifyItem("Cursed Dual Katana") then return {"Finished"} end
            if MasterySwords() then return {"MasterySwords"} end

            local Door = Cursed:FindFirstChild("Breakable")
            if Door and Door.CanCollide then
                local Prog = FireRemote("CDKQuest", "OpenDoor")
                if type(Prog) == "string" and Prog == "opened" then
                    return {"OpenDoor"}
                else
                    Door.CanCollide = false
                end
            end

            local Count = GetMaterial("Alucard Fragment")
            if Count == 6 then
                return {"FinalQuest"}
            elseif Count == 0 then
                FireRemote("CDKQuest", "Progress", "Evil")
                FireRemote("CDKQuest", "StartTrial", "Evil")
                return {"Yama", 1}
            elseif Map:FindFirstChild("HellDimension") then
                return {"Yama", 3}
            elseif Map:FindFirstChild("HeavenlyDimension") then
                return {"Tushita", 3}
            elseif Player:FindFirstChild("QuestHaze") then
                return {"Yama", 2}
            end

            local Progress = FireRemote("CDKQuest", "Progress")
            local Good = Progress.Good
            local Evil = Progress.Evil

            if Evil and Evil >= 0 and Evil < 3 then
                FireRemote("CDKQuest", "Progress", "Evil")
                FireRemote("CDKQuest", "StartTrial", "Evil")
                if Evil == 0 then
                    return {"Yama", 1}
                elseif Evil == 1 then
                    return {"Yama", 2}
                elseif Evil == 2 then
                    return {"Yama", 3}
                end
            elseif Good and Good >= 0 and Good < 3 then
                FireRemote("CDKQuest", "Progress", "Good")
                FireRemote("CDKQuest", "StartTrial", "Good")
                if Good == 0 then
                    return {"Tushita", 1}
                elseif Good == 1 then
                    return {"Tushita", 2}
                elseif Good == 2 then
                    return {"Tushita", 3}
                end
            end
        end

        task.spawn(function()
            while getgenv().AutoCDK do task.wait()
                local Quest = IndentifyQuest()
                if Quest then
                    getgenv().CurrentQuest = Quest
                end
            end
        end)

        while getgenv().AutoCDK do task.wait()
            if MyLevel.Value >= 2200 then
                local Quest = getgenv().CurrentQuest
                if Quest then
                    if Quest[1] == "Finished" then
                        getgenv().AutoCDK = false
                    elseif Quest[1] == "MasterySwords" then
                        getgenv().CursedDualKatana = true
                    elseif Quest[1] == "OpenDoor" then
                        local plrPP = Player.Character and Player.Character.PrimaryPart
                        if plrPP and (plrPP.Position - Vector3.new(-12131, 578, -6707)).Magnitude < 5 then
                            FireRemote("CDKQuest", "OpenDoor")
                        else
                            PlayerTP(CFrame.new(-12131, 578, -6707))
                            getgenv().CursedDualKatana = true
                        end
                    elseif Quest[1] == "FinalQuest" then
                        if not VerifyTool("Tushita") and not VerifyTool("Yama") then
                            FireRemote("LoadItem", "Tushita")
                        else
                            if VerifyNPC("Cursed Skeleton Boss") then
                                local Enemie = GetEnemies({"Cursed Skeleton Boss"})
                                if Enemie and Enemie:FindFirstChild("HumanoidRootPart") then
                                    PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos)
                                    pcall(function() ActiveHaki() end)
                                end
                                EquipToolTip("Sword")
                            end
                        end
                    end
                end
            else
                getgenv().CursedDualKatana = false
            end
        end
    end

    AutoCDK() -- AutoCDK функцийг дуудаж эхлүүлнэ
end)

tab:Toggle("Auto-Farm Coins", "Automatically collects coins for you!", function(t)
    print(t)
end)

tab:Slider("Walkspeed", "Makes you faster.", 0, 100, 16, function(t)
    print(t)
end)

tab:Dropdown("Part to aim at", {"Torso", "Head", "Penis"}, function(t)
    print(t)
end)

tab:Colorpicker("ESP Color", Color3.fromRGB(255, 1, 1), function(t)
    print(t)
end)

tab:Textbox("Gun Power", "This textbox changes your gun power, so you can kill everyone faster and easier.", true, function(t)
    print(t)
end)

tab:Bind("Kill Bind", Enum.KeyCode.Q, function()
    print("Killed a random person!")
end)
