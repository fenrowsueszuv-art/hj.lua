-- NullCore | Fisch Hub | Mobile-Fixed
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer

if CoreGui:FindFirstChild("NullCore") then CoreGui:FindFirstChild("NullCore"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NullCore"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

-- viewport
local vp = workspace.CurrentCamera.ViewportSize
local W = math.min(vp.X * 0.95, 680)
local H = math.min(vp.Y * 0.88, 520)

local Theme = {
    BG          = Color3.fromRGB(12, 12, 17),
    Panel       = Color3.fromRGB(20, 20, 28),
    Card        = Color3.fromRGB(26, 26, 36),
    Sidebar     = Color3.fromRGB(16, 16, 22),
    Accent      = Color3.fromRGB(110, 85, 200),
    AccentSoft  = Color3.fromRGB(70, 50, 140),
    T1          = Color3.fromRGB(225, 225, 235),
    T2          = Color3.fromRGB(120, 120, 145),
    T3          = Color3.fromRGB(65, 65, 85),
    Border      = Color3.fromRGB(35, 35, 50),
    Green       = Color3.fromRGB(75, 195, 115),
    Yellow      = Color3.fromRGB(235, 195, 75),
    Red         = Color3.fromRGB(215, 75, 75),
    Blue        = Color3.fromRGB(55, 155, 215),
    Discord     = Color3.fromRGB(88, 101, 242),
}

local function C(cls, p)
    local o = Instance.new(cls)
    for k,v in pairs(p or {}) do o[k]=v end
    return o
end
local function corner(r,p) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r) c.Parent=p end
local function stroke(col,th,p) local s=Instance.new("UIStroke") s.Color=col s.Thickness=th s.Parent=p end
local function pad(t,r,b,l,p)
    local u=Instance.new("UIPadding")
    u.PaddingTop=UDim.new(0,t) u.PaddingRight=UDim.new(0,r)
    u.PaddingBottom=UDim.new(0,b) u.PaddingLeft=UDim.new(0,l)
    u.Parent=p
end
local function tween(o,t,g) TweenService:Create(o,t,g):Play() end
local function label(props)
    local l = C("TextLabel", props)
    if not props.Font then l.Font = Enum.Font.Gotham end
    if not props.TextScaled then l.TextScaled = false end
    return l
end

-- MAIN
local Main = C("Frame",{
    Name="Main",
    Size=UDim2.fromOffset(W,H),
    Position=UDim2.fromScale(0.5,0.5),
    AnchorPoint=Vector2.new(0.5,0.5),
    BackgroundColor3=Theme.Panel,
    BorderSizePixel=0,
    ClipsDescendants=true,
})
Main.Parent = ScreenGui
corner(12, Main)
stroke(Theme.Border, 1, Main)

-- intro anim
Main.Size = UDim2.fromOffset(W, 0)
tween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size=UDim2.fromOffset(W,H)})

-- TITLEBAR
local TB = C("Frame",{
    Size=UDim2.new(1,0,0,44),
    BackgroundColor3=Theme.BG,
    BorderSizePixel=0,
    ZIndex=10,
})
TB.Parent = Main

local LogoBadge = C("Frame",{
    Size=UDim2.fromOffset(26,26),
    Position=UDim2.new(0,12,0.5,-13),
    BackgroundColor3=Theme.Accent,
    ZIndex=11,
})
LogoBadge.Parent=TB corner(7,LogoBadge)
label({Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="⬡",
    TextColor3=Color3.new(1,1,1),TextSize=13,Font=Enum.Font.GothamBold,ZIndex=12}).Parent=LogoBadge

label({
    Size=UDim2.new(0,120,1,0),Position=UDim2.new(0,44,0,0),
    BackgroundTransparency=1,Text="NullCore",TextColor3=Theme.T1,
    TextSize=14,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11
}).Parent=TB

label({
    Size=UDim2.new(0,110,1,0),Position=UDim2.new(0,130,0,0),
    BackgroundTransparency=1,Text=".gg/nullcore",TextColor3=Theme.T3,
    TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11
}).Parent=TB

-- close
local CloseBtn = C("TextButton",{
    Size=UDim2.fromOffset(26,26),Position=UDim2.new(1,-36,0.5,-13),
    BackgroundColor3=Color3.fromRGB(45,25,25),Text="✕",
    TextColor3=Theme.Red,TextSize=11,Font=Enum.Font.GothamBold,ZIndex=12,AutoButtonColor=false,
})
CloseBtn.Parent=TB corner(6,CloseBtn)
CloseBtn.MouseButton1Click:Connect(function()
    tween(Main,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
        {Size=UDim2.fromOffset(W,0)})
    task.delay(0.25,function() ScreenGui:Destroy() end)
end)

