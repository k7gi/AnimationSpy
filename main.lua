local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local GuiInset = game:GetService("GuiService"):GetGuiInset()
local Players = game:GetService("Players")

local function Create(instance, properties, children)
    local obj = Instance.new(instance)
    for i, v in next, properties or {} do
        obj[i] = v
    end
    for _, child in next, children or {} do
        child.Parent = obj
    end
    return obj
end

local AnimSpy = Create("ScreenGui", {ResetOnSpawn = false, Name = "AnimSpy"})
local Background = Create("Frame", {Parent = AnimSpy, BackgroundColor3 = Color3.fromRGB(16, 16, 20), BackgroundTransparency = 0, ClipsDescendants = true, Position = UDim2.new(0, 500, 0, 200), Size = UDim2.new(0, 520, 0, 330)})
local LeftPanel = Create("Frame", {Parent = Background, BackgroundColor3 = Color3.fromRGB(22, 22, 28), BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 22), Size = UDim2.new(0, 138, 0, 308)})
local LogList = Create("ScrollingFrame", {Parent = LeftPanel, Active = true, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0, 4, 0, 6), Size = UDim2.new(1, -8, 1, -10), CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 3})
local UIListLayout = Create("UIListLayout", {Parent = LogList, HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
local RightPanel = Create("Frame", {Parent = Background, BackgroundColor3 = Color3.fromRGB(19, 19, 24), BorderSizePixel = 0, Position = UDim2.new(0, 138, 0, 22), Size = UDim2.new(0, 382, 0, 308)})
local CodeBox = Create("Frame", {Parent = RightPanel, BackgroundColor3 = Color3.fromRGB(12, 12, 16), BorderSizePixel = 0, Size = UDim2.new(0, 382, 0, 155)})
local ViewportFrame = Create("ViewportFrame", {Parent = CodeBox, BackgroundColor3 = Color3.fromRGB(20, 20, 28), BorderSizePixel = 0, LightColor = Color3.fromRGB(200, 200, 220), Ambient = Color3.fromRGB(90, 90, 110), Size = UDim2.new(0.44, -1, 1, 0)})
Create("Frame", {Parent = CodeBox, BackgroundColor3 = Color3.fromRGB(35, 35, 48), BorderSizePixel = 0, Position = UDim2.new(0.44, -1, 0, 0), Size = UDim2.new(0, 1, 1, 0)})
local CodeLabel = Create("TextLabel", {Parent = CodeBox, BackgroundTransparency = 1, Size = UDim2.new(0.56, -6, 1, -6), Position = UDim2.new(0.44, 3, 0, 3), Font = Enum.Font.Code, TextColor3 = Color3.fromRGB(195, 195, 215), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, Text = "-- Select a log entry to view details"})
local ViewportCamera = Instance.new("Camera")
ViewportCamera.Parent = ViewportFrame
ViewportFrame.CurrentCamera = ViewportCamera
local ScrollingFrame = Create("ScrollingFrame", {Parent = RightPanel, Active = true, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0.5, -9), CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 3})
local UIGridLayout = Create("UIGridLayout", {Parent = ScrollingFrame, HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, CellPadding = UDim2.new(0, 4, 0, 4), CellSize = UDim2.new(0, 100, 0, 24)})
local TopBar = Create("Frame", {Parent = Background, BackgroundColor3 = Color3.fromRGB(13, 13, 17), BorderSizePixel = 0, Size = UDim2.new(0, 520, 0, 22)})
local Simple = Create("TextButton", {Parent = TopBar, BackgroundColor3 = Color3.new(1, 1, 1), AutoButtonColor = false, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(0, 100, 0, 22), Font = Enum.Font.GothamBold, Text = "kagis animspy", TextColor3 = Color3.fromRGB(215, 215, 230), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left})
local CloseButton = Create("TextButton", {Parent = TopBar, BackgroundColor3 = Color3.fromRGB(36, 36, 46), BorderSizePixel = 0, Position = UDim2.new(1, -22, 0, 0), Size = UDim2.new(0, 22, 0, 22), Font = Enum.Font.SourceSans, Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14})
Create("ImageLabel", {Parent = CloseButton, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Position = UDim2.new(0, 7, 0, 7), Size = UDim2.new(0, 8, 0, 8), Image = "http://www.roblox.com/asset/?id=5597086202"})
local MaximizeButton = Create("TextButton", {Parent = TopBar, BackgroundColor3 = Color3.fromRGB(36, 36, 46), BorderSizePixel = 0, Position = UDim2.new(1, -44, 0, 0), Size = UDim2.new(0, 22, 0, 22), Font = Enum.Font.SourceSans, Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14})
Create("ImageLabel", {Parent = MaximizeButton, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Position = UDim2.new(0, 7, 0, 7), Size = UDim2.new(0, 8, 0, 8), Image = "http://www.roblox.com/asset/?id=5597108117"})
local MinimizeButton = Create("TextButton", {Parent = TopBar, BackgroundColor3 = Color3.fromRGB(36, 36, 46), BorderSizePixel = 0, Position = UDim2.new(1, -66, 0, 0), Size = UDim2.new(0, 22, 0, 22), Font = Enum.Font.SourceSans, Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14})
Create("ImageLabel", {Parent = MinimizeButton, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Position = UDim2.new(0, 7, 0, 7), Size = UDim2.new(0, 8, 0, 8), Image = "http://www.roblox.com/asset/?id=5597105827"})

Create("UICorner", {Parent = Background, CornerRadius = UDim.new(0, 8)})

local ToolTip = Create("Frame", {Parent = AnimSpy, BackgroundColor3 = Color3.fromRGB(26, 26, 34), BackgroundTransparency = 0, BorderSizePixel = 0, Size = UDim2.new(0, 200, 0, 50), ZIndex = 3, Visible = false})
Create("UICorner", {Parent = ToolTip, CornerRadius = UDim.new(0, 6)})
Create("UIStroke", {Parent = ToolTip, Color = Color3.fromRGB(55, 55, 72), Thickness = 1})
local ToolTipLabel = Create("TextLabel", {Parent = ToolTip, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Position = UDim2.new(0, 6, 0, 4), Size = UDim2.new(1, -12, 1, -8), ZIndex = 3, Font = Enum.Font.Gotham, Text = "", TextColor3 = Color3.fromRGB(205, 205, 220), TextSize = 12, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top})

local customCursor = Create("ImageLabel", {Parent = AnimSpy, Visible = false, Size = UDim2.fromOffset(200, 200), ZIndex = 1e9, BackgroundTransparency = 1, Image = ""})

local layoutOrderNum = 999999999
local mainClosing = false
local closed = false
local sideClosing = false
local sideClosed = false
local maximized = false
local excluded = {}
local logs = {}
local selected = nil
local mouseInGui = false
local connections = {}
local remotesFadeIn
local rightFadeIn
local previewCharClone = nil
local previewWorldModel = nil
local previewTrack = nil
local previewRotConn = nil

local codebox = {
    setRaw = function(self, text)
        CodeLabel.Text = tostring(text or "")
    end,
    getString = function(self)
        return CodeLabel.Text
    end
}

local function scaleToolTip()
    local size = TextService:GetTextSize(ToolTipLabel.Text, ToolTipLabel.TextSize, ToolTipLabel.Font, Vector2.new(196, math.huge))
    ToolTipLabel.Size = UDim2.new(0, size.X, 0, size.Y)
    ToolTip.Size = UDim2.new(0, size.X + 4, 0, size.Y + 4)
end

local function onToggleButtonHover()
    TweenService:Create(Simple, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
end

local function onToggleButtonUnhover()
    TweenService:Create(Simple, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end

local function onXButtonHover()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}):Play()
end

local function onXButtonUnhover()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(36, 36, 46)}):Play()
end

