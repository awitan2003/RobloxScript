-- ============================================
-- LGL MOD MENU - Roblox replica (matches Android template look)
-- Features: touch + mouse support, draggable menu, floating icon,
-- settings page, auto-size toggle, hold-to-kill
-- ============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "LGL_ModMenu"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = player:WaitForChild("PlayerGui")

-- ============================================
-- COLORS (taken from the Android screenshots)
-- ============================================
local C = {
	BG        = Color3.fromRGB(28, 42, 54),
	Category  = Color3.fromRGB(44, 62, 78),
	Button    = Color3.fromRGB(22, 32, 42),
	Stroke    = Color3.fromRGB(58, 78, 98),
	Title     = Color3.fromRGB(110, 185, 240),
	Green     = Color3.fromRGB(50, 230, 80),
	Text      = Color3.fromRGB(255, 255, 255),
	TextDim   = Color3.fromRGB(185, 195, 205),
	TrackOff  = Color3.fromRGB(80, 60, 62),
	TrackOn   = Color3.fromRGB(130, 40, 44),
	KnobOff   = Color3.fromRGB(190, 190, 190),
	KnobOn    = Color3.fromRGB(255, 35, 40),
	SlideTrk  = Color3.fromRGB(95, 105, 115),
	Teal      = Color3.fromRGB(60, 190, 175),
	Red       = Color3.fromRGB(255, 40, 40),
}

-- ============================================
-- HELPERS
-- ============================================
local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do
		o[k] = v
	end
	o.Parent = parent
	return o
end

local function corner(o, r)
	return new("UICorner", { CornerRadius = UDim.new(0, r) }, o)
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
end

-- Makes `target` draggable by `handle`. onClick fires if released without moving.
local function makeDraggable(handle, target, onClick, onMoved)
	local dragging, dragStart, startPos, moved = false, nil, nil, 0
	handle.InputBegan:Connect(function(input)
		if isPress(input) then
			dragging = true
			moved = 0
			dragStart = input.Position
			startPos = target.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and isMove(input) then
			local d = input.Position - dragStart
			moved = math.max(moved, d.Magnitude)
			if moved > 8 then
				target.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + d.X,
					startPos.Y.Scale, startPos.Y.Offset + d.Y
				)
				if onMoved then onMoved() end
			end
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if dragging and isPress(input) then
			dragging = false
			if moved <= 8 and onClick then
				onClick()
			end
		end
	end)
end

-- ============================================
-- MAIN FRAME
-- ============================================
local WIDTH = 310
local HEADER_H = 62
local BOTTOM_H = 46
local MAX_CONTENT = 300
local MIN_CONTENT = 140
local FIXED_CONTENT = 200

local main = new("Frame", {
	Name = "Main",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.fromOffset(WIDTH, HEADER_H + MAX_CONTENT + BOTTOM_H),
	BackgroundColor3 = C.BG,
	BackgroundTransparency = 0.04,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, gui)
corner(main, 6)
new("UIStroke", { Color = C.Stroke, Thickness = 1 }, main)

-- ============================================
-- HEADER
-- ============================================
local header = new("Frame", {
	Name = "Header",
	Size = UDim2.new(1, 0, 0, HEADER_H),
	BackgroundTransparency = 1,
}, main)

local title = new("TextLabel", {
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(30, 6),
	Size = UDim2.new(1, -60, 0, 28),
	Font = Enum.Font.GothamBold,
	Text = "Modded by (yourname)",
	TextColor3 = C.Title,
	TextSize = 18,
	TextXAlignment = Enum.TextXAlignment.Center,
}, header)

local marqueeClip = new("Frame", {
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(0, 38),
	Size = UDim2.new(1, 0, 0, 18),
	ClipsDescendants = true,
}, header)

local marquee = new("TextLabel", {
	BackgroundTransparency = 1,
	Position = UDim2.new(1, 0, 0, 0),
	Size = UDim2.new(0, 0, 1, 0),
	AutomaticSize = Enum.AutomaticSize.X,
	Font = Enum.Font.GothamBold,
	RichText = true,
	Text = '<font color="#32e650">Modded by LGL</font>  <font color="#ffffff">|  https://github.com/LGLTeam  |  Lorem Ipsum is simply dummy text of the printing and typesetting industry</font>',
	TextColor3 = C.Text,
	TextSize = 11,
	TextWrapped = false,
	TextXAlignment = Enum.TextXAlignment.Left,
}, marqueeClip)

task.spawn(function()
	task.wait(0.2)
	while gui.Parent do
		local w = marquee.AbsoluteSize.X
		local cw = marqueeClip.AbsoluteSize.X
		marquee.Position = UDim2.new(0, cw, 0, 0)
		local tw = TweenService:Create(
			marquee,
			TweenInfo.new((cw + w) / 50, Enum.EasingStyle.Linear),
			{ Position = UDim2.new(0, -w, 0, 0) }
		)
		tw:Play()
		tw.Completed:Wait()
	end
end)

local gear = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -8, 0, 4),
	Size = UDim2.fromOffset(30, 30),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "⚙",
	TextColor3 = C.Title,
	TextSize = 24,
	ZIndex = 3,
}, header)

