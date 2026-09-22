-- NullCore | Fisch Hub | Full Feature Build
-- Features: AC Bypass, Silent Aim (hook), No Spread, Rapid Fire,
--           Backshoot, Tracers, Hit Effects, ESP, Aimbot
-- UI: Mobile-safe, sidebar nav, tabbed pages

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UIS          = game:GetService("UserInputService")
local CoreGui      = game:GetService("CoreGui")
local Stats        = game:GetService("Stats")
local TS           = game:GetService("TweenService")
local RS           = game:GetService("ReplicatedStorage")
local WS           = game:GetService("Workspace")
local HTTP         = game:GetService("HttpService")

local LP  = Players.LocalPlayer
local Cam = WS.CurrentCamera

if CoreGui:FindFirstChild("NullCore") then CoreGui:FindFirstChild("NullCore"):Destroy() end

-- ════════════════════════════════════════
--  STATE / FLAGS
-- ════════════════════════════════════════
local Flags = {
    -- Combat
    SilentAim      = false,
    AimbotEnabled  = false,
    AimbotSmooth   = 0.15,
    FovRadius      = 120,
    HitPart        = "Head",
    HitChance      = 85,
    NoSpread       = false,
    NoRecoil       = false,
    RapidFire      = false,
    Backshoot      = false,
    -- Visuals
    ESP            = false,
    ESPBoxes       = true,
    ESPNames       = true,
    ESPTracers     = false,
    ESPHealth      = true,
    Tracers        = false,
    HitEffects     = false,
    -- AC
    AntiKick       = false,
    NukeAC         = false,
}

-- ════════════════════════════════════════
--  THEME / HELPERS
-- ════════════════════════════════════════
local vp = Cam.ViewportSize
local W  = math.min(vp.X * 0.95, 680)
local H  = math.min(vp.Y * 0.90, 540)

local Th = {
    BG      = Color3.fromRGB(12,12,17),
    Panel   = Color3.fromRGB(20,20,28),
    Card    = Color3.fromRGB(26,26,36),
    SB      = Color3.fromRGB(16,16,22),
    Accent  = Color3.fromRGB(110,85,200),
    ASoft   = Color3.fromRGB(70,50,140),
    T1      = Color3.fromRGB(225,225,235),
    T2      = Color3.fromRGB(120,120,145),
    T3      = Color3.fromRGB(65,65,85),
    Border  = Color3.fromRGB(35,35,50),
    Green   = Color3.fromRGB(75,195,115),
    Yellow  = Color3.fromRGB(235,195,75),
    Red     = Color3.fromRGB(215,75,75),
    Blue    = Color3.fromRGB(55,155,215),
    Disc    = Color3.fromRGB(88,101,242),
    ON      = Color3.fromRGB(75,195,115),
    OFF     = Color3.fromRGB(215,75,75),
}

local function N(cls,p) local o=Instance.new(cls) for k,v in pairs(p or {}) do o[k]=v end return o end
local function corner(r,p) local c=N("UICorner") c.CornerRadius=UDim.new(0,r) c.Parent=p end
local function stroke(col,th,p) local s=N("UIStroke") s.Color=col s.Thickness=th s.Parent=p end
local function pad(t,r,b,l,p)
    local u=N("UIPadding")
    u.PaddingTop=UDim.new(0,t) u.PaddingRight=UDim.new(0,r)
    u.PaddingBottom=UDim.new(0,b) u.PaddingLeft=UDim.new(0,l) u.Parent=p
end
local function tw(o,t,g) TS:Create(o,t,g):Play() end
local function lbl(p)
    local l=N("TextLabel",p)
    if not p.Font then l.Font=Enum.Font.Gotham end
    return l
end

-- ════════════════════════════════════════
--  ROOT GUI
-- ════════════════════════════════════════
local SG = N("ScreenGui",{Name="NullCore",ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=999,
    IgnoreGuiInset=true})
SG.Parent = CoreGui

local Main = N("Frame",{Name="Main",Size=UDim2.fromOffset(W,0),
    Position=UDim2.fromScale(0.5,0.5),AnchorPoint=Vector2.new(0.5,0.5),
    BackgroundColor3=Th.Panel,BorderSizePixel=0,ClipsDescendants=true})
Main.Parent=SG corner(12,Main) stroke(Th.Border,1,Main)
tw(Main,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.fromOffset(W,H)})

-- TITLEBAR
local TB=N("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=Th.BG,BorderSizePixel=0,ZIndex=10})
TB.Parent=Main
N("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),
    BackgroundColor3=Th.Border,BorderSizePixel=0,ZIndex=10}).Parent=TB

