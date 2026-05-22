

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
    Misc = Window:AddTab("Misc"),
    ["UI Settings"] = Window:AddTab("Configs") 
}

local S = setmetatable({}, {__index = function(t, k) local s = game:GetService(k); t[k] = s; return s end})
local LP = S.Players.LocalPlayer or S.Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or S.Players.LocalPlayer
local ReplicatedStorage = S.ReplicatedStorage
local G = {}

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
    FCase = "Normal",
    CustomHitSound = false,
    HitSoundVolume = 1,
    HitSoundAsset = "rbxassetid://4581728529",
    LitMaster = false,
    LitAmbientOverride = false,
    LitClock = 14,
    LitBrightness = 2,
    LitAmbient = Color3.fromRGB(128, 128, 128),
    LitOutdoorAmbient = Color3.fromRGB(128, 128, 128),
    LitGlobalShadows = true,
    LitBloom = false,
    LitBloomTint = Color3.fromRGB(255, 255, 255),
    LitBloomIntensity = 1,
    LitBloomSize = 24,
    LitBloomThreshold = 0.95,
    LitBloomPreset = "Default",
    LitColorCorrection = false,
    LitCCBrightness = 0,
    LitCCContrast = 0,
    LitCCSaturation = 0,
    LitCCTint = Color3.fromRGB(255, 255, 255),
    LitAtmosphere = false,
    LitFogDensity = 0,
    LitFogOffset = 0,
    LitFogColor = Color3.fromRGB(192, 192, 192),
    LitSunRays = false,
    LitSunIntensity = 0.15,
    LitSunSpread = 0.5,
    LitBlur = false,
    LitBlurSize = 0,
    LitClockSet = false,
    LitBrightnessSet = false,
    LitGlobalShadowsSet = false,
    TextGradient = false,
    TextGradColor1 = Color3.fromRGB(211, 227, 255),
    TextGradColor2 = Color3.fromRGB(255, 255, 255),
    TextGradRot = false,
    TextGradSpeed = 1,
    BoxType = "Full",
    BoxGrad = false,
    BoxGrad1 = Color3.fromRGB(211, 227, 255),
    BoxGrad2 = Color3.fromRGB(255, 255, 255),
    BoxGradRot = false,
    BoxGradSpeed = 1,
    Tracers = false,
    TracerGrad1 = Color3.fromRGB(255, 190, 110),
    TracerGrad2 = Color3.fromRGB(255, 255, 255),
    TracerDuration = 0.65,
    TracerSize = 0.12,
    TracerStyle = "None"
}

local FM = { ['UI'] = 0, ['System'] = 1, ['Plex'] = 2, ['Monospace'] = 3 }

do
local P, RS, TS, WS, UIS = S.Players, S.RunService, S.TweenService, workspace, S.UserInputService
local C = workspace.CurrentCamera
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
    for i = 1, 160 do
        local sq = Drawing.new("Square")
        sq.Filled = true
        sq.Thickness = 1
        sq.Visible = false
        esp.healthLines[i] = sq
    end
    esp.boxCornerFill, esp.boxCornerOut = {}, {}
    for i = 1, 8 do
        local out = Drawing.new("Line")
        out.Thickness = 3
        out.Color = Color3.fromRGB(0, 0, 0)
        out.Visible = false
        esp.boxCornerOut[i] = out
        local fill = Drawing.new("Line")
        fill.Thickness = 1
        fill.Visible = false
        esp.boxCornerFill[i] = fill
    end
    esp.boxPerim = {}
    for i = 1, 40 do
        local ln = Drawing.new("Line")
        ln.Thickness = 1
        ln.Visible = false
        esp.boxPerim[i] = ln
    end
    esp.hum = model:FindFirstChildOfClass("Humanoid")
    esp.hrp = model:FindFirstChild("HumanoidRootPart")
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
            for i = 1, #esp.healthLines do
                local line = esp.healthLines[i]
                if line then pcall(function() line:Remove() end) end
            end
            table.clear(esp.healthLines)
        end
        for _, key in ipairs({ "gradName", "gradWeapon", "gradDist", "gradHealth" }) do
            local pool = esp[key]
            if pool then
                for i = 1, #pool do
                    if pool[i] then pcall(function() pool[i]:Remove() end) end
                end
            end
        end
        if esp.skeletonLines then
            for _, line in ipairs(esp.skeletonLines) do
                if line.outline then pcall(function() line.outline:Remove() end) end
                if line.fill then pcall(function() line.fill:Remove() end) end
            end
            table.clear(esp.skeletonLines)
        end
        for _, key in ipairs({ "boxCornerFill", "boxCornerOut", "boxPerim" }) do
            local arr = esp[key]
            if arr then
                for i = 1, #arr do
                    if arr[i] then pcall(function() arr[i]:Remove() end) end
                end
            end
        end
        if esp.chamHighlight then
            pcall(function() esp.chamHighlight:Destroy() end)
            esp.chamHighlight = nil
        end
        cache[model] = nil
    end
end

local GRAD_SEG_MAX = 32
local GRAD_CHAR_W = 0.52
local BOX_PERIM_SEGS = 40
G.textGradPhase = 0
G.boxGradPhase = 0

local function hideGradPool(pool)
    if not pool then return end
    for i = 1, #pool do
        local seg = pool[i]
        if seg then seg.Visible = false end
    end
end

local function hideBoxDraw(esp)
    if esp.boxOutline then esp.boxOutline.Visible = false end
    if esp.box then esp.box.Visible = false end
    if esp.boxFill then esp.boxFill.Visible = false end
    if esp.boxCornerFill then
        for i = 1, 8 do
            local ln = esp.boxCornerFill[i]
            if ln then ln.Visible = false end
        end
    end
    if esp.boxCornerOut then
        for i = 1, 8 do
            local ln = esp.boxCornerOut[i]
            if ln then ln.Visible = false end
        end
    end
    if esp.boxPerim then
        for i = 1, #esp.boxPerim do
            local ln = esp.boxPerim[i]
            if ln then ln.Visible = false end
        end
    end
end

local function perimeterPoint(t, x, y, w, h)
    local perim = 2 * (w + h)
    local d = t * perim
    if d <= w then
        return x + d, y
    end
    d = d - w
    if d <= h then
        return x + w, y + d
    end
    d = d - h
    if d <= w then
        return x + w - d, y + h
    end
    d = d - w
    return x, y + h - d
end

local function boxGradTAt(px, py, bx, by, bw, bh, rotOff)
    if rotOff and rotOff ~= 0 then
        local cx, cy = bx + bw * 0.5, by + bh * 0.5
        local ang = math.atan2(py - cy, px - cx) / (2 * math.pi)
        return (ang + 0.25 + rotOff) % 1
    end
    return math.clamp((px - bx) / math.max(bw, 1), 0, 1)
end

local function drawCornerBracket(esp, x, y, w, h, cl, opacity, solidColor, useGrad, c1, c2, rotOff, bx, by, bw, bh)
    local fills, outs = esp.boxCornerFill, esp.boxCornerOut
    if not fills or not outs then return end
    local segs = {
        {x, y, x + cl, y},
        {x, y, x, y + cl},
        {x + w - cl, y, x + w, y},
        {x + w, y, x + w, y + cl},
        {x + w - cl, y + h, x + w, y + h},
        {x + w, y + h - cl, x + w, y + h},
        {x, y + h, x + cl, y + h},
        {x, y + h - cl, x, y + h},
    }
    for i = 1, 8 do
        local s = segs[i]
        local fx, fy, tx, ty = s[1], s[2], s[3], s[4]
        local mx, my = (fx + tx) * 0.5, (fy + ty) * 0.5
        local col = useGrad and c1:Lerp(c2, boxGradTAt(mx, my, bx, by, bw, bh, rotOff)) or solidColor
        local from, to = Vector2.new(fx, fy), Vector2.new(tx, ty)
        local outLn, fillLn = outs[i], fills[i]
        if outLn then
            outLn.From, outLn.To = from, to
            outLn.Thickness = 2
            outLn.Color = Color3.fromRGB(0, 0, 0)
            outLn.Transparency = opacity
            outLn.Visible = true
        end
        if fillLn then
            fillLn.From, fillLn.To = from, to
            fillLn.Color = col
            fillLn.Thickness = 1
            fillLn.Transparency = opacity
            fillLn.Visible = true
        end
    end
end

local function drawPerimeterGrad(esp, x, y, w, h, opacity, c1, c2, rotOff, bx, by, bw, bh)
    local lines = esp.boxPerim
    if not lines then return end
    local n = BOX_PERIM_SEGS
    for i = 1, n do
        local t0 = (i - 1) / n
        local t1 = i / n
        local p0x, p0y = perimeterPoint(t0, x, y, w, h)
        local p1x, p1y = perimeterPoint(t1, x, y, w, h)
        local tMid = (t0 + t1) * 0.5
        local mx, my = perimeterPoint(tMid, x, y, w, h)
        local col = c1:Lerp(c2, boxGradTAt(mx, my, bx, by, bw, bh, rotOff))
        local ln = lines[i]
        if ln then
            ln.From = Vector2.new(p0x, p0y)
            ln.To = Vector2.new(p1x, p1y)
            ln.Color = col
            ln.Thickness = 1
            ln.Transparency = opacity
            ln.Visible = true
        end
    end
    for i = n + 1, #lines do
        if lines[i] then lines[i].Visible = false end
    end
