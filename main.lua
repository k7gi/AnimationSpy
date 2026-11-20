if _G.AnimSpyExecuted and type(_G.AnimSpyShutdown) == "function" then
    pcall(_G.AnimSpyShutdown)
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local HIGHLIGHT_URL = "https://github.com/exxtremestuffs/SimpleSpySource/raw/master/highlight.lua"
local MAX_LOGS = 300
local SIDE_WIDTH = 131
local TOP_HEIGHT = 19
local MIN_SIZE = Vector2.new(450, 268)

local WHITE = Color3.new(1, 1, 1)
local BLACK = Color3.new(0, 0, 0)
local SELECTED = Color3.fromRGB(92, 126, 229)
local ON = Color3.fromRGB(68, 206, 91)
local OFF = Color3.fromRGB(252, 51, 51)

local priorityColors = {
    [Enum.AnimationPriority.Core] = Color3.fromRGB(150, 150, 150),
    [Enum.AnimationPriority.Idle] = Color3.fromRGB(68, 206, 91),
    [Enum.AnimationPriority.Movement] = Color3.fromRGB(255, 242, 0),
    [Enum.AnimationPriority.Action] = Color3.fromRGB(99, 86, 245),
}

local function new(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then obj[k] = v end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = obj
    end
    obj.Parent = props and props.Parent
    return obj
end

local function tween(obj, t, props)
    local tw = TweenService:Create(obj, TweenInfo.new(t), props)
    tw:Play()
    return tw
end

local connections = {}
local function bind(signal, fn)
    local c = signal:Connect(fn)
    table.insert(connections, c)
    return c
end

-- gui

local gui = new("ScreenGui", {Name = "Animation Spy", ResetOnSpawn = false})

local background = new("Frame", {
    Parent = gui,
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    Position = UDim2.fromOffset(500, 200),
    Size = UDim2.fromOffset(520, 290),
})

local leftPanel = new("Frame", {
    Parent = background,
    BackgroundColor3 = Color3.fromRGB(53, 52, 55),
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(0, TOP_HEIGHT),
    Size = UDim2.new(0, SIDE_WIDTH, 1, -TOP_HEIGHT),
})

local logList = new("ScrollingFrame", {
    Parent = leftPanel,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(0, 9),
    Size = UDim2.new(1, 0, 1, -18),
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 4,
}, {
    new("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder}),
})

local rightPanel = new("Frame", {
    Parent = background,
    BackgroundColor3 = Color3.fromRGB(37, 36, 38),
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(SIDE_WIDTH, TOP_HEIGHT),
    Size = UDim2.new(1, -SIDE_WIDTH, 1, -TOP_HEIGHT),
})

local codeBox = new("Frame", {
    Parent = rightPanel,
    BackgroundColor3 = Color3.fromRGB(21, 19, 20),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 1, -64),
})

local viewport = new("ViewportFrame", {
    Parent = codeBox,
    BackgroundColor3 = Color3.fromRGB(28, 27, 29),
    BorderSizePixel = 0,
    Size = UDim2.new(0.4, 0, 1, 0),
    Ambient = Color3.fromRGB(110, 110, 120),
    LightColor = Color3.fromRGB(220, 220, 230),
})
local camera = new("Camera", {Parent = viewport, FieldOfView = 50})
viewport.CurrentCamera = camera

local noPreview = new("TextLabel", {
    Parent = viewport,
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Font = Enum.Font.SourceSans,
    Text = "no preview",
    TextColor3 = Color3.fromRGB(120, 120, 125),
    TextSize = 14,
})

local codeHolder = new("Frame", {
    Parent = codeBox,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.4, 0, 0, 0),
    Size = UDim2.new(0.6, 0, 1, 0),
})

local buttonGrid = new("ScrollingFrame", {
    Parent = rightPanel,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 1, -60),
    Size = UDim2.new(1, 0, 0, 56),
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollBarThickness = 4,
}, {
    new("UIGridLayout", {
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        CellPadding = UDim2.new(),
        CellSize = UDim2.fromOffset(94, 27),
    }),
})

local topBar = new("Frame", {
    Parent = background,
    BackgroundColor3 = Color3.fromRGB(37, 35, 38),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, TOP_HEIGHT),
})