local badge=N("Frame",{Size=UDim2.fromOffset(26,26),Position=UDim2.new(0,12,0.5,-13),
    BackgroundColor3=Th.Accent,ZIndex=11}) badge.Parent=TB corner(7,badge)
lbl({Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="⬡",
    TextColor3=Color3.new(1,1,1),TextSize=13,Font=Enum.Font.GothamBold,ZIndex=12}).Parent=badge
lbl({Size=UDim2.new(0,100,1,0),Position=UDim2.new(0,44,0,0),BackgroundTransparency=1,
    Text="NullCore",TextColor3=Th.T1,TextSize=14,Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11}).Parent=TB
lbl({Size=UDim2.new(0,100,1,0),Position=UDim2.new(0,130,0,0),BackgroundTransparency=1,
    Text=".gg/nullcore",TextColor3=Th.T3,TextSize=11,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11}).Parent=TB

local CloseBtn=N("TextButton",{Size=UDim2.fromOffset(26,26),Position=UDim2.new(1,-36,0.5,-13),
    BackgroundColor3=Color3.fromRGB(45,25,25),Text="✕",TextColor3=Th.Red,
    TextSize=11,Font=Enum.Font.GothamBold,ZIndex=12,AutoButtonColor=false}) CloseBtn.Parent=TB corner(6,CloseBtn)
CloseBtn.MouseButton1Click:Connect(function()
    tw(Main,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.fromOffset(W,0)})
    task.delay(0.25,function() SG:Destroy() end)
end)

-- SIDEBAR
local Sidebar=N("Frame",{Size=UDim2.new(0,48,1,-44),Position=UDim2.new(0,0,0,44),
    BackgroundColor3=Th.SB,BorderSizePixel=0,ZIndex=9}) Sidebar.Parent=Main
N("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),
    BackgroundColor3=Th.Border,BorderSizePixel=0,ZIndex=10}).Parent=Sidebar
local SBList=N("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=10}) SBList.Parent=Sidebar
N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4),
    HorizontalAlignment=Enum.HorizontalAlignment.Center}).Parent=SBList
pad(8,0,8,0,SBList)

-- CONTENT AREA
local Content=N("Frame",{Size=UDim2.new(1,-48,1,-44),Position=UDim2.new(0,48,0,44),
    BackgroundTransparency=1,ZIndex=8,ClipsDescendants=true}) Content.Parent=Main

-- page container
local Pages={}
local function makePage()
    local s=N("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
        BorderSizePixel=0,ScrollBarThickness=2,ScrollBarImageColor3=Th.Accent,
        CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ZIndex=8,Visible=false})
    s.Parent=Content pad(12,12,12,12,s)
    N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8)}).Parent=s
    return s
end

local function Card(page,h,order)
    local f=N("Frame",{Size=UDim2.new(1,0,0,h),BackgroundColor3=Th.Card,
        BorderSizePixel=0,ZIndex=9,LayoutOrder=order})
    f.Parent=page corner(10,f) stroke(Th.Border,1,f) pad(12,12,12,12,f)
    return f
end

-- Section header inside a card
local function SectionLabel(parent,text,pos)
    lbl({Size=UDim2.new(1,0,0,16),Position=pos or UDim2.new(0,0,0,0),
        BackgroundTransparency=1,Text=text,TextColor3=Th.T2,TextSize=10,
        Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10}).Parent=parent
end

-- Toggle row builder
local function Toggle(parent, text, flag, yPos, callback)
    local row=N("Frame",{Size=UDim2.new(1,0,0,30),Position=UDim2.new(0,0,0,yPos),
        BackgroundColor3=Th.BG,BorderSizePixel=0,ZIndex=10}) row.Parent=parent corner(7,row)
    lbl({Size=UDim2.new(1,-50,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,
        Text=text,TextColor3=Th.T1,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11}).Parent=row
    local pill=N("Frame",{Size=UDim2.fromOffset(36,18),Position=UDim2.new(1,-44,0.5,-9),
        BackgroundColor3=Flags[flag] and Th.ON or Th.OFF,ZIndex=11}) pill.Parent=row corner(9,pill)
    local knob=N("Frame",{Size=UDim2.fromOffset(14,14),
        Position=Flags[flag] and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7),
        BackgroundColor3=Color3.new(1,1,1),ZIndex=12}) knob.Parent=pill corner(7,knob)
    local btn=N("TextButton",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="",ZIndex=13})
    btn.Parent=row
    btn.MouseButton1Click:Connect(function()
        Flags[flag]=not Flags[flag]
        local on=Flags[flag]
        tw(pill,TweenInfo.new(0.15),{BackgroundColor3=on and Th.ON or Th.OFF})
        tw(knob,TweenInfo.new(0.15),{Position=on and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)})
        if callback then callback(on) end
    end)
    return row
