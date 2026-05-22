

local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/lelo0002/hai../refs/heads/main/roxylinoria.lua'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/lelo0002/hai../refs/heads/main/theme.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
    Title = "                     $$ roxyrivals $$                                                  TWW", 
    Center = true, 
    AutoShow = true, 
    MenuFadeTime = 0.1, 
    Resizable = true,
    ShowCustomCursor = false, 
    NotifySide = "Bottom", 
    Size = UDim2.new(0, 750, 0, 480)
})

for _, v in ipairs(Window.Holder:GetDescendants()) do
    if v:IsA("TextLabel") and v.Text:find("roxyrivals") then 
        v.RichText = true 
        break 
    end
end

local Tabs = { 
    Combat = Window:AddTab("Combat"), 
    Visuals = Window:AddTab("Visuals"),
    Skinchanger = Window:AddTab("Skinchanger"),
    ["UI Settings"] = Window:AddTab("Configs") 
}

local S = setmetatable({}, {__index = function(t, k) local s = game:GetService(k); t[k] = s; return s end})
local P, RS, TS, WS, UIS = S.Players, S.RunService, S.TweenService, workspace, S.UserInputService
local C = workspace.CurrentCamera
local LP = P.LocalPlayer or P:GetPropertyChangedSignal("LocalPlayer"):Wait() or P.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local playerScripts = LP:WaitForChild("PlayerScripts")
local controllers = playerScripts:WaitForChild("Controllers")
local EnumLibrary = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
if EnumLibrary and EnumLibrary.WaitForEnumBuilder then
    EnumLibrary:WaitForEnumBuilder()
end
local CosmeticLibrary = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
local ItemLibrary = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
local DataController = require(controllers:WaitForChild("PlayerDataController", 10))

local scEquipCosmetic =
    ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("Data")
    :WaitForChild("EquipCosmetic")

local scFavoriteCosmetic =
    ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("Data")
    :WaitForChild("FavoriteCosmetic")
local L = {
    Master = false,
    BE = false,
    BC = Color3.fromRGB(255, 255, 255),
    BFE = false,
    BFC = Color3.fromRGB(255, 255, 255),
    BFTrans = 0.5,
    NE = false,
    NTC = Color3.fromRGB(255, 255, 255),
    DE = false,
    DTC = Color3.fromRGB(255, 255, 255),
    DistMode = "Studs",
    HE = false,
    HHC = Color3.fromRGB(0, 255, 0),
    HLC = Color3.fromRGB(255, 0, 0),
    HGrad = false,
    HTE = false,
    HTC = Color3.fromRGB(255, 255, 255),
    WE = false,
    WTC = Color3.fromRGB(255, 255, 255),
    Skel = false,
    SkelColor = Color3.fromRGB(255, 255, 255),
    SkelTrans = 0.0,
    Chams = false,
    ChamsColor = Color3.fromRGB(84, 132, 171),
    ChamsTrans = 0.5,
    ChamsOutlineColor = Color3.fromRGB(255, 255, 255),
    ChamsOutlineTrans = 0.0,
    NameStyle = "Username",
    TeamCheck = true,
    FadeIn = 0.5,
    FadeOut = 0.5,
    DMax = 650,
    Aimbot = false,
    StickyAim = false,
    WallCheck = false,
    Smoothness = 1,
    AimbotMaxDist = 650,
    AimbotBone = "Head",
    Snapline = false,
    SnaplineColor = Color3.fromRGB(255, 255, 255),
    SnapFrom = "Mouse",
    FOVVisible = false,
    FOVColor = Color3.fromRGB(255, 255, 255),
    HighlightTarget = false,
    HighlightColor = Color3.fromRGB(255, 0, 0),
    FOVSize = 100,
    FS = 13,
    HBarThickness = 2,
    HBarOffset = 5,
    Font = 2,
    FCase = "Normal"
}

local FM = { ['UI'] = 0, ['System'] = 1, ['Plex'] = 2, ['Monospace'] = 3 }

local cache = {}

local AimbotFOV = Drawing.new("Circle")
AimbotFOV.Filled = false
AimbotFOV.Thickness = 1
AimbotFOV.ZIndex = 999

local AimbotFOVOutline = Drawing.new("Circle")
AimbotFOVOutline.Filled = false
AimbotFOVOutline.Thickness = 3
AimbotFOVOutline.Color = Color3.fromRGB(0, 0, 0)
AimbotFOVOutline.ZIndex = 998

local currentFOVSize = 100

local AimbotSnaplineOutline = Drawing.new("Line")
AimbotSnaplineOutline.Thickness = 3
AimbotSnaplineOutline.Color = Color3.fromRGB(0, 0, 0)
AimbotSnaplineOutline.ZIndex = 997

local AimbotSnapline = Drawing.new("Line")
AimbotSnapline.Thickness = 1
AimbotSnapline.ZIndex = 998

local CurrentAimbotTarget = nil

local GlobalRaycastParams = RaycastParams.new()
GlobalRaycastParams.FilterType = Enum.RaycastFilterType.Exclude

local R15Parts = {
    "Head", "UpperTorso", "LowerTorso",
    "LeftUpperArm", "LeftLowerArm", "LeftHand",
    "RightUpperArm", "RightLowerArm", "RightHand",
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
    "RightUpperLeg", "RightLowerLeg", "RightFoot"
}

local BoneConnections = {
    { "Head", "UpperTorso" },
    { "UpperTorso", "LowerTorso" },
    { "UpperTorso", "LeftUpperArm" },
    { "LeftUpperArm", "LeftLowerArm" },
    { "LeftLowerArm", "LeftHand" },
    { "UpperTorso", "RightUpperArm" },
    { "RightUpperArm", "RightLowerArm" },
    { "RightLowerArm", "RightHand" },
    { "LowerTorso", "LeftUpperLeg" },
    { "LeftUpperLeg", "LeftLowerLeg" },
    { "LeftLowerLeg", "LeftFoot" },
    { "LowerTorso", "RightUpperLeg" },
    { "RightUpperLeg", "RightLowerLeg" },
    { "RightLowerLeg", "RightFoot" }
}

local fontMap = { [0] = Enum.Font.BuilderSans, [1] = Enum.Font.SourceSans, [2] = Enum.Font.Roboto, [3] = Enum.Font.Code }
local function applyCase(t, case)
    if not t or typeof(t) ~= "string" then return tostring(t or "") end
    if case == "Lowercase" then return string.lower(t)
    elseif case == "Uppercase" then return string.upper(t) end
    local lower = string.lower(t)
    return (lower:gsub("^%l", string.upper):gsub("[%s%p]%l", string.upper))
end

local ESPPreview = { Enabled = false, UserMoved = false, Container = nil, MainFrame = nil, stickyUpdating = false }
function ESPPreview:UpdateAesthetics()
    if not self.MainFrame then return end
    local Main = self.MainFrame
    Main.BackgroundColor3 = Library.BackgroundColor
    Main.Outline.BackgroundColor3 = Library.OutlineColor
    Main.Accent.BackgroundColor3 = Library.AccentColor
    if self.Glow then self.Glow.ImageColor3 = Library.AccentColor end
    self.Title.Font = Library.Font
    self.Title.TextColor3 = Library.FontColor
    self.Inner.BackgroundColor3 = Library.MainColor
    self.Inner.BorderColor3 = Library.OutlineColor

    local Master = L.Master
    local PreviewEnabled = self.Enabled and Master and Library.MainOuterFrame.Visible
    if self.Enabled then
        Main.Visible = PreviewEnabled
    end

    if PreviewEnabled and self.DummyBox then
        local font = fontMap[L.Font or 2] or Enum.Font.Roboto
        local fontSize = L.FS or 13
        local case = L.FCase or "Normal"
        
        local boxColor = typeof(L.BC) == "Color3" and L.BC or Color3.new(1,1,1)
        self.DummyBox.Visible = L.BE
        self.DummyBoxMain.Color = boxColor
        
        self.DummyBoxFill.Visible = L.BFE
        self.DummyBoxFill.BackgroundColor3 = typeof(L.BFC) == "Color3" and L.BFC or Color3.new(1,1,1)
        self.DummyBoxFill.BackgroundTransparency = L.BFTrans or 0.5
        
        self.DummyName.Visible = L.NE
        self.DummyName.TextColor3 = typeof(L.NTC) == "Color3" and L.NTC or Color3.new(1,1,1)
        self.DummyName.Font = font
        self.DummyName.TextSize = fontSize
        self.DummyName.Text = applyCase("Player", case)
        
        self.DummyWeapon.Visible = L.WE
        self.DummyWeapon.TextColor3 = typeof(L.WTC) == "Color3" and L.WTC or Color3.new(1,1,1)
        self.DummyWeapon.Font = font
        self.DummyWeapon.TextSize = fontSize
        self.DummyWeapon.Text = applyCase("Energy Pistols", case)
        
        local dUnit = L.DistMode == "Meters" and "m" or "s"
        local dVal = L.DistMode == "Meters" and "42" or "150"
        self.DummyDist.Visible = L.DE
        self.DummyDist.TextColor3 = typeof(L.DTC) == "Color3" and L.DTC or Color3.new(1,1,1)
        self.DummyDist.Font = font
        self.DummyDist.TextSize = fontSize
        self.DummyDist.Text = applyCase(dVal .. dUnit, case)
        
        if L.WE then
            self.DummyDist.Position = UDim2.new(0.5, -62, 0.5, 96)
        else
            self.DummyDist.Position = UDim2.new(0.5, -62, 0.5, 83)
        end
        
        local chamAlpha = L.ChamsTrans or 0.5
        self.DummyCharChams.Visible = L.Chams
        self.DummyCharChams.ImageColor3 = typeof(L.ChamsColor) == "Color3" and L.ChamsColor or Color3.new(1,1,1)
        self.DummyCharChams.ImageTransparency = chamAlpha
        self.DummyChar.ImageTransparency = 0
        
        if self.DummyCharHighlight then
            self.DummyCharHighlight.Visible = L.Chams
            self.DummyCharHighlight.ImageColor3 = typeof(L.ChamsOutlineColor) == "Color3" and L.ChamsOutlineColor or Color3.new(1,1,1)
            self.DummyCharHighlight.ImageTransparency = L.ChamsOutlineTrans or 0.0
        end
        
        local health = (math.sin(os.clock() * math.pi * 2 / 6) + 1) / 2
        local hlc = typeof(L.HLC) == "Color3" and L.HLC or Color3.fromRGB(255, 0, 0)
        local hhc = typeof(L.HHC) == "Color3" and L.HHC or Color3.fromRGB(0, 255, 0)
        
        self.DummyHealthBar.Visible = L.HE
        self.DummyHealthText.Visible = L.HE and L.HTE
        self.DummyHealthText.Text = tostring(math.floor(health * 100))
        self.DummyHealthText.Position = UDim2.new(0, -22, 1 - health, -6)
        self.DummyHealthText.TextColor3 = typeof(L.HTC) == "Color3" and L.HTC or Color3.new(1,1,1)
        self.DummyHealthText.Font = font
        self.DummyHealthText.TextSize = fontSize
        
        self.DummyHealthSolid.Visible = true
        self.DummyHealthSolid.Size = UDim2.new(1, 0, health, 0)
        self.DummyHealthSolid.Position = UDim2.new(0, 0, 1 - health, 0)
        
        if L.HGrad then
            local c1 = hhc
            local c2 = hlc
            if L.HGradAnim then
                local speed = L.HGradAnimSpeed or 1
                local offset = os.clock() * speed
                if L.HGradAnimStyle == "Shift" then
                    self.DummyHealthGradient.Offset = Vector2.new(0, (math.sin(offset) * 0.5))
                elseif L.HGradAnimStyle == "Pulse" then
                    self.DummyHealthGradient.Offset = Vector2.new(0, 0)
                    local pulse = (math.sin(offset * math.pi * 0.8) + 1) / 2
                    c1 = hhc:Lerp(Color3.new(1,1,1), pulse * 0.4)
                else
                    self.DummyHealthGradient.Offset = Vector2.new(0, (math.sin(offset * math.pi * 1.2) + 1) / 2 - 0.5)
                end
            else
                self.DummyHealthGradient.Offset = Vector2.new(0, 0)
            end
            self.DummyHealthGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, c1),
                ColorSequenceKeypoint.new(1, c2)
            })
        else
            local mainHColor = hlc:Lerp(hhc, health)
            self.DummyHealthGradient.Color = ColorSequence.new(mainHColor)
            self.DummyHealthGradient.Offset = Vector2.new(0, 0)
        end
    end
end

