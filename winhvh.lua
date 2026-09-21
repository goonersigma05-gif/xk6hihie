local function DestroyYep()
    for i=1,69 do
        local g=game.CoreGui:FindFirstChild("fu8rj82n")
        if g then g:Destroy() end
    end
end
DestroyYep()
task.wait(.069)
local Library={}
local UIS=game:GetService("UserInputService")
local Players=game:GetService("Players")
local HttpService=game:GetService("HttpService")
local TweenService=game:GetService("TweenService")
--// THEME ENGINE (module scope; UI hooks assigned inside CreateWindow)
local Themes={
    {Name="Onyx",Accent=Color3.new(1,1,1),Window=Color3.fromRGB(18,18,18),Panel=Color3.fromRGB(13,13,13),Row=Color3.fromRGB(23,23,23),Hi=Color3.fromRGB(28,28,28)},
    {Name="Midnight Blue",Accent=Color3.fromRGB(130,170,255),Window=Color3.fromRGB(19,23,35),Panel=Color3.fromRGB(14,17,27),Row=Color3.fromRGB(52,64,94),Hi=Color3.fromRGB(66,80,114)},
    {Name="Crimson Night",Accent=Color3.fromRGB(220,70,80),Window=Color3.fromRGB(22,14,16),Panel=Color3.fromRGB(16,10,12),Row=Color3.fromRGB(34,20,24),Hi=Color3.fromRGB(48,28,32)},
    {Name="Dark Forest",Accent=Color3.fromRGB(90,210,130),Window=Color3.fromRGB(13,20,15),Panel=Color3.fromRGB(9,15,11),Row=Color3.fromRGB(18,32,22),Hi=Color3.fromRGB(26,46,32)},
    {Name="Espresso",Accent=Color3.fromRGB(215,160,95),Window=Color3.fromRGB(23,18,13),Panel=Color3.fromRGB(16,12,9),Row=Color3.fromRGB(37,28,20),Hi=Color3.fromRGB(52,40,28)},
    {Name="Gray",Accent=Color3.fromRGB(225,225,225),Window=Color3.fromRGB(24,24,24),Panel=Color3.fromRGB(17,17,17),Row=Color3.fromRGB(36,36,36),Hi=Color3.fromRGB(52,52,52)},
    {Name="Obsidian Purple",Accent=Color3.fromRGB(175,115,255),Window=Color3.fromRGB(17,13,24),Panel=Color3.fromRGB(12,9,17),Row=Color3.fromRGB(26,19,38),Hi=Color3.fromRGB(38,28,54)},
    {Name="PinkEdition",Accent=Color3.fromRGB(255,115,185),Window=Color3.fromRGB(25,14,20),Panel=Color3.fromRGB(18,10,14),Row=Color3.fromRGB(40,22,32),Hi=Color3.fromRGB(56,32,46)},
    {Name="Rust & Bone",Accent=Color3.fromRGB(220,135,65),Window=Color3.fromRGB(23,18,13),Panel=Color3.fromRGB(17,13,10),Row=Color3.fromRGB(38,29,20),Hi=Color3.fromRGB(54,41,28)},
    {Name="Blood Moon",Accent=Color3.fromRGB(255,45,45),Window=Color3.fromRGB(16,10,10),Panel=Color3.fromRGB(11,7,7),Row=Color3.fromRGB(30,16,16),Hi=Color3.fromRGB(44,22,22)},
    {Name="Arctic Frost",Accent=Color3.fromRGB(150,220,255),Window=Color3.fromRGB(14,18,24),Panel=Color3.fromRGB(10,13,18),Row=Color3.fromRGB(22,30,40),Hi=Color3.fromRGB(32,44,58)},
    {Name="Toxic",Accent=Color3.fromRGB(140,255,70),Window=Color3.fromRGB(12,18,10),Panel=Color3.fromRGB(9,13,8),Row=Color3.fromRGB(20,30,16),Hi=Color3.fromRGB(30,44,24)},
    {Name="Sunset",Accent=Color3.fromRGB(255,140,60),Window=Color3.fromRGB(24,15,12),Panel=Color3.fromRGB(17,11,9),Row=Color3.fromRGB(40,24,18),Hi=Color3.fromRGB(58,34,26)},
    {Name="Lavender",Accent=Color3.fromRGB(200,170,255),Window=Color3.fromRGB(19,16,25),Panel=Color3.fromRGB(14,12,19),Row=Color3.fromRGB(30,26,42),Hi=Color3.fromRGB(44,38,60)},
    {Name="Gold Rush",Accent=Color3.fromRGB(255,205,70),Window=Color3.fromRGB(22,18,12),Panel=Color3.fromRGB(16,13,9),Row=Color3.fromRGB(38,30,18),Hi=Color3.fromRGB(55,43,26)},
}
local CurrentTheme=Themes[1]
local AllTabRefs={}
local ThemeRegistry={}
local function RegTheme(obj,role) if obj then table.insert(ThemeRegistry,{o=obj,r=role}) end return obj end
local UpdateThemeUI=function() end
local SaveSettingsFn=function() end
local function ApplyTheme(t)
    if type(t)~="table" or not t.Name then return end
    CurrentTheme=t
    for _,e in ipairs(ThemeRegistry) do
        local o=e.o
        if o and o.Parent then
            pcall(function()
                if e.r=="Window" then o.BackgroundColor3=t.Window
                elseif e.r=="Panel" then o.BackgroundColor3=t.Panel
                elseif e.r=="Row" then o.BackgroundColor3=t.Row
                elseif e.r=="Hi" then o.BackgroundColor3=t.Hi
                elseif e.r=="Accent" or e.r=="Dot" then o.BackgroundColor3=t.Accent
                end
            end)
        end
    end
    pcall(UpdateThemeUI)
    pcall(SaveSettingsFn)
    for _,t in ipairs(AllTabRefs) do
        pcall(function()
            if t and t.Parent and t:IsA("GuiButton") then
                local sel=t.TextColor3==Color3.new(1,1,1)
                t.BackgroundTransparency=1
                t.Font=sel and Enum.Font.GothamBold or Enum.Font.GothamSemibold
                t.TextXAlignment=sel and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
            end
        end)
    end
end
local function FindTheme(name)
    for _,t in ipairs(Themes) do if t.Name:lower()==tostring(name or ""):lower() then return t end end
    return nil
end
local ConfigFolder="winhvh"
local PluginFolder=ConfigFolder.."/winhvh_plugin"
local function HasFS()
    return type(isfile)=="function"
    and type(readfile)=="function"
    and type(writefile)=="function"
end
local function SetupFolder()
    if not HasFS() then return false end
    if type(isfolder)=="function"
    and type(makefolder)=="function" then
        if not isfolder(ConfigFolder) then pcall(makefolder,ConfigFolder) end
    end
    return true
end
local function SetupPluginFolder()
    if not SetupFolder() then return false end
    if type(isfolder)=="function"
    and type(makefolder)=="function" then
        if not isfolder(PluginFolder) then pcall(makefolder,PluginFolder) end
    end
    return true
end
local function CleanName(name)
    name=tostring(name or "")
    name=name:gsub("[^%w_%- ]","")
    name=name:gsub("^%s+","")
    name=name:gsub("%s+$","")
    return name~="" and name or "Default"
end
local function ConfigPath(name)
    return ConfigFolder.."/"..CleanName(name)..".json"
end
local function ColorToTable(c)
    if typeof(c)~="Color3" then return nil end
    return {
        __type="Color3",
        R=c.R,
        G=c.G,
        B=c.B
    }
end
local function TableToColor(v)
    if type(v)~="table"
    or v.__type~="Color3" then
        return nil
    end
return Color3.new(tonumber(v.R) or 1, tonumber(v.G) or 1, tonumber(v.B) or 1)
end
local function SerializeBind(bind)
    if not bind then return nil end
    if bind.EnumType==Enum.KeyCode then return "KeyCode|"..bind.Name end
    if bind.EnumType==Enum.UserInputType then return "UserInputType|"..bind.Name end
    return nil
end
local function DeserializeBind(value)
    if type(value)~="string" then return nil end
    local typ,name=value:match("^([^|]+)|(.+)$")
    if typ=="KeyCode" then
local ok,result=pcall(function() return Enum.KeyCode[name] end)
        if ok and result then return result end
    elseif typ=="UserInputType" then
local ok,result=pcall(function() return Enum.UserInputType[name] end)
        if ok and result then return result end
    end
    return nil
end
local function GetConfigFiles()
    local files={}
    if not SetupFolder()
    or type(listfiles)~="function" then
        return files
    end
local ok,result=pcall(function() return listfiles(ConfigFolder) end)
    if not ok or type(result)~="table" then return files end
    for _,path in ipairs(result) do
        local filename=tostring(path):match("([^/\\]+)%.json$")
        if filename and filename~="settings" then table.insert(files,filename) end
    end
table.sort(files,function(a,b) return a:lower()<b:lower() end)
    return files
end
local function GetPluginFiles()
    local files={}
    if not SetupPluginFolder()
    or type(listfiles)~="function" then
        return files
    end
local ok,result=pcall(function() return listfiles(PluginFolder) end)
    if not ok or type(result)~="table" then return files end
    for _,path in ipairs(result) do
        path=tostring(path)
        if lower:sub(-4)==".lua" or lower:sub(-4)==".txt" then table.insert(files,path) end
    end
table.sort(files,function(a,b) return a:lower()<b:lower() end)
    return files
end
local function PluginFileName(path)
    return tostring(path):match("([^/\\]+)%.[^%.]+$") or tostring(path)
end
function Library:CreateWindow(windowname,windowinfo)
    local Gui=Instance.new("ScreenGui")
    local Frame=Instance.new("Frame")
    local Scale=Instance.new("UIScale")
    local Corner=Instance.new("UICorner")
    local Dash=Instance.new("Frame")
    local DashCorner=Instance.new("UICorner")
    local Tabs=Instance.new("ScrollingFrame")
    local TabLayout=Instance.new("UIListLayout")
    local Pages=Instance.new("Frame")
    local PagesCorner=Instance.new("UICorner")
    local Folder=Instance.new("Folder")
    local Title=Instance.new("TextLabel")
    local ResetButton=Instance.new("TextButton")
    local Credits=Instance.new("TextButton")
    local CreditIcon=Instance.new("ImageLabel")
    local CreditText=Instance.new("TextLabel")
    Gui.Name="fu8rj82n"
    Gui.Parent=game.CoreGui
    Gui.ResetOnSpawn=false
    Gui.ZIndexBehavior=Enum.ZIndexBehavior.Global
    Frame.Parent=Gui
    Frame.BackgroundColor3=Color3.fromRGB(18,18,18)
    Frame.BorderSizePixel=0
    Frame.Position=UDim2.new(.27,0,.29,0)
    Frame.Size=UDim2.new(0,620,0,400)
    Frame.Active=true
    RegTheme(Frame,"Window")
    Scale.Scale=1
    Scale.Parent=Frame
    Corner.CornerRadius=UDim.new(0,7)
    Corner.Parent=Frame
    Dash.Parent=Frame
    Dash.BackgroundColor3=Color3.fromRGB(13,13,13)
    Dash.BorderSizePixel=0
    Dash.Position=UDim2.new(.018,0,.168,0)
    Dash.Size=UDim2.new(0,130,0,318)
    Dash.ClipsDescendants=true
    RegTheme(Dash,"Panel")
    local DashStroke=Instance.new("UIStroke")
    DashStroke.Color=Color3.fromRGB(40,40,40)
    DashStroke.Thickness=1
    DashStroke.Parent=Dash
    DashCorner.CornerRadius=UDim.new(0,6)
    DashCorner.Parent=Dash
    Tabs.Parent=Dash
Tabs.BackgroundTransparency=1
Tabs.BorderSizePixel=0
Tabs.Position=UDim2.new(.03,0,.035,0)
Tabs.Size=UDim2.new(0,122,1,-18)
Tabs.CanvasSize=UDim2.new(0,0,0,0)
Tabs.ScrollBarThickness=2
Tabs.ScrollBarImageColor3=Color3.fromRGB(70,70,70)
Tabs.ScrollBarImageTransparency=0.15
Tabs.ScrollingDirection=Enum.ScrollingDirection.Y
Tabs.VerticalScrollBarInset=Enum.ScrollBarInset.ScrollBar
Tabs.AutomaticCanvasSize=Enum.AutomaticSize.Y
Tabs.ElasticBehavior=Enum.ElasticBehavior.WhenScrollable
Tabs.ClipsDescendants=true
TabLayout.Parent=Tabs
TabLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
TabLayout.SortOrder=Enum.SortOrder.LayoutOrder
TabLayout.Padding=UDim.new(0,6)
    Pages.Parent=Frame
    Pages.BackgroundColor3=Color3.fromRGB(13,13,13)
    Pages.BorderSizePixel=0
    Pages.Position=UDim2.new(.245,0,.168,0)
    Pages.Size=UDim2.new(0,456,0,318)
    Pages.ClipsDescendants=true
    RegTheme(Pages,"Panel")
    local PagesStroke=Instance.new("UIStroke")
    PagesStroke.Color=Color3.fromRGB(40,40,40)
    PagesStroke.Thickness=1
    PagesStroke.Parent=Pages
    PagesCorner.CornerRadius=UDim.new(0,6)
    PagesCorner.Parent=Pages
    Folder.Parent=Pages
    Folder.Name="PageFolder"
    local CenterDivider=Instance.new("Frame")
    CenterDivider.Name="winhvh_Divider"
    CenterDivider.Parent=Pages
    CenterDivider.BackgroundColor3=Color3.fromRGB(70,70,70)
    CenterDivider.BorderSizePixel=0
    CenterDivider.Position=UDim2.new(0,223,.06,0)
    CenterDivider.Size=UDim2.new(0,1,0,295)
    CenterDivider.ZIndex=5
    Title.Parent=Frame
    Title.BackgroundTransparency=1
    Title.Position=UDim2.new(0,16,0,8)
    Title.Size=UDim2.new(0,200,0,22)
    Title.Font=Enum.Font.GothamBold
    Title.Text=windowname or "winhvh"
    Title.TextColor3=Color3.new(1,1,1)
    Title.TextSize=16
    Title.TextXAlignment=Enum.TextXAlignment.Left
    local Subtitle=Instance.new("TextLabel")
    Subtitle.Parent=Frame
    Subtitle.BackgroundTransparency=1
    Subtitle.Position=UDim2.new(0,16,0,30)
    Subtitle.Size=UDim2.new(0,200,0,14)
    Subtitle.Font=Enum.Font.GothamSemibold
    Subtitle.Text=windowinfo or "da hood"
    Subtitle.TextColor3=Color3.fromRGB(130,130,130)
    Subtitle.TextSize=10
    Subtitle.TextXAlignment=Enum.TextXAlignment.Left
    local PageHeader=Instance.new("TextLabel")
    PageHeader.Parent=Frame
    PageHeader.Name="winhvh_PageHeader"
    PageHeader.BackgroundTransparency=1
    PageHeader.Position=UDim2.new(.245,0,.10,0)
    PageHeader.Size=UDim2.new(0,200,0,20)
    PageHeader.Font=Enum.Font.GothamBold
    PageHeader.Text="Main"
    PageHeader.TextColor3=Color3.new(1,1,1)
    PageHeader.TextSize=13
    PageHeader.TextXAlignment=Enum.TextXAlignment.Left
    local PageUnderline=Instance.new("Frame")
    PageUnderline.Parent=Frame
    PageUnderline.BackgroundColor3=Color3.new(1,1,1)
    PageUnderline.BorderSizePixel=0
    PageUnderline.Position=UDim2.new(.245,0,.10,20)
    PageUnderline.Size=UDim2.new(0,34,0,2)
    --// v2.7 forwards (assigned later in CreateWindow scope)
    local UIToggleKey=Enum.KeyCode.V
    local HotkeySources={}
    local RefreshHotkeys=function() end
    local ToggleSettingsPanel=function() end
    local ExpandSearch=function() end
    local CollapseSearch=function() end
    local OpenKeybindPopup=function() end
    ResetButton.Visible=false
    ResetButton.Parent=Frame
    ResetButton.BackgroundColor3=Color3.fromRGB(30,30,30)
    ResetButton.BorderSizePixel=0
    ResetButton.Position=UDim2.new(.30,0,.05,0)
    ResetButton.Size=UDim2.new(0,40,0,22)
    ResetButton.Font=Enum.Font.GothamSemibold
    ResetButton.Text="reset"
    ResetButton.TextColor3=Color3.fromRGB(185,185,185)
    ResetButton.TextSize=9
    ResetButton.AutoButtonColor=false
    ResetButton.ZIndex=50
    local ResetCorner=Instance.new("UICorner")
    ResetCorner.CornerRadius=UDim.new(0,5)
    ResetCorner.Parent=ResetButton
    local ResetStroke=Instance.new("UIStroke")
    ResetStroke.Color=Color3.fromRGB(45,45,45)
    ResetStroke.Transparency=.15
    ResetStroke.Parent=ResetButton
    --// SEARCH (icon, expands on hover like v2.7)
    local SearchBox=Instance.new("TextBox")
    local SearchCorner=Instance.new("UICorner")
    local SearchStroke=Instance.new("UIStroke")
    SearchBox.Parent=Frame
    SearchBox.BackgroundColor3=Color3.fromRGB(24,24,24)
    SearchBox.BorderSizePixel=0
    SearchBox.Position=UDim2.new(.27,0,.03,0)
    SearchBox.Size=UDim2.new(0,0,0,24)
    SearchBox.Visible=false
    SearchBox.Font=Enum.Font.GothamSemibold
    SearchBox.PlaceholderText="Search"
    SearchBox.PlaceholderColor3=Color3.fromRGB(100,100,100)
    SearchBox.Text=""
    SearchBox.TextColor3=Color3.new(1,1,1)
    SearchBox.TextSize=10
    SearchBox.ClearTextOnFocus=false
    SearchBox.TextXAlignment=Enum.TextXAlignment.Left
    SearchBox.ZIndex=60
    SearchBox.ClipsDescendants=true
    SearchCorner.CornerRadius=UDim.new(0,5)
    SearchCorner.Parent=SearchBox
    SearchStroke.Color=Color3.fromRGB(35,35,35)
    SearchStroke.Transparency=.15
    SearchStroke.Parent=SearchBox
    local SearchPadding=Instance.new("UIPadding")
    SearchPadding.PaddingLeft=UDim.new(0,8)
    SearchPadding.PaddingRight=UDim.new(0,8)
    SearchPadding.Parent=SearchBox
    --// SEARCH ICON (magnifier, expands box on hover)
    local SearchIcon=Instance.new("TextButton")
    local SearchIconCorner=Instance.new("UICorner")
    SearchIcon.Parent=Frame
    SearchIcon.BackgroundColor3=Color3.fromRGB(24,24,24)
    SearchIcon.BorderSizePixel=0
    SearchIcon.Position=UDim2.new(.27,0,.03,0)
    SearchIcon.Size=UDim2.new(0,28,0,24)
    SearchIcon.Text=""
    SearchIcon.AutoButtonColor=false
    SearchIcon.ZIndex=50
    SearchIconCorner.CornerRadius=UDim.new(0,5)
    SearchIconCorner.Parent=SearchIcon
    local MagRing=Instance.new("Frame")
    MagRing.Parent=SearchIcon
    MagRing.BackgroundTransparency=1
    MagRing.AnchorPoint=Vector2.new(.5,.5)
    MagRing.Position=UDim2.new(.44,0,.44,0)
    MagRing.Size=UDim2.new(0,10,0,10)
    MagRing.ZIndex=51
    local MagRingCorner=Instance.new("UICorner")
    MagRingCorner.CornerRadius=UDim.new(1,0)
    MagRingCorner.Parent=MagRing
    local MagRingStroke=Instance.new("UIStroke")
    MagRingStroke.Color=Color3.new(1,1,1)
    MagRingStroke.Thickness=2
    MagRingStroke.Parent=MagRing
    local MagHandle=Instance.new("Frame")
    MagHandle.Parent=SearchIcon
    MagHandle.BackgroundColor3=Color3.new(1,1,1)
    MagHandle.BorderSizePixel=0
    MagHandle.AnchorPoint=Vector2.new(.5,.5)
    MagHandle.Position=UDim2.new(.66,0,.68,0)
    MagHandle.Size=UDim2.new(0,2,0,7)
    MagHandle.Rotation=45
    MagHandle.ZIndex=51
    local SearchImg=Instance.new("ImageLabel")
    SearchImg.Parent=SearchIcon
    SearchImg.BackgroundTransparency=1
    SearchImg.BorderSizePixel=0
    SearchImg.AnchorPoint=Vector2.new(.5,.5)
    SearchImg.Position=UDim2.new(.5,0,.5,0)
    SearchImg.Size=UDim2.new(0,18,0,18)
    SearchImg.Image="rbxassetid://11496279127"
    SearchImg.ScaleType=Enum.ScaleType.Fit
    SearchImg.ZIndex=52
    task.delay(3,function()
        local ok,loaded=pcall(function() return SearchImg.IsLoaded end)
        if not ok or not loaded then SearchImg.Visible=false end
    end)
    local searchOpen=false
    ExpandSearch=function()
        if searchOpen then return end
        searchOpen=true
        SearchBox.Visible=true
        SearchBox:TweenSize(UDim2.new(0,220,0,24),"Out","Quad",.18,true)
    end
    CollapseSearch=function()
        if not searchOpen or SearchBox:IsFocused() then return end
        searchOpen=false
        SearchBox:TweenSize(UDim2.new(0,0,0,24),"Out","Quad",.15,true)
        task.delay(.16,function() if not searchOpen then SearchBox.Visible=false end end)
    end
    SearchIcon.MouseEnter:Connect(function() ExpandSearch() end)
    SearchIcon.MouseLeave:Connect(function() task.delay(.15,function() CollapseSearch() end) end)
    SearchBox.MouseLeave:Connect(function() task.delay(.15,function() CollapseSearch() end) end)
    SearchBox.FocusLost:Connect(function() CollapseSearch() end)
    --// GEAR (opens settings panel)
    local GearBtn=Instance.new("TextButton")
    local GearCorner=Instance.new("UICorner")
    GearBtn.Parent=Frame
    GearBtn.BackgroundColor3=Color3.fromRGB(24,24,24)
    GearBtn.BorderSizePixel=0
    GearBtn.Position=UDim2.new(.27,36,.03,0)
    GearBtn.Size=UDim2.new(0,28,0,24)
    GearBtn.Text=""
    GearBtn.AutoButtonColor=false
    GearBtn.ZIndex=50
    GearCorner.CornerRadius=UDim.new(0,5)
    GearCorner.Parent=GearBtn
    do
        local cx,cy=.5,.5
        for _,rot in ipairs({0,45,90,135}) do
            local Spoke=Instance.new("Frame")
            Spoke.Parent=GearBtn
            Spoke.BackgroundColor3=Color3.new(1,1,1)
            Spoke.BorderSizePixel=0
            Spoke.AnchorPoint=Vector2.new(.5,.5)
            Spoke.Position=UDim2.new(cx,0,cy,0)
            Spoke.Size=UDim2.new(0,2,0,14)
            Spoke.Rotation=rot
            Spoke.ZIndex=51
        end
        local GearRing=Instance.new("Frame")
        GearRing.Parent=GearBtn
        GearRing.BackgroundColor3=Color3.fromRGB(24,24,24)
        GearRing.BorderSizePixel=0
        GearRing.AnchorPoint=Vector2.new(.5,.5)
        GearRing.Position=UDim2.new(cx,0,cy,0)
        GearRing.Size=UDim2.new(0,10,0,10)
        GearRing.ZIndex=51
        local GearRingCorner=Instance.new("UICorner")
        GearRingCorner.CornerRadius=UDim.new(1,0)
        GearRingCorner.Parent=GearRing
        local GearRingStroke=Instance.new("UIStroke")
        GearRingStroke.Color=Color3.new(1,1,1)
        GearRingStroke.Thickness=2
        GearRingStroke.Parent=GearRing
        local GearDot=Instance.new("Frame")
        GearDot.Parent=GearBtn
        GearDot.BackgroundColor3=Color3.new(1,1,1)
        GearDot.BorderSizePixel=0
        GearDot.AnchorPoint=Vector2.new(.5,.5)
        GearDot.Position=UDim2.new(cx,0,cy,0)
        GearDot.Size=UDim2.new(0,4,0,4)
        GearDot.ZIndex=51
        local GearDotCorner=Instance.new("UICorner")
        GearDotCorner.CornerRadius=UDim.new(1,0)
        GearDotCorner.Parent=GearDot
    end
    GearBtn.MouseButton1Click:Connect(function() ToggleSettingsPanel() end)
    local GearImg=Instance.new("ImageLabel")
    GearImg.Parent=GearBtn
    GearImg.BackgroundTransparency=1
    GearImg.BorderSizePixel=0
    GearImg.AnchorPoint=Vector2.new(.5,.5)
    GearImg.Position=UDim2.new(.5,0,.5,0)
    GearImg.Size=UDim2.new(0,18,0,18)
    GearImg.Image="rbxassetid://9405931596"
    GearImg.ScaleType=Enum.ScaleType.Fit
    GearImg.ZIndex=52
    task.delay(3,function()
        local ok,loaded=pcall(function() return GearImg.IsLoaded end)
        if not ok or not loaded then GearImg.Visible=false end
    end)
    --// CREDITS
    Credits.Visible=false
    Credits.Parent=Frame
    Credits.BackgroundTransparency=1
    Credits.Position=UDim2.new(.885,0,.05,0)
    Credits.Size=UDim2.new(0,38,0,22)
    Credits.AutoButtonColor=false
    Credits.Text=""
    CreditIcon.Parent=Credits
    CreditIcon.BackgroundTransparency=1
    CreditIcon.Size=UDim2.new(0,38,0,21)
    CreditIcon.Image="rbxassetid://4384401360"
    CreditIcon.ScaleType=Enum.ScaleType.Fit
    CreditText.Parent=Credits
    CreditText.BackgroundTransparency=1
    CreditText.Position=UDim2.new(1.45,0,-.32,0)
    CreditText.Size=UDim2.new(0,145,0,33)
    CreditText.Font=Enum.Font.GothamSemibold
    CreditText.Text=windowinfo or "UI Made by Bytes#0001"
    CreditText.TextColor3=Color3.new(1,1,1)
    CreditText.TextSize=9
    CreditText.TextTransparency=1