end

local function drawPlayerBox(esp, box, opacity, solidColor, gradPhase)
    hideBoxDraw(esp)
    local x, y, w, h = box.x, box.y, box.w, box.h
    local corners = L.BoxType == "Corners"
    local useGrad = L.BoxGrad
    local rotOff = L.BoxGradRot and gradPhase or 0
    local c1, c2 = L.BoxGrad1, L.BoxGrad2

    if not useGrad and not corners then
        esp.boxOutline.Size = Vector2.new(w, h)
        esp.boxOutline.Position = Vector2.new(x, y)
        esp.boxOutline.Transparency = opacity
        esp.boxOutline.Visible = true
        esp.box.Size = Vector2.new(w, h)
        esp.box.Position = Vector2.new(x, y)
        esp.box.Color = solidColor
        esp.box.Transparency = opacity
        esp.box.Visible = true
        return
    end

    if esp.box then esp.box.Visible = false end

    if corners then
        if esp.boxPerim then
            for i = 1, #esp.boxPerim do
                local ln = esp.boxPerim[i]
                if ln then ln.Visible = false end
            end
        end
        if esp.boxOutline then esp.boxOutline.Visible = false end
        drawCornerBracket(esp, x, y, w, h, math.max(3, math.floor(math.min(w, h) * 0.22)), opacity, solidColor, useGrad, c1, c2, rotOff, x, y, w, h)
    elseif useGrad then
        if esp.boxCornerFill then
            for i = 1, 8 do
                if esp.boxCornerFill[i] then esp.boxCornerFill[i].Visible = false end
                if esp.boxCornerOut[i] then esp.boxCornerOut[i].Visible = false end
            end
        end
        local inset = 1
        esp.boxOutline.Size = Vector2.new(w, h)
        esp.boxOutline.Position = Vector2.new(x, y)
        esp.boxOutline.Transparency = opacity
        esp.boxOutline.Visible = true
        drawPerimeterGrad(esp, x + inset, y + inset, w - inset * 2, h - inset * 2, opacity, c1, c2, rotOff, x, y, w, h)
    else
        if esp.boxPerim then
            for i = 1, #esp.boxPerim do
                local ln = esp.boxPerim[i]
                if ln then ln.Visible = false end
            end
        end
        esp.boxOutline.Size = Vector2.new(w, h)
        esp.boxOutline.Position = Vector2.new(x, y)
        esp.boxOutline.Transparency = opacity
        esp.boxOutline.Visible = true
        esp.box.Size = Vector2.new(w, h)
        esp.box.Position = Vector2.new(x, y)
        esp.box.Color = solidColor
        esp.box.Transparency = opacity
        esp.box.Visible = true
    end
end

local function drawEspLabel(mainDraw, pool, text, x, y, size, font, opacity, fallbackColor, centered, gradPhase)
    if not L.TextGradient then
        hideGradPool(pool)
        mainDraw.Text = text
        mainDraw.Size = size
        mainDraw.Font = font
        mainDraw.Color = fallbackColor
        mainDraw.Transparency = opacity
        mainDraw.Position = Vector2.new(x, y)
        mainDraw.Center = centered ~= false
        mainDraw.Visible = true
        return pool
    end
    mainDraw.Visible = false
    local len = #text
    if len < 1 then
        hideGradPool(pool)
        return pool
    end
    pool = pool or {}
    local segs = math.min(len, GRAD_SEG_MAX)
    if segs < 2 then segs = math.min(len, 2) end
    local c1, c2 = L.TextGradColor1, L.TextGradColor2
    local rotOff = L.TextGradRot and gradPhase or 0
    local totalW = size * GRAD_CHAR_W * len
    local x0 = centered ~= false and (x - totalW * 0.5) or x
    local step = totalW / segs
    for i = 1, segs do
        local seg = pool[i]
        if not seg then
            seg = Drawing.new("Text")
            seg.Outline = true
            seg.Center = false
            pool[i] = seg
        end
        local i0 = math.floor((i - 1) * len / segs) + 1
        local i1 = math.min(len, math.ceil(i * len / segs))
        local chunk = text:sub(i0, i1)
        if chunk ~= "" then
            local charMid = (i0 + i1) * 0.5
            local t = ((charMid - 0.5) / len + rotOff) % 1
            seg.Text = chunk
            seg.Size = size
            seg.Font = font
            seg.Color = c1:Lerp(c2, t)
            seg.Transparency = opacity
            seg.Position = Vector2.new(x0 + (i - 1) * step, y)
            seg.Visible = true
        else
            seg.Visible = false
        end
    end
    for i = segs + 1, #pool do
        local seg = pool[i]
        if seg then seg.Visible = false end
    end
    return pool
end

local function hideESP(esp)
    hideBoxDraw(esp)
    if esp.nameText then esp.nameText.Visible = false end
    if esp.distanceText then esp.distanceText.Visible = false end
    if esp.weaponText then esp.weaponText.Visible = false end
    if esp.healthOutlineBg then esp.healthOutlineBg.Visible = false end
    if esp.healthOutline then esp.healthOutline.Visible = false end
    if esp.healthText then esp.healthText.Visible = false end
    if esp.healthLines then
        for i = 1, #esp.healthLines do
            local line = esp.healthLines[i]
            if line then line.Visible = false end
        end
    end
    if esp.skeletonLines then
        for i = 1, #esp.skeletonLines do
            local line = esp.skeletonLines[i]
            if line then
                if line.outline then line.outline.Visible = false end
                if line.fill then line.fill.Visible = false end
            end
        end
    end
    if esp.chamHighlight then
        esp.chamHighlight.Enabled = false
    end
    hideGradPool(esp.gradName)
    hideGradPool(esp.gradWeapon)
    hideGradPool(esp.gradDist)
    hideGradPool(esp.gradHealth)
end

local cachedActiveTargets, sreCache, sreTick = {}, nil, 0
local playerScanTick, masterWasOn = 0, true

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