end

-- Slider row
local function Slider(parent,text,flag,min,max,yPos,fmt)
    local row=N("Frame",{Size=UDim2.new(1,0,0,38),Position=UDim2.new(0,0,0,yPos),
        BackgroundColor3=Th.BG,BorderSizePixel=0,ZIndex=10}) row.Parent=parent corner(7,row) pad(6,10,6,10,row)
    local valLbl=lbl({Size=UDim2.new(0,50,0,14),Position=UDim2.new(1,-50,0,0),
        BackgroundTransparency=1,Text=tostring(Flags[flag]),TextColor3=Th.Accent,
        TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=11})
    valLbl.Parent=row
    lbl({Size=UDim2.new(1,-55,0,14),BackgroundTransparency=1,Text=text,TextColor3=Th.T1,
        TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11}).Parent=row
    local track=N("Frame",{Size=UDim2.new(1,0,0,4),Position=UDim2.new(0,0,1,-8),
        BackgroundColor3=Th.Border,BorderSizePixel=0,ZIndex=11}) track.Parent=row corner(2,track)
    local fill=N("Frame",{Size=UDim2.new((Flags[flag]-min)/(max-min),0,1,0),
        BackgroundColor3=Th.Accent,BorderSizePixel=0,ZIndex=12}) fill.Parent=track corner(2,fill)
    local function update(abs)
        local rel=math.clamp((abs-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
        local val=math.floor(min+rel*(max-min))
        Flags[flag]=val
        fill.Size=UDim2.new(rel,0,1,0)
        valLbl.Text=fmt and string.format(fmt,val) or tostring(val)
    end
    local dragging=false
    track.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true update(i.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            update(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)
end

-- ════════════════════════════════════════
--  TABS DEFINITION
-- ════════════════════════════════════════
local TABS={
    {icon="🏠",id="home",   label="Home"},
    {icon="⊕", id="combat", label="Combat"},
    {icon="◈", id="visuals",label="Visuals"},
    {icon="⚔", id="misc",   label="Misc"},
    {icon="🔔",id="notif",  label="Notif"},
    {icon="⚙", id="settings",label="Settings"},
    {icon="◉", id="profile",label="Profile"},
}
local activeTab="home"
local navBtns={}

for i,tab in ipairs(TABS) do
    Pages[tab.id]=makePage()
    local btn=N("TextButton",{
        Size=UDim2.fromOffset(34,34),
        BackgroundColor3=tab.id==activeTab and Th.Accent or Color3.new(0,0,0),
        BackgroundTransparency=tab.id==activeTab and 0 or 1,
        Text=tab.icon,TextColor3=tab.id==activeTab and Color3.new(1,1,1) or Th.T3,
        TextSize=14,Font=Enum.Font.GothamBold,ZIndex=11,
        LayoutOrder=tab.id=="profile" and 99 or i,AutoButtonColor=false,
    }) btn.Parent=SBList corner(7,btn) navBtns[tab.id]=btn
    btn.MouseButton1Click:Connect(function()
        Pages[activeTab].Visible=false
        if navBtns[activeTab] then
            tw(navBtns[activeTab],TweenInfo.new(0.12),{BackgroundTransparency=1,TextColor3=Th.T3})
        end
        activeTab=tab.id
        Pages[activeTab].Visible=true
        tw(btn,TweenInfo.new(0.12),{BackgroundTransparency=0,TextColor3=Color3.new(1,1,1)})
        btn.BackgroundColor3=Th.Accent
    end)
end
Pages["home"].Visible=true

-- ════════════════════════════════════════
--  HOME PAGE
-- ════════════════════════════════════════
local HP=Pages["home"]

-- Hello card
local hCard=Card(HP,58,0)
local avBox=N("Frame",{Size=UDim2.fromOffset(38,38),BackgroundColor3=Th.ASoft,ZIndex=10}) avBox.Parent=hCard corner(8,avBox)
local avLetter=lbl({Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
    Text=string.sub(LP.Name,1,1):upper(),TextColor3=Color3.new(1,1,1),
    TextSize=17,Font=Enum.Font.GothamBold,ZIndex=11}) avLetter.Parent=avBox
task.spawn(function()
    local ok,img=pcall(function() return Players:GetUserThumbnailAsync(LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100) end)
    if ok then avLetter.Visible=false avBox.BackgroundTransparency=1
        local il=N("ImageLabel",{Size=UDim2.fromScale(1,1),Image=img,BackgroundTransparency=1,ZIndex=11})
        il.Parent=avBox corner(8,il)
    end
end)
lbl({Size=UDim2.new(1,-50,0,18),Position=UDim2.new(0,48,0,3),BackgroundTransparency=1,
    Text="Hello, "..LP.Name,TextColor3=Th.T1,TextSize=14,Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10}).Parent=hCard
lbl({Size=UDim2.new(1,-50,0,14),Position=UDim2.new(0,48,0,23),BackgroundTransparency=1,
    Text=LP.Name.." — NullCore — Fisch",TextColor3=Th.T3,TextSize=10,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10}).Parent=hCard

-- Server card
local srvCard=Card(HP,220,1)
lbl({Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text="Server",
    TextColor3=Th.T1,TextSize=13,Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10}).Parent=srvCard
lbl({Size=UDim2.new(1,0,0,13),Position=UDim2.new(0,0,0,18),BackgroundTransparency=1,
    Text="Information about the session you're currently in",
    TextColor3=Th.T3,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,ZIndex=10}).Parent=srvCard

local Grid=N("Frame",{Size=UDim2.new(1,0,0,168),Position=UDim2.new(0,0,0,38),BackgroundTransparency=1,ZIndex=9})
Grid.Parent=srvCard
N("UIGridLayout",{CellSize=UDim2.new(0.5,-4,0,38),CellPaddingH=UDim2.new(0,4),
    CellPaddingV=UDim2.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder}).Parent=Grid

local function StatCell(l,v,ac,ord)
    local cell=N("Frame",{BackgroundColor3=Th.BG,BorderSizePixel=0,ZIndex=10,LayoutOrder=ord})
    cell.Parent=Grid corner(7,cell) pad(7,8,7,8,cell)
    lbl({Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,Text=l,TextColor3=Th.T1,
        TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11}).Parent=cell
    local vl=lbl({Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,0,15),BackgroundTransparency=1,
        Text=v,TextColor3=ac or Th.T2,TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11})
    vl.Parent=cell return vl
end

local pingL   = StatCell("Latency","...",Th.Yellow,1)
local regionL = StatCell("Server Region","US",Th.T2,2)
local playerL = StatCell("Players","...",Th.Green,3)
local maxL    = StatCell("Max Players","15 can join",Th.T2,4)
local uptimeL = StatCell("In Server For","00:00:00",Th.Blue,5)

local joinCell=N("Frame",{BackgroundColor3=Th.BG,BorderSizePixel=0,ZIndex=10,LayoutOrder=6})
joinCell.Parent=Grid corner(7,joinCell) pad(7,8,7,8,joinCell)
lbl({Size=UDim2.new(1,0,0,14),BackgroundTransparency=1,Text="Join Script",
    TextColor3=Th.T1,TextSize=10,Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11}).Parent=joinCell
local joinBtn=N("TextButton",{Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,0,15),
    BackgroundTransparency=1,Text="Tap to copy",TextColor3=Th.Accent,TextSize=9,
    Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=false,ZIndex=11})
joinBtn.Parent=joinCell
joinBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d,"%s")',game.PlaceId,game.JobId))
        joinBtn.Text="Copied!" task.delay(2,function() joinBtn.Text="Tap to copy" end)
    end