CreditIcon.MouseEnter:Connect(function() CreditText.TextTransparency=0 CreditIcon.ImageColor3=Color3.new(1,1,1) end)
CreditIcon.MouseLeave:Connect(function() CreditText.TextTransparency=1 CreditIcon.ImageColor3=Color3.new(1,1,1) end)
    --// MAIN DRAG
    local dragging=false
    local dragInput
    local dragStart
    local startPos
    Frame.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            if SearchBox:IsFocused() then return end
            if Frame:GetAttribute("Resizing") then return end
            dragging=true
            dragStart=i.Position
            startPos=Frame.Position
i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
Frame.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end end)
    UIS.InputChanged:Connect(function(i)
        if i==dragInput and dragging then
            local d=i.Position-dragStart
Frame.Position=UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
        end
    end)
SearchBox.Focused:Connect(function() dragging=false end)
    --// FOUR CORNER RESIZE
    Frame:SetAttribute("Resizing",false)
    do
        local resizing=false
        local resizeCorner=nil
        local resizeInput=nil
        local resizeStart=nil
        local resizeStartSize=nil
        local resizeStartPos=nil
        local function MakeHandle(name,anchor,position,cursor)
            local Handle=Instance.new("TextButton")
            Handle.Name=name
            Handle.Parent=Frame
            Handle.BackgroundTransparency=1
            Handle.BorderSizePixel=0
            Handle.AnchorPoint=anchor
            Handle.Position=position
            Handle.Size=UDim2.new(0,14,0,14)
            Handle.Text=""
            Handle.AutoButtonColor=false
            Handle.ZIndex=100
            Handle.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1
                or i.UserInputType==Enum.UserInputType.Touch then
                    resizing=true
                    Frame:SetAttribute("Resizing",true)
                    resizeCorner=name
                    resizeStart=i.Position
                    resizeStartSize=Frame.AbsoluteSize
                    resizeStartPos=Frame.Position
i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then resizing=false resizeCorner=nil Frame:SetAttribute("Resizing",false) end end)
                end
            end)
Handle.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then resizeInput=i end end)
            return Handle
        end
MakeHandle("ResizeTopLeft", Vector2.new(0,0), UDim2.new(0,0,0,0))
MakeHandle("ResizeTopRight", Vector2.new(1,0), UDim2.new(1,0,0,0))
MakeHandle("ResizeBottomLeft", Vector2.new(0,1), UDim2.new(0,0,1,0))
MakeHandle("ResizeBottomRight", Vector2.new(1,1), UDim2.new(1,0,1,0))
        UIS.InputChanged:Connect(function(i)
            if not resizing or i~=resizeInput then return end
            local d=i.Position-resizeStart
            local minX=620
            local minY=400
            local maxX=1000
            local maxY=700
            local width=resizeStartSize.X
            local height=resizeStartSize.Y
            local pos=resizeStartPos
            if resizeCorner=="ResizeTopLeft" then
                width=math.clamp(resizeStartSize.X-d.X,minX,maxX)
                height=math.clamp(resizeStartSize.Y-d.Y,minY,maxY)
pos=UDim2.new(resizeStartPos.X.Scale, resizeStartPos.X.Offset+d.X, resizeStartPos.Y.Scale, resizeStartPos.Y.Offset+d.Y)
            elseif resizeCorner=="ResizeTopRight" then
                width=math.clamp(resizeStartSize.X+d.X,minX,maxX)
                height=math.clamp(resizeStartSize.Y-d.Y,minY,maxY)
pos=UDim2.new(resizeStartPos.X.Scale, resizeStartPos.X.Offset, resizeStartPos.Y.Scale, resizeStartPos.Y.Offset+d.Y)
            elseif resizeCorner=="ResizeBottomLeft" then
                width=math.clamp(resizeStartSize.X-d.X,minX,maxX)
                height=math.clamp(resizeStartSize.Y+d.Y,minY,maxY)
pos=UDim2.new(resizeStartPos.X.Scale, resizeStartPos.X.Offset+d.X, resizeStartPos.Y.Scale, resizeStartPos.Y.Offset)
            else
                width=math.clamp(resizeStartSize.X+d.X,minX,maxX)
                height=math.clamp(resizeStartSize.Y+d.Y,minY,maxY)
            end
            Frame.Position=pos
            Frame.Size=UDim2.new(0,width,0,height)
        end)
    end
    --// MINIMIZE
    local Min=Instance.new("TextButton")
    local MinCorner=Instance.new("UICorner")
    Min.Parent=Frame
    Min.BackgroundTransparency=1
    Min.BackgroundColor3=Color3.fromRGB(18,18,18)
    Min.Position=UDim2.new(.94,0,.03,0)
    Min.Size=UDim2.new(0,28,0,22)
    Min.Font=Enum.Font.GothamBold
    Min.Text="X"
    Min.TextColor3=Color3.new(1,1,1)
    Min.TextSize=14
    Min.ZIndex=50
    MinCorner.CornerRadius=UDim.new(0,5)
    MinCorner.Parent=Min
    Min.MouseButton1Click:Connect(function() Gui:Destroy() end)
    --// FLOAT
    local Float=Instance.new("TextButton")
    local FloatCorner=Instance.new("UICorner")
    local FloatStroke=Instance.new("UIStroke")
    Float.Parent=Gui
    Float.BackgroundColor3=Color3.fromRGB(15,15,15)
    Float.Position=UDim2.new(.05,0,.2,0)
    Float.Size=UDim2.new(0,65,0,35)
    Float.Font=Enum.Font.GothamBold
    Float.Text="winhvh"
    Float.TextColor3=Color3.new(1,1,1)
    Float.TextSize=12
    Float.Visible=false
    Float.Active=true
    FloatCorner.CornerRadius=UDim.new(0,6)
    FloatCorner.Parent=Float
    FloatStroke.Color=Color3.fromRGB(35,35,35)
    FloatStroke.Parent=Float
    local fd,fi,fs,fp
    Float.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            fd=true
            fs=i.Position
            fp=Float.Position
i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then fd=false end end)
        end
    end)
Float.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then fi=i end end)
    UIS.InputChanged:Connect(function(i)
        if i==fi and fd then
            local d=i.Position-fs
Float.Position=UDim2.new(fp.X.Scale, fp.X.Offset+d.X, fp.Y.Scale, fp.Y.Offset+d.Y)
        end
    end)
    local visible=true
    Float.Visible=false
    local function SetVisible(v)
        if v==nil then visible=not visible else visible=v==true end
        Frame.Visible=visible
    end
    UIS.InputBegan:Connect(function(i,gp)
        if gp then return end
        if i.KeyCode==Enum.KeyCode.Semicolon then
            if not Frame.Visible then SetVisible(true) end
            ExpandSearch()
            SearchBox:CaptureFocus()
            SearchBox.CursorPosition=#SearchBox.Text+1
            return
        end
        if i.KeyCode==Enum.KeyCode.RightShift or i.KeyCode==UIToggleKey then
            SetVisible()
        end
    end)
    --// REGISTRY
    local AllElements={}
    local PageTabs={}
    local ConfigEntries={}
    local PluginConfigEntries={}
    local ResetEntries={}
    local LoadedPlugins={}
    local PluginTabOrder=0
    local CurrentPlugin=nil
    --// PERFORMANCE / UI SCALE
    local PerformanceMode=false
    local UIRefreshQueued=false
    local UIScaleValue=1
    local function QueueCanvasUpdate(fn)
        if PerformanceMode then
            if UIRefreshQueued then return end
            UIRefreshQueued=true
task.delay(.06,function() UIRefreshQueued=false pcall(fn) end)
        else
            task.defer(fn)
        end
    end
    --// AUTO RESIZE
    --// WINDOW LAYOUT
--// Tabs are scrollable instead of making the window taller.
local function UpdateWindowLayout()
    -- XK5NG layout: wider window, fixed size.
    local contentHeight=318
Frame.Size=UDim2.new(0, 620, 0, contentHeight+82)
Dash.Size=UDim2.new(0, 130, 0, contentHeight)
Tabs.Size=UDim2.new(0, 122, 0, contentHeight-9)
Pages.Size=UDim2.new(0, 456, 0, contentHeight)
    --// Update page sizes
    local homeW2=Pages.AbsoluteSize.X
    if homeW2<50 then homeW2=456 end
    for _,page in ipairs(Folder:GetChildren()) do
        if page:IsA("ScrollingFrame") then
page.Size=UDim2.new(0, homeW2-12, 0, contentHeight-13)
        end
    end
    --// Update page canvases
    QueueCanvasUpdate(function()
        for _,page in ipairs(Folder:GetChildren()) do
            if page:IsA("ScrollingFrame") then
                local layout=
page:FindFirstChildOfClass("UIGridLayout")
                if layout then
                    page.CanvasSize=UDim2.new(
                        0,
                        0,
                        0,
math.max(layout.AbsoluteContentSize.Y+12, page.AbsoluteSize.Y)
)
                end
            end
        end
    end)
end
    --// INDEPENDENT LEFT ACTIVE PANEL
    local TogglePanel=Instance.new("Frame")
    local ToggleCorner=Instance.new("UICorner")
    local ToggleStroke=Instance.new("UIStroke")
    local ToggleTitle=Instance.new("TextLabel")
    local ToggleList=Instance.new("Frame")
    local ToggleLayout=Instance.new("UIListLayout")
    TogglePanel.Name="NOVA_ActiveToggles"
    TogglePanel.Parent=Gui
    TogglePanel.BackgroundColor3=Color3.fromRGB(15,15,15)
    TogglePanel.BorderSizePixel=0
    TogglePanel.Position=UDim2.new(0,12,0,0.5)
    TogglePanel.Size=UDim2.new(0,210,0,45)
    TogglePanel.Active=true
    TogglePanel.Visible=false
    TogglePanel.ZIndex=200
    ToggleCorner.CornerRadius=UDim.new(0,7)
    ToggleCorner.Parent=TogglePanel
    ToggleStroke.Color=Color3.fromRGB(35,35,35)
    ToggleStroke.Transparency=.1
    ToggleStroke.Parent=TogglePanel
    ToggleTitle.Parent=TogglePanel
    ToggleTitle.BackgroundTransparency=1
    ToggleTitle.Position=UDim2.new(0,12,0,6)
    ToggleTitle.Size=UDim2.new(1,-24,0,22)
    ToggleTitle.Font=Enum.Font.GothamSemibold
    ToggleTitle.Text="Active Toggles"
    ToggleTitle.TextColor3=Color3.new(1,1,1)
    ToggleTitle.TextSize=12
    ToggleTitle.TextXAlignment=Enum.TextXAlignment.Left
    ToggleTitle.ZIndex=201
    ToggleList.Parent=TogglePanel
    ToggleList.BackgroundTransparency=1
    ToggleList.Position=UDim2.new(0,10,0,34)
    ToggleList.Size=UDim2.new(1,-20,1,-40)
    ToggleList.ZIndex=201
    ToggleLayout.Parent=ToggleList
    ToggleLayout.SortOrder=Enum.SortOrder.LayoutOrder
    ToggleLayout.Padding=UDim.new(0,5)
    local ActiveToggleRows={}
    local ToggleControllers={}
    local function UpdateTogglePanel()
        local count=0
        for _,row in pairs(ActiveToggleRows) do
            if row and row.Parent then count+=1 end
        end
        local height=45
        if count>0 then height=45+(count*29)+8 end
        TogglePanel.Size=UDim2.new(0,210,0,height)
    end
    --// PANEL DRAG ONLY
    local tpDragging=false
    local tpInput
    local tpStart
    local tpPos
    ToggleTitle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            tpDragging=true
            tpStart=i.Position
            tpPos=TogglePanel.Position
i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then tpDragging=false end end)
        end
    end)
ToggleTitle.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then tpInput=i end end)
    UIS.InputChanged:Connect(function(i)
        if i==tpInput and tpDragging then
            local d=i.Position-tpStart
TogglePanel.Position=UDim2.new(tpPos.X.Scale, tpPos.X.Offset+d.X, tpPos.Y.Scale, tpPos.Y.Offset+d.Y)
        end
    end)
    local HighlightedObject=nil
    local HighlightedColor=nil
    local HighlightToken=0
    local SearchToken=0
    local function ClearHighlight()
        HighlightToken+=1
        if HighlightedObject
        and HighlightedObject.Parent
        and HighlightedColor then
            HighlightedObject.BackgroundColor3=HighlightedColor
        end
        HighlightedObject=nil
        HighlightedColor=nil
    end
    local function Register(obj,name,page,typ)
        if not obj then return end
        table.insert(AllElements,{
            Object=obj,
            Name=tostring(name or ""),
            Page=page,
            Type=typ
        })
    end
    local function RegisterConfig(name,typ,getter,setter)
        local okDefault,defaultValue=pcall(getter)
        local entry={
            Name=tostring(name or ""),
            Type=typ,
            Get=getter,
            Set=setter,
            Default=okDefault and defaultValue or nil,
            Plugin=CurrentPlugin
        }
        table.insert(ResetEntries,entry)
        if CurrentPlugin then
table.insert(PluginConfigEntries, entry)
        else
table.insert(ConfigEntries, entry)
        end
    end
    --// SEARCH
    local function Search(query)
        SearchToken+=1
        local token=SearchToken
        query=tostring(query or "")
        query=query:lower()
        query=query:gsub("^%s+","")
        query=query:gsub("%s+$","")
        if query=="" then
            ClearHighlight()
            return
        end
        for _,data in ipairs(AllElements) do
            if data.Name:lower():find(query,1,true) then
                local page=data.Page
                if not page or not page.Parent then return end
                for _,p in ipairs(Folder:GetChildren()) do
                    if p:IsA("ScrollingFrame") then p.Visible=false end
                end
                page.Visible=true
                for name,tab in pairs(PageTabs) do
                    if name==page.Name then
                        tab.TextTransparency=0
                        tab.BackgroundColor3=Color3.fromRGB(25,25,25)
                    else
                        tab.TextTransparency=.3
                        tab.BackgroundColor3=Color3.fromRGB(15,15,15)
                    end
                end
                task.defer(function()
                    task.wait()
                    if token~=SearchToken then return end
                    if not data.Object
                    or not data.Object.Parent then
                        return
                    end
                    local y=
                        data.Object.AbsolutePosition.Y
                        -page.AbsolutePosition.Y
                        +page.CanvasPosition.Y
                        -12
local maxY=math.max(0, page.AbsoluteCanvasSize.Y-page.AbsoluteSize.Y)
page.CanvasPosition=Vector2.new(0, math.clamp(y,0,maxY))
                    ClearHighlight()
                    HighlightToken+=1
                    local ht=HighlightToken
                    HighlightedObject=data.Object
                    HighlightedColor=data.Object.BackgroundColor3
                    data.Object.BackgroundColor3=
                        Color3.new(1,1,1)
                    task.delay(.55,function()
                        if ht~=HighlightToken then return end
                        if HighlightedObject==data.Object
                        and HighlightedObject.Parent
                        and HighlightedColor then
                            HighlightedObject.BackgroundColor3=
                                HighlightedColor
                        end
                        HighlightedObject=nil
                        HighlightedColor=nil
                    end)
                end)
                return
            end
        end
        ClearHighlight()
    end