local function onRender(dt)
    local now = os.clock()
    dt = math.clamp(dt, 0, 0.05)
    if L.TextGradRot then
        G.textGradPhase = (G.textGradPhase + dt * (L.TextGradSpeed or 1) * 0.12) % 1
    else
        G.textGradPhase = 0
    end
    if L.BoxGradRot then
        G.boxGradPhase = (G.boxGradPhase + dt * (L.BoxGradSpeed or 1) * 0.12) % 1
    else
        G.boxGradPhase = 0
    end
    local centerScreen = UIS:GetMouseLocation()
    currentFOVSize = currentFOVSize + ((L.FOVSize - currentFOVSize) * (dt * 10))
    local needDraw = L.BE or L.BFE or L.NE or L.DE or L.WE or L.HE or L.Skel or L.Chams
    local needAim = L.Aimbot or L.Snapline or L.HighlightTarget

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
        if masterWasOn then
            masterWasOn = false
            for _, esp in next, cache do
                hideESP(esp)
            end
        end
        AimbotSnapline.Visible = false
        AimbotSnaplineOutline.Visible = false
        return
    end
    masterWasOn = true
    if now - sreTick > 0.5 then
        sreTick = now
        sreCache = WS:FindFirstChild("ShootingRangeEntities")
    end
    if now - playerScanTick > 0.15 then
        playerScanTick = now
        local active = {}
        for _, p in next, P:GetPlayers() do
            if p ~= LP then
                local char = p.Character
                if char and char:IsA("Model") then
                    active[char] = true
                end
            end
        end
        if sreCache then
            for _, child in next, sreCache:GetChildren() do
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

    if needAim and L.Aimbot then
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

    if needDraw then
    for model in next, targets do
        local esp = cache[model]
        if esp then
            if L.HighlightTarget then
                if model == CurrentAimbotTarget then
                    esp.highlightLerp = math.min(1, esp.highlightLerp + (dt * 5))
                else
                    esp.highlightLerp = math.max(0, esp.highlightLerp - (dt * 5))
                end
            elseif esp.highlightLerp > 0 then
                esp.highlightLerp = 0
            end
            local hl = esp.highlightLerp
            local function lc(c) return hl > 0 and c:Lerp(L.HighlightColor, hl) or c end
            local currentBC, currentBFC = lc(L.BC), lc(L.BFC)
            local currentNTC, currentWTC, currentDTC = lc(L.NTC), lc(L.WTC), lc(L.DTC)
            local currentHHC, currentHLC, currentHTC = lc(L.HHC), lc(L.HLC), lc(L.HTC)
            local currentSkelColor = lc(L.SkelColor)
            local currentChamsColor, currentChamsOutlineColor = lc(L.ChamsColor), lc(L.ChamsOutlineColor)
            local humanoid = esp.hum
            local hrp = esp.hrp
            if not humanoid or humanoid.Parent ~= model then
                humanoid = model:FindFirstChildOfClass("Humanoid")
                esp.hum = humanoid
            end
            if not hrp or hrp.Parent ~= model then
                hrp = model:FindFirstChild("HumanoidRootPart")
                esp.hrp = hrp
            end
            if not humanoid or not hrp then
                hideESP(esp)
            else
            local distance = (camPos - hrp.Position).Magnitude
            local box = getBoundingBox(model)
            local skip = distance > L.DMax
            if not skip and L.TeamCheck then
                if esp.teamSkipTick and (now - esp.teamSkipTick) < 0.25 then
                    skip = esp.teamSkipCached == true
                else
                    local teamSkip = false
                    local label = hrp:FindFirstChild("TeammateLabel")
                    if label then
                        local pFrame = label:FindFirstChild("Player")
                        if pFrame and pFrame.Visible and pFrame.Active then teamSkip = true end
                    end
                    esp.teamSkipCached = teamSkip
                    esp.teamSkipTick = now
                    skip = teamSkip
                end
            end
            if not skip and not box then skip = true end
            if not skip and L.VisCheck then
                local targetPart = model:FindFirstChild("Head") or hrp
                if targetPart then
                    GlobalRaycastParams.FilterDescendantsInstances = {LP.Character, model}
                    if WS:Raycast(camPos, targetPart.Position - camPos, GlobalRaycastParams) then skip = true end
                end
            end
            if skip then
                hideESP(esp)
            else
            if L.BE then
                drawPlayerBox(esp, box, esp.opacity, currentBC, G.boxGradPhase)

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
                hideBoxDraw(esp)
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

                local nameY = box.y - currentFontSize - 2
                esp.gradName = drawEspLabel(esp.nameText, esp.gradName, rawName, box.x + box.w * 0.5, nameY, currentFontSize, currentFont, esp.opacity, currentNTC, true, G.textGradPhase)
            else
                esp.nameText.Visible = false
                hideGradPool(esp.gradName)
            end

            local bottomOffset = 2
            if L.WE then
                local weaponName = getHeldWeapon(model)
                if L.FCase == "Uppercase" then
                    weaponName = weaponName:upper()
                elseif L.FCase == "Lowercase" then
                    weaponName = weaponName:lower()
                end

                local weaponY = box.y + box.h + bottomOffset
                esp.gradWeapon = drawEspLabel(esp.weaponText, esp.gradWeapon, weaponName, box.x + box.w * 0.5, weaponY, currentFontSize, currentFont, esp.opacity, currentWTC, true, G.textGradPhase)
                bottomOffset = bottomOffset + currentFontSize + 2
            else
                esp.weaponText.Visible = false
                hideGradPool(esp.gradWeapon)
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

                local distY = box.y + box.h + bottomOffset
                esp.gradDist = drawEspLabel(esp.distanceText, esp.gradDist, distStr, box.x + box.w * 0.5, distY, currentFontSize, currentFont, esp.opacity, currentDTC, true, G.textGradPhase)
            else
                esp.distanceText.Visible = false
                hideGradPool(esp.gradDist)
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

                local lineMax = #esp.healthLines
                local needed = math.min(math.max(1, filledH), lineMax)
                local animTime = L.HGradAnim and (now * (L.HGradAnimSpeed or 1)) or 0
                for i = 1, needed do
                    local sq = esp.healthLines[i]
                    if sq then
                        sq.Size = Vector2.new(barW, 1)
                        sq.Position = Vector2.new(barX, filledY + (needed - i))
                        sq.Transparency = esp.opacity
                        if L.HGrad then
                            local t = i / needed
                            if L.HGradAnim then
                                local style = L.HGradAnimStyle
                                if style == "Orbit" then t = (t + animTime * 0.12) % 1
                                elseif style == "Helix" then t = (t + math.sin((t * 4) - (animTime * 2)) * 0.18) % 1
                                elseif style == "Stream" then t = (t + animTime * 0.22) % 1; t = t * t * (3 - 2 * t)
                                elseif style == "Flux" then t = t + math.sin((t * 8) + animTime) * 0.08
                                elseif style == "Nova" then t = t + math.cos((t * 5) - animTime * 1.4) * 0.12
                                elseif style == "Drift" then t = (t + animTime * 0.08 + math.sin(t * 10 + animTime) * 0.04) % 1
                                end
                            end
                            sq.Color = currentHLC:Lerp(currentHHC, math.clamp(t, 0, 1))
                        else
                            sq.Color = currentHHC:Lerp(currentHLC, 1 - esp.healthLerp)
                        end
                        sq.Visible = true
                    end
                end
                for i = needed + 1, lineMax do
                    local sq = esp.healthLines[i]
                    if sq then sq.Visible = false end
                end


                if L.HTE and healthPercentage < 0.99 then
                    local hpText = tostring(math.floor(healthPercentage * 100))
                    esp.gradHealth = drawEspLabel(esp.healthText, esp.gradHealth, hpText, barX - 15, filledY - 2, currentFontSize - 2, currentFont, esp.opacity, currentHTC, false, G.textGradPhase)
                else
                    esp.healthText.Visible = false
                    hideGradPool(esp.gradHealth)
                end
            else
                esp.healthOutlineBg.Visible = false
                esp.healthOutline.Visible = false
                for i = 1, #esp.healthLines do
                    local sq = esp.healthLines[i]
                    if sq then sq.Visible = false end
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
        end
    end
    end
end
local renderConnection = RS.RenderStepped:Connect(onRender)
G.cache, G.renderConnection, G.removeESP = cache, renderConnection, removeESP
end

do
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

local HitSoundMap = {
    ["Minecraft experience"] = "rbxassetid://7151570575",
    Neverlose = "rbxassetid://8726881116",
    Gamesense = "rbxassetid://4817809188",
    One = "rbxassetid://7380502345",
    Bell = "rbxassetid://6534947240",
    Rust = "rbxassetid://1255040462",
    TF2 = "rbxassetid://2868331684",
    Slime = "rbxassetid://6916371803",
    ["Among Us"] = "rbxassetid://5700183626",
    Minecraft = "rbxassetid://4018616850",
    ["CS:GO"] = "rbxassetid://6937353691",
    Saber = "rbxassetid://8415678813",
    Baimware = "rbxassetid://3124331820",
    Osu = "rbxassetid://7149255551",
    ["TF2 Critical"] = "rbxassetid://296102734",
    Bat = "rbxassetid://3333907347",
    ["Call of Duty"] = "rbxassetid://5952120301",
    Bubble = "rbxassetid://6534947588",
    Pick = "rbxassetid://1347140027",
    Pop = "rbxassetid://198598793",
    Bruh = "rbxassetid://4275842574",
    ["[Bamboo]"] = "rbxassetid://3769434519",
    Crowbar = "rbxassetid://546410481",
    Weeb = "rbxassetid://6442965016",
    Beep = "rbxassetid://8177256015",
    Bambi = "rbxassetid://8437203821",
    Stone = "rbxassetid://3581383408",
    ["Old Fatality"] = "rbxassetid://6607142036",
    Click = "rbxassetid://8053704437",
    Ding = "rbxassetid://7149516994",
    Snow = "rbxassetid://6455527632",
    Laser = "rbxassetid://7837461331",
    Mario = "rbxassetid://2815207981",
    Steve = "rbxassetid://4965083997",
    Snowdrake = "rbxassetid://7834724809",
    Default = "rbxassetid://4581728529"
}