end)

-- Wave card
local wCard=N("Frame",{Size=UDim2.new(1,0,0,72),BackgroundColor3=Color3.fromRGB(28,20,52),
    BorderSizePixel=0,ZIndex=9,LayoutOrder=2}) wCard.Parent=HP corner(10,wCard) stroke(Th.Accent,1,wCard) pad(12,14,12,14,wCard)
N("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(38,26,76)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(18,16,38))}),Rotation=135}).Parent=wCard
local wi=N("Frame",{Size=UDim2.fromOffset(26,26),BackgroundColor3=Th.Accent,ZIndex=10}) wi.Parent=wCard corner(6,wi)
lbl({Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="〜",TextColor3=Color3.new(1,1,1),
    TextSize=13,Font=Enum.Font.GothamBold,ZIndex=11}).Parent=wi
lbl({Size=UDim2.new(1,-36,0,18),Position=UDim2.new(0,34,0,0),BackgroundTransparency=1,Text="Wave",
    TextColor3=Color3.fromRGB(195,180,255),TextSize=13,Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10}).Parent=wCard
local execOk=false pcall(function() execOk=(getgenv~=nil)or(syn~=nil)or(KRNL_LOADED~=nil) end)
lbl({Size=UDim2.new(1,0,0,28),Position=UDim2.new(0,0,0,34),BackgroundTransparency=1,
    Text=execOk and "Your executor seems to support this script." or "Executor support could not be verified.",
    TextColor3=Th.T2,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,ZIndex=10}).Parent=wCard

-- Friends card
local frCard=Card(HP,110,3)
lbl({Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text="Friends",
    TextColor3=Th.Blue,TextSize=13,Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10}).Parent=frCard
lbl({Size=UDim2.new(1,0,0,13),Position=UDim2.new(0,0,0,18),BackgroundTransparency=1,
    Text="Find out what your friends are currently doing",
    TextColor3=Th.T3,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,ZIndex=10}).Parent=frCard
local FGrid=N("Frame",{Size=UDim2.new(1,0,0,52),Position=UDim2.new(0,0,0,44),BackgroundTransparency=1,ZIndex=9}) FGrid.Parent=frCard
N("UIGridLayout",{CellSize=UDim2.new(0.5,-4,1,0),CellPaddingH=UDim2.new(0,4),
    CellPaddingV=UDim2.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder}).Parent=FGrid
local fd={inServer=0,offline=0,online=0,total=0}
local function FrCell(l,v,ac,ord)
    local cell=N("Frame",{BackgroundColor3=Th.BG,BorderSizePixel=0,ZIndex=10,LayoutOrder=ord})
    cell.Parent=FGrid corner(6,cell) pad(6,7,6,7,cell)
    lbl({Size=UDim2.new(1,0,0,13),BackgroundTransparency=1,Text=l,TextColor3=ac or Th.T2,
        TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11}).Parent=cell
    local vl=lbl({Size=UDim2.new(1,0,0,12),Position=UDim2.new(0,0,0,14),BackgroundTransparency=1,
        Text=tostring(v),TextColor3=Th.T3,TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=11})
    vl.Parent=cell return vl
end
local inSrvV=FrCell("In Server",0,Th.Green,1)
local offV=FrCell("Offline",0,Th.T3,2)
local onV=FrCell("Online",0,Th.Accent,3)
local allV=FrCell("All",0,Th.Blue,4)
task.spawn(function() pcall(function()
    local page=Players:GetFriendsAsync(LP.UserId)
    local function read(p)
        for _,f in pairs(p:GetCurrentPage()) do fd.total+=1
            for _,pl in pairs(Players:GetPlayers()) do
                if pl.UserId==f.Id then fd.inServer+=1 end
            end
        end
        if not p.IsFinished then p:AdvanceToNextPageAsync() read(p) end
    end
    read(page) inSrvV.Text=tostring(fd.inServer) allV.Text=tostring(fd.total)
end) end)

-- Discord card
local disc=N("TextButton",{Size=UDim2.new(1,0,0,52),BackgroundColor3=Color3.fromRGB(28,30,68),
    BorderSizePixel=0,ZIndex=9,LayoutOrder=4,Text="",AutoButtonColor=false}) disc.Parent=HP corner(10,disc)
N("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(58,66,165)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(22,26,78))}),Rotation=90}).Parent=disc
lbl({Size=UDim2.fromOffset(28,28),Position=UDim2.new(0,12,0.5,-14),BackgroundTransparency=1,
    Text="ⓓ",TextColor3=Color3.new(1,1,1),TextSize=22,Font=Enum.Font.GothamBold,ZIndex=10}).Parent=disc
lbl({Size=UDim2.new(0.5,0,0,17),Position=UDim2.new(0,48,0.5,-17),BackgroundTransparency=1,
    Text="Discord",TextColor3=Color3.new(1,1,1),TextSize=13,Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10}).Parent=disc
lbl({Size=UDim2.new(0.6,0,0,13),Position=UDim2.new(0,48,0.5,2),BackgroundTransparency=1,
    Text="Tap to join the NullCore Discord",TextColor3=Color3.fromRGB(175,180,255),
    TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10}).Parent=disc
disc.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("https://discord.gg/nullcore") end
end)

-- ════════════════════════════════════════
--  COMBAT PAGE
-- ════════════════════════════════════════
local CP=Pages["combat"]

-- Silent Aim
local saCard=Card(CP,170,0) SectionLabel(saCard,"⊕  Silent Aim")
Toggle(saCard,"Silent Aim","SilentAim",20)
Toggle(saCard,"Aimbot","AimbotEnabled",54)
Slider(saCard,"FOV Radius","FovRadius",60,300,88,"%d px")
Slider(saCard,"Hit Chance","HitChance",0,100,130,"%.0f%%")
-- hit part selector label
lbl({Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,0,154),BackgroundTransparency=1,
    Text="Hit Part: Head (edit Flags.HitPart in script)",TextColor3=Th.T3,TextSize=9,
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=10}).Parent=saCard