-- separator
C("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),
    BackgroundColor3=Theme.Border,BorderSizePixel=0,ZIndex=10}).Parent=TB

-- SIDEBAR
local SB = C("Frame",{
    Size=UDim2.new(0,48,1,-44),Position=UDim2.new(0,0,0,44),
    BackgroundColor3=Theme.Sidebar,BorderSizePixel=0,ZIndex=9,
})
SB.Parent=Main
C("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),
    BackgroundColor3=Theme.Border,BorderSizePixel=0,ZIndex=10}).Parent=SB

local SBList = C("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=10})
SBList.Parent=SB
local sbLayout = C("UIListLayout",{
    SortOrder=Enum.SortOrder.LayoutOrder,
    Padding=UDim.new(0,4),
    HorizontalAlignment=Enum.HorizontalAlignment.Center,
})
sbLayout.Parent=SBList
pad(8,0,8,0,SBList)

local TABS = {
    {icon="🏠",id="home"},
    {icon="◈", id="tab2"},
    {icon="⌖", id="tab3"},
    {icon="✦", id="tab4"},
    {icon="🔔",id="tab5"},
    {icon="⚙", id="settings"},
    {icon="◉", id="profile"},
}
local activeTab = "home"
local navBtns = {}

for i,tab in ipairs(TABS) do
    local btn = C("TextButton",{
        Size=UDim2.fromOffset(34,34),
        BackgroundColor3=tab.id==activeTab and Theme.Accent or Color3.new(0,0,0),
        BackgroundTransparency=tab.id==activeTab and 0 or 1,
        Text=tab.icon,TextColor3=tab.id==activeTab and Color3.new(1,1,1) or Theme.T3,
        TextSize=15,Font=Enum.Font.GothamBold,ZIndex=11,
        LayoutOrder=tab.id=="profile" and 99 or i,AutoButtonColor=false,
    })
    btn.Parent=SBList corner(7,btn)
    navBtns[tab.id]=btn
    btn.MouseButton1Click:Connect(function()
        local prev=activeTab activeTab=tab.id
        if navBtns[prev] then
            tween(navBtns[prev],TweenInfo.new(0.12),{BackgroundTransparency=1,TextColor3=Theme.T3})
        end
        tween(btn,TweenInfo.new(0.12),{BackgroundTransparency=0,TextColor3=Color3.new(1,1,1)})
        btn.BackgroundColor3=Theme.Accent
    end)
end

-- CONTENT
local Content = C("Frame",{
    Size=UDim2.new(1,-48,1,-44),Position=UDim2.new(0,48,0,44),
    BackgroundTransparency=1,ZIndex=8,ClipsDescendants=true,
})
Content.Parent=Main

-- SCROLL
local Scroll = C("ScrollingFrame",{
    Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,
    ScrollBarThickness=2,ScrollBarImageColor3=Theme.Accent,
    CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=8,
})
Scroll.Parent=Content
pad(12,12,12,12,Scroll)
C("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8)}).Parent=Scroll

-- helper: section card
local function Card(h, order)
    local f = C("Frame",{
        Size=UDim2.new(1,0,0,h),BackgroundColor3=Theme.Card,
        BorderSizePixel=0,ZIndex=9,LayoutOrder=order,
    })
    f.Parent=Scroll corner(10,f) stroke(Theme.Border,1,f) pad(12,12,12,12,f)
    return f
end

-- HELLO CARD
local Hello = Card(58, 0)

local AvBox = C("Frame",{Size=UDim2.fromOffset(38,38),BackgroundColor3=Theme.AccentSoft,ZIndex=10})
AvBox.Parent=Hello corner(8,AvBox)

local AvLetter = label({Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
    Text=string.sub(LP.Name,1,1):upper(),TextColor3=Color3.new(1,1,1),
    TextSize=17,Font=Enum.Font.GothamBold,ZIndex=11})
AvLetter.Parent=AvBox

task.spawn(function()
    local ok,img=pcall(function()
        return Players:GetUserThumbnailAsync(LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
    end)
    if ok then
        AvLetter.Visible=false AvBox.BackgroundTransparency=1
        local il=C("ImageLabel",{Size=UDim2.fromScale(1,1),Image=img,BackgroundTransparency=1,ZIndex=11})
        il.Parent=AvBox corner(8,il)
    end
end)

label({
    Size=UDim2.new(1,-50,0,18),Position=UDim2.new(0,48,0,3),
    BackgroundTransparency=1,Text="Hello, "..LP.Name,TextColor3=Theme.T1,
    TextSize=14,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10
}).Parent=Hello

label({
    Size=UDim2.new(1,-50,0,14),Position=UDim2.new(0,48,0,23),
    BackgroundTransparency=1,Text=LP.Name.." — NullCore — Fisch",TextColor3=Theme.T3,
    TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10
}).Parent=Hello

-- SERVER CARD
local Srv = Card(220, 1)

label({Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text="Server",
    TextColor3=Theme.T1,TextSize=13,Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10}).Parent=Srv

label({Size=UDim2.new(1,0,0,13),Position=UDim2.new(0,0,0,18),
    BackgroundTransparency=1,Text="Information about the session you're currently in",
    TextColor3=Theme.T3,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,
    TextWrapped=true,ZIndex=10}).Parent=Srv

-- stat grid container
local Grid = C("Frame",{
    Size=UDim2.new(1,0,0,168),Position=UDim2.new(0,0,0,38),
    BackgroundTransparency=1,ZIndex=9,
})
Grid.Parent=Srv

local GridLayout = C("UIGridLayout",{
    CellSize=UDim2.new(0.5,-4,0,38),
    CellPaddingH=UDim2.new(0,4),
    CellPaddingV=UDim2.new(0,4),
    SortOrder=Enum.SortOrder.LayoutOrder,
})
GridLayout.Parent=Grid

local function StatCell(lbl, val, accent, order)
    local cell = C("Frame",{BackgroundColor3=Theme.BG,BorderSizePixel=0,ZIndex=10,LayoutOrder=order})
    cell.Parent=Grid corner(7,cell) pad(7,8,7,8,cell)
    label({Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,Text=lbl,
        TextColor3=Theme.T1,TextSize=10,Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11}).Parent=cell
    local vl = label({Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,0,15),
        BackgroundTransparency=1,Text=val,TextColor3=accent or Theme.T2,
        TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11})
    vl.Parent=cell
    return vl
end

local pingLabel   = StatCell("Latency",       "...", Theme.Yellow, 1)
local regionLabel = StatCell("Server Region", "US",  Theme.T2,     2)
local playerLabel = StatCell("Players",       "...", Theme.Green,  3)
local maxLabel    = StatCell("Max Players",   "15 can join", Theme.T2, 4)
local uptimeLabel = StatCell("In Server For", "00:00:00", Theme.Blue, 5)

-- join script cell
local joinCell = C("Frame",{BackgroundColor3=Theme.BG,BorderSizePixel=0,ZIndex=10,LayoutOrder=6})
joinCell.Parent=Grid corner(7,joinCell) pad(7,8,7,8,joinCell)
label({Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,Text="Join Script",
    TextColor3=Theme.T1,TextSize=10,Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11}).Parent=joinCell
local joinBtn = C("TextButton",{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,0,15),
    BackgroundTransparency=1,Text="Tap to copy",TextColor3=Theme.Accent,
    TextSize=9,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,
    AutoButtonColor=false,ZIndex=11})
joinBtn.Parent=joinCell
joinBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(string.format(
            'game:GetService("TeleportService"):TeleportToPlaceInstance(%d,"%s")',
            game.PlaceId, game.JobId))
        joinBtn.Text="Copied!"
        task.delay(2,function() joinBtn.Text="Tap to copy" end)
    end
end)