local title = new("TextButton", {
    Parent = topBar,
    BackgroundTransparency = 1,
    AutoButtonColor = false,
    Position = UDim2.fromOffset(5, 0),
    Size = UDim2.fromOffset(57, 18),
    Font = Enum.Font.SourceSansBold,
    Text = "Animation Spy",
    TextColor3 = WHITE,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local function topButton(x, image)
    return new("TextButton", {
        Parent = topBar,
        BackgroundColor3 = Color3.fromRGB(37, 36, 38),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Position = UDim2.new(1, x, 0, 0),
        Size = UDim2.fromOffset(19, 19),
        Text = "",
    }, {
        new("ImageLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(5, 5), Size = UDim2.fromOffset(9, 9), Image = image}),
    })
end

local closeButton = topButton(-19, "http://www.roblox.com/asset/?id=5597086202")
local maximizeButton = topButton(-38, "http://www.roblox.com/asset/?id=5597108117")
local minimizeButton = topButton(-57, "http://www.roblox.com/asset/?id=5597105827")

local grip = new("TextButton", {
    Parent = background,
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.fromScale(1, 1),
    Size = UDim2.fromOffset(10, 10),
    BackgroundTransparency = 1,
    Text = "",
    ZIndex = 5,
})

local toolTip = new("Frame", {
    Parent = gui,
    BackgroundColor3 = Color3.fromRGB(26, 26, 26),
    BackgroundTransparency = 0.1,
    BorderColor3 = WHITE,
    Size = UDim2.fromOffset(200, 50),
    ZIndex = 3,
    Visible = false,
})

local toolTipLabel = new("TextLabel", {
    Parent = toolTip,
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(2, 2),
    Size = UDim2.fromOffset(196, 46),
    ZIndex = 3,
    Font = Enum.Font.SourceSans,
    Text = "",
    TextColor3 = WHITE,
    TextSize = 14,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
})

-- codebox

local codebox
do
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(HIGHLIGHT_URL))().new(codeHolder)
    end)
    if ok and result then
        codebox = result
    else
        local fallback = new("TextLabel", {
            Parent = codeHolder,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(4, 4),
            Size = UDim2.new(1, -8, 1, -8),
            Font = Enum.Font.Code,
            Text = "",
            TextColor3 = WHITE,
            TextSize = 13,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
        })
        codebox = {
            setRaw = function(_, text) fallback.Text = text end,
            getString = function() return fallback.Text end,
        }
    end
    codebox:setRaw("")
end

-- tooltip

local toolTipConn

toolTipLabel:GetPropertyChangedSignal("Text"):Connect(function()
    local size = TextService:GetTextSize(toolTipLabel.Text, 14, Enum.Font.SourceSans, Vector2.new(196, math.huge))
    toolTipLabel.Size = UDim2.fromOffset(size.X, size.Y)
    toolTip.Size = UDim2.fromOffset(size.X + 4, size.Y + 4)
end)

local function hideToolTip()
    if toolTipConn then
        toolTipConn:Disconnect()
        toolTipConn = nil
    end
    toolTip.Visible = false
end

local function showToolTip(text)
    hideToolTip()
    toolTipLabel.Text = text
    toolTip.Visible = true
    toolTipConn = RunService.RenderStepped:Connect(function()
        local vp = workspace.CurrentCamera.ViewportSize
        local size = toolTip.AbsoluteSize
        local x = math.clamp(mouse.X + 20, 0, math.max(0, vp.X - size.X))
        local y = math.clamp(mouse.Y + 20, 0, math.max(0, vp.Y - size.Y - 36))
        if x <= mouse.X and y <= mouse.Y then
            x, y = mouse.X - size.X - 2, mouse.Y - size.Y - 2
        end
        toolTip.Position = UDim2.fromOffset(x, y)
    end)
end

-- window

local openSize = Vector2.new(520, 290)
local sideClosed, closed, busy = false, false, false

local function targetSize()
    return UDim2.fromOffset(sideClosed and SIDE_WIDTH or openSize.X, closed and TOP_HEIGHT or openSize.Y)
end

local function toggleSide()
    if busy then return end
    busy = true
    sideClosed = not sideClosed
    if sideClosed then
        rightPanel.Visible = false
    else
        closed = false
    end
    tween(background, 0.3, {Size = targetSize()}).Completed:Wait()
    rightPanel.Visible = not sideClosed
    busy = false
end

local function toggleMinimize()
    if busy then return end
    busy = true
    closed = not closed
    if closed then
        sideClosed = true
        rightPanel.Visible = false
    end
    tween(background, 0.3, {Size = targetSize()}).Completed:Wait()
    busy = false
end

local function onDrag(handle, begin, move)
    local active, start
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            active, start = input, input.Position
            begin()
        end
    end)
    bind(UserInputService.InputChanged, function(input)
        if active and (input.UserInputType == Enum.UserInputType.MouseMovement or input == active) then
            move(input.Position - start)
        end
    end)
    bind(UserInputService.InputEnded, function(input)
        if input == active then active = nil end
    end)
end