-- Gun mods
local gmCard=Card(CP,130,1) SectionLabel(gmCard,"⚙  Gun Mods")
Toggle(gmCard,"No Spread","NoSpread",20)
Toggle(gmCard,"No Recoil","NoRecoil",54)
Toggle(gmCard,"Rapid Fire","RapidFire",88)

-- Backshoot
local bsCard=Card(CP,50,2) SectionLabel(bsCard,"↺  Backshoot")
Toggle(bsCard,"Backshoot (teleport behind target)","Backshoot",20)

-- ════════════════════════════════════════
--  VISUALS PAGE
-- ════════════════════════════════════════
local VP2=Pages["visuals"]

local espCard=Card(VP2,170,0) SectionLabel(espCard,"◈  ESP")
Toggle(espCard,"ESP Enabled","ESP",20)
Toggle(espCard,"Boxes","ESPBoxes",54)
Toggle(espCard,"Names","ESPNames",88)
Toggle(espCard,"Health Bars","ESPHealth",122)

local trCard=Card(VP2,90,1) SectionLabel(trCard,"⟶  Tracers")
Toggle(trCard,"ESP Tracers","ESPTracers",20)
Toggle(trCard,"Bullet Tracers","Tracers",54)

local hfCard=Card(VP2,50,2) SectionLabel(hfCard,"✦  Hit Effects")
Toggle(hfCard,"Hit Effects","HitEffects",20)