local function onToggleButtonClick() end

local function isInResizeRange(p)
    local relativeP = p - Background.AbsolutePosition
    local range = 5
    if relativeP.X >= TopBar.AbsoluteSize.X - range and relativeP.Y >= Background.AbsoluteSize.Y - range
        and relativeP.X <= TopBar.AbsoluteSize.X and relativeP.Y <= Background.AbsoluteSize.Y then
        return true, "B"
    elseif relativeP.X >= TopBar.AbsoluteSize.X - range and relativeP.X <= Background.AbsoluteSize.X then
        return true, "X"
    elseif relativeP.Y >= Background.AbsoluteSize.Y - range and relativeP.Y <= Background.AbsoluteSize.Y then
        return true, "Y"
    end
    return false
end

local function isInDragRange(p)
    local relativeP = p - Background.AbsolutePosition
    local topbarAS = TopBar.AbsoluteSize
    return relativeP.X <= topbarAS.X - CloseButton.AbsoluteSize.X * 3
        and relativeP.X >= 0
        and relativeP.Y <= topbarAS.Y
        and relativeP.Y >= 0
end

local function validateSize()
    local x, y = Background.AbsoluteSize.X, Background.AbsoluteSize.Y
    local screenSize = workspace.CurrentCamera.ViewportSize
    if x + Background.AbsolutePosition.X > screenSize.X then
        x = math.max(screenSize.X - Background.AbsolutePosition.X, 450)
    elseif y + Background.AbsolutePosition.Y > screenSize.Y then
        y = math.max(screenSize.Y - Background.AbsolutePosition.Y, 268)
    end
    Background.Size = UDim2.fromOffset(x, y)