local HitSoundNames = {}
for name in next, HitSoundMap do
    HitSoundNames[#HitSoundNames + 1] = name
end
table.sort(HitSoundNames, function(a, b)
    return string.lower(a) < string.lower(b)
end)

local HitSoundDefaultIndex = 1
for i, name in ipairs(HitSoundNames) do
    if name == "Default" then
        HitSoundDefaultIndex = i
        break
    end
end

local MiscTabbox = Tabs.Misc:AddLeftTabbox()
local SoundfxTab = MiscTabbox:AddTab("Soundfx")
local KillfxTab = MiscTabbox:AddTab("Killfx")

SoundfxTab:AddToggle("CustomHitSound", {
    Text = "Custom Hit Sound",
    Default = false,
    Callback = function(v)
        L.CustomHitSound = v
    end
})

SoundfxTab:AddSlider("HitSoundVolume", {
    Text = "Sound Volume",
    Default = 1,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        L.HitSoundVolume = v
    end
})

SoundfxTab:AddDropdown("HitSoundOption", {
    Values = HitSoundNames,
    Default = HitSoundDefaultIndex,
    Multi = false,
    Text = "Sound Option",
    Callback = function(v)
        L.HitSoundAsset = HitSoundMap[v] or L.HitSoundAsset
    end
})
end

do
local PlayerESPTabbox = Tabs.Visuals:AddLeftTabbox()
local PlayerESPGroup = PlayerESPTabbox:AddTab("Player ESP")

local ME = PlayerESPGroup:AddToggle('MasterESP', {
    Text = 'Enable ESP', 
    Default = false, 
    Callback = function(v) 
        L.Master = v 
    end
})

local D_Box = PlayerESPGroup:AddDependencyBox()
D_Box:SetupDependencies({{ME, true}})

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

local D_BoxOpts = D_Box:AddDependencyBox()
D_BoxOpts:SetupDependencies({{BV, true}})

D_BoxOpts:AddDropdown("BoxTypeDropdown", {
    Values = {"Full", "Corners"},
    Default = 1,
    Multi = false,
    Text = "Type",
    Callback = function(v)
        L.BoxType = v
    end
})

local BGV = D_BoxOpts:AddToggle("BoxGradient", {
    Text = "Box Gradient",
    Default = false,
    Tooltip = "50% color 1 on the left, 50% color 2 on the right, blended in the middle.",
    Callback = function(v)
        L.BoxGrad = v
    end
})
BGV:AddColorPicker("BoxGradColor1", {
    Default = L.BoxGrad1,
    Title = "Box Gradient Color 1",
    Callback = function(v)
        L.BoxGrad1 = v
    end
})
BGV:AddColorPicker("BoxGradColor2", {
    Default = L.BoxGrad2,
    Title = "Box Gradient Color 2",
    Callback = function(v)
        L.BoxGrad2 = v
    end
})

local BGRV = D_BoxOpts:AddToggle("BoxGradRotation", {
    Text = "Gradient Rotation",
    Default = false,
    Callback = function(v)
        L.BoxGradRot = v
    end
})

local D_BoxGradSpeed = D_BoxOpts:AddDependencyBox()
D_BoxGradSpeed:SetupDependencies({{BGRV, true}})

D_BoxGradSpeed:AddSlider("BoxGradRotSpeed", {
    Text = "Rotation Speed",
    Default = 1,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        L.BoxGradSpeed = v
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

local TGV = D_Misc:AddToggle("TextGradient", {
    Text = "Text Gradient",
    Default = false,
    Tooltip = "Left half uses color 1, right half uses color 2, blended in the middle.",
    Callback = function(v)
        L.TextGradient = v
    end
})
TGV:AddColorPicker("TextGradColor1", {
    Default = L.TextGradColor1,
    Title = "Gradient Color 1",
    Callback = function(v)
        L.TextGradColor1 = v
    end
})
TGV:AddColorPicker("TextGradColor2", {
    Default = L.TextGradColor2,
    Title = "Gradient Color 2",
    Callback = function(v)
        L.TextGradColor2 = v
    end
})

local D_TextGradRot = D_Misc:AddDependencyBox()
D_TextGradRot:SetupDependencies({{TGV, true}})

local TGRV = D_TextGradRot:AddToggle("TextGradRotation", {
    Text = "Gradient Rotation",
    Default = false,
    Callback = function(v)
        L.TextGradRot = v
    end
})

local D_TextGradSpeed = D_TextGradRot:AddDependencyBox()
D_TextGradSpeed:SetupDependencies({{TGRV, true}})

D_TextGradSpeed:AddSlider("TextGradRotSpeed", {
    Text = "Rotation Speed",
    Default = 1,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        L.TextGradSpeed = v
    end
})

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

end

do
local Lighting = game:GetService("Lighting")
local LitBloomPresets = {
    Subtle = 0.98,
    Default = 0.95,
    Intense = 0.75,
    All = 0
}

local litFx = {}
local litApplying, litQueued = false, false
local litConns = {}
local litSnapshot = nil
local litForeignSnap = {}

local function litDisconnectAll()
    for _, conn in litConns do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(litConns)
end

local function litGetFx(className, name)
    local inst = litFx[name]
    if inst and inst.Parent == Lighting and inst:IsA(className) then
        return inst
    end
    local existing = Lighting:FindFirstChild(name)
    if existing and existing:IsA(className) then
        litFx[name] = existing
        return existing
    end
    inst = Instance.new(className)
    inst.Name = name
    inst.Parent = Lighting
    litFx[name] = inst
    return inst
end

local function litSuppressForeignPostFx()
    if not L.LitMaster then return end
    for _, child in Lighting:GetChildren() do
        if child:IsA("PostEffect") and not child.Name:find("^Roxy") then
            if L.LitBloom and child:IsA("BloomEffect") then
                child.Enabled = false
            elseif L.LitColorCorrection and child:IsA("ColorCorrectionEffect") then
                child.Enabled = false
            elseif L.LitBlur and child:IsA("BlurEffect") then
                child.Enabled = false
            elseif L.LitSunRays and child:IsA("SunRaysEffect") then
                child.Enabled = false
            end
        elseif child:IsA("Atmosphere") and child.Name ~= "RoxyAtmosphere" and L.LitAtmosphere then
            child.Density = 0
        end
    end
end

local function litDisableFx()
    for _, inst in litFx do
        if inst.Parent then
            if inst:IsA("PostEffect") then
                inst.Enabled = false
            elseif inst:IsA("Atmosphere") then
                inst.Density = 0
                inst.Haze = 0
            end
        end
    end
end

local function litCaptureSnapshot()
    litSnapshot = {
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        GlobalShadows = Lighting.GlobalShadows,
        FogColor = Lighting.FogColor,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        ExposureCompensation = Lighting.ExposureCompensation,
    }
    table.clear(litForeignSnap)
    for _, child in Lighting:GetChildren() do
        if child:IsA("PostEffect") and not child.Name:find("^Roxy") then
            litForeignSnap[child] = { Enabled = child.Enabled }
        elseif child:IsA("Atmosphere") and child.Name ~= "RoxyAtmosphere" then
            litForeignSnap[child] = { Density = child.Density, Haze = child.Haze }
        end
    end
end

local function litRestore()
    litApplying = true
    litDisconnectAll()
    for _, inst in litFx do
        pcall(function() inst:Destroy() end)
    end
    table.clear(litFx)
    if litSnapshot then
        for prop, val in litSnapshot do
            Lighting[prop] = val
        end
        litSnapshot = nil
    end
    for inst, data in litForeignSnap do
        if inst.Parent then
            if inst:IsA("PostEffect") and data.Enabled ~= nil then
                inst.Enabled = data.Enabled
            elseif inst:IsA("Atmosphere") then
                if data.Density ~= nil then inst.Density = data.Density end
                if data.Haze ~= nil then inst.Haze = data.Haze end
            end
        end
    end
    table.clear(litForeignSnap)
    litApplying = false
end

local function litApplyNow()
    if litApplying or not L.LitMaster then return end
    litApplying = true

    if L.LitClockSet then
        Lighting.ClockTime = L.LitClock
    end
    if L.LitBrightnessSet then
        Lighting.Brightness = L.LitBrightness
    end
    if L.LitGlobalShadowsSet then
        Lighting.GlobalShadows = L.LitGlobalShadows
    end
    if L.LitAmbientOverride then
        Lighting.Ambient = L.LitAmbient
        Lighting.OutdoorAmbient = L.LitOutdoorAmbient
    end

    local bloom = litFx.RoxyBloom
    if L.LitBloom then
        bloom = litGetFx("BloomEffect", "RoxyBloom")
        bloom.Enabled = true
        bloom.Intensity = L.LitBloomIntensity
        bloom.Size = L.LitBloomSize
        bloom.Threshold = LitBloomPresets[L.LitBloomPreset] or L.LitBloomThreshold
    elseif bloom then
        bloom.Enabled = false
    end

    local cc = litFx.RoxyColorCorrection
    local ccOn = L.LitColorCorrection or (L.LitBloom and not L.LitColorCorrection)
    if ccOn then
        cc = litGetFx("ColorCorrectionEffect", "RoxyColorCorrection")
        cc.Enabled = true
        cc.Brightness = L.LitCCBrightness
        cc.Contrast = L.LitCCContrast
        cc.Saturation = L.LitCCSaturation
        cc.TintColor = (L.LitBloom and not L.LitColorCorrection) and L.LitBloomTint or L.LitCCTint
    elseif cc then
        cc.Enabled = false
    end

    local blur = litFx.RoxyBlur
    if L.LitBlur then
        blur = litGetFx("BlurEffect", "RoxyBlur")
        blur.Enabled = true
        blur.Size = L.LitBlurSize
    elseif blur then
        blur.Enabled = false
    end

    local sun = litFx.RoxySunRays
    if L.LitSunRays then
        sun = litGetFx("SunRaysEffect", "RoxySunRays")
        sun.Enabled = true
        sun.Intensity = L.LitSunIntensity
        sun.Spread = L.LitSunSpread
    elseif sun then
        sun.Enabled = false
    end

    local atmo = litFx.RoxyAtmosphere
    if L.LitAtmosphere then
        atmo = litGetFx("Atmosphere", "RoxyAtmosphere")
        atmo.Density = L.LitFogDensity
        atmo.Offset = L.LitFogOffset
        atmo.Color = L.LitFogColor
        atmo.Decay = L.LitFogColor
        atmo.Glare = 0
        atmo.Haze = math.clamp(L.LitFogDensity * 2, 0, 2)
    elseif atmo then
        atmo.Density = 0
        atmo.Haze = 0
    end

    litSuppressForeignPostFx()
    litApplying = false
end

local function litApply()
    if not L.LitMaster then return end
    if litQueued then return end
    litQueued = true
    task.defer(function()
        litQueued = false
        litApplyNow()
    end)
end

local function litBindProperty(inst, prop)
    litConns[#litConns + 1] = inst:GetPropertyChangedSignal(prop):Connect(function()
        if litApplying or not L.LitMaster then return end
        litApply()
    end)
end

local function litMountGuard()
    litDisconnectAll()
    local props = {
        "Ambient", "OutdoorAmbient", "Brightness", "ClockTime",
        "GlobalShadows", "FogColor", "FogStart", "FogEnd", "ExposureCompensation"
    }
    for _, prop in props do
        litBindProperty(Lighting, prop)
    end
    litConns[#litConns + 1] = Lighting.ChildAdded:Connect(function()
        if litApplying or not L.LitMaster then return end
        task.defer(litApply)
    end)
    litConns[#litConns + 1] = Lighting.DescendantAdded:Connect(function(desc)
        if litApplying or not L.LitMaster then return end
        if desc:IsA("PostEffect") or desc:IsA("Atmosphere") then
            task.defer(litApply)
        end
    end)
end

local WorldCameraTabbox = Tabs.Visuals:AddRightTabbox()
local WorldTab = WorldCameraTabbox:AddTab("World")
local CameraTab = WorldCameraTabbox:AddTab("Camera")

WorldTab:AddToggle("LitMaster", {
    Text = "Custom Lighting",
    Default = false,
    Callback = function(v)
        L.LitMaster = v
        if v then
            litCaptureSnapshot()
            litMountGuard()
        else
            litRestore()
        end
    end
})

local D_LitCore = WorldTab:AddDependencyBox()
D_LitCore:SetupDependencies({{Toggles.LitMaster, true}})

D_LitCore:AddSlider("LitClock", {
    Text = "Clock Time",
    Default = 14,
    Min = 0,
    Max = 24,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        L.LitClock = v
        L.LitClockSet = true
        litApply()
    end
})

D_LitCore:AddSlider("LitBrightness", {
    Text = "Brightness",
    Default = 2,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = true,
    Callback = function(v)
        L.LitBrightness = v
        L.LitBrightnessSet = true
        litApply()
    end
})

D_LitCore:AddToggle("LitGlobalShadows", {
    Text = "Global Shadows",
    Default = true,
    Callback = function(v)
        L.LitGlobalShadows = v
        L.LitGlobalShadowsSet = true
        litApply()
    end
})

local D_LitAmbient = D_LitCore:AddDependencyBox()

local LitAmbientToggle = D_LitAmbient:AddToggle("LitAmbientOverride", {
    Text = "Ambient Override",
    Default = false,
    Callback = function(v)
        L.LitAmbientOverride = v
        litApply()
    end
})
LitAmbientToggle:AddColorPicker("LitAmbientColor", {
    Default = L.LitAmbient,
    Title = "Ambient",
    Callback = function(c)
        L.LitAmbient = c
        litApply()
    end
}):AddColorPicker("LitOutdoorAmbientColor", {
    Default = L.LitOutdoorAmbient,
    Title = "Outdoor Ambient",
    Callback = function(c)
        L.LitOutdoorAmbient = c
        litApply()
    end
})

local LitBloomToggle = D_LitCore:AddToggle("LitBloom", {
    Text = "Bloom",
    Default = false,
    Callback = function(v)
        L.LitBloom = v
        litApply()
    end
})
LitBloomToggle:AddColorPicker("LitBloomTint", {
    Default = L.LitBloomTint,
    Title = "Bloom Tint",
    Callback = function(c)
        L.LitBloomTint = c
        litApply()
    end
})

local D_LitBloom = D_LitCore:AddDependencyBox()
D_LitBloom:SetupDependencies({{LitBloomToggle, true}})

D_LitBloom:AddSlider("LitBloomIntensity", {
    Text = "Bloom Intensity",
    Default = 1,
    Min = 0,
    Max = 5,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        L.LitBloomIntensity = v
        litApply()
    end
})

D_LitBloom:AddSlider("LitBloomSize", {
    Text = "Bloom Amount",
    Default = 24,
    Min = 0,
    Max = 56,
    Rounding = 0,
    Compact = true,
    Callback = function(v)
        L.LitBloomSize = v
        litApply()
    end
})

D_LitBloom:AddDropdown("LitBloomPreset", {
    Values = {"Subtle", "Default", "Intense", "All"},
    Default = 2,
    Multi = false,
    Text = "Bloom Threshold",
    Callback = function(v)
        L.LitBloomPreset = v
        L.LitBloomThreshold = LitBloomPresets[v] or L.LitBloomThreshold
        litApply()
    end
})

local LitCCToggle = D_LitCore:AddToggle("LitColorCorrection", {
    Text = "Color Correction",
    Default = false,
    Callback = function(v)
        L.LitColorCorrection = v
        litApply()
    end
})

local D_LitCC = D_LitCore:AddDependencyBox()
D_LitCC:SetupDependencies({{LitCCToggle, true}})

LitCCToggle:AddColorPicker("LitCCTint", {
    Default = L.LitCCTint,
    Title = "Tint",
    Callback = function(c)
        L.LitCCTint = c
        litApply()
    end
})

D_LitCC:AddSlider("LitCCBrightness", {
    Text = "CC Brightness",
    Default = 0,
    Min = -1,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        L.LitCCBrightness = v
        litApply()
    end
})

D_LitCC:AddSlider("LitCCContrast", {
    Text = "CC Contrast",
    Default = 0,
    Min = -1,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        L.LitCCContrast = v
        litApply()
    end
})

D_LitCC:AddSlider("LitCCSaturation", {
    Text = "CC Saturation",
    Default = 0,
    Min = -1,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        L.LitCCSaturation = v
        litApply()
    end
})

local LitAtmoToggle = D_LitCore:AddToggle("LitAtmosphere", {
    Text = "Atmosphere / Fog",
    Default = false,
    Callback = function(v)
        L.LitAtmosphere = v
        litApply()
    end
})

local D_LitAtmo = D_LitCore:AddDependencyBox()
D_LitAtmo:SetupDependencies({{LitAtmoToggle, true}})

LitAtmoToggle:AddColorPicker("LitFogColor", {
    Default = L.LitFogColor,
    Title = "Fog Color",
    Callback = function(c)
        L.LitFogColor = c
        litApply()
    end
})

D_LitAtmo:AddSlider("LitFogDensity", {
    Text = "Fog Density",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        L.LitFogDensity = v
        litApply()
    end
})

D_LitAtmo:AddSlider("LitFogOffset", {
    Text = "Fog Offset",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        L.LitFogOffset = v
        litApply()
    end
})

local LitSunToggle = D_LitCore:AddToggle("LitSunRays", {
    Text = "Sun Rays",
    Default = false,
    Callback = function(v)
        L.LitSunRays = v
        litApply()
    end
})

local D_LitSun = D_LitCore:AddDependencyBox()
D_LitSun:SetupDependencies({{LitSunToggle, true}})

D_LitSun:AddSlider("LitSunIntensity", {
    Text = "Sun Intensity",
    Default = 0.15,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        L.LitSunIntensity = v
        litApply()
    end
})

D_LitSun:AddSlider("LitSunSpread", {
    Text = "Sun Spread",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        L.LitSunSpread = v
        litApply()
    end
})

local LitBlurToggle = D_LitCore:AddToggle("LitBlur", {
    Text = "Blur",
    Default = false,
    Callback = function(v)
        L.LitBlur = v
        litApply()
    end
})

local D_LitBlur = D_LitCore:AddDependencyBox()
D_LitBlur:SetupDependencies({{LitBlurToggle, true}})

D_LitBlur:AddSlider("LitBlurSize", {
    Text = "Blur Size",
    Default = 0,
    Min = 0,
    Max = 56,
    Rounding = 0,
    Compact = true,
    Callback = function(v)
        L.LitBlurSize = v
        litApply()
    end
})

CameraTab:AddLabel("Camera modifiers coming soon.")

G.litDisconnectAll = litDisconnectAll
G.litRestore = litRestore
end

do
local WS = workspace
local RS = S.RunService
local tracerFolder = nil
local tracerHooksReady = false

local TRACER_NAME_SET = {
    VoidBeamTracerEffect = true,
    ["2025BeamTracerEffect"] = true,
    ApexBeamTracerEffect = true,
    EnergyBeamTracerEffect = true,
    EnergyTracerEffect = true,
    HackerBeamTracerEffect = true,
    SoulBeamTracerEffect = true,
    TracerEffect = true,
}

local tracerProcessed = setmetatable({}, { __mode = "k" })
local tracerDrawActive = {}
local tracerConns = {}
local tracerFolderConns = {}
local tracerOrigCache = setmetatable({}, { __mode = "k" })

local function tracerAlpha(elapsed, duration)
    duration = math.max(0.05, duration)
    local fadeIn = math.min(0.1, duration * 0.22)
    local fadeOut = math.min(0.32, duration * 0.48)
    local hold = math.max(0, duration - fadeIn - fadeOut)
    if elapsed < fadeIn then
        return elapsed / fadeIn
    end
    if elapsed < fadeIn + hold then
        return 1
    end
    if elapsed < duration then
        return 1 - (elapsed - fadeIn - hold) / fadeOut
    end
    return 0
end

local LOCAL_TRACER_DIST = 28

local function distToLocalPlayer(worldPos)
    local char = LP.Character
    if not char then return math.huge end
    local best = math.huge
    local cam = WS.CurrentCamera
    if cam then
        best = math.min(best, (worldPos - cam.CFrame.Position).Magnitude)
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        best = math.min(best, (worldPos - hrp.Position).Magnitude)
    end
    for _, desc in ipairs(char:GetDescendants()) do
        if desc:IsA("BasePart") then
            best = math.min(best, (worldPos - desc.Position).Magnitude)
        end
    end
    return best
end

local function isLocalTracer(data)
    local p0, p1 = data.att0.WorldPosition, data.att1.WorldPosition
    return math.min(distToLocalPlayer(p0), distToLocalPlayer(p1)) <= LOCAL_TRACER_DIST
end

local function normalizeTracerAttachments(att0, att1)
    if distToLocalPlayer(att0.WorldPosition) <= distToLocalPlayer(att1.WorldPosition) then
        return att0, att1
    end
    return att1, att0
end

local function resolveTracerFolder()
    local f = WS:FindFirstChild("TracerEffect")
    if f and (f:IsA("Folder") or f:IsA("Model") or f:IsA("BasePart")) then
        return f
    end
    return nil
end

local function isTracerInstance(inst)
    if not inst or not tracerFolder then return false end
    if inst.Parent ~= tracerFolder then return false end
    if TRACER_NAME_SET[inst.Name] then return true end
    if inst:IsA("BasePart") or inst:IsA("Model") then
        if inst:FindFirstChildWhichIsA("Beam", true) then return true end
        local ac = 0
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("Attachment") then ac = ac + 1 end
        end
        if ac >= 2 then return true end
    end
    return false
end

local function getTracerData(inst)
    if not inst or not isTracerInstance(inst) then return nil end
    local root = inst
    local beam = root:FindFirstChildWhichIsA("Beam", true)
    local att0, att1
    if beam and beam.Attachment0 and beam.Attachment1 then
        att0, att1 = beam.Attachment0, beam.Attachment1
    else
        local atts = {}
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("Attachment") then
                atts[#atts + 1] = d
            end
        end
        if #atts < 2 then return nil end
        att0, att1 = atts[1], atts[2]
    end
    att0, att1 = normalizeTracerAttachments(att0, att1)
    local part = root:IsA("BasePart") and root or root:FindFirstChildWhichIsA("BasePart", true)
    return { root = root, beam = beam, att0 = att0, att1 = att1, part = part }
end

local function cacheTracerOrig(data)
    if tracerOrigCache[data.root] then return end
    local o = {}
    if data.beam then
        o.beam = {
            Enabled = data.beam.Enabled,
            Color = data.beam.Color,
            Transparency = data.beam.Transparency,
            Width0 = data.beam.Width0,
            Width1 = data.beam.Width1,
            LightEmission = data.beam.LightEmission,
            FaceCamera = data.beam.FaceCamera,
        }
    end
    if data.part then
        o.part = {
            Transparency = data.part.Transparency,
            Color = data.part.Color,
            Material = data.part.Material,
            Size = data.part.Size,
            CastShadow = data.part.CastShadow,
            CanCollide = data.part.CanCollide,
        }
    end
    tracerOrigCache[data.root] = o
end

local function restoreTracerOrig(root)
    local o = tracerOrigCache[root]
    if not o then return end
    if o.beam then
        local beam = root:FindFirstChildWhichIsA("Beam", true)
        if beam then
            for k, v in pairs(o.beam) do beam[k] = v end
        end
    end
    if o.part then
        local part = root:IsA("BasePart") and root or root:FindFirstChildWhichIsA("BasePart", true)
        if part then
            for k, v in pairs(o.part) do part[k] = v end
        end
    end
    tracerOrigCache[root] = nil
end

local function hideWorldTracerVisual(data)
    if data.beam then
        data.beam.Enabled = false
    end
    if data.part then
        data.part.Transparency = 1
        data.part.CanCollide = false
        data.part.CastShadow = false
    end
end

local function applyNoneTracer(data, alpha)
    local c1, c2 = L.TracerGrad1, L.TracerGrad2
    local p0, p1 = data.att0.WorldPosition, data.att1.WorldPosition
    local dist = (p1 - p0).Magnitude
    if dist < 0.05 then return end
    local thickness = math.clamp(L.TracerSize or 0.12, 0.02, 2)
    local mid = (p0 + p1) * 0.5
    local cf = CFrame.lookAt(mid, p1)
    if data.beam then
        data.beam.Enabled = false
    end
    if data.part then
        data.part.Anchored = true
        data.part.CanCollide = false
        data.part.CastShadow = false
        data.part.Material = Enum.Material.Neon
        data.part.Color = c1:Lerp(c2, 0.5)
        data.part.Size = Vector3.new(thickness, thickness, dist)
        data.part.CFrame = cf * CFrame.new(0, 0, -dist * 0.5)
        data.part.Transparency = 1 - alpha
    elseif data.beam then
        data.beam.Enabled = true
        data.beam.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1),
            ColorSequenceKeypoint.new(1, c2),
        })
        data.beam.Width0 = thickness * 8
        data.beam.Width1 = thickness * 8
        data.beam.LightEmission = 1
        data.beam.FaceCamera = true
        data.beam.Transparency = NumberSequence.new(1 - alpha)
    end
end

local function removeDrawTracer(entry)
    if entry.outline then pcall(function() entry.outline:Remove() end) end
    if entry.segs then
        for i = 1, #entry.segs do
            if entry.segs[i] then pcall(function() entry.segs[i]:Remove() end) end
        end
    elseif entry.line then
        pcall(function() entry.line:Remove() end)
    end
end

local TRACER_DRAW_SEGS = 14

local function pushDrawTracer(data)
    if #tracerDrawActive >= 32 then
        local old = table.remove(tracerDrawActive, 1)
        if old then removeDrawTracer(old) end
    end
    local outline = Drawing.new("Line")
    outline.Thickness = 3
    outline.Color = Color3.fromRGB(0, 0, 0)
    outline.Visible = false
    local segs = {}
    for i = 1, TRACER_DRAW_SEGS do
        local ln = Drawing.new("Line")
        ln.Thickness = math.max(1, (L.TracerSize or 0.12) * 10)
        ln.Visible = false
        segs[i] = ln
    end
    tracerDrawActive[#tracerDrawActive + 1] = {
        att0 = data.att0,
        att1 = data.att1,
        root = data.root,
        outline = outline,
        segs = segs,
        start = tick(),
        duration = L.TracerDuration or 0.65,
    }
end

local function runTracerLife(data)
    cacheTracerOrig(data)
    local duration = math.clamp(L.TracerDuration or 0.65, 0.05, 5)
    local style = L.TracerStyle or "None"
    if style == "1" then
        hideWorldTracerVisual(data)
        pushDrawTracer(data)
        return
    end
    task.spawn(function()
        local start = tick()
        while data.root.Parent and L.Tracers and (L.TracerStyle or "None") == "None" do
            local elapsed = tick() - start
            if elapsed >= duration then break end
            applyNoneTracer(data, tracerAlpha(elapsed, duration))
            RS.Heartbeat:Wait()
        end
        if data.root.Parent then
            restoreTracerOrig(data.root)
        end
    end)
end

local function tryProcessTracer(inst)
    if not L.Tracers or not inst then return end
    tracerFolder = tracerFolder or resolveTracerFolder()
    if not tracerFolder then return end
    local data = getTracerData(inst)
    if not data then return end
    if tracerProcessed[data.root] then return end
    if not isLocalTracer(data) then return end
    tracerProcessed[data.root] = true
    runTracerLife(data)
end

local function scheduleProcessTracer(inst)
    if not inst then return end
    task.defer(function()
        tryProcessTracer(inst)
    end)
    for _, delay in ipairs({ 0.03, 0.08, 0.15 }) do
        task.delay(delay, function()
            if inst.Parent then
                tryProcessTracer(inst)
            end
        end)
    end
end

local function scanTracerFolder()
    tracerFolder = resolveTracerFolder()
    if not tracerFolder then return end
    for _, child in ipairs(tracerFolder:GetChildren()) do
        scheduleProcessTracer(child)
    end
end

local function tracerRenderStep()
    if not L.Tracers or L.TracerStyle ~= "1" then
        for i = #tracerDrawActive, 1, -1 do
            removeDrawTracer(tracerDrawActive[i])
            table.remove(tracerDrawActive, i)
        end
        return
    end
    local cam = WS.CurrentCamera
    if not cam then return end
    local now = tick()
    local c1, c2 = L.TracerGrad1, L.TracerGrad2
    local thick = math.max(1, (L.TracerSize or 0.12) * 10)
    for i = #tracerDrawActive, 1, -1 do
        local e = tracerDrawActive[i]
        local elapsed = now - e.start
        if elapsed >= e.duration or not e.att0.Parent or not e.att1.Parent or not e.root.Parent then
            removeDrawTracer(e)
            if e.root.Parent then restoreTracerOrig(e.root) end
            table.remove(tracerDrawActive, i)
        else
            local p0, p1 = e.att0.WorldPosition, e.att1.WorldPosition
            local s0, _ = cam:WorldToViewportPoint(p0)
            local s1, _ = cam:WorldToViewportPoint(p1)
            local v0 = Vector2.new(s0.X, s0.Y)
            local v1 = Vector2.new(s1.X, s1.Y)
            local alpha = tracerAlpha(elapsed, e.duration)
            local transp = 1 - alpha
            e.outline.From, e.outline.To = v0, v1
            e.outline.Thickness = thick + 2
            e.outline.Transparency = transp
            e.outline.Visible = true
            local n = TRACER_DRAW_SEGS
            for s = 1, n do
                local t0 = (s - 1) / n
                local t1 = s / n
                local a0 = v0:Lerp(v1, t0)
                local a1 = v0:Lerp(v1, t1)
                local gradT = (t0 + t1) * 0.5
                local ln = e.segs[s]
                if ln then
                    ln.From, ln.To = a0, a1
                    ln.Thickness = thick
                    ln.Color = c1:Lerp(c2, gradT)
                    ln.Transparency = transp
                    ln.Visible = true
                end
            end
        end
    end
end

local function tracerDisconnectFolder()
    for _, c in tracerFolderConns do
        pcall(function() c:Disconnect() end)
    end
    table.clear(tracerFolderConns)
    tracerHooksReady = false
end

local function tracerDisconnectAll()
    tracerDisconnectFolder()
    for _, c in tracerConns do
        pcall(function() c:Disconnect() end)
    end
    table.clear(tracerConns)
end

local function tracerCleanupAll()
    for i = #tracerDrawActive, 1, -1 do
        local e = tracerDrawActive[i]
        removeDrawTracer(e)
        if e.root and e.root.Parent then restoreTracerOrig(e.root) end
    end
    table.clear(tracerDrawActive)
    for root in pairs(tracerOrigCache) do
        if root.Parent then restoreTracerOrig(root) end
    end
end

local function tracerMount()
    tracerFolder = resolveTracerFolder()
    if not tracerFolder or tracerHooksReady then return tracerHooksReady end
    tracerFolderConns[#tracerFolderConns + 1] = tracerFolder.ChildAdded:Connect(function(child)
        scheduleProcessTracer(child)
    end)
    tracerFolderConns[#tracerFolderConns + 1] = tracerFolder.DescendantAdded:Connect(function(desc)
        if not L.Tracers then return end
        if not (desc:IsA("Beam") or desc:IsA("Attachment")) then return end
        local cur = desc.Parent
        while cur and cur ~= tracerFolder do
            if cur.Parent == tracerFolder and isTracerInstance(cur) then
                scheduleProcessTracer(cur)
                return
            end
            cur = cur.Parent
        end
    end)
    tracerHooksReady = true
    if L.Tracers then
        scanTracerFolder()
    end
    return true
end

local function tracerEnsureHooks()
    if tracerMount() then return end
end

tracerConns[#tracerConns + 1] = RS.RenderStepped:Connect(tracerRenderStep)

tracerConns[#tracerConns + 1] = WS.ChildAdded:Connect(function(child)
    if child.Name == "TracerEffect" then
        tracerFolder = child
        tracerDisconnectFolder()
        tracerMount()
        if L.Tracers then
            scanTracerFolder()
        end
    end
end)

local ViewTracerTabbox = Tabs.Visuals:AddRightTabbox()
local ViewmodelTab = ViewTracerTabbox:AddTab("Viewmodel")
ViewmodelTab:AddLabel("Viewmodel modifiers coming soon.")

local TracersTab = ViewTracerTabbox:AddTab("Tracers")

TracersTab:AddToggle("BulletTracers", {
    Text = "Bullet Tracers",
    Default = false,
    Callback = function(v)
        L.Tracers = v
        if v then
            tracerProcessed = setmetatable({}, { __mode = "k" })
            tracerEnsureHooks()
            scanTracerFolder()
        else
            tracerCleanupAll()
            tracerProcessed = setmetatable({}, { __mode = "k" })
        end
    end
}):AddColorPicker("TracerGradColor1", {
    Default = L.TracerGrad1,
    Title = "Tracer Gradient 1",
    Callback = function(c)
        L.TracerGrad1 = c
    end
}):AddColorPicker("TracerGradColor2", {
    Default = L.TracerGrad2,
    Title = "Tracer Gradient 2",
    Callback = function(c)
        L.TracerGrad2 = c
    end
})

TracersTab:AddSlider("TracerDuration", {
    Text = "Duration",
    Default = 0.65,
    Min = 0.05,
    Max = 3,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        L.TracerDuration = v
    end
})

TracersTab:AddSlider("TracerSize", {
    Text = "Size",
    Default = 0.12,
    Min = 0.02,
    Max = 1.5,
    Rounding = 2,
    Compact = true,
    Callback = function(v)
        L.TracerSize = v
    end
})

TracersTab:AddDropdown("TracerStyle", {
    Values = {"None", "1"},
    Default = "None",
    Multi = false,
    Text = "Tracer Style",
    Callback = function(v)
        L.TracerStyle = v
        if L.TracerStyle == "1" and tracerFolder then
            for _, child in ipairs(tracerFolder:GetChildren()) do
                local data = getTracerData(child)
                if data and tracerProcessed[data.root] then
                    hideWorldTracerVisual(data)
                end
            end
        else
            tracerCleanupAll()
            scanTracerFolder()
        end
    end
})

task.defer(function()
    tracerMount()
end)

G.tracerDisconnectAll = tracerDisconnectAll
G.tracerCleanupAll = tracerCleanupAll
end

do
local HttpService2 = game:GetService("HttpService")
local playerScripts = LP:WaitForChild("PlayerScripts")
local controllers = playerScripts:WaitForChild("Controllers")
local EnumLibrary = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
if EnumLibrary and EnumLibrary.WaitForEnumBuilder then EnumLibrary:WaitForEnumBuilder() end
local DataController = require(controllers:WaitForChild("PlayerDataController", 10))

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
local sc_unlockOverlay = nil
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
end

local sc_repFlushScheduled = false
local function sc_queueReplication(key)
    sc_replicationQueue[key] = true
    if sc_repFlushScheduled then return end
    sc_repFlushScheduled = true
    task.defer(function()
        sc_repFlushScheduled = false
        local pending = sc_replicationQueue
        sc_replicationQueue = {}
        for repKey in next, pending do
            pcall(function() DataController.CurrentData:Replicate(repKey) end)
        end
    end)
end

local function sc_invalidateAll()
    table.clear(sc_weaponDataCache)
    sc_invDirty = true
    sc_invProxy = nil
    sc_unlockOverlay = nil
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
            if sc_unlockAllRequested and _CosLib and _CosLib.Cosmetics then
                if not sc_unlockOverlay then
                    sc_unlockOverlay = {}
                    for k in next, _CosLib.Cosmetics do
                        if sc_isValid(k) then sc_unlockOverlay[k] = true end
                    end
                end
                for k in next, sc_unlockOverlay do
                    proxy[k] = true
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

if EmoteController and EmoteController.GetEmotes then
    local _origGE = EmoteController.GetEmotes
    EmoteController.GetEmotes = function(self)
        if sc_emoteCache then return sc_emoteCache end
        local emotes = _origGE(self)
        local merged = sc_clone(emotes)
        if _CosLib and _CosLib.Cosmetics then
            for name, cosmetic in next, _CosLib.Cosmetics do
                if cosmetic and (cosmetic.Type == "Dance" or cosmetic.Type == "Emote") and not merged[name] then
                    merged[name] = { Name = name, Type = cosmetic.Type, ObjectID = cosmetic.ObjectID, Enum = cosmetic.Enum }
                end
            end
        end
        sc_emoteCache = merged
        return merged
    end
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
    if not sc_weaponCosCacheCount then sc_weaponCosCacheCount = 0 end
    if not _weaponCosCache[cacheKey] then
        sc_weaponCosCacheCount += 1
        if sc_weaponCosCacheCount > 64 then
            table.clear(_weaponCosCache)
            sc_weaponCosCacheCount = 0
        end
    end
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
local SC_PROFILE_NONE = "None"
local scMeta         = { activeKey = SC_PROFILE_NONE, defaultConfig = SC_PROFILE_NONE, configs = { SC_PROFILE_NONE }, autoApply = true, autoloadProfile = false }
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
            scMeta.autoloadProfile = (decoded.autoloadProfile ~= nil) and decoded.autoloadProfile or false
        end
    end)
end

local function scEnsureNoneProfile()
    local found, idx = false, nil
    for i, name in ipairs(scMeta.configs) do
        if name == SC_PROFILE_NONE then found = true; idx = i; break end
    end
    if found and idx ~= 1 then
        table.remove(scMeta.configs, idx)
        table.insert(scMeta.configs, 1, SC_PROFILE_NONE)
    elseif not found then
        table.insert(scMeta.configs, 1, SC_PROFILE_NONE)
    end
end

local function scEnsureNoneFile()
    if not writefile or not isfile then return end
    scEnsureFolder()
    local path = scConfigFile(SC_PROFILE_NONE)
    if not isfile(path) then
        pcall(function()
            writefile(path, HttpService2:JSONEncode({
                weaponCosmetics = {},
                emote = "None",
                lastWeapon = scSelectedWeapon or "Assault Rifle",
            }))
        end)
    end
end

local function scClearCosmeticState()
    sc_invalidateAll()
    table.clear(sc_equipped)
    table.clear(weaponCosmetics)
    scSelectedEmote = "None"
    sc_updateEquippedSet()
    sc_queueReplication("WeaponInventory")
end

local function scBuildConfigList()
    scEnsureNoneProfile()
    return scMeta.configs
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
    if name == SC_PROFILE_NONE then
        scClearCosmeticState()
        return
    end
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
    scClearCosmeticState()
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
            end
        end
    end
    sc_updateEquippedSet()
    task.defer(function()
        for weapon, cosmetics in next, weaponCosmetics do
            for cosmeticType, cosmeticName in next, cosmetics do
                if cosmeticName and cosmeticName ~= "None" and scEquipCosmetic then
                    pcall(function() scEquipCosmetic:FireServer(weapon, cosmeticType, cosmeticName, {}) end)
                end
            end
        end
        sc_queueReplication("WeaponInventory")
    end)
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
scEnsureNoneProfile()
if not scMeta.activeKey then scMeta.activeKey = SC_PROFILE_NONE end
local activeValid = false
for _, n in ipairs(scMeta.configs) do
    if n == scMeta.activeKey then activeValid = true break end
end
if not activeValid then scMeta.activeKey = SC_PROFILE_NONE end
scSaveMeta()
if scMeta.autoloadProfile then
    scLoadConfig(scMeta.activeKey or SC_PROFILE_NONE)
elseif scMeta.activeKey == SC_PROFILE_NONE then
    scClearCosmeticState()
end

local SkinTab      = Tabs.Skinchanger
local SCLeftTabbox = SkinTab:AddLeftTabbox()

local WeaponSkinsTab = SCLeftTabbox:AddTab("Weapon Skins")

local weaponList = scGetWeapons()
scSelectedWeapon = scSelectedWeapon or weaponList[1] or "None"
scEnsureNoneFile()

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
    sc_unlockOverlay = nil
    sc_invDirty = true
    sc_invProxy = nil
    sc_queueReplication("CosmeticInventory")
    Library:Notify("Applied Global Unlock to Inventory System.", 3)
end)