function ESPPreview:Create()
    if self.Container then return end
    local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "ROXY_ESPPreview"; ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global; ScreenGui.DisplayOrder = 1005
    self.Container = ScreenGui
    local Main = Instance.new("Frame"); Main.Name = "Main"; Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BorderColor3 = Color3.fromRGB(0, 0, 0); Main.BorderSizePixel = 1; Main.Size = UDim2.fromOffset(200, 250); Main.Visible = false; Main.Parent = ScreenGui; Main.ClipsDescendants = false
    self.MainFrame = Main
    local Outline = Instance.new("Frame"); Outline.Name = "Outline"; Outline.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Outline.BorderSizePixel = 0; Outline.Position = UDim2.new(0, -1, 0, -1); Outline.Size = UDim2.new(1, 2, 1, 2); Outline.ZIndex = 0; Outline.Parent = Main
    local Accent = Instance.new("Frame"); Accent.Name = "Accent"; Accent.BackgroundColor3 = Library.AccentColor; Accent.BorderSizePixel = 0; Accent.Size = UDim2.new(1, 0, 0, 1); Accent.ZIndex = 2; Accent.Parent = Main
    self.AccentLine = Accent
    local Glow = Instance.new("ImageLabel"); Glow.Name = "Glow"; Glow.BackgroundTransparency = 1; Glow.Image = "rbxassetid://1316045217"; Glow.ImageColor3 = Library.AccentColor; Glow.ImageTransparency = 0.7; Glow.Position = UDim2.new(0, -15, 0, -15); Glow.Size = UDim2.new(1, 30, 1, 30); Glow.ZIndex = -1; Glow.Parent = Main
    Library:AddToRegistry(Glow, { ImageColor3 = "AccentColor" })
    if Library.AddGlow then Library:AddGlow(Glow, 0.7) end
    local Title = Instance.new("TextLabel"); Title.Name = "Title"; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 5, 0, 2); Title.Size = UDim2.new(1, -10, 0, 15); Title.Font = Library.Font; Title.Text = "ESP Preview"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.Parent = Main
    local Inner = Instance.new("Frame"); Inner.Name = "Inner"; Inner.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Inner.BorderColor3 = Color3.fromRGB(35, 35, 35); Inner.Position = UDim2.new(0, 5, 0, 20); Inner.Size = UDim2.new(1, -10, 1, -25); Inner.Parent = Main
    local InnerContainer = Instance.new("Frame"); InnerContainer.Name = "InnerContainer"; InnerContainer.BackgroundTransparency = 1; InnerContainer.Position = UDim2.new(0.5, 0, 0.5, 0); InnerContainer.Size = UDim2.fromOffset(190, 225); InnerContainer.AnchorPoint = Vector2.new(0.5, 0.5); InnerContainer.Parent = Inner
    local InnerScale = Instance.new("UIScale"); InnerScale.Parent = InnerContainer
    Main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        InnerScale.Scale = Main.AbsoluteSize.Y / 250
    end)
    local CharImage = "rbxassetid://6331765786"
    local DummyChar = Instance.new("ImageLabel"); DummyChar.Name = "DummyChar"; DummyChar.BackgroundTransparency = 1; DummyChar.Position = UDim2.new(0.5, -60, 0.5, -78); DummyChar.Size = UDim2.fromOffset(120, 155); DummyChar.Image = CharImage; DummyChar.Parent = InnerContainer
    self.DummyChar = DummyChar
    local DummyCharChams = Instance.new("ImageLabel"); DummyCharChams.Name = "DummyCharChams"; DummyCharChams.BackgroundTransparency = 1; DummyCharChams.Position = UDim2.new(0, 0, 0, 0); DummyCharChams.Size = UDim2.new(1, 0, 1, 0); DummyCharChams.Image = CharImage; DummyCharChams.ZIndex = 2; DummyCharChams.Parent = DummyChar
    self.DummyCharChams = DummyCharChams
    local DummyCharHighlight = Instance.new("ImageLabel"); DummyCharHighlight.Name = "DummyCharHighlight"; DummyCharHighlight.BackgroundTransparency = 1; DummyCharHighlight.Position = UDim2.new(0, -2, 0, -2); DummyCharHighlight.Size = UDim2.new(1, 4, 1, 4); DummyCharHighlight.Image = CharImage; DummyCharHighlight.ZIndex = 1; DummyCharHighlight.Parent = DummyChar
    self.DummyCharHighlight = DummyCharHighlight
    local Box = Instance.new("Frame"); Box.Name = "DummyBox"; Box.BackgroundTransparency = 1; Box.BorderSizePixel = 0; Box.Position = UDim2.new(0.5, -62, 0.5, -90); Box.Size = UDim2.fromOffset(125, 170); Box.ZIndex = 10; Box.Parent = InnerContainer
    self.DummyBox = Box
    local BoxStroke = Instance.new("UIStroke"); BoxStroke.Thickness = 1; BoxStroke.LineJoinMode = Enum.LineJoinMode.Miter; BoxStroke.Parent = Box
    self.DummyBoxMain = BoxStroke
    local BoxOuter = Instance.new("Frame"); BoxOuter.Name = "Outer"; BoxOuter.BackgroundTransparency = 1; BoxOuter.Position = UDim2.new(0, -1, 0, -1); BoxOuter.Size = UDim2.new(1, 2, 1, 2); BoxOuter.ZIndex = 10; BoxOuter.Parent = Box
    local OuterStroke = Instance.new("UIStroke"); OuterStroke.Color = Color3.new(0,0,0); OuterStroke.Thickness = 1; OuterStroke.LineJoinMode = Enum.LineJoinMode.Miter; OuterStroke.Parent = BoxOuter
    local BoxInnerF = Instance.new("Frame"); BoxInnerF.Name = "Inner"; BoxInnerF.BackgroundTransparency = 1; BoxInnerF.Position = UDim2.new(0, 1, 0, 1); BoxInnerF.Size = UDim2.new(1, -2, 1, -2); BoxInnerF.ZIndex = 10; BoxInnerF.Parent = Box
    local InnerStroke = Instance.new("UIStroke"); InnerStroke.Color = Color3.new(0,0,0); InnerStroke.Thickness = 1; InnerStroke.LineJoinMode = Enum.LineJoinMode.Miter; InnerStroke.Parent = BoxInnerF
    local BoxFill = Instance.new("Frame"); BoxFill.Name = "Fill"; BoxFill.BorderSizePixel = 0; BoxFill.Position = UDim2.new(0, 0, 0, 0); BoxFill.Size = UDim2.new(1, 0, 1, 0); BoxFill.ZIndex = 2; BoxFill.Parent = Box
    self.DummyBoxFill = BoxFill
    local bFont = Enum.Font.Roboto
    local Name = Instance.new("TextLabel"); Name.Name = "DummyName"; Name.BackgroundTransparency = 1; Name.Position = UDim2.new(0.5, -62, 0.5, -105); Name.Size = UDim2.fromOffset(125, 12); Name.Font = bFont; Name.Text = "Player"; Name.TextSize = 13; Name.ZIndex = 11; Name.Parent = InnerContainer
    local NameStroke = Instance.new("UIStroke"); NameStroke.Thickness = 1; NameStroke.Color = Color3.new(0,0,0); NameStroke.LineJoinMode = Enum.LineJoinMode.Miter; NameStroke.Parent = Name
    local Weapon = Instance.new("TextLabel"); Weapon.Name = "DummyWeapon"; Weapon.BackgroundTransparency = 1; Weapon.Position = UDim2.new(0.5, -62, 0.5, 83); Weapon.Size = UDim2.fromOffset(125, 12); Weapon.Font = bFont; Weapon.Text = "Winchester"; Weapon.TextSize = 11; Weapon.ZIndex = 11; Weapon.Parent = InnerContainer
    local WeaponStroke = Instance.new("UIStroke"); WeaponStroke.Thickness = 1; WeaponStroke.Color = Color3.new(0,0,0); WeaponStroke.LineJoinMode = Enum.LineJoinMode.Miter; WeaponStroke.Parent = Weapon
    local Dist = Instance.new("TextLabel"); Dist.Name = "DummyDist"; Dist.BackgroundTransparency = 1; Dist.Position = UDim2.new(0.5, -62, 0.5, 96); Dist.Size = UDim2.fromOffset(125, 12); Dist.Font = bFont; Dist.Text = "[ 150m ]"; Dist.TextSize = 11; Dist.ZIndex = 11; Dist.Parent = InnerContainer
    local DistStroke = Instance.new("UIStroke"); DistStroke.Thickness = 1; DistStroke.Color = Color3.new(0,0,0); DistStroke.LineJoinMode = Enum.LineJoinMode.Miter; DistStroke.Parent = Dist
    local HealthBar = Instance.new("Frame"); HealthBar.Name = "DummyHealth"; HealthBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0); HealthBar.BorderSizePixel = 0; HealthBar.Position = UDim2.new(0.5, -67, 0.5, -90); HealthBar.Size = UDim2.fromOffset(2, 170); HealthBar.ZIndex = 12; HealthBar.Parent = InnerContainer
    self.DummyHealthBar = HealthBar
    local HealthStroke = Instance.new("UIStroke"); HealthStroke.Thickness = 1; HealthStroke.Color = Color3.new(0,0,0); HealthStroke.LineJoinMode = Enum.LineJoinMode.Miter; HealthStroke.Parent = HealthBar
    local HealthSolid = Instance.new("Frame"); HealthSolid.Name = "Solid"; HealthSolid.BorderSizePixel = 0; HealthSolid.BackgroundColor3 = Color3.new(1,1,1); HealthSolid.ZIndex = 13; HealthSolid.Parent = HealthBar
    self.DummyHealthSolid = HealthSolid
    local HealthGradient = Instance.new("UIGradient"); HealthGradient.Rotation = 90; HealthGradient.Parent = HealthSolid
    self.DummyHealthGradient = HealthGradient
    local HealthText = Instance.new("TextLabel"); HealthText.Name = "HealthText"; HealthText.BackgroundTransparency = 1; HealthText.Font = bFont; HealthText.TextSize = 11; HealthText.Size = UDim2.fromOffset(20, 12); HealthText.TextXAlignment = Enum.TextXAlignment.Right; HealthText.ZIndex = 14; HealthText.Parent = HealthBar
    local HealthTextStroke = Instance.new("UIStroke"); HealthTextStroke.Thickness = 1; HealthTextStroke.Color = Color3.new(0,0,0); HealthTextStroke.LineJoinMode = Enum.LineJoinMode.Miter; HealthTextStroke.Parent = HealthText
    self.DummyHealthText = HealthText
    self.Glow = Glow
    self.Inner = Inner
    self.DummyName = Name
    self.DummyDist = Dist
    self.DummyWeapon = Weapon
    self.Title = Title
    if typeof(syn) == "table" and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = gethui() or game:GetService("CoreGui")
    Library:MakeDraggable(Main, 15, false, true)
    if Library.MakeResizable then Library:MakeResizable(Main, Vector2.new(150, 180)) end
    Main:GetPropertyChangedSignal("Position"):Connect(function() if self.Enabled and not self.stickyUpdating then self.UserMoved = true end end)
    RS.RenderStepped:Connect(function()
        if self.Enabled and Library.MainOuterFrame then
            if not self.UserMoved then
                self.stickyUpdating = true
                local pos = Library.MainOuterFrame.AbsolutePosition
                Main.Position = UDim2.new(0, pos.X - 215, 0, pos.Y + 3)
                self.stickyUpdating = false
            end
            self:UpdateAesthetics()
        end
    end)
    Library.MainOuterFrame:GetPropertyChangedSignal("Visible"):Connect(function()
        self:UpdateAesthetics()
    end)
end

function ESPPreview:Toggle(state)
    self.Enabled = state
    if state then
        self.UserMoved = false
        if not self.Container then self:Create() end
        if not self.MainFrame then return end
        self:UpdateAesthetics()
        if Library.MainOuterFrame and not self.UserMoved then
            local pos = Library.MainOuterFrame.AbsolutePosition
            self.MainFrame.Position = UDim2.new(0, pos.X - 215, 0, pos.Y)
        end
        self.MainFrame.Visible = true
        if not self.TCCache then
            self.TCCache = {}
            for _, desc in ipairs(self.MainFrame:GetDescendants()) do
                if desc:IsA("ImageLabel") then self.TCCache[desc] = {Prop = "ImageTransparency", Val = desc.ImageTransparency}
                elseif desc:IsA("TextLabel") then self.TCCache[desc] = {Prop = "TextTransparency", Val = desc.TextTransparency}
                elseif desc:IsA("UIStroke") then self.TCCache[desc] = {Prop = "Transparency", Val = desc.Transparency}
                elseif desc:IsA("Frame") then self.TCCache[desc] = {Prop = "BackgroundTransparency", Val = desc.BackgroundTransparency}
                end
            end
            self.TCCache[self.MainFrame] = {Prop = "BackgroundTransparency", Val = self.MainFrame.BackgroundTransparency}
        else
            for desc, data in pairs(self.TCCache) do
                if desc:IsA("ImageLabel") and desc.Name == "Glow" then
                    data.Val = math.clamp(1 - ((1 - 0.7) * (Library.GlowAmount or 1)), 0, 1)
                elseif desc:IsA("ImageLabel") and desc.Name == "DummyCharChams" then
                    data.Val = L.Chams and (L.ChamsTrans or 0.5) or 1
                elseif desc:IsA("ImageLabel") and desc.Name == "DummyCharHighlight" then
                    data.Val = L.Chams and (L.ChamsOutlineTrans or 0.0) or 1
                end
            end
        end
        for desc, data in pairs(self.TCCache) do
            if data.Val == 1 then continue end
            local cur = desc[data.Prop]
            desc[data.Prop] = 1
            TS:Create(desc, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {[data.Prop] = data.Val}):Play()
        end
    else
        if self.MainFrame and self.TCCache then
            local longest
            for desc, data in pairs(self.TCCache) do
                if data.Val == 1 then continue end
                longest = TS:Create(desc, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {[data.Prop] = 1})
                longest:Play()
            end
            if longest then
                longest.Completed:Connect(function()
                    if not self.Enabled then self.MainFrame.Visible = false end
                end)
            else
                self.MainFrame.Visible = false
            end
        end
    end
end

local function getPartBox(part)
    if not part then return nil end
    local cframe = part.CFrame
    local size = part.Size
    local halfSize = size * 0.5
    local topWorld = cframe * Vector3.new(0, halfSize.Y, 0)
    local bottomWorld = cframe * Vector3.new(0, -halfSize.Y, 0)
    local topPos, topOnScreen = C:WorldToViewportPoint(topWorld)
    local bottomPos, bottomOnScreen = C:WorldToViewportPoint(bottomWorld)
    if not topOnScreen or not bottomOnScreen then return nil end
    local height = math.abs(topPos.Y - bottomPos.Y)
    local width = height * (size.X / size.Y)
    local x = topPos.X - (width / 2)
    local y = topPos.Y
    return {
        x = math.floor(x),
        y = math.floor(y),
        w = math.floor(width),
        h = math.floor(height)
    }
end