-- WAVE CARD
local Wave = C("Frame",{
    Size=UDim2.new(1,0,0,72),BackgroundColor3=Color3.fromRGB(28,20,52),
    BorderSizePixel=0,ZIndex=9,LayoutOrder=2,
})
Wave.Parent=Scroll corner(10,Wave) stroke(Theme.Accent,1,Wave) pad(12,14,12,14,Wave)

C("UIGradient",{
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(38,26,76)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(18,16,38)),
    }),Rotation=135
}).Parent=Wave

local waveIcon = C("Frame",{Size=UDim2.fromOffset(26,26),BackgroundColor3=Theme.Accent,ZIndex=10})
waveIcon.Parent=Wave corner(6,waveIcon)
label({Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="〜",
    TextColor3=Color3.new(1,1,1),TextSize=13,Font=Enum.Font.GothamBold,ZIndex=11}).Parent=waveIcon

label({Size=UDim2.new(1,-36,0,18),Position=UDim2.new(0,34,0,0),
    BackgroundTransparency=1,Text="Wave",TextColor3=Color3.fromRGB(195,180,255),
    TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10
}).Parent=Wave

local execOk=false
pcall(function() execOk=(getgenv~=nil)or(syn~=nil)or(KRNL_LOADED~=nil) end)
label({Size=UDim2.new(1,0,0,28),Position=UDim2.new(0,0,0,34),
    BackgroundTransparency=1,
    Text=execOk and "Your executor seems to support this script." or "Executor support could not be verified.",
    TextColor3=Theme.T2,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,
    TextWrapped=true,ZIndex=10
}).Parent=Wave