-- Emote unlock handled in Global Unlock


WeaponSkinsTab:AddLabel("Use Configs (right) to save/load skin setups.")
WeaponSkinsTab:AddLabel("None = empty. Equip skins, then Save Config.")

task.defer(function()
    scRefreshDropdowns(scSelectedWeapon)
    if Options.SC_ConfigSelect then
        Options.SC_ConfigSelect:SetValues(scBuildConfigList())
        Options.SC_ConfigSelect:SetValue(scMeta.activeKey or SC_PROFILE_NONE)
    end
end)

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
    if name == SC_PROFILE_NONE then Library:Notify('"' .. SC_PROFILE_NONE .. '" is reserved', 2) return end
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
    if oldName == SC_PROFILE_NONE then Library:Notify('"' .. SC_PROFILE_NONE .. '" cannot be renamed', 2) return end
    if newName == SC_PROFILE_NONE then Library:Notify('"' .. SC_PROFILE_NONE .. '" is reserved', 2) return end
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
    local name = scActiveConfigName()
    if name == SC_PROFILE_NONE then Library:Notify('"' .. SC_PROFILE_NONE .. '" cannot be deleted', 2) return end
    if #scMeta.configs <= 1 then Library:Notify("Cannot delete the last config", 2) return end
    pcall(function()
        if isfile and isfile(scConfigFile(name)) and delfile then
            delfile(scConfigFile(name))
        end
    end)
    for i, n in next, scMeta.configs do
        if n == name then table.remove(scMeta.configs, i) break end
    end
    scEnsureNoneProfile()
    if scMeta.defaultConfig == name then scMeta.defaultConfig = SC_PROFILE_NONE end
    scMeta.activeKey = SC_PROFILE_NONE
    scLoadConfig(SC_PROFILE_NONE)
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
    Default = scMeta.autoloadProfile == true,
    Callback = function(v)
        scMeta.autoloadProfile = v
        scSaveMeta()
        if v then
            local profile = scMeta.activeKey or SC_PROFILE_NONE
            scMeta.activeKey = profile
            scLoadConfig(profile)
            scRefreshDropdowns(scSelectedWeapon)
            if Options.SC_ConfigSelect then
                Options.SC_ConfigSelect:SetValue(profile)
            end
            if Options.SC_EmoteSelect and scSelectedEmote then
                Options.SC_EmoteSelect:SetValue(scSelectedEmote)
            end
            Library:Notify('Loaded profile "' .. profile .. '"', 2)
        end
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
    local name = scActiveConfigName()
    scEnsureFolder()
    if name == SC_PROFILE_NONE then scEnsureNoneFile() end
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
end

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