-- ============================================
-- CONTENT + PAGES
-- ============================================
local content = new("Frame", {
	Name = "Content",
	Position = UDim2.fromOffset(0, HEADER_H),
	Size = UDim2.new(1, 0, 1, -(HEADER_H + BOTTOM_H)),
	BackgroundTransparency = 1,
	ClipsDescendants = true,
}, main)

local function makePage(name)
	local page = new("ScrollingFrame", {
		Name = name,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Color3.fromRGB(110, 130, 150),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		ElasticBehavior = Enum.ElasticBehavior.Never,
	}, content)
	new("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = UDim.new(0, 3),
	}, page)
	return page
end

local featPage = makePage("Features")
local setPage = makePage("Settings")
setPage.Visible = false

-- ============================================
-- WIDGET BUILDERS
-- ============================================
local function makeCategory(parent, text, order)
	return new("TextLabel", {
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = C.Category,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamBold,
		Text = text,
		TextColor3 = C.Text,
		TextSize = 14,
		LayoutOrder = order,
	}, parent)
end

local function makeToggle(parent, text, order, default, callback)
	local row = new("TextButton", {
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = order,
	}, parent)

	new("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(8, 0),
		Size = UDim2.new(1, -70, 1, 0),
		Font = Enum.Font.GothamMedium,
		Text = text,
		TextColor3 = C.Text,
		TextSize = 14,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)

	local track = new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -16, 0.5, 0),
		Size = UDim2.fromOffset(38, 16),
		BackgroundColor3 = C.TrackOff,
		BorderSizePixel = 0,
	}, row)
	corner(track, 8)

	local knob = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(22, 22),
		BackgroundColor3 = C.KnobOff,
		BorderSizePixel = 0,
		ZIndex = 2,
	}, track)
	corner(knob, 11)

	local state = default
	local function render(animate)
		local goal = {
			Position = state and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0),
			BackgroundColor3 = state and C.KnobOn or C.KnobOff,
		}
		track.BackgroundColor3 = state and C.TrackOn or C.TrackOff
		if animate then
			TweenService:Create(knob, TweenInfo.new(0.15), goal):Play()
		else
			knob.Position = goal.Position
			knob.BackgroundColor3 = goal.BackgroundColor3
		end
	end
	render(false)

	row.MouseButton1Click:Connect(function()
		state = not state
		render(true)
		if callback then callback(state) end
	end)
end