SearchBox:GetPropertyChangedSignal("Text"):Connect(function() Search(SearchBox.Text) end)
    --// PAGES
    local PageYep={}
    function PageYep:addPage(
        pagename,
        scrollsize,
        visible,
        elementspacing
)
        local pageName=tostring(pagename or "Page")
        if PageTabs[pageName] then pageName=pageName.." "..tostring(math.random(1000,9999)) end
        local Tab=Instance.new("TextButton")
        local TC=Instance.new("UICorner")
        local Home=Instance.new("ScrollingFrame")
        local Layout=Instance.new("UIGridLayout")
        Tab.Name="Tab"
        Tab.Parent=Tabs
        Tab.BackgroundTransparency=1
        Tab.BorderSizePixel=0
        Tab.Size=UDim2.new(0,116,0,24)
        Tab.AutoButtonColor=false
        Tab.Font=visible and Enum.Font.GothamBold or Enum.Font.GothamSemibold
        Tab.Text=pageName
        Tab.TextColor3=visible and Color3.new(1,1,1) or Color3.fromRGB(140,140,140)
        Tab.TextSize=11
        Tab.TextTransparency=0
        Tab.TextXAlignment=visible and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
        TC.CornerRadius=UDim.new(0,5)
        TC.Parent=Tab
        Home.Name=pageName
        Home.Parent=Folder
        Home.Active=true
        Home.BackgroundTransparency=1
        Home.BorderSizePixel=0
        Home.Position=UDim2.new(0,6,.06,0)
        local homeW0=Pages.AbsoluteSize.X
        if homeW0<50 then homeW0=456 end
        Home.Size=UDim2.new(0,homeW0-12,0,295)
        Home.ScrollBarThickness=2
        Home.ScrollBarImageColor3=Color3.fromRGB(70,70,70)
        Home.CanvasSize=UDim2.new(0,0,0,0)
        Home.ScrollingDirection=Enum.ScrollingDirection.Y
        Home.VerticalScrollBarInset=Enum.ScrollBarInset.ScrollBar
        Home.ClipsDescendants=true
        Home.Visible=visible==true
        Layout.Parent=Home
        Layout.FillDirectionMaxCells=2
        Layout.FillDirection=Enum.FillDirection.Horizontal
        Layout.HorizontalAlignment=Enum.HorizontalAlignment.Left
        Layout.VerticalAlignment=Enum.VerticalAlignment.Top
        Layout.SortOrder=Enum.SortOrder.LayoutOrder
        Layout.CellSize=UDim2.new(0,214,0,26)
        Layout.CellPadding=UDim2.new(0,6,0,3)
        local function UpdateCanvas()
            local h=Layout.AbsoluteContentSize.Y+12
            Home.CanvasSize=UDim2.new(
                0,
                0,
                0,
math.max(h, Home.AbsoluteSize.Y)
)
        end
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
Home:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateCanvas)
        task.defer(UpdateCanvas)
        PageTabs[pageName]=Tab
        table.insert(AllTabRefs,Tab)
        if pageName~="Config" then
            PluginTabOrder+=1
            Tab.LayoutOrder=PluginTabOrder
        end
        local function ShowPage()
            ClearHighlight()
            SearchToken+=1
            for _,p in ipairs(Folder:GetChildren()) do
                if p:IsA("ScrollingFrame") then p.Visible=false end
            end
            Home.Visible=true
            local header=Frame:FindFirstChild("winhvh_PageHeader")
            if header then header.Text=pageName end
            for _,t in ipairs(Tabs:GetChildren()) do
                if t:IsA("GuiButton") then
                    local selected=t==Tab
                    t.BackgroundTransparency=1
                    t.Font=selected and Enum.Font.GothamBold or Enum.Font.GothamSemibold
                    t.TextXAlignment=selected and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
                    t.TextColor3=
                        selected
                        and Color3.new(1,1,1)
                        or Color3.fromRGB(140,140,140)
                end
            end
            task.defer(UpdateCanvas)
        end
        Tab.MouseButton1Click:Connect(ShowPage)
Tab.MouseEnter:Connect(function() Tab.Font=Enum.Font.GothamBold Tab.TextColor3=Color3.new(1,1,1) end)
Tab.MouseLeave:Connect(function() if Tab.TextXAlignment==Enum.TextXAlignment.Center then Tab.Font=Enum.Font.GothamBold Tab.TextColor3=Color3.new(1,1,1) else Tab.Font=Enum.Font.GothamSemibold Tab.TextColor3=Color3.fromRGB(140,140,140) Tab.TextXAlignment=Enum.TextXAlignment.Left end end)
        local Elements={}
        Elements.__Tab=Tab
        Elements.__Page=Home
        local OrderSeq=0
        Elements.__Order=function() OrderSeq+=1 return OrderSeq end
        local function RegisterElement(obj,name,typ)
            Register(obj,name,Home,typ)
            RegTheme(obj,"Row")
            OrderSeq+=1
            obj.LayoutOrder=OrderSeq
            for _,d in ipairs(obj:GetDescendants()) do
                if d:IsA("TextLabel") or d:IsA("TextButton") then
                    d.TextScaled=true
                    if not d:FindFirstChildOfClass("UITextSizeConstraint") then
                        local c=Instance.new("UITextSizeConstraint")
                        c.MaxTextSize=d.TextSize
                        c.Parent=d
                    end
                end
            end
        end
        local function BuildHSVGrid(parent,baseZ)
            local Base=Instance.new("Frame")
            Base.Parent=parent
            Base.BackgroundColor3=Color3.new(1,1,1)
            Base.BorderSizePixel=0
            Base.Position=UDim2.new(0,0,0,0)
            Base.Size=UDim2.new(1,0,1,0)
            Base.ZIndex=baseZ+1
            local HG=Instance.new("UIGradient")
            HG.Rotation=0
            HG.Color=ColorSequence.new{
                ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
                ColorSequenceKeypoint.new(1/6,Color3.fromRGB(255,255,0)),
                ColorSequenceKeypoint.new(2/6,Color3.fromRGB(0,255,0)),
                ColorSequenceKeypoint.new(3/6,Color3.fromRGB(0,255,255)),
                ColorSequenceKeypoint.new(4/6,Color3.fromRGB(0,0,255)),
                ColorSequenceKeypoint.new(5/6,Color3.fromRGB(255,0,255)),
                ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0)),
            }
            HG.Parent=Base
            local Ov1=Instance.new("Frame")
            Ov1.Parent=parent
            Ov1.BackgroundColor3=Color3.new(1,1,1)
            Ov1.BorderSizePixel=0
            Ov1.Position=UDim2.new(0,0,0,0)
            Ov1.Size=UDim2.new(1,0,1,0)
            Ov1.ZIndex=baseZ+2
            local G1=Instance.new("UIGradient")
            G1.Rotation=0
            G1.Transparency=NumberSequence.new{
                NumberSequenceKeypoint.new(0,0),
                NumberSequenceKeypoint.new(1,1),
            }
            G1.Parent=Ov1
            local Ov2=Instance.new("Frame")
            Ov2.Parent=parent
            Ov2.BackgroundColor3=Color3.fromRGB(0,0,0)
            Ov2.BorderSizePixel=0
            Ov2.Position=UDim2.new(0,0,0,0)
            Ov2.Size=UDim2.new(1,0,1,0)
            Ov2.ZIndex=baseZ+3
            local G2=Instance.new("UIGradient")
            G2.Rotation=90
            G2.Transparency=NumberSequence.new{
                NumberSequenceKeypoint.new(0,1),
                NumberSequenceKeypoint.new(1,0),
            }
            G2.Parent=Ov2
        end
        --// SPACER (invisible grid cell for layout)
        function Elements:addSpacer()
            local S=Instance.new("Frame")
            S.Name="SPACER"
            S.Parent=Home
            S.BackgroundTransparency=1
            S.BorderSizePixel=0
            S.Size=UDim2.new(0,214,0,26)
            S.Active=false
            OrderSeq+=1
            S.LayoutOrder=OrderSeq
            return S
        end
        --// LABEL
        function Elements:addLabel(name,info)
            local o=type(name)=="table" and name or nil
            if o then name=o.Text or "" info=o.Info or o.Description or "" end
            local H=Instance.new("Frame")
            local C=Instance.new("UICorner")
            local T=Instance.new("TextLabel")
            local I=Instance.new("TextLabel")
            H.Parent=Home H.BackgroundColor3=Color3.fromRGB(23,23,23) H.BorderSizePixel=0 H.Size=UDim2.new(0,214,0,26)
            C.CornerRadius=UDim.new(0,5) C.Parent=H
            T.Parent=H T.BackgroundTransparency=1 T.Size=UDim2.new(1,0,0,17) T.Font=Enum.Font.GothamSemibold T.Text=name or "" T.TextColor3=Color3.new(1,1,1) T.TextSize=11
            I.Parent=H I.BackgroundTransparency=1 I.Position=UDim2.new(0,0,.55,0) I.Size=UDim2.new(1,0,0,11) I.Font=Enum.Font.GothamSemibold I.Text=info or "" I.TextColor3=Color3.new(1,1,1) I.TextTransparency=.3 I.TextSize=9
            RegisterElement(H,name,"Label")
            return H,T,I
        end
        --// BUTTON
        function Elements:addButton(name,callback)
            local H=Instance.new("Frame")
            local B=Instance.new("TextButton")
            local C=Instance.new("UICorner")
            H.Parent=Home
            H.BackgroundColor3=Color3.fromRGB(23,23,23)
            H.BorderSizePixel=0
            H.Size=UDim2.new(0,214,0,26)
            H.ClipsDescendants=true
            C.CornerRadius=UDim.new(0,5)
            C.Parent=H
            B.Parent=H
            B.BackgroundTransparency=1
            B.Size=UDim2.new(1,0,1,0)
            B.AutoButtonColor=false
            B.Font=Enum.Font.GothamSemibold
            B.Text=name or ""
            B.TextColor3=Color3.new(1,1,1)
            B.TextSize=11
            B.TextScaled=true
            local Dot=Instance.new("Frame")
            Dot.Parent=H
            Dot.BackgroundColor3=Color3.new(1,1,1)
            Dot.BorderSizePixel=0
            Dot.AnchorPoint=Vector2.new(.5,.5)
            Dot.Position=UDim2.new(.93,0,.5,0)
            Dot.Size=UDim2.new(0,5,0,5)
            RegTheme(Dot,"Dot")
            local DotC=Instance.new("UICorner")
            DotC.CornerRadius=UDim.new(1,0)
            DotC.Parent=Dot
B.MouseButton1Click:Connect(function() pcall(callback or function() end) end)
            RegisterElement(H,name,"Button")
            return H,B
        end
        --// TOGGLE
        function Elements:addToggle(name,a,b,c,d,e,f)
            local keybind,default,callback,picker,color,colorcb,keybindMode
            local keybindPicker=false
            local keybindRequiresToggle=false
            local holdToggle=false
            local toggleMode="Toggle"
            local hasBind=false
            if type(a)=="table" then
                local o=a
                name=o.Text or name
                keybind=o.Keybind
                keybindPicker=o.KeybindPicker==true
                hasBind=typeof(keybind)=="EnumItem" or keybindPicker or o.KeybindMode==true or o.KeybindRequiresToggle==true
                default=o.Default==true
                callback=o.Callback or function() end
                picker=o.ColorPicker==true or o.Picker==true
                color=o.Color or Color3.new(1,1,1)
                colorcb=o.ColorCallback or function() end
                keybindMode=o.KeybindMode==true
                keybindRequiresToggle=o.KeybindRequiresToggle==true
                holdToggle=o.HoldToggle==true
                if o.Mode=="Hold" then toggleMode="Hold" end
            elseif typeof(a)=="EnumItem" then
                keybind=a
                hasBind=true
                callback=b or function() end
                if typeof(c)=="boolean" then
                    default=c
                    picker=d or false
                    color=e
                    colorcb=f
                else
                    default=false
                    picker=c or false
                    color=d
                    colorcb=e
                end
            elseif typeof(a)=="boolean" then
                default=a
                callback=b or function() end
                picker=c or false
                color=d
                colorcb=e
            else
                default=false
                callback=a or function() end
                picker=b or false
                color=c
                colorcb=d
            end
            if type(a)~="table" then
                if typeof(f)=="boolean" and picker==false then
                    keybindMode=f
                elseif typeof(e)=="boolean"
                and picker==false
                and color==nil then
                    keybindMode=e
                elseif typeof(d)=="boolean"
                and picker==false
                and color==nil then
                    keybindMode=d
                else
                    keybindMode=false
                end
            end
            if typeof(a)=="EnumItem"
            and typeof(c)=="boolean"
            and d==nil
            and e==nil
            and f==nil then
                keybindMode=c
                default=false
                picker=false
                color=Color3.new(1,1,1)
                colorcb=function() end
            end
            default=default or false
            color=color or Color3.new(1,1,1)
            colorcb=colorcb or function() end
            keybindMode=keybindMode==true
            keybindRequiresToggle=keybindRequiresToggle==true
            holdToggle=holdToggle==true
            local H=Instance.new("Frame")
            local HC=Instance.new("UICorner")
            local T=Instance.new("TextLabel")
            local TB=Instance.new("TextButton")
            local TF=Instance.new("Frame")
            local TFC=Instance.new("UICorner")
            local Ball=Instance.new("Frame")
            local BC=Instance.new("UICorner")
            local Bind=Instance.new("TextButton")
            local BindC=Instance.new("UICorner")
            H.Parent=Home
            H.BackgroundColor3=Color3.fromRGB(23,23,23)
            H.BorderSizePixel=0
            H.Size=UDim2.new(0,214,0,26)
            H.ClipsDescendants=false
            HC.CornerRadius=UDim.new(0,5)
            HC.Parent=H
            T.Parent=H
            T.BackgroundTransparency=1
            T.Position=UDim2.new(.04,0,0,0)
            T.Size=picker and UDim2.new(0,112,0,26) or UDim2.new(0,134,0,26)
            T.Font=Enum.Font.GothamSemibold
            T.Text=name or ""
            T.TextColor3=Color3.fromRGB(235,235,235)
            T.TextSize=10
            T.TextXAlignment=Enum.TextXAlignment.Left
            T.TextScaled=true
            T.ClipsDescendants=true
            Bind.Parent=H
            Bind.BackgroundTransparency=1
            Bind.BorderSizePixel=0
            Bind.Position=picker and UDim2.new(.58,0,0,4) or UDim2.new(.72,0,0,4)
            Bind.Size=UDim2.new(0,18,0,18)
            Bind.Font=Enum.Font.GothamSemibold
            Bind.Text=""
            Bind.TextTransparency=1
            Bind.TextSize=9
            Bind.Visible=true
            Bind.AutoButtonColor=false
            local BindDia=Instance.new("Frame")
            BindDia.Parent=Bind
            BindDia.BackgroundTransparency=1
            BindDia.AnchorPoint=Vector2.new(.5,.5)
            BindDia.Position=UDim2.new(.5,0,.5,0)
            BindDia.Size=UDim2.new(0,9,0,9)
            BindDia.Rotation=45
            local BindStroke=Instance.new("UIStroke")
            BindStroke.Color=Color3.new(1,1,1)
            BindStroke.Thickness=1.5
            BindStroke.Parent=BindDia
            BindC.CornerRadius=UDim.new(0,4)
            BindC.Parent=Bind
            local ModeButton
            local ModeMenu
            local ToggleChoice
            local HoldChoice
            local SetMode
            if holdToggle then
                ModeButton=Instance.new("TextButton")
                ModeButton.Parent=H
                ModeButton.BackgroundColor3=Color3.fromRGB(25,25,25)
                ModeButton.Position=UDim2.new(.61,0,0,5)
                ModeButton.Size=UDim2.new(0,43,0,20)
                ModeButton.Font=Enum.Font.GothamSemibold
                ModeButton.Text="Toggle"
                ModeButton.TextColor3=Color3.fromRGB(150,150,150)
                ModeButton.TextSize=9
                ModeButton.AutoButtonColor=false
                ModeButton.ZIndex=51
                local MC=Instance.new("UICorner")
                MC.CornerRadius=UDim.new(0,4)
                MC.Parent=ModeButton
                ModeMenu=Instance.new("Frame")
                ModeMenu.Parent=H
                ModeMenu.BackgroundColor3=Color3.fromRGB(25,25,25)
                ModeMenu.Position=UDim2.new(.61,0,0,28)
                ModeMenu.Size=UDim2.new(0,43,0,48)
                ModeMenu.Visible=false
                ModeMenu.BorderSizePixel=0
                ModeMenu.ZIndex=70
                local MMC=Instance.new("UICorner")
                MMC.CornerRadius=UDim.new(0,4)
                MMC.Parent=ModeMenu
                ToggleChoice=Instance.new("TextButton")
                ToggleChoice.Parent=ModeMenu
                ToggleChoice.BackgroundTransparency=1
                ToggleChoice.Size=UDim2.new(1,0,0,24)
                ToggleChoice.Font=Enum.Font.GothamSemibold
                ToggleChoice.Text="Toggle"
                ToggleChoice.TextColor3=Color3.new(1,1,1)
                ToggleChoice.TextSize=9
                ToggleChoice.ZIndex=71
                HoldChoice=Instance.new("TextButton")
                HoldChoice.Parent=ModeMenu
                HoldChoice.BackgroundTransparency=1
                HoldChoice.Position=UDim2.new(0,0,0,24)
                HoldChoice.Size=UDim2.new(1,0,0,24)
                HoldChoice.Font=Enum.Font.GothamSemibold
                HoldChoice.Text="Hold"
                HoldChoice.TextColor3=Color3.new(1,1,1)
                HoldChoice.TextSize=9
                HoldChoice.ZIndex=71
                local modeOpen=false
            end
            local currentBind=
                (keybind and keybind~=Enum.KeyCode.Unknown)
                and keybind
                or nil
            -- diamond icon shows no text; assignments shown in Hotkeys list
            TB.Parent=H
            TB.BackgroundTransparency=1
            TB.Text=""
            TB.TextTransparency=1
            TB.Position=UDim2.new(.84,0,0,0)
            TB.Size=UDim2.new(0,34,0,26)
            TB.AutoButtonColor=false
            TF.Parent=TB
            TF.BackgroundColor3=Color3.fromRGB(35,35,35)
            TF.BorderSizePixel=0
            TF.Position=UDim2.new(.5,0,.5,0)
            TF.AnchorPoint=Vector2.new(.5,.5)
            TF.Size=UDim2.new(0,16,0,16)
            TFC.Parent=TF
            TFC.CornerRadius=UDim.new(0,4)
            local TFStroke=Instance.new("UIStroke")
            TFStroke.Color=Color3.fromRGB(70,70,70)
            TFStroke.Parent=TF
            local Check1=Instance.new("Frame")
            Check1.Parent=TF
            Check1.BackgroundColor3=Color3.new(1,1,1)
            Check1.BorderSizePixel=0
            Check1.AnchorPoint=Vector2.new(.5,.5)
            Check1.Position=UDim2.new(.38,0,.56,0)
            Check1.Size=UDim2.new(0,2,0,6)
            Check1.Rotation=-40
            Check1.Visible=default
            local Check2=Instance.new("Frame")
            Check2.Parent=TF
            Check2.BackgroundColor3=Color3.new(1,1,1)
            Check2.BorderSizePixel=0
            Check2.AnchorPoint=Vector2.new(.5,.5)
            Check2.Position=UDim2.new(.62,0,.47,0)
            Check2.Size=UDim2.new(0,2,0,10)
            Check2.Rotation=40
            Check2.Visible=default
            local armed=default
            local active=keybindMode and false or default
            local closePicker
            local Row
            local function UpdateSwitchVisual()
                local on=(keybindMode or keybindRequiresToggle) and armed or active
                TF.BackgroundColor3=
                    on
                    and Color3.fromRGB(50,50,50)
                    or Color3.fromRGB(35,35,35)
                Check1.Visible=on
                Check2.Visible=on
            end
            local function RemoveRightRow()
                if Row then
                    Row:Destroy()
                    Row=nil
                end
                ActiveToggleRows[H]=nil
                UpdateTogglePanel()
            end
            local function AddRightRow()
                if Row and Row.Parent then return end
                Row=Instance.new("TextLabel")
                Row.Parent=ToggleList
                Row.BackgroundColor3=Color3.fromRGB(20,20,20)
                Row.BorderSizePixel=0
                Row.Size=UDim2.new(1,0,0,24)
                Row.Font=Enum.Font.GothamSemibold
                Row.TextColor3=Color3.new(1,1,1)
                Row.TextSize=8
                Row.TextXAlignment=Enum.TextXAlignment.Left
                Row.ZIndex=202
                local RC=Instance.new("UICorner")
                RC.CornerRadius=UDim.new(0,4)
                RC.Parent=Row
                local RP=Instance.new("UIPadding")
                RP.PaddingLeft=UDim.new(0,6)
                RP.Parent=Row
                ActiveToggleRows[H]=Row
                UpdateTogglePanel()
            end
            local function UpdateRightRow()
                local shouldShow=
                    (keybindMode or keybindRequiresToggle)
                    and armed
                    or active
                if not shouldShow then
                    RemoveRightRow()
                    return
                end
                AddRightRow()
                if Row then
                    local stateText=
                        active
                        and "ON"
                        or "OFF"
                    local bindText=
                        currentBind