do
local HitSoundSkipIds = {
    ["rbxassetid://16537449730"] = true
}

local hitSoundEmitter = Instance.new("Sound")
hitSoundEmitter.Name = "RoxyHitEmitter"
hitSoundEmitter.Looped = false
hitSoundEmitter.Parent = S.SoundService

local hitSoundHostConn
local hitSoundDescConn

local function resolveHitSoundHost()
    local ps = LP:FindFirstChild("PlayerScripts")
    if not ps then return nil end
    local modules = ps:FindFirstChild("Modules")
    if not modules then return nil end
    local crc = modules:FindFirstChild("ClientReplicatedClasses")
    if not crc then return nil end
    local fighter = crc:FindFirstChild("ClientFighter")
    if not fighter then return nil end
    local item = fighter:FindFirstChild("ClientItem")
    if not item then return nil end
    return item:FindFirstChild("ClientViewModel")
end

local function wireHitSound(inst)
    if not inst:IsA("Sound") then return end
    if inst == hitSoundEmitter then return end
    if inst:GetAttribute("RoxyHitBound") then return end
    if HitSoundSkipIds[inst.SoundId] then return end
    inst:SetAttribute("RoxyHitBound", true)
    inst.Played:Connect(function()
        if not L.CustomHitSound then return end
        local asset = L.HitSoundAsset
        if not asset or HitSoundSkipIds[inst.SoundId] then return end
        inst:Stop()
        inst.Volume = 0
        hitSoundEmitter.SoundId = asset
        hitSoundEmitter.Volume = L.HitSoundVolume
        hitSoundEmitter.TimePosition = 0
        hitSoundEmitter:Play()
    end)