local dragOrigin, sizeOrigin
onDrag(topBar, function() dragOrigin = background.Position end, function(d)
    background.Position = dragOrigin + UDim2.fromOffset(d.X, d.Y)
end)
onDrag(grip, function() sizeOrigin = openSize end, function(d)
    if busy or closed or sideClosed then return end
    openSize = Vector2.new(math.max(MIN_SIZE.X, sizeOrigin.X + d.X), math.max(MIN_SIZE.Y, sizeOrigin.Y + d.Y))
    background.Size = targetSize()
end)

local logging = true

title.MouseEnter:Connect(function() tween(title, 0.5, {TextColor3 = logging and ON or OFF}) end)
title.MouseLeave:Connect(function() tween(title, 0.5, {TextColor3 = WHITE}) end)
title.MouseButton1Click:Connect(function()
    logging = not logging
    tween(title, 0.5, {TextColor3 = logging and ON or OFF})
end)

closeButton.MouseEnter:Connect(function() tween(closeButton, 0.2, {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}) end)
closeButton.MouseLeave:Connect(function() tween(closeButton, 0.2, {BackgroundColor3 = Color3.fromRGB(37, 36, 38)}) end)
minimizeButton.MouseButton1Click:Connect(function() task.spawn(toggleMinimize) end)
maximizeButton.MouseButton1Click:Connect(function() task.spawn(toggleSide) end)

-- preview

local preview = {}

local function clearPreview()
    if preview.conn then preview.conn:Disconnect() end
    if preview.world then preview.world:Destroy() end
    preview = {}
    noPreview.Visible = true
end

local function showPreview(id)
    clearPreview()
    local char = player.Character
    if not char then return end

    local archivable = char.Archivable
    char.Archivable = true
    local clone = char:Clone()
    char.Archivable = archivable
    if not clone then return end

    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("BaseScript") or d:IsA("ModuleScript") then d:Destroy() end
    end

    local world = new("WorldModel", {Parent = viewport})
    clone.Parent = world
    preview.world = world
    noPreview.Visible = false

    local humanoid = clone:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local animator = humanoid:FindFirstChildOfClass("Animator") or new("Animator", {Parent = humanoid})
        local ok, track = pcall(animator.LoadAnimation, animator, new("Animation", {AnimationId = "rbxassetid://" .. id}))
        if ok and track then
            track.Looped = true
            track:Play()
        end
    end

    local focus = clone:GetPivot().Position
    local dist = clone:GetExtentsSize().Y * 1.3 + 3
    local angle = 0
    preview.conn = RunService.RenderStepped:Connect(function(dt)
        angle += dt * 0.6
        camera.CFrame = CFrame.lookAt(focus + Vector3.new(math.sin(angle) * dist, dist * 0.15, math.cos(angle) * dist), focus)
    end)
end

-- logs

local entries, byId, excluded = {}, {}, {}
local selected
local order = 0

local function genScript(entry)
    return table.concat({
        "-- Script generated by AnimSpy",
        "-- " .. entry.name .. (entry.looped and " (looped)" or ""),
        "",
        'local character = game:GetService("Players").LocalPlayer.Character',
        'local animator = character:WaitForChild("Humanoid"):WaitForChild("Animator")',
        "",
        'local anim = Instance.new("Animation")',
        'anim.AnimationId = "rbxassetid://' .. entry.id .. '"',
        "",
        "local track = animator:LoadAnimation(anim)",
        "track.Priority = " .. tostring(entry.priority),
        "track.Looped = " .. tostring(entry.looped),
        "track:Play()",
    }, "\n")
end

local function refreshRow(entry)
    entry.label.Text = entry.count > 1 and ("%s (x%d)"):format(entry.name, entry.count) or entry.name
    entry.bar.BackgroundColor3 = priorityColors[entry.priority] or OFF
end

local function selectEntry(entry)
    if selected then
        tween(selected.button, 0.5, {BackgroundColor3 = BLACK})
    end
    selected = entry
    if entry then
        tween(entry.button, 0.5, {BackgroundColor3 = SELECTED})
        codebox:setRaw(genScript(entry))
        showPreview(entry.id)
        if sideClosed then task.spawn(toggleSide) end
    else
        codebox:setRaw("")
        clearPreview()
    end
end

local function removeEntry(entry)
    byId[entry.id] = nil
    table.remove(entries, table.find(entries, entry))
    entry.frame:Destroy()
    if selected == entry then selectEntry(nil) end
end