and currentBind.Name:gsub("MouseButton", "MB")
                        or "None"
                    Row.Text=
                        (name or "Toggle")
                        .."  ["
                        ..bindText
                        .."] "
                        ..stateText
                    Row.TextColor3=
                        active
and Color3.new(1,1,1)
or Color3.fromRGB(170, 170, 170)
                end
            end
            local function SetActive(v,callCallback)
                v=v==true
                active=v
                if callCallback~=false then pcall(callback,active) end
                UpdateRightRow()
                UpdateSwitchVisual()
            end
            local function SetArmed(v,callCallback)
                v=v==true
                armed=v
                if keybindRequiresToggle and not keybindMode then active=armed end
                if not armed and active then
                    active=false
                    if callCallback~=false then pcall(callback,false) end
                end
                if not armed and closePicker then closePicker() end
                UpdateRightRow()
                UpdateSwitchVisual()
                if callCallback~=false
                and (not keybindMode or keybindRequiresToggle) then
                    pcall(callback,armed)
                end
                task.defer(UpdateCanvas)
            end
            local function UpdateNormal()
                if not active and closePicker then closePicker() end
                UpdateRightRow()
                UpdateSwitchVisual()
                pcall(callback,active)
                if SettingsState and SettingsState.AlwaysTrigger and Library.Notify then pcall(function() Library:Notify(tostring(name).." turned "..(active and "on" or "off")) end) end
                task.defer(UpdateCanvas)
            end
            local modeOpen=false
            SetMode=function(mode)
                local newMode=mode=="Hold" and "Hold" or "Toggle"
                if toggleMode==newMode then
                    if ModeButton then ModeButton.Text=toggleMode end
                    if ModeMenu then ModeMenu.Visible=false end
                    modeOpen=false
                    UpdateRightRow()
                    UpdateSwitchVisual()
                    return
                end
                toggleMode=newMode
                if ModeButton then ModeButton.Text=toggleMode end
                if ModeMenu then ModeMenu.Visible=false end
                modeOpen=false
                if active then SetActive(false,true) else UpdateRightRow() UpdateSwitchVisual() end
            end
            if ModeButton then
                ModeButton.MouseButton1Click:Connect(function() modeOpen=not modeOpen ModeMenu.Visible=modeOpen H.Size=UDim2.new(0,214,0,modeOpen and 74 or 26) task.defer(UpdateCanvas) end)
                ToggleChoice.MouseButton1Click:Connect(function() SetMode("Toggle") H.Size=UDim2.new(0,214,0,26) task.defer(UpdateCanvas) end)
                HoldChoice.MouseButton1Click:Connect(function() SetMode("Hold") H.Size=UDim2.new(0,214,0,26) task.defer(UpdateCanvas) end)
            end
            local mainPress=false
            TB.InputBegan:Connect(function(i)
                if i.UserInputType~=Enum.UserInputType.MouseButton1
                and i.UserInputType~=Enum.UserInputType.Touch then
                    return
                end
                mainPress=true
                if keybindMode or keybindRequiresToggle then
                    SetArmed(not armed,true)
                elseif toggleMode=="Hold" then
                    SetActive(true,true)
                end
            end)
            TB.InputEnded:Connect(function(i)
                if i.UserInputType~=Enum.UserInputType.MouseButton1
                and i.UserInputType~=Enum.UserInputType.Touch then
                    return
                end
                if not mainPress then return end
                mainPress=false
                if keybindMode or keybindRequiresToggle then
                    -- Master toggle is always a normal on/off switch.
                elseif toggleMode=="Hold" then
                    SetActive(false,true)
                else
                    active=not active
                    UpdateNormal()
                end
            end)
            --// COLOR PICKER
            if picker then
                local CB=Instance.new("TextButton")
                local CBC=Instance.new("UICorner")
                local Panel=Instance.new("Frame")
                local PC=Instance.new("UICorner")
                local Canvas=Instance.new("Frame")
                local Circle=Instance.new("Frame")
                local CC=Instance.new("UICorner")
                CB.Parent=H
                CB.BackgroundColor3=color
                CB.Position=UDim2.new(.69,0,0,5)
                CB.Size=UDim2.new(0,20,0,20)
                CB.Text=""
                CB.ZIndex=50
                CBC.CornerRadius=UDim.new(0,4)
                CBC.Parent=CB
                Panel.Parent=Gui
                Panel.BackgroundColor3=Color3.fromRGB(25,25,25)
                Panel.Position=UDim2.new(0,0,0,0)
                Panel.Size=UDim2.new(0,210,0,110)
                Panel.Visible=false
                Panel.ZIndex=60
                Panel.BorderSizePixel=0
                Panel.Active=true
                PC.CornerRadius=UDim.new(0,6)
                PC.Parent=Panel
                Canvas.Parent=Panel
                Canvas.BackgroundColor3=Color3.fromRGB(0,0,0)
                Canvas.BorderSizePixel=0
                Canvas.Position=UDim2.new(0,8,0,8)
                Canvas.Size=UDim2.new(1,-16,1,-16)
                Canvas.ZIndex=61
                Canvas.ClipsDescendants=true
                BuildHSVGrid(Canvas,61)
                Circle.Parent=Canvas
                Circle.AnchorPoint=Vector2.new(.5,.5)
                Circle.BackgroundColor3=color
                Circle.BorderColor3=Color3.new(0,0,0)
                Circle.BorderSizePixel=2
                Circle.Size=UDim2.new(0,10,0,10)
                Circle.ZIndex=65
                Circle.Position=UDim2.new(.5,0,.5,0)
                CC.CornerRadius=UDim.new(1,0)
                CC.Parent=Circle
                local open=false
                closePicker=function()
                    open=false
                    Panel.Visible=false
                    H.Size=UDim2.new(0,214,0,26)
                    task.defer(UpdateCanvas)
                end
                local function PositionPicker()
                    if not H.Parent then return end
                    local hp=H.AbsolutePosition
                    local vp=Gui.AbsoluteSize
                    local x=hp.X+H.AbsoluteSize.X+8
                    local y=hp.Y
                    Panel.Position=UDim2.fromOffset(math.clamp(x,4,math.max(4,vp.X-214)),math.clamp(y,4,math.max(4,vp.Y-114)))
                end
                CB.MouseButton1Click:Connect(function()
                    open=not open
                    if open then
                        PositionPicker()
                        Panel.Visible=true
                        Circle.BackgroundColor3=color
                    else
                        Panel.Visible=false
                    end
                    CB.BackgroundColor3=color
                    H.Size=UDim2.new(0,214,0,26)
                    task.defer(UpdateCanvas)
                end)
                local colorDrag=false
                local function SetColor(i)
                    local s=Canvas.AbsoluteSize
                    local p=Canvas.AbsolutePosition
                    if s.X<=0 or s.Y<=0 then return end
local x=math.clamp((i.Position.X-p.X)/s.X, 0, 1)
local y=math.clamp((i.Position.Y-p.Y)/s.Y, 0, 1)
                    Circle.Position=UDim2.new(x,0,y,0)
color=Color3.fromHSV(x, x, 1-y)
                    CB.BackgroundColor3=color
                    Circle.BackgroundColor3=color
                    pcall(colorcb,color)
                end
                Canvas.InputBegan:Connect(function(i)
                    if i.UserInputType==
                        Enum.UserInputType.MouseButton1
                    or i.UserInputType==
                        Enum.UserInputType.Touch then
                        colorDrag=true
                        SetColor(i)
                    end
                end)
                UIS.InputChanged:Connect(function(i)
                    if colorDrag
and (i.UserInputType== Enum.UserInputType.MouseMovement or i.UserInputType== Enum.UserInputType.Touch) then
                        SetColor(i)
                    end
                end)
UIS.InputEnded:Connect(function(i) if i.UserInputType== Enum.UserInputType.MouseButton1 or i.UserInputType== Enum.UserInputType.Touch then colorDrag=false end end)
                RegisterConfig(
                    name.."_Color",
                    "Color3",
                    function()
                        return color
                    end,
                    function(v)
                        local cc=TableToColor(v)
                        if cc then
                            color=cc
                            CB.BackgroundColor3=color
                            Circle.BackgroundColor3=color
                            pcall(colorcb,color)
                        end
                    end
)
            end
            --// TOUCH SHORTCUT
            if UIS.TouchEnabled and not keybindPicker then
                local ShortcutButton=nil
                local ShortcutDragConn=nil
                local function RemoveShortcut()
                    if ShortcutDragConn then
                        ShortcutDragConn:Disconnect()
                        ShortcutDragConn=nil
                    end
                    if ShortcutButton then
                        ShortcutButton:Destroy()
                        ShortcutButton=nil
                    end
                    Bind:SetAttribute("Shown",false)
                    Bind.Text="Show"
                end
                Bind.MouseButton1Click:Connect(function()
                    if Bind:GetAttribute("Shown") then
                        RemoveShortcut()
                        return
                    end
                    Bind:SetAttribute("Shown",true)
                    Bind.Text="Hide"
                    local SB=Instance.new("TextButton")
                    local SC=Instance.new("UICorner")
                    ShortcutButton=SB
                    SB.Parent=Gui
                    SB.Name=(name or "Toggle").."_Shortcut"
                    SB.Size=UDim2.new(0,78,0,30)
                    SB.Position=UDim2.new(1,-90,0,.35)
                    SB.Font=Enum.Font.GothamBold
                    SB.Text=name or "Toggle"
                    SB.TextSize=9
                    SB.TextWrapped=true
                    SB.BackgroundColor3=active
                        and Color3.fromRGB(40,140,70)
                        or Color3.fromRGB(30,30,30)
                    SB.TextColor3=Color3.fromRGB(160,160,160)
                    SB.ZIndex=250
                    SB.Active=true
                    SB.AutoButtonColor=false
                    SC.CornerRadius=UDim.new(0,5)
                    SC.Parent=SB
                    --// SHORTCUT DRAG
                    local dragging=false
                    local moved=false
                    local dragInput=nil
                    local dragStart=nil
                    local startPos=nil
                    SB.InputBegan:Connect(function(i)
                        if i.UserInputType==Enum.UserInputType.MouseButton1
                        or i.UserInputType==Enum.UserInputType.Touch then
                            dragging=true
                            moved=false
                            dragStart=i.Position
                            startPos=SB.Position
i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
                        end
                    end)
SB.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end end)
                    ShortcutDragConn=UIS.InputChanged:Connect(function(i)
                        if i==dragInput and dragging and ShortcutButton==SB then
                            local d=i.Position-dragStart
                            if math.abs(d.X)>5 or math.abs(d.Y)>5 then moved=true end
SB.Position=UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
                        end
                    end)
                    local shortcutPress=false
                    SB.InputBegan:Connect(function(i)
                        if i.UserInputType~=Enum.UserInputType.MouseButton1
                        and i.UserInputType~=Enum.UserInputType.Touch then
                            return
                        end
                        if moved or ShortcutButton~=SB then return end
                        shortcutPress=true
                        if keybindRequiresToggle and not keybindMode and not armed then return end
                        if keybindMode then
                            if armed and toggleMode=="Hold" then SetActive(true,true) end
                        elseif toggleMode=="Hold" then
                            SetActive(true,true)
                        end
                    end)
                    SB.InputEnded:Connect(function(i)
                        if i.UserInputType~=Enum.UserInputType.MouseButton1
                        and i.UserInputType~=Enum.UserInputType.Touch then
                            return
                        end
                        if not shortcutPress or moved or ShortcutButton~=SB then return end
                        shortcutPress=false
                        if keybindRequiresToggle and not keybindMode and not armed then return end
                        if keybindMode then
                            if armed then
                                if toggleMode=="Hold" then
                                    SetActive(false,true)
                                else
                                    SetActive(not active,true)
                                end
                            end
                        elseif toggleMode=="Hold" then
                            SetActive(false,true)
                        else
                            active=not active
                            UpdateNormal()
                        end
                        SB.BackgroundColor3=
                            active
                            and Color3.fromRGB(40,140,70)
                            or Color3.fromRGB(30,30,30)
                        SB.TextColor3=Color3.new(1,1,1)
                    end)
                end)
            else
                -- diamond opens the keybind editor popup
Bind.MouseButton1Click:Connect(function()
    OpenKeybindPopup({
        Anchor=Bind,
        Label=tostring(name or "Toggle"),
        GetBind=function() return currentBind end,
        SetBind=function(k) currentBind=k UpdateRightRow() RefreshHotkeys() end,
        HasMode=holdToggle,
        GetMode=function() return toggleMode end,
        SetModeFn=function(m) SetMode(m) end,
    })
end)
                UIS.InputBegan:Connect(function(i,gp)
                    if not gp and currentBind then
                        local match=
(currentBind.EnumType== Enum.KeyCode and i.KeyCode==currentBind)
                            or
(currentBind.EnumType== Enum.UserInputType and i.UserInputType== currentBind)
                        if match then
                            if keybindRequiresToggle and not keybindMode and not armed then return end
                            if keybindMode then
                                if armed then
                                    if toggleMode=="Hold" then
                                        SetActive(true,true)
                                    else
                                        SetActive(not active,true)
                                    end
                                end
                            elseif toggleMode=="Hold" then
                                SetActive(true,true)
                            else
                                active=not active
                                UpdateNormal()
                            end
                        end
                    end
                end)
            end
            if hasBind and not UIS.TouchEnabled then
                UIS.InputEnded:Connect(function(i)
                    if toggleMode~="Hold" or not currentBind then return end
                    local match=
(currentBind.EnumType==Enum.KeyCode and i.KeyCode==currentBind)
                        or
(currentBind.EnumType==Enum.UserInputType and i.UserInputType==currentBind)
                    if match then
                        if keybindMode then
                            if armed then SetActive(false,true) end
                        else
                            SetActive(false,true)
                        end
                    end
                end)
            end
            --// INITIAL STATE
            if keybindMode then
                active=false
                pcall(callback,false)
            elseif keybindRequiresToggle then
                active=default
                pcall(callback,active)
            else
                active=default
                pcall(callback,active)
            end
            UpdateRightRow()
            UpdateSwitchVisual()
            RegisterElement(H,name,"Toggle")
            RegisterConfig(
                name,
                "Toggle",
                function()
                    return {
                        Enabled=armed,
                        Active=active,
                        Keybind=SerializeBind(currentBind),
                        KeybindMode=keybindMode,
                        KeybindRequiresToggle=keybindRequiresToggle,
                        ToggleMode=toggleMode,
                        HoldToggle=holdToggle
                    }
                end,
                function(v)
                    if type(v)=="boolean" then
                        armed=v
                        if keybindMode or keybindRequiresToggle then
                            active=false
                        else
                            active=v
                        end
                    elseif type(v)=="table" then
                        armed=v.Enabled==true
                        if holdToggle and (v.ToggleMode=="Hold" or v.ToggleMode=="Toggle") then
                            toggleMode=v.ToggleMode
                            if ModeButton then ModeButton.Text=toggleMode end
                            if keybindMode and toggleMode=="Hold" and active then
                                active=false
                                pcall(callback,false)
                            end
                        end
                        if v.Keybind~=nil then
                            local newBind=
DeserializeBind(v.Keybind)
                            if newBind then
                                currentBind=newBind
                                if not UIS.TouchEnabled then
                                    Bind.Text=
currentBind.Name:gsub("MouseButton", "MB")
                                end
                            end
                        elseif v.Keybind==false then
                            currentBind=nil
                            Bind.Text="None"
                        end
                        if keybindMode then
                            active=
                                v.Active==true
                                and armed
                        elseif keybindRequiresToggle then
                            active=v.Active==true
                        else
                            if v.Active~=nil then
                                active=v.Active==true
                            else
                                active=armed
                            end
                        end
                    end
                    pcall(callback,active)
                    UpdateRightRow()
                    UpdateSwitchVisual()
                end
)
            return H
        end
        --// SLIDER
        function Elements:addSlider(name,a,b,c,d)
            local min,max,value,callback,rounding
            if type(a)=="table" then
                local o=a
                name=o.Text or name
                min=tonumber(o.Min) or 0
                max=tonumber(o.Max) or 100
                value=tonumber(o.Default)
                rounding=math.max(0,math.floor(tonumber(o.Rounding) or 0))
                callback=o.Callback or function() end
            else
                min=tonumber(a) or 0
                max=tonumber(b) or 100
                callback=c or function() end
                value=tonumber(d)
                rounding=0
            end
            if max<min then min,max=max,min end
            local step=10^-rounding
            local function roundValue(v)
                v=tonumber(v) or min
                v=math.clamp(v,min,max)
                if rounding>0 then
                    v=math.round(v/step)*step
                    v=math.clamp(v,min,max)
                else
                    v=math.floor(v+0.5)
                    v=math.clamp(v,min,max)
                end
                return v
            end
            value=roundValue(value or min)
            local function formatValue(v)
                if rounding<=0 then return tostring(math.floor(v+0.5)) end
                local text=string.format("%."..rounding.."f",v)
                text=text:gsub("(%..-)0+$","%1"):gsub("%.$","")
                return text
            end
            local H=Instance.new("Frame")
            local C=Instance.new("UICorner")
            local T=Instance.new("TextLabel")
            local B=Instance.new("TextButton")
            local BC=Instance.new("UICorner")
            local Trail=Instance.new("Frame")
            local TC=Instance.new("UICorner")
            local Knob=Instance.new("Frame")
            local KC=Instance.new("UICorner")
            local Num=Instance.new("TextBox")
            do
                local fc=0
                for _,c in ipairs(Home:GetChildren()) do if c:IsA("Frame") then fc+=1 end end
                if fc%2==1 then
                    local SP=Instance.new("Frame")
                    SP.Name="SPACER"
                    SP.Parent=Home SP.BackgroundTransparency=1 SP.BorderSizePixel=0 SP.Size=UDim2.new(0,214,0,26) SP.Active=false
                    OrderSeq+=1
                    SP.LayoutOrder=OrderSeq
                end
            end
            H.Parent=Home
            H.BackgroundColor3=Color3.fromRGB(23,23,23)
            H.BorderSizePixel=0
            H.Size=UDim2.new(0,434,0,26)
            H.ClipsDescendants=true
            do
                local SP2=Instance.new("Frame")
                SP2.Name="SPACER"
                SP2.Parent=Home SP2.BackgroundTransparency=1 SP2.BorderSizePixel=0 SP2.Size=UDim2.new(0,214,0,26) SP2.Active=false
                OrderSeq+=1
                SP2.LayoutOrder=OrderSeq
            end
            C.CornerRadius=UDim.new(0,5)
            C.Parent=H
            T.Parent=H
            T.BackgroundTransparency=1
            T.Position=UDim2.new(.024,0,0,3)
            T.Size=UDim2.new(0,160,0,10)
            T.Font=Enum.Font.GothamSemibold
            T.Text=name or ""
            T.TextColor3=Color3.new(1,1,1)
            T.TextSize=11
            T.TextXAlignment=Enum.TextXAlignment.Left
            T.TextScaled=true
            T.ClipsDescendants=true
            Num.Parent=H
            Num.BackgroundColor3=Color3.fromRGB(10,10,10)
            Num.BorderSizePixel=0
            Num.Position=UDim2.new(.80,0,0,2)
            Num.Size=UDim2.new(0,36,0,13)
            Num.Font=Enum.Font.GothamSemibold
            Num.Text=formatValue(value)
            Num.TextColor3=Color3.fromRGB(235,235,235)
            Num.TextSize=10
            Num.TextEditable=true
            Num.ZIndex=5
            Num.TextXAlignment=Enum.TextXAlignment.Center
            Num.ClearTextOnFocus=false
            local NumC=Instance.new("UICorner")
            NumC.CornerRadius=UDim.new(0,4)
            NumC.Parent=Num
            B.Parent=H
            B.BackgroundColor3=Color3.fromRGB(5,5,5)
            B.BorderSizePixel=0
            B.Position=UDim2.new(0,8,0,19)
            B.Size=UDim2.new(1,-16,0,7)
            B.Text=""
            B.AutoButtonColor=false
            B.Active=true
            BC.CornerRadius=UDim.new(0,4)
            BC.Parent=B
            Trail.Parent=B
            Trail.BackgroundColor3=Color3.new(1,1,1)
            Trail.Size=UDim2.new(0,0,1,0)
            Trail.ZIndex=2
            RegTheme(Trail,"Accent")
            TC.CornerRadius=UDim.new(0,4)
            TC.Parent=Trail
            Knob.Parent=B
            Knob.BackgroundColor3=Color3.fromRGB(235,235,235)
            Knob.Size=UDim2.new(0,12,0,12)
            Knob.AnchorPoint=Vector2.new(.5,.5)
            Knob.Position=UDim2.new(0,0,.5,0)
            Knob.ZIndex=4
            Knob.Visible=false
            KC.CornerRadius=UDim.new(1,0)
            KC.Parent=Knob
            local function Set(v,callCallback)
                value=roundValue(v)
                Num.Text=formatValue(value)
                local p=max==min and 0 or (value-min)/(max-min)
                p=math.clamp(p,0,1)
                Trail.Size=UDim2.new(p,0,1,0)
                Knob.Position=UDim2.new(p,0,.5,0)
                if callCallback~=false then pcall(callback,value) end
                task.defer(UpdateCanvas)
            end
            local moving=false
            local moveInput=nil
            local function UpdateFromX(x)
                if B.AbsoluteSize.X<=0 then return end
