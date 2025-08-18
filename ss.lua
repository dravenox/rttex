local RS=game:GetService("ReplicatedStorage")
local P=game:GetService("Players").LocalPlayer
local GE=RS:WaitForChild("GameEvents")
local Notif=GE:WaitForChild("Notification")
if typeof(getconnections)=="function" then for _,c in ipairs(getconnections(Notif.OnClientEvent)) do pcall(function() c:Disconnect() end) end end
Notif.OnClientEvent:Connect(function(m) m=tostring(m):lower(); if m:find("not an ingredient") or m:find("cant cook") or m:find("pending trade") then return end end)

local Cook=GE:WaitForChild("CookingPotService_RE")
local function hum() local ch=P.Character or P.CharacterAdded:Wait(); return ch:WaitForChild("Humanoid") end
local function wanted(n) n=n:lower(); return (n:find("pepper",1,true) or n:find("corn",1,true)) and not n:find("corndog") end
local function pick() local bp=P:WaitForChild("Backpack"); local t={} for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") and wanted(v.Name) then t[#t+1]=v end end return (#t>0) and t[math.random(#t)] or nil end

local RUN=true
while RUN do
    local h=hum(); local t=pick()
    if t then
        h:UnequipTools(); task.wait(0.03)
        t.Parent=P.Backpack; task.wait()
        h:EquipTool(t); task.wait(0.10)
        Cook:FireServer("SubmitHeldPlant","OLD_KITCHEN_COOKING_EVENT"); task.wait(0.15)
        Cook:FireServer("CookBest","OLD_KITCHEN_COOKING_EVENT")
    else task.wait(0.15) end
    task.wait(0.30)
end
