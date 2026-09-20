-- winhvh loader (loads your restyled x5ng ui from github)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/goonersigma05-gif/xk6hihie/refs/heads/main/ui.lua"))()

-- INTRO (info card first, then character viewport slides in, left side)
if Library.ShowIntro then
Library:ShowIntro({
    "winhvh",
    "For mobile user or xeno user",
    "Dont use the flame mode for ragebot",
    "Because i forgot to add the weld checker",
    "So if you use the flame mode in unsuppported",
    "It will still anchor the target and it wont hit",
    "Its not suppose to anchor the target",
    "when its not supported",
    "winhvh",
    "Loaded",
}, "winhvh", 6)
else
    warn("[winhvh] ShowIntro not found - reupload x5ng ui.txt to github ui.lua first")
end

-- NOTE: options table always goes SECOND: addToggle("Name", { ... })
local Window = Library:CreateWindow("winhvh", "da hood")

local Main      = Window:addPage("Main", 6, true, 6)
local Target    = Window:addPage("Target", 6, false, 6)
local AutoBuy   = Window:addPage("AutoBuy", 6, false, 6)
local Fun       = Window:addPage("Fun", 6, false, 6)
local Animation = Window:addPage("Animation", 6, false, 6)
local Keybind   = Window:addPage("Keybind", 6, false, 6)
local Teleport  = Window:addPage("Teleport", 6, false, 6)
local ESP       = Window:addPage("ESP", 6, false, 6)
local Visual    = Window:addPage("Visual", 6, false, 6)
local Farm      = Window:addPage("Farm", 6, false, 6)

-- MAIN (2-column grid: buttons show a dot, toggles show diamond + checkbox)
Main:addButton("Redeem Promo Code", function()
    print("redeem")
end)

Main:addButton("Force reset", function()
    print("force reset")
end)

Main:addToggle("Fake Position", { Keybind = Enum.KeyCode.X, Callback = print })
Main:addToggle("Noclip", { Keybind = Enum.KeyCode.N, Callback = print })
Main:addToggle("Auto Armor", { Callback = print })
Main:addToggle("Auto Block", { Callback = print })
Main:addToggle("Void Desync", { Keybind = Enum.KeyCode.V, Callback = print })
Main:addToggle("Auto Reload", { Callback = print })

Main:addDropdown("Void Desync Mode - spun", {
    Values = {"spun", "normal", "random"},
    Default = "spun",
    Callback = print,
})

Main:addSlider("Recoil [ 0% + no recoil ]", { Min = 0, Max = 100, Default = 0, Callback = print })
Main:addSlider("Recoil Percentage", { Min = 0, Max = 100, Default = 100, Callback = print })

Main:addToggle("Anti Stomp", { Callback = print })
Main:addDropdown("Anti Stomp Mode - Normal", {
    Values = {"Normal", "Strict", "Off"},
    Default = "Normal",
    Callback = print,
})
Main:addToggle("Anti Void", { Callback = print })
Main:addToggle("Respawn location", { Callback = print })
Main:addToggle("Anti Seat", { Callback = print })
Main:addToggle("Auto Mask", { Callback = print })
Main:addDropdown("Mask Option - Surgeon", {
    Values = {"Surgeon", "Riot", "Hockey"},
    Default = "Surgeon",
    Callback = print,
})

-- Other tabs
Target:addToggle("Target Aim", { Callback = print })
Target:addDropdown("Target Part", { Values = {"Head", "Torso", "Legs"}, Default = "Head", Callback = print })
ESP:addToggle("ESP", {
    ColorPicker = true,
    Color = Color3.fromRGB(255, 255, 255),
    ColorCallback = print,
    Callback = print,
})
Keybind:addKeybind("Toggle UI", Enum.KeyCode.RightShift, print)

-- v2.7 extras (all built into the lib):
-- gear icon (top bar) opens settings: UI Toggle key (default V),
--   Keybind list, Show notifications, Custom cursor, Custom kick
-- show the Hotkeys panel + custom cursor right away:
Library:SetSetting("KeybindList", true)
Library:SetSetting("CustomCursor", true)
-- hotkey pills ([v] ui toggle...) appear in the Hotkeys panel
--   when "Keybind list" is checked in settings
-- custom hotkeys: Library:RegisterHotkey(Enum.KeyCode.Q, "set target key")
-- toasts (gated by Show notifications): Library:Notify("hello")
-- force a setting: Library:SetSetting("KeybindList", true)