local p=math.clamp((x-B.AbsolutePosition.X)/B.AbsoluteSize.X, 0,1)
                Set(min+(max-min)*p,true)
            end
B.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then moving=true moveInput=i UpdateFromX(i.Position.X) end end)
B.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then moveInput=i end end)
UIS.InputChanged:Connect(function(i) if not moving or not moveInput then return end if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then UpdateFromX(i.Position.X) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then moving=false moveInput=nil end end)
            Num.FocusLost:Connect(function()
local typed=tonumber(tostring(Num.Text):gsub("%s+",""))
                if typed==nil then
                    Num.Text=formatValue(value)
                    return
                end
                Set(typed,true)
            end)
Num.Focused:Connect(function() task.defer(function() Num.CursorPosition=#Num.Text+1 end) end)
            Set(value,false)
            RegisterElement(H,name,"Slider")
            RegisterConfig(
                name,
                "Slider",
                function()
                    return value
                end,
                function(v)
                    Set(v,true)
                end
)
            return H
        end
        --// TEXTBOX
        function Elements:addTextBox(name,default,callback)
            local o=type(default)=="table" and default or nil
            if o then name=o.Text or name default=o.Default or "" callback=o.Callback end
            callback=callback or function() end
            local H=Instance.new("Frame") local C=Instance.new("UICorner") local T=Instance.new("TextLabel") local B=Instance.new("TextBox") local BC=Instance.new("UICorner")
            H.Parent=Home H.BackgroundColor3=Color3.fromRGB(23,23,23) H.BorderSizePixel=0 H.Size=UDim2.new(0,214,0,26)
            C.CornerRadius=UDim.new(0,5) C.Parent=H
            T.Parent=H T.BackgroundTransparency=1 T.Position=UDim2.new(.024,0,0,3) T.Size=UDim2.new(0,90,0,24) T.Font=Enum.Font.GothamSemibold T.Text=name or "" T.TextColor3=Color3.new(1,1,1) T.TextSize=11 T.TextXAlignment=Enum.TextXAlignment.Left T.TextScaled=true T.ClipsDescendants=true
            B.Parent=H B.BackgroundColor3=Color3.fromRGB(5,5,5) B.Position=UDim2.new(.45,0,0,5) B.Size=UDim2.new(0,110,0,20) B.Font=Enum.Font.GothamSemibold B.Text=tostring(default or "") B.TextColor3=Color3.new(1,1,1) B.TextSize=9 B.ClearTextOnFocus=false B.TextXAlignment=Enum.TextXAlignment.Center B.PlaceholderText=(o and o.Placeholder) or ""
            BC.CornerRadius=UDim.new(0,5) BC.Parent=B
            B.FocusLost:Connect(function() pcall(callback,B.Text) end)
            RegisterElement(H,name,"TextBox")
            RegisterConfig(name,"TextBox",function() return B.Text end,function(v) B.Text=tostring(v or "") pcall(callback,B.Text) end)
            return H,B
        end
        --// DROPDOWN
        function Elements:addDropdown(name,list,scrollsize,callback)
            local o=type(list)=="table" and (list.Values~=nil or list.Text~=nil or list.Callback~=nil or list.Default~=nil or list.MultiSelect~=nil) and list or nil
            if o then name=o.Text or name list=o.Values or {} callback=o.Callback scrollsize=o.ScrollSize end
            list=list or {} callback=callback or function() end
            local multi=o and o.MultiSelect==true or false
            local H=Instance.new("Frame") local C=Instance.new("UICorner") local T=Instance.new("TextLabel") local B=Instance.new("TextButton") local Icon=Instance.new("ImageLabel") local Panel=Instance.new("Frame") local PC=Instance.new("UICorner") local Scroll=Instance.new("ScrollingFrame") local Layout=Instance.new("UIListLayout")
            H.Parent=Home H.BackgroundColor3=Color3.fromRGB(23,23,23) H.BorderSizePixel=0 H.Size=UDim2.new(0,214,0,26) H.ClipsDescendants=false
            C.CornerRadius=UDim.new(0,5) C.Parent=H
            T.Parent=H T.BackgroundTransparency=1 T.Position=UDim2.new(.024,0,0,2) T.Size=UDim2.new(0,140,0,26) T.Font=Enum.Font.GothamSemibold T.Text=name or "" T.TextColor3=Color3.new(1,1,1) T.TextSize=11 T.TextXAlignment=Enum.TextXAlignment.Left T.TextScaled=true T.ClipsDescendants=true
            B.Parent=H B.BackgroundTransparency=1 B.Size=UDim2.new(1,0,0,30) B.Text="" B.AutoButtonColor=false
            Icon.Visible=false
            local function MakeHam(y)
                local Bar=Instance.new("Frame")
                Bar.Parent=H
                Bar.BackgroundColor3=Color3.new(1,1,1)
                Bar.BorderSizePixel=0
                Bar.Position=UDim2.new(.84,0,0,y)
                Bar.Size=UDim2.new(0,14,0,2)
                return Bar
            end
            MakeHam(8) MakeHam(12) MakeHam(16)
            Panel.Parent=H Panel.BackgroundColor3=Color3.fromRGB(23,23,23) Panel.Position=UDim2.new(0,0,0,30) Panel.Size=UDim2.new(0,214,0,115) Panel.BorderSizePixel=0 Panel.Visible=false Panel.ZIndex=100 Panel.Active=true
            PC.CornerRadius=UDim.new(0,6) PC.Parent=Panel
            Scroll.Parent=Panel Scroll.BackgroundTransparency=1 Scroll.BorderSizePixel=0 Scroll.Position=UDim2.new(0,4,0,5) Scroll.Size=UDim2.new(1,-8,1,-10) Scroll.ScrollBarThickness=2 Scroll.ScrollBarImageColor3=Color3.fromRGB(70,70,70) Scroll.ZIndex=101
            Layout.Parent=Scroll Layout.HorizontalAlignment=Enum.HorizontalAlignment.Center Layout.SortOrder=Enum.SortOrder.LayoutOrder Layout.Padding=UDim.new(0,5)
            local open=false local selected=nil local values={} local selections={}
            local function canvas() Scroll.CanvasSize=UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y+8) end
            local function close() open=false Panel.Visible=false H.Size=UDim2.new(0,214,0,26) Icon.ImageColor3=Color3.new(1,1,1) task.defer(UpdateCanvas) end
            local function visual(btn,v)
                local yes=multi and selections[v] or selected==v
                btn.BackgroundColor3=yes and CurrentTheme.Accent or Color3.fromRGB(15,15,15)
                btn.TextColor3=yes and Color3.fromRGB(10,10,10) or Color3.new(1,1,1)
            end
            local function get()
                if not multi then return selected end
                local r={} for _,v in ipairs(values) do if selections[v] then r[v]=true end end return r
            end
            local function set(v,fire)
                if multi then
                    selections={}
                    if type(v)=="table" then for k,x in pairs(v) do if x==true then selections[k]=true end end elseif v~=nil then selections[v]=true end
                    local names={} for _,x in ipairs(values) do if selections[x] then table.insert(names,tostring(x)) end end
                    T.Text=#names>0 and table.concat(names,", ") or tostring(name)
                    for _,ch in ipairs(Scroll:GetChildren()) do if ch:IsA("TextButton") then for _,x in ipairs(values) do if ch.Text==tostring(x) then visual(ch,x) break end end end end
                    if fire then pcall(callback,selections) end
                else
                    for _,x in ipairs(values) do if tostring(x)==tostring(v) then selected=x T.Text=tostring(name).." - "..tostring(x) for _,ch in ipairs(Scroll:GetChildren()) do if ch:IsA("TextButton") then visual(ch,x) end end if fire then pcall(callback,x) end return end end
                end
            end
            B.MouseButton1Click:Connect(function() open=not open Panel.Visible=open H.Size=UDim2.new(0,214,0,open and 145 or 26) Icon.ImageColor3=open and Color3.new(1,1,1) or Color3.new(1,1,1) task.defer(UpdateCanvas) end)
            local function build(valuesList)
                values={} for _,ch in ipairs(Scroll:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
                for _,v in ipairs(valuesList or {}) do
                    table.insert(values,v) local O=Instance.new("TextButton") local OC=Instance.new("UICorner")
                    O.Parent=Scroll O.BackgroundColor3=Color3.fromRGB(15,15,15) O.BorderSizePixel=0 O.Size=UDim2.new(1,0,0,24) O.AutoButtonColor=false O.Font=Enum.Font.GothamSemibold O.Text=tostring(v) O.TextColor3=Color3.new(1,1,1) O.TextSize=10 O.ZIndex=102
                    OC.CornerRadius=UDim.new(0,6) OC.Parent=O visual(O,v)
                    O.TextScaled=true
                    local OCC=Instance.new("UITextSizeConstraint")
                    OCC.MaxTextSize=10
                    OCC.Parent=O
                    O.MouseEnter:Connect(function() if not ((multi and selections[v]) or selected==v) then O.BackgroundColor3=Color3.fromRGB(10,10,10) end end)
                    O.MouseLeave:Connect(function() visual(O,v) end)
                    O.MouseButton1Click:Connect(function()
                        if multi then selections[v]=not selections[v] T.Text=(function() local n={} for _,x in ipairs(values) do if selections[x] then table.insert(n,tostring(x)) end end return #n>0 and table.concat(n,", ") or tostring(name) end)() visual(O,v) pcall(callback,selections)
                        else selected=v T.Text=tostring(v) visual(O,v) close() pcall(callback,v) end
                    end)
                end canvas()
            end
            build(list)
            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(canvas)
            local def=o and o.Default or nil
            if def~=nil then set(def,false) elseif scrollsize and tonumber(scrollsize) and values[tonumber(scrollsize)] then set(values[tonumber(scrollsize)],false) end
            RegisterElement(H,name,"Dropdown")
            RegisterConfig(name,"Dropdown",function() return get() end,function(v) if v~=nil then set(v,true) end end)
            return {Object=H,Refresh=function(newList) build(newList or {}) end,Get=function() return get() end,Set=function(v) set(v,true) end}
        end
        function Elements:addKeybind(name,default,callback)
            local o=type(default)=="table" and default or nil
            if o then name=o.Text or name default=o.Default callback=o.Callback end
            callback=callback or function() end
            local H=Instance.new("Frame") local C=Instance.new("UICorner") local T=Instance.new("TextLabel") local B=Instance.new("TextButton")
            H.Parent=Home H.BackgroundColor3=Color3.fromRGB(23,23,23) H.BorderSizePixel=0 H.Size=UDim2.new(0,214,0,26) C.CornerRadius=UDim.new(0,5) C.Parent=H
            T.Parent=H T.BackgroundTransparency=1 T.Position=UDim2.new(.024,0,0,3) T.Size=UDim2.new(0,140,0,24) T.Font=Enum.Font.GothamSemibold T.Text=name or "" T.TextColor3=Color3.new(1,1,1) T.TextSize=11 T.TextXAlignment=Enum.TextXAlignment.Left T.TextScaled=true T.ClipsDescendants=true
            B.Parent=H B.BackgroundColor3=Color3.fromRGB(5,5,5) B.Position=UDim2.new(.68,0,0,5) B.Size=UDim2.new(0,60,0,20) B.Font=Enum.Font.GothamSemibold B.Text=default and tostring(default.Name or default) or "None" B.TextColor3=Color3.new(1,1,1) B.TextSize=9
            local value=default local listening=false
            B.MouseButton1Click:Connect(function() listening=true B.Text="Press key..." end)
            UIS.InputBegan:Connect(function(i,g) if listening and not g then if i.UserInputType==Enum.UserInputType.Keyboard then value=i.KeyCode listening=false B.Text=i.KeyCode.Name pcall(callback,value) end end end)
            RegisterElement(H,name,"Keybind") RegisterConfig(name,"Keybind",function() return value and value.Name end,function(v) if type(v)=="string" then local ok,k=pcall(function() return Enum.KeyCode[v] end) if ok and k then value=k B.Text=k.Name pcall(callback,k) end elseif typeof(v)=="EnumItem" then value=v B.Text=v.Name pcall(callback,v) end end)
            return {Object=H,Get=function() return value end,Set=function(v) value=v B.Text=v and v.Name or "None" pcall(callback,v) end}
        end
        function Elements:addColorPicker(name,default,callback)
            local o=type(default)=="table" and default or nil
            if o then name=o.Text or name default=o.Default callback=o.Callback end
            callback=callback or function() end
            default=typeof(default)=="Color3" and default or Color3.new(1,1,1)
            local H=Instance.new("Frame") local C=Instance.new("UICorner") local T=Instance.new("TextLabel") local B=Instance.new("TextButton") local BC=Instance.new("UICorner")
            H.Parent=Home H.BackgroundColor3=Color3.fromRGB(23,23,23) H.BorderSizePixel=0 H.Size=UDim2.new(0,214,0,26) H.ClipsDescendants=false C.CornerRadius=UDim.new(0,5) C.Parent=H
            T.Parent=H T.BackgroundTransparency=1 T.Position=UDim2.new(.024,0,0,3) T.Size=UDim2.new(0,160,0,24) T.Font=Enum.Font.GothamSemibold T.Text=name or "" T.TextColor3=Color3.new(1,1,1) T.TextSize=11 T.TextXAlignment=Enum.TextXAlignment.Left T.TextScaled=true T.ClipsDescendants=true
            B.Parent=H B.BackgroundColor3=default B.Position=UDim2.new(.78,0,0,5) B.Size=UDim2.new(0,40,0,20) B.Text="" B.AutoButtonColor=false B.ZIndex=50 BC.CornerRadius=UDim.new(0,5) BC.Parent=B
            local Panel=Instance.new("Frame") local PC=Instance.new("UICorner") local Canvas=Instance.new("Frame") local Circle=Instance.new("Frame") local CC=Instance.new("UICorner")
            Panel.Parent=Gui Panel.BackgroundColor3=Color3.fromRGB(25,25,25) Panel.Size=UDim2.new(0,210,0,110) Panel.Visible=false Panel.BorderSizePixel=0 Panel.Active=true Panel.ZIndex=300
            PC.CornerRadius=UDim.new(0,6) PC.Parent=Panel
            Canvas.Parent=Panel Canvas.BackgroundColor3=Color3.fromRGB(0,0,0) Canvas.BorderSizePixel=0 Canvas.Position=UDim2.new(0,8,0,8) Canvas.Size=UDim2.new(1,-16,1,-16) Canvas.ZIndex=301 Canvas.ClipsDescendants=true
            BuildHSVGrid(Canvas,301)
            Circle.Parent=Canvas Circle.AnchorPoint=Vector2.new(.5,.5) Circle.BackgroundColor3=default Circle.BorderColor3=Color3.new(0,0,0) Circle.BorderSizePixel=2 Circle.Size=UDim2.new(0,10,0,10) Circle.ZIndex=305 Circle.Position=UDim2.new(.5,0,.5,0)
            CC.CornerRadius=UDim.new(1,0) CC.Parent=Circle
            local value=default local open=false local dragging=false
            local function positionPicker()
                local hp=H.AbsolutePosition local vp=Gui.AbsoluteSize
                local x=hp.X+H.AbsoluteSize.X+8 local y=hp.Y
                Panel.Position=UDim2.fromOffset(math.clamp(x,4,math.max(4,vp.X-214)),math.clamp(y,4,math.max(4,vp.Y-114)))
            end
            local function setColor(i)
                local s=Canvas.AbsoluteSize local p=Canvas.AbsolutePosition
                if s.X<=0 or s.Y<=0 then return end
                local x=math.clamp((i.Position.X-p.X)/s.X,0,1) local y=math.clamp((i.Position.Y-p.Y)/s.Y,0,1)
                value=Color3.fromHSV(x,x,1-y) Circle.Position=UDim2.new(x,0,y,0) Circle.BackgroundColor3=value B.BackgroundColor3=value pcall(callback,value)
            end
B.MouseButton1Click:Connect(function() open=not open if open then positionPicker() Panel.Visible=true Circle.BackgroundColor3=value else Panel.Visible=false end end)
Canvas.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true setColor(i) end end)
UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then setColor(i) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
            RegisterElement(H,name,"ColorPicker")
            RegisterConfig(name,"ColorPicker",function() return {R=value.R,G=value.G,B=value.B} end,function(v)
                if type(v)=="table" and v.R and v.G and v.B then value=Color3.new(v.R,v.G,v.B) B.BackgroundColor3=value Circle.BackgroundColor3=value pcall(callback,value) end
            end)
            return {Object=H,Get=function() return value end,Set=function(v) if typeof(v)=="Color3" then value=v B.BackgroundColor3=v Circle.BackgroundColor3=v pcall(callback,v) end end}
        end
        task.defer(UpdateCanvas)
        UpdateWindowLayout()
        Elements.AddLabel=Elements.addLabel
        Elements.AddSpacer=Elements.addSpacer
        Elements.AddButton=Elements.addButton
        Elements.AddToggle=Elements.addToggle
        Elements.AddSlider=Elements.addSlider
        Elements.AddInput=Elements.addTextBox
        Elements.AddDropdown=Elements.addDropdown
        Elements.AddKeybind=Elements.addKeybind
        Elements.AddColorPicker=Elements.addColorPicker
        return Elements
    end
    --// CONFIG PAGE
local ConfigPage=PageYep:addPage("Config", 6, false, 6)
    ConfigPage.__Tab.LayoutOrder=9999
    local CurrentConfig="Default"
    local AutoLoad=false
    local ConfigNameBox
    local ConfigDropdown
    local ConfigStatus
    local AutoBtn
    local ThemeRowText
    local function CurrentName()
        local v=ConfigNameBox and ConfigNameBox.Text or CurrentConfig
        if tostring(v):lower()=="name..." or tostring(v)=="" then v=CurrentConfig end
        return CleanName(v)
    end
    local function SaveSettings()
        if not SetupFolder() then return end
        pcall(function() writefile(ConfigFolder.."/settings.json", HttpService:JSONEncode({Config=CurrentConfig,AutoLoad=AutoLoad,Theme=CurrentTheme.Name})) end)
    end
    SaveSettingsFn=function() SaveSettings() end
    local function UpdateAutoBtn()
        if AutoBtn then AutoBtn.Text="Auto load : "..((AutoLoad and CurrentConfig) or "none") end
    end
    local function ConfigSpacer()
        local S=Instance.new("Frame")
        S.Name="SPACER"
        S.Parent=ConfigPage.__Page
        S.BackgroundTransparency=1
        S.BorderSizePixel=0
        S.Size=UDim2.new(0,214,0,26)
        S.Active=false
        if ConfigPage.__Order then S.LayoutOrder=ConfigPage.__Order() end
    end
    do
        local T=Instance.new("TextLabel")
        T.Parent=Folder
        T.Visible=false
        T.BackgroundTransparency=1
        T.Size=UDim2.new(0,0,0,0)
        T.Font=Enum.Font.GothamSemibold
        T.Text=""
        T.TextColor3=Color3.fromRGB(140,140,140)
        T.TextSize=9
        ConfigStatus=T
    end
    local function SetStatus(text,good)
        if ConfigStatus then
            ConfigStatus.Text=text
            ConfigStatus.TextColor3=good and Color3.new(1,1,1) or Color3.fromRGB(255,120,120)
        end
        if good then pcall(function() Library:Notify(text) end) end
    end
    -- L1: config name
    local _,InputBox=ConfigPage:addTextBox(
        "Config name",
        "Name...",
        function(v)
            if tostring(v)~=""
            and tostring(v):lower()~="name..." then
                CurrentConfig=CleanName(v)
            end
        end
)
    ConfigNameBox=InputBox
    -- R1: auto load state
    local _,AutoB=ConfigPage:addButton("Auto load : none",function() UpdateAutoBtn() end)
    AutoBtn=AutoB
    -- L2: config list
    ConfigDropdown=ConfigPage:addDropdown(
        "Config list",
        {},
        5,
        function(v)
            CurrentConfig=CleanName(v)
            if ConfigNameBox then ConfigNameBox.Text=CurrentConfig end
        end
)
    -- R2: set auto load
    ConfigPage:addButton(
        "Set as auto load",
        function()
            local n=CurrentName()
            CurrentConfig=n
            AutoLoad=true
            SaveSettings()
            UpdateAutoBtn()
            SetStatus("Auto load: "..n,true)
        end
)
    -- L3: refresh list
    ConfigPage:addButton(
        "Refresh list",
        function()
            local files=GetConfigFiles()
            if ConfigDropdown then ConfigDropdown.Refresh(files) end
            if #files==0 then
                SetStatus("No configs found",false)
            else
                SetStatus("Found "..#files.." config"..(#files==1 and "" or "s"),true)
            end
        end
)
    -- R3: clear auto load
    ConfigPage:addButton(
        "Clear auto load",
        function()
            AutoLoad=false
            SaveSettings()
            UpdateAutoBtn()
            SetStatus("Auto load cleared",true)
        end
)
    -- L4: create config
    ConfigPage:addButton(
        "Create config",
        function()
            local n=CurrentName()
            if SaveConfig(n) then
                if ConfigDropdown then
                    ConfigDropdown.Refresh(GetConfigFiles())
                    ConfigDropdown.Set(n)
                end
            end
        end
)
    -- R4: theme row (opens theme panel on the right)
    local ThemeRowH=Instance.new("Frame") local ThemeRowC=Instance.new("UICorner")
    ThemeRowH.Parent=ConfigPage.__Page ThemeRowH.BackgroundColor3=Color3.fromRGB(23,23,23) ThemeRowH.BorderSizePixel=0 ThemeRowH.Size=UDim2.new(0,214,0,26)
    if ConfigPage.__Order then ThemeRowH.LayoutOrder=ConfigPage.__Order() end
    ThemeRowC.CornerRadius=UDim.new(0,5) ThemeRowC.Parent=ThemeRowH
    RegTheme(ThemeRowH,"Row")
    ThemeRowText=Instance.new("TextLabel")
    ThemeRowText.Parent=ThemeRowH ThemeRowText.BackgroundTransparency=1 ThemeRowText.Position=UDim2.new(.024,0,0,0) ThemeRowText.Size=UDim2.new(0,160,1,0) ThemeRowText.Font=Enum.Font.GothamSemibold ThemeRowText.Text="Theme - "..CurrentTheme.Name ThemeRowText.TextColor3=Color3.new(1,1,1) ThemeRowText.TextSize=11 ThemeRowText.TextXAlignment=Enum.TextXAlignment.Left ThemeRowText.TextTruncate=Enum.TextTruncate.AtEnd ThemeRowText.ClipsDescendants=true
    do
        for i,dy in ipairs({8,12,16}) do
            local HB=Instance.new("Frame")
            HB.Parent=ThemeRowH HB.BackgroundColor3=Color3.new(1,1,1) HB.BorderSizePixel=0 HB.Position=UDim2.new(.88,0,0,dy) HB.Size=UDim2.new(0,14,0,2)
        end
    end
    local ThemeRowBtn=Instance.new("TextButton")
    ThemeRowBtn.Parent=ThemeRowH ThemeRowBtn.BackgroundTransparency=1 ThemeRowBtn.Size=UDim2.new(1,0,1,0) ThemeRowBtn.Text="" ThemeRowBtn.AutoButtonColor=false
    Register(ThemeRowH,"Theme - "..CurrentTheme.Name,ConfigPage.__Page,"Dropdown")
    --// THEME PANEL (right side with a gap)
    local ThemePanel=Instance.new("Frame")
    local ThemePanelC=Instance.new("UICorner")
    ThemePanel.Parent=Frame
    ThemePanel.BackgroundColor3=Color3.fromRGB(15,15,15)
    ThemePanel.BorderSizePixel=0
    ThemePanel.Position=UDim2.new(1,10,0,222)
    ThemePanel.Size=UDim2.new(0,230,0,196)
    ThemePanel.Visible=false
    ThemePanel.ZIndex=90
    ThemePanelC.CornerRadius=UDim.new(0,6)
    ThemePanelC.Parent=ThemePanel
    RegTheme(ThemePanel,"Panel")
    local ThemeClose=Instance.new("TextButton") local ThemeCloseC=Instance.new("UICorner")
    ThemeClose.Parent=ThemePanel ThemeClose.BackgroundColor3=Color3.fromRGB(25,25,25) ThemeClose.BorderSizePixel=0 ThemeClose.Position=UDim2.new(0,8,0,8) ThemeClose.Size=UDim2.new(0,64,0,22) ThemeClose.Font=Enum.Font.GothamSemibold ThemeClose.Text="Close" ThemeClose.TextColor3=Color3.new(1,1,1) ThemeClose.TextSize=10 ThemeClose.AutoButtonColor=false ThemeClose.ZIndex=91
    ThemeCloseC.CornerRadius=UDim.new(0,5) ThemeCloseC.Parent=ThemeClose
    local ThemeSearch=Instance.new("TextBox") local ThemeSearchC=Instance.new("UICorner")
    ThemeSearch.Parent=ThemePanel ThemeSearch.BackgroundColor3=Color3.fromRGB(10,10,10) ThemeSearch.BorderSizePixel=0 ThemeSearch.Position=UDim2.new(0,80,0,8) ThemeSearch.Size=UDim2.new(1,-88,0,22) ThemeSearch.Font=Enum.Font.GothamSemibold ThemeSearch.PlaceholderText="Search..." ThemeSearch.PlaceholderColor3=Color3.fromRGB(100,100,100) ThemeSearch.Text="" ThemeSearch.TextColor3=Color3.new(1,1,1) ThemeSearch.TextSize=10 ThemeSearch.ClearTextOnFocus=false ThemeSearch.ZIndex=91
    ThemeSearchC.CornerRadius=UDim.new(0,5) ThemeSearchC.Parent=ThemeSearch
    local ThemeList=Instance.new("ScrollingFrame") local ThemeListLayout=Instance.new("UIListLayout")
    ThemeList.Parent=ThemePanel ThemeList.BackgroundTransparency=1 ThemeList.BorderSizePixel=0 ThemeList.Position=UDim2.new(0,8,0,38) ThemeList.Size=UDim2.new(1,-16,1,-46) ThemeList.ScrollBarThickness=2 ThemeList.ScrollBarImageColor3=Color3.fromRGB(70,70,70) ThemeList.CanvasSize=UDim2.new(0,0,0,0) ThemeList.AutomaticCanvasSize=Enum.AutomaticSize.Y ThemeList.ZIndex=91
    ThemeListLayout.Parent=ThemeList ThemeListLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center ThemeListLayout.SortOrder=Enum.SortOrder.LayoutOrder ThemeListLayout.Padding=UDim.new(0,4)
    local ThemeRows={}
    for _,t in ipairs(Themes) do
        local R=Instance.new("TextButton") local RC=Instance.new("UICorner")
        local L=Instance.new("TextLabel")
        R.Parent=ThemeList R.BackgroundColor3=Color3.fromRGB(20,20,20) R.BorderSizePixel=0 R.Size=UDim2.new(1,-4,0,24) R.AutoButtonColor=false R.Font=Enum.Font.GothamSemibold R.Text="" R.ZIndex=91
        RC.CornerRadius=UDim.new(0,5) RC.Parent=R
        L.Parent=R L.BackgroundTransparency=1 L.Position=UDim2.new(0,10,0,0) L.Size=UDim2.new(1,-20,1,0) L.Font=Enum.Font.GothamSemibold L.Text=t.Name L.TextColor3=Color3.fromRGB(150,150,150) L.TextSize=11 L.TextXAlignment=Enum.TextXAlignment.Left L.ZIndex=92
        table.insert(ThemeRows,{Row=R,Label=L,Theme=t})
        R.MouseButton1Click:Connect(function() ApplyTheme(t) end)
    end
    local function RefreshThemeList()
        for _,e in ipairs(ThemeRows) do
            local sel=e.Theme==CurrentTheme
            e.Row.BackgroundColor3=sel and CurrentTheme.Hi or Color3.fromRGB(20,20,20)
            e.Label.TextColor3=sel and Color3.new(1,1,1) or Color3.fromRGB(150,150,150)
        end
    end
    RefreshThemeList()
    ThemeSearch:GetPropertyChangedSignal("Text"):Connect(function()
        local q=tostring(ThemeSearch.Text or ""):lower()
        for _,e in ipairs(ThemeRows) do
            e.Row.Visible=q=="" or e.Theme.Name:lower():find(q,1,true)~=nil
        end
    end)
    ThemeClose.MouseButton1Click:Connect(function() ThemePanel.Visible=false end)
    ThemeRowBtn.MouseButton1Click:Connect(function() ThemePanel.Visible=not ThemePanel.Visible end)
    UpdateThemeUI=function()
        if ThemeRowText then ThemeRowText.Text="Theme - "..CurrentTheme.Name end
        RefreshThemeList()
    end
    -- L5: save config
    ConfigPage:addButton(
        "Save config",
        function()
            SaveConfig(CurrentName())
        end
)
    ConfigSpacer()
    -- L6: load config
    ConfigPage:addButton(
        "Load config",
        function()
            LoadConfig(CurrentName())
        end
)
    ConfigSpacer()
    -- L7: unload config
    ConfigPage:addButton(
        "Unload config",
        function()
            UnloadConfig()
        end
)
    ConfigSpacer()
    -- L8: delete config
    ConfigPage:addButton(
        "Delete config",
        function()
            local n=CurrentName()
            if DeleteConfig(n) then
                if ConfigDropdown then ConfigDropdown.Refresh(GetConfigFiles()) end
                if n==CurrentConfig then
                    CurrentConfig="Default"
                    if ConfigNameBox then ConfigNameBox.Text="Name..." end
                end
            end
        end
)
    ConfigSpacer()
    local function SaveConfig(name)
        if not SetupFolder() then
            SetStatus("Filesystem unavailable",false)
            return false
        end
        name=CleanName(name)
        local data={
            Version=5,
            ConfigName=name,
            Values={},
            Plugins={}
        }
        for _,entry in ipairs(ConfigEntries) do
            local ok,value=pcall(entry.Get)
            if ok then
                if typeof(value)=="Color3" then value=ColorToTable(value) end
                data.Values[entry.Name]={
                    Type=entry.Type,
                    Value=value
                }
            end
        end
        for _,entry in ipairs(PluginConfigEntries) do
            if entry.Plugin then
                local pluginName=entry.Plugin.Name
                data.Plugins[pluginName]=
                    data.Plugins[pluginName]
                    or {
                        File=entry.Plugin.File,
                        Values={}
                    }
                local ok,value=pcall(entry.Get)
                if ok then
                    if typeof(value)=="Color3" then value=ColorToTable(value) end
                    data.Plugins[pluginName].Values[
                        entry.Name
                    ]={
                        Type=entry.Type,
                        Value=value
                    }
                end
            end
        end
local ok,json=pcall(function() return HttpService:JSONEncode(data) end)
        if not ok then
            SetStatus("Failed to encode config",false)
            return false
        end
local success=pcall(function() writefile(ConfigPath(name), json) end)
        if not success then
            SetStatus("Failed to save",false)
            return false
        end
        CurrentConfig=name
        if ConfigNameBox then ConfigNameBox.Text=name end
SetStatus("Saved: "..name, true)
        return true
    end
    local function LoadConfig(name)
        if not SetupFolder() then
            SetStatus("Filesystem unavailable",false)
            return false
        end
        name=CleanName(name)
        local path=ConfigPath(name)
        if not isfile(path) then
SetStatus("Not found: "..name, false)
            return false
        end
local ok,contents=pcall(function() return readfile(path) end)
        if not ok or not contents then
SetStatus("Failed to read", false)
            return false
        end
local decodedOk,data=pcall(function() return HttpService:JSONDecode(contents) end)
        if not decodedOk
        or type(data)~="table"
        or type(data.Values)~="table" then
SetStatus("Invalid config", false)
            return false
        end
        for _,entry in ipairs(ConfigEntries) do
            local saved=data.Values[entry.Name]
            if saved and saved.Value~=nil then
                local value=saved.Value
                if type(value)=="table"
                and value.__type=="Color3" then
                    value=TableToColor(value)
                end
                pcall(entry.Set,value)
            end
        end
        if type(data.Plugins)=="table" then
            for _,entry in ipairs(PluginConfigEntries) do
                if entry.Plugin then
                    local pluginData=
                        data.Plugins[
                            entry.Plugin.Name
                        ]
                    if pluginData
                    and type(pluginData.Values)=="table" then
                        local saved=
                            pluginData.Values[
                                entry.Name
                            ]
                        if saved
                        and saved.Value~=nil then
                            local value=saved.Value
                            if type(value)=="table"
                            and value.__type=="Color3" then
                                value=TableToColor(value)
                            end
pcall(entry.Set, value)
                        end
                    end
                end
            end
        end
        CurrentConfig=name
        if ConfigNameBox then ConfigNameBox.Text=name end
SetStatus("Loaded: "..name, true)
        return true
    end
    local function DeleteConfig(name)
        if not SetupFolder() then
SetStatus("Filesystem unavailable", false)
            return false
        end
        name=CleanName(name)
        local path=ConfigPath(name)
        if not isfile(path) then
SetStatus("Not found: "..name, false)
            return false
        end
        if type(delfile)~="function" then
SetStatus("Delete unsupported", false)
            return false
        end
local ok=pcall(function() delfile(path) end)
        if not ok then
SetStatus("Failed to delete", false)
            return false
        end
        if ConfigDropdown then ConfigDropdown.Refresh(GetConfigFiles()) end
SetStatus("Deleted: "..name, true)
        return true
    end
    local function UnloadConfig()
        for _,entry in ipairs(ResetEntries) do
            local v=entry.Default
            if entry.Type=="Toggle" then v=false end
            if v~=nil then pcall(entry.Set,v) end
        end
        UpdateTogglePanel()
        UpdateWindowLayout()
        SetStatus("Unloaded",true)
    end
    local function ResetAll()
        for _,entry in ipairs(ResetEntries) do
            local resetValue=entry.Default
            if entry.Type=="Toggle" then resetValue=false end
            if resetValue~=nil then
                pcall(entry.Set,resetValue)
            elseif entry.Type=="Dropdown" then
                pcall(entry.Set,nil)
            end
        end
        AutoLoad=false
        PerformanceMode=false
        UIScaleValue=1
        Scale.Scale=UIScaleValue
        CurrentConfig="Default"
        local character=G.LP and G.LP.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity=Vector3.zero
            root.AssemblyAngularVelocity=Vector3.zero
            root.Velocity=Vector3.zero
            root.RotVelocity=Vector3.zero
            root.CFrame=CFrame.new(-432.1439208984375,38.9649658203125,-284.1016540527344)
        end
        if ConfigNameBox then ConfigNameBox.Text="Name..." end
        SearchBox.Text=""
        UpdateTogglePanel()
        UpdateWindowLayout()
    end
    ResetButton.MouseButton1Click:Connect(ResetAll)
    --// PLUGIN SECTION (backend only, no UI; system still works)
local PluginDropdown
local PluginStatus
local function RefreshPluginDropdown()
    local files=GetPluginFiles()
    if PluginDropdown then PluginDropdown.Refresh(files) end
    if PluginStatus then
        if #files==0 then
            PluginStatus.Text="No .lua plugins found"
            PluginStatus.TextColor3=Color3.fromRGB(140,140,140)
        else
            PluginStatus.Text=
                "Found "
                ..#files
                .." plugin"
                ..(#files==1 and "" or "s")
            PluginStatus.TextColor3=
                Color3.new(1,1,1)
        end
    end
end
    --// PLUGIN EXECUTION
local function ResolvePluginResult(result)
    local current=result
    for i=1,8 do
        if type(current)=="table" then
            if type(current.Tabs)=="table" then return current end
            if type(current.Plugin)=="table" then
                current=current.Plugin
            elseif type(current.Data)=="table" then
                current=current.Data
            elseif type(current.Module)=="table" then
                current=current.Module
            else
                return nil,"Plugin did not return a valid plugin table"
            end
        elseif type(current)=="function" then
            local ok,nextResult=pcall(current)
            if not ok then return nil,tostring(nextResult) end
            current=nextResult
        else
            return nil,"Plugin returned "..type(current)
        end
    end
    return nil,"Plugin wrapper depth exceeded"
end
local function ExecutePluginSource(source,fileName)
    if type(loadstring)~="function" then return nil,"loadstring unavailable" end
local ok,chunk=pcall(function() return loadstring(source, "@"..tostring(fileName)) end)
    if not ok or type(chunk)~="function" then return nil,tostring(chunk) end
    local okRun,result=pcall(chunk)
    if not okRun then return nil,tostring(result) end
    return ResolvePluginResult(result)
end
--// PLUGIN LOADER
local function LoadPlugin(path)
    if type(path)~="string" or path=="" then
        if PluginStatus then
            PluginStatus.Text="Select a plugin first"
            PluginStatus.TextColor3=Color3.fromRGB(255,120,120)
        end
        return false
    end
    local fileKey=tostring(path)
    if LoadedPlugins[fileKey] then
        if PluginStatus then
            PluginStatus.Text="Already loaded: "..PluginFileName(fileKey)
            PluginStatus.TextColor3=Color3.fromRGB(255,190,90)
        end
        return false
    end
    if type(isfile)~="function" or not isfile(fileKey) then
        if PluginStatus then
            PluginStatus.Text="Plugin file not found"
            PluginStatus.TextColor3=Color3.fromRGB(255,120,120)
        end
        return false
    end
    if type(readfile)~="function" then
        if PluginStatus then
            PluginStatus.Text="readfile unavailable"
            PluginStatus.TextColor3=Color3.fromRGB(255,120,120)
        end
        return false
    end
    if type(loadstring)~="function" then
        if PluginStatus then
            PluginStatus.Text="loadstring unavailable"
            PluginStatus.TextColor3=Color3.fromRGB(255,120,120)
        end
        return false
    end
local okRead,source=pcall(function() return readfile(fileKey) end)
    if not okRead or type(source)~="string" or source=="" then
        if PluginStatus then
            PluginStatus.Text="Failed to read plugin"
            PluginStatus.TextColor3=Color3.fromRGB(255,120,120)
        end
        return false
    end
local plugin,err=ExecutePluginSource(source, PluginFileName(fileKey))
    if not plugin then
        if PluginStatus then
            PluginStatus.Text="Plugin error: "..tostring(err)
            PluginStatus.TextColor3=Color3.fromRGB(255,120,120)
        end
        return false
    end
    if type(plugin.Tabs)~="table" then
        if PluginStatus then
            PluginStatus.Text="Plugin has no Tabs table"
            PluginStatus.TextColor3=Color3.fromRGB(255,120,120)
        end
        return false
    end
local pluginName=tostring(plugin.Name or PluginFileName(fileKey))
    local pluginInfo={
        Name=pluginName,
        File=fileKey,
        Plugin=plugin,
        Tabs={},
        Entries={}
    }
    LoadedPlugins[fileKey]=pluginInfo
    CurrentPlugin=pluginInfo
    local createdTabs=0
    local errors={}
    for _,tabInfo in ipairs(plugin.Tabs) do
        if type(tabInfo)=="table"
        and type(tabInfo.Name)=="string" then
            local requestedName=tostring(tabInfo.Name)
            if requestedName:lower()~="config"
            and not PageTabs[requestedName] then
local pageOk,page=pcall(function() return PageYep:addPage(requestedName, tabInfo.ScrollSize or 6, false, tabInfo.ElementSpacing or 6) end)
                if pageOk and page then
                    page.__Tab.LayoutOrder=PluginTabOrder
                    PluginTabOrder+=1
table.insert(pluginInfo.Tabs, page)
                    createdTabs+=1
                    if type(tabInfo.Elements)=="function" then
local success,elementErr=pcall(tabInfo.Elements, page, plugin)
                        if not success then table.insert(errors, requestedName..": "..tostring(elementErr)) end
                    end
                else
table.insert(errors, requestedName..": "..tostring(page))
                end
            end
        end
    end
    CurrentPlugin=nil
    UpdateWindowLayout()
    if createdTabs==0 then
        LoadedPlugins[fileKey]=nil
        if PluginStatus then
            PluginStatus.Text="Plugin created no tabs"
            PluginStatus.TextColor3=Color3.fromRGB(255,120,120)
        end
        return false
    end
    --// Show first newly loaded plugin tab
    if pluginInfo.Tabs[1] then
        local first=pluginInfo.Tabs[1]
        if first.__Tab and first.__Tab.Parent then
            first.__Tab:Activate()
            first.__Page.Visible=true
            for _,page in ipairs(Folder:GetChildren()) do
                if page:IsA("ScrollingFrame")
                and page~=first.__Page then
                    page.Visible=false
                end
            end
            for _,tab in pairs(PageTabs) do
                if tab:IsA("GuiButton") then
                    if tab==first.__Tab then
                        tab.TextTransparency=0
                        tab.BackgroundColor3=Color3.fromRGB(25,25,25)
                    else
                        tab.TextTransparency=.3
                        tab.BackgroundColor3=Color3.fromRGB(15,15,15)
                    end
                end
            end
        end
    end
    if PluginStatus then
        if #errors>0 then
            PluginStatus.Text=
                "Loaded: "
                ..pluginName
                .." ("
                ..createdTabs
                .." tab"
                ..(createdTabs==1 and "" or "s")
                ..", "
                ..#errors
                .." error"
                ..(#errors==1 and "" or "s")
                ..")"
        else
            PluginStatus.Text=
                "Loaded: "
                ..pluginName
.." (" ..createdTabs .." tab" ..(createdTabs==1 and "" or "s") ..")"
        end
        PluginStatus.TextColor3=Color3.new(1,1,1)
    end
    return true
end
--// INITIAL SETTINGS
task.spawn(function()
    if not SetupFolder() then return end
    local settingsPath=ConfigFolder.."/settings.json"
    if isfile(settingsPath) then
local ok,contents=pcall(function() return readfile(settingsPath) end)
        if ok and contents then
local decodedOk,data=pcall(function() return HttpService:JSONDecode(contents) end)
            if decodedOk and type(data)=="table" then
                if type(data.Config)=="string"
                and data.Config~="" then
                    CurrentConfig=CleanName(data.Config)
                end
                AutoLoad=data.AutoLoad==true
                if ConfigNameBox then ConfigNameBox.Text=CurrentConfig end
                local th=FindTheme(data.Theme)
                if th then CurrentTheme=th end
            end
        end
    end
    task.wait(.15)
    UpdateAutoBtn()
    ApplyTheme(CurrentTheme)
    if ConfigDropdown then ConfigDropdown.Refresh(GetConfigFiles()) end
    if PluginDropdown then RefreshPluginDropdown() end
    if AutoLoad then
        task.wait(.25)
        LoadConfig(CurrentConfig)
    end
end)
task.defer(function()
    task.wait(.1)
    if ConfigDropdown then ConfigDropdown.Refresh(GetConfigFiles()) end
    if PluginDropdown then RefreshPluginDropdown() end
    UpdateTogglePanel()
    UpdateWindowLayout()
end)
--// v2.7: SETTINGS PANEL + HOTKEYS LIST + CUSTOM CURSOR + NOTIFY
Library.NotificationsEnabled=true
local SettingsState={KeybindList=false,Notifications=true,CustomKick=true,AlwaysTrigger=false}
Library.Settings=SettingsState
local SettingSetters={}
function Library:SetSetting(name,value) local s=SettingSetters[name] if s then s(value) end end
function Library:ThemeObject(obj,role)
    if typeof(obj)~="Instance" then return end
    RegTheme(obj,role or "Row")
    ApplyTheme(CurrentTheme)
end
local function KeyToText(k)
    if typeof(k)~="EnumItem" then return "?" end
    local n=tostring(k.Name or "?")
    if k.EnumType==Enum.UserInputType then n=n:gsub("MouseButton","MB") end
    return n:lower()
end
local function MakeCheckRow(parent,labelText,default,y)
    local H=Instance.new("Frame") local HC=Instance.new("UICorner") local T=Instance.new("TextLabel")
    local Box=Instance.new("TextButton") local BoxC=Instance.new("UICorner")
    H.Parent=parent H.BackgroundColor3=Color3.fromRGB(20,20,20) H.BorderSizePixel=0 H.Position=UDim2.new(0,8,0,y) H.Size=UDim2.new(1,-16,0,26) H.ZIndex=91
    RegTheme(H,"Row")
    HC.CornerRadius=UDim.new(0,5) HC.Parent=H
    T.Parent=H T.BackgroundTransparency=1 T.Position=UDim2.new(0,8,0,0) T.Size=UDim2.new(1,-60,1,0) T.Font=Enum.Font.GothamSemibold T.Text=labelText T.TextColor3=Color3.new(1,1,1) T.TextSize=9 T.TextXAlignment=Enum.TextXAlignment.Left T.ZIndex=92 T.TextScaled=true T.ClipsDescendants=true
    do local TC=Instance.new("UITextSizeConstraint") TC.MaxTextSize=9 TC.Parent=T end
    Box.Parent=H Box.BackgroundColor3=Color3.fromRGB(35,35,35) Box.BorderSizePixel=0 Box.Position=UDim2.new(1,-26,0.5,-8) Box.Size=UDim2.new(0,16,0,16) Box.Text="" Box.AutoButtonColor=false Box.ZIndex=92
    BoxC.CornerRadius=UDim.new(0,4) BoxC.Parent=Box
    local BS=Instance.new("UIStroke") BS.Color=Color3.fromRGB(70,70,70) BS.Parent=Box
    local C1=Instance.new("Frame") C1.Parent=Box C1.BackgroundColor3=Color3.new(1,1,1) C1.BorderSizePixel=0 C1.AnchorPoint=Vector2.new(.5,.5) C1.Position=UDim2.new(.38,0,.56,0) C1.Size=UDim2.new(0,2,0,6)     C1.Rotation=-40 C1.Visible=default C1.ZIndex=93
    local C2=Instance.new("Frame") C2.Parent=Box C2.BackgroundColor3=Color3.new(1,1,1) C2.BorderSizePixel=0 C2.AnchorPoint=Vector2.new(.5,.5) C2.Position=UDim2.new(.62,0,.47,0) C2.Size=UDim2.new(0,2,0,10)     C2.Rotation=40 C2.Visible=default C2.ZIndex=93
    local state=default==true
    local api={}
    function api.Set(v) state=v==true C1.Visible=state C2.Visible=state end
    function api.Get() return state end
    Box.MouseButton1Click:Connect(function() api.Set(not state) if api.OnChange then pcall(api.OnChange,state) end end)
    return api
end
--// SETTINGS PANEL (right of window, gear toggles it)
local SettingsPanel=Instance.new("Frame")
local SettingsCorner=Instance.new("UICorner")
SettingsPanel.Parent=Frame
SettingsPanel.BackgroundColor3=Color3.fromRGB(15,15,15)
SettingsPanel.BorderSizePixel=0
SettingsPanel.Position=UDim2.new(.27,36,0,32)
SettingsPanel.Size=UDim2.new(0,210,0,172)
SettingsPanel.Visible=false
SettingsPanel.ZIndex=90
RegTheme(SettingsPanel,"Panel")
SettingsCorner.CornerRadius=UDim.new(0,6)
SettingsCorner.Parent=SettingsPanel
ToggleSettingsPanel=function() SettingsPanel.Visible=not SettingsPanel.Visible end
do
    local KeyRow=Instance.new("Frame") local KeyRowC=Instance.new("UICorner") local KeyLabel=Instance.new("TextLabel")
    local KeyPill=Instance.new("TextButton") local KeyPillC=Instance.new("UICorner")
    KeyRow.Parent=SettingsPanel KeyRow.BackgroundColor3=Color3.fromRGB(20,20,20) KeyRow.BorderSizePixel=0 KeyRow.Position=UDim2.new(0,8,0,8) KeyRow.Size=UDim2.new(1,-16,0,26) KeyRow.ZIndex=91
    KeyRowC.CornerRadius=UDim.new(0,5) KeyRowC.Parent=KeyRow
    KeyLabel.Parent=KeyRow KeyLabel.BackgroundTransparency=1 KeyLabel.Position=UDim2.new(0,8,0,0) KeyLabel.Size=UDim2.new(1,-70,1,0) KeyLabel.Font=Enum.Font.GothamSemibold KeyLabel.Text="UI Toggle :" KeyLabel.TextColor3=Color3.new(1,1,1) KeyLabel.TextSize=9 KeyLabel.TextXAlignment=Enum.TextXAlignment.Left KeyLabel.ZIndex=92
    KeyPill.Parent=KeyRow KeyPill.BackgroundColor3=Color3.fromRGB(10,10,10) KeyPill.BorderSizePixel=0 KeyPill.Position=UDim2.new(1,-52,0.5,-9) KeyPill.Size=UDim2.new(0,44,0,18) KeyPill.Font=Enum.Font.GothamSemibold KeyPill.Text=UIToggleKey.Name KeyPill.TextColor3=Color3.new(1,1,1) KeyPill.TextSize=9 KeyPill.AutoButtonColor=false KeyPill.ZIndex=92
    do local KC=Instance.new("UITextSizeConstraint") KC.MaxTextSize=9 KC.Parent=KeyLabel end
    do local KC2=Instance.new("UITextSizeConstraint") KC2.MaxTextSize=9 KC2.Parent=KeyPill end
    KeyPillC.CornerRadius=UDim.new(0,5) KeyPillC.Parent=KeyPill
    RegTheme(KeyRow,"Row")
    local listening=false
    KeyPill.MouseButton1Click:Connect(function() listening=true KeyPill.Text="..." end)
    UIS.InputBegan:Connect(function(i,gp)
        if not listening then return end
        if SearchBox:IsFocused() then return end
        if i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode~=Enum.KeyCode.Escape then
            UIToggleKey=i.KeyCode KeyPill.Text=i.KeyCode.Name RefreshHotkeys()
        end
        listening=false
        if KeyPill.Text=="..." then KeyPill.Text=UIToggleKey.Name end
    end)
    SettingSetters["UIToggleKey"]=function(v)
        if typeof(v)=="EnumItem" then UIToggleKey=v KeyPill.Text=v.Name RefreshHotkeys() end
    end
end
do
    local r1=MakeCheckRow(SettingsPanel,"Keybind list",SettingsState.KeybindList,42)
    r1.OnChange=function(v) SettingsState.KeybindList=v SlideHotkeys(v) end
    SettingSetters["KeybindList"]=function(v) r1.Set(v) SettingsState.KeybindList=v==true SlideHotkeys(v==true) end
    local r2=MakeCheckRow(SettingsPanel,"Show notifications",SettingsState.Notifications,74)
    r2.OnChange=function(v) SettingsState.Notifications=v Library.NotificationsEnabled=v end
    SettingSetters["Notifications"]=function(v) r2.Set(v) SettingsState.Notifications=v==true Library.NotificationsEnabled=v==true end
    local r3=MakeCheckRow(SettingsPanel,"Custom kick",SettingsState.CustomKick,106)
    r3.OnChange=function(v) SettingsState.CustomKick=v end
    SettingSetters["CustomKick"]=function(v) r3.Set(v) SettingsState.CustomKick=v==true end
    local r5=MakeCheckRow(SettingsPanel,"Always trigger",SettingsState.AlwaysTrigger,138)
    r5.OnChange=function(v) SettingsState.AlwaysTrigger=v end
    SettingSetters["AlwaysTrigger"]=function(v) r5.Set(v) SettingsState.AlwaysTrigger=v==true end
end
--// HOTKEYS LIST PANEL (draggable, left side)
local HotkeysPanel=Instance.new("Frame")
local HotkeysCorner=Instance.new("UICorner")
local HotkeysHead=Instance.new("TextLabel")
local HotkeyList=Instance.new("Frame")
local HotkeyLayout=Instance.new("UIListLayout")
HotkeysPanel.Parent=Gui
HotkeysPanel.BackgroundTransparency=1
HotkeysPanel.BorderSizePixel=0
HotkeysPanel.Position=UDim2.new(0,15,0.5,-10)
HotkeysPanel.Size=UDim2.new(0,150,0,34)
HotkeysPanel.Visible=SettingsState.KeybindList
HotkeysPanel.Active=true
HotkeysPanel.ZIndex=80
HotkeysCorner.CornerRadius=UDim.new(0,6)
HotkeysCorner.Parent=HotkeysPanel
HotkeysHead.Parent=HotkeysPanel
HotkeysHead.BackgroundTransparency=1
HotkeysHead.BorderSizePixel=0
HotkeysHead.Size=UDim2.new(1,-16,0,20)
HotkeysHead.Position=UDim2.new(0,8,0,2)
HotkeysHead.Font=Enum.Font.GothamSemibold
HotkeysHead.Text="hotkeys"
HotkeysHead.TextColor3=Color3.fromRGB(200,200,200)
HotkeysHead.TextSize=11
HotkeysHead.TextXAlignment=Enum.TextXAlignment.Left
HotkeyList.Parent=HotkeysPanel
HotkeyList.BackgroundTransparency=1
HotkeyList.Position=UDim2.new(0,8,0,28)
HotkeyList.Size=UDim2.new(1,-16,1,-32)
HotkeyLayout.Parent=HotkeyList
HotkeyLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
HotkeyLayout.SortOrder=Enum.SortOrder.LayoutOrder
HotkeyLayout.Padding=UDim.new(0,4)
do
    local hd,hi,hs,hp
    HotkeysHead.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            hd=true hs=i.Position hp=HotkeysPanel.Position
i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then hd=false end end)
        end
    end)
HotkeysHead.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then hi=i end end)
    UIS.InputChanged:Connect(function(i)
        if i==hi and hd then
            local d=i.Position-hs
HotkeysPanel.Position=UDim2.new(hp.X.Scale,hp.X.Offset+d.X,hp.Y.Scale,hp.Y.Offset+d.Y)
        end
    end)
end
local hkSlideToken=0
local function SlideHotkeys(show)
    hkSlideToken+=1
    local tk=hkSlideToken
    if show then
        HotkeysPanel.Visible=true
        local p=HotkeysPanel.Position
        HotkeysPanel.Position=UDim2.new(p.X.Scale,p.X.Offset-160,p.Y.Scale,p.Y.Offset)
        TweenService:Create(HotkeysPanel,TweenInfo.new(.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=p}):Play()
    else
        local p=HotkeysPanel.Position
        local tw=TweenService:Create(HotkeysPanel,TweenInfo.new(.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Position=UDim2.new(p.X.Scale,p.X.Offset-160,p.Y.Scale,p.Y.Offset)})
        tw:Play()
        tw.Completed:Connect(function() if tk==hkSlideToken and not SettingsState.KeybindList then HotkeysPanel.Visible=false end end)
    end
end
--// KEYBIND EDITOR POPUP (diamond click)
local KeyPopup=Instance.new("Frame")
local KeyPopupCorner=Instance.new("UICorner")
KeyPopup.Parent=Frame
KeyPopup.BackgroundColor3=Color3.fromRGB(15,15,15)
KeyPopup.BorderSizePixel=0
KeyPopup.Position=UDim2.new(0,150,0,100)
KeyPopup.Size=UDim2.new(0,196,0,118)
KeyPopup.Visible=false
KeyPopup.ZIndex=200
RegTheme(KeyPopup,"Panel")
KeyPopupCorner.CornerRadius=UDim.new(0,6)
KeyPopupCorner.Parent=KeyPopup
local PopupCtx=nil
local KPL1=Instance.new("TextLabel")
KPL1.Parent=KeyPopup KPL1.BackgroundTransparency=1 KPL1.Position=UDim2.new(0,8,0,8) KPL1.Size=UDim2.new(0,64,0,20) KPL1.Font=Enum.Font.GothamSemibold KPL1.Text="Keybinds :" KPL1.TextColor3=Color3.new(1,1,1) KPL1.TextSize=11 KPL1.TextXAlignment=Enum.TextXAlignment.Left KPL1.ZIndex=201
local KPPill=Instance.new("TextButton") local KPPillC=Instance.new("UICorner")
KPPill.Parent=KeyPopup KPPill.BackgroundColor3=Color3.fromRGB(10,10,10) KPPill.BorderSizePixel=0 KPPill.Position=UDim2.new(0,76,0,8) KPPill.Size=UDim2.new(0,56,0,20) KPPill.Font=Enum.Font.GothamSemibold KPPill.Text="None" KPPill.TextColor3=Color3.new(1,1,1) KPPill.TextSize=10 KPPill.AutoButtonColor=false KPPill.ZIndex=201
KPPillC.CornerRadius=UDim.new(0,5) KPPillC.Parent=KPPill
local KPRemove=Instance.new("TextButton") local KPRemoveC=Instance.new("UICorner")
KPRemove.Parent=KeyPopup KPRemove.BackgroundColor3=Color3.fromRGB(30,30,30) KPRemove.BorderSizePixel=0 KPRemove.Position=UDim2.new(0,136,0,8) KPRemove.Size=UDim2.new(0,52,0,20) KPRemove.Font=Enum.Font.GothamSemibold KPRemove.Text="Remove" KPRemove.TextColor3=Color3.fromRGB(200,200,200) KPRemove.TextSize=10 KPRemove.AutoButtonColor=false KPRemove.ZIndex=201
KPRemoveC.CornerRadius=UDim.new(0,5) KPRemoveC.Parent=KPRemove
local KPL2=Instance.new("TextLabel")
KPL2.Parent=KeyPopup KPL2.BackgroundTransparency=1 KPL2.Position=UDim2.new(0,8,0,34) KPL2.Size=UDim2.new(1,-16,0,14) KPL2.Font=Enum.Font.GothamSemibold KPL2.Text="activate when" KPL2.TextColor3=Color3.fromRGB(150,150,150) KPL2.TextSize=10 KPL2.TextXAlignment=Enum.TextXAlignment.Left KPL2.ZIndex=201
local KPMode=Instance.new("TextButton") local KPModeC=Instance.new("UICorner")
KPMode.Parent=KeyPopup KPMode.BackgroundColor3=Color3.fromRGB(20,20,20) KPMode.BorderSizePixel=0 KPMode.Position=UDim2.new(0,8,0,52) KPMode.Size=UDim2.new(1,-16,0,26) KPMode.Font=Enum.Font.GothamSemibold KPMode.Text="toggled" KPMode.TextColor3=Color3.new(1,1,1) KPMode.TextSize=11 KPMode.AutoButtonColor=false KPMode.ZIndex=201
KPModeC.CornerRadius=UDim.new(0,5) KPModeC.Parent=KPMode
do
    for i,dy in ipairs({6,12,18}) do
        local HB=Instance.new("Frame")
        HB.Parent=KPMode HB.BackgroundColor3=Color3.new(1,1,1) HB.BorderSizePixel=0 HB.Position=UDim2.new(1,-22,0,dy) HB.Size=UDim2.new(0,12,0,2) HB.ZIndex=202
    end
end
local KPList=Instance.new("Frame") local KPListC=Instance.new("UICorner")
KPList.Parent=KeyPopup KPList.BackgroundColor3=Color3.fromRGB(20,20,20) KPList.BorderSizePixel=0 KPList.Position=UDim2.new(0,8,0,82) KPList.Size=UDim2.new(1,-16,0,0) KPList.Visible=false KPList.ZIndex=205 KPList.ClipsDescendants=true
KPListC.CornerRadius=UDim.new(0,5) KPListC.Parent=KPList
local KPOptLayout=Instance.new("UIListLayout")
KPOptLayout.Parent=KPList KPOptLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center KPOptLayout.SortOrder=Enum.SortOrder.LayoutOrder KPOptLayout.Padding=UDim.new(0,2)
for _,modeName in ipairs({"toggled","hold"}) do
    local O=Instance.new("TextButton") local OC=Instance.new("UICorner")
    O.Parent=KPList O.BackgroundColor3=Color3.fromRGB(10,10,10) O.BorderSizePixel=0 O.Size=UDim2.new(1,-8,0,20) O.AutoButtonColor=false O.Font=Enum.Font.GothamSemibold O.Text=modeName O.TextColor3=Color3.new(1,1,1) O.TextSize=10 O.ZIndex=206
    OC.CornerRadius=UDim.new(0,4) OC.Parent=O
    O.MouseButton1Click:Connect(function()
        if PopupCtx and PopupCtx.SetModeFn then
            pcall(PopupCtx.SetModeFn, modeName=="hold" and "Hold" or "Toggle")
        end
        KPList.Visible=false KPList.Size=UDim2.new(1,-16,0,0)
        RefreshKeyPopup()
    end)
end
local function BindPillText(k)
    if typeof(k)~="EnumItem" then return "None" end
    local n=tostring(k.Name or "None")
    if k.EnumType==Enum.UserInputType then n=n:gsub("MouseButton","MB") end
    return n
end
function RefreshKeyPopup()
    if not PopupCtx then return end
    local ok,k=pcall(PopupCtx.GetBind)
    KPPill.Text=(ok and BindPillText(k) or "None")
    local ok2,m=pcall(PopupCtx.GetMode)
    KPMode.Text=(ok2 and type(m)=="string" and m:lower() or "toggled")
end
KPPill.MouseButton1Click:Connect(function()
    KPPill.Text="..."
    local conn=nil
    conn=UIS.InputBegan:Connect(function(i,gp)
        if SearchBox:IsFocused() then return end
        if i.UserInputType==Enum.UserInputType.Keyboard or i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.MouseButton2 or i.UserInputType==Enum.UserInputType.MouseButton3 then
            if PopupCtx and PopupCtx.SetBind then
                if i.KeyCode==Enum.KeyCode.Escape or i.KeyCode==Enum.KeyCode.Backspace then
                    pcall(PopupCtx.SetBind,nil)
                elseif i.UserInputType==Enum.UserInputType.Keyboard then
                    pcall(PopupCtx.SetBind,i.KeyCode)
                else
                    pcall(PopupCtx.SetBind,i.UserInputType)
                end
            end
            RefreshKeyPopup()
            if conn then conn:Disconnect() conn=nil end
        end
    end)
end)
KPRemove.MouseButton1Click:Connect(function()
    if PopupCtx and PopupCtx.SetBind then pcall(PopupCtx.SetBind,nil) end
    RefreshKeyPopup()
end)
KPMode.MouseButton1Click:Connect(function()
    if not PopupCtx then return end
    KPList.Visible=not KPList.Visible
    KPList.Size=KPList.Visible and UDim2.new(1,-16,0,48) or UDim2.new(1,-16,0,0)
end)
OpenKeybindPopup=function(ctx)
    if not ctx or not ctx.Anchor then return end
    if PopupCtx and PopupCtx.Anchor==ctx.Anchor and KeyPopup.Visible then KeyPopup.Visible=false PopupCtx=nil KPList.Visible=false return end
    PopupCtx=ctx
    KPList.Visible=false KPList.Size=UDim2.new(1,-16,0,0)
    local ok,ap=pcall(function() return ctx.Anchor.AbsolutePosition end)
    local fs=Frame.AbsoluteSize local fp=Frame.AbsolutePosition
    local ax,ay=150,100
    if ok then
        ax=math.clamp(ap.X-fp.X,4,math.max(4,fs.X-200))
        ay=math.clamp(ap.Y-fp.Y+22,4,math.max(4,fs.Y-122))
    end
KeyPopup.Position=UDim2.new(0,ax,0,ay)
    KeyPopup.Visible=true
    RefreshKeyPopup()
end
RefreshHotkeys=function()
    for _,ch in ipairs(HotkeyList:GetChildren()) do if ch.Name=="HKRow" then ch:Destroy() end end
    local n=0
    for _,src in ipairs(HotkeySources) do
        local ok,key=pcall(src.Get)
        if ok and (key==nil or typeof(key)=="EnumItem") then
            n+=1
            local ks=key and KeyToText(key) or " "
            local R=Instance.new("TextButton") local RC=Instance.new("UICorner")
            R.Name="HKRow" R.Parent=HotkeyList R.BackgroundColor3=CurrentTheme.Row R.BorderSizePixel=0 R.Size=UDim2.new(1,0,0,22) R.AutoButtonColor=false R.Font=Enum.Font.GothamSemibold R.Text="["..ks.."] "..tostring(src.Label or "") R.TextColor3=Color3.new(1,1,1)             R.TextSize=10 R.ZIndex=81; do local _zc=Instance.new("UITextSizeConstraint") _zc.MaxTextSize=10 _zc.Parent=R end R.TextScaled=true R.ClipsDescendants=true
            R.LayoutOrder=n
            RC.CornerRadius=UDim.new(0,5) RC.Parent=R
            RegTheme(R,"Row")
        end
    end
    if n==0 then
        local R=Instance.new("TextButton") local RC=Instance.new("UICorner")
        R.Name="HKRow" R.Parent=HotkeyList R.BackgroundColor3=Color3.fromRGB(0,0,0) R.BorderSizePixel=0 R.Size=UDim2.new(1,0,0,22) R.AutoButtonColor=false R.Font=Enum.Font.GothamSemibold R.Text="No hotkeys" R.TextColor3=Color3.fromRGB(120,120,120) R.TextSize=10 R.ZIndex=81; do local _zc=Instance.new("UITextSizeConstraint") _zc.MaxTextSize=10 _zc.Parent=R end
        RC.CornerRadius=UDim.new(0,5) RC.Parent=R
        n=1
    end
HotkeysPanel.Size=UDim2.new(0,150,0,36+n*26)
end
function Library:RegisterHotkey(key,label)
    if key~=nil and typeof(key)~="EnumItem" then return nil end
    local src={Label=tostring(label or "hotkey"),Key=key}
    src.Get=function() return src.Key end
    table.insert(HotkeySources,src)
    RefreshHotkeys()
    return {Set=function(k) if typeof(k)=="EnumItem" then src.Key=k RefreshHotkeys() end end,Remove=function() for i,s in ipairs(HotkeySources) do if s==src then table.remove(HotkeySources,i) break end end RefreshHotkeys() end}
end
table.insert(HotkeySources,{Label="gui keybind",Get=function() return UIToggleKey end})
--// NOTIFY TOAST (themed, bottom-center pop, gated by Show notifications)
Library._toasts=Library._toasts or {}
function Library:Notify(text,dur)
    if not Library.NotificationsEnabled then return end
    dur=tonumber(dur) or 3
    local idx=#Library._toasts+1
    local baseY=-70-((idx-1)*38)
    local T=Instance.new("Frame") local TC=Instance.new("UICorner")
    local Dot=Instance.new("Frame") local DotC=Instance.new("UICorner") local DotS=Instance.new("UIStroke")
    local I=Instance.new("TextLabel") local L=Instance.new("TextLabel")
    T.Parent=Gui T.BackgroundColor3=CurrentTheme.Row T.BorderSizePixel=0
    T.AnchorPoint=Vector2.new(.5,1) T.Position=UDim2.new(.5,0,1,baseY+18) T.Size=UDim2.new(0,280,0,30) T.ZIndex=300
    TC.CornerRadius=UDim.new(0,6) TC.Parent=T
    RegTheme(T,"Row")
    Dot.Parent=T Dot.BackgroundTransparency=1 Dot.AnchorPoint=Vector2.new(.5,.5) Dot.Position=UDim2.new(0,18,0.5,0) Dot.Size=UDim2.new(0,14,0,14) Dot.ZIndex=301
    DotC.CornerRadius=UDim.new(1,0) DotC.Parent=Dot
    DotS.Color=CurrentTheme.Accent DotS.Thickness=1.5 DotS.Transparency=1 DotS.Parent=Dot
    I.Parent=Dot I.BackgroundTransparency=1 I.Size=UDim2.new(1,0,1,0) I.Font=Enum.Font.GothamBold I.Text="i" I.TextColor3=CurrentTheme.Accent I.TextSize=10 I.TextTransparency=1 I.ZIndex=302
    L.Parent=T L.BackgroundTransparency=1 L.Position=UDim2.new(0,34,0,0) L.Size=UDim2.new(1,-42,1,0) L.Font=Enum.Font.GothamSemibold L.Text=tostring(text or "") L.TextColor3=Color3.new(1,1,1) L.TextSize=11 L.TextXAlignment=Enum.TextXAlignment.Left L.TextTransparency=1 L.ZIndex=301 L.TextScaled=true L.ClipsDescendants=true
    do local LC=Instance.new("UITextSizeConstraint") LC.MaxTextSize=11 LC.Parent=L end
    table.insert(Library._toasts,T)
    T.BackgroundTransparency=1
    TweenService:Create(T,TweenInfo.new(.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(.5,0,1,baseY),BackgroundTransparency=0}):Play()
    TweenService:Create(L,TweenInfo.new(.25),{TextTransparency=0}):Play()
    TweenService:Create(I,TweenInfo.new(.25),{TextTransparency=0}):Play()
    TweenService:Create(DotS,TweenInfo.new(.25),{Transparency=0}):Play()
    task.delay(dur,function()
        if not T.Parent then return end
        TweenService:Create(T,TweenInfo.new(.3),{BackgroundTransparency=1}):Play()
        TweenService:Create(L,TweenInfo.new(.3),{TextTransparency=1}):Play()
        TweenService:Create(I,TweenInfo.new(.3),{TextTransparency=1}):Play()
        TweenService:Create(DotS,TweenInfo.new(.3),{Transparency=1}):Play()
        task.wait(.32)
        for i,v in ipairs(Library._toasts) do if v==T then table.remove(Library._toasts,i) break end end
        pcall(function() T:Destroy() end)
    end)
end
RefreshHotkeys()
task.delay(3,function()
    local rows=0
    for _,ch in ipairs(HotkeyList:GetChildren()) do if ch.Name=="HKRow" then rows+=1 end end
    local sk={}
    pcall(function() for key in pairs(SettingSetters) do sk[#sk+1]=tostring(key) end end)
    table.sort(sk)
    local pw,cell,over,homeW,kids,contentH=0,"?",0,0,0,0
    local pageInfo={}
    local mainCells={}
    pcall(function()
        for _,page in ipairs(Folder:GetChildren()) do
            if page.Name=="Main" and page:IsA("ScrollingFrame") then
                local tmp={}
                for _,c in ipairs(page:GetChildren()) do
                    if c:IsA("Frame") then
                        local lbl="?"
                        pcall(function()
                            for _,d in ipairs(c:GetDescendants()) do
                                if d:IsA("TextLabel") and tostring(d.Text)~="" then lbl=tostring(d.Text):sub(1,22) break end
                            end
                        end)
                        table.insert(tmp,{o=c.LayoutOrder or 0,t=lbl})
                    end
                end
                table.sort(tmp,function(a,b) return a.o<b.o end)
                for _,e in ipairs(tmp) do table.insert(mainCells,e.o..":"..e.t) end
            end
        end
    end)
    pcall(function()
        for _,page in ipairs(Folder:GetChildren()) do
            if page:IsA("ScrollingFrame") and pw==0 then pw=math.floor(page.AbsoluteSize.X) end
        end
        local gl=Folder:GetChildren()[1]
        if gl then
            homeW=math.floor(gl.AbsoluteSize.X)
            local grid=gl:FindFirstChildOfClass("UIGridLayout")
            if grid then
                cell=tostring(grid.CellSize)
                contentH=math.floor(grid.AbsoluteContentSize.Y)
                for _,c in ipairs(gl:GetChildren()) do if c:IsA("Frame") then kids+=1 end end
            end
        end
        for _,page in ipairs(Folder:GetChildren()) do
            if page:IsA("ScrollingFrame") then
                local k,h2=0,0
                for _,c in ipairs(page:GetChildren()) do if c:IsA("Frame") then k+=1 end end
                local g2=page:FindFirstChildOfClass("UIGridLayout")
                if g2 then h2=math.floor(g2.AbsoluteContentSize.Y) end
                table.insert(pageInfo,page.Name..":"..k.."/"..h2)
            end
        end
    end)
        for _,page in ipairs(Folder:GetChildren()) do
            if page:IsA("ScrollingFrame") then
                for _,h in ipairs(page:GetChildren()) do
                    if h:IsA("Frame") and h.AbsoluteSize.X>100 then
                        local hr=h.AbsolutePosition.X+h.AbsoluteSize.X
                        for _,c in ipairs(h:GetDescendants()) do
                            if c:IsA("GuiObject") and c.Visible and c.AbsoluteSize.X>0 then
                                if c.AbsolutePosition.X+c.AbsoluteSize.X>hr+1 then over+=1 break end
                            end
                        end
                    end
                end
            end
        end
    print("[winhvh] diag: hotkeysVisible="..tostring(HotkeysPanel.Visible).." hotkeyRows="..tostring(rows).." pageW="..tostring(pw).." homeW="..tostring(homeW).." kids="..tostring(kids).." contentH="..tostring(contentH).." cell="..tostring(cell).." overflows="..tostring(over).." pages={"..table.concat(pageInfo,",").."} main={"..table.concat(mainCells,"|").."} setters="..table.concat(sk,","))
end)
return PageYep
end
--// XK5NG INTRO: info card first, then character viewport slides in
function Library:ShowIntro(lines, titleText, holdTime)
    local infoLines=lines or {
        "winhvh",
        "For mobile user or xeno user",
        "Dont use the flame mode for ragebot",
        "winhvh",
        "Loaded",
    }
    if type(infoLines)=="string" then
        local split={}
        for line in tostring(infoLines):gmatch("[^\n]+") do table.insert(split, line) end
        infoLines=split
    end
    titleText=titleText or "winhvh"
    holdTime=tonumber(holdTime) or 6
    local parent=game.CoreGui
    local ok,plrGui=pcall(function() return Players.LocalPlayer:WaitForChild("PlayerGui", 5) end)
    local IntroGui=Instance.new("ScreenGui")
    IntroGui.Name="winhvh_Intro"
    IntroGui.ResetOnSpawn=false
    IntroGui.ZIndexBehavior=Enum.ZIndexBehavior.Global
    pcall(function() IntroGui.Parent=parent end)
    if not IntroGui.Parent and ok and plrGui then IntroGui.Parent=plrGui end
    --// Info card (black box, top)
    local Card=Instance.new("Frame")
    local CardCorner=Instance.new("UICorner")
    local CardLayout=Instance.new("UIListLayout")
    Card.Parent=IntroGui
    Card.BackgroundColor3=Color3.fromRGB(8,8,8)
    Card.BorderSizePixel=0
    Card.AnchorPoint=Vector2.new(0,0)
    Card.Position=UDim2.new(0,12,-.4,0)
    Card.Size=UDim2.new(0,300,0,30+(#infoLines*17))
    CardCorner.CornerRadius=UDim.new(0,6)
    CardCorner.Parent=Card
    CardLayout.Parent=Card
    CardLayout.HorizontalAlignment=Enum.HorizontalAlignment.Left
    CardLayout.SortOrder=Enum.SortOrder.LayoutOrder
    CardLayout.Padding=UDim.new(0,2)
    local CardPad=Instance.new("UIPadding")
    CardPad.PaddingTop=UDim.new(0,8)
    CardPad.PaddingLeft=UDim.new(0,10)
    CardPad.PaddingRight=UDim.new(0,10)
    CardPad.Parent=Card
    local labels={}
    for _,line in ipairs(infoLines) do
        local L=Instance.new("TextLabel")
        L.Parent=Card
        L.BackgroundTransparency=1
        L.Size=UDim2.new(1,0,0,15)
        L.Font=Enum.Font.GothamSemibold
        L.Text=tostring(line)
        L.TextColor3=Color3.new(1,1,1)
        L.TextSize=11
        L.TextXAlignment=Enum.TextXAlignment.Left
        L.TextTransparency=1
        table.insert(labels, L)
    end
    --// Character box (below card)
    local CharBox=Instance.new("Frame")
    local CharCorner=Instance.new("UICorner")
    CharBox.Parent=IntroGui
    CharBox.BackgroundColor3=Color3.fromRGB(200,200,200)
    CharBox.BorderSizePixel=0
    CharBox.AnchorPoint=Vector2.new(0,0)
    CharBox.Position=UDim2.new(0,12,1.2,0)
    CharBox.Size=UDim2.new(0,300,0,260)
    CharCorner.CornerRadius=UDim.new(0,6)
    CharCorner.Parent=CharBox
    local Viewport=Instance.new("ViewportFrame")
    Viewport.Parent=CharBox
    Viewport.BackgroundTransparency=1
    Viewport.Position=UDim2.new(0,0,0,0)
    Viewport.Size=UDim2.new(1,0,1,0)
    Viewport.LightColor=Color3.new(1,1,1)
    Viewport.LightDirection=Vector3.new(0,-1,-1)
    Viewport.Ambient=Color3.new(.7,.7,.7)
    local LoadedLabel=Instance.new("TextLabel")
    LoadedLabel.Parent=CharBox
    LoadedLabel.BackgroundTransparency=1
    LoadedLabel.Position=UDim2.new(0,0,0,4)
    LoadedLabel.Size=UDim2.new(1,0,0,16)
    LoadedLabel.Font=Enum.Font.GothamBold
    LoadedLabel.Text=titleText.." Loaded"
    LoadedLabel.TextColor3=Color3.fromRGB(20,20,20)
    LoadedLabel.TextSize=11
    --// Build character model
    task.spawn(function()
        local model=nil
        pcall(function()
            local lp=Players.LocalPlayer
            local char=lp.Character or lp.CharacterAdded:Wait()
            char.Archivable=true
            local clone=char:Clone()
            clone.Parent=nil
            for _,d in ipairs(clone:GetDescendants()) do
                if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Animator") then
                    pcall(function() d:Destroy() end)
                end
            end
            model=clone
        end)
        if model then
            local wm=Instance.new("WorldModel")
            wm.Parent=Viewport
            model.Parent=wm
            local hrp=model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
            local cam=Instance.new("Camera")
            cam.Parent=Viewport
            Viewport.CurrentCamera=cam
            if hrp then
                local focus=hrp.Position
                cam.CFrame=CFrame.new(focus+Vector3.new(0,.5,5.5), focus+Vector3.new(0,.5,0))
                task.spawn(function()
                    local t0=tick()
                    while Viewport.Parent and tick()-t0<holdTime+4 do
                        local a=(tick()-t0)*.4
                        if hrp.Parent then
                            cam.CFrame=CFrame.new(focus+Vector3.new(math.sin(a)*5.5,.5,math.cos(a)*5.5), focus+Vector3.new(0,.5,0))
                        end
                        task.wait(.03)
                    end
                end)
            end
        else
            local F=Instance.new("TextLabel")
            F.Parent=Viewport
            F.BackgroundTransparency=1
            F.Size=UDim2.new(1,0,1,0)
            F.Font=Enum.Font.GothamBold
            F.Text=":)"
            F.TextColor3=Color3.fromRGB(40,40,40)
            F.TextSize=60
        end
    end)
    --// Animation: notif first (left side), then character next
    TweenService:Create(Card, TweenInfo.new(.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position=UDim2.new(0,12,.06,0)}):Play()
    for i,L in ipairs(labels) do
        task.delay(.25+i*.18, function()
            if L.Parent then TweenService:Create(L, TweenInfo.new(.3), {TextTransparency=0}):Play() end
        end)
    end
    task.delay(.4+(#labels*.18), function()
        if CharBox.Parent then TweenService:Create(CharBox, TweenInfo.new(.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position=UDim2.new(0,12,.06+Card.AbsoluteSize.Y/math.max(1,IntroGui.AbsoluteSize.Y)+.02,0)}):Play() end
    end)
    task.delay(holdTime, function()
        if not IntroGui.Parent then return end
        local out1=TweenService:Create(Card, TweenInfo.new(.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position=UDim2.new(0,12,-.5,0)})
        local out2=TweenService:Create(CharBox, TweenInfo.new(.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position=UDim2.new(0,12,1.2,0)})
        out1:Play() out2:Play()
        out2.Completed:Wait()
        pcall(function() IntroGui:Destroy() end)
    end)
    return IntroGui
end
Library.Version=45
return Library