-- FRIENDS CARD
local Friends = Card(110, 3)

label({Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text="Friends",
    TextColor3=Theme.Blue,TextSize=13,Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10}).Parent=Friends

label({Size=UDim2.new(1,0,0,13),Position=UDim2.new(0,0,0,18),
    BackgroundTransparency=1,Text="Find out what your friends are currently doing",
    TextColor3=Theme.T3,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,
    TextWrapped=true,ZIndex=10}).Parent=Friends

local FGrid = C("Frame",{Size=UDim2.new(1,0,0,52),Position=UDim2.new(0,0,0,44),
    BackgroundTransparency=1,ZIndex=9})
FGrid.Parent=Friends
C("UIGridLayout",{
    CellSize=UDim2.new(0.5,-4,1,0),
    CellPaddingH=UDim2.new(0,4),CellPaddingV=UDim2.new(0,4),
    SortOrder=Enum.SortOrder.LayoutOrder,
}).Parent=FGrid

local friendsData={inServer=0,offline=0,online=0,total=0}

local function FrCell(lbl,val,accent,order)
    local cell=C("Frame",{BackgroundColor3=Theme.BG,BorderSizePixel=0,ZIndex=10,LayoutOrder=order})
    cell.Parent=FGrid corner(6,cell) pad(6,7,6,7,cell)
    label({Size=UDim2.new(1,0,0,13),BackgroundTransparency=1,Text=lbl,
        TextColor3=accent or Theme.T2,TextSize=10,Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11}).Parent=cell
    local vl=label({Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,0,14),
        BackgroundTransparency=1,Text=tostring(val),TextColor3=Theme.T3,
        TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11})
    vl.Parent=cell return vl
end

local inSrvV  = FrCell("In Server", 0, Theme.Green, 1)
local offV    = FrCell("Offline",   0, Theme.T3,    2)
local onV     = FrCell("Online",    0, Theme.Accent, 3)
local allV    = FrCell("All",       0, Theme.Blue,  4)

task.spawn(function()
    pcall(function()
        local page=Players:GetFriendsAsync(LP.UserId)
        local function read(p)
            for _,f in pairs(p:GetCurrentPage()) do
                friendsData.total+=1
                for _,pl in pairs(Players:GetPlayers()) do
                    if pl.UserId==f.Id then friendsData.inServer+=1 end
                end
            end
            if not p.IsFinished then p:AdvanceToNextPageAsync() read(p) end
        end
        read(page)
        inSrvV.Text=tostring(friendsData.inServer)
        allV.Text=tostring(friendsData.total)
    end)
end)

-- DISCORD CARD
local Disc = C("TextButton",{
    Size=UDim2.new(1,0,0,52),BackgroundColor3=Color3.fromRGB(28,30,68),
    BorderSizePixel=0,ZIndex=9,LayoutOrder=4,Text="",AutoButtonColor=false,
})
Disc.Parent=Scroll corner(10,Disc)
C("UIGradient",{
    Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(58,66,165)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(22,26,78)),
    }),Rotation=90
}).Parent=Disc

label({Size=UDim2.fromOffset(28,28),Position=UDim2.new(0,12,0.5,-14),
    BackgroundTransparency=1,Text="ⓓ",TextColor3=Color3.new(1,1,1),
    TextSize=22,Font=Enum.Font.GothamBold,ZIndex=10}).Parent=Disc
label({Size=UDim2.new(0.5,0,0,17),Position=UDim2.new(0,48,0.5,-17),
    BackgroundTransparency=1,Text="Discord",TextColor3=Color3.new(1,1,1),
    TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10}).Parent=Disc
label({Size=UDim2.new(0.6,0,0,13),Position=UDim2.new(0,48,0.5,2),
    BackgroundTransparency=1,Text="Tap to join the NullCore Discord",
    TextColor3=Color3.fromRGB(175,180,255),TextSize=9,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10}).Parent=Disc

Disc.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("https://discord.gg/nullcore") end
end)

-- LIVE UPDATES
local startTime=tick()
RunService.Heartbeat:Connect(function()
    local e=math.floor(tick()-startTime)
    uptimeLabel.Text=string.format("%02d:%02d:%02d",math.floor(e/3600),math.floor((e%3600)/60),e%60)
    playerLabel.Text=#Players:GetPlayers().." playing"
    pcall(function()
        pingLabel.Text=math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()).."ms"
    end)
end)

-- DRAG
local dragging,dStart,dPos=false,nil,nil
TB.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=true dStart=i.Position dPos=Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-dStart
        Main.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)

-- TOGGLE
UserInputService.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightControl then
        Main.Visible=not Main.Visible
    end
end)

print("[NullCore] Loaded")