local function getHeldWeapon(model)
    if not model then return "None" end
    local name = model.Name
    local vm = WS:FindFirstChild("ViewModels")
    if vm then
        for _, child in ipairs(vm:GetChildren()) do
            local cName = child.Name
            local prefix = name .. " - "
            if cName:sub(1, #prefix) == prefix then
                local remaining = cName:sub(#prefix + 1)
                local parts = string.split(remaining, " - ")
                if parts[1] then
                    return parts[1]
                end
            end
        end
    end
    return "None"
end

local function createESP(model)
    local esp = {
        boxOutline = Drawing.new("Square"),
        box = Drawing.new("Square"),
        boxFill = Drawing.new("Square"),
        nameText = Drawing.new("Text"),
        distanceText = Drawing.new("Text"),
        weaponText = Drawing.new("Text"),
        healthOutlineBg = Drawing.new("Square"),
        healthOutline = Drawing.new("Square"),
        healthLines = {},
        healthText = Drawing.new("Text"),
        skeletonLines = {},
        chamHighlight = nil,
        opacity = 0,
        state = "fadein",
        highlightLerp = 0
    }

    esp.boxOutline.Thickness = 3
    esp.boxOutline.Color = Color3.fromRGB(0, 0, 0)
    esp.boxOutline.Filled = false
    esp.boxOutline.Visible = false

    esp.box.Thickness = 1
    esp.box.Color = Color3.fromRGB(255, 255, 255)
    esp.box.Filled = false
    esp.box.Visible = false

    esp.boxFill.Filled = true
    esp.boxFill.Visible = false

    esp.nameText.Size = 13
    esp.nameText.Center = true
    esp.nameText.Outline = true
    esp.nameText.Visible = false

    esp.distanceText.Size = 13
    esp.distanceText.Center = true
    esp.distanceText.Outline = true
    esp.distanceText.Visible = false

    esp.weaponText.Size = 13
    esp.weaponText.Center = true
    esp.weaponText.Outline = true
    esp.weaponText.Visible = false

    esp.healthOutlineBg.Thickness = 1
    esp.healthOutlineBg.Color = Color3.fromRGB(0, 0, 0)
    esp.healthOutlineBg.Filled = true
    esp.healthOutlineBg.Visible = false

    esp.healthOutline.Thickness = 1
    esp.healthOutline.Color = Color3.fromRGB(0, 0, 0)
    esp.healthOutline.Filled = false
    esp.healthOutline.Visible = false

    esp.healthText.Size = 13
    esp.healthText.Outline = true
    esp.healthText.Font = L.Font
    esp.healthText.Visible = false

    for i = 1, 14 do
        local outline = Drawing.new("Line")
        outline.Thickness = 2
        outline.Color = Color3.fromRGB(0, 0, 0)
        outline.Visible = false

        local fill = Drawing.new("Line")
        fill.Thickness = 1
        fill.Color = Color3.fromRGB(255, 255, 255)
        fill.Visible = false

        esp.skeletonLines[i] = { outline = outline, fill = fill }
    end

    esp.opacity = 0
    esp.state = "fadein"

    cache[model] = esp
    return esp
end

local function removeESP(model)
    local esp = cache[model]
    if esp then
        if esp.boxOutline then pcall(function() esp.boxOutline:Remove() end) end
        if esp.box then pcall(function() esp.box:Remove() end) end
        if esp.boxFill then pcall(function() esp.boxFill:Remove() end) end
        if esp.nameText then pcall(function() esp.nameText:Remove() end) end
        if esp.distanceText then pcall(function() esp.distanceText:Remove() end) end
        if esp.weaponText then pcall(function() esp.weaponText:Remove() end) end
        if esp.healthOutlineBg then pcall(function() esp.healthOutlineBg:Remove() end) end
        if esp.healthOutline then pcall(function() esp.healthOutline:Remove() end) end
        if esp.healthText then pcall(function() esp.healthText:Remove() end) end
        if esp.healthLines then
            for _, line in pairs(esp.healthLines) do
                pcall(function() line:Remove() end)
            end
            table.clear(esp.healthLines)
        end
        if esp.skeletonLines then
            for _, line in ipairs(esp.skeletonLines) do
                if line.outline then pcall(function() line.outline:Remove() end) end
                if line.fill then pcall(function() line.fill:Remove() end) end
            end
            table.clear(esp.skeletonLines)
        end
        if esp.chamHighlight then
            pcall(function() esp.chamHighlight:Destroy() end)
            esp.chamHighlight = nil
        end
        cache[model] = nil
    end
end

local function hideESP(esp)
    if esp.boxOutline then esp.boxOutline.Visible = false end
    if esp.box then esp.box.Visible = false end
    if esp.boxFill then esp.boxFill.Visible = false end
    if esp.nameText then esp.nameText.Visible = false end
    if esp.distanceText then esp.distanceText.Visible = false end
    if esp.weaponText then esp.weaponText.Visible = false end
    if esp.healthOutlineBg then esp.healthOutlineBg.Visible = false end
    if esp.healthOutline then esp.healthOutline.Visible = false end
    if esp.healthText then esp.healthText.Visible = false end
    if esp.healthLines then
        for _, line in next, esp.healthLines do
            line.Visible = false
        end
    end
    if esp.skeletonLines then
        for _, line in next, esp.skeletonLines do
            line.outline.Visible = false
            line.fill.Visible = false
        end
    end
    if esp.chamHighlight then
        esp.chamHighlight.Enabled = false
    end
end

local function isValidTarget(model)
    if not model or not model:IsA("Model") then return false end
    if model == LP.Character then return false end
    if model.Name:find("Dummy") then return false end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return false end
    if humanoid.Health <= 0 then return false end
    if P:GetPlayerFromCharacter(model) then return true end
    local parent = model.Parent
    if parent == WS:FindFirstChild("ShootingRangeEntities") or parent == WS then
        return true
    end
    return false
end

local lastTargetScan = 0
local cachedActiveTargets = {}

local function getBoundingBox(model)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    local head = model:FindFirstChild("Head")
    if not hrp or not head then return nil end

    local hrpPos = hrp.Position
    local topWorld = hrpPos + Vector3.new(0, 3, 0)
    local bottomWorld = hrpPos - Vector3.new(0, 3.5, 0)

    local topPos, topOnScreen = C:WorldToViewportPoint(topWorld)
    local bottomPos, bottomOnScreen = C:WorldToViewportPoint(bottomWorld)

    if not topOnScreen or not bottomOnScreen then return nil end

    local height = math.abs(topPos.Y - bottomPos.Y)
    local width = height * 0.55
    local x = topPos.X - (width / 2)
    local y = topPos.Y

    return {
        x = math.floor(x),
        y = math.floor(y),
        w = math.floor(width),
        h = math.floor(height)
    }
end

local renderConnection = RS.RenderStepped:Connect(function(dt)
    local now = os.clock()
    local centerScreen = UIS:GetMouseLocation()
    currentFOVSize = currentFOVSize + ((L.FOVSize - currentFOVSize) * (dt * 10))

    if L.FOVVisible then
        AimbotFOV.Visible = true
        AimbotFOV.Radius = currentFOVSize
        AimbotFOV.Position = centerScreen
if L.FOVGradient and L.FOVGrad1 and L.FOVGrad2 then
    local speed = L.FOVGradSpeed or 1
    local time = now * speed

    local t = (math.sin(time) + 1) * 0.5

    if L.FOVGradStyle == "Orbit" then
        t = (time * 0.18) % 1

    elseif L.FOVGradStyle == "Helix" then
        t = (math.sin(time * 1.6) + 1) * 0.5

    elseif L.FOVGradStyle == "Stream" then
        t = (time * 0.32) % 1
        t = t * t * (3 - 2 * t)

    elseif L.FOVGradStyle == "Flux" then
        t = (math.sin(time * 2.2) + math.cos(time * 1.4)) * 0.25 + 0.5

    elseif L.FOVGradStyle == "Nova" then
        t = math.abs(math.sin(time * 1.3))

    elseif L.FOVGradStyle == "Drift" then
        t = ((time * 0.1) + math.sin(time) * 0.15) % 1
    end

    AimbotFOV.Color = L.FOVGrad1:Lerp(L.FOVGrad2, math.clamp(t, 0, 1))
else
    AimbotFOV.Color = L.FOVColor
end
        AimbotFOVOutline.Visible = true
        AimbotFOVOutline.Radius = currentFOVSize
        AimbotFOVOutline.Position = centerScreen
    else
        AimbotFOV.Visible = false
        AimbotFOVOutline.Visible = false
    end

    if not L.Master then
        for _, esp in next, cache do
            hideESP(esp)
        end
        AimbotSnapline.Visible = false
        AimbotSnaplineOutline.Visible = false
        return
    end
    if now - lastTargetScan > 0.45 then
        lastTargetScan = now
        local active = {}
        for _, p in next, P:GetPlayers() do
            if p ~= LP then
                local char = p.Character
                if char and char:IsA("Model") then
                    active[char] = true
                end
            end
        end
        local sre = WS:FindFirstChild("ShootingRangeEntities")
        if sre then
            for _, child in next, sre:GetChildren() do
                if child.ClassName == "Model" then
                    active[child] = true
                end
            end
        end
        cachedActiveTargets = active
    end
    local activeTargets = cachedActiveTargets

    local targets = {}
    for model, esp in pairs(cache) do
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        local hrp = model:FindFirstChild("HumanoidRootPart")
        local isAlive = activeTargets[model] and humanoid and hrp and humanoid.Health > 0 and not model.Name:find("Dummy")

        if isAlive then
            if esp.state == "fadeout" or esp.state == "dead" then
                esp.state = "fadein"
            end
            if esp.state == "fadein" then
                esp.opacity = math.min(1, esp.opacity + (dt / L.FadeIn))
                if esp.opacity >= 1 then
                    esp.state = "active"
                end
            else
                esp.opacity = 1
            end
            targets[model] = true
        else
            if esp.state ~= "dead" then
                esp.state = "fadeout"
                esp.opacity = math.max(0, esp.opacity - (dt / L.FadeOut))
                if esp.opacity <= 0 then
                    esp.state = "dead"
                else
                    if hrp then
                        targets[model] = true
                    end
                end
            end
        end
    end

    for model in pairs(activeTargets) do
        if not cache[model] then
            local humanoid = model:FindFirstChildOfClass("Humanoid")
            local hrp = model:FindFirstChild("HumanoidRootPart")
            if humanoid and hrp and humanoid.Health > 0 and not model.Name:find("Dummy") then
                local esp = createESP(model)
                esp.opacity = 0
                esp.state = "fadein"
                targets[model] = true
            end
        end
    end

    for model, esp in pairs(cache) do
        if esp.state == "dead" or not model:IsDescendantOf(WS) then
            removeESP(model)
        end
    end

    local camPos = C.CFrame.Position
    local currentFont = L.Font
    local currentFontSize = L.FS

    local closestTarget = nil
    local closestDist = math.huge

    if L.Aimbot then
        for model in next, targets do
            local hrp = model:FindFirstChild("HumanoidRootPart")
            if hrp then
                local passTeam = true
                if L.TeamCheck then
                    local label = hrp:FindFirstChild("TeammateLabel")
                    if label then
                        local pFrame = label:FindFirstChild("Player")
                        if pFrame and pFrame.Visible and pFrame.Active then
                            passTeam = false
                        end
                    end
                end
                
                if passTeam then
                    local distance = (camPos - hrp.Position).Magnitude
                    if distance <= L.AimbotMaxDist then
                        local targetPart = model:FindFirstChild(L.AimbotBone) or model:FindFirstChild("Head") or hrp
                        if targetPart then
                            local sPos, onScreen = C:WorldToViewportPoint(targetPart.Position)
                            if onScreen then
                                local distToCenter = (Vector2.new(sPos.X, sPos.Y) - centerScreen).Magnitude
                                if distToCenter <= currentFOVSize then
                                    if distToCenter < closestDist then
                                        local isVisible = true
                                        if L.WallCheck then
                                            GlobalRaycastParams.FilterDescendantsInstances = {LP.Character, model}
                                            if WS:Raycast(camPos, targetPart.Position - camPos, GlobalRaycastParams) then
                                                isVisible = false
                                            end
                                        end
                                        if isVisible then
                                            closestDist = distToCenter
                                            closestTarget = model
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        if L.StickyAim and CurrentAimbotTarget and targets[CurrentAimbotTarget] then
            local valid = false
            local hrp = CurrentAimbotTarget:FindFirstChild("HumanoidRootPart")
            if hrp then
                local passTeam = true
                if L.TeamCheck then
                    local label = hrp:FindFirstChild("TeammateLabel")
                    if label then
                        local pFrame = label:FindFirstChild("Player")
                        if pFrame and pFrame.Visible and pFrame.Active then
                            passTeam = false
                        end
                    end
                end
                if passTeam and (camPos - hrp.Position).Magnitude <= L.AimbotMaxDist then
                    local tPart = CurrentAimbotTarget:FindFirstChild(L.AimbotBone) or CurrentAimbotTarget:FindFirstChild("Head") or hrp
                    local sPos, on = C:WorldToViewportPoint(tPart.Position)
                    if on then
                        if L.WallCheck then
                            GlobalRaycastParams.FilterDescendantsInstances = {LP.Character, CurrentAimbotTarget}
                            if not WS:Raycast(camPos, tPart.Position - camPos, GlobalRaycastParams) then
                                valid = true
                            end
                        else
                            valid = true
                        end
                    end
                end
            end
            if not valid then CurrentAimbotTarget = nil end
        else
            CurrentAimbotTarget = nil
        end
        
        if not CurrentAimbotTarget then
            CurrentAimbotTarget = closestTarget
        end
    else
        CurrentAimbotTarget = nil
    end

    if CurrentAimbotTarget and Options.AimbotKey:GetState() then
        local tPart = CurrentAimbotTarget:FindFirstChild(L.AimbotBone) or CurrentAimbotTarget:FindFirstChild("Head")
        if tPart then
            local sPos, onScreen = C:WorldToViewportPoint(tPart.Position)
            if onScreen then
                local mousePos = UIS:GetMouseLocation()
                local delta = Vector2.new(sPos.X, sPos.Y) - mousePos
                
                local smooth = L.Smoothness
                if smooth <= 1 then smooth = 1.0001 end
                
                if mousemoverel then
                    mousemoverel(delta.X / smooth, delta.Y / smooth)
                else
                    local aimCF = CFrame.new(camPos, tPart.Position)
                    C.CFrame = C.CFrame:Lerp(aimCF, 1 / smooth)
                end
            end
        end
    end

    if L.Snapline and CurrentAimbotTarget then
        local tPart = CurrentAimbotTarget:FindFirstChild(L.AimbotBone) or CurrentAimbotTarget:FindFirstChild("Head")
        if tPart then
            local sP, on = C:WorldToViewportPoint(tPart.Position)
            if on then
                local origin
                if L.SnapFrom == "Top" then
                    origin = Vector2.new(C.ViewportSize.X / 2, 0)
                elseif L.SnapFrom == "Mouse" then
                    origin = UIS:GetMouseLocation()
                else
                    origin = Vector2.new(C.ViewportSize.X / 2, C.ViewportSize.Y)
                end
                
                AimbotSnapline.From = origin
                AimbotSnapline.To = Vector2.new(sP.X, sP.Y)
                AimbotSnapline.Color = L.SnaplineColor
                AimbotSnapline.Visible = true

                AimbotSnaplineOutline.From = origin
                AimbotSnaplineOutline.To = Vector2.new(sP.X, sP.Y)
                AimbotSnaplineOutline.Visible = true
            else
                AimbotSnapline.Visible = false
                AimbotSnaplineOutline.Visible = false
            end
        else
            AimbotSnapline.Visible = false
            AimbotSnaplineOutline.Visible = false
        end
    else
        AimbotSnapline.Visible = false
        AimbotSnaplineOutline.Visible = false
    end

    for model in next, targets do
        local esp = cache[model]
        if esp then
            if L.HighlightTarget and model == CurrentAimbotTarget then
                esp.highlightLerp = math.min(1, esp.highlightLerp + (dt * 5))
            else
                esp.highlightLerp = math.max(0, esp.highlightLerp - (dt * 5))
            end

            local function lerpColor(c)
                if esp.highlightLerp > 0 then
                    return c:Lerp(L.HighlightColor, esp.highlightLerp)
                end
                return c
            end

            local currentBC = lerpColor(L.BC)
            local currentBFC = lerpColor(L.BFC)
            local currentNTC = lerpColor(L.NTC)
            local currentWTC = lerpColor(L.WTC)
            local currentDTC = lerpColor(L.DTC)
            local currentHHC = lerpColor(L.HHC)
            local currentHLC = lerpColor(L.HLC)
            local currentHTC = lerpColor(L.HTC)
            local currentSkelColor = lerpColor(L.SkelColor)
            local currentChamsColor = lerpColor(L.ChamsColor)
            local currentChamsOutlineColor = lerpColor(L.ChamsOutlineColor)

            local humanoid = model:FindFirstChildOfClass("Humanoid")
            local hrp = model:FindFirstChild("HumanoidRootPart")
            local distance = (camPos - hrp.Position).Magnitude

            if distance > L.DMax then
                hideESP(esp)
                continue
            end

            if L.TeamCheck then
                local label = hrp:FindFirstChild("TeammateLabel")
                if label then
                    local pFrame = label:FindFirstChild("Player")
                    if pFrame and pFrame.Visible and pFrame.Active then
                        hideESP(esp)
                        continue
                    end
                end
            end

            local box = getBoundingBox(model)
            if not box then
                hideESP(esp)
                continue
            end

            if L.VisCheck then
                local targetPart = model:FindFirstChild("Head") or hrp
                if targetPart then
                    GlobalRaycastParams.FilterDescendantsInstances = {LP.Character, model}
                    if WS:Raycast(camPos, targetPart.Position - camPos, GlobalRaycastParams) then
                        hideESP(esp)
                        continue
                    end
                end
            end

            if L.BE then
                esp.boxOutline.Size = Vector2.new(box.w, box.h)
                esp.boxOutline.Position = Vector2.new(box.x, box.y)
                esp.boxOutline.Transparency = esp.opacity
                esp.boxOutline.Visible = true

                esp.box.Size = Vector2.new(box.w, box.h)
                esp.box.Position = Vector2.new(box.x, box.y)
                esp.box.Color = currentBC
                esp.box.Transparency = esp.opacity
                esp.box.Visible = true

                if L.BFE then
                    esp.boxFill.Size = Vector2.new(box.w, box.h)
                    esp.boxFill.Position = Vector2.new(box.x, box.y)
                    esp.boxFill.Color = currentBFC
                    esp.boxFill.Transparency = (1 - L.BFTrans) * esp.opacity
                    esp.boxFill.Visible = true
                else
                    esp.boxFill.Visible = false
                end
            else
                esp.boxOutline.Visible = false
                esp.box.Visible = false
                esp.boxFill.Visible = false
            end

            if L.NE then
                local rawName = model.Name
                if L.NameStyle == "DisplayName" then
                    if esp.cachedPlayer == nil then
                        esp.cachedPlayer = P:GetPlayerFromCharacter(model) or false
                    end
                    if esp.cachedPlayer then
                        rawName = esp.cachedPlayer.DisplayName
                    end
                end

                if L.FCase == "Uppercase" then
                    rawName = rawName:upper()
                elseif L.FCase == "Lowercase" then
                    rawName = rawName:lower()
                end

                esp.nameText.Text = rawName
                esp.nameText.Size = currentFontSize
                esp.nameText.Font = currentFont
                esp.nameText.Color = currentNTC
                esp.nameText.Transparency = esp.opacity
                esp.nameText.Position = Vector2.new(box.x + (box.w / 2), box.y - currentFontSize - 2)
                esp.nameText.Visible = true
            else
                esp.nameText.Visible = false
            end

            local bottomOffset = 2
            if L.WE then
                local weaponName = getHeldWeapon(model)
                if L.FCase == "Uppercase" then
                    weaponName = weaponName:upper()
                elseif L.FCase == "Lowercase" then
                    weaponName = weaponName:lower()
                end

                esp.weaponText.Text = weaponName
                esp.weaponText.Size = currentFontSize
                esp.weaponText.Font = currentFont
                esp.weaponText.Color = currentWTC
                esp.weaponText.Transparency = esp.opacity
                esp.weaponText.Position = Vector2.new(box.x + (box.w / 2), box.y + box.h + bottomOffset)
                esp.weaponText.Visible = true
                bottomOffset = bottomOffset + currentFontSize + 2
            else
                esp.weaponText.Visible = false
            end

            if L.DE then
                local displayedDist = math.floor(L.DistMode == "Meters" and distance * 0.28 or distance)
                local suffix = L.DistMode == "Meters" and "m" or " studs"
                local distStr = displayedDist .. suffix
                if L.FCase == "Uppercase" then
                    distStr = distStr:upper()
                elseif L.FCase == "Lowercase" then
                    distStr = distStr:lower()
                end

                esp.distanceText.Text = distStr
                esp.distanceText.Size = currentFontSize
                esp.distanceText.Font = currentFont
                esp.distanceText.Color = currentDTC
                esp.distanceText.Transparency = esp.opacity
                esp.distanceText.Position = Vector2.new(box.x + (box.w / 2), box.y + box.h + bottomOffset)
                esp.distanceText.Visible = true
            else
                esp.distanceText.Visible = false
            end

            if L.HE then
                local maxHealth = humanoid.MaxHealth
                local health = math.clamp(humanoid.Health, 0, maxHealth)
                local healthPercentage = health / maxHealth
                
                if not esp.healthLerp then esp.healthLerp = healthPercentage end
                esp.healthLerp = esp.healthLerp + (healthPercentage - esp.healthLerp) * math.min(1, dt * 10)

                local barOffset = L.HBarOffset or 5
local barThickness = L.HBarThickness or 2

local barX = math.floor(box.x) - barOffset
local barY = math.floor(box.y)
local barW = barThickness
local barH = math.floor(box.h)

                esp.healthOutlineBg.Filled = true
                esp.healthOutlineBg.Size = Vector2.new(barW + 2, barH + 2)
                esp.healthOutlineBg.Position = Vector2.new(barX - 1, barY - 1)
                esp.healthOutlineBg.Color = Color3.new(0, 0, 0)
                esp.healthOutlineBg.Transparency = esp.opacity
                esp.healthOutlineBg.Visible = true

                esp.healthOutline.Filled = false
                esp.healthOutline.Thickness = 1
                esp.healthOutline.Size = Vector2.new(barW, barH)
                esp.healthOutline.Position = Vector2.new(barX, barY)
                esp.healthOutline.Color = Color3.new(0, 0, 0)
                esp.healthOutline.Transparency = esp.opacity
                esp.healthOutline.Visible = false

                local filledH = math.max(1, math.floor(barH * esp.healthLerp))
                local filledY = barY + (barH - filledH)

                local linesNeeded = filledH
                local currentLines = #esp.healthLines

                if currentLines < linesNeeded then
                    for i = currentLines + 1, linesNeeded do
                        local sq = Drawing.new("Square")
                        sq.Filled = true; sq.Thickness = 1; sq.Visible = false
                        esp.healthLines[i] = sq
                    end
                end

                local needed = math.max(1, filledH)


local animTime = 0

if L.HGradAnim then
    animTime = now * (L.HGradAnimSpeed or 1)
end

    for i = 1, needed do
        local sq = esp.healthLines[i]

        local yPos = filledY + (needed - i)

        sq.Size = Vector2.new(barW, 1)
        sq.Position = Vector2.new(barX, yPos)
        sq.Transparency = esp.opacity

        if L.HGrad then
local t = i / needed

if L.HGradAnim then
    local style = L.HGradAnimStyle

    if style == "Orbit" then
        t = (t + animTime * 0.12) % 1

    elseif style == "Helix" then
        t = (t + math.sin((t * 4) - (animTime * 2)) * 0.18) % 1

    elseif style == "Stream" then
        t = (t + animTime * 0.22) % 1
        t = t * t * (3 - 2 * t)

    elseif style == "Flux" then
        t = (t + math.sin((t * 8) + animTime) * 0.08)

    elseif style == "Nova" then
        t = (t + math.cos((t * 5) - animTime * 1.4) * 0.12)

    elseif style == "Drift" then
        t = (t + animTime * 0.08 + math.sin(t * 10 + animTime) * 0.04) % 1
    end
end

sq.Color = currentHLC:Lerp(currentHHC, math.clamp(t, 0, 1))
        else
            sq.Color = currentHHC:Lerp(currentHLC, 1 - esp.healthLerp)
        end

        sq.Visible = true
    end

                for i = needed + 1, #esp.healthLines do
                    if esp.healthLines[i] then
                        esp.healthLines[i].Visible = false
                    end
                end


                if L.HTE and healthPercentage < 0.99 then
                    esp.healthText.Text = tostring(math.floor(healthPercentage * 100))
                    esp.healthText.Size = currentFontSize - 2
                    esp.healthText.Font = currentFont
                    esp.healthText.Color = currentHTC
                    esp.healthText.Transparency = esp.opacity
                    esp.healthText.Position = Vector2.new(barX - 15, filledY - 2)
                    esp.healthText.Visible = true
                else
                    esp.healthText.Visible = false
                end
            else
                esp.healthOutlineBg.Visible = false
                esp.healthOutline.Visible = false
                for _, line in next, esp.healthLines do
                    line.Visible = false
                end
                esp.healthText.Visible = false
            end

            if L.Skel then
                local skelCache = esp.skelParts
                if not skelCache then
                    skelCache = {}
                    esp.skelParts = skelCache
                end

                local function getPart(name)
                    local p = skelCache[name]
                    if not p or not p.Parent then
                        p = model:FindFirstChild(name)
                        skelCache[name] = p
                    end
                    return p
                end

                local skelAlpha = esp.opacity
                local skelFillAlpha = esp.opacity * (1 - L.SkelTrans)

                for i, bone in next, BoneConnections do
                    local pA = getPart(bone[1])
                    local pB = getPart(bone[2])
                    local draw = esp.skeletonLines[i]

                    if pA and pB and draw then
                        local posA = pA.Position
                        local posB = pB.Position

                        local sA, onA = C:WorldToViewportPoint(posA)
                        local sB, onB = C:WorldToViewportPoint(posB)

                        if onA and onB then
                            local from = Vector2.new(sA.X, sA.Y)
                            local to   = Vector2.new(sB.X, sB.Y)

                            draw.outline.From = from
                            draw.outline.To   = to
                            draw.outline.Transparency = skelAlpha
                            draw.outline.Visible = true

                            draw.fill.From = from
                            draw.fill.To   = to
                            draw.fill.Color = currentSkelColor
                            draw.fill.Transparency = skelFillAlpha
                            draw.fill.Visible = true
                        else
                            draw.outline.Visible = false
                            draw.fill.Visible   = false
                        end
                    elseif draw then
                        draw.outline.Visible = false
                        draw.fill.Visible   = false
                    end
                end
            else
                for _, draw in next, esp.skeletonLines do
                    draw.outline.Visible, draw.fill.Visible = false, false
                end
            end

            if L.Chams then
                local highlight = esp.chamHighlight
                if not highlight or highlight.Parent == nil then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "RoxyCham"
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    pcall(function() highlight.Parent = model end)
                    esp.chamHighlight = highlight
                end
                highlight.FillColor = currentChamsColor
                highlight.FillTransparency = 1 - (1 - L.ChamsTrans) * esp.opacity
                highlight.OutlineColor = currentChamsOutlineColor
                highlight.OutlineTransparency = 1 - (1 - L.ChamsOutlineTrans) * esp.opacity
                highlight.Enabled = true
            else
                if esp.chamHighlight then
                    esp.chamHighlight.Enabled = false
                end
            end
        end
    end
end)

local CombatGroup = Tabs.Combat:AddLeftGroupbox("Aimbot")
CombatGroup:AddToggle('Aimbot', { Text = 'Aimbot', Default = false, Callback = function(v) L.Aimbot = v end }):AddKeyPicker('AimbotKey', { Default = 'None', SyncToggleState = false, Mode = 'Hold', Text = 'Aimbot Key', NoUI = false })
CombatGroup:AddToggle('StickyAim', { Text = 'Sticky Aim', Default = false, Callback = function(v) L.StickyAim = v end })
CombatGroup:AddToggle('WallCheck', { Text = 'Wall Check', Default = false, Callback = function(v) L.WallCheck = v end })
CombatGroup:AddSlider('Smoothness', { Text = 'Smoothness', Default = 1, Min = 1, Max = 10, Rounding = 1, Compact = true, Callback = function(v) L.Smoothness = v end })
CombatGroup:AddSlider('AimbotMaxDist', { Text = 'Max Distance', Default = 650, Min = 10, Max = 1000, Rounding = 0, Compact = true, Callback = function(v) L.AimbotMaxDist = v end })
CombatGroup:AddDropdown('AimbotBone', { Values = {'Head', 'UpperTorso', 'LowerTorso'}, Default = 1, Multi = false, Text = 'Aimbot Bone', Callback = function(v) L.AimbotBone = v end })

CombatGroup:AddDivider()

local SnapToggle = CombatGroup:AddToggle('Snapline', { Text = 'Snapline', Default = false, Callback = function(v) L.Snapline = v end })
SnapToggle:AddColorPicker('SnaplineColor', { Default = L.SnaplineColor, Title = 'Snapline Color', Callback = function(c) L.SnaplineColor = c end })

local D_Snap = CombatGroup:AddDependencyBox()
D_Snap:SetupDependencies({{SnapToggle, true}})
D_Snap:AddDropdown('SnapFrom', { Values = {'Bottom', 'Top', 'Mouse'}, Default = 3, Multi = false, Text = 'Snap Origin', Callback = function(v) L.SnapFrom = v end })
local FOVToggle = CombatGroup:AddToggle('FOVVisible', { Text = 'FOV Visible', Default = false, Callback = function(v) L.FOVVisible = v end })
FOVToggle:AddColorPicker('FOVColor', { Default = L.FOVColor, Title = 'FOV Color', Callback = function(c) L.FOVColor = c end })

local D_FOV = CombatGroup:AddDependencyBox()
D_FOV:SetupDependencies({{FOVToggle, true}})

local FOVGradToggle = D_FOV:AddToggle("FOVGradient", { Text = "Gradient Color", Default = false, Callback = function(v) L.FOVGradient = v end })
FOVGradToggle:AddColorPicker("FOVGrad1", { Default = Color3.fromRGB(211, 227, 255), Title = "Color 1", Callback = function(c) L.FOVGrad1 = c end })
FOVGradToggle:AddColorPicker("FOVGrad2", { Default = Color3.fromRGB(255, 255, 255), Title = "Color 2", Callback = function(c)
    L.FOVGrad2 = c
    L.FOVGradient = true
end})

local D_FOVGrad = CombatGroup:AddDependencyBox()
D_FOVGrad:SetupDependencies({{FOVToggle, true}, {FOVGradToggle, true}})
D_FOVGrad:AddSlider("FOVGradSpeed", { Text = "Animation Speed", Default = 1, Min = 0.1, Max = 10, Rounding = 1, Compact = true, Callback = function(v) L.FOVGradSpeed = v end })
D_FOVGrad:AddDropdown("FOVGradStyle", { Values = {
    'Orbit',
    'Helix',
    'Stream',
    'Flux',
    'Nova',
    'Drift'
}, Default = 1, Multi = false, Text = 'Animation Type', Callback = function(v) L.FOVGradStyle = v end })

CombatGroup:AddToggle('HighlightTarget', { Text = 'Highlight Target', Default = false, Callback = function(v) L.HighlightTarget = v end }):AddColorPicker('HighlightColor', { Default = L.HighlightColor, Title = 'Highlight Color', Callback = function(c) L.HighlightColor = c end })
CombatGroup:AddSlider('FOVSize', { Text = 'FOV Size', Default = 100, Min = 10, Max = 1000, Rounding = 0, Compact = true, Callback = function(v) L.FOVSize = v end })

local GunModsGroup = Tabs.Combat:AddRightGroupbox("Gun Mods")

local function MakeSimpleMod(id, text)
    GunModsGroup:AddToggle('Mod_'..id, { Text = text, Default = false, Callback = function(v) L['Mod_'..id] = v end })
end

local function MakeAmountMod(id, text, min, max, default, rounding)
    local tgl = GunModsGroup:AddToggle('Mod_'..id, { Text = text, Default = false, Callback = function(v) L['Mod_'..id] = v end })
    local dep = GunModsGroup:AddDependencyBox()
    dep:SetupDependencies({{tgl, true}})
    dep:AddSlider('Val_'..id, { Text = text..' Amount', Default = default, Min = min, Max = max, Rounding = rounding, Suffix = '%', Compact = true, Callback = function(v) L['Val_'..id] = v end })
end

MakeAmountMod('NoRecoil', 'Recoil Modifier', 0, 100, 0, 0)
MakeAmountMod('NoSpread', 'Spread Modifier', 0, 100, 0, 0)
MakeSimpleMod('InfAmmo', 'Inf Ammo')
MakeSimpleMod('FastFire', 'No Shoot Cooldown')
MakeSimpleMod('InfBullet', 'Inf Bullet')
MakeSimpleMod('FullAuto', 'Always Full Auto')

local PlayerESPTabbox = Tabs.Visuals:AddLeftTabbox()
local PlayerESPGroup = PlayerESPTabbox:AddTab("Player ESP")

local ME = PlayerESPGroup:AddToggle('MasterESP', {
    Text = 'Enable ESP', 
    Default = false, 
    Callback = function(v) 
        L.Master = v 
        if Toggles.ESPPreview then
            ESPPreview:Toggle(v and Toggles.ESPPreview.Value)
        end
    end
})

local D_Box = PlayerESPGroup:AddDependencyBox()
D_Box:SetupDependencies({{ME, true}})

D_Box:AddToggle('ESPPreview', {
    Text = 'ESP Preview',
    Default = true,
    Callback = function(v)
        ESPPreview:Toggle(v and L.Master)
    end
})

local BV = D_Box:AddToggle("BoxESP", {
    Text = "Box", 
    Default = false, 
    Callback = function(v) 
        L.BE = v 
    end
})
BV:AddColorPicker("BoxESPColor", {
    Default = L.BC, 
    Title = "Box Color", 
    Transparency = 0, 
    Callback = function(c) 
        L.BC = c 
    end
})

local D_BoxSub = PlayerESPGroup:AddDependencyBox()
D_BoxSub:SetupDependencies({{ME, true}, {BV, true}})

D_BoxSub:AddToggle("BoxFillToggle", {
    Text = "Box Fill", 
    Default = false, 
    Callback = function(v) 
        L.BFE = v 
    end
}):AddColorPicker("BoxFillColorPicker", {
    Default = L.BFC, 
    Title = "Box Fill Color", 
    Transparency = 0.5, 
    Callback = function(c) 
        L.BFC = c 
        if Options.BoxFillColorPicker then
            L.BFTrans = Options.BoxFillColorPicker.Transparency or 0.5
        end
    end
})

local D_Name = PlayerESPGroup:AddDependencyBox()
D_Name:SetupDependencies({{ME, true}})

local NV = D_Name:AddToggle('ShowPlayerTags', {
    Text = 'Name', 
    Default = false, 
    Callback = function(v) 
        L.NE = v 
    end
})
NV:AddColorPicker('NameTagColor', {
    Default = L.NTC, 
    Title = 'Name Text Color', 
    Transparency = 0, 
    Callback = function(c) 
        L.NTC = c 
    end
})

local D_NameSub = PlayerESPGroup:AddDependencyBox()
D_NameSub:SetupDependencies({{ME, true}, {NV, true}})

D_NameSub:AddDropdown('NameStyleDropdown', {
    Values = {'Username', 'DisplayName'},
    Default = 1,
    Multi = false,
    Text = 'Name Type',
    Callback = function(v)
        L.NameStyle = v
    end
})

local D_Health = PlayerESPGroup:AddDependencyBox()
D_Health:SetupDependencies({{ME, true}})

local HV = D_Health:AddToggle("HealthESP", {
    Text = "Health", 
    Default = false, 
    Callback = function(v) 
        L.HE = v 
    end
})
HV:AddColorPicker("HealthESPHigh", {
    Default = L.HHC, 
    Title = "High Health Color", 
    Callback = function(c) 
        L.HHC = c 
    end
})
HV:AddColorPicker("HealthESPLow", {
    Default = L.HLC, 
    Title = "Low Health Color", 
    Callback = function(c) 
        L.HLC = c 
    end
})

local D_HealthSub = PlayerESPGroup:AddDependencyBox()
D_HealthSub:SetupDependencies({{ME, true}, {HV, true}})

local HGradToggle = D_HealthSub:AddToggle("HealthGradientToggle", {
    Text = "Health Gradient",
    Default = false,
    Callback = function(v)
        L.HGrad = v
    end
})

local D_HGradSub = PlayerESPGroup:AddDependencyBox()
D_HGradSub:SetupDependencies({{ME, true}, {HV, true}, {HGradToggle, true}})

local HGradAnimToggle = D_HGradSub:AddToggle("HGradAnim", {
    Text = "Gradient Animation",
    Default = false,
    Callback = function(v) L.HGradAnim = v end
})

local D_HGradAnimSub = PlayerESPGroup:AddDependencyBox()
D_HGradAnimSub:SetupDependencies({{ME, true}, {HV, true}, {HGradToggle, true}, {HGradAnimToggle, true}})

D_HGradAnimSub:AddSlider("HGradAnimSpeed", {
    Text = "Animation Speed",
    Default = 1, Min = 0.1, Max = 10, Rounding = 1, Compact = true,
    Callback = function(v) L.HGradAnimSpeed = v end
})

D_HGradAnimSub:AddDropdown("HGradAnimStyle", {
Values = {
    'Orbit',
    'Helix',
    'Stream',
    'Flux',
    'Nova',
    'Drift'
},
    Default = 1, Multi = false, Text = 'Animation Style',
    Callback = function(v) L.HGradAnimStyle = v end
})

local D_HealthTextSub = PlayerESPGroup:AddDependencyBox()
D_HealthTextSub:SetupDependencies({{ME, true}, {HV, true}})

D_HealthTextSub:AddToggle("HealthTextToggle", {
    Text = "Health Text", 
    Default = false, 
    Callback = function(v) 
        L.HTE = v 
    end
}):AddColorPicker("HealthTextColor", {
    Default = L.HTC, 
    Title = "Health Text Color", 
    Callback = function(c) 
        L.HTC = c 
    end
})
local D_HealthBarOptions = PlayerESPGroup:AddDependencyBox()
D_HealthBarOptions:SetupDependencies({{ME, true}, {HV, true}})

D_HealthBarOptions:AddSlider("HBarThickness", {
    Text = "Healthbar Thickness",
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Compact = true,
    Callback = function(v)
        L.HBarThickness = v
    end
})

D_HealthBarOptions:AddSlider("HBarOffset", {
    Text = "Healthbar Offset",
    Default = 5,
    Min = 1,
    Max = 20,
    Rounding = 0,
    Compact = true,
    Callback = function(v)
        L.HBarOffset = v
    end
})

local D_Chams = PlayerESPGroup:AddDependencyBox()
D_Chams:SetupDependencies({{ME, true}})

local CV = D_Chams:AddToggle("ChamsESP", {
    Text = "Chams", 
    Default = false, 
    Callback = function(v) 
        L.Chams = v 
    end
})
CV:AddColorPicker("ChamsColor", {
    Default = L.ChamsColor, 
    Title = "Fill Color", 
    Transparency = 0.5,
    Callback = function(c) 
        L.ChamsColor = c 
        if Options.ChamsColor then
            L.ChamsTrans = Options.ChamsColor.Transparency or 0.5
        end
    end
})
CV:AddColorPicker("ChamsOutlineColor", {
    Default = L.ChamsOutlineColor, 
    Title = "Outline Color", 
    Transparency = 0.0,
    Callback = function(c) 
        L.ChamsOutlineColor = c 
        if Options.ChamsOutlineColor then
            L.ChamsOutlineTrans = Options.ChamsOutlineColor.Transparency or 0.0
        end
    end
})

local D_Dist = PlayerESPGroup:AddDependencyBox()
D_Dist:SetupDependencies({{ME, true}})

local CE2 = D_Dist:AddToggle('DistanceESP', {
    Text = 'Distance', 
    Default = false, 
    Callback = function(v) 
        L.DE = v 
    end
})
CE2:AddColorPicker("DistanceESPCP", {
    Default = L.DTC, 
    Title = "Distance Color", 
    Callback = function(v) 
        L.DTC = v 
    end
})

local D_DistSub = PlayerESPGroup:AddDependencyBox()
D_DistSub:SetupDependencies({{ME, true}, {CE2, true}})

D_DistSub:AddDropdown('DistanceMode', {
    Values = {'Studs', 'Meters'}, 
    Default = 1, 
    Multi = false, 
    Text = 'Measuring Mode', 
    Callback = function(v) 
        L.DistMode = v 
    end
})

local D_Weapon = PlayerESPGroup:AddDependencyBox()
D_Weapon:SetupDependencies({{ME, true}})

local WE2 = D_Weapon:AddToggle('WeaponESP', {
    Text = 'Weapon', 
    Default = false, 
    Callback = function(v) 
        L.WE = v 
    end
})
WE2:AddColorPicker("WeaponESPCP", {
    Default = L.WTC, 
    Title = "Weapon Color", 
    Callback = function(v) 
        L.WTC = v 
    end
})

local D_Skel = PlayerESPGroup:AddDependencyBox()
D_Skel:SetupDependencies({{ME, true}})

local SV = D_Skel:AddToggle("SkeletonESP", {
    Text = "Skeleton", 
    Default = false, 
    Callback = function(v) 
        L.Skel = v 
    end
})
SV:AddColorPicker("SkeletonColor", {
    Default = L.SkelColor, 
    Title = "Skeleton Color", 
    Transparency = 0.0,
    Callback = function(c) 
        L.SkelColor = c 
        if Options.SkeletonColor then
            L.SkelTrans = Options.SkeletonColor.Transparency or 0.0
        end
    end
})

local D_Misc = PlayerESPGroup:AddDependencyBox()
D_Misc:SetupDependencies({{ME, true}})

D_Misc:AddDivider()
D_Misc:AddDropdown('FontTypeDropdown', {
    Values = {'UI', 'System', 'Plex', 'Monospace'}, 
    Default = 3, 
    Multi = false, 
    Text = 'Font Type', 
    Callback = function(v) 
        L.Font = FM[v] or 2 
    end
})
D_Misc:AddDropdown('FontCaseDropdown', {
    Values = {'Normal', 'Lowercase', 'Uppercase'}, 
    Default = 1, 
    Multi = false, 
    Text = 'Font Case', 
    Callback = function(v) 
        L.FCase = v 
    end
})
D_Misc:AddSlider("FontSize", {
    Text = "Font Size", 
    Default = 13, 
    Min = 8, 
    Max = 24, 
    Rounding = 0, 
    Compact = true, 
    Callback = function(v) 
        L.FS = math.floor(v) 
    end
})
D_Misc:AddSlider("MaxDistance", {
    Text = "Max Distance", 
    Default = 650, 
    Min = 1, 
    Max = 1000, 
    Rounding = 0, 
    Compact = true, 
    Callback = function(v) 
        L.DMax = v 
    end
})

local ExtraTab = PlayerESPTabbox:AddTab("Extra")

ExtraTab:AddToggle("VisCheck", {
    Text = "Visible Only",
    Default = false,
    Callback = function(v) L.VisCheck = v end
})

ExtraTab:AddToggle("TeamCheck", {
    Text = "Team Check",
    Default = true,
    Callback = function(v)
        L.TeamCheck = v
    end
})

ExtraTab:AddSlider("FadeIn", {
    Text = "Fade In",
    Default = 0.5,
    Min = 0.05,
    Max = 3,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        L.FadeIn = v
    end
})

ExtraTab:AddSlider("FadeOut", {
    Text = "Fade Out",
    Default = 0.5,
    Min = 0.05,
    Max = 3,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        L.FadeOut = v
    end
})

ExtraTab:AddDivider()

ExtraTab:AddToggle("TextGradient", {
    Text = "Text Gradient",
    Default = false,
    Tooltip = "Utilizes a sophisticated dual-color interpolation engine to apply chromatic gradients across all ESP text labels for a premium visual aesthetic.",
    Callback = function(v)
        L.TextGradient = v
    end
}):AddColorPicker("TextGradColor1", {
    Default = Library.FontColor,
    Title = "Primary Gradient Color",
    Callback = function(v)
        L.TextGradColor1 = v
    end
}):AddColorPicker("TextGradColor2", {
	Default = Color3.new(1, 1, 1),
	Title = "Secondary Gradient Color",
	Callback = function(v)
		L.TextGradColor2 = v
	end
})
local HttpService2 = game:GetService("HttpService")

local _CosLib, _ItemLib
pcall(function()
    _CosLib  = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
    _ItemLib = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
end)

local ReplicatedClass
pcall(function()
    ReplicatedClass = require(ReplicatedStorage.Modules:WaitForChild("ReplicatedClass", 10))
end)

local FighterController, ClientItem, ClientViewModel, EmoteController
pcall(function() FighterController = require(controllers:WaitForChild("FighterController", 10)) end)
pcall(function() ClientItem = require(playerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem) end)
pcall(function() ClientViewModel = require(playerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel) end)
pcall(function() EmoteController = require(controllers:WaitForChild("EmoteController", 10)) end)

local sc_equipped         = {}
local sc_favorites        = {}
local sc_constructingWeapon
local sc_replicationQueue = {}
local sc_weaponDataCache = {}
local sc_invProxy = nil
local sc_favDirty = true
local sc_favCache = nil
local sc_emoteCache = nil
local sc_unlockAllRequested = false
local sc_enumCache = {}
local sc_cosCache = {}
local sc_lowerCache = {}
local SC_COSMETIC_TYPES = { Skin=true, Charm=true, Wrap=true, Wrapping=true, Dance=true, Emote=true }
local sc_equippedSet = {}
local function sc_isCurrentlyEquipped(name)
    return sc_equippedSet[name] == true
end
local function sc_updateEquippedSet()
    table.clear(sc_equippedSet)
    for _, cosmetics in next, sc_equipped do
        for _, data in next, cosmetics do
            if data and data.Name then
                sc_equippedSet[data.Name] = true
            end
        end
    end
end
local function sc_lower(s)
    local v = sc_lowerCache[s]
    if v then return v end
    v = string.lower(s); sc_lowerCache[s] = v; return v
end

local function sc_getCosmetic(name)
    local c = sc_cosCache[name]
    if c ~= nil then return c or nil end
    c = _CosLib and _CosLib.Cosmetics and _CosLib.Cosmetics[name]
    sc_cosCache[name] = c or false
    return c
end

local sc_validCache = {}
local function sc_isValid(name)
    local cached = sc_validCache[name]
    if cached ~= nil then return cached end
    local c = sc_getCosmetic(name)
    if not c then sc_validCache[name] = false; return false end
    if SC_COSMETIC_TYPES[c.Type] then sc_validCache[name] = true; return true end
    local l = sc_lower(name)
    local ok = l:find("wrap") or l:find("charm") or l:find("dance") or l:find("emote")
    sc_validCache[name] = ok and true or false
    return sc_validCache[name]
end

local function sc_clone(tbl)
    local n = {}
    for k, v in next, tbl do n[k] = v end
    return n
end

local function sc_getEnum(name)
    local c = sc_enumCache[name]
    if c ~= nil then return c or nil end
    local ok, r = pcall(EnumLibrary.ToEnum, EnumLibrary, name)
    sc_enumCache[name] = ok and r or false
    return sc_enumCache[name] or nil
end

local function sc_cloneCosmetic(name, cosType, opts)
    local c = sc_getCosmetic(name)
    if not c then return nil end
    local d = sc_clone(c)
    d.Name = name
    d.Type = d.Type or cosType
    d.Seed = d.Seed or math.random(1, 1000000)
    local eid = sc_getEnum(name)
    if eid then d.Enum = eid; d.ObjectID = d.ObjectID or eid end
    if opts then d.Inverted = opts.inverted; d.OnlyUseFavorites = opts.favoritesOnly end
    return d
end

local function sc_invalidateWeapon(weaponName)
    sc_weaponDataCache[weaponName] = nil
    sc_invDirty = true
    sc_invProxy = nil
end

local function sc_queueReplication(key)
    if sc_replicationQueue[key] then return end
    sc_replicationQueue[key] = true
    task.defer(function()
        sc_replicationQueue[key] = nil
        pcall(function() DataController.CurrentData:Replicate(key) end)
    end)
end

local function sc_invalidateAll()
    table.clear(sc_weaponDataCache)
    sc_invDirty = true
    sc_invProxy = nil
    sc_favDirty = true
    sc_favCache = nil
    sc_emoteCache = nil
end
if _CosLib then
    local _origOwns = _CosLib.OwnsCosmetic
    local function _owns(_, _, name) return sc_unlockAllRequested or sc_isCurrentlyEquipped(name) end
    _CosLib.OwnsCosmeticNormally    = _owns
    _CosLib.OwnsCosmeticUniversally = _owns
    _CosLib.OwnsCosmeticForWeapon   = _owns
    _CosLib.OwnsCosmetic = function(self, inv, name, weapon)
        if name:find("MISSING_") then return _origOwns(self, inv, name, weapon) end
        return sc_unlockAllRequested or sc_isCurrentlyEquipped(name) or _origOwns(self, inv, name, weapon)
    end
end

if DataController then
    local _origGet = DataController.Get
    local _invMeta = {
        __index = function(_, k)
            return (sc_unlockAllRequested or sc_isCurrentlyEquipped(k)) and true or nil
        end
    }

    DataController.Get = function(self, key)
        local data = _origGet(self, key)
        if key == "CosmeticInventory" then
            if not sc_invDirty and sc_invProxy then return sc_invProxy end
            local proxy = {}
            if data then
                for k, v in next, data do
                    proxy[k] = v
                end
            end
            if sc_unlockAllRequested then
                for k, _ in next, _CosLib.Cosmetics do
                    if sc_isValid(k) then proxy[k] = true end
                end
            end
            sc_invProxy = setmetatable(proxy, _invMeta)
            sc_invDirty = false
            return sc_invProxy
        end
        if key == "FavoritedCosmetics" then
            if not sc_favDirty and sc_favCache then return sc_favCache end
            local result = data and table.clone(data) or {}
            for weapon, favs in next, sc_favorites do
                local t = result[weapon]
                if not t then t = {}; result[weapon] = t end
                for name, state in next, favs do
                    if sc_isValid(name) then t[name] = state end
                end
            end
            sc_favCache = result
            sc_favDirty = false
            return result
        end
        return data
    end

    local _origGetWeapon = DataController.GetWeaponData
    DataController.GetWeaponData = function(self, weaponName)
        local cached = sc_weaponDataCache[weaponName]
        if cached then return cached end
        local data = _origGetWeapon(self, weaponName)
        if not data then return end
        local merged = sc_clone(data)
        merged.Name = weaponName
        local wc = sc_equipped[weaponName]
        if wc then
            for cosType, cosData in next, wc do
                merged[cosType] = cosData
            end
        end
        sc_weaponDataCache[weaponName] = merged
        return merged
    end
end

if _ItemLib and _ItemLib.GetViewModelImageFromWeaponData then
    local _origImg = _ItemLib.GetViewModelImageFromWeaponData
    _ItemLib.GetViewModelImageFromWeaponData = function(self, weaponData, highRes)
        if not weaponData then return _origImg(self, weaponData, highRes) end
        local wc = sc_equipped[weaponData.Name]
        if wc and wc.Skin then
            local info = self.ViewModels and self.ViewModels[wc.Skin.Name]
            if info then
                return info[highRes and "ImageHighResolution" or "Image"] or info.Image
            end
        end
        return _origImg(self, weaponData, highRes)
    end
end

-- ── ClientItem._CreateViewModel hook ──────────────────────────────────────
local function sc_applyCosmetics(data, wc, enumFn)
    for cosType, cosData in next, wc do
        local ek = enumFn(cosType)
        if ek then data[ek] = cosData else data[cosType] = cosData end
    end
end

if ClientItem and ClientItem._CreateViewModel then
    local _origCVM = ClientItem._CreateViewModel
    ClientItem._CreateViewModel = function(self, vmRef)
        local wPlayer = self.ClientFighter and self.ClientFighter.Player
        if wPlayer ~= LP then return _origCVM(self, vmRef) end
        local wName = self.Name
        local wc    = sc_equipped[wName]
        sc_constructingWeapon = wName
        if wc and vmRef then
            local dataKey = self:ToEnum("Data")
            local data    = vmRef[dataKey] or vmRef.Data
            if data then
                sc_applyCosmetics(data, wc, function(n) return self:ToEnum(n) end)
                if wc.Skin then
                    local nk = self:ToEnum("Name")
                    if nk then data[nk] = wc.Skin.Name else data.Name = wc.Skin.Name end
                end
            end
        end
        local result = _origCVM(self, vmRef)
        sc_constructingWeapon = nil
        return result
    end
end

-- ── ClientViewModel.new / GetCharm / GetWrap hooks ─────────────────────────
if ClientViewModel then
    local _origNew = ClientViewModel.new
    ClientViewModel.new = function(repData, clientItem)
        local wPlayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
        if wPlayer == LP then
            local wName = sc_constructingWeapon or clientItem.Name
            local wc    = sc_equipped[wName]
            if wc and ReplicatedClass then
                local dataKey = ReplicatedClass:ToEnum("Data")
                local data    = repData[dataKey]
                if not data then data = {}; repData[dataKey] = data end
                sc_applyCosmetics(data, wc, function(n) return ReplicatedClass:ToEnum(n) end)
            end
        end
        local result = _origNew(repData, clientItem)
        if wPlayer == LP then
            local wName = sc_constructingWeapon or clientItem.Name
            local wc    = sc_equipped[wName]
            if wc and result then
                if wc.Wrap and result._UpdateWrap then
                    task.defer(function() if not result._destroyed then result:_UpdateWrap() end end)
                end
                if wc.Charm and result._UpdateCharm then
                    task.defer(function() if not result._destroyed then result:_UpdateCharm() end end)
                end
            end
        end
        return result
    end

    if ClientViewModel.GetCharm then
        local _origGC = ClientViewModel.GetCharm
        ClientViewModel.GetCharm = function(self)
            local item = self.ClientItem
            if item then
                local wPlayer = item.ClientFighter and item.ClientFighter.Player
                if wPlayer == LP then
                    local wc = sc_equipped[item.Name]
                    if wc and wc.Charm then return wc.Charm end
                end
            end
            return _origGC(self)
        end
    end

    if ClientViewModel.GetWrap then
        local _origGW = ClientViewModel.GetWrap
        ClientViewModel.GetWrap = function(self)
            local item = self.ClientItem
            if item then
                local wPlayer = item.ClientFighter and item.ClientFighter.Player
                if wPlayer == LP then
                    local wc = sc_equipped[item.Name]
                    if wc and wc.Wrap then return wc.Wrap end
                end
            end
            return _origGW(self)
        end
    end
end

    local _origGE = EmoteController.GetEmotes
    EmoteController.GetEmotes = function(self)
        if sc_emoteCache then return sc_emoteCache end
        local emotes = _origGE(self)
        if _CosLib and _CosLib.Cosmetics then
            for name, cosmetic in next, _CosLib.Cosmetics do
                if cosmetic and (cosmetic.Type == "Dance" or cosmetic.Type == "Emote") and not emotes[name] then
                    emotes[name] = { Name=name, Type=cosmetic.Type, ObjectID=cosmetic.ObjectID, Enum=cosmetic.Enum }
                end
            end
        end
        sc_emoteCache = emotes
        return emotes
    end
pcall(function()
    local rem = ReplicatedStorage:WaitForChild("Remotes", 5)
    local rep = rem and rem:WaitForChild("Replication", 5)
    local fig = rep and rep:WaitForChild("Fighter", 5)
    _scUseItemRemote = fig and fig:WaitForChild("UseItem", 5)
end)

if hookmetamethod and scEquipCosmetic then
    local _oldNC
    _oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        if getnamecallmethod() ~= "FireServer" then return _oldNC(self, ...) end
        if self == _scUseItemRemote and FighterController then
            local objectID = select(1, ...)
            pcall(function()
                local fighter = FighterController:GetFighter(LP)
                if fighter and fighter.Items then
                    for _, item in next, fighter.Items do
                        if item:Get("ObjectID") == objectID then
                            sc_constructingWeapon = item.Name
                            break
                        end
                    end
                end
            end)
            return _oldNC(self, ...)
        end
        if self == scEquipCosmetic then
            local weaponName = select(1, ...)
            local cosType    = select(2, ...)
            local cosName    = select(3, ...)
            local opts       = select(4, ...) or {}
            if SC_COSMETIC_TYPES[cosType] then
                sc_equipped[weaponName] = sc_equipped[weaponName] or {}
                if cosName and cosName ~= "" and cosName ~= "None" then
                    local cloned = sc_cloneCosmetic(cosName, cosType, { inverted=opts.IsInverted, favoritesOnly=opts.OnlyUseFavorites })
                    if cloned then sc_equipped[weaponName][cosType] = cloned end
                else
                    sc_equipped[weaponName][cosType] = nil
                    if not next(sc_equipped[weaponName]) then sc_equipped[weaponName] = nil end
                end
                sc_updateEquippedSet()
                sc_invalidateWeapon(weaponName)
                sc_queueReplication("WeaponInventory")
            end
            return _oldNC(self, ...)
        end
        if scFavoriteCosmetic and self == scFavoriteCosmetic then
            local weapon  = select(1, ...)
            local cosName = select(2, ...)
            local state   = select(3, ...)
            if sc_isValid(cosName) then
                local t = sc_favorites[weapon]
                if not t then t = {}; sc_favorites[weapon] = t end
                t[cosName] = state or nil
                sc_favDirty = true
                sc_queueReplication("FavoritedCosmetics")
                return
            end
        end
        return _oldNC(self, ...)
    end)
end

local _equipRemote
local function scGetRemote()
    if _equipRemote and _equipRemote.Parent then return _equipRemote end
    _equipRemote = scEquipCosmetic
    return _equipRemote
end

local function scApply(weaponName, cosmeticType, cosmeticName)
    local remote = scGetRemote()
    if not remote then return false end
    local name = (cosmeticName and cosmeticName ~= "" and cosmeticName ~= "None") and cosmeticName or nil
    sc_equipped[weaponName] = sc_equipped[weaponName] or {}
    if name then
        local cloned = sc_cloneCosmetic(name, cosmeticType)
        if cloned then sc_equipped[weaponName][cosmeticType] = cloned end
    else
        sc_equipped[weaponName][cosmeticType] = nil
        if not next(sc_equipped[weaponName]) then sc_equipped[weaponName] = nil end
    end
    sc_updateEquippedSet()
    sc_invalidateWeapon(weaponName)
    sc_queueReplication("WeaponInventory")
    pcall(function()
        remote:FireServer(weaponName, cosmeticType, name or "", {})
    end)
    return true
end

local _cosmeticCache = {}
local function scGetCosmetics(...)
    local types = {...}
    local key = table.concat(types, "|")
    if _cosmeticCache[key] then return _cosmeticCache[key] end
    local results = { "None" }
    if _CosLib and _CosLib.Cosmetics then
        local seen = {}
        for name, data in next, _CosLib.Cosmetics do
            if data and not seen[name] then
                for _, t in ipairs(types) do
                    if data.Type == t then
                        table.insert(results, name)
                        seen[name] = true
                        break
                    end
                end
            end
        end
    end
    table.sort(results, function(a, b)
        if a == "None" then return true end
        if b == "None" then return false end
        return a:lower() < b:lower()
    end)
    _cosmeticCache[key] = results
    return results
end

local _weaponCosCache = {}
local function scGetCosmeticsForWeapon(weaponName, ...)
    local types = {...}
    local cacheKey = weaponName .. "|" .. table.concat(types, "|")
    if _weaponCosCache[cacheKey] then return _weaponCosCache[cacheKey] end

    local wLower = string.lower(weaponName)
    local results = { "None" }
    local fallback = { "None" }

    if _CosLib and _CosLib.Cosmetics then
        local seen = {}
        for name, data in next, _CosLib.Cosmetics do
            if data and not seen[name] then
                local typeMatch = false
                for _, t in ipairs(types) do
                    if data.Type == t then typeMatch = true; break end
                end
                if typeMatch then
                    table.insert(fallback, name)
                    seen[name] = true

                    local weaponField =
                        data.Weapon or data.WeaponName or data.ForWeapon
                        or data.Item or data.ItemName or data.WeaponType

                    if weaponField then
                        if string.lower(tostring(weaponField)) == wLower then
                            table.insert(results, name)
                        end
                    else
                        local nLower = string.lower(name)
                        if nLower:sub(1, #wLower) == wLower then
                            table.insert(results, name)
                        end
                    end
                end
            end
        end
    end

    local function sortList(t)
        table.sort(t, function(a, b)
            if a == "None" then return true end
            if b == "None" then return false end
            return a:lower() < b:lower()
        end)
    end

    sortList(results)
    sortList(fallback)

    local final = (#results > 1) and results or fallback
    _weaponCosCache[cacheKey] = final
    return final
end

local VALID_WEAPONS = {
    "Assault Rifle",
    "Battle Axe",
    "Bow",
    "Burst Rifle",
    "Chainsaw",
    "Crossbow",
    "Daggers",
    "Distortion",
    "Elixir",
    "Energy Pistols",
    "Energy Rifle",
    "Exogun",
    "Fists",
    "Flamethrower",
    "Flare Gun",
    "Flashbang",
    "Freeze Ray",
    "Glass Cannon",
    "Glass Shard",
    "Grappler",
    "Grenade",
    "Grenade Launcher",
    "Gunblade",
    "Handgun",
    "Jump Pad",
    "Katana",
    "Knife",
    "Maul",
    "Medkit",
    "Minigun",
    "Molotov",
    "Paintball Gun",
    "Permafrost",
    "Revolver",
    "Riot Shield",
    "RNG Dice",
    "RPG",
    "Satchel",
    "Scythe",
    "Scepter",
    "Shorty",
    "Slingshot",
    "Smoke Grenade",
    "Sniper",
    "Spear",
    "Spray",
    "Subspace Tripmine",
    "Trowel",
    "Uzi",
    "War Horn",
    "Warpstone",
    "Warper"
}

local function scGetWeapons()
    return VALID_WEAPONS
end

local _wrapTypeKey
local function scGetWrapType()
    if _wrapTypeKey then return _wrapTypeKey end
    if _CosLib and _CosLib.Cosmetics then
        for _, data in next, _CosLib.Cosmetics do
            if data then
                if data.Type == "Wrapping" then _wrapTypeKey = "Wrapping"; break end
                if data.Type == "Wrap"     then _wrapTypeKey = "Wrap";     break end
            end
        end
    end
    _wrapTypeKey = _wrapTypeKey or "Wrap"
    return _wrapTypeKey
end

local weaponCosmetics = {}
local scSelectedWeapon  = nil
local scSelectedEmote   = "None"

local SC_FOLDER       = "unlockall/skins"
local SC_META         = "unlockall/skins/meta.json"
local scMeta         = { activeKey = nil, defaultConfig = "Default", configs = {}, autoApply = true, autoloadProfile = false }
local scConfigPending = false

local function scEnsureFolder()
    pcall(function()
        makefolder("unlockall")
        makefolder(SC_FOLDER)
    end)
end

local function scSafeName(name)
    return name:gsub("[^%w%s%-_]", "_"):match("^%s*(.-)%s*$")
end

local function scConfigFile(name)
    return SC_FOLDER .. "/" .. scSafeName(name) .. ".json"
end

local function scSaveMeta()
    if not writefile then return end
    scEnsureFolder()
    pcall(function() writefile(SC_META, HttpService2:JSONEncode(scMeta)) end)
end

local function scLoadMeta()
    if not readfile or not isfile then return end
    pcall(function()
        if isfile(SC_META) then
            local decoded = HttpService2:JSONDecode(readfile(SC_META))
            scMeta.activeKey     = decoded.activeKey or nil
            scMeta.defaultConfig = decoded.defaultConfig or "Default"
            scMeta.configs       = decoded.configs   or {}
            scMeta.autoApply       = (decoded.autoApply ~= nil) and decoded.autoApply or true
            scMeta.autoloadProfile = (decoded.autoloadProfile ~= nil) and decoded.autoloadProfile or true
        end
    end)
end

local function scBuildConfigList()
    local list = {}
    for _, name in ipairs(scMeta.configs) do
        table.insert(list, name)
    end
    if #list == 0 then table.insert(list, "Default") end
    return list
end

local function scActiveConfigName()
    return scMeta.activeKey or (scBuildConfigList()[1])
end

local function scSaveActiveConfig()
    if not writefile then return end
    scEnsureFolder()
    pcall(function()
        local data = {
            weaponCosmetics = weaponCosmetics,
            emote           = scSelectedEmote,
            lastWeapon      = scSelectedWeapon,
        }
        writefile(scConfigFile(scActiveConfigName()), HttpService2:JSONEncode(data))
    end)
end

local function scLoadConfig(name)
    if not readfile or not isfile then
        return
    end

    local path = scConfigFile(name)

    if not isfile(path) then
        return
    end

    local success, decoded = pcall(function()
        return HttpService2:JSONDecode(readfile(path))
    end)

    if not success or type(decoded) ~= "table" or not decoded.weaponCosmetics then return end
    sc_invalidateAll()
    table.clear(sc_equipped)
    table.clear(weaponCosmetics)
    for k, v in next, decoded.weaponCosmetics do weaponCosmetics[k] = v end
    scSelectedEmote  = decoded.emote           or "None"
    scSelectedWeapon = decoded.lastWeapon      or "Assault Rifle"
    for weapon, cosmetics in next, weaponCosmetics do
        for cosmeticType, cosmeticName in next, cosmetics do
            if cosmeticName and cosmeticName ~= "None" then
                local cloned = sc_cloneCosmetic(cosmeticName, cosmeticType)
                if cloned then
                    sc_equipped[weapon] = sc_equipped[weapon] or {}
                    sc_equipped[weapon][cosmeticType] = cloned
                end
                pcall(function() scEquipCosmetic:FireServer(weapon, cosmeticType, cosmeticName, {}) end)
            end
        end
    end
    sc_updateEquippedSet()
    sc_queueReplication("WeaponInventory")
end
local function scApplyAllSlot()
    local remote = scGetRemote()
    if not remote then
        Library:Notify("Remote not found — retry in a moment", 3)
        return
    end
    local wrapKey = scGetWrapType()
    local count   = 0
    for weapon, data in next, weaponCosmetics do
        if data.Skin  and data.Skin  ~= "None" then scApply(weapon, "Skin",   data.Skin);  count += 1 end
        if data.Charm and data.Charm ~= "None" then scApply(weapon, "Charm",  data.Charm); count += 1 end
        if data.Wrap  and data.Wrap  ~= "None" then scApply(weapon, wrapKey,  data.Wrap);  count += 1 end
    end
    if scSelectedEmote and scSelectedEmote ~= "None" then
        pcall(function() remote:FireServer("Dances", "Dance", scSelectedEmote, {}) end)
        count += 1
    end
    Library:Notify("Applied " .. count .. " cosmetic(s) from \"" .. scActiveConfigName() .. "\"", 4)
end

scLoadMeta()
if #scMeta.configs == 0 then
    scMeta.configs      = { "Default" }
    scMeta.activeKey    = "Default"
    scMeta.defaultConfig = "Default"
    scSaveMeta()
end
if scMeta.autoloadProfile then
    local startProfile = scMeta.defaultConfig or scMeta.activeKey or scMeta.configs[1]
    scMeta.activeKey = startProfile
    scLoadConfig(startProfile)
end

local SkinTab      = Tabs.Skinchanger
local SCLeftTabbox = SkinTab:AddLeftTabbox()

local WeaponSkinsTab = SCLeftTabbox:AddTab("Weapon Skins")

local weaponList = scGetWeapons()
local skinList   = scGetCosmetics("Skin")
local charmList  = scGetCosmetics("Charm")
local wrapList   = scGetCosmetics("Wrap", "Wrapping")

scSelectedWeapon = scSelectedWeapon or weaponList[1] or "None"

local function scWeaponData(weapon)
    if not weaponCosmetics[weapon] then
        weaponCosmetics[weapon] = { Skin = "None", Charm = "None", Wrap = "None" }
    end
    return weaponCosmetics[weapon]
end

local _lastDropdownWeapon = nil
local scUpdatingDropdowns = false

local function scRefreshDropdowns(weapon)
    if scUpdatingDropdowns then return end
    scUpdatingDropdowns = true
    local data     = scWeaponData(weapon)
    local wrapKey  = scGetWrapType()
    local skins  = scGetCosmeticsForWeapon(weapon, "Skin")
    local charms = scGetCosmeticsForWeapon(weapon, "Charm")
    local wraps  = scGetCosmeticsForWeapon(weapon, "Wrap", "Wrapping")
    task.defer(function()
        pcall(function()
            if Options.SC_SkinSelect then
                if weapon ~= _lastDropdownWeapon and Options.SC_SkinSelect.SetValues then
                    Options.SC_SkinSelect:SetValues(skins)
                end
                local skin = data.Skin
                local valid = false
                for _, v in next, skins do if v == skin then valid = true; break end end
                Options.SC_SkinSelect:SetValue(valid and skin or "None")
            end
            if Options.SC_CharmSelect then
                if weapon ~= _lastDropdownWeapon and Options.SC_CharmSelect.SetValues then
                    Options.SC_CharmSelect:SetValues(charms)
                end
                local charm = data.Charm
                local valid = false
                for _, v in next, charms do if v == charm then valid = true; break end end
                Options.SC_CharmSelect:SetValue(valid and charm or "None")
            end
            if Options.SC_WrapSelect then
                if weapon ~= _lastDropdownWeapon and Options.SC_WrapSelect.SetValues then
                    Options.SC_WrapSelect:SetValues(wraps)
                end
                local wrap = data.Wrap
                local valid = false
                for _, v in next, wraps do if v == wrap then valid = true; break end end
                Options.SC_WrapSelect:SetValue(valid and wrap or "None")
            end
        end)
        _lastDropdownWeapon = weapon
        scUpdatingDropdowns = false
    end)
end

WeaponSkinsTab:AddDropdown("SC_WeaponSelect", {
    Values   = scGetWeapons(),
    Default  = 1,
    Text     = "Select Weapon",
    Callback = function(v)
        scSelectedWeapon = v
        _weaponCosCache = {}
        scRefreshDropdowns(v)
        scSaveActiveConfig()
    end,
})

WeaponSkinsTab:AddDropdown("SC_SkinSelect", {
    Values   = scGetCosmeticsForWeapon(scSelectedWeapon, "Skin"),
    Default  = 1,
    Multi    = false,
    Text     = "Skin",
    Callback = function(v)
        if scUpdatingDropdowns then return end
        local weapon = scSelectedWeapon or weaponList[1]
        local data   = scWeaponData(weapon)
        data.Skin = v
        scApply(weapon, "Skin", v)
        scSaveActiveConfig()
    end,
})

WeaponSkinsTab:AddDropdown("SC_CharmSelect", {
    Values   = scGetCosmeticsForWeapon(scSelectedWeapon, "Charm"),
    Default  = 1,
    Multi    = false,
    Text     = "Charm",
    Callback = function(v)
        if scUpdatingDropdowns then return end
        local weapon = scSelectedWeapon or weaponList[1]
        local data   = scWeaponData(weapon)
        data.Charm = v
        scApply(weapon, "Charm", v)
        scSaveActiveConfig()
    end,
})

WeaponSkinsTab:AddDropdown("SC_WrapSelect", {
    Values   = scGetCosmeticsForWeapon(scSelectedWeapon, "Wrap", "Wrapping"),
    Default  = 1,
    Multi    = false,
    Text     = "Wrap",
    Callback = function(v)
        if scUpdatingDropdowns then return end
        local weapon  = scSelectedWeapon or weaponList[1]
        local wrapKey = scGetWrapType()
        local data    = scWeaponData(weapon)
        data.Wrap = v
        scApply(weapon, wrapKey, v)
        scSaveActiveConfig()
    end,
})

task.defer(function()
    pcall(function()
        if Options.SC_WeaponSelect then
            Options.SC_WeaponSelect:SetValue(scSelectedWeapon or weaponList[1])
        end
    end)
    scRefreshDropdowns(scSelectedWeapon or weaponList[1])
end)

-- Apply button removed as it is now automatic (Syncing is handled via the dropdowns)


WeaponSkinsTab:AddButton("Clear Weapon Cosmetics", function()
    local weapon  = scSelectedWeapon or weaponList[1]
    local wrapKey = scGetWrapType()
    scApply(weapon, "Skin",   "")
    scApply(weapon, "Charm",  "")
    scApply(weapon, wrapKey,  "")
    sc_equipped[weapon] = nil
    sc_updateEquippedSet()
    weaponCosmetics[weapon] = { Skin="None", Charm="None", Wrap="None" }
    sc_invalidateWeapon(weapon)
    scRefreshDropdowns(weapon)
    scSaveActiveConfig()
    Library:Notify("Cleared cosmetics for " .. weapon, 2)
end)

WeaponSkinsTab:AddDivider()

WeaponSkinsTab:AddButton("Global Unlock (Items & Inventory)", function()
    sc_unlockAllRequested = true
    sc_invDirty = true
    sc_queueReplication("CosmeticInventory")
    Library:Notify("Applied Global Unlock to Inventory System.", 3)
end)

-- Emote unlock handled in Global Unlock


WeaponSkinsTab:AddLabel("Skin Config Instructions")
WeaponSkinsTab:AddLabel("• Create a config using the config box.")
WeaponSkinsTab:AddLabel("• Equip skins/wraps/charms you want saved.")
WeaponSkinsTab:AddLabel("• Press Save Config after editing cosmetics.")
WeaponSkinsTab:AddLabel("• Loading a config auto-equips saved cosmetics.")
WeaponSkinsTab:AddLabel("• Delete or rename configs anytime.")

task.defer(function() scRefreshDropdowns(scSelectedWeapon) end)

-- Emotes tab removed as requested


local SCRightGroup = SkinTab:AddRightGroupbox("Skin Configs")
local scInputBuf = ""
SCRightGroup:AddInput("SC_ConfigNameInput", {
    Text        = "Config Name",
    Default     = "",
    Placeholder = "Enter config name...",
    Numeric     = false,
    Finished    = false,
    Callback    = function(v) scInputBuf = v end,
})
SCRightGroup:AddDivider()
SCRightGroup:AddButton("Create Config", function()
    local name = scInputBuf:match("^%s*(.-)%s*$")
    if name == "" then Library:Notify("Enter a config name first", 2) return end
    for _, existing in ipairs(scMeta.configs) do
        if existing == name then Library:Notify('"' .. name .. '" already exists', 2) return end
    end
    table.insert(scMeta.configs, name)
    scMeta.activeKey = name
    table.clear(sc_equipped)
    table.clear(weaponCosmetics)
    sc_updateEquippedSet()
    scSaveMeta()
    scSaveActiveConfig()
    if Options.SC_ConfigSelect then
        Options.SC_ConfigSelect:SetValues(scBuildConfigList())
        Options.SC_ConfigSelect:SetValue(name)
    end
    scRefreshDropdowns(scSelectedWeapon)
    Library:Notify('Created blank config "' .. name .. '"', 3)
end)
SCRightGroup:AddButton("Rename Config", function()
    local newName = scInputBuf:match("^%s*(.-)%s*$")
    if newName == "" then Library:Notify("Enter a new name first", 2) return end
    local oldName = scActiveConfigName()
    for _, existing in ipairs(scMeta.configs) do
        if existing == newName then Library:Notify('"' .. newName .. '" already exists', 2) return end
    end
    pcall(function()

        if isfile and isfile(scConfigFile(oldName)) and readfile and writefile then
            writefile(scConfigFile(newName), readfile(scConfigFile(oldName)))
            if delfile then delfile(scConfigFile(oldName)) end
        end
    end)
    for i, n in ipairs(scMeta.configs) do
        if n == oldName then scMeta.configs[i] = newName break end
    end
    if scMeta.defaultConfig == oldName then scMeta.defaultConfig = newName end
    scMeta.activeKey = newName
    scSaveMeta()
    if Options.SC_ConfigSelect then
        Options.SC_ConfigSelect:SetValues(scBuildConfigList())
        Options.SC_ConfigSelect:SetValue(newName)
    end
    Library:Notify('Renamed to "' .. newName .. '"', 3)
end)

SCRightGroup:AddButton("Delete Config", function()
    if #scMeta.configs <= 1 then Library:Notify("Cannot delete the last config", 2) return end
    local name = scActiveConfigName()
    pcall(function()
        if isfile and isfile(scConfigFile(name)) and delfile then
            delfile(scConfigFile(name))
        end
    end)
    for i, n in next, scMeta.configs do
        if n == name then table.remove(scMeta.configs, i) break end
    end
    if scMeta.defaultConfig == name then scMeta.defaultConfig = scMeta.configs[1] end
    scMeta.activeKey = scMeta.configs[1]
    scLoadConfig(scMeta.activeKey)
    scRefreshDropdowns(scSelectedWeapon)
    if Options.SC_EmoteSelect and scSelectedEmote then
        Options.SC_EmoteSelect:SetValue(scSelectedEmote)
    end
    scSaveMeta()
    if Options.SC_ConfigSelect then
        Options.SC_ConfigSelect:SetValues(scBuildConfigList())
        Options.SC_ConfigSelect:SetValue(scMeta.activeKey)
    end
    Library:Notify('Deleted "' .. name .. '"', 3)
end)

SCRightGroup:AddToggle("SC_Autoload", {
    Text    = "Autoload Profile on Launch",
    Default = scMeta.autoloadProfile,
    Callback = function(v)
        scMeta.autoloadProfile = v
        if v then
            scLoadConfig(scMeta.activeKey or scMeta.defaultConfig or scMeta.configs[1])
            scRefreshDropdowns(scSelectedWeapon)
        end
        scSaveMeta()
    end,
})

-- Auto Apply removed as requested (integrated into loader)


-- Button moved below


SCRightGroup:AddDivider()

SCRightGroup:AddDropdown("SC_ConfigSelect", {
    Values   = scBuildConfigList(),
    Default  = 1,
    Multi    = false,
    Text     = "Active Profile",
    Callback = function(v)
        scMeta.activeKey = v
        scLoadConfig(v)
        scRefreshDropdowns(scSelectedWeapon)
        if Options.SC_EmoteSelect and scSelectedEmote then
            Options.SC_EmoteSelect:SetValue(scSelectedEmote)
        end
        scSaveMeta()
        Library:Notify('Switched to Profile: "' .. v .. '"', 2)
    end,
})

local scAutoloadLabel = SCRightGroup:AddLabel("Current autoload cfg: " .. (scMeta.defaultConfig or "None"))


SCRightGroup:AddButton("Save Config", function()
    scEnsureFolder()
    pcall(function()
        local data = {
            weaponCosmetics = weaponCosmetics,
            emote           = scSelectedEmote,
            lastWeapon      = scSelectedWeapon,
        }
        writefile(scConfigFile(scActiveConfigName()), HttpService2:JSONEncode(data))
    end)
    Library:Notify('Saved "' .. scActiveConfigName() .. '"', 3)
end)

SCRightGroup:AddButton("Load Config", function()
    scLoadConfig(scActiveConfigName())
    scRefreshDropdowns(scSelectedWeapon)
    if Options.SC_EmoteSelect and scSelectedEmote then
        Options.SC_EmoteSelect:SetValue(scSelectedEmote)
    end
    Library:Notify('Loaded "' .. scActiveConfigName() .. '"', 3)
end)

SCRightGroup:AddButton("Clear Config", function()
    weaponCosmetics = {}
    scSelectedEmote = "None"
    scRefreshDropdowns(scSelectedWeapon)
    if Options.SC_EmoteSelect then Options.SC_EmoteSelect:SetValue("None") end
    pcall(function()
        if isfile and isfile(scConfigFile(scActiveConfigName())) and delfile then
            delfile(scConfigFile(scActiveConfigName()))
        end
    end)
    Library:Notify('Cleared "' .. scActiveConfigName() .. '"', 2)
end)

SCRightGroup:AddButton("Set as Default", function()
    scMeta.defaultConfig = scMeta.activeKey
    scSaveMeta()
    if scAutoloadLabel then
        scAutoloadLabel:SetText("Current autoload cfg: " .. (scMeta.defaultConfig or "None"))
    end
    Library:Notify('"' .. scMeta.activeKey .. '" set as default profile', 3)
end)

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible, 
    Text = "Open Keybind Menu", 
    Callback = function(v) 
        Library.KeybindFrame.Visible = v 
    end
})
MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor", 
    Default = false, 
    Callback = function(v) 
        Library.ShowCustomCursor = v 
    end
})
MenuGroup:AddToggle("HideLogo", {
    Text = "Hide Logo", 
    Default = false, 
    Callback = function(v)
        Library.HideImages = v
        if Library.BackgroundImage then 
            Library.BackgroundImage.Visible = not v 
        end
    end
})