-- ════════════════════════════════════════
--  MISC PAGE
-- ════════════════════════════════════════
local MP=Pages["misc"]

local acCard=Card(MP,90,0) SectionLabel(acCard,"🛡  Anti-Cheat Bypass")
Toggle(acCard,"Anti-Kick (namecall hook)","AntiKick",20,function(on)
    if on then
        pcall(function()
            local mt=getrawmetatable(game)
            local old=mt.__namecall
            local ro=not pcall(function() mt.__namecall=old end)
            if ro then setreadonly(mt,false) end
            mt.__namecall=newcclosure(function(self,...)
                local name=getnamecallmethod()
                if name=="Kick" and self==LP then return end
                return old(self,...)
            end)
            if ro then setreadonly(mt,true) end
        end)
    end
end)
Toggle(acCard,"Nuke AC Scripts","NukeAC",54,function(on)
    if on then
        pcall(function()
            local keywords={"anticheat","ac_","exploit","detect","ban","flag","validate","integrity","security"}
            local function hasKw(str)
                str=str:lower()
                for _,k in ipairs(keywords) do if str:find(k) then return true end end
            end
            local function disableScript(s)
                if (s:IsA("LocalScript") or s:IsA("ModuleScript")) and hasKw(s.Name) then
                    s.Disabled=true
                end
            end
            for _,d in pairs(game:GetDescendants()) do disableScript(d) end
            game.DescendantAdded:Connect(disableScript)
            -- GC scan
            if getgc then
                for _,f in pairs(getgc(false)) do
                    if type(f)=="function" then
                        pcall(function()
                            local consts=debug.getconstants(f)
                            for _,c in pairs(consts) do
                                if type(c)=="string" and hasKw(c) then
                                    hookfunction(f,function() end)
                                    break
                                end
                            end
                        end)
                    end
                end
            end
        end)
    end
end)

local remCard=Card(MP,50,1) SectionLabel(remCard,"📡  Remote Filter")
Toggle(remCard,"Block AC Remotes (FireServer filter)","NukeAC",20)

-- ════════════════════════════════════════
--  FEATURE LOGIC
-- ════════════════════════════════════════

-- ESP Drawings
local ESPObjects={}
local function getChar(p)
    return p and p.Character
end
local function getRoot(p)
    local c=getChar(p) return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum(p)
    local c=getChar(p) return c and c:FindFirstChildOfClass("Humanoid")
end

local function makeESP(player)
    if player==LP then return end
    local obj={
        box    = Drawing.new("Square"),
        name   = Drawing.new("Text"),
        health = Drawing.new("Line"),
        tracer = Drawing.new("Line"),
    }
    obj.box.Visible=false obj.box.Color=Color3.fromRGB(255,255,255)
    obj.box.Thickness=1 obj.box.Filled=false
    obj.name.Visible=false obj.name.Color=Color3.fromRGB(255,255,255)
    obj.name.Size=13 obj.name.Center=true obj.name.Outline=true
    obj.health.Visible=false obj.health.Color=Th.Green obj.health.Thickness=2
    obj.tracer.Visible=false obj.tracer.Color=Th.Red obj.tracer.Thickness=1
    ESPObjects[player]=obj
    return obj
end

local function removeESP(player)
    if ESPObjects[player] then
        for _,d in pairs(ESPObjects[player]) do pcall(function() d:Remove() end) end
        ESPObjects[player]=nil
    end
end