local function makeSlider(parent, text, order, min, max, default, callback)
	local row = new("Frame", {
		Size = UDim2.new(1, 0, 0, 58),
		BackgroundTransparency = 1,
		LayoutOrder = order,
	}, parent)

	local label = new("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(8, 2),
		Size = UDim2.new(1, -16, 0, 24),
		Font = Enum.Font.GothamMedium,
		RichText = true,
		TextColor3 = C.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)

	local track = new("Frame", {
		Position = UDim2.new(0, 18, 0, 40),
		Size = UDim2.new(1, -36, 0, 4),
		BackgroundColor3 = C.SlideTrk,
		BorderSizePixel = 0,
	}, row)
	corner(track, 2)

	local fill = new("Frame", {
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = C.Teal,
		BorderSizePixel = 0,
	}, track)
	corner(fill, 2)

	local knob = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(18, 18),
		BackgroundColor3 = C.Teal,
		BorderSizePixel = 0,
		ZIndex = 2,
	}, track)
	corner(knob, 9)

	local hit = new("TextButton", {
		Position = UDim2.fromOffset(0, 26),
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 3,
	}, row)

	local function setValue(v)
		v = math.clamp(math.floor(v + 0.5), min, max)
		local rx = (v - min) / (max - min)
		knob.Position = UDim2.new(rx, 0, 0.5, 0)
		fill.Size = UDim2.new(rx, 0, 1, 0)
		label.Text = text .. ': <font color="#32e650">' .. v .. "</font>"
		return v
	end
	setValue(default)

	local dragging = false
	local last = default
	local function fromInput(input)
		local rx = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		local v = setValue(min + (max - min) * rx)
		if v ~= last then
			last = v
			if callback then callback(v) end
		end
	end

	hit.InputBegan:Connect(function(input)
		if isPress(input) then
			dragging = true
			parent.ScrollingEnabled = false
			fromInput(input)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and isMove(input) then
			fromInput(input)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if dragging and isPress(input) then
			dragging = false
			parent.ScrollingEnabled = true
		end
	end)
end

local function makeButton(parent, text, order, callback, textColor)
	local btn = new("TextButton", {
		Size = UDim2.new(1, -16, 0, 44),
		BackgroundColor3 = C.Button,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamMedium,
		Text = text,
		TextColor3 = textColor or C.Text,
		TextSize = 14,
		LayoutOrder = order,
	}, parent)
	corner(btn, 4)
	if callback then
		btn.MouseButton1Click:Connect(callback)
	end
	return btn
end

local function makeText(parent, text, order, size, color)
	return new("TextLabel", {
		Size = UDim2.new(1, -16, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = text,
		TextColor3 = color or C.Text,
		TextSize = size or 14,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = order,
	}, parent)
end

-- ============================================
-- AUTO SIZE (height follows content when enabled)
-- ============================================
local autoSize = false
local activePage = featPage

local function updateSize()
	local ch = FIXED_CONTENT
	if autoSize then
		ch = math.clamp(activePage.AbsoluteCanvasSize.Y, MIN_CONTENT, MAX_CONTENT)
	end
	TweenService:Create(main, TweenInfo.new(0.15), {
		Size = UDim2.fromOffset(WIDTH, HEADER_H + ch + BOTTOM_H),
	}):Play()
end

featPage:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
	if activePage == featPage then updateSize() end
end)
setPage:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
	if activePage == setPage then updateSize() end
end)

-- ============================================
-- FEATURES PAGE  (put your own feature code in the callbacks)
-- ============================================
makeCategory(featPage, "The Category", 0)
makeToggle(featPage, "The toggle", 1, false, function(on) print("The toggle:", on) end)
makeToggle(featPage, "The toggle 2", 2, false, function(on) print("The toggle 2:", on) end)
makeToggle(featPage, "The toggle 3", 3, false, function(on) print("The toggle 3:", on) end)
makeSlider(featPage, "The slider", 4, 0, 10, 1, function(v) print("The slider:", v) end)
makeSlider(featPage, "Kittymemory slider example", 5, 0, 10, 1, function(v) print("Kittymemory slider:", v) end)

-- ============================================
-- SETTINGS PAGE
-- ============================================
local colorAnim = false

makeCategory(setPage, "Settings", 0)
makeToggle(setPage, "Color animation", 1, false, function(on) colorAnim = on end)
makeToggle(setPage, "Auto size vertically", 2, false, function(on)
	autoSize = on
	updateSize()
end)
makeToggle(setPage, "Save feature preferences (Radio Button is not saved)", 3, false)
makeCategory(setPage, "Logcat", 4)
makeText(setPage, "Save logcat if a bug occured and sent it to the modder. Clear logcat and reproduce bug again if the log file is too large", 5, 14)
makeText(setPage, "data/(package name)/files/Mod Menu logs", 6, 12, C.TextDim)
makeButton(setPage, "Save logcat to file", 7, function() print("Logcat saved") end)
makeButton(setPage, "Clear logcat", 8, function() print("Logcat cleared") end)
makeCategory(setPage, "Menu", 9)
local closeSet = makeButton(setPage, "Close settings", 10, nil, C.Red)

