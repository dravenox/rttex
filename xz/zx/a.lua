type table = { [any]: any }

_G.Configuration = { 
    Enabled = true, 
  	WebhookSeed = "https://discord.com/api/webhooks/1390623947523100743/1ido88uuUAq1UCxhdnrt0yJjlaQxIvkuN9__diUEXsNK6Hdp-ejiQ2pZCwshsg4pH8Xy",
  	WebhookGear = "https://discord.com/api/webhooks/1390624001289879585/1xR0HQONX64CePQ84l4kIyC2zljalqFJk5k0rosAbmD2R7LE9UyX6ewNFDuI8nxw_ueb",
  	WebhookEgg = "https://discord.com/api/webhooks/1390020865357381783/HjYhbZ8EKGVphAdkBmUCwaTLp9uGDq_55anWyKpGik0ViQA7jW5_i3hLc32R3QrDQ6NO",
  	WebhookCosmetic = "https://discord.com/api/webhooks/1390020880469459016/85ivQJuAg3Efzve5NQ0HBp1Jzp0Rsj2pp90HFSijqOyPJsw--sFD6ySGAEgBQqX9IiQW",
  	WebhookWeather = "https://discord.com/api/webhooks/1390020948144558200/UTH3Cc8_zL8yNBAi66UN95E3rBB9hNrUsLIUgofNCCO5b5d6hbuxw4M-x-JOPsdKvcgW",
  	WebhookEvent = "https://discord.com/api/webhooks/1390020903752175829/-uLOzgHhsEFzCKYMGMxo4UNo56Ol9c3ujER2Z01sj6teHM2qKIQRtBBqar28b6M1fl51",
  	WeatherReporting = true,
    AntiAFK = true, 
    RenderingEnabled = true, 
    DebugMode = false,
    AlertLayouts = { 
        Weather = { 
            EmbedColor = Color3.fromRGB(42, 109, 255) 
        }, 
        SeedsAndGears = { 
            EmbedColor = Color3.fromRGB(56, 238, 23), 
            Layout = { 
                ["ROOT/SeedStock/Stocks"] = "• Seed Stock", 
                ["ROOT/GearStock/Stocks"] = "• Gear Stock" 
            } 
        }, 
        EventShop = { 
            EmbedColor = Color3.fromRGB(212, 42, 255), 
            Layout = { 
                ["ROOT/EventShopStock/Stocks"] = "• Summer Stock" 
            } 
        }, 
        Eggs = { 
            EmbedColor = Color3.fromRGB(251, 255, 14), 
            Layout = { 
                ["ROOT/PetEggStock/Stocks"] = "• Egg Stock"
            } 
        }, 
        CosmeticStock = { 
            EmbedColor = Color3.fromRGB(255, 106, 42), 
            Layout = { 
                ["ROOT/CosmeticStock/ItemStocks"] = "• Cosmetic Stock" 
            } 
        } 
    } 
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local VirtualUser = cloneref and cloneref(game:GetService("VirtualUser")) or game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local DataStream = ReplicatedStorage.GameEvents.DataStream
local WeatherEventStarted = ReplicatedStorage.GameEvents.WeatherEventStarted

local LocalPlayer = Players.LocalPlayer

local GoodItems = {
    ["Sugar Apple"] = "...",
    ["Loquat"] = "...",
    ["Pineapple"] = "...",
    ["Kiwi"] = "...",
    ["Advanced Sprinkler"] = "...",
    ["Master Sprinkler"] = "...",
    ["Godly Sprinkler"] = "...",
    ["Harvest Tool"] = "...",
    ["Magnifying Glass"] = "...",
    ["Friendship Pot"] = "..."
}

local ItemEmojis = {
    ['Anti Bee Egg'] = '<:antibeeegg:1392913362257444985>',
    ['Bee Egg'] = '<:beeegg:1392913384894234814>',
    ['Bug Egg'] = '<:bugegg:1392913405912023180>',
    ['Common Egg'] = '<:commonegg:1392913215981223988>',
    ['Common Summer Egg'] = '<:commonsummeregg:1392913333379797154>',
    ['Dinosaur Egg'] = '',
    ['Exotic Bug Egg'] = '',
    ['Legendary Egg'] = '',
    ['Mythical Egg'] = '',
    ['Night Egg'] = '',
    ['Oasis Egg'] = '',
    ['Paradise Egg'] = '',
    ['Rare Egg'] = '',
    ['Rare Summer Egg'] = '',
    ['Uncommon Egg'] = '',
    
    ["Carrot"] = "🥕",
    ["Strawberry"] = "🍓",
    ["Blueberry"] = "🫐",
    ["Orange Tulip"] = "🌷",
    ["Tomato"] = "🍅",
    ["Daffodil"] = "🌼",
    ["Watermelon"] = "🍉",
    ["Pumpkin"] = "🎃",
    ["Apple"] = "🍎",
    ["Bamboo"] = "🎍",
    ["Coconut"] = "🥥",
    ["Cactus"] = "🌵",
	  ["Dragon Fruit"] = "🐲",
    ["Mango"] = "🥭",
    ["Grape"] = "🍇",
    ["Mushroom"] = "🍄",
    ["Pepper"] = "🌶️",
    ["Cacao"] = "🍫",
    ["Beanstalk"] = "🌱",
    ["Ember Lily"] = "🔥",
    ["Sugar Apple"] = "🍏",
    ["Burning Bud"] = "🌋",
    
    ["Basic Sprinkler"] = "💧",
    ["Advanced Sprinkler"] = "🌊",
    ["Godly Sprinkler"] = "🌀",
    ["Master Sprinkler"] = "🔱",
    ["Harvest Tool"] = "🔨",
    ["Magnifying Glass"] = "🔍",
    ["Friendship Pot"] = "🫖",
    ["Watering Can"] = "🪣",
    ["Shovel"] = "⛏️",
    ["Cleaning Spray"] = "🧽",
    ["Trowel"] = "🪠",
    ["Recall Wrench"] = "🔧",
    ["Favorite Tool"] = "🔖",
    
    ["Default"] = "📦"
}

local WeatherDatabase = { 
		["Rain"] = {
				description = "* Rain\n\n-# * __Effects__\n-# * Increases crop growth speed by 50%.\n-# * 50% chance to apply the Wet mutation.\n-# * Can combine with Chilled to create Frozen."
		},
	  ["Thunderstorm"] = {
	  		description = "* Thunderstorm\n\n-# * __Effects__\n-# * Increases growth speed by 50%.\n-# * 50% chance to apply Wet.\n-# * Lightning strikes can apply Shocked mutation."
	  },
	  ["Night"] = {
	  		description = "* Night\n\n-# * __Effects__\n-# * Chance to apply MoonLit.\n-# * 6 crops become Moonlit per night (once every 40 seconds over 4 minutes)."
	  },
	  ["Blood Moon"] = {
	  		description = "* Blood Moon\n\n-# * __Effects__\n-# * Gives crops a glowing red hue.\n-# * Chance to apply Bloodlit."
	  },
	  ["Meteor Shower"] = {
	  		description = "* Meteor Shower\n\n-# * __Effects__\n-# * Crops hit by meteors gain Celestial mutation."
	  },
	  ["Windy"] = {
	  		description = "* Windy\n\n-# * __Effects__\n-# * Crops have a chance to become Windstruck during the event."
	  },
	  ["Gale"] = {
	  		description = "* Gale\n\n-# * __Effects__\n-# * Crops have a much higher chance (higher than Windy) to become Windstruck during the event.\n-# * Players will be blown by strong wind currents."
	  },
	  ["Tornado"] = {
	  		description = "* Tornado\n\n-# * __Effects__\n-# * Gives crops the Twisted mutation."
	  },
	  ["Sandstorm"] = {
	  		description = "* Sandstorm\n\n-# * __Effects__\n-# * Gives the Sandy mutation.\n-# * Can combine with Sundried or Burnt to create Ceramic.\n-# * Can combine with Wet to create Clay."
	  },
	  ["Heatwave"] = {
	  		description = "* Heatwave\n\n-# * __Effects__\n-# * Applies the Sundried mutation to crops."
	  },
	  ["Sun God"] = {
	  		description = "* Sun God\n\n-# * __Effects__\n-# * Applies the Dawnbound mutation to 4+ sunflowers when presented in front of the Sun God.\n-# * Speeds up growth of Sunflower."
	  },
	  ["Tropical Rain"] = {
	  		description = "* Tropical Rain\n\n-# * __Effects__\n-# * Gives +50% Grow Speed, & crops the Drenched mutation."
	  },
	  ["Disco"] = {
	  		description = "* Disco\n\n-# * __Effects__\n-# * Turns the screen rainbow-colored.\n-# * Every second, fruits/crops have a chance to receive the Disco mutation.\n-# * Forces characters to dance with 1 of 3 default Roblox dances."
	  },
	  ["Jandel Storm"] = {
	  		description = "* Jandel Storm\n\n-# * __Effects__\n-# * Spawns lightning strikes at 4 strikes/second.\n-# * A gigantic Jandel entity appears at the start, which can be seen behind the gears, cosmetics, and eggs shop."
	  },
	  ["Laser Storm"] = {
	  		description = "* Laser Storm\n\n-# * __Effects__\n-# * Gives crops the Plasma mutation."
	  },
	  ["Monster Mash"] = {
	  		description = "* Monster Mash\n\n-# * __Effects__\n-# * DJ Jhai was shown behind the Pet Eggs and Gear Shop with a DJ booth, causing effects and forcing players to dance."
	  },
	  ["Black Hole"] = {
	  		description = "* Black Hole\n\n-# * __Effects__\n-# * Gives the plants Void Touched mutation.\n-# * Plants with this mutation have purple void portals as particles."
	  },
	  ["Floating Jandel"] = {
	  		description = "* Floating Jandel\n\n-# * __Effects__\n-# * Make crops have a chance to get Heavenly mutation."
	  },
	  ["Volcano"] = {
	  		description = "* Volcano\n\n-# * __Effects__\n-# * Has a likelihood to apply the Molten mutation. Can also be applied from the lava blocks that spew from the volcano."
	  },
	  ["Alien Invasion"] = {
	  		description = "* Alien Invasion\n\n-# * __Effects__\n-# * Has a chance to apply the Alienlike mutation.\n-# * Skybox changes to a light-blue, aliens spawn in the skybox"
	  },
	  ["Under The Sea"] = {
	  		description = "* Under The Sea\n\n-# * __Effects__\n-# * Has a chance to apply the Wet mutation.\n-# * The skybox changes to light-blue with Bikini Bottom effects, players can swim around the map by jumping."
	  },
	  ["Frost"] = {
	  		description = "* Frost\n\n-# * __Effects__\n-# * Increases growth speed by 50%.\n-# * Chance to apply Chilled.\n-# * Combines with Wet or Drenched to create Frozen.\n-# * Triggers shivering animation for players, along with a shivering sound effect."
	  },
	  ["Solar Flare"] = {
	  		description = "* Solar Flare\n\n-# * __Effects__\n-# * The solar flare will apply Sundried such as Verdant to some fruit."
	  }
}

local function GetConfigValue(Key)
    return _G.Configuration[Key]
end

local function DebugLog(message)
    if GetConfigValue("DebugMode") then
        print("[DEBUG] " .. message)
    end
end

pcall(function()
    RunService:Set3dRenderingEnabled(GetConfigValue("RenderingEnabled"))
end)

if _G.StockBot then return end
_G.StockBot = true

local function ConvertColor3(Color)
    return tonumber(Color:ToHex(), 16)
end

local function GetDataPacket(Data, Target)
    if not Data or type(Data) ~= "table" then return nil end
    for _, Packet in pairs(Data) do
        if type(Packet) == "table" and Packet[1] == Target then
            return Packet[2]
        end
    end
    return nil
end

local function GetLayout(Type)
    return GetConfigValue("AlertLayouts")[Type]
end

local function GetWebhookURL(Type)
    return GetConfigValue("Webhook" .. Type) or nil
end

local function WebhookSend(WebhookURL, EmbedColor, Fields, MentionRole)
    if not WebhookURL or WebhookURL == "" then 
        DebugLog("No webhook URL for type")
        return 
    end

    local Body = {
        embeds = {{
            color = EmbedColor,
            fields = Fields,
            footer = { text = "Grow a Garden ID | " .. os.date('%H.%M') }
        }}
    }

    if MentionRole then
        if type(MentionRole) == "table" then
            Body.content = "" .. table.concat(MentionRole, " ")
        elseif type(MentionRole) == "string" then
            Body.content = "" .. MentionRole
        end
    end

    task.spawn(function()
        local success, err = pcall(function()
            request({
                Url = WebhookURL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(Body)
            })
        end)
        
        if not success then
            DebugLog("Webhook send failed: " .. tostring(err))
        else
            DebugLog("Webhook sent successfully")
        end
    end)
end

local function GetItemEmoji(itemName)
    return ItemEmojis[itemName] or ItemEmojis["Default"]
end

local function MakeStockString(Stock)
    if not Stock or type(Stock) ~= "table" then return "No items available", false, nil end
    local result, mentionRoles = "", {}
    local count = 0

    for Name, Data in pairs(Stock) do
        if type(Data) ~= "table" then continue end
        local Item = Data.EggName or Name
        local stockAmount = Data.Stock or 0
        if type(stockAmount) ~= "number" then continue end
        local emoji = GetItemEmoji(Item)
        
        local roleId = GoodItems[Item]
        if roleId then
            table.insert(mentionRoles, roleId)
            result ..= "-# * " .. emoji .. " " .. Item .. " x" .. stockAmount .. "\n"
        else
            result ..= "* " .. emoji .. " " .. Item .. " x" .. stockAmount .. "\n"
        end
        count += 1
        if count >= 25 then
            result ..= "... (truncated)"
            break
        end
    end

    return result ~= "" and result or "No items available", #mentionRoles > 0, mentionRoles
end


local function ProcessPacket(Data, Type, Layout)
    if not Data or not Layout then return end
    
    DebugLog("Processing packet for type: " .. Type)
    
    local Fields = {}
    local MentionRoles = {}
    local Color = ConvertColor3(Layout.EmbedColor)

    for Path, Title in pairs(Layout.Layout or {}) do
        DebugLog("Looking for data at path: " .. Path)
        local Stock = GetDataPacket(Data, Path)
        if Stock then
            DebugLog("Found stock data for: " .. Title)
            local Content, Found, Roles = MakeStockString(Stock)
            if Found and type(Roles) == "table" then
                for _, r in ipairs(Roles) do
                    if not table.find(MentionRoles, r) then
                        table.insert(MentionRoles, r)
                    end
                end
            end
            table.insert(Fields, { name = Title, value = Content, inline = true })
        else
            DebugLog("No stock data found for path: " .. Path)
        end
    end

    if #Fields > 0 then
        DebugLog("Sending webhook for type: " .. Type)
        if Type == "SeedsAndGears" then
            for Path, Title in pairs(Layout.Layout or {}) do
                local Stock = GetDataPacket(Data, Path)
                if Stock then
                    local Content, _, MentionRoles = MakeStockString(Stock)
                    local Field = { name = Title, value = Content, inline = true }

                    if string.find(Title, "Seed") then
                        WebhookSend(GetWebhookURL("Seed"), Color, {Field}, MentionRoles)
                    elseif string.find(Title, "Gear") then
                        WebhookSend(GetWebhookURL("Gear"), Color, {Field}, MentionRoles)
                    end
                    task.wait(0.5)
                end
            end
        else
            local webhookType = Type
            if Type == "Eggs" then
                webhookType = "Egg"
            elseif Type == "CosmeticStock" then
                webhookType = "Cosmetic"
            elseif Type == "EventShop" then
                webhookType = "Event"
            end
            
            DebugLog("Sending to webhook type: " .. webhookType)
            DebugLog("Webhook URL: " .. (GetWebhookURL(webhookType) or "NIL"))
            WebhookSend(GetWebhookURL(webhookType), Color, Fields, MentionRoles)
        end
    else
        DebugLog("No fields to send for type: " .. Type)
    end
end

DataStream.OnClientEvent:Connect(function(Type, Profile, Data)
    if Type ~= "UpdateData" or not Profile or not string.find(Profile, LocalPlayer.Name) then return end
    
    DebugLog("Received data update for profile: " .. Profile)
    
    if GetConfigValue("DebugMode") then
        print("=== DATA RECEIVED ===")
        for i, packet in pairs(Data) do
            if type(packet) == "table" and packet[1] then
                print("Path: " .. tostring(packet[1]))
            end
        end
        print("=== END DATA ===")
    end
    
    for LayoutType, Layout in pairs(GetConfigValue("AlertLayouts")) do
        if LayoutType ~= "Weather" then
            task.spawn(function()
                ProcessPacket(Data, LayoutType, Layout)
            end)
            task.wait(0.2)
        end
    end
end)

WeatherEventStarted.OnClientEvent:Connect(function(Event, Length)
    if not GetConfigValue("WeatherReporting") then return end
    local Data = WeatherDatabase[Event]
    local Desc = Data and Data.description or ("⚠️ **" .. Event .. "** (Unknown Weather)\n\nNo description available for this weather event.")
    local EndUnix = math.round(workspace:GetServerTimeNow()) + Length
    WebhookSend(GetWebhookURL("Weather"), ConvertColor3(Color3.fromRGB(42, 109, 255)), {{
        name = "Weather Event Started",
        value = Desc .. "\n\n⏰ **Ends:** <t:" .. EndUnix .. ":R>",
        inline = false
    }}, false)
end)

LocalPlayer.Idled:Connect(function()
    if not GetConfigValue("AntiAFK") then return end
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