local BlurTgl = MenuGroup:AddToggle("UIBlur", {
    Text = "Blur", 
    Default = false, 
    Callback = function(v)
        Library.UIBlur = v
        if Library.UpdateBlur then 
            Library:UpdateBlur() 
        end
    end
})

local BlurDep = MenuGroup:AddDependencyBox()
BlurDep:SetupDependencies({{BlurTgl, true}})
BlurDep:AddSlider("UIBlurIntensity", {
    Text = "Blur Intensity", 
    Default = 15, 
    Min = 0, 
    Max = 50, 
    Rounding = 0, 
    Callback = function(v)
        Library.UIBlurIntensity = v
        if Library.UpdateBlur then 
            Library:UpdateBlur() 
        end
    end
})

MenuGroup:AddDropdown("NotificationPosition", {
    Values = {"Left", "Right", "Bottom"}, 
    Default = "Bottom", 
    Multi = false, 
    Text = "Notification Position", 
    Callback = function(v) 
        Library.NotifySide = v 
        Library:Notify("notification test", 3)
    end
})

MenuGroup:AddDropdown("LibraryFont", {
    Values = {
        "Legacy", "Arial", "ArialBold", "SourceSans", "SourceSansBold", "SourceSansSemibold", 
        "SourceSansLight", "SourceSansItalic", "Bodoni", "Garamond", "Cartoon", "Code", 
        "Highway", "SciFi", "Arcade", "Fantasy", "Antique", "Gotham", "GothamBold", 
        "GothamSemibold", "GothamMedium", "GothamBlack", "AmaticSC", "Bangers", "Creepster", 
        "DenkOne", "Fondamento", "FredokaOne", "GrenzeGotisch", "IndieFlower", "JosefinSans", 
        "Jura", "Kalam", "LuckiestGuy", "Merriweather", "Michroma", "Nunito", "Oswald", 
        "PatrickHand", "PermanentMarker", "PressStart2P", "Roboto", "RobotoCondensed", 
        "RobotoMono", "Sarpanch", "SpecialElite", "TitilliumWeb", "Ubuntu"
    },
    Default = "FredokaOne",
    Multi = false,
    Text = "Library Font",
    Callback = function(v)
        local ok, font = pcall(function() return Enum.Font[v] end)
        if ok and font then
            Library:SetFont(font)
        end
    end
})