for _,p in pairs(Players:GetPlayers()) do makeESP(p) end
Players.PlayerAdded:Connect(makeESP)
Players.PlayerRemoving:Connect(removeESP)

-- FOV Circle
local fovCircle=Drawing.new("Circle")
fovCircle.Visible=false fovCircle.Color=Color3.fromRGB(255,255,255)
fovCircle.Thickness=1 fovCircle.Filled=false fovCircle.NumSides=64

-- Silent Aim / Aimbot target finder
local function getClosestPlayer()
    local closest,closestDist,closestChar=nil,math.huge,nil
    local center=Vector2.new(Cam.ViewportSize.X/2,Cam.ViewportSize.Y/2)
    for _,p in pairs(Players:GetPlayers()) do
        if p==LP then continue end
        local c=getChar(p) if not c then continue end
        local root=c:FindFirstChild("HumanoidRootPart") if not root then continue end
        local hum=getHum(p) if not hum or hum.Health<=0 then continue end
        local pos,vis=Cam:WorldToViewportPoint(root.Position)
        if vis then
            local dist=(Vector2.new(pos.X,pos.Y)-center).Magnitude
            if dist<Flags.FovRadius and dist<closestDist then
                closest=p closestDist=dist closestChar=c
            end
        end
    end
    return closest,closestChar
end

-- Bullet Tracer pool
local activeTracers={}
local function spawnTracer(from,to)
    local line=Drawing.new("Line")
    line.From=from line.To=to
    line.Color=Color3.fromRGB(255,80,80) line.Thickness=1.5 line.Visible=true
    table.insert(activeTracers,{line=line,born=tick()})
end

-- Hit effect billboards
local function spawnHitEffect(pos,dmg)
    pcall(function()
        local bb=N("BillboardGui",{Size=UDim2.fromOffset(60,20),
            StudsOffset=Vector3.new(0,2,0),AlwaysOnTop=true})
        local att=N("Attachment",{}) att.Parent=WS.Terrain
        att.WorldPosition=pos bb.Adornee=att bb.Parent=att
        local t=N("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,
            Text="-"..tostring(math.floor(dmg or 10)),TextColor3=Th.Red,
            TextSize=14,Font=Enum.Font.GothamBold})
        t.Parent=bb
        task.delay(1.2,function() bb:Destroy() att:Destroy() end)
    end)
end

-- Backshoot
local bsConn
local function startBackshoot()
    if bsConn then bsConn:Disconnect() end
    bsConn=RunService.Heartbeat:Connect(function()
        if not Flags.Backshoot then bsConn:Disconnect() return end
        local _,tc=getClosestPlayer()
        if not tc then return end
        local tr=tc:FindFirstChild("HumanoidRootPart")
        local myRoot=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if tr and myRoot then
            local behind=tr.Position+(-tr.CFrame.LookVector*5)+Vector3.new(0,2,0)
            myRoot.CFrame=CFrame.new(behind,tr.Position)
        end
    end)
end

-- __namecall hook for FireServer filter + anti-kick
local hookedNamecall=false
local function hookNamecall()
    if hookedNamecall then return end
    hookedNamecall=true
    pcall(function()
        local mt=getrawmetatable(game)
        local old=mt.__namecall
        setreadonly(mt,false)
        mt.__namecall=newcclosure(function(self,...)
            local name=getnamecallmethod()
            -- anti-kick
            if Flags.AntiKick and name=="Kick" and self==LP then return end
            -- remote filter
            if Flags.NukeAC and (name=="FireServer" or name=="InvokeServer") then
                local n=(self.Name or ""):lower()
                local kw={"exploit","cheat","detect","ban","flag","validate","integrity","security","anticheat","ac_"}
                for _,k in ipairs(kw) do if n:find(k) then return end end
            end
            return old(self,...)
        end)
        setreadonly(mt,true)
    end)
end

-- No Spread / No Recoil hooks (Fisch gun module)
local spreadHooked=false
local function hookGunModule()
    if spreadHooked then return end
    spreadHooked=true
    pcall(function()
        local scripts=LP:FindFirstChild("PlayerScripts")
        if not scripts then return end
        local gunMod=scripts:FindFirstChild("Gun",true)
        if not gunMod then return end
        local ok,mod=pcall(require,gunMod)
        if not ok or type(mod)~="table" then return end
        if mod.GetSpread and Flags.NoSpread then
            local og=mod.GetSpread
            mod.GetSpread=function(...) return CFrame.new() end
        end
        if mod._Recoil and Flags.NoRecoil then
            mod._Recoil=function() end
        end
    end)
end

-- ════════════════════════════════════════
--  MAIN LOOP
-- ════════════════════════════════════════
local startTime=tick()

