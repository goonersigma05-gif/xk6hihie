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
local ConfigFolder="Skido"
local PluginFolder=ConfigFolder.."/skido_plugin"
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
    Scale.Scale=1.1
    Scale.Parent=Frame
    Corner.CornerRadius=UDim.new(0,7)
    Corner.Parent=Frame
    Dash.Parent=Frame
    Dash.BackgroundColor3=Color3.fromRGB(13,13,13)
    Dash.BorderSizePixel=0
    Dash.Position=UDim2.new(.018,0,.168,0)
    Dash.Size=UDim2.new(0,130,0,318)
    DashCorner.CornerRadius=UDim.new(0,6)
    DashCorner.Parent=Dash
    Tabs.Parent=Dash
Tabs.BackgroundTransparency=1
Tabs.BorderSizePixel=0
Tabs.Position=UDim2.new(.03,0,.035,0)
Tabs.Size=UDim2.new(0,122,1,-18)
Tabs.CanvasSize=UDim2.new(0,0,0,0)
Tabs.ScrollBarThickness=3
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
    PagesCorner.CornerRadius=UDim.new(0,6)
    PagesCorner.Parent=Pages
    Folder.Parent=Pages
    Folder.Name="PageFolder"
    Title.Parent=Frame
    Title.BackgroundTransparency=1
    Title.Position=UDim2.new(.025,0,.015,0)
    Title.Size=UDim2.new(0,180,0,20)
    Title.Font=Enum.Font.GothamBold
    Title.Text=windowname or "XKSNG R-PT2-V2.5"
    Title.TextColor3=Color3.fromRGB(200,40,40)
    Title.TextSize=13
    Title.TextXAlignment=Enum.TextXAlignment.Left
    local Subtitle=Instance.new("TextLabel")
    Subtitle.Parent=Frame
    Subtitle.BackgroundTransparency=1
    Subtitle.Position=UDim2.new(.025,0,.06,0)
    Subtitle.Size=UDim2.new(0,180,0,14)
    Subtitle.Font=Enum.Font.GothamSemibold
    Subtitle.Text=windowinfo or "メイン"
    Subtitle.TextColor3=Color3.fromRGB(130,130,130)
    Subtitle.TextSize=10
    Subtitle.TextXAlignment=Enum.TextXAlignment.Left
    local PageHeader=Instance.new("TextLabel")
    PageHeader.Parent=Frame
    PageHeader.Name="XK5NG_PageHeader"
    PageHeader.BackgroundTransparency=1
    PageHeader.Position=UDim2.new(.245,0,.10,0)
    PageHeader.Size=UDim2.new(0,200,0,20)
    PageHeader.Font=Enum.Font.GothamBold
    PageHeader.Text="Main"
    PageHeader.TextColor3=Color3.new(1,1,1)
    PageHeader.TextSize=13
    PageHeader.TextXAlignment=Enum.TextXAlignment.Left
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
    --// SEARCH
    local SearchBox=Instance.new("TextBox")
    local SearchCorner=Instance.new("UICorner")
    local SearchStroke=Instance.new("UIStroke")
    SearchBox.Parent=Frame
    SearchBox.BackgroundColor3=Color3.fromRGB(24,24,24)
    SearchBox.BorderSizePixel=0
    SearchBox.Position=UDim2.new(.27,0,.03,0)
    SearchBox.Size=UDim2.new(0,220,0,24)
    SearchBox.Font=Enum.Font.GothamSemibold
    SearchBox.PlaceholderText="Search..."
    SearchBox.PlaceholderColor3=Color3.fromRGB(100,100,100)
    SearchBox.Text=""
    SearchBox.TextColor3=Color3.new(1,1,1)
    SearchBox.TextSize=10
    SearchBox.ClearTextOnFocus=false
    SearchBox.TextXAlignment=Enum.TextXAlignment.Left
    SearchBox.ZIndex=50
    SearchCorner.CornerRadius=UDim.new(0,5)
    SearchCorner.Parent=SearchBox
    SearchStroke.Color=Color3.fromRGB(35,35,35)
    SearchStroke.Transparency=.15
    SearchStroke.Parent=SearchBox
    local SearchPadding=Instance.new("UIPadding")
    SearchPadding.PaddingLeft=UDim.new(0,8)
    SearchPadding.PaddingRight=UDim.new(0,8)
    SearchPadding.Parent=SearchBox
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
CreditIcon.MouseEnter:Connect(function() CreditText.TextTransparency=0 CreditIcon.ImageColor3=Color3.fromRGB(200,50,50) end)
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
    Min.TextColor3=Color3.fromRGB(200,60,60)
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
    Float.Text="Skido"
    Float.TextColor3=Color3.fromRGB(200,50,50)
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
    UIS.InputBegan:Connect(function(i,gp)
        if gp then return end
        if i.KeyCode==Enum.KeyCode.Semicolon then
            if not Frame.Visible then
                visible=true
                Frame.Visible=true
            end
            SearchBox:CaptureFocus()
            SearchBox.CursorPosition=#SearchBox.Text+1
            return
        end
        if i.KeyCode==Enum.KeyCode.RightShift then
            visible=not visible
            Frame.Visible=visible
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
    local UIScaleValue=1.1
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
    for _,page in ipairs(Folder:GetChildren()) do
        if page:IsA("ScrollingFrame") then
page.Size=UDim2.new(1, -3, 0, contentHeight-13)
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
    ToggleTitle.TextColor3=Color3.fromRGB(200,50,50)
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
                        Color3.fromRGB(80,30,30)
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
        Tab.BackgroundColor3=visible and Color3.fromRGB(28,28,28) or Color3.fromRGB(13,13,13)
        Tab.BorderSizePixel=0
        Tab.Size=UDim2.new(0,116,0,24)
        Tab.AutoButtonColor=false
        Tab.Font=Enum.Font.GothamSemibold
        Tab.Text="  "..pageName
        Tab.TextColor3=visible and Color3.new(1,1,1) or Color3.fromRGB(140,140,140)
        Tab.TextSize=11
        Tab.TextTransparency=0
        Tab.TextXAlignment=Enum.TextXAlignment.Left
        TC.CornerRadius=UDim.new(0,5)
        TC.Parent=Tab
        Home.Name=pageName
        Home.Parent=Folder
        Home.Active=true
        Home.BackgroundTransparency=1
        Home.BorderSizePixel=0
        Home.Position=UDim2.new(0,6,.06,0)
        Home.Size=UDim2.new(1,-12,0,295)
        Home.ScrollBarThickness=4
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
        Layout.CellPadding=UDim2.new(0,6,0,5)
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
            local header=Frame:FindFirstChild("XK5NG_PageHeader")
            if header then header.Text=pageName end
            for _,t in ipairs(Tabs:GetChildren()) do
                if t:IsA("GuiButton") then
                    local selected=t==Tab
                    t.BackgroundColor3=
                        selected
                        and Color3.fromRGB(28,28,28)
                        or Color3.fromRGB(13,13,13)
                    t.TextColor3=
                        selected
                        and Color3.new(1,1,1)
                        or Color3.fromRGB(140,140,140)
                end
            end
            task.defer(UpdateCanvas)
        end
        Tab.MouseButton1Click:Connect(ShowPage)
Tab.MouseEnter:Connect(function() if Tab.BackgroundColor3~=Color3.fromRGB(28,28,28) then Tab.BackgroundColor3=Color3.fromRGB(20,20,20) end end)
Tab.MouseLeave:Connect(function() Tab.BackgroundColor3=Tab.TextColor3==Color3.new(1,1,1) and Color3.fromRGB(28,28,28) or Color3.fromRGB(13,13,13) end)
        local Elements={}
        Elements.__Tab=Tab
        Elements.__Page=Home
        local function RegisterElement(obj,name,typ)
            Register(obj,name,Home,typ)
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
            T.Size=UDim2.new(0,150,0,26)
            T.Font=Enum.Font.GothamSemibold
            T.Text=name or ""
            T.TextColor3=Color3.fromRGB(235,235,235)
            T.TextSize=10
            T.TextXAlignment=Enum.TextXAlignment.Left
            Bind.Parent=H
            Bind.BackgroundColor3=Color3.fromRGB(25,25,25)
            Bind.Position=
                holdToggle
                and UDim2.new(.42,0,0,5)
or (picker and UDim2.new(.49,0,0,5) or UDim2.new(.57,0,0,5))
            Bind.Size=UDim2.new(0,holdToggle and 45 or 52,0,20)
            Bind.Font=Enum.Font.GothamSemibold
            Bind.TextColor3=Color3.fromRGB(150,150,150)
            Bind.TextSize=10
            Bind.Visible=hasBind or UIS.TouchEnabled
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
            if UIS.TouchEnabled then
                Bind.Text="Show"
            elseif currentBind then
Bind.Text=currentBind.Name:gsub("MouseButton", "MB")
            else
                Bind.Text="None"
            end
            TB.Parent=H
            TB.BackgroundTransparency=1
            TB.Position=UDim2.new(.82,0,0,0)
            TB.Size=UDim2.new(0,38,0,26)
            TB.AutoButtonColor=false
            TF.Parent=TB
            TF.BackgroundColor3=default and Color3.new(1,1,1) or Color3.fromRGB(70,70,70)
            TF.Position=UDim2.new(.5,0,.5,0)
            TF.AnchorPoint=Vector2.new(.5,.5)
            TF.Size=UDim2.new(0,13,0,13)
            TFC.Parent=TF
            TFC.CornerRadius=UDim.new(1,0)
            Ball.Parent=TF
            Ball.BackgroundColor3=Color3.new(1,1,1)
            Ball.Position=UDim2.new(0,0,0,0)
            Ball.Size=UDim2.new(1,0,1,0)
            BC.CornerRadius=UDim.new(1,0)
            BC.Parent=Ball
            local armed=default
            local active=keybindMode and false or default
            local closePicker
            local Row
            local function UpdateSwitchVisual()
                local on=(keybindMode or keybindRequiresToggle) and armed or active
                TF.BackgroundColor3=
                    on
                    and Color3.new(1,1,1)
                    or Color3.fromRGB(70,70,70)
                Ball.BackgroundColor3=Color3.new(1,1,1)
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
and Color3.fromRGB(200, 50, 50)
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
                task.defer(UpdateCanvas)
            end
            local modeOpen=false
            SetMode=function(mode)
                local newMode=mode=="Hold" and "Hold" or "Toggle"
                if toggleMode==newMode then
                    ModeButton.Text=toggleMode
                    ModeMenu.Visible=false
                    modeOpen=false
                    UpdateRightRow()
                    UpdateSwitchVisual()
                    return
                end
                toggleMode=newMode
                ModeButton.Text=toggleMode
                ModeMenu.Visible=false
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
                local Canvas=Instance.new("ImageButton")
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
                Panel.Size=UDim2.new(0,296,0,115)
                Panel.Visible=false
                Panel.ZIndex=60
                Panel.BorderSizePixel=0
                Panel.Active=true
                PC.CornerRadius=UDim.new(0,6)
                PC.Parent=Panel
                Canvas.Parent=Panel
                Canvas.BackgroundTransparency=1
                Canvas.Position=UDim2.new(0,8,0,8)
                Canvas.Size=UDim2.new(1,-16,1,-16)
                Canvas.Image="rbxassetid://143332548"
                Canvas.ZIndex=61
                Canvas.AutoButtonColor=false
                Circle.Parent=Canvas
                Circle.AnchorPoint=Vector2.new(.5,.5)
                Circle.BackgroundColor3=color
                Circle.BorderColor3=Color3.new(0,0,0)
                Circle.BorderSizePixel=2
                Circle.Size=UDim2.new(0,10,0,10)
                Circle.ZIndex=62
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
                    if not CB.Parent then return end
                    local p=CB.AbsolutePosition
                    local y=p.Y+CB.AbsoluteSize.Y+4
                    local x=p.X-120
                    local vp=Gui.AbsoluteSize
                    x=math.clamp(x,4,math.max(4,vp.X-300))
                    y=math.clamp(y,4,math.max(4,vp.Y-120))
                    Panel.Position=UDim2.fromOffset(x,y)
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
color=Color3.fromHSV(x, 1-y, 1)
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
            elseif hasBind then
                local listening=false
Bind.MouseButton1Click:Connect(function() Bind.Text="..." listening=true end)
                UIS.InputBegan:Connect(function(i,gp)
                    if listening then
                        if i.UserInputType==
                            Enum.UserInputType.Keyboard
                        or i.UserInputType==
                            Enum.UserInputType.MouseButton1
                        or i.UserInputType==
                            Enum.UserInputType.MouseButton2
                        or i.UserInputType==
                            Enum.UserInputType.MouseButton3 then
                            if i.KeyCode==
                                Enum.KeyCode.Escape
                            or i.KeyCode==
                                Enum.KeyCode.Backspace then
                                currentBind=nil
                                Bind.Text="None"
                            elseif i.UserInputType==
                                Enum.UserInputType.Keyboard then
                                currentBind=i.KeyCode
                                Bind.Text=i.KeyCode.Name
                            else
                                currentBind=i.UserInputType
                                Bind.Text=
i.UserInputType.Name:gsub("MouseButton", "MB")
                            end
                            UpdateRightRow()
                            listening=false
                        end
                    elseif not gp and currentBind then
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
                    Ball:TweenPosition(
UDim2.new(armed and .46 or .1, 0, 0, 4),
                        "Out",
                        "Linear",
                        .1,
                        true
)
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
            H.Parent=Home
            H.BackgroundColor3=Color3.fromRGB(23,23,23)
            H.BorderSizePixel=0
            H.Size=UDim2.new(0,214,0,26)
            C.CornerRadius=UDim.new(0,5)
            C.Parent=H
            T.Parent=H
            T.BackgroundTransparency=1
            T.Position=UDim2.new(.024,0,0,3)
            T.Size=UDim2.new(0,240,0,10)
            T.Font=Enum.Font.GothamSemibold
            T.Text=name or ""
            T.TextColor3=Color3.new(1,1,1)
            T.TextSize=11
            T.TextXAlignment=Enum.TextXAlignment.Left
            Num.Parent=H
            Num.BackgroundTransparency=1
            Num.Position=UDim2.new(.84,0,0,2)
            Num.Size=UDim2.new(0,42,0,13)
            Num.Font=Enum.Font.GothamSemibold
            Num.Text=formatValue(value)
            Num.TextColor3=Color3.fromRGB(235,235,235)
            Num.TextSize=10
            Num.TextEditable=true
            Num.ZIndex=5
            Num.TextXAlignment=Enum.TextXAlignment.Right
            Num.ClearTextOnFocus=false
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
            Trail.BackgroundColor3=Color3.fromRGB(200,50,50)
            Trail.Size=UDim2.new(0,1,1,0)
            Trail.ZIndex=2
            TC.CornerRadius=UDim.new(0,4)
            TC.Parent=Trail
            Knob.Parent=B
            Knob.BackgroundColor3=Color3.fromRGB(235,235,235)
            Knob.Size=UDim2.new(0,12,0,12)
            Knob.AnchorPoint=Vector2.new(.5,.5)
            Knob.Position=UDim2.new(0,0,.5,0)
            Knob.ZIndex=4
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
            T.Parent=H T.BackgroundTransparency=1 T.Position=UDim2.new(.024,0,0,3) T.Size=UDim2.new(0,210,0,24) T.Font=Enum.Font.GothamSemibold T.Text=name or "" T.TextColor3=Color3.new(1,1,1) T.TextSize=11 T.TextXAlignment=Enum.TextXAlignment.Left
            B.Parent=H B.BackgroundColor3=Color3.fromRGB(5,5,5) B.Position=UDim2.new(.735,0,0,5) B.Size=UDim2.new(0,75,0,20) B.Font=Enum.Font.GothamSemibold B.Text=tostring(default or "") B.TextColor3=Color3.new(1,1,1) B.TextSize=9 B.ClearTextOnFocus=false B.PlaceholderText=(o and o.Placeholder) or ""
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
            T.Parent=H T.BackgroundTransparency=1 T.Position=UDim2.new(.024,0,0,2) T.Size=UDim2.new(0,220,0,26) T.Font=Enum.Font.GothamSemibold T.Text=name or "" T.TextColor3=Color3.new(1,1,1) T.TextSize=11 T.TextXAlignment=Enum.TextXAlignment.Left
            B.Parent=H B.BackgroundTransparency=1 B.Size=UDim2.new(1,0,0,30) B.Text="" B.AutoButtonColor=false
            Icon.Parent=B Icon.BackgroundTransparency=1 Icon.Position=UDim2.new(.88,0,.18,0) Icon.Size=UDim2.new(0,24,0,17) Icon.Image="rbxassetid://3944690667"
            Panel.Parent=H Panel.BackgroundColor3=Color3.fromRGB(23,23,23) Panel.Position=UDim2.new(0,0,0,30) Panel.Size=UDim2.new(0,214,0,115) Panel.BorderSizePixel=0 Panel.Visible=false Panel.ZIndex=100 Panel.Active=true
            PC.CornerRadius=UDim.new(0,6) PC.Parent=Panel
            Scroll.Parent=Panel Scroll.BackgroundTransparency=1 Scroll.BorderSizePixel=0 Scroll.Position=UDim2.new(0,4,0,5) Scroll.Size=UDim2.new(1,-8,1,-10) Scroll.ScrollBarThickness=3 Scroll.ScrollBarImageColor3=Color3.fromRGB(70,70,70) Scroll.ZIndex=101
            Layout.Parent=Scroll Layout.HorizontalAlignment=Enum.HorizontalAlignment.Center Layout.SortOrder=Enum.SortOrder.LayoutOrder Layout.Padding=UDim.new(0,5)
            local open=false local selected=nil local values={} local selections={}
            local function canvas() Scroll.CanvasSize=UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y+8) end
            local function close() open=false Panel.Visible=false H.Size=UDim2.new(0,214,0,26) Icon.ImageColor3=Color3.new(1,1,1) task.defer(UpdateCanvas) end
            local function visual(btn,v)
                local yes=multi and selections[v] or selected==v
                btn.BackgroundColor3=yes and Color3.fromRGB(200,50,50) or Color3.fromRGB(15,15,15)
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
                    for _,x in ipairs(values) do if tostring(x)==tostring(v) then selected=x T.Text=tostring(x) for _,ch in ipairs(Scroll:GetChildren()) do if ch:IsA("TextButton") then visual(ch,x) end end if fire then pcall(callback,x) end return end end
                end
            end
            B.MouseButton1Click:Connect(function() open=not open Panel.Visible=open H.Size=UDim2.new(0,214,0,open and 145 or 26) Icon.ImageColor3=open and Color3.fromRGB(200,60,60) or Color3.new(1,1,1) task.defer(UpdateCanvas) end)
            local function build(valuesList)
                values={} for _,ch in ipairs(Scroll:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
                for _,v in ipairs(valuesList or {}) do
                    table.insert(values,v) local O=Instance.new("TextButton") local OC=Instance.new("UICorner")
                    O.Parent=Scroll O.BackgroundColor3=Color3.fromRGB(15,15,15) O.BorderSizePixel=0 O.Size=UDim2.new(1,0,0,24) O.AutoButtonColor=false O.Font=Enum.Font.GothamSemibold O.Text=tostring(v) O.TextColor3=Color3.new(1,1,1) O.TextSize=10 O.ZIndex=102
                    OC.CornerRadius=UDim.new(0,6) OC.Parent=O visual(O,v)
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
            T.Parent=H T.BackgroundTransparency=1 T.Position=UDim2.new(.024,0,0,3) T.Size=UDim2.new(0,200,0,24) T.Font=Enum.Font.GothamSemibold T.Text=name or "" T.TextColor3=Color3.new(1,1,1) T.TextSize=11 T.TextXAlignment=Enum.TextXAlignment.Left
            B.Parent=H B.BackgroundColor3=Color3.fromRGB(5,5,5) B.Position=UDim2.new(.70,0,0,5) B.Size=UDim2.new(0,85,0,20) B.Font=Enum.Font.GothamSemibold B.Text=default and tostring(default.Name or default) or "None" B.TextColor3=Color3.new(1,1,1) B.TextSize=9
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
            T.Parent=H T.BackgroundTransparency=1 T.Position=UDim2.new(.024,0,0,3) T.Size=UDim2.new(0,230,0,24) T.Font=Enum.Font.GothamSemibold T.Text=name or "" T.TextColor3=Color3.new(1,1,1) T.TextSize=11 T.TextXAlignment=Enum.TextXAlignment.Left
            B.Parent=H B.BackgroundColor3=default B.Position=UDim2.new(.82,0,0,5) B.Size=UDim2.new(0,45,0,20) B.Text="" B.AutoButtonColor=false B.ZIndex=50 BC.CornerRadius=UDim.new(0,5) BC.Parent=B
            local Panel=Instance.new("Frame") local PC=Instance.new("UICorner") local Canvas=Instance.new("ImageButton") local Circle=Instance.new("Frame") local CC=Instance.new("UICorner")
            Panel.Parent=Gui Panel.BackgroundColor3=Color3.fromRGB(25,25,25) Panel.Size=UDim2.new(0,296,0,115) Panel.Visible=false Panel.BorderSizePixel=0 Panel.Active=true Panel.ZIndex=300
            PC.CornerRadius=UDim.new(0,6) PC.Parent=Panel
            Canvas.Parent=Panel Canvas.BackgroundTransparency=1 Canvas.Position=UDim2.new(0,8,0,8) Canvas.Size=UDim2.new(1,-16,1,-16) Canvas.Image="rbxassetid://143332548" Canvas.ZIndex=301 Canvas.AutoButtonColor=false
            Circle.Parent=Canvas Circle.AnchorPoint=Vector2.new(.5,.5) Circle.BackgroundColor3=default Circle.BorderColor3=Color3.new(0,0,0) Circle.BorderSizePixel=2 Circle.Size=UDim2.new(0,10,0,10) Circle.ZIndex=302 Circle.Position=UDim2.new(.5,0,.5,0)
            CC.CornerRadius=UDim.new(1,0) CC.Parent=Circle
            local value=default local open=false local dragging=false
            local function positionPicker()
                local p=B.AbsolutePosition local x=p.X-120 local y=p.Y+B.AbsoluteSize.Y+4 local vp=Gui.AbsoluteSize
                Panel.Position=UDim2.fromOffset(math.clamp(x,4,math.max(4,vp.X-300)),math.clamp(y,4,math.max(4,vp.Y-120)))
            end
            local function setColor(i)
                local s=Canvas.AbsoluteSize local p=Canvas.AbsolutePosition
                if s.X<=0 or s.Y<=0 then return end
                local x=math.clamp((i.Position.X-p.X)/s.X,0,1) local y=math.clamp((i.Position.Y-p.Y)/s.Y,0,1)
                value=Color3.fromHSV(x,1-y,1) Circle.Position=UDim2.new(x,0,y,0) Circle.BackgroundColor3=value B.BackgroundColor3=value pcall(callback,value)
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
ConfigPage:addLabel("Configs", "Save, load and manage your configurations")
    local _,InputBox=ConfigPage:addTextBox(
        "",
        "Name...",
        function(v)
            if tostring(v)~=""
            and tostring(v):lower()~="name..." then
                CurrentConfig=CleanName(v)
            end
        end
)
    ConfigNameBox=InputBox
    ConfigPage:addButton(
        "Refresh",
        function()
            local files=GetConfigFiles()
            if ConfigDropdown then ConfigDropdown.Refresh(files) end
            if #files==0 then
                ConfigStatus.Text="No configs found"
                ConfigStatus.TextColor3=
                    Color3.fromRGB(140,140,140)
            else
                ConfigStatus.Text=
                    "Found "
                    ..#files
                    .." config"
                    ..(#files==1 and "" or "s")
                ConfigStatus.TextColor3=
                    Color3.fromRGB(200,50,50)
            end
        end
)
    ConfigDropdown=ConfigPage:addDropdown(
        "",
        {},
        5,
        function(v)
            CurrentConfig=CleanName(v)
            if ConfigNameBox then ConfigNameBox.Text=CurrentConfig end
        end
)
    do
        local H=Instance.new("Frame")
        local C=Instance.new("UICorner")
        local T=Instance.new("TextLabel")
        H.Parent=ConfigPage.__Page
        H.BackgroundColor3=Color3.fromRGB(23,23,23)
        H.BorderSizePixel=0
        H.Size=UDim2.new(0,214,0,26)
        C.CornerRadius=UDim.new(0,5)
        C.Parent=H
        T.Parent=H
        T.BackgroundTransparency=1
        T.Position=UDim2.new(0,7,0,0)
        T.Size=UDim2.new(1,-14,1,0)
        T.Font=Enum.Font.GothamSemibold
        T.Text="Loaded: None"
        T.TextColor3=Color3.fromRGB(140,140,140)
        T.TextSize=9
        T.TextXAlignment=Enum.TextXAlignment.Left
        ConfigStatus=T
    end
    local function SetStatus(text,good)
        if not ConfigStatus then return end
        ConfigStatus.Text=text
        ConfigStatus.TextColor3=
            good
            and Color3.fromRGB(200,50,50)
            or Color3.fromRGB(255,120,120)
    end
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
    ConfigPage:addButton(
        "Load",
        function()
            local name=
                ConfigNameBox
                and ConfigNameBox.Text
                or CurrentConfig
            if tostring(name):lower()=="name..."
            or tostring(name)=="" then
                name=CurrentConfig
            end
            LoadConfig(name)
        end
)
    ConfigPage:addButton(
        "Save",
        function()
            local name=
                ConfigNameBox
                and ConfigNameBox.Text
                or CurrentConfig
            if tostring(name):lower()=="name..."
            or tostring(name)=="" then
                name=CurrentConfig
            end
            SaveConfig(name)
            if ConfigDropdown then
ConfigDropdown.Refresh(GetConfigFiles())
                ConfigDropdown.Set(name)
            end
        end
)
    ConfigPage:addToggle(
        "Auto Load",
        false,
        function(v)
            AutoLoad=v
            if not SetupFolder() then return end
            local name=
                ConfigNameBox
                and ConfigNameBox.Text
                or CurrentConfig
            if tostring(name):lower()=="name..."
            or tostring(name)=="" then
                name=CurrentConfig
            end
            local settings={
                Config=name,
                AutoLoad=v
            }
pcall(function() writefile(ConfigFolder.."/settings.json", HttpService:JSONEncode(settings)) end)
        end
)
    ConfigPage:addButton(
        "Delete",
        function()
            local name=
                ConfigNameBox
                and ConfigNameBox.Text
                or CurrentConfig
            if tostring(name):lower()=="name..."
            or tostring(name)=="" then
                name=CurrentConfig
            end
            DeleteConfig(name)
        end
)
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
        UIScaleValue=1.1
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
    --// PLUGIN SECTION
ConfigPage:addLabel("Plugins", "Load Lua plugins from Skido/skido_plugin")
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
                Color3.fromRGB(200,50,50)
        end
    end
end
PluginDropdown=ConfigPage:addDropdown(
    "",
    {},
    6,
    function()
    end
)
ConfigPage:addButton("Refresh Plugins", function() RefreshPluginDropdown() end)
do
    local H=Instance.new("Frame")
    local C=Instance.new("UICorner")
    local T=Instance.new("TextLabel")
    H.Parent=ConfigPage.__Page
    H.BackgroundColor3=Color3.fromRGB(23,23,23)
    H.BorderSizePixel=0
    H.Size=UDim2.new(0,214,0,26)
    C.CornerRadius=UDim.new(0,5)
    C.Parent=H
    T.Parent=H
    T.BackgroundTransparency=1
    T.Position=UDim2.new(0,7,0,0)
    T.Size=UDim2.new(1,-14,1,0)
    T.Font=Enum.Font.GothamSemibold
    T.Text="Plugin loader ready"
    T.TextColor3=Color3.fromRGB(140,140,140)
    T.TextSize=9
    T.TextXAlignment=Enum.TextXAlignment.Left
    T.TextWrapped=true
    PluginStatus=T
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
        PluginStatus.TextColor3=Color3.fromRGB(200,50,50)
    end
    return true
end
--// UI SETTINGS
ConfigPage:addLabel("Interface", "Scale and performance controls")
ConfigPage:addSlider(
    "UI Scale",
    80,
    130,
    function(v)
        UIScaleValue=v/100
        Scale.Scale=UIScaleValue
    end,
    110
)
ConfigPage:addToggle(
    "Performance Mode",
    false,
    function(v)
        PerformanceMode=v==true
        for _,page in ipairs(Folder:GetChildren()) do
            if page:IsA("ScrollingFrame") then page.ScrollBarThickness=PerformanceMode and 2 or 4 end
        end
        if PerformanceMode then UpdateWindowLayout() end
    end
)
ConfigPage:addButton(
    "Load Plugin",
    function()
        local selected=
            PluginDropdown
            and PluginDropdown.Get()
        if not selected then
            if PluginStatus then
                PluginStatus.Text="Select a plugin first"
                PluginStatus.TextColor3=Color3.fromRGB(255,120,120)
            end
            return
        end
        LoadPlugin(tostring(selected))
    end
)
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
            end
        end
    end
    task.wait(.15)
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
return PageYep
end
return Library