MenuGroup:AddSlider("UIGlowAmount", {
    Text = "UI Glow Intensity",
    Default = 1,
    Min = 0,
    Max = 4,
    Rounding = 2,
    Callback = function(v)
        if Library.SetGlowAmount then
            Library:SetGlowAmount(v)
        end
    end
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { 
    Default = "RightShift", 
    NoUI = true, 
    Text = "Menu keybind" 
})
MenuGroup:AddButton("Unload", function() 
    Library:Unload() 
end)

local SG = Tabs['UI Settings']:AddRightGroupbox("Server")
SG:AddButton("Rejoin Server", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
end)
SG:AddButton("Server Hop", function()
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        local data = game:GetService("HttpService"):JSONDecode(game:HttpGet(url))
        if data and data.data then
            for _, s in ipairs(data.data) do
                if s.id ~= game.JobId and s.playing >= 12 and s.playing < s.maxPlayers then 
                    return s.id 
                end
            end
        end
    end)
    if success and result then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, result, LP)
    else
        game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
    end
end)

Window:SetWindowTitle("                     $$ roxy.win rivals $$                  ")


Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
ThemeManager:SetFolder('RoxyRivals')
SaveManager:SetFolder('RoxyRivals/TheWildWest')
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

Library:OnUnload(function()
    Library.Unloaded = true
    
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end

    for model in next, cache do
        removeESP(model)
    end
    table.clear(cache)
end)