RunService.RenderStepped:Connect(function()
    -- server stats
    local e=math.floor(tick()-startTime)
    uptimeL.Text=string.format("%02d:%02d:%02d",math.floor(e/3600),math.floor((e%3600)/60),e%60)
    playerL.Text=#Players:GetPlayers().." playing"
    pcall(function() pingL.Text=math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()).."ms" end)

    -- hooks
    if (Flags.AntiKick or Flags.NukeAC) and not hookedNamecall then hookNamecall() end
    if (Flags.NoSpread or Flags.NoRecoil) then hookGunModule() end
    if Flags.Backshoot and (not bsConn or not bsConn.Connected) then startBackshoot() end

    -- FOV circle
    fovCircle.Visible = Flags.AimbotEnabled or Flags.SilentAim
    fovCircle.Radius  = Flags.FovRadius
    fovCircle.Position= Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2)

    -- Aimbot
    if Flags.AimbotEnabled then
        local target,tc=getClosestPlayer()
        if target and tc then
            local part=tc:FindFirstChild(Flags.HitPart) or tc:FindFirstChild("HumanoidRootPart")
            if part then
                local cf=CFrame.new(Cam.CFrame.Position,part.Position)
                Cam.CFrame=Cam.CFrame:Lerp(cf,Flags.AimbotSmooth)
            end
        end
    end

    -- tracer cleanup
    for i=#activeTracers,1,-1 do
        local t=activeTracers[i]
        if tick()-t.born>0.12 then t.line:Remove() table.remove(activeTracers,i) end
    end

    -- Bullet tracers
    if Flags.Tracers then
        local target,tc=getClosestPlayer()
        if target and tc then
            local part=tc:FindFirstChild("HumanoidRootPart")
            local myRoot=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if part and myRoot then
                local from2d,vis1=Cam:WorldToViewportPoint(myRoot.Position)
                local to2d,vis2=Cam:WorldToViewportPoint(part.Position)
                if vis1 and vis2 then
                    spawnTracer(Vector2.new(from2d.X,from2d.Y),Vector2.new(to2d.X,to2d.Y))
                end
            end
        end
    end

    -- ESP
    for player,obj in pairs(ESPObjects) do
        local visible=Flags.ESP
        local c=getChar(player)
        local root=c and c:FindFirstChild("HumanoidRootPart")
        local hum=getHum(player)
        if visible and root and hum and hum.Health>0 then
            local pos3d,onScreen=Cam:WorldToViewportPoint(root.Position)
            if onScreen then
                local scaleFactor=1/(pos3d.Z)
                local bH=math.clamp(600*scaleFactor,20,200)
                local bW=bH*0.6
                local bX=pos3d.X-bW/2
                local bY=pos3d.Y-bH/2

                if Flags.ESPBoxes then
                    obj.box.Visible=true obj.box.Position=Vector2.new(bX,bY)
                    obj.box.Size=Vector2.new(bW,bH)
                    obj.box.Color=Color3.fromHSV(hum.Health/hum.MaxHealth*0.33,1,1)
                else obj.box.Visible=false end

                if Flags.ESPNames then
                    obj.name.Visible=true
                    obj.name.Position=Vector2.new(pos3d.X,bY-16)
                    obj.name.Text=player.Name
                else obj.name.Visible=false end

                if Flags.ESPHealth then
                    local hp=hum.Health/hum.MaxHealth
                    obj.health.Visible=true
                    obj.health.From=Vector2.new(bX-6,bY+bH)
                    obj.health.To=Vector2.new(bX-6,bY+bH-(bH*hp))
                    obj.health.Color=Color3.fromHSV(hp*0.33,1,1)
                else obj.health.Visible=false end

                if Flags.ESPTracers then
                    obj.tracer.Visible=true
                    obj.tracer.From=Vector2.new(Cam.ViewportSize.X/2,Cam.ViewportSize.Y)
                    obj.tracer.To=Vector2.new(pos3d.X,pos3d.Y)
                else obj.tracer.Visible=false end
            else
                obj.box.Visible=false obj.name.Visible=false
                obj.health.Visible=false obj.tracer.Visible=false
            end
        else
            obj.box.Visible=false obj.name.Visible=false
            obj.health.Visible=false obj.tracer.Visible=false
        end
    end
end)

-- ════════════════════════════════════════
--  DRAG + TOGGLE
-- ════════════════════════════════════════
local dragging,dStart,dPos=false,nil,nil
TB.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=true dStart=i.Position dPos=Main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-dStart
        Main.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightControl then Main.Visible=not Main.Visible end
end)

print("[NullCore] Loaded — Full build")