end

local function mountHitSoundHost(host)
    if hitSoundHostConn then
        hitSoundHostConn:Disconnect()
        hitSoundHostConn = nil
    end
    if hitSoundDescConn then
        hitSoundDescConn:Disconnect()
        hitSoundDescConn = nil
    end
    if not host then return end
    for _, desc in host:GetDescendants() do
        wireHitSound(desc)
    end
    hitSoundDescConn = host.DescendantAdded:Connect(wireHitSound)
    hitSoundHostConn = host.AncestryChanged:Connect(function(_, parent)
        if not parent then
            task.defer(function()
                if not Library.Unloaded then
                    mountHitSoundHost(resolveHitSoundHost())
                end
            end)
        end
    end)
end

task.defer(function()
    local host = resolveHitSoundHost()
    if host then
        mountHitSoundHost(host)
        return
    end
    local ps = LP:WaitForChild("PlayerScripts", 60)
    local modules = ps:WaitForChild("Modules", 60)
    local crc = modules:WaitForChild("ClientReplicatedClasses", 60)
    local fighter = crc:WaitForChild("ClientFighter", 60)
    local item = fighter:WaitForChild("ClientItem", 60)
    mountHitSoundHost(item:WaitForChild("ClientViewModel", 60))
end)
G.hitSoundHostConn, G.hitSoundDescConn, G.hitSoundEmitter = hitSoundHostConn, hitSoundDescConn, hitSoundEmitter
end

Library:OnUnload(function()
    Library.Unloaded = true
    if G.renderConnection then G.renderConnection:Disconnect(); G.renderConnection = nil end
    if G.hitSoundHostConn then G.hitSoundHostConn:Disconnect(); G.hitSoundHostConn = nil end
    if G.hitSoundDescConn then G.hitSoundDescConn:Disconnect(); G.hitSoundDescConn = nil end
    if G.hitSoundEmitter then G.hitSoundEmitter:Destroy() end
    if L.LitMaster and G.litRestore then G.litRestore()
    elseif G.litDisconnectAll then G.litDisconnectAll() end
    if G.removeESP and G.cache then
        for model in next, G.cache do G.removeESP(model) end
        table.clear(G.cache)
    end
    if G.tracerCleanupAll then G.tracerCleanupAll() end
    if G.tracerDisconnectAll then G.tracerDisconnectAll() end
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