local function makeRow(entry)
    entry.frame = new("Frame", {Parent = logList, BackgroundTransparency = 1, LayoutOrder = entry.order, Size = UDim2.fromOffset(117, 27)})
    entry.bar = new("Frame", {Parent = entry.frame, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 1), Size = UDim2.fromOffset(7, 18), ZIndex = 2})
    entry.label = new("TextLabel", {
        Parent = entry.frame,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 1),
        Size = UDim2.fromOffset(105, 18),
        ZIndex = 2,
        Font = Enum.Font.SourceSans,
        TextColor3 = WHITE,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    entry.button = new("TextButton", {
        Parent = entry.frame,
        BackgroundColor3 = BLACK,
        BackgroundTransparency = 0.75,
        BorderColor3 = WHITE,
        Position = UDim2.fromOffset(0, 1),
        Size = UDim2.fromOffset(117, 18),
        AutoButtonColor = false,
        Text = "",
    })
    entry.button.MouseButton1Click:Connect(function() selectEntry(entry) end)
    refreshRow(entry)
end

local function onPlayed(track)
    if not logging then return end
    local anim = track.Animation
    local id = anim and anim.AnimationId:match("%d+")
    if not id or excluded[id] then return end

    order -= 1
    local entry = byId[id]
    if entry then
        entry.count += 1
        entry.order = order
        entry.priority, entry.looped = track.Priority, track.Looped
        entry.frame.LayoutOrder = order
        refreshRow(entry)
        return
    end

    if #entries >= MAX_LOGS then
        local oldest = entries[1]
        for _, e in ipairs(entries) do
            if e.order > oldest.order then oldest = e end
        end
        removeEntry(oldest)
    end

    entry = {
        id = id,
        name = anim.Name ~= "" and anim.Name or "Animation",
        count = 1,
        order = order,
        priority = track.Priority,
        looped = track.Looped,
    }
    makeRow(entry)
    byId[id] = entry
    table.insert(entries, entry)
end

-- buttons

local function newButton(name, description, onClick)
    local cell = new("Frame", {Parent = buttonGrid, BackgroundTransparency = 1})
    new("Frame", {Parent = cell, BackgroundColor3 = WHITE, BorderSizePixel = 0, Position = UDim2.fromOffset(7, 5), Size = UDim2.fromOffset(7, 18), ZIndex = 3})
    new("TextLabel", {
        Parent = cell,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(19, 5),
        Size = UDim2.fromOffset(69, 18),
        ZIndex = 2,
        Font = Enum.Font.SourceSans,
        Text = name,
        TextColor3 = WHITE,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local button = new("TextButton", {
        Parent = cell,
        BackgroundColor3 = BLACK,
        BackgroundTransparency = 0.7,
        BorderColor3 = WHITE,
        Position = UDim2.fromOffset(7, 5),
        Size = UDim2.fromOffset(80, 18),
        AutoButtonColor = false,
        Text = "",
    })
    button.MouseEnter:Connect(function() showToolTip(description) end)
    button.MouseLeave:Connect(hideToolTip)
    button.MouseButton1Click:Connect(onClick)
end

newButton("Copy Code", "Click to copy code", function()
    setclipboard(codebox:getString())
    toolTipLabel.Text = "Copied successfully!"
end)

newButton("Copy ID", "Click to copy the animation id", function()
    if not selected then return end
    setclipboard("rbxassetid://" .. selected.id)
    toolTipLabel.Text = "Copied!"
end)

newButton("Run Code", "Click to play this animation on your character", function()
    local ok = pcall(function() loadstring(codebox:getString())() end)
    toolTipLabel.Text = ok and "Executed successfully!" or "Execution error!"
end)

newButton("Exclude", "Click to exclude this animation.\nExcluded animations won't show up in the logs.", function()
    if not selected then return end
    excluded[selected.id] = true
    removeEntry(selected)
    toolTipLabel.Text = "Excluded!"
end)

newButton("Clr Logs", "Click to clear logs", function()
    for _, e in ipairs(entries) do e.frame:Destroy() end
    table.clear(entries)
    table.clear(byId)
    selectEntry(nil)
    toolTipLabel.Text = "Logs cleared!"
end)

newButton("Clr Excluded", "Click to clear the exclude list", function()
    table.clear(excluded)
    toolTipLabel.Text = "Exclude list cleared!"
end)

-- hooks

local function hookCharacter(char)
    local humanoid = char:WaitForChild("Humanoid", 10)
    local animator = humanoid and humanoid:WaitForChild("Animator", 10)
    if animator then bind(animator.AnimationPlayed, onPlayed) end
end

if player.Character then task.spawn(hookCharacter, player.Character) end
bind(player.CharacterAdded, hookCharacter)

local function shutdown()
    for _, c in ipairs(connections) do c:Disconnect() end
    hideToolTip()
    clearPreview()
    gui:Destroy()
    _G.AnimSpyExecuted = false
    _G.AnimSpyShutdown = nil
end

closeButton.MouseButton1Click:Connect(shutdown)

gui.Parent = CoreGui
_G.AnimSpyShutdown = shutdown
_G.AnimSpyExecuted = true