task.spawn(function()
    local clientItemModule
    pcall(function()
        clientItemModule = require(LP.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
    end)
    
    if clientItemModule and clientItemModule.Input then
        local oldInput
        oldInput = hookfunction(clientItemModule.Input, function(...)
            local args = {...}
            if type(args[1]) == "table" and args[1].Info then
                local info = args[1].Info
                pcall(function()
                    if L.Mod_InfAmmo then
                        info.MaxAmmo = 999
                        info.MaxAmmoReserve = 9999
                        info.Ammo = 999
                    end
                    if L.Mod_NoRecoil then
                        local recoilMult = (L.Val_NoRecoil or 0) / 100
                        if type(info.ShootRecoil) == "table" then
                            for k, _ in next, info.ShootRecoil do info.ShootRecoil[k] = info.ShootRecoil[k] * recoilMult end
                        elseif type(info.ShootRecoil) == "number" then
                            info.ShootRecoil = info.ShootRecoil * recoilMult
                        end
                    end
                    if L.Mod_NoSpread then
                        local spreadMult = (L.Val_NoSpread or 0) / 100
                        if type(info.ShootSpread) == "table" then
                            for k, _ in next, info.ShootSpread do info.ShootSpread[k] = info.ShootSpread[k] * spreadMult end
                        elseif type(info.ShootSpread) == "number" then
                            info.ShootSpread = info.ShootSpread * spreadMult
                        end
                    end
                    if L.Mod_FullAuto then
                        info.Auto = true
                        info.AutoFire = true
                        info.IsAuto = true
                        info.FireMode = "Auto"
                    end
                    if L.Mod_FastFire then
                        info.ShootCooldown = 0.05
                    end
                    if L.Mod_InfBullet then
                        info.ProjectileSpeed = 99999
                    end
                end)
            end
            return oldInput(...)
        end)
    end
end)

return { 
    Library = Library, 
    ThemeManager = ThemeManager, 
    SaveManager = SaveManager, 
    Options = Options, 
    Toggles = Toggles, 
    Window = Window, 
    Tabs = Tabs 
}