-- Subtle title color animation
RunService.RenderStepped:Connect(function()
	if colorAnim then
		title.TextColor3 = Color3.fromHSV(0.58 + 0.04 * math.sin(tick() * 2), 0.5, 1)
	else
		title.TextColor3 = C.Title
	end
end)

-- ============================================
-- BOTTOM BAR
-- ============================================
local bottom = new("Frame", {
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 0, 1, 0),
	Size = UDim2.new(1, 0, 0, BOTTOM_H),
	BackgroundTransparency = 1,
}, main)

local hideBtn = new("TextButton", {
	Position = UDim2.fromOffset(6, 0),
	Size = UDim2.new(0.5, -6, 1, 0),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "HIDE/KILL (HOLD)",
	TextColor3 = C.Title,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left,
}, bottom)

local minBtn = new("TextButton", {
	Position = UDim2.new(0.5, 0, 0, 0),
	Size = UDim2.new(0.5, -6, 1, 0),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "MINIMIZE",
	TextColor3 = C.Title,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
}, bottom)

-- ============================================
-- FLOATING ICON (draggable, tap to open)
-- ============================================
local floatBtn = new("TextButton", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0, 46, 0.7, 0),
	Size = UDim2.fromOffset(64, 64),
	BackgroundColor3 = Color3.fromRGB(14, 20, 28),
	BackgroundTransparency = 0.5,
	BorderSizePixel = 0,
	Font = Enum.Font.GothamBold,
	Text = "OPEN\nMOD MENU",
	TextColor3 = C.Green,
	TextSize = 10,
	Visible = false,
	Active = true,
	ZIndex = 10,
}, gui)
corner(floatBtn, 32)
local floatStroke = new("UIStroke", { Color = C.Green, Thickness = 1.5, Transparency = 0.3 }, floatBtn)

-- ============================================
-- SHOW / HIDE ANIMATION
-- ============================================
local shownPos = main.Position
local function hiddenPos()
	return UDim2.new(0, -WIDTH, shownPos.Y.Scale, shownPos.Y.Offset)
end

-- Text stays fully visible green; only the background gets lighter when hidden
local function setFloatFaded(faded)
	floatBtn.BackgroundTransparency = faded and 0.8 or 0.5
	floatBtn.TextTransparency = 0
	floatStroke.Transparency = faded and 0.6 or 0.3
end

local isOpen = false

local function slideIn()
	if isOpen then return end
	isOpen = true
	floatBtn.Visible = false
	main.Visible = true
	TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = shownPos,
	}):Play()
end

local function slideOut(faded)
	if not isOpen then return end
	isOpen = false
	setFloatFaded(faded)
	TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Position = hiddenPos(),
	}):Play()
	task.delay(0.25, function()
		if not isOpen then
			main.Visible = false
			floatBtn.Visible = true
		end
	end)
end

makeDraggable(header, main, nil, function()
	shownPos = main.Position
end)
makeDraggable(floatBtn, floatBtn, slideIn)

minBtn.MouseButton1Click:Connect(function() slideOut(false) end)

-- Tap = hide (faded icon), hold 1.2s = kill the whole menu
local holdToken = 0
hideBtn.InputBegan:Connect(function(input)
	if isPress(input) then
		holdToken += 1
		local token = holdToken
		hideBtn.TextColor3 = C.Red
		task.delay(1.2, function()
			if holdToken == token and hideBtn.TextColor3 == C.Red then
				gui:Destroy()
			end
		end)
	end
end)
hideBtn.InputEnded:Connect(function(input)
	if isPress(input) then
		local wasHolding = hideBtn.TextColor3 == C.Red
		holdToken += 1
		hideBtn.TextColor3 = C.Title
		if wasHolding then
			slideOut(true)
		end
	end
end)

-- ============================================
-- PAGE SWITCHING
-- ============================================
local function showPage(page)
	featPage.Visible = page == featPage
	setPage.Visible = page == setPage
	activePage = page
	page.CanvasPosition = Vector2.new(0, 0)
	updateSize()
end

gear.MouseButton1Click:Connect(function() showPage(setPage) end)
closeSet.MouseButton1Click:Connect(function() showPage(featPage) end)

-- ============================================
-- START
-- ============================================
main.Position = hiddenPos()
main.Visible = false
task.wait(0.2)
slideIn()
updateSize()

print("LGL Mod Menu loaded")