end

local function maximizeSize(speed)
    speed = speed or 0.05
    TweenService:Create(LeftPanel, TweenInfo.new(speed), {Size = UDim2.fromOffset(LeftPanel.AbsoluteSize.X, Background.AbsoluteSize.Y - TopBar.AbsoluteSize.Y)}):Play()
    TweenService:Create(RightPanel, TweenInfo.new(speed), {Size = UDim2.fromOffset(Background.AbsoluteSize.X - LeftPanel.AbsoluteSize.X, Background.AbsoluteSize.Y - TopBar.AbsoluteSize.Y)}):Play()
    TweenService:Create(TopBar, TweenInfo.new(speed), {Size = UDim2.fromOffset(Background.AbsoluteSize.X, TopBar.AbsoluteSize.Y)}):Play()
    TweenService:Create(ScrollingFrame, TweenInfo.new(speed), {Size = UDim2.fromOffset(Background.AbsoluteSize.X - LeftPanel.AbsoluteSize.X, 110), Position = UDim2.fromOffset(0, Background.AbsoluteSize.Y - 119 - TopBar.AbsoluteSize.Y)}):Play()
    TweenService:Create(CodeBox, TweenInfo.new(speed), {Size = UDim2.fromOffset(Background.AbsoluteSize.X - LeftPanel.AbsoluteSize.X, Background.AbsoluteSize.Y - 119 - TopBar.AbsoluteSize.Y)}):Play()
    TweenService:Create(LogList, TweenInfo.new(speed), {Size = UDim2.fromOffset(LogList.AbsoluteSize.X, Background.AbsoluteSize.Y - TopBar.AbsoluteSize.Y - 18)}):Play()
end

local function minimizeSize(speed)
    speed = speed or 0.05
    TweenService:Create(LeftPanel, TweenInfo.new(speed), {Size = UDim2.fromOffset(LeftPanel.AbsoluteSize.X, Background.AbsoluteSize.Y - TopBar.AbsoluteSize.Y)}):Play()
    TweenService:Create(RightPanel, TweenInfo.new(speed), {Size = UDim2.fromOffset(0, Background.AbsoluteSize.Y - TopBar.AbsoluteSize.Y)}):Play()
    TweenService:Create(TopBar, TweenInfo.new(speed), {Size = UDim2.fromOffset(LeftPanel.AbsoluteSize.X, TopBar.AbsoluteSize.Y)}):Play()
    TweenService:Create(ScrollingFrame, TweenInfo.new(speed), {Size = UDim2.fromOffset(0, 119), Position = UDim2.fromOffset(0, Background.AbsoluteSize.Y - 119 - TopBar.AbsoluteSize.Y)}):Play()
    TweenService:Create(CodeBox, TweenInfo.new(speed), {Size = UDim2.fromOffset(0, Background.AbsoluteSize.Y - 119 - TopBar.AbsoluteSize.Y)}):Play()
    TweenService:Create(LogList, TweenInfo.new(speed), {Size = UDim2.fromOffset(LogList.AbsoluteSize.X, Background.AbsoluteSize.Y - TopBar.AbsoluteSize.Y - 18)}):Play()
end

local function bringBackOnResize()
    validateSize()
    if sideClosed then minimizeSize() else maximizeSize() end
    local currentX = Background.AbsolutePosition.X
    local currentY = Background.AbsolutePosition.Y
    local viewportSize = workspace.CurrentCamera.ViewportSize
    if currentX < 0 then
        currentX = 0
    elseif currentX > viewportSize.X - (sideClosed and 131 or Background.AbsoluteSize.X) then
        currentX = viewportSize.X - (sideClosed and 131 or Background.AbsoluteSize.X)
    end
    if currentY < 0 then
        currentY = 0
    elseif currentY > viewportSize.Y - (closed and 19 or Background.AbsoluteSize.Y) - GuiInset.Y then
        currentY = viewportSize.Y - (closed and 19 or Background.AbsoluteSize.Y) - GuiInset.Y
    end
    TweenService:Create(Background, TweenInfo.new(0.1), {Position = UDim2.new(0, currentX, 0, currentY)}):Play()
end

local function connectResize()
    if not workspace.CurrentCamera then
        workspace:GetPropertyChangedSignal("CurrentCamera"):Wait()
    end
    local lastCam = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(bringBackOnResize)
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        lastCam:Disconnect()
        lastCam = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(bringBackOnResize)
    end)
end

local function fadeOut(elements)
    local data = {}
    for _, v in next, elements do
        if typeof(v) == "Instance" and v:IsA("GuiObject") and v.Visible then
            task.spawn(function()
                data[v] = {BackgroundTransparency = v.BackgroundTransparency}
                TweenService:Create(v, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
                if v:IsA("TextBox") or v:IsA("TextButton") or v:IsA("TextLabel") then
                    data[v].TextTransparency = v.TextTransparency
                    TweenService:Create(v, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
                elseif v:IsA("ImageButton") or v:IsA("ImageLabel") then
                    data[v].ImageTransparency = v.ImageTransparency
                    TweenService:Create(v, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
                end
                task.delay(0.5, function()
                    v.Visible = false
                    for i, x in next, data[v] do v[i] = x end
                    data[v] = true
                end)
            end)
        end
    end
    return function()
        for i in next, data do
            task.spawn(function()
                local props = {BackgroundTransparency = i.BackgroundTransparency}
                i.BackgroundTransparency = 1
                TweenService:Create(i, TweenInfo.new(0.5), {BackgroundTransparency = props.BackgroundTransparency}):Play()
                if i:IsA("TextBox") or i:IsA("TextButton") or i:IsA("TextLabel") then
                    props.TextTransparency = i.TextTransparency
                    i.TextTransparency = 1
                    TweenService:Create(i, TweenInfo.new(0.5), {TextTransparency = props.TextTransparency}):Play()
                elseif i:IsA("ImageButton") or i:IsA("ImageLabel") then
                    props.ImageTransparency = i.ImageTransparency
                    i.ImageTransparency = 1
                    TweenService:Create(i, TweenInfo.new(0.5), {ImageTransparency = props.ImageTransparency}):Play()
                end
                i.Visible = true
            end)
        end
    end
end

local function toggleMinimize(override)
    if mainClosing and not override or maximized then return end
    mainClosing = true
    closed = not closed
    if closed then
        if not sideClosed then
            sideClosing = true
            sideClosed = true
            fadeOut(RightPanel:GetDescendants())
            task.wait(0.5)
            minimizeSize(0.5)
            task.wait(0.5)
            RightPanel.Visible = false
            sideClosing = false
        end
        LeftPanel.Visible = true
        remotesFadeIn = fadeOut(LeftPanel:GetDescendants())
        TweenService:Create(LeftPanel, TweenInfo.new(0.5), {Size = UDim2.fromOffset(LeftPanel.AbsoluteSize.X, 0)}):Play()
        task.wait(0.5)
    else
        TweenService:Create(LeftPanel, TweenInfo.new(0.5), {Size = UDim2.fromOffset(LeftPanel.AbsoluteSize.X, Background.AbsoluteSize.Y - TopBar.AbsoluteSize.Y)}):Play()
        task.wait(0.5)
        if remotesFadeIn then
            remotesFadeIn()
            remotesFadeIn = nil
        end
        bringBackOnResize()
    end
    mainClosing = false
end

local function toggleSideTray(override)
    if sideClosing and not override or maximized then return end
    sideClosing = true
    sideClosed = not sideClosed
    if sideClosed then
        rightFadeIn = fadeOut(RightPanel:GetDescendants())
        task.wait(0.5)
        minimizeSize(0.5)
        task.wait(0.5)
        RightPanel.Visible = false
    else
        if closed then
            closed = false
            TweenService:Create(LeftPanel, TweenInfo.new(0.5), {Size = UDim2.fromOffset(LeftPanel.AbsoluteSize.X, Background.AbsoluteSize.Y - TopBar.AbsoluteSize.Y)}):Play()
            task.wait(0.5)
            if remotesFadeIn then remotesFadeIn(); remotesFadeIn = nil end
        end
        RightPanel.Visible = true
        maximizeSize(0.5)
        task.wait(0.5)
        if rightFadeIn then rightFadeIn(); rightFadeIn = nil end
        bringBackOnResize()
    end
    sideClosing = false
end

local function toggleMaximize()
    if not sideClosed and not maximized then
        maximized = true
        local disable = Instance.new("TextButton")
        local prevSize = UDim2.new(0, CodeBox.AbsoluteSize.X, 0, CodeBox.AbsoluteSize.Y)
        local prevPos = UDim2.new(0, CodeBox.AbsolutePosition.X, 0, CodeBox.AbsolutePosition.Y)
        disable.Size = UDim2.new(1, 0, 1, 0)
        disable.BackgroundColor3 = Color3.new()
        disable.BorderSizePixel = 0
        disable.Text = ""
        disable.ZIndex = 3
        disable.BackgroundTransparency = 1
        disable.AutoButtonColor = false
        CodeBox.ZIndex = 4
        CodeBox.Position = prevPos
        CodeBox.Size = prevSize
        TweenService:Create(CodeBox, TweenInfo.new(0.5), {Size = UDim2.new(0.5, 0, 0.5, 0), Position = UDim2.new(0.25, 0, 0.25, 0)}):Play()
        TweenService:Create(disable, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
        disable.MouseButton1Click:Connect(function()
            local ml = UserInputService:GetMouseLocation()
            if ml.Y + GuiInset.Y >= CodeBox.AbsolutePosition.Y
                and ml.Y + GuiInset.Y <= CodeBox.AbsolutePosition.Y + CodeBox.AbsoluteSize.Y
                and ml.X >= CodeBox.AbsolutePosition.X
                and ml.X <= CodeBox.AbsolutePosition.X + CodeBox.AbsoluteSize.X then
                return
            end
            TweenService:Create(CodeBox, TweenInfo.new(0.5), {Size = prevSize, Position = prevPos}):Play()
            TweenService:Create(disable, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            task.wait(0.5)
            disable:Destroy()
            CodeBox.Size = UDim2.new(1, 0, 0.5, 0)
            CodeBox.Position = UDim2.new(0, 0, 0, 0)
            CodeBox.ZIndex = 0
            maximized = false
        end)
        disable.Parent = AnimSpy
    end
end

local function makeToolTip(enable, text)
    if enable and text then
        if ToolTip.Visible then
            ToolTip.Visible = false
            if connections["ToolTip"] then connections["ToolTip"]:Disconnect() end
        end
        local first = true
        connections["ToolTip"] = RunService.RenderStepped:Connect(function()
            local MousePos = UserInputService:GetMouseLocation()
            local topLeft = MousePos + Vector2.new(20, -15)
            local bottomRight = topLeft + ToolTip.AbsoluteSize
            local vp = workspace.CurrentCamera.ViewportSize
            if topLeft.X < 0 then
                topLeft = Vector2.new(0, topLeft.Y)
            elseif bottomRight.X > vp.X then
                topLeft = Vector2.new(vp.X - ToolTip.AbsoluteSize.X, topLeft.Y)
            end
            if topLeft.Y < 0 then
                topLeft = Vector2.new(topLeft.X, 0)
            elseif bottomRight.Y > vp.Y - 35 then
                topLeft = Vector2.new(topLeft.X, vp.Y - ToolTip.AbsoluteSize.Y - 35)
            end
            if topLeft.X <= MousePos.X and topLeft.Y <= MousePos.Y then
                topLeft = Vector2.new(MousePos.X - ToolTip.AbsoluteSize.X - 2, MousePos.Y - ToolTip.AbsoluteSize.Y - 2)
            end
            if first then
                ToolTip.Position = UDim2.fromOffset(topLeft.X, topLeft.Y)
                first = false
            else
                ToolTip:TweenPosition(UDim2.fromOffset(topLeft.X, topLeft.Y), "Out", "Linear", 0.1)
            end
        end)
        ToolTipLabel.Text = text
        ToolTipLabel.TextScaled = true
        ToolTip.Visible = true
    else
        if ToolTip.Visible then
            ToolTip.Visible = false
            if connections["ToolTip"] then connections["ToolTip"]:Disconnect() end
        end
    end
end

local function onBarInput(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local lastPos = UserInputService:GetMouseLocation()
        local offset = Background.AbsolutePosition - lastPos
        local currentPos = offset + lastPos
        if not connections["drag"] then
            connections["drag"] = RunService.RenderStepped:Connect(function()
                local newPos = UserInputService:GetMouseLocation()
                if newPos ~= lastPos then
                    local currentX = (offset + newPos).X
                    local currentY = (offset + newPos).Y
                    local vp = workspace.CurrentCamera.ViewportSize
                    if currentX < 0 and currentX < currentPos.X then currentX = 0
                    elseif currentX > vp.X - (sideClosed and 131 or TopBar.AbsoluteSize.X) and currentX > currentPos.X then
                        currentX = vp.X - (sideClosed and 131 or TopBar.AbsoluteSize.X)
                    end
                    if currentY < 0 and currentY < currentPos.Y then currentY = 0
                    elseif currentY > vp.Y - (closed and 19 or Background.AbsoluteSize.Y) - GuiInset.Y and currentY > currentPos.Y then
                        currentY = vp.Y - (closed and 19 or Background.AbsoluteSize.Y) - GuiInset.Y
                    end
                    currentPos = Vector2.new(currentX, currentY)
                    lastPos = newPos
                    TweenService:Create(Background, TweenInfo.new(0.1), {Position = UDim2.new(0, currentPos.X, 0, currentPos.Y)}):Play()
                end
            end)
        end
        table.insert(connections, UserInputService.InputEnded:Connect(function(inputE)
            if input == inputE and connections["drag"] then
                connections["drag"]:Disconnect()
                connections["drag"] = nil
            end
        end))
    end
end

local function backgroundUserInput(input)
    local mousePos = UserInputService:GetMouseLocation() - GuiInset
    local inResizeRange, rtype = isInResizeRange(mousePos)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and inResizeRange then
        local lastPos = UserInputService:GetMouseLocation()
        local offset = Background.AbsoluteSize - lastPos
        local currentPos = lastPos + offset
        if not connections["ANIMSPY_RESIZE"] then
            connections["ANIMSPY_RESIZE"] = RunService.RenderStepped:Connect(function()
                local newPos = UserInputService:GetMouseLocation()
                if newPos ~= lastPos then
                    local currentX = math.max((newPos + offset).X, 400)
                    local currentY = math.max((newPos + offset).Y, 280)
                    currentPos = Vector2.new(currentX, currentY)
                    Background.Size = UDim2.fromOffset(
                        (not sideClosed and not closed and (rtype == "X" or rtype == "B")) and currentPos.X or Background.AbsoluteSize.X,
                        (not closed and (rtype == "Y" or rtype == "B")) and currentPos.Y or Background.AbsoluteSize.Y
                    )
                    validateSize()
                    if sideClosed then minimizeSize() else maximizeSize() end
                    lastPos = newPos
                end
            end)
        end
        table.insert(connections, UserInputService.InputEnded:Connect(function(inputE)
            if input == inputE and connections["ANIMSPY_RESIZE"] then
                connections["ANIMSPY_RESIZE"]:Disconnect()
                connections["ANIMSPY_RESIZE"] = nil
            end
        end))
    elseif isInDragRange(mousePos) then
        onBarInput(input)
    end
end

local function mouseEntered()
    if connections["ANIMSPY_CURSOR"] then
        connections["ANIMSPY_CURSOR"]:Disconnect()
        connections["ANIMSPY_CURSOR"] = nil
    end
    connections["ANIMSPY_CURSOR"] = RunService.RenderStepped:Connect(function()
        UserInputService.MouseIconEnabled = not mouseInGui
        customCursor.Visible = mouseInGui
        if mouseInGui then
            local mouseLocation = UserInputService:GetMouseLocation() - GuiInset
            customCursor.Position = UDim2.fromOffset(mouseLocation.X - customCursor.AbsoluteSize.X / 2, mouseLocation.Y - customCursor.AbsoluteSize.Y / 2)
            local inRange, rtype = isInResizeRange(mouseLocation)
            if inRange and not closed then
                if not sideClosed then
                    customCursor.Image = rtype == "B" and "rbxassetid://6065821980"
                        or rtype == "X" and "rbxassetid://6065821086"
                        or "rbxassetid://6065821596"
                elseif rtype == "Y" or rtype == "B" then
                    customCursor.Image = "rbxassetid://6065821596"
                end
            elseif customCursor.Image ~= "rbxassetid://6065775281" then
                customCursor.Image = "rbxassetid://6065775281"
            end
        else
            connections["ANIMSPY_CURSOR"]:Disconnect()
            connections["ANIMSPY_CURSOR"] = nil
        end
    end)
end

local function updateFunctionCanvas()
    ScrollingFrame.CanvasSize = UDim2.fromOffset(UIGridLayout.AbsoluteContentSize.X, UIGridLayout.AbsoluteContentSize.Y)
end

local function updateRemoteCanvas()
    LogList.CanvasSize = UDim2.fromOffset(UIListLayout.AbsoluteContentSize.X, UIListLayout.AbsoluteContentSize.Y)
end

local function clearPreview()
    if previewRotConn then
        previewRotConn:Disconnect()
        previewRotConn = nil
    end
    if previewTrack then
        pcall(function() previewTrack:Stop(0) end)
        previewTrack = nil
    end
    if previewWorldModel then
        pcall(function() previewWorldModel:Destroy() end)
        previewWorldModel = nil
        previewCharClone = nil
    elseif previewCharClone then
        pcall(function() previewCharClone:Destroy() end)
        previewCharClone = nil
    end
end

local function previewAnim(assetId)
    clearPreview()
    local char = Players.LocalPlayer.Character
    if not char then return end

    local wasArchivable = char.Archivable
    char.Archivable = true
    local clone = char:Clone()
    char.Archivable = wasArchivable
    if not clone then return end

    for _, v in ipairs(clone:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then
            v:Destroy()
        end
    end
    for _, v in ipairs(clone:GetChildren()) do
        if v:IsA("Accessory") then v:Destroy() end
    end

    local worldModel = Instance.new("WorldModel")
    worldModel.Parent = ViewportFrame
    clone.Parent = worldModel
    previewCharClone = clone
    previewWorldModel = worldModel

    local hrp = clone:FindFirstChild("HumanoidRootPart")
    local origin = hrp and (hrp.Position + Vector3.new(0, 1, 0)) or Vector3.new(0, 3, 0)

    local angle = 0
    previewRotConn = RunService.RenderStepped:Connect(function(dt)
        if not previewCharClone then return end
        angle = (angle + dt * 0.8) % (math.pi * 2)
        ViewportCamera.CFrame = CFrame.new(
            origin + Vector3.new(math.sin(angle) * 5.5, 0.5, math.cos(angle) * 5.5),
            origin
        )
    end)

    local humanoid = clone:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end
    for _, t in ipairs(animator:GetPlayingAnimationTracks()) do t:Stop(0) end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. assetId
    local ok, track = pcall(animator.LoadAnimation, animator, anim)
    if ok and track then
        track.Looped = true
        track:Play()
        previewTrack = track
    end
end

local function eventSelect(frame)
    if selected and selected.Button then
        TweenService:Create(selected.Button, TweenInfo.new(0.5), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
        selected = nil
    end
    for _, v in next, logs do
        if frame == v.Log then selected = v; break end
    end
    if selected then
        TweenService:Create(selected.Button, TweenInfo.new(0.5), {BackgroundColor3 = Color3.fromRGB(92, 126, 229)}):Play()
        codebox:setRaw(selected.Text or "")
        if selected.assetId then
            task.spawn(previewAnim, selected.assetId)
        end
    end
    if sideClosed then
        task.spawn(toggleSideTray)
    end
end

function newButton(name, description, onClick)
    local FunctionTemplate = Create("Frame", {Name = "FunctionTemplate", Parent = ScrollingFrame, BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Size = UDim2.new(0, 117, 0, 24)})
    local Button = Create("TextButton", {Name = "Button", Parent = FunctionTemplate, BackgroundColor3 = Color3.fromRGB(34, 34, 44), BorderSizePixel = 0, Size = UDim2.new(1, -8, 1, -6), Position = UDim2.new(0, 4, 0, 3), AutoButtonColor = false, Font = Enum.Font.Gotham, Text = name, TextColor3 = Color3.fromRGB(195, 195, 215), TextSize = 11})
    Create("UICorner", {Parent = Button, CornerRadius = UDim.new(0, 5)})
    Button.MouseEnter:Connect(function() TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 66)}):Play() end)
    Button.MouseLeave:Connect(function() TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(34, 34, 44)}):Play() end)
    Button.MouseEnter:Connect(function() makeToolTip(true, description()) end)
    Button.MouseLeave:Connect(function()
        makeToolTip(false)
        TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(34, 34, 44)}):Play()
    end)
    FunctionTemplate.AncestryChanged:Connect(function() makeToolTip(false) end)
    if onClick then
        Button.MouseButton1Click:Connect(function(...) onClick(FunctionTemplate, ...) end)
    end
    updateFunctionCanvas()
    return FunctionTemplate
end

function newLog(name, logType, text)
    if layoutOrderNum < 1 then layoutOrderNum = 999999999 end
    local accentColor = logType == "event" and Color3.fromRGB(112, 200, 130) or Color3.fromRGB(115, 100, 240)
    local RemoteTemplate = Create("Frame", {LayoutOrder = layoutOrderNum, Name = "RemoteTemplate", Parent = LogList, BackgroundColor3 = Color3.fromRGB(30, 30, 38), BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 26)})
    Create("UICorner", {Parent = RemoteTemplate, CornerRadius = UDim.new(0, 5)})
    Create("Frame", {Name = "ColorBar", Parent = RemoteTemplate, BackgroundColor3 = accentColor, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 4), Size = UDim2.new(0, 3, 1, -8), ZIndex = 2})
    Create("UICorner", {Parent = RemoteTemplate:FindFirstChild("ColorBar"), CornerRadius = UDim.new(1, 0)})
    Create("TextLabel", {TextTruncate = Enum.TextTruncate.AtEnd, Name = "Text", Parent = RemoteTemplate, BackgroundTransparency = 1, Position = UDim2.new(0, 9, 0, 0), Size = UDim2.new(1, -12, 1, 0), ZIndex = 2, Font = Enum.Font.Gotham, Text = name, TextColor3 = Color3.fromRGB(195, 195, 215), TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left})
    local Button = Create("TextButton", {Name = "Button", Parent = RemoteTemplate, BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), AutoButtonColor = false, Font = Enum.Font.SourceSans, Text = "", TextColor3 = Color3.new(0, 0, 0), TextSize = 14})

    local log = {Name = name, Log = RemoteTemplate, Button = Button, Text = text or ("-- " .. name)}
    logs[#logs + 1] = log
    Button.MouseButton1Click:Connect(function() eventSelect(RemoteTemplate) end)
    layoutOrderNum -= 1
    updateRemoteCanvas()
    return log
end

local function shutdown()
    clearPreview()
    for _, connection in next, connections do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    UserInputService.MouseIconEnabled = true
    AnimSpy:Destroy()
end

Background.MouseEnter:Connect(function()
    mouseInGui = true
    mouseEntered()
end)
Background.MouseLeave:Connect(function()
    mouseInGui = false
    mouseEntered()
end)
ToolTipLabel:GetPropertyChangedSignal("Text"):Connect(scaleToolTip)
MinimizeButton.MouseButton1Click:Connect(function() task.spawn(toggleMinimize) end)
MaximizeButton.MouseButton1Click:Connect(function() task.spawn(toggleSideTray) end)
Simple.MouseButton1Click:Connect(onToggleButtonClick)
CloseButton.MouseEnter:Connect(onXButtonHover)
CloseButton.MouseLeave:Connect(onXButtonUnhover)
Simple.MouseEnter:Connect(onToggleButtonHover)
Simple.MouseLeave:Connect(onToggleButtonUnhover)
CloseButton.MouseButton1Click:Connect(shutdown)
table.insert(connections, UserInputService.InputBegan:Connect(backgroundUserInput))
connectResize()

AnimSpy.Enabled = true
bringBackOnResize()
AnimSpy.Parent = CoreGui

local function flashButton(frame, msg, duration)
    local btn = frame:FindFirstChild("Button")
    if not btn then return end
    local orig = btn.Text
    btn.Text = msg
    task.delay(duration or 1.5, function()
        if btn and btn.Parent then btn.Text = orig end
    end)
end

newButton("Copy Code", function() return "Copy replay script to clipboard" end, function(frame)
    setclipboard(codebox:getString())
    flashButton(frame, "Copied!")
end)

newButton("Copy ID", function() return "Copy just the animation ID to clipboard" end, function(frame)
    if selected then
        local id = selected.Name:match("%d+")
        if id then
            setclipboard("rbxassetid://" .. id)
            flashButton(frame, "Copied!")
        end
    end
end)

newButton("Exclude", function() return "Exclude this animation ID from future logs" end, function(frame)
    if not selected then return end
    local id = selected.assetId
    local name = selected.animName or id
    if not id then return end
    excluded[id] = true
    selected.Log:Destroy()
    for i, v in next, logs do
        if v == selected then table.remove(logs, i); break end
    end
    selected = nil
    codebox:setRaw("-- Select a log entry to view details")
    flashButton(frame, "Excluded!")
end)

newButton("Clr Logs", function() return "Clear all log entries" end, function(frame)
    for _, v in next, LogList:GetChildren() do
        if not v:IsA("UIListLayout") then v:Destroy() end
    end
    table.clear(logs)
    selected = nil
    codebox:setRaw("-- Select a log entry to view details")
    flashButton(frame, "Cleared!")
end)

local MAX_LOGS = 300
local animConnections = {}

local function formatId(id)
    return id:match("%d+") or id
end

local function onAnimPlayed(track)
    local rawId = track.Animation.AnimationId
    if excluded[formatId(rawId)] then return end

    if #logs >= MAX_LOGS then
        local oldest = table.remove(logs, 1)
        if oldest and oldest.Log then oldest.Log:Destroy() end
    end

    local assetId = formatId(rawId)
    local animName = (track.Animation.Name ~= "" and track.Animation.Name) or ("anim_" .. assetId)
    local label = animName .. "  [" .. assetId .. "]"

    local replayScript = table.concat({
        '-- ' .. animName .. '  (rbxassetid://' .. assetId .. ')',
        'local Players = game:GetService("Players")',
        'local humanoid = Players.LocalPlayer.Character:WaitForChild("Humanoid")',
        'local anim = Instance.new("Animation")',
        'anim.AnimationId = "rbxassetid://' .. assetId .. '"',
        'local track = humanoid:LoadAnimation(anim)',
        'track:Play()',
    }, "\n")

    local entry = newLog(label, "event", replayScript)
    entry.assetId = assetId
    entry.animName = animName
end

local function watchAnimator(animator)
    table.insert(animConnections, animator.AnimationPlayed:Connect(onAnimPlayed))
end

local function watchCharacter(character)
    task.spawn(function()
        local humanoid = character:WaitForChild("Humanoid", 10)
        if not humanoid then return end
        local animator = humanoid:WaitForChild("Animator", 10)
        if not animator then return end
        watchAnimator(animator)
    end)
end

local lp = Players.LocalPlayer
if lp.Character then
    watchCharacter(lp.Character)
end
table.insert(animConnections, lp.CharacterAdded:Connect(watchCharacter))

local _origShutdown = shutdown
shutdown = function()
    for _, c in next, animConnections do c:Disconnect() end
    _origShutdown()
end
