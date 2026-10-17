local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local ws = game:GetService("Workspace")
local http_service = game:GetService("HttpService")
local gui_service = game:GetService("GuiService")
local lighting = game:GetService("Lighting")
local run = game:GetService("RunService")
local stats = game:GetService("Stats")
local coregui = game:GetService("CoreGui")
local debris = game:GetService("Debris")
local tween_service = game:GetService("TweenService")
local rs = game:GetService("ReplicatedStorage")

local vec2 = Vector2.new
local vec3 = Vector3.new
local dim2 = UDim2.new
local dim = UDim.new
local rect = Rect.new
local cfr = CFrame.new

local color = Color3.new
local rgb = Color3.fromRGB
local hex = Color3.fromHex
local hsv = Color3.fromHSV
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new

local camera = ws.CurrentCamera
local lp = players.LocalPlayer
local mouse = lp:GetMouse()
local gui_offset = gui_service:GetGuiInset().Y

local max = math.max
local floor = math.floor
local min = math.min
local abs = math.abs

if getgenv().library then
	getgenv().library:unload()
end

-- library init
getgenv().library = {
	flags = {},
	config_flags = {},
	connections = {},
	notifications = {},
	instances = {},
	main_frame = {},
	config_holder,
	current_tab,
	current_element_open,
	dock_button_holder,
	gui,
	sin = 0,
	keybind_path,
	panel_open = false,

	-- [OPT] colorpickers that are currently running an animation (rainbow/fade/fade alpha).
	-- Only these get updated each frame by a single shared Heartbeat loop.
	animated_pickers = {},

	directory = "inactivity",
	folders = {
		"/fonts",
		"/configs",
	},
	font,
}

local flags = library.flags
local config_flags = library.config_flags

local themes = {
	preset = {
		["outline"] = rgb(32, 32, 38), --
		["inline"] = rgb(60, 55, 75), --
		["accent"] = rgb(100, 100, 255), --
		["contrast"] = rgb(35, 35, 47),
		["text"] = rgb(255, 255, 255),
		["unselected_text"] = rgb(57, 57, 57),
		["text_outline"] = rgb(0, 0, 0),
		["glow"] = rgb(100, 100, 255),
		["risky"] = rgb(255, 100, 100),
		["warning"] = hex("#ffa126"),
		["BoxColor"] = rgb(255, 255, 255),
	},
	

	Fatality = {
		["outline"] = hex("#322850"),
		["inline"] = hex("#0F0F28"), 
		["accent"] = hex("#F00F50"), 
		["text"] = hex("#ffffff"),
		["text_outline"] = hex("#0A0A0A"),
		["glow"] = hex("#F00F50"), 
		["risky"] = hex("#F00F70"),
		["warning"] = hex("#ffa126"),
	},
	

	utility = {
		["outline"] = {
			["BackgroundColor3"] = {},
			["Color"] = {},
		},
		["inline"] = {
			["BackgroundColor3"] = {},
		},
		["accent"] = {
			["BackgroundColor3"] = {},
			["TextColor3"] = {},
			["ImageColor3"] = {},
			["BorderColor3"] = {},
			["ScrollBarImageColor3"] = {},
		},
		["contrast"] = {
			["Color"] = {},
		},
		["text"] = {
			["TextColor3"] = {},
		},
		["unselected_text"] = {
			["TextColor3"] = {},
		},
		["risky"] = {
			["TextColor3"] = {},
		},
		["warning"] = {
			["TextColor3"] = {},
		},
		["glow"] = {
			["ImageColor3"] = {},
		},


		["NameColor"] = {
		  ["TextColor3"] = {},
		},
		["DistanceColor"] = {
		  ["TextColor3"] = {},
		},
		["VisibleColor"] = {
		  ["TextColor3"] = {},
		},
		["BoxColor"] = {
		  ["Color"] = {},
		},

		
		["Box"] = {
			["Color"] = {},
			["Visible"] = {},
		},

		["HealthBar"] = {
			["Color"] = {},
			["Visible"] = {},
		},
	},
}

local keys = {
	[Enum.KeyCode.LeftShift] = "LS",
	[Enum.KeyCode.RightShift] = "RS",
	[Enum.KeyCode.LeftControl] = "LC",
	[Enum.KeyCode.RightControl] = "RC",
	[Enum.KeyCode.Insert] = "INS",
	[Enum.KeyCode.Backspace] = "BS",
	[Enum.KeyCode.Return] = "Ent",
	[Enum.KeyCode.LeftAlt] = "LA",
	[Enum.KeyCode.RightAlt] = "RA",
	[Enum.KeyCode.CapsLock] = "CAPS",
	[Enum.KeyCode.One] = "1",
	[Enum.KeyCode.Two] = "2",
	[Enum.KeyCode.Three] = "3",
	[Enum.KeyCode.Four] = "4",
	[Enum.KeyCode.Five] = "5",
	[Enum.KeyCode.Six] = "6",
	[Enum.KeyCode.Seven] = "7",
	[Enum.KeyCode.Eight] = "8",
	[Enum.KeyCode.Nine] = "9",
	[Enum.KeyCode.Zero] = "0",
	[Enum.KeyCode.KeypadOne] = "Num1",
	[Enum.KeyCode.KeypadTwo] = "Num2",
	[Enum.KeyCode.KeypadThree] = "Num3",
	[Enum.KeyCode.KeypadFour] = "Num4",
	[Enum.KeyCode.KeypadFive] = "Num5",
	[Enum.KeyCode.KeypadSix] = "Num6",
	[Enum.KeyCode.KeypadSeven] = "Num7",
	[Enum.KeyCode.KeypadEight] = "Num8",
	[Enum.KeyCode.KeypadNine] = "Num9",
	[Enum.KeyCode.KeypadZero] = "Num0",
	[Enum.KeyCode.Minus] = "-",
	[Enum.KeyCode.Equals] = "=",
	[Enum.KeyCode.Tilde] = "~",
	[Enum.KeyCode.LeftBracket] = "[",
	[Enum.KeyCode.RightBracket] = "]",
	[Enum.KeyCode.RightParenthesis] = ")",
	[Enum.KeyCode.LeftParenthesis] = "(",
	[Enum.KeyCode.Semicolon] = ",",
	[Enum.KeyCode.Quote] = "'",
	[Enum.KeyCode.BackSlash] = "\\",
	[Enum.KeyCode.Comma] = ",",
	[Enum.KeyCode.Period] = ".",
	[Enum.KeyCode.Slash] = "/",
	[Enum.KeyCode.Asterisk] = "*",
	[Enum.KeyCode.Plus] = "+",
	[Enum.KeyCode.Period] = ".",
	[Enum.KeyCode.Backquote] = "`",
	[Enum.UserInputType.MouseButton1] = "MB1",
	[Enum.UserInputType.MouseButton2] = "MB2",
	[Enum.UserInputType.MouseButton3] = "MB3",
	[Enum.KeyCode.Escape] = "ESC",
	[Enum.KeyCode.Space] = "SPC",
}

library.__index = library

for _, path in next, library.folders do
	makefolder(library.directory .. path)
end

if not isfile(library.directory .. "/fonts/main.ttf") then
	writefile(
		library.directory .. "/fonts/main.ttf",
		game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/fs-tahoma-8px.ttf")
	)
end

local tahoma = {
	name = "SmallestPixel7",
	faces = {
		{
			name = "Regular",
			weight = 400,
			style = "normal",
			assetId = getcustomasset(library.directory .. "/fonts/main.ttf"),
		},
	},
}

if not isfile(library.directory .. "/fonts/main_encoded.ttf") then
	writefile(library.directory .. "/fonts/main_encoded.ttf", http_service:JSONEncode(tahoma))
end

library.font = Font.new(getcustomasset(library.directory .. "/fonts/main_encoded.ttf"), Enum.FontWeight.Regular)
--

-- functions
-- misc functions
function library.to_screen_point(position)
	return camera:WorldToViewportPoint(position)
end

function library:unload()
	library.gui:Destroy()

	for _, connection in library.connections do
		connection:Disconnect()
	end

	for _, item in library.instances do
		item:Destroy()
	end

	library.animated_pickers = {}

	getgenv().library = nil
end

function library:convert_string_rgb(str)
	local values = {}

	for value in string.gmatch(str, "[^,]+") do
		table.insert(values, tonumber(value))
	end

	if #values == 4 then
		local r, g, b, a = values[1], values[2], values[3], values[4]

		return r, g, b, a
	else
		library:notification({ text = "Input a correct RGBA value (in the format 255, 255, 255, 0.5)" })
	end
end

function library:connection(signal, callback)
	local connection = signal:Connect(callback)

	table.insert(library.connections, connection)

	return connection
end

function library:make_resizable(frame)
	local Frame = Instance.new("TextButton")
	Frame.Position = dim2(1, -10, 1, -10)
	Frame.BorderColor3 = rgb(0, 0, 0)
	Frame.Size = dim2(0, 10, 0, 10)
	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = rgb(255, 255, 255)
	Frame.Parent = frame
	Frame.BackgroundTransparency = 1
	Frame.Text = ""

	local resizing = false
	local start_size
	local start
	local og_size = frame.Size

	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = true
			start = input.Position
			start_size = frame.Size
		end
	end)

	Frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = false
		end
	end)

	library:connection(uis.InputChanged, function(input, game_event)
		if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mouse_pos = vec2(mouse.X, mouse.Y)
			local viewport_x = camera.ViewportSize.X
			local viewport_y = camera.ViewportSize.Y

			current_size = dim2(
				start_size.X.Scale,
				math.clamp(start_size.X.Offset + (input.Position.X - start.X), og_size.X.Offset, viewport_x),
				start_size.Y.Scale,
				math.clamp(start_size.Y.Offset + (input.Position.Y - start.Y), og_size.Y.Offset, viewport_y)
			)
			frame.Size = current_size
		end
	end)
end

function library:new_item(class, properties)
	local ins = Instance.new(class)

	for _, v in next, properties do
		ins[_] = v
	end

	table.insert(library.instances, ins)

	return ins
end

function library:animation(text)
	local pattern = {}
	for i = 1, tonumber(text:len()) do
		table.insert(pattern, string.sub(text, 1, i))
	end
	for i = tonumber(text:len()) - 1, 0, -1 do
		table.insert(pattern, string.sub(text, 1, i))
	end
	return pattern
end

function library:convert_enum(enum)
	local enum_parts = {}

	for part in string.gmatch(enum, "[%w_]+") do
		table.insert(enum_parts, part)
	end

	local enum_table = Enum
	for i = 2, #enum_parts do
		local enum_item = enum_table[enum_parts[i]]

		enum_table = enum_item
	end

	return enum_table
end

function library:config_list_update()
	if not library.config_holder then
		return
	end

	local list = {}

	for idx, file in next, listfiles(library.directory .. "/configs") do
		local name = file:match("([^/\\]+)%.cfg$")

		if name then
			list[#list + 1] = name
		end
	end

	library.config_holder:refresh_options(list)
end

function library:get_config()
	local Config = {}

	for _, v in flags do
		if type(v) == "table" and v.key then
			Config[_] = { active = v.active, mode = v.mode, key = tostring(v.key) }
		elseif type(v) == "table" and v["Transparency"] and v["Color"] then
			Config[_] = { Transparency = v["Transparency"], Color = v["Color"]:ToHex() }
		else
			Config[_] = v
		end
	end

	return http_service:JSONEncode(Config)
end

function library:load_config(config_json)
	local config = http_service:JSONDecode(config_json)

	for _, v in next, config do
		local function_set = library.config_flags[_]

		if function_set then
			if type(v) == "table" and v["Transparency"] and v["Color"] then
				function_set(hex(v["Color"]), v["Transparency"])
			elseif type(v) == "table" and v["active"] then
				function_set(v)
			else
				function_set(v)
			end
		end
	end
end

function library:round(number, float)
	local multiplier = 1 / (float or 1)
	return math.floor(number * multiplier + 0.5) / multiplier
end

function library:apply_theme(instance, theme, property)
	table.insert(themes.utility[theme][property], instance)
end

function library:update_theme(theme, color)
	for _, property in next, themes.utility[theme] do
		for m, object in next, property do
			if object[_] == themes.preset[theme] or object.ClassName == "UIGradient" then
				object[_] = color
			end
		end
	end

	themes.preset[theme] = color
end

function library:update_esp_instance(instance, value, flag)
    local targetTable = themes.utility[instance]
    
    -- Debug: Check if the table actually exists
    if not targetTable then
        warn("themes.utility[" .. tostring(instance) .. "] does not exist!")
        return
    end

    for _, tbleValue in targetTable do
        -- Check if the key exists in the table (using ~= nil instead of truthiness)
        if tbleValue[value] ~= nil then
            local newValue = flags and flags[flag] ~= nil and flags[flag] or flag
            
            tbleValue[value] = newValue or false
        else
            warn("Property '" .. tostring(value) .. "' not found in table entry!")
        end
    end
end

function library:connection(signal, callback)
	local connection = signal:Connect(callback)

	table.insert(library.connections, connection)

	return connection
end

function library:create(instance, options)
	local ins = Instance.new(instance)

	for prop, value in next, options do
		ins[prop] = value
	end

	return ins
end
--

library.gui = library:create("ScreenGui", {
	Enabled = true,
	Parent = coregui,
	Name = "",
	DisplayOrder = 2,
	ZIndexBehavior = 1,
})

-- [OPT] ONE shared loop drives every animated colorpicker.
-- Pickers set to "normal" are not in this list, so they cost nothing per frame.
library:connection(run.Heartbeat, function()
	local speed = flags["color_picker_anim_speed"]

	if not speed then
		return
	end

	library.sin = math.abs(math.sin(tick() * speed))

	for picker in next, library.animated_pickers do
		picker.animate()
	end
end)

-- [OPT] sliders animate their fill through ONE shared loop (exponential smoothing, no Tween objects)
library.animated_sliders = {}

library:connection(run.Heartbeat, function(dt)
	for slider in next, library.animated_sliders do
		slider.step_fill(dt)
	end
end)

-- library functions
function library:window(properties)
	local cfg = {
		name = properties.Name or properties.name or properties.Title or properties.title or "sp4m.wtf",
		size = properties.Size or properties.size or dim2(0, 500, 0, 650),
	}

	local animated_text = library:animation(cfg.name .. " | private")

	-- watermark
	local __holder = library:create("Frame", {
		Parent = library.gui,
		Name = "",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 20, 0, 20),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		ZIndex = 2,
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
	})

	local inline1 = library:create("Frame", {
		Parent = __holder,
		Name = "",
		Active = true,
		Draggable = true,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(0, ((#animated_text / 2) * 5) + 13, 0, 40),
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
	})

	local accent_line = library:create("Frame", {
		Parent = inline1,
		Name = "",
		BorderColor3 = Color3.fromRGB(34, 34, 34),
		Size = UDim2.new(1, 0, 0, 2),
		BorderSizePixel = 0,
		BackgroundColor3 = themes.preset.accent,
	})

	library:apply_theme(accent_line, "accent", "BackgroundColor3")

	local depth = library:create("Frame", {
		Parent = inline1,
		Name = "",
		BackgroundTransparency = 0.5,
		Position = UDim2.new(0, 0, 0, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 0, 1),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	})

	local inline2 = library:create("Frame", {
		Parent = inline1,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -4, 1, -4),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	})

	local main = library:create("Frame", {
		Parent = inline2,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(57, 57, 57),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	})

	local tab_inline = library:create("Frame", {
		Parent = main,
		Name = "",
		Position = UDim2.new(0, 6, 0, 6),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -12, 1, -12),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(19, 19, 19),
	})

	local tabs = library:create("Frame", {
		Parent = tab_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	local name = library:create("TextLabel", {
		Parent = tabs,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = "ledger.live",
		TextStrokeTransparency = 0.5,
		Size = UDim2.new(0, 0, 1, 0),
		Position = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.X,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local TEXT_ANIMATION_GRADIENT = library:create("UIGradient", {
		Parent = name,
		Name = "",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.01, themes.preset.accent),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		}),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = tabs,
		Name = "",
		PaddingRight = UDim.new(0, 21),
	})

	local glow = library:create("ImageLabel", {
		Parent = accent_line,
		Name = "",
		ImageColor3 = themes.preset.accent,
		ScaleType = Enum.ScaleType.Slice,
		ImageTransparency = 0.8999999761581421,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Image = "http://www.roblox.com/asset/?id=18245826428",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -20, 0, -20),
		Size = UDim2.new(1, 40, 0, 42),
		ZIndex = 2,
		BorderSizePixel = 0,
		SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
	})

	library:apply_theme(glow, "accent", "ImageColor3")

	task.spawn(function()
		while true do
			if __holder.Visible then
				for i = 1, #animated_text do
					task.wait(0.2)
					name.Text = animated_text[i]
				end
			end
			task.wait(0.2)
		end
	end)
	--

	-- window
	local inline1 = library:create("Frame", {
		Parent = library.gui,
		Name = "",
		Active = true,
		Draggable = true,
		Position = UDim2.new(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2),
		BorderColor3 = Color3.fromRGB(8, 8, 8),
		ZIndex = 2,
		Size = cfg.size,
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
	})
	table.insert(library.main_frame, inline1)
	local WINDOW_PATH = inline1
	library:make_resizable(inline1)

	local inline2 = library:create("Frame", {
		Parent = inline1,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -4, 1, -4),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	})

	local main = library:create("Frame", {
		Parent = inline2,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(57, 57, 57),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	})

	local tab_buttons = library:create("Frame", {
		Parent = main,
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, 4),
		Size = UDim2.new(1, -32, 0, 0),
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	cfg["tab_holder"] = tab_buttons

	local list = library:create("UIListLayout", {
		Parent = tab_buttons,
		Name = "",
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local tab_inline = library:create("Frame", {
		Parent = main,
		Name = "",
		Position = UDim2.new(0, 15, 0, 33),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -30, 1, -48),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(19, 19, 19),
	})

	local tabs = library:create("Frame", {
		Parent = tab_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	cfg["tab_instance_holder"] = tabs

	local accent_line = library:create("Frame", {
		Parent = inline1,
		Name = "",
		BorderColor3 = Color3.fromRGB(34, 34, 34),
		Size = UDim2.new(1, 0, 0, 2),
		BorderSizePixel = 0,
		BackgroundColor3 = themes.preset.accent,
	})

	library:apply_theme(accent_line, "accent", "BackgroundColor3")

	local name = library:create("TextLabel", {
		Parent = inline1,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = cfg.name,
		TextStrokeTransparency = 0.5,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, -1),
		Size = UDim2.new(1, 0, 0, 1),
		ZIndex = 2,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local stroke = Instance.new("UIStroke", name)
	stroke.LineJoinMode = Enum.LineJoinMode.Miter

	local glow = library:create("ImageLabel", {
		Parent = inline1,
		Name = "",
		ImageColor3 = themes.preset.accent,
		ScaleType = Enum.ScaleType.Slice,
		ImageTransparency = 0.8999999761581421,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Image = "http://www.roblox.com/asset/?id=18245826428",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -20, 0, -20),
		Size = UDim2.new(1, 40, 0, 42),
		ZIndex = 10,
		BorderSizePixel = 0,
		SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
	})
	library:apply_theme(glow, "accent", "ImageColor3")

	local depth = library:create("Frame", {
		Parent = inline1,
		Name = "",
		BackgroundTransparency = 0.5,
		Position = UDim2.new(0, 0, 0, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 0, 1),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	})

	local holder = library:create("Frame", {
		Parent = inline1,
		Name = "",
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 20, 0, 0),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		ZIndex = 2,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
	})

	
	local last_gradient_update = 0
	library:connection(run.Heartbeat, function()
		if not flags["color_picker_anim_speed"] or not __holder.Visible then
			return
		end

		local now = tick()

		if now - last_gradient_update < 1 / 30 then
			return
		end

		last_gradient_update = now

		TEXT_ANIMATION_GRADIENT.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(math.abs(math.sin(now)), themes.preset.accent),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		})
	end)
	--

	-- esp preview
	local esp_preview = library:create("Frame", {
		Parent = library.gui,
		Name = "",
		Visible = true,
		Active = true,
		Draggable = true,
		Position = UDim2.new(
			0,
			inline1.AbsolutePosition.X + inline1.AbsoluteSize.X + 8,
			0,
			inline1.AbsolutePosition.Y + 1
		),
		BorderColor3 = Color3.fromRGB(8, 8, 8),
		Size = UDim2.new(0, 300, 0, 376),
		BackgroundColor3 = Color3.fromRGB(56, 56, 56),
	})
	library:make_resizable(esp_preview)

	local name = library:create("TextLabel", {
		Parent = esp_preview,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = "ESP Preview",
		TextStrokeTransparency = 1,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, -1),
		Size = UDim2.new(1, 0, 0, 1),
		ZIndex = 2,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local UIStroke = library:create("UIStroke", {
		Parent = name,
		Name = "",
		LineJoinMode = Enum.LineJoinMode.Miter
	})

	local UIPadding = library:create("UIPadding", {
		Parent = name,
		Name = "",
	})

	local main = library:create("Frame", {
		Parent = esp_preview,
		Name = "",
		Position = UDim2.new(0, 4, 0, 4),
		BorderColor3 = Color3.fromRGB(26, 26, 26),
		Size = UDim2.new(1, -8, 1, -8),
		BorderSizePixel = 2,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	})

	library:create("UIStroke", {
		Parent = main,
		Name = "mainStroke",
		Color = Color3.fromRGB(57, 57, 57),
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local tabs = library:create("Frame", {
		Parent = main,
		Name = "",
		Position = UDim2.new(0, 8, 0, 8),
		BorderColor3 = Color3.fromRGB(8, 8, 8),
		Size = UDim2.new(1, -16, 1, -16),
		BorderSizePixel = 2,
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	library:create("UIStroke", {
		Parent = tabs,
		Name = "",
		Color = Color3.fromRGB(57, 57, 57),
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local hitpart = library:create("Frame", {
		Parent = tabs,
		Name = "",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 2, 0, 20),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	local head = library:create("Frame", {
		Parent = hitpart,
		Name = "",
		Position = UDim2.new(0.5, -25, 0, 16),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(0, 50, 0, 44),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local torso = library:create("Frame", {
		Parent = hitpart,
		Name = "",
		Position = UDim2.new(0.5, -42, 0, 64),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(0, 84, 0, 90),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local l_arm = library:create("Frame", {
		Parent = hitpart,
		Name = "",
		Position = UDim2.new(0.5, -86, 0, 64),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(0, 40, 0, 90),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local r_arm = library:create("Frame", {
		Parent = hitpart,
		Name = "",
		Position = UDim2.new(0.5, 46, 0, 64),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(0, 40, 0, 90),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local r_leg = library:create("Frame", {
		Parent = hitpart,
		Name = "",
		Position = UDim2.new(0.5, 2, 0, 158),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(0, 40, 0, 90),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local l_leg = library:create("Frame", {
		Parent = hitpart,
		Name = "",
		Position = UDim2.new(0.5, -42, 0, 158),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(0, 40, 0, 90),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local hrp = library:create("Frame", {
		Parent = hrp_out,
		Name = "",
		Position = UDim2.new(0, 4, 0, 4),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -8, 1, -8),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local glow_patterns = {}

	for _, v in next, hitpart:GetChildren() do
		local glow = library:create("ImageLabel", {
			Parent = v,
			Name = "",
			Visible = false,
			ImageColor3 = themes.preset.accent,
			ScaleType = Enum.ScaleType.Slice,
			ImageTransparency = 0.8999999761581421,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Image = "http://www.roblox.com/asset/?id=18245826428",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, -20, 0, -20),
			Size = UDim2.new(1, 40, 1, 40),
			ZIndex = 2,
			BorderSizePixel = 0,
			SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
		})

		library:apply_theme(glow, "accent", "ImageColor3")

		table.insert(glow_patterns, glow)
	end
	
	function cfg.preview_chams(bool)
		for _, glow in next, glow_patterns do
			glow.Visible = bool
		end
	end

	function cfg.preview_cham_color(color)
	    for _, part in next, hitpart:GetChildren() do
		  part.BackgroundColor3 = color or themes.preset.accent
	    end
	end

	local player = library:create("Frame", {
		Parent = tabs,
		Name = "playerFrame",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 43, 0, 28),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -86, 1, -106),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})
    
	local line_holder = library:create("Frame", {
		Parent = player,
		Name = "",
		Size = UDim2.new(.945, 0, .975, 0),
		ZIndex = 50,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Position = UDim2.new(.0265, 0, .015, 0),
	})

	local box_outline = library:create("Frame", {
		Parent = line_holder,
		Name = "box_outline",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -1, 0, -1),
		ZIndex = 50,
		Size = UDim2.new(1, 2, 1, 2),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local BoxLine2 = library:create("UIStroke", {
		Parent = box_outline,
		Name = "BoxLine2",
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local box_color = library:create("UIStroke", {
		Parent = line_holder,
		Name = "box_color",
		Color = Color3.fromRGB(255, 255, 255),
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local box_inline = library:create("Frame", {
		Parent = line_holder,
		Name = "",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 1, 0, 1),
		ZIndex = 50,
		Size = UDim2.new(1, -2, 1, -2),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local BoxLine3 = library:create("UIStroke", {
		Parent = box_inline,
		Name = "BoxLine3",
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local fillGradient = library:create("UIGradient", {
		Parent = line_holder,
		Name = "",
		Rotation = -180,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.5),
			NumberSequenceKeypoint.new(1, 0.5),
		}),
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
		}),
	})

	local corner_box = library:create("Frame", {
		Parent = line_holder,
		Name = "",
		Visible = false,
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local top_left = library:create("Frame", {
		Parent = corner_box,
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		ZIndex = 50,
		Size = UDim2.new(0, 1, 0.30000001192092896, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local top_right = library:create("Frame", {
		Parent = corner_box,
		Name = "",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -1, 0, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		ZIndex = 50,
		Size = UDim2.new(0, 1, 0.30000001192092896, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local bottom_left = library:create("Frame", {
		Parent = corner_box,
		Name = "",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		ZIndex = 50,
		Size = UDim2.new(0.4000000059604645, 0, 0, 1),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local bottom_right = library:create("Frame", {
		Parent = corner_box,
		Name = "",
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -1, 1, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		ZIndex = 50,
		Size = UDim2.new(0.4000000059604645, 0, 0, 1),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local bottom_left2 = library:create("Frame", {
		Parent = corner_box,
		Name = "",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		ZIndex = 50,
		Size = UDim2.new(0, 1, 0.30000001192092896, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local bottom_right2 = library:create("Frame", {
		Parent = corner_box,
		Name = "",
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		ZIndex = 50,
		Size = UDim2.new(0, 1, 0.30000001192092896, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local top_left2 = library:create("Frame", {
		Parent = corner_box,
		Name = "",
		AnchorPoint = Vector2.new(0, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		ZIndex = 50,
		Size = UDim2.new(0.4000000059604645, 0, 0, 1),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local top_right2 = library:create("Frame", {
		Parent = corner_box,
		Name = "",
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -1, 0, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		ZIndex = 50,
		Size = UDim2.new(0.4000000059604645, 0, 0, 1),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	function cfg.preview_corner_boxes(bool)
		corner_box.Visible = bool == "Corner" and true or false
		BoxLine2.Enabled = bool == "Corner" and false or true
		box_outline.Visible = bool == "Corner" and false or true
		box_color.Enabled = bool == "Corner" and false or true
	end

	function cfg.preview_bounding_box(bool)
		BoxLine2.Enabled = bool
		box_outline.Visible = bool
		box_color.Enabled = bool
		BoxLine3.Enabled = bool
	end

	function cfg.change_box(color3)
		box_color.Color = color3
	end

	local bottom_holder = library:create("Frame", {
		Parent = line_holder,
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -1, 1, 1),
		Size = UDim2.new(1, 2, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local UIListLayout = library:create("UIListLayout", {
		Parent = bottom_holder,
		Name = "",
		Padding = UDim.new(0, 0),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local UIPadding = library:create("UIPadding", {
		Parent = bottom_holder,
		Name = "",
		PaddingTop = UDim.new(0, 1),
	})

	local bar_holder = library:create("Frame", {
		Parent = bottom_holder,
		Name = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 4),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local reload_bar = library:create("Frame", {
		Parent = bar_holder,
		Name = "",
		Size = UDim2.new(1, 0, 0, 4),
		ZIndex = 50,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	})

	function cfg.preview_reload_bar(bool)
		bar_holder.Visible = bool
	end

	local reload_slider = library:create("Frame", {
		Parent = reload_bar,
		Name = "",
		Size = UDim2.new(0.5, -2, 0, 2),
		Position = UDim2.new(0, 1, 0, 1),
		ZIndex = 50,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(28, 145, 255),
	})

	local gradient = library:create("UIGradient", {
		Parent = reload_slider,
		Name = "",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 238)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 238)),
		}),
	})

	local UIStroke = library:create("UIStroke", {
		Parent = distance,
		Name = "",
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local weapon = library:create("TextLabel", {
		Parent = bottom_holder,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Text = "Ray Gun",
		TextStrokeTransparency = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 50,
		TextSize = 12,
		Size = UDim2.new(1, 0, 0, 4),
		LayoutOrder = 4
	})

	function cfg.preview_weapon(bool)
		weapon.Visible = bool
	end

	function cfg.change_weapon(color3)
		weapon.TextColor3 = color3
	end

	local UIStroke = library:create("UIStroke", {
		Parent = weapon,
		Name = "",
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local distance = library:create("TextLabel", {
		Parent = bottom_holder,
		Name = "distanceTextLabel",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Text = "1000M",
		TextStrokeTransparency = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 50,
		TextSize = 12,
		Size = UDim2.new(1, 0, 0, 4),
		LayoutOrder = 3
	})

	function cfg.preview_distance(bool)
		distance.Visible = bool
	end

	function cfg.change_distance(color3)
		distance.TextColor3 = color3
	end
	
	local UIStroke = library:create("UIStroke", {
		Parent = distance,
		Name = "",
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local visible = library:create("TextLabel", {
		Parent = bottom_holder,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Text = "Visible",
		TextStrokeTransparency = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 50,
		TextSize = 12,
		Size = UDim2.new(1, 0, 0, 4),
		LayoutOrder = 5
	})
    
	function cfg.preview_visible(bool)
		visible.Visible = bool
	end
    
	function cfg.change_visible(color3)
		visible.TextColor3 = color3
	end
	
	local UIStroke = library:create("UIStroke", {
		Parent = visible,
		Name = "",
		LineJoinMode = Enum.LineJoinMode.Miter,
	})
    
	local image_holder = library:create("Frame", {
		Parent = bottom_holder,
		Name = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})
    
	function cfg.preview_icons(bool)
		image_holder.Visible = bool
	end
    
	local ImageLabel = library:create("ImageLabel", {
		Parent = image_holder,
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Image = "rbxassetid://130516018594923",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(0, 64, 0, 27),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})
    
	local armor = library:create("Frame", {
		Parent = line_holder,
		Name = "",
		Position = UDim2.new(0, -14, 0, -2),
		Size = UDim2.new(0, 4, 1, 4),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	})
	
	function cfg.preview_armor(bool)
		armor.Visible = bool
	end
    
	local armor_slider = library:create("Frame", {
		Parent = armor,
		Name = "",
		Position = UDim2.new(0, 1, 0, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(0.5, 0, 1, -2),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(0, 13, 255),
	})

	local armor_gradient = library:create("UIGradient", {
		Parent = armor_slider,
		Name = "",
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 242, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 17, 255)),
		}),
		Enabled = false,
	})

	local armor_text = library:create("TextLabel", {
		Parent = armor_slider,
		Name = "",
		ZIndex = 99,
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(0, 13, 255),
		Text = "100",
		Position = UDim2.new(0, -2, 0.75, -2),
		TextStrokeTransparency = 0,
		AnchorPoint = Vector2.new(1, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Right,
		Active = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(26, 255, 0),
	})

	library:create("UIStroke", {
		Parent = armor_text,
		Name = "",
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local health = library:create("Frame", {
		Parent = line_holder,
		Name = "",
		Position = UDim2.new(0, -5, 0, -1),
		Size = UDim2.new(0, 1, 1, 2),
		BorderSizePixel = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		Rotation = -180
	})

	function cfg.preview_health(bool)
		health.Visible = bool
	end

	function cfg.chage_health_color(bool)
		health.Visible = bool
	end
    
	local health_slider = library:create("Frame", {
		Parent = health,
		Name = "",
		Position = UDim2.new(0, 0, 0, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Rotation = 0
	})
    
	local gradient = library:create("UIGradient", {
		Parent = health_slider,
		Name = "",
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 0),
		}),
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		}),
	})
	--flags["Box_Fill_Color_Two"].Color
	--flags["Box_Fill_Color"].Color

	function cfg.change_health_gradient(color)
		gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, (flags["GradientColor1"] and flags["GradientColor1"].Color) or Color3.new(1, 1, 1) ), ColorSequenceKeypoint.new(1, (flags["GradientColor2"] and flags["GradientColor2"].Color) or Color3.new(1, 1, 1)),})
	end
    
	local health_text = library:create("TextLabel", {
		Parent = line_holder,
		Name = "",
		Visible = true,
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(0, 255, 0),
		Text = "100",
		ZIndex = 100,
		TextStrokeTransparency = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(-.53, 0, 1, 0),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Right,
		Active = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(26, 255, 0),
		Rotation = 0
	})
    
	task.spawn(function() --// Health Bar Loop :P
      while true do
		local speed = flags["healthBarSpeed"] or 2
        local alpha = (math.sin(os.clock() * speed) + 1) / 2
            
	    health_slider.Size = UDim2.new(
		 1, 
		 0, 
		 math.clamp(1 - alpha, 0, 1),
		 0
		)
		
		health_text.Position = UDim2.new(
		 .01, 
		 0, 
		 math.clamp(alpha - .02, -1, 1),
		 0
		)

		if flags and flags["Health_Text_Color"] and flags["Low_Health_Text_Color"] then
			local fullFlag = flags["Health_Text_Color"].Color or Color3.fromRGB(0, 0, 220)
            local lowFlag = flags["Low_Health_Text_Color"].Color or Color3.fromRGB(255, 100, 100)
            health_text.TextColor3 = fullFlag:Lerp(lowFlag, math.clamp(alpha, 0, 1))
			health_text.Text = math.clamp(math.round((1 - alpha) * 100), 0, 100)
		end
        
		if flags and flags["Vis_Color"] and flags["Not_Vis_Color"] then
            local isVisFlag = flags["Vis_Color"].Color or Color3.fromRGB(0, 0, 220)
            local notVisFlag = flags["Not_Vis_Color"].Color or Color3.fromRGB(255, 100, 100)
            visible.TextColor3 = isVisFlag:Lerp(notVisFlag, math.clamp(alpha, 0, 1))
        end
            
		task.wait()
	  end
    end)

	local UIStroke = library:create("UIStroke", {
	  Parent = health_text,
	  Name = "",
	  LineJoinMode = Enum.LineJoinMode.Miter,
	})
    
	function cfg.preview_filler(bool)
	  local isGradient = flags and flags["Boxes"] and flags["BoxFill"]
	  line_holder.BackgroundTransparency = isGradient and 0 or 1
	  fillGradient.Enabled = isGradient
	end
	
	function cfg.change_fill_gradient(color)
	  fillGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, (flags["Box_Fill_Color"] and flags["Box_Fill_Color"].Color) or Color3.new(1, 1, 1) ), ColorSequenceKeypoint.new(1, (flags["Box_Fill_Color_Two"] and flags["Box_Fill_Color_Two"].Color) or Color3.new(1, 1, 1))})
	  fillGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, (flags["Box_Fill_Color"] and flags["Box_Fill_Color"].Transparency) or .5), NumberSequenceKeypoint.new(1, (flags["Box_Fill_Color_Two"] and flags["Box_Fill_Color_Two"].Transparency) or .5)})
	end

	function cfg.change_fill_rotation(rotation)
		fillGradient.Rotation = rotation
	end

	local top_holder = library:create("Frame", {
		Parent = line_holder,
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -2, 0, -4),
		Size = UDim2.new(1, 4, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	library:create("UIListLayout", {
		Parent = top_holder,
		Name = "",
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	library:create("UIPadding", {
		Parent = top_holder,
		Name = "",
		PaddingTop = UDim.new(0, 1),
	})

	local player_name = library:create("TextLabel", {
		Parent = top_holder,
		Name = "",
		RichText = true,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Text = lp.Name,
		FontFace = library.font,
		AnchorPoint = Vector2.new(0, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, -2),
		BorderSizePixel = 0,
		ZIndex = 50,
		TextSize = 12,
		Size = UDim2.new(1, 0, 0, 0),
	})

	function cfg.preview_names(bool)
		player_name.Visible = bool
	end

	function cfg.change_name(color3)
		player_name.TextColor3 = color3
	end

	local UIStroke = library:create("UIStroke", {
		Parent = player_name,
		Name = "",
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local accent_line = library:create("Frame", {
		Parent = esp_preview,
		Name = "",
		BorderColor3 = Color3.fromRGB(34, 34, 34),
		Size = UDim2.new(1, 0, 0, 2),
		BorderSizePixel = 0,
		BackgroundColor3 = themes.preset.accent,
	})

	library:apply_theme(accent_line, "accent", "BackgroundColor3")

	local depth = library:create("Frame", {
		Parent = esp_preview,
		Name = "",
		BackgroundTransparency = 0.5,
		Position = UDim2.new(0, 0, 0, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 0, 1),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	})

	local glow = library:create("ImageLabel", {
		Parent = esp_preview,
		Name = "",
		ImageColor3 = themes.preset.accent,
		ScaleType = Enum.ScaleType.Slice,
		ImageTransparency = 0.8999999761581421,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Image = "http://www.roblox.com/asset/?id=18245826428",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -20, 0, -20),
		Size = UDim2.new(1, 40, 0, 42),
		ZIndex = 2,
		BorderSizePixel = 0,
		SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
	})

	library:apply_theme(glow, "accent", "ImageColor3")
	--

	-- playerlist
	local selected_button
	local selected_player
	local player_buttons = {}

	function library.get_priority(player)
		return player_buttons[player.Name].priority.Text
	end

	local playerlist = library:create("Frame", {
		Parent = library.gui,
		Name = "",
		Active = true,
		Draggable = true,
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0, inline1.AbsolutePosition.X - 358 - 8, 0, inline1.AbsolutePosition.Y + 1),
		BorderColor3 = Color3.fromRGB(8, 8, 8),
		Size = UDim2.new(0, 358, 0, 328),
		BackgroundColor3 = Color3.fromRGB(56, 56, 56),
	})
	library:make_resizable(playerlist)

	table.insert(library.main_frame, playerlist)

	local name = library:create("TextLabel", {
		Parent = playerlist,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = "playerlist",
		TextStrokeTransparency = 0.5,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, -1),
		Size = UDim2.new(1, 0, 0, 1),
		ZIndex = 2,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = name,
		Name = "",
	})

	local main = library:create("Frame", {
		Parent = playerlist,
		Name = "",
		Position = UDim2.new(0, 4, 0, 4),
		BorderColor3 = Color3.fromRGB(26, 26, 26),
		Size = UDim2.new(1, -8, 1, -8),
		BorderSizePixel = 2,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	})

	library:create("UIStroke", {
		Parent = main,
		Name = "",
		Color = Color3.fromRGB(57, 57, 57),
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local tabs = library:create("Frame", {
		Parent = main,
		Name = "",
		Position = UDim2.new(0, 8, 0, 8),
		BorderColor3 = Color3.fromRGB(8, 8, 8),
		Size = UDim2.new(1, -16, 1, -16),
		BorderSizePixel = 2,
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	library:create("UIStroke", {
		Parent = tabs,
		Name = "",
		Color = Color3.fromRGB(57, 57, 57),
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local list = library:create("Frame", {
		Parent = tabs,
		Name = "",
		Position = UDim2.new(0, 14, 0, 14),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -28, 0.75, -28),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local inline = library:create("Frame", {
		Parent = list,
		Name = "",
		Position = UDim2.new(0, 1, 0, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -2, 1, -2),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(57, 57, 57),
	})

	local background = library:create("Frame", {
		Parent = inline,
		Name = "",
		Position = UDim2.new(0, 1, 0, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -2, 1, -2),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	local UIGradient = library:create("UIGradient", {
		Parent = background,
		Name = "",
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(167, 167, 167)),
		}),
	})

	local contrast = library:create("Frame", {
		Parent = background,
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	local __ScrollingFrame = library:create("ScrollingFrame", {
		Parent = contrast,
		Name = "",
		ScrollBarImageColor3 = themes.preset.accent,
		MidImage = "rbxassetid://18406573371",
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		TopImage = "rbxassetid://18406573371",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1.0099999904632568,
		BottomImage = "rbxassetid://18406573371",
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
	})

	library:apply_theme(__ScrollingFrame, "accent", "ScrollBarImageColor3")

	local UIPadding = library:create("UIPadding", {
		Parent = __ScrollingFrame,
		Name = "",
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 4),
		PaddingLeft = UDim.new(0, 4),
	})

	local UIListLayout = library:create("UIListLayout", {
		Parent = __ScrollingFrame,
		Name = "",
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local info = library:create("Frame", {
		Parent = tabs,
		Name = "",
		Position = UDim2.new(0, 14, 0.75, -5),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -28, 0.30000001192092896, -23),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local inline = library:create("Frame", {
		Parent = info,
		Name = "",
		Position = UDim2.new(0, 1, 0, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -2, 1, -2),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(57, 57, 57),
	})

	local background = library:create("Frame", {
		Parent = inline,
		Name = "",
		Position = UDim2.new(0, 1, 0, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -2, 1, -2),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	local UIGradient = library:create("UIGradient", {
		Parent = background,
		Name = "",
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(167, 167, 167)),
		}),
	})

	local contrast = library:create("Frame", {
		Parent = background,
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	local ScrollingFrame = library:create("ScrollingFrame", {
		Parent = contrast,
		Name = "",
		ScrollBarImageColor3 = Color3.fromRGB(155, 125, 175),
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		BackgroundTransparency = 1.0099999904632568,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = ScrollingFrame,
		Name = "",
		PaddingTop = UDim.new(0, 7),
		PaddingBottom = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 4),
		PaddingLeft = UDim.new(0, 10),
	})

	local UIListLayout = library:create("UIListLayout", {
		Parent = ScrollingFrame,
		Name = "",
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local display_name_label = library:create("TextLabel", {
		Parent = ScrollingFrame,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(180, 180, 180),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = "Display Name: ...",
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		AutomaticSize = Enum.AutomaticSize.XY,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	library:create("UIStroke", {
		Parent = display_name_label,
		Name = "",
	})

	local name_label = library:create("TextLabel", {
		Parent = ScrollingFrame,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(180, 180, 180),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = "Name: ...",
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		AutomaticSize = Enum.AutomaticSize.XY,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	library:create("UIStroke", {
		Parent = name_label,
		Name = "",
	})

	local priority_label = library:create("TextLabel", {
		Parent = ScrollingFrame,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(180, 180, 180),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = "Priority: Friendly",
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		AutomaticSize = Enum.AutomaticSize.XY,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	library:create("UIStroke", {
		Parent = priority_label,
		Name = "",
	})

	local Frame = library:create("Frame", {
		Parent = contrast,
		Name = "",
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -10, 0, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -200, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local button_inline = library:create("Frame", {
		Parent = Frame,
		Name = "",
		Position = UDim2.new(0, -15, 0, 2),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -26, 0, 16),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local button = library:create("TextButton", {
		Parent = button_inline,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "Neutral",
		TextStrokeTransparency = 0.5,
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	button.MouseButton1Click:Connect(function()
		player_buttons[selected_player.Name].priority.Text = "Neutral"
		player_buttons[selected_player.Name].priority.TextColor3 = rgb(180, 180, 180)
	end)

	local button_inline = library:create("Frame", {
		Parent = Frame,
		Name = "",
		Position = UDim2.new(0, -15, 0, 2),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -26, 0, 16),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local button = library:create("TextButton", {
		Parent = button_inline,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "Friendly",
		TextStrokeTransparency = 0.5,
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	button.MouseButton1Click:Connect(function()
		player_buttons[selected_player.Name].priority.Text = "Friendly"
		player_buttons[selected_player.Name].priority.TextColor3 = rgb(15, 179, 255)
	end)

	local button_inline = library:create("Frame", {
		Parent = Frame,
		Name = "",
		Position = UDim2.new(0, -15, 0, 2),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -26, 0, 16),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local button = library:create("TextButton", {
		Parent = button_inline,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "Enemy",
		TextStrokeTransparency = 0.5,
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	button.MouseButton1Click:Connect(function()
		player_buttons[selected_player.Name].priority.Text = "Enemy"
		player_buttons[selected_player.Name].priority.TextColor3 = rgb(255, 44, 44)
	end)

	local UIListLayout = library:create("UIListLayout", {
		Parent = Frame,
		Name = "",
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		Padding = UDim.new(0, 4),
	})

	local accent_line = library:create("Frame", {
		Parent = playerlist,
		Name = "",
		BorderColor3 = Color3.fromRGB(34, 34, 34),
		Size = UDim2.new(1, 0, 0, 2),
		BorderSizePixel = 0,
		BackgroundColor3 = themes.preset.accent,
	})

	library:apply_theme(accent_line, "accent", "BackgroundColor3")

	local depth = library:create("Frame", {
		Parent = playerlist,
		Name = "",
		BackgroundTransparency = 0.5,
		Position = UDim2.new(0, 0, 0, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 0, 1),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	})

	local glow = library:create("ImageLabel", {
		Parent = playerlist,
		Name = "",
		ImageColor3 = themes.preset.accent,
		ScaleType = Enum.ScaleType.Slice,
		ImageTransparency = 0.8999999761581421,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Image = "http://www.roblox.com/asset/?id=18245826428",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -20, 0, -20),
		Size = UDim2.new(1, 40, 0, 42),
		ZIndex = 2,
		BorderSizePixel = 0,
		SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
	})

	library:apply_theme(glow, "accent", "ImageColor3")

	local function create_player(player)
		local TextButton = library:create("TextButton", {
			Parent = __ScrollingFrame,
			Name = "",
			FontFace = library.font,
			TextColor3 = Color3.fromRGB(180, 180, 180),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 12,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})

		player_buttons[player.Name] = {}
		player_buttons[player.Name].instance = TextButton

		local TextLabel = library:create("TextLabel", {
			Parent = TextButton,
			Name = "",
			FontFace = library.font,
			TextColor3 = Color3.fromRGB(180, 180, 180),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Text = player.Name,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 12,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})

		library:create("UIStroke", {
			Parent = TextLabel,
			Name = "",
		})

		local TextLabel = library:create("TextLabel", {
			Parent = TextButton,
			Name = "",
			FontFace = library.font,
			TextColor3 = Color3.fromRGB(180, 180, 180),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Text = player.Team and tostring(player.Team) or "None",
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 12,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})

		library:create("UIStroke", {
			Parent = TextLabel,
			Name = "",
		})

		local Frame = library:create("Frame", {
			Parent = TextLabel,
			Name = "",
			Position = UDim2.new(0, -10, 0, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 1, 0, 12),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(32, 32, 38),
		})

		local TextLabel = library:create("TextLabel", {
			Parent = TextButton,
			Name = "",
			FontFace = library.font,
			TextColor3 = Color3.fromRGB(180, 180, 180),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Text = "Neutral",
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 12,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})

		player_buttons[player.Name].priority = TextLabel

		library:create("UIStroke", {
			Parent = TextLabel,
			Name = "",
		})

		local Frame = library:create("Frame", {
			Parent = TextLabel,
			Name = "",
			Position = UDim2.new(0, -10, 0, 0),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 1, 0, 12),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(32, 32, 38),
		})

		local UIListLayout = library:create("UIListLayout", {
			Parent = TextButton,
			Name = "",
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalFlex = Enum.UIFlexAlignment.Fill,
		})

		local UIPadding = library:create("UIPadding", {
			Parent = TextButton,
			Name = "",
			PaddingRight = UDim.new(0, 2),
			PaddingLeft = UDim.new(0, 2),
		})

		local line = library:create("Frame", {
			Parent = tabs,
			Name = "",
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(1, 0, 0, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(32, 32, 38),
		})

		TextButton.MouseButton1Click:Connect(function()
			if selected_button then
				selected_button.BackgroundTransparency = 1
			end

			selected_button = TextButton
			selected_player = player
			TextButton.BackgroundTransparency = 0.85

			priority_label.Text = "Priority: " .. library.get_priority(player)
			name_label.Text = "Name: " .. player.Name
			display_name_label.Text = "Display: " .. player.DisplayName
		end)
	end

	for _, player in next, players:GetPlayers() do
		create_player(player)
	end

	library:connection(players.PlayerAdded, function(player)
		create_player(player)
	end)

	library:connection(players.PlayerRemoving, function(player)
		player_buttons[player.Name].instance:Destroy()
	end)
	--

	-- keybind list
	local old_kblist = library:create("Frame", {
		Parent = library.gui,
		Name = "",
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 20, 0.5, 0),
		ZIndex = 2,
		Active = true,
		Draggable = true,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
	})

	local glow = library:create("ImageLabel", {
		Parent = old_kblist,
		Name = "",
		ImageColor3 = themes.preset.accent,
		ScaleType = Enum.ScaleType.Slice,
		ImageTransparency = 0.8999999761581421,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Image = "http://www.roblox.com/asset/?id=18245826428",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -20, 0, -20),
		Size = UDim2.new(1, 40, 0, 42),
		ZIndex = 2,
		BorderSizePixel = 0,
		SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
	})

	library:apply_theme(glow, "accent", "ImageColor3")

	local inline1 = library:create("Frame", {
		Parent = old_kblist,
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
	})

	local accent_line = library:create("Frame", {
		Parent = inline1,
		Name = "",
		BorderColor3 = Color3.fromRGB(34, 34, 34),
		Size = UDim2.new(1, 0, 0, 2),
		BorderSizePixel = 0,
		BackgroundColor3 = themes.preset.accent,
	})

	library:apply_theme(accent_line, "accent", "BackgroundColor3")

	local name = library:create("TextLabel", {
		Parent = inline1,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = "keybinds",
		TextStrokeTransparency = 0,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, -1),
		Size = UDim2.new(1, 0, 0, 1),
		ZIndex = 10,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local inline2 = library:create("Frame", {
		Parent = inline1,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -4, 1, -4),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	})

	local main = library:create("Frame", {
		Parent = inline2,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(57, 57, 57),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	})

	local tab_inline = library:create("Frame", {
		Parent = main,
		Name = "",
		Position = UDim2.new(0, 6, 0, 6),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -12, 1, -12),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(19, 19, 19),
	})

	local tabs = library:create("Frame", {
		Parent = tab_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = tabs,
		Name = "",
		PaddingBottom = UDim.new(0, 22),
		PaddingRight = UDim.new(0, 20),
		PaddingLeft = UDim.new(0, 20),
	})

	local UIListLayout = library:create("UIListLayout", {
		Parent = tabs,
		Name = "",
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = UDim.new(0, 3),
	})

	local UIStroke = library:create("UIStroke", {
		Parent = tabs,
		Name = "",
		Color = Color3.fromRGB(57, 57, 57),
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local depth = library:create("Frame", {
		Parent = inline1,
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.5,
		Position = UDim2.new(0, 0, 0, 1),
		Size = UDim2.new(1, 0, 0, 1),
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	})

	library.keybind_path = tabs
	--

	function cfg.toggle_list(bool)
		old_kblist.Visible = bool
	end

	function cfg.toggle_playerlist(bool)
		playerlist.Visible = bool
	end

	function cfg.toggle_espPreview(bool)
		esp_preview.Visible = bool
	end

	function cfg.toggle_watermark(bool)
		__holder.Visible = bool
	end

	function cfg.set_menu_visibility(bool, pl)
		WINDOW_PATH.Visible = bool

		playerlist.Visible = flags["player_list"] and bool or false
		esp_preview.Visible = flags["esp_preview"] and bool or false
	end

	return setmetatable(cfg, library)
end

function library:new_keybind(properties)
	local cfg = {
		text = properties.name or properties.text or "aimbot",
		key = properties.key or nil,
		mode = properties.mode or "hold",
	}

	local keybind_text = library:create("TextLabel", {
		Parent = library.keybind_path,
		Name = "",
		FontFace = library.font,
		LineHeight = 1.2000000476837158,
		TextStrokeTransparency = 0.5,
		AnchorPoint = Vector2.new(0.5, 0),
		TextSize = 12,
		Size = UDim2.new(0, 0, 0, 11),
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = "",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0, 8),
		BorderSizePixel = 0,
		Visible = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local stroke = Instance.new("UIStroke", keybind_text)
	stroke.LineJoinMode = Enum.LineJoinMode.Miter

	local UIPadding = library:create("UIPadding", {
		Parent = keybind_text,
		Name = "",
		PaddingTop = UDim.new(0, 6),
	})

	function cfg.set_visible(bool)
		keybind_text.Visible = bool
	end

	function cfg.change_text(text)
		keybind_text.Text = text
	end

	-- register with the accent theme so changing the accent recolors active binds
	library:apply_theme(keybind_text, "accent", "TextColor3")

	function cfg.set_active(bool)
		keybind_text.TextColor3 = bool and themes.preset.accent or Color3.fromRGB(170, 170, 170)
	end

	function keyName(key)
		local text = tostring(key) ~= "Enums" and (keys[key] or tostring(key):gsub("Enum.", "")) or nil
		local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))

		return __text or "..."
	end

	-- Shit ass function
	function cfg.update(n_properties)
		cfg.change_text(
			"["
				.. tostring(keyName(n_properties.key))
				.. "] "
				.. tostring(n_properties.text)
				.. " ("
				.. tostring(n_properties.mode)
				.. ")"
		)
	end

	cfg.change_text(
		"[" .. tostring(keyName(cfg.key)) .. "] " .. tostring(cfg.text) .. " (" .. tostring(cfg.mode) .. ")"
	)

	return cfg
end

function library:notification(properties)
	local cfg = {
		time = properties.time or 5,
		text = properties.text or properties.name or "ledger.live is pasted",
	}

	-- 28 offset

	function cfg:refresh_notifications()
		for _, notif in next, library.notifications do
			tween_service
				:Create(
					notif,
					TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
					{ Position = dim2(0, 20, 0, 72 + (_ * 28)) }
				)
				:Play()
		end
	end

	-- Instances
	local holder = library:create("Frame", {
		Parent = library.gui,
		Name = "",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 20, 0, 72 + (#library.notifications * 28)),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		ZIndex = 2,
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		AnchorPoint = Vector2.new(1, 0),
	})

	local inline1 = library:create("Frame", {
		Parent = holder,
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(0, 0, 0, 24),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
	})

	local inline2 = library:create("Frame", {
		Parent = inline1,
		Name = "",
		Position = UDim2.new(0, 0, 0, 2),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -4, 1, -4),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	})

	local main = library:create("Frame", {
		Parent = inline2,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(57, 57, 57),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	})

	local tab_inline = library:create("Frame", {
		Parent = main,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -4, 1, -4),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(19, 19, 19),
	})

	local name = library:create("TextLabel", {
		Parent = tab_inline,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = cfg.text,
		TextStrokeTransparency = 0.5,
		Size = UDim2.new(0, 0, 1, 0),
		Position = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.X,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local stroke = Instance.new("UIStroke", name)
	stroke.LineJoinMode = Enum.LineJoinMode.Miter

	local UIPadding = library:create("UIPadding", {
		Parent = tab_inline,
		Name = "",
		PaddingRight = UDim.new(0, 14),
	})

	local depth = library:create("Frame", {
		Parent = inline1,
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.5,
		Position = UDim2.new(0, 1, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	})

	local accent_line = library:create("Frame", {
		Parent = inline1,
		Name = "",
		BorderColor3 = Color3.fromRGB(34, 34, 34),
		Size = UDim2.new(0, 2, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = themes.preset.accent,
	})

	library:apply_theme(accent_line, "accent", "BackgroundColor3")

	local glow = library:create("ImageLabel", {
		Parent = holder,
		Name = "",
		ImageColor3 = themes.preset.accent,
		ScaleType = Enum.ScaleType.Slice,
		ImageTransparency = 0.8999999761581421,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Image = "http://www.roblox.com/asset/?id=18245826428",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -20, 0, 0),
		Size = UDim2.new(0, 42, 1, 40),
		ZIndex = 2,
		BorderSizePixel = 0,
		SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
	})

	library:apply_theme(glow, "accent", "ImageColor3")
	--

	task.spawn(function()
		tween_service
			:Create(
				holder,
				TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
				{ AnchorPoint = Vector2.new(0, 0) }
			)
			:Play()

		task.wait(cfg.time)

		tween_service
			:Create(
				holder,
				TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
				{ AnchorPoint = Vector2.new(1, 0) }
			)
			:Play()
		for _, v in next, holder:GetDescendants() do
			if v:IsA("TextLabel") then
				tween_service
					:Create(
						v,
						TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
						{ TextTransparency = 1 }
					)
					:Play()
			elseif v:IsA("Frame") then
				tween_service
					:Create(
						v,
						TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
						{ BackgroundTransparency = 1 }
					)
					:Play()
			elseif v:IsA("ImageLabel") then
				tween_service
					:Create(
						v,
						TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
						{ ImageTransparency = 1 }
					)
					:Play()
			end
		end
	end)

	task.delay(cfg.time + 0.1, function()
		table.remove(library.notifications, table.find(library.notifications, holder))
		cfg:refresh_notifications()
		task.wait(0.5)
		holder:Destroy()
	end)

	table.insert(library.notifications, holder)
end

function library:tab(properties)
	local cfg = {
		name = properties.name or "tab",
		enabled = false,
	}

	-- Button
	local TAB_BUTTON = library:create("TextButton", {
		Parent = self.tab_holder,
		Name = "",
		FontFace = library.font,
		TextColor3 = themes.preset.unselected_text,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = cfg.name,
		TextStrokeTransparency = 0.5,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.3330000042915344, -4, 0, 22),
		BorderSizePixel = 0,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	library:apply_theme(TAB_BUTTON, "unselected_text", "TextColor3")

	local stroke = Instance.new("UIStroke", TAB_BUTTON)
	stroke.LineJoinMode = Enum.LineJoinMode.Miter

	local line = library:create("Frame", {
		Parent = TAB_BUTTON,
		Name = "",
		Position = UDim2.new(0, 0, 1, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 0, 2),
		BorderSizePixel = 0,
		BackgroundColor3 = rgb(57, 57, 57),
	})

	library:apply_theme(line, "accent", "BackgroundColor3")

	local glow = library:create("ImageLabel", {
		Parent = line,
		Name = "",
		ImageColor3 = themes.preset.accent,
		ScaleType = Enum.ScaleType.Slice,
		ImageTransparency = 0.8999999761581421,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Image = "http://www.roblox.com/asset/?id=18245826428",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -20, 0, -20),
		Size = UDim2.new(1, 40, 1, 40),
		ZIndex = 2,
		Visible = false,
		BorderSizePixel = 0,
		SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
	})

	library:apply_theme(glow, "accent", "ImageColor3")

	local depth = library:create("Frame", {
		Parent = line,
		Name = "",
		BackgroundTransparency = 0.5,
		Position = UDim2.new(0, 0, 0, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 0, 1),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	})
	--

	-- Tab Instances
	local TAB = library:create("Frame", {
		Parent = self.tab_instance_holder,
		Name = "",
		Visible = false,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local scrolling_columns = library:create("Frame", {
		Parent = TAB,
		Name = "",
		ClipsDescendants = true,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 6, 0, 6),
		Size = UDim2.new(1, -12, 1, -12),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	cfg["column_holder"] = scrolling_columns

	local UIListLayout = library:create("UIListLayout", {
		Parent = scrolling_columns,
		Name = "",
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local left = library:create("ScrollingFrame", {
		Parent = scrolling_columns,
		Name = "",
		ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 0,
		Size = UDim2.new(0.5, -64, 1, 0),
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 4, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
	})

	left:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		if library.current_element_open then
			library.current_element_open.set_visible(false)
			library.current_element_open.open = false
			library.current_element_open = nil
		end
	end)

	cfg["left"] = left

	local UIListLayout = library:create("UIListLayout", {
		Parent = left,
		Name = "",
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local UIPadding = library:create("UIPadding", {
		Parent = left,
		Name = "",
		PaddingBottom = UDim.new(0, 15),
	})

	local right = library:create("ScrollingFrame", {
		Parent = scrolling_columns,
		Name = "",
		ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 0,
		Size = UDim2.new(0.5, -64, 1, 0),
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, -50, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
	})

	right:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		if library.current_element_open then
			library.current_element_open.set_visible(false)
			library.current_element_open.open = false
			library.current_element_open = nil
		end
	end)

	cfg["right"] = right

	local UIListLayout = library:create("UIListLayout", {
		Parent = right,
		Name = "",
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local UIPadding = library:create("UIPadding", {
		Parent = right,
		Name = "",
		PaddingBottom = UDim.new(0, 15),
	})
	--

	function cfg.open_tab()
		if library.current_tab and library.current_tab[1] ~= TAB_BUTTON then
			local button = library.current_tab[1]
			button.TextColor3 = themes.preset.unselected_text

			local parent = button:FindFirstChildOfClass("Frame")
			parent.BackgroundColor3 = rgb(57, 57, 57)
			parent:FindFirstChildOfClass("ImageLabel").Visible = false

			library.current_tab[2].Visible = false
		end

		library.current_tab = {
			TAB_BUTTON,
			TAB,
		}

		line.BackgroundColor3 = themes.preset.accent
		glow.Visible = true
		TAB_BUTTON.TextColor3 = themes.preset.text
		TAB.Visible = true

		if library.current_element_open and library.current_element_open ~= cfg then
			library.current_element_open.set_visible(false)
			library.current_element_open.open = false
			library.current_element_open = nil
		end
	end

	TAB_BUTTON.MouseButton1Click:Connect(cfg.open_tab)

	return setmetatable(cfg, library)
end

function library:section(properties)
	local cfg = {
		name = properties.name or properties.Name or "Section",
		side = properties.side or properties.Side or "left",
	}

	-- Instances
	local section = library:create("Frame", {
		Parent = self[cfg.side],
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		ZIndex = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local section_inline = library:create("Frame", {
		Parent = section,
		Name = "",
		Position = UDim2.new(0, 0, 0, 4),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, 0, 1, -4),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local name = library:create("TextLabel", {
		Parent = section_inline,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = cfg.name,
		TextStrokeTransparency = 0.5,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 8, 0, 0),
		ZIndex = 2,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local stroke = Instance.new("UIStroke", name)
	stroke.LineJoinMode = Enum.LineJoinMode.Miter

	local section = library:create("Frame", {
		Parent = section_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	local elements = library:create("Frame", {
		Parent = section,
		Name = "",
		Position = UDim2.new(0, 12, 0, 12),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -24, 0, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local UIListLayout = library:create("UIListLayout", {
		Parent = elements,
		Name = "",
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = UDim.new(0, 3),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = section,
		Name = "",
		PaddingBottom = UDim.new(0, 13),
	})
	--

	cfg["holder"] = elements

	return setmetatable(cfg, library)
end

function library:hitpart_picker(properties)
	local cfg = {
		name = properties.name or properties.Name or "Hitpart",
		side = properties.side or properties.Side or "left",
		flag = properties.flag or "Hitpart",
		default = properties.default or { "Head" },
		type_char = properties.type or "R6",
		multi = properties.multi or false,
		callback = properties.callback or function() end,
		previous_holder = self,
	}

	flags[cfg.flag] = {}

	local bodyparts = {}
	local bools = {}

	local r15_hitpart_holder = library:create("Frame", {
		Parent = self[cfg.side],
		Name = "",
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 0, 272),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local hitpart_inline = library:create("Frame", {
		Parent = r15_hitpart_holder,
		Name = "",
		Position = UDim2.new(0, 0, 0, 4),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, 0, 1, -4),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local hitpart = library:create("Frame", {
		Parent = hitpart_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	if cfg.type_char == "R15" then
		bodyparts.Head = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -25, 0, 16),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 50, 0, 44),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.UpperTorso = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -42, 0, 64),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 84, 0, 76),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftUpperArm = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -86, 0, 64),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 34),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightUpperArm = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 46, 0, 64),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 34),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftUpperLeg = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -42, 0, 158),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 34),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftLowerLeg = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -42, 0, 196),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 42),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightFoot = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 2, 0, 242),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 6),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftFoot = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -42, 0, 242),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 6),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightLowerLeg = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 2, 0, 196),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 42),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightUpperLeg = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 2, 0, 158),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 34),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftHand = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -86, 0, 148),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 6),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightHand = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 46, 0, 148),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 6),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LowerTorso = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -42, 0, 144),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 84, 0, 10),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightLowerArm = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 46, 0, 102),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 42),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftLowerArm = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -86, 0, 102),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 42),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		local outline = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -10, 0, 96),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 20, 0, 20),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		})

		bodyparts.HumanoidRootPart = library:create("TextButton", {
			Text = "",
			Parent = outline,
			Name = "",
			Position = UDim2.new(0, 4, 0, 4),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(1, -8, 1, -8),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})
	else
		bodyparts.Head = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Text = "",
			Position = UDim2.new(0.5, -25, 0, 16),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 50, 0, 44),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.Torso = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Text = "",
			Position = UDim2.new(0.5, -42, 0, 64),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 84, 0, 90),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftArm = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -86, 0, 64),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 90),
			BorderSizePixel = 0,
			Text = "",
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightArm = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 46, 0, 64),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 90),
			Text = "",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightLeg = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 2, 0, 158),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 90),
			BorderSizePixel = 0,
			Text = "",
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftLeg = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -42, 0, 158),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 90),
			BorderSizePixel = 0,
			Text = "",
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		local hrp_out = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -10, 0, 99),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 20, 0, 20),
			BorderSizePixel = 0,
			Text = "",
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		})

		bodyparts.HumanoidRootPart = library:create("TextButton", {
			Parent = hrp_out,
			Name = "",
			Position = UDim2.new(0, 4, 0, 4),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(1, -8, 1, -8),
			BorderSizePixel = 0,
			Text = "",
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})
	end

	local name = library:create("TextLabel", {
		Parent = hitpart_inline,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = cfg.name,
		TextStrokeTransparency = 0.5,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 8, 0, 0),
		ZIndex = 2,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	function cfg.set(parts)
		flags[cfg.flag] = {}
		for name, button in pairs(bodyparts) do
			bools[name] = false
			local glow = button:FindFirstChildOfClass("ImageLabel")
			if glow then
				glow.Visible = false
			end
			button.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
		end

		for _, part in pairs(parts) do
			if bodyparts[part] then
				bools[part] = true
				table.insert(flags[cfg.flag], part)
				local glow = bodyparts[part]:FindFirstChildOfClass("ImageLabel")
				if glow then
					glow.Visible = true
				end
				bodyparts[part].BackgroundColor3 = themes.preset.accent
			end
		end

		cfg.callback(flags[cfg.flag])
	end

	for name, button in next, bodyparts do
		bools[name] = false

		library:apply_theme(button, "accent", "BackgroundColor3")

		local glow = library:create("ImageLabel", {
			Parent = button,
			Name = "",
			Visible = false,
			ImageColor3 = themes.preset.accent,
			ScaleType = Enum.ScaleType.Slice,
			ImageTransparency = 0.8999999761581421,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Image = "http://www.roblox.com/asset/?id=18245826428",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, -20, 0, -20),
			Size = UDim2.new(1, 40, 1, 40),
			ZIndex = 2,
			BorderSizePixel = 0,
			SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
		})

		library:apply_theme(glow, "accent", "ImageColor3")

		library:connection(button.MouseButton1Click, function()
			if not cfg.multi then
				cfg.set({ name })
			else
				bools[name] = not bools[name]

				if bools[name] then
					table.insert(flags[cfg.flag], name)
				else
					local index = table.find(flags[cfg.flag], name)
					table.remove(flags[cfg.flag], index)
				end

				glow.Visible = bools[name]
				button.BackgroundColor3 = bools[name] and themes.preset.accent or Color3.fromRGB(38, 38, 38)

				cfg.callback(flags[cfg.flag])
			end
		end)
	end

	if #cfg.default > 1 and not cfg.multi then
		cfg.default = { cfg.default[1] }
	end

	cfg.set(cfg.default)
	config_flags[cfg.flag] = cfg.set
	return setmetatable(cfg, library)
end

function library:espPreview(properties)
	local cfg = {
		name = properties.name or properties.Name or "Hitpart",
		side = properties.side or properties.Side or "left",
		flag = properties.flag or "Hitpart",
		default = properties.default or { "Head" },
		type_char = properties.type or "R6",
		multi = properties.multi or false,
		callback = properties.callback or function() end,
		previous_holder = self,
	}

	flags[cfg.flag] = {}

	local bodyparts = {}
	local bools = {}

	local r15_hitpart_holder = library:create("Frame", {
		Parent = self[cfg.side],
		Name = "",
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 0, 300),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local hitpart_inline = library:create("Frame", {
		Parent = r15_hitpart_holder,
		Name = "",
		Position = UDim2.new(0, 0, 0, 4),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, 0, 1, -4),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local hitpart = library:create("Frame", {
		Parent = hitpart_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})
    
    
	do --// ESP remake
		do -- Name
   		 local nameText = library:create("Frame", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(.07, 2, .015, 2),
			BorderColor3 = Color3.fromRGB(56, 56, 56),
			Size = UDim2.new(.84, 0, 0.04, 0),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			BackgroundTransparency = 1,
			Visible = true
	     })
         
		 local textLabel = library:create("TextLabel", {
			Parent = nameText,
			Name = "playerTextLol",
			Position = UDim2.new(0, 0, -.085, 0),
			BorderColor3 = Color3.fromRGB(56, 56, 56),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			BackgroundTransparency = 1,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Text = "Player",
			FontFace = library.font,
			TextSize = 12
	     })

    	 local textOutline = library:create("UIStroke", {
    		Parent = textLabel,
            LineJoinMode = "Miter",
            ZIndex = 1,
    	 })
		 themes.utility["Name"] = {Text = textLabel}
		 library:apply_theme(textLabel, "NameColor", "TextColor3")
		end

		do -- Distance
   		 local distanceText = library:create("Frame", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(.07, 2, .865, 2),
			BorderColor3 = Color3.fromRGB(56, 56, 56),
			Size = UDim2.new(.84, 0, 0.04, 0),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			BackgroundTransparency = 1,
			Visible = true
	     })
         
		 local textLabel = library:create("TextLabel", {
			Parent = distanceText,
			Name = "distanceTextLol",
			Position = UDim2.new(0, 0, 0, 0),
			BorderColor3 = Color3.fromRGB(56, 56, 56),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
			BackgroundTransparency = 1,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Text = "100M",
			FontFace = library.font,
			TextSize = 12
	     })

    	 local textOutline = library:create("UIStroke", {
    		Parent = textLabel,
            LineJoinMode = "Miter",
            ZIndex = 1,
    	 })
		 themes.utility["Distance"] = {Text = textLabel}
		 library:apply_theme(textLabel, "DistanceColor", "TextColor3")
		end
	  
		do -- Box
   		 local box = library:create("Frame", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(.07, 2, .06, 2),
			BorderColor3 = Color3.fromRGB(56, 56, 56),
			Size = UDim2.new(.84, 0, .8, 0),
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	     })

    	 local innerStroke = library:create("UIStroke", {
    		Parent = box,
    		ApplyStrokeMode = "Contextual",
            StrokeSizingMode = "FixedSize",
            LineJoinMode = "Miter",
            BorderStrokePosition = Enum.BorderStrokePosition.Inner,
            ZIndex = 1,
            Color = Color3.fromRGB(255, 255, 255)
    	 })
	  
      
    	 local outerStroke = library:create("UIStroke", {
    		Parent = box,
    		ApplyStrokeMode =  "Border",
            StrokeSizingMode = "FixedSize",
            LineJoinMode = "Miter",
            BorderStrokePosition = Enum.BorderStrokePosition.Outer,
            ZIndex = 0
    	 })

    	 local colorStroke = library:create("UIStroke", {
    		Parent = box,
    		ApplyStrokeMode = "Contextual",
            StrokeSizingMode = "FixedSize",
            LineJoinMode = "Miter",
            BorderStrokePosition = Enum.BorderStrokePosition.Inner,
            ZIndex = 0,
            Thickness = 2
    	 })
		 themes.utility["Box"] = {Box = box}
		 library:apply_theme(innerStroke, "BoxColor", "Color")
		end

		do -- Health Bar
   		 local healthbar = library:create("Frame", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(.055, 2, .06, 2),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(.004, 0, .8, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0,
			BorderSizePixel = 1
	     })

		 local bar = library:create("Frame", {
			Parent = healthbar,
			Name = "",
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(0, 255, 20),
			BackgroundTransparency = 0,
			BorderSizePixel = 0
	     })
    	 
		 local barGradient = library:create("UIGradient", {
    		Parent = bar,
    	 })
	  
    	 
		 themes.utility["HealthBar"] = {HealthBar = healthbar}
		 --library:apply_theme(barGradient, "GradientColor", "Color")
		end

	end
	
    
	if cfg.type_char == "R15" then
		bodyparts.Head = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -25, 0, 25),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 50, 0, 44),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.UpperTorso = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -42, 0, 72),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 84, 0, 76),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftUpperArm = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -86, 0, 72),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 34),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightUpperArm = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 46, 0, 72),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 34),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftUpperLeg = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -42, 0, 162),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 34),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftLowerLeg = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -42, 0, 196),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 42),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightFoot = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 2, 0, 242),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 6),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftFoot = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -42, 0, 242),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 6),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightLowerLeg = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 2, 0, 196),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 42),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightUpperLeg = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 2, 0, 162),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 34),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftHand = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -86, 0, 148),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 6),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightHand = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 46, 0, 148),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 6),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LowerTorso = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -42, 0, 144),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 84, 0, 10),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightLowerArm = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 46, 0, 102),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 42),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftLowerArm = library:create("TextButton", {
			Text = "",
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -86, 0, 102),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 42),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})
		
	 else
		bodyparts.Head = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Text = "",
			Position = UDim2.new(0.5, -25, 0, 16),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 50, 0, 44),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.Torso = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Text = "",
			Position = UDim2.new(0.5, -42, 0, 64),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 84, 0, 90),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftArm = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -86, 0, 64),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 90),
			BorderSizePixel = 0,
			Text = "",
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightArm = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 46, 0, 64),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 90),
			Text = "",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.RightLeg = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, 2, 0, 158),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 90),
			BorderSizePixel = 0,
			Text = "",
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		bodyparts.LeftLeg = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -42, 0, 158),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 40, 0, 90),
			BorderSizePixel = 0,
			Text = "",
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		local hrp_out = library:create("TextButton", {
			Parent = hitpart,
			Name = "",
			Position = UDim2.new(0.5, -10, 0, 99),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 20, 0, 20),
			BorderSizePixel = 0,
			Text = "",
			BackgroundColor3 = Color3.fromRGB(22, 22, 22),
		})

		bodyparts.HumanoidRootPart = library:create("TextButton", {
			Parent = hrp_out,
			Name = "",
			Position = UDim2.new(0, 4, 0, 4),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(1, -8, 1, -8),
			BorderSizePixel = 0,
			Text = "",
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})
	end

	local name = library:create("TextLabel", {
		Parent = hitpart_inline,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = cfg.name,
		TextStrokeTransparency = 0.5,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 8, 0, 0),
		ZIndex = 2,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	function cfg.set(parts)
		flags[cfg.flag] = {}
		for name, button in pairs(bodyparts) do
			bools[name] = false
			local glow = button:FindFirstChildOfClass("ImageLabel")
			if glow then
				glow.Visible = false
			end
			button.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
		end

		for _, part in pairs(parts) do
			if bodyparts[part] then
				bools[part] = true
				table.insert(flags[cfg.flag], part)
				local glow = bodyparts[part]:FindFirstChildOfClass("ImageLabel")
				if glow then
					glow.Visible = true
				end
				bodyparts[part].BackgroundColor3 = themes.preset.accent
			end
		end

		cfg.callback(flags[cfg.flag])
	end

	for name, button in next, bodyparts do
		bools[name] = false

		library:apply_theme(button, "accent", "BackgroundColor3")

		local glow = library:create("ImageLabel", {
			Parent = button,
			Name = "",
			Visible = false,
			ImageColor3 = themes.preset.accent,
			ScaleType = Enum.ScaleType.Slice,
			ImageTransparency = 0.8999999761581421,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Image = "http://www.roblox.com/asset/?id=18245826428",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, -20, 0, -20),
			Size = UDim2.new(1, 40, 1, 40),
			ZIndex = 2,
			BorderSizePixel = 0,
			SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
		})

		library:apply_theme(glow, "accent", "ImageColor3")

		library:connection(button.MouseButton1Click, function()
			if not cfg.multi then
				cfg.set({ name })
			else
				bools[name] = not bools[name]

				if bools[name] then
					table.insert(flags[cfg.flag], name)
				else
					local index = table.find(flags[cfg.flag], name)
					table.remove(flags[cfg.flag], index)
				end

				glow.Visible = bools[name]
				button.BackgroundColor3 = bools[name] and themes.preset.accent or Color3.fromRGB(38, 38, 38)

				cfg.callback(flags[cfg.flag])
			end
		end)
	end

	if #cfg.default > 1 and not cfg.multi then
		cfg.default = { cfg.default[1] }
	end

	cfg.set(cfg.default)
	config_flags[cfg.flag] = cfg.set
	return setmetatable(cfg, library)
end

local function getTextColor(cfg)
    	if cfg.warningType == "risky" then
			library:apply_theme(object, "risky", "TextColor3")
			return themes.preset.risky
    	 elseif cfg.warningType == "warning" then
			library:apply_theme(object, "warning", "TextColor3")
			return themes.preset.warning
		 else
			library:apply_theme(object, "text", "TextColor3")
			return themes.preset.text
    	end
    
    	--themes[value].risky or themes[value].warning
end

function library:toggle(properties)
	local cfg = {
		enabled = properties.enabled or nil,
		name = properties.name or "Toggle",
		flag = properties.flag or tostring(math.random(1, 9999999)),
		callback = properties.callback or function() end,
		default = properties.default or false,
		previous_holder = self,
		warningType = nil or properties.warningType
	}
	

	-- Instances
	local object = library:create("TextButton", {
		Parent = self.holder,
		Name = "",
		FontFace = library.font,
		TextColor3 = getTextColor(cfg),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = cfg.name,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -26, 0, 12),
		ZIndex = 1,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	if cfg.warningType == "risky" then
		library:apply_theme(object, "risky", "TextColor3")
	  elseif cfg.warningType == "warning" then
		library:apply_theme(object, "warning", "TextColor3")
	  else
		library:apply_theme(object, "text", "TextColor3")
	end
	
	local stroke = Instance.new("UIStroke", object)
	stroke.LineJoinMode = Enum.LineJoinMode.Miter

	local right_components = library:create("Frame", {
		Parent = object,
		Name = "",
		Position = UDim2.new(1, 22, 0, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(0, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local list = library:create("UIListLayout", {
		Parent = right_components,
		Name = "",
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Padding = UDim.new(0, 3),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local icon_inline = library:create("TextButton", {
		Parent = object,
		Name = "",
		Position = UDim2.new(0, -15, 0, 1),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(0, 10, 0, 10),
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local icon = library:create("Frame", {
		Parent = icon_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	local icon_2 = library:create("Frame", {
		Parent = icon,
		Name = "",
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = themes.preset.accent,
	})
	library:apply_theme(icon_2, "accent", "BackgroundColor3")

	local glow = library:create("ImageLabel", {
		Parent = icon_inline,
		Name = "",
		Visible = false,
		ImageColor3 = themes.preset.accent,
		ScaleType = Enum.ScaleType.Slice,
		ImageTransparency = 0.75,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Image = "http://www.roblox.com/asset/?id=18245826428",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -12, 0, -12),
		Size = UDim2.new(1, 24, 1, 24),
		ZIndex = 2,
		BorderSizePixel = 0,
		SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
	})

	library:apply_theme(glow, "accent", "ImageColor3")

	local bottom_components = library:create("Frame", {
		Parent = object,
		Name = "",
		Visible = true,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Position = UDim2.new(0, 0, 0, 13),
		Size = UDim2.new(1, 26, 0, 0),
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local list = library:create("UIListLayout", {
		Parent = bottom_components,
		Name = "",
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	--

	function cfg.set(bool)
		icon_2.Visible = bool
		glow.Visible = bool

		flags[cfg.flag] = bool

		cfg.callback(bool)
	end

	library:connection(object.MouseButton1Click, function()
		cfg.enabled = not cfg.enabled

		cfg.set(cfg.enabled)
	end)

	library:connection(icon_inline.MouseButton1Click, function()
		cfg.enabled = not cfg.enabled

		cfg.set(cfg.enabled)
	end)

	cfg.set(cfg.default)

	self.previous_holder = left_components
	self.bottom_holder = bottom_components
	self.right_holder = right_components

	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library), object
end

function library:label(properties)
	local cfg = {
		enabled = properties.enabled or nil,
		text = properties.text or "Label",
		flag = properties.flag or tostring(math.random(1, 9999999)),
		callback = properties.callback or function() end,
		default = properties.default or false,
		previous_holder = self,
	}

	-- Instances
	local object = library:create("TextButton", {
		Parent = self.holder,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Position = UDim2.new(0, -15, 0, 1),
		Text = cfg.text,
		TextStrokeTransparency = 0,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 1, 0, 12),
		ZIndex = 1,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	library:apply_theme(object, "text", "TextColor3")

	local stroke = Instance.new("UIStroke", object)
	stroke.LineJoinMode = Enum.LineJoinMode.Miter
    
	--object.Size = UDim2.new(0, object.TextBounds.X, object.Size.Y.Scale, object.Size.Y.Offset)
	--object.AutomaticSize = Enum.AutomaticSize.X
	local right_components = library:create("Frame", {
		Parent = object,
		Name = "",
		Position = UDim2.new(1, 8, 0, 1),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(0, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local list = library:create("UIListLayout", {
		Parent = right_components,
		Name = "",
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		Padding = UDim.new(0, 3),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})


	local bottom_components = library:create("Frame", {
		Parent = object,
		Name = "",
		Visible = true,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Position = UDim2.new(0, 0, 0, 13),
		Size = UDim2.new(1, 26, 0, 0),
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local list = library:create("UIListLayout", {
		Parent = bottom_components,
		Name = "",
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})
	--

	self.previous_holder = left_components
	self.bottom_holder = bottom_components
	self.right_holder = right_components

	config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:slider(properties)
	local cfg = {
		name = properties.name or nil,
		suffix = properties.suffix or "",
		flag = properties.flag or tostring(2 ^ 789),
		callback = properties.callback or function() end,

		min = properties.min or properties.minimum or 0,
		max = properties.max or properties.maximum or 100,
		intervals = properties.interval or properties.decimal or 1,
		default = properties.default or 10,

		dragging = false,
		value = properties.default or 10,

		previous_holder = self,
	}

	local bottom_components
	if cfg.name then
		object = library:create("TextLabel", {
			Parent = self.holder,
			Name = "",
			FontFace = library.font,
			TextColor3 = Color3.fromRGB(170, 170, 170),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Text = cfg.name,
			TextStrokeTransparency = 0.5,
			Size = UDim2.new(1, -24, 0, 12),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextSize = 12,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})

		library:apply_theme(object, "text", "TextColor3")

		bottom_components = library:create("Frame", {
			Parent = object,
			Name = "",
			Visible = true,
			Position = UDim2.new(0, 0, 0, 13),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(1, 26, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})

		local list = library:create("UIListLayout", {
			Parent = bottom_components,
			Name = "",
			Padding = UDim.new(0, 4),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	else
		self.bottom_holder.Parent.AutomaticSize = Enum.AutomaticSize.Y
		self.bottom_holder.Parent.TextYAlignment = Enum.TextYAlignment.Top
	end

	local slider_holder = library:create("Frame", {
		Parent = cfg.name and bottom_components or self.bottom_holder,
		Name = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local slider_inline = library:create("TextButton", {
		Parent = slider_holder,
		Name = "",
		Position = UDim2.new(0, 0, 0, 1),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -26, 0, 8),
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local fill_inline = library:create("Frame", {
		Parent = slider_inline,
		Name = "",
		Size = UDim2.new(0.5, 0, 1, 0),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(19, 19, 19),
	})

	local fill = library:create("Frame", {
		Parent = fill_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, 0, 1, -4),
		BackgroundColor3 = themes.preset.accent,
	})

	library:apply_theme(fill, "accent", "BackgroundColor3")
	library:apply_theme(fill, "accent", "BorderColor3")

	local VALUE_TEXT = library:create("TextLabel", {
		Parent = fill_inline,
		Name = "",
		RichText = true,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(0, 1, 0, 3),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 0, 0, 1),
		BorderSizePixel = 0,
		FontFace = library.font,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local stroke = Instance.new("UIStroke", VALUE_TEXT)
	stroke.LineJoinMode = Enum.LineJoinMode.Miter

	local glow = library:create("ImageLabel", {
		Parent = fill_inline,
		Name = "",
		ImageColor3 = themes.preset.accent,
		ScaleType = Enum.ScaleType.Slice,
		ImageTransparency = 0.8999999761581421,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Image = "http://www.roblox.com/asset/?id=18245826428",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -18, 0, -18),
		Size = UDim2.new(1, 36, 1, 36),
		ZIndex = 2,
		BorderSizePixel = 0,
		SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
	})

	library:apply_theme(glow, "accent", "ImageColor3")

	local add = library:create("TextButton", {
		Parent = slider_inline,
		Name = "",
		TextWrapped = true,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "+",
		TextStrokeTransparency = 0.5,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 5, 0, -1),
		Size = UDim2.new(0, 8, 0, 8),
		FontFace = library.font,
		TextSize = 8,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local sub = library:create("TextButton", {
		Parent = slider_inline,
		Name = "",
		TextWrapped = true,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "-",
		TextStrokeTransparency = 0.5,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -15, 0, -1),
		Size = UDim2.new(0, 8, 0, 8),
		FontFace = library.font,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local slider = library:create("Frame", {
		Parent = slider_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	local pad = library:create("UIPadding", {
		Parent = slider_holder,
		Name = "",
		PaddingBottom = UDim.new(0, -17),
	})

	-- Fill smoothing. Speed comes from flags["slider_tween_speed"]
	-- (0 = instant, higher = faster; reaches ~99% in 1 / speed seconds, default speed 10).
	local shown_alpha = 0
	local target_alpha = 0
	local first_set = true
	local last_px = -1

	local function get_speed()
		local speed = flags["slider_tween_speed"]

		if speed == nil then
			return 10
		end

		return type(speed) == "number" and speed or 0
	end

	function cfg.step_fill(dt)
		local speed = get_speed()

		if speed <= 0 then
			shown_alpha = target_alpha
		else
			shown_alpha = shown_alpha + (target_alpha - shown_alpha) * (1 - math.exp(-dt * speed * 4.6))
		end

		if math.abs(target_alpha - shown_alpha) < 0.0005 then
			shown_alpha = target_alpha
			library.animated_sliders[cfg] = nil
		end

		-- only touch the instance when the bar actually moves by a whole pixel
		local width = slider.AbsoluteSize.X
		local px = width > 0 and math.floor(shown_alpha * width + 0.5) or -1

		if px == -1 or px ~= last_px then
			last_px = px
			fill_inline.Size = dim2(shown_alpha, 0, 1, 0)
		end
	end

	local function set_fill(alpha)
		target_alpha = alpha

		-- initial value and speed 0 are applied instantly
		if first_set or get_speed() <= 0 then
			first_set = false
			shown_alpha = alpha
			fill_inline.Size = dim2(alpha, 0, 1, 0)
			library.animated_sliders[cfg] = nil
			return
		end

		library.animated_sliders[cfg] = true
	end

	function cfg.set(value)
		if type(value) ~= "number" then
			return
		end

		cfg.value = math.clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

		set_fill((cfg.value - cfg.min) / (cfg.max - cfg.min))
		VALUE_TEXT.Text = tostring(cfg.value) .. cfg.suffix
		flags[cfg.flag] = cfg.value

		cfg.callback(flags[cfg.flag])
	end

	local drag_conn

	local function drag_step()
		local x = uis:GetMouseLocation().X
		local size_x = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
		local value = math.clamp(
			library:round(((cfg.max - cfg.min) * size_x) + cfg.min, cfg.intervals),
			cfg.min,
			cfg.max
		)

		if value ~= cfg.value then
			cfg.set(value)
		end
	end

	library:connection(uis.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			cfg.dragging = false

			if drag_conn then
				drag_conn:Disconnect()
				drag_conn = nil
			end
		end
	end)

	slider_inline.MouseButton1Down:Connect(function()
		cfg.dragging = true

		if not drag_conn then
			drag_conn = run.RenderStepped:Connect(drag_step)
		end

		drag_step()
	end)

	add.MouseButton1Down:Connect(function()
		cfg.value += cfg.intervals
		cfg.set(cfg.value)
	end)

	sub.MouseButton1Down:Connect(function()
		cfg.value -= cfg.intervals
		cfg.set(cfg.value)
	end)

	cfg.set(cfg.default)

	config_flags[cfg.flag] = cfg.set

	library.config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:dropdown(properties)
	local cfg = {
		name = properties.name or nil,
		flag = properties.flag or tostring(math.random(1, 9999999)),

		items = properties.items or { "1", "2", "3" },
		callback = properties.callback or function() end,
		multi = properties.multi or false,

		open = false,
		option_instances = {},
		multi_items = {},

		previous_holder = self,
	}
	cfg.default = properties.default or (cfg.multi and { cfg.items[1] }) or cfg.items[1] or nil

	local bottom_components
	local object
	if cfg.name then
		object = library:create("TextLabel", {
			Parent = self.holder,
			Name = "",
			FontFace = library.font,
			TextColor3 = Color3.fromRGB(170, 170, 170),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Position = UDim2.new(0, 0, 0, 0), -- Aligned to X = 0 (matches toggle text)
			Text = cfg.name,
			TextStrokeTransparency = 0.5,
			Size = UDim2.new(1, -26, 0, 12),
			BorderSizePixel = 0,
			ZIndex = 2,
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextSize = 12,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})

		library:apply_theme(object, "text", "TextColor3")

		bottom_components = library:create("Frame", {
			Parent = object,
			Name = "",
			Visible = true,
			Position = UDim2.new(0, 0, 0, 13),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(1, 0, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})

		local list = library:create("UIListLayout", {
			Parent = bottom_components,
			Name = "",
			Padding = UDim.new(0, 2),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	else
		self.bottom_holder.Parent.AutomaticSize = Enum.AutomaticSize.Y
		self.bottom_holder.Parent.TextYAlignment = Enum.TextYAlignment.Top
	end

	-- Instances
	local dropdown_inline = library:create("Frame", {
		Parent = cfg.name and bottom_components or self.bottom_holder,
		Name = "",
		Position = UDim2.new(0, 0, 0, 2), -- Aligned to X = 0
		Size = cfg.name and UDim2.new(1, 0, 0, 16) or UDim2.new(1, -26, 0, 16),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local dropdown = library:create("TextButton", {
		Parent = dropdown_inline,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "option 1, option 3",
		TextStrokeTransparency = 0.5,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -4, 1, -4),
		Position = UDim2.new(0, 2, 0, 2),
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = dropdown,
		Name = "",
		PaddingLeft = UDim.new(0, 5),
	})

	local icon = library:create("TextLabel", {
		Parent = dropdown,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = "+",
		TextStrokeTransparency = 0.5,
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Right,
		Position = UDim2.new(1, -6, 0, -1),
		BorderSizePixel = 0,
		TextSize = 8,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local content_inline = library:create("Frame", {
		Parent = library.gui,
		Name = "",
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(0, dropdown_inline.AbsoluteSize.X, 0, 0),
		Position = UDim2.new(
			0,
			dropdown_inline.AbsolutePosition.X,
			0,
			dropdown_inline.AbsolutePosition.Y + dropdown_inline.AbsoluteSize.Y + 2
		),
		BorderSizePixel = 0,
		ZIndex = 2,
		Visible = false,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local position_conn

	local function update_content_pos()
		content_inline.Position = UDim2.new(
			0,
			dropdown_inline.AbsolutePosition.X,
			0,
			dropdown_inline.AbsolutePosition.Y + dropdown_inline.AbsoluteSize.Y + 2
		)
		content_inline.Size = UDim2.new(0, dropdown_inline.AbsoluteSize.X, 0, 0)
	end

	local content = library:create("Frame", {
		Parent = content_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local options = library:create("Frame", {
		Parent = content,
		Name = "",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -4, 1, -4),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
	})

	local UIListLayout = library:create("UIListLayout", {
		Parent = options,
		Name = "",
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local UIPadding = library:create("UIPadding", {
		Parent = options,
		Name = "",
		PaddingBottom = UDim.new(0, 4),
	})

	function cfg.set_visible(bool)
		if position_conn then
			position_conn:Disconnect()
			position_conn = nil
		end

		if bool then
			update_content_pos()
			position_conn = dropdown_inline:GetPropertyChangedSignal("AbsolutePosition"):Connect(update_content_pos)
		end

		content_inline.Visible = bool

		icon.Text = bool and "-" or "+"
		icon.TextSize = bool and 12 or 8

		if cfg.name then
			object.ZIndex = bool and 9999 or 3
		end

		if bool then
			if library.current_element_open and library.current_element_open ~= cfg then
				library.current_element_open.set_visible(false)
				library.current_element_open.open = false
			end

			library.current_element_open = cfg
		end
	end

	function cfg.set(value)
		local selected = {}

		local is_table = type(value) == "table"

		for _, v in next, cfg.option_instances do
			if v.Text == value or (is_table and table.find(value, v.Text)) then
				table.insert(selected, v.Text)
				cfg.multi_items = selected
				v.BackgroundTransparency = 0
			else
				v.BackgroundTransparency = 1
			end
		end

		dropdown.Text = is_table and table.concat(selected, ",  ") or selected[1] or ""
		flags[cfg.flag] = is_table and selected or selected[1]
		cfg.callback(flags[cfg.flag])
	end

	function cfg:refresh_options(refreshed_list)
		for _, v in next, cfg.option_instances do
			v:Destroy()
		end

		cfg.option_instances = {}

		for i, v in next, refreshed_list do
			local op3 = library:create("TextButton", {
				Parent = options,
				Name = "",
				FontFace = library.font,
				TextColor3 = Color3.fromRGB(170, 170, 170),
				BorderColor3 = Color3.fromRGB(56, 56, 56),
				Text = v,
				BackgroundTransparency = 1,
				TextStrokeTransparency = 0.5,
				Size = UDim2.new(1, 0, 0, 14),
				TextXAlignment = Enum.TextXAlignment.Left,
				Position = UDim2.new(0, 2, 0, 2),
				BorderSizePixel = 0,
				TextSize = 12,
				BackgroundColor3 = Color3.fromRGB(65, 65, 65),
			})

			local UIPadding = library:create("UIPadding", {
				Parent = op3,
				Name = "",
				PaddingLeft = UDim.new(0, 5),
			})

			table.insert(cfg.option_instances, op3)

			op3.MouseButton1Down:Connect(function()
				if cfg.multi then
					local selected_index = table.find(cfg.multi_items, op3.Text)

					if selected_index then
						table.remove(cfg.multi_items, selected_index)
					else
						table.insert(cfg.multi_items, op3.Text)
					end

					cfg.set(cfg.multi_items)
				else
					cfg.set_visible(false)
					cfg.open = false

					cfg.set(op3.Text)
				end
			end)
		end

		dropdown.Text = ""
	end

	dropdown.MouseButton1Click:Connect(function()
		cfg.open = not cfg.open

		cfg.set_visible(cfg.open)
	end)

	cfg:refresh_options(cfg.items)

	cfg.set(cfg.default)

	library.config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:colorpicker(properties)
	local cfg = {
		name = properties.name or nil,
		flag = properties.flag or tostring(2 ^ 789),
		color = properties.color or properties.default or Color3.new(1, 1, 1), -- Default to white color if not provided
		alpha = properties.alpha or 1,
		callback = properties.callback or function() end,
		animation = "normal",
		saved_color,
		right_holder = self.right_holder or nil,
		holder = self.holder or nil,
	}

	flags[cfg.flag] = {}

	local dragging_sat = false
	local dragging_hue = false
	local dragging_alpha = false

	local h, s, v = cfg.color:ToHSV()
	local a = cfg.alpha

	-- Button Instances
	local right_components
	if cfg.name then
		local object = library:create("TextLabel", {
			Parent = self.holder,
			Name = "",
			FontFace = library.font,
			TextColor3 = Color3.fromRGB(170, 170, 170),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Text = cfg.name,
			TextStrokeTransparency = 0.5,
			Size = UDim2.new(1, -26, 0, 12),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextSize = 12,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})

		library:apply_theme(object, "text", "TextColor3")

		right_components = library:create("Frame", {
			Parent = object,
			Name = "",
			Position = UDim2.new(1, 15, 0, 1),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})

		local list = library:create("UIListLayout", {
			Parent = right_components,
			Name = "",
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = UDim.new(0, 3),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	end

	local icon_inline = library:create("TextButton", {
		Parent = cfg.name and right_components or self.right_holder,
		Name = "",
		Text = "",
		Size = UDim2.new(0, 16, 0, 10),
		Position = UDim2.new(0, -15, 0, 1),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		ZIndex = 3,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(9, 9, 44),
	})

	local icon = library:create("Frame", {
		Parent = icon_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(22, 22, 108),
		ZIndex = 2,
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(41, 41, 204),
	})

	local glow = library:create("ImageLabel", {
		Parent = icon_inline,
		Name = "",
		ImageColor3 = Color3.fromRGB(41, 41, 204),
		ScaleType = Enum.ScaleType.Slice,
		ImageTransparency = 0.8999999761581421,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Image = "http://www.roblox.com/asset/?id=18245826428",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, -20, 0, -20),
		Size = UDim2.new(1, 40, 1, 40),
		ZIndex = 2,
		BorderSizePixel = 0,
		SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
	})
	--

	-- Colorpicker Instances
	local picker_inline = library:create("Frame", {
		Parent = library.gui,
		Name = "",
		Size = UDim2.new(0, 142, 0, 146),
		Position = dim2(0, icon_inline.AbsolutePosition.X + 1, 0, icon_inline.AbsolutePosition.Y + 17),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		ZIndex = 9999,
		BorderSizePixel = 0,
		Visible = false,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local picker = library:create("Frame", {
		Parent = picker_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local sat_inline = library:create("TextButton", {
		Parent = picker,
		Name = "",
		Text = "",
		Position = UDim2.new(0, 4, 0, 4),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -8, 1, -50),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local sat = library:create("Frame", {
		Parent = sat_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(255, 0, 0),
	})

	local sat_white = library:create("Frame", {
		Parent = sat,
		Name = "",
		Size = UDim2.new(1, 0, 1, 0),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local UIGradient = library:create("UIGradient", {
		Parent = sat_white,
		Name = "",
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1),
		}),
	})

	local sat_black = library:create("Frame", {
		Parent = sat_white,
		Name = "",
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local UIGradient = library:create("UIGradient", {
		Parent = sat_black,
		Name = "",
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
		}),
	})

	local sat_black_cursor = library:create("Frame", {
		Parent = sat_black,
		Name = "",
		Position = UDim2.new(0.800000011920929, 0, 0.20000000298023224, 0),
		BorderColor3 = Color3.fromRGB(108, 22, 22),
		Size = UDim2.new(0, 1, 0, 1),
		BackgroundColor3 = Color3.fromRGB(204, 41, 41),
	})

	local preview_inline = library:create("Frame", {
		Parent = picker,
		Name = "",
		Position = UDim2.new(1, -20, 1, -20),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(0, 16, 0, 16),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(35, 35, 35),
	})

	local preview = library:create("Frame", {
		Parent = preview_inline,
		Name = "",
		BackgroundTransparency = 0,
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		ZIndex = 2,
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(204, 41, 41),
	})

	local preview_image = library:create("ImageLabel", {
		Parent = preview_inline,
		Name = "",
		ScaleType = Enum.ScaleType.Tile,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Image = "http://www.roblox.com/asset/?id=18274452449",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		TileSize = UDim2.new(0, 6, 0, 6),
		BorderSizePixel = 0,
		ZIndex = 3,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local hue_inline = library:create("TextButton", {
		Parent = picker,
		Text = "",
		Name = "",
		Position = UDim2.new(0, 4, 1, -44),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -8, 0, 10),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local hue_border = library:create("Frame", {
		Parent = hue_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local hue = library:create("Frame", {
		Parent = hue_border,
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local UIGradient = library:create("UIGradient", {
		Parent = hue,
		Name = "",
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.16699999570846558, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.3330000042915344, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.6669999957084656, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.8330000042915344, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
		}),
	})

	local hue_cursor = library:create("Frame", {
		Parent = hue,
		Name = "",
		BorderColor3 = Color3.fromRGB(108, 22, 22),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = Color3.fromRGB(204, 41, 41),
	})

	local input_inline = library:create("Frame", {
		Parent = picker,
		Name = "",
		Position = UDim2.new(0, 4, 1, -20),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -26, 0, 16),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local __input = library:create("TextBox", {
		Parent = input_inline,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "204, 41, 41, 0.5",
		TextStrokeTransparency = 0.5,
		Size = UDim2.new(1, -4, 1, -4),
		PlaceholderColor3 = Color3.fromRGB(90, 90, 90),
		Position = UDim2.new(0, 2, 0, 2),
		PlaceholderText = "r, g, b, a",
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local alpha_inline = library:create("TextButton", {
		Parent = picker,
		Name = "",
		Text = "",
		Position = UDim2.new(0, 4, 1, -32),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -8, 0, 10),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local alpha = library:create("Frame", {
		Parent = alpha_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(204, 41, 41),
	})

	local alpha_image = library:create("ImageLabel", {
		Parent = alpha,
		Name = "",
		ScaleType = Enum.ScaleType.Tile,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Image = "http://www.roblox.com/asset/?id=18343135386",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		TileSize = UDim2.new(0, 6, 0, 6),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local UIGradient = library:create("UIGradient", {
		Parent = alpha_image,
		Name = "",
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
	})

	local alpha_cursor = library:create("Frame", {
		Parent = alpha_image,
		Name = "",
		Position = UDim2.new(0.5, 0, 0, 0),
		BorderColor3 = Color3.fromRGB(108, 22, 22),
		Size = UDim2.new(0, 1, 1, 0),
		BackgroundColor3 = Color3.fromRGB(204, 41, 41),
	})

	--

	-- Animation Handling
	local content_inline = library:create("Frame", {
		Parent = library.gui,
		Name = "",
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(0, 73, 0, 0),
		Position = dim2(0, icon_inline.AbsolutePosition.X + 20, 0, icon_inline.AbsolutePosition.Y),
		BorderSizePixel = 0,
		ZIndex = 2,
		Visible = false,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local content = library:create("Frame", {
		Parent = content_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local options = library:create("Frame", {
		Parent = content,
		Name = "",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -4, 1, -4),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
	})

	local UIListLayout = library:create("UIListLayout", {
		Parent = options,
		Name = "",
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local normal = library:create("TextButton", {
		Parent = options,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "normal",
		TextStrokeTransparency = 0.5,
		Size = UDim2.new(1, 0, 0, 12),
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 2, 0, 2),
		BorderSizePixel = 0,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(65, 65, 65),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = normal,
		Name = "",
		PaddingBottom = UDim.new(0, 1),
		PaddingLeft = UDim.new(0, 5),
	})

	local rainbow = library:create("TextButton", {
		Parent = options,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "rainbow",
		TextStrokeTransparency = 0.5,
		Size = UDim2.new(1, 0, 0, 12),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 2, 0, 2),
		BorderSizePixel = 0,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(65, 65, 65),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = rainbow,
		Name = "",
		PaddingBottom = UDim.new(0, 1),
		PaddingLeft = UDim.new(0, 5),
	})

	local fade = library:create("TextButton", {
		Parent = options,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "fade",
		TextStrokeTransparency = 0.5,
		Size = UDim2.new(1, 0, 0, 12),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 2, 0, 2),
		BorderSizePixel = 0,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(65, 65, 65),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = fade,
		Name = "",
		PaddingBottom = UDim.new(0, 1),
		PaddingLeft = UDim.new(0, 5),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = options,
		Name = "",
		PaddingBottom = UDim.new(0, 4),
	})

	local fade_alpha = library:create("TextButton", {
		Parent = options,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "fade alpha",
		TextStrokeTransparency = 0.5,
		Size = UDim2.new(1, 0, 0, 12),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 2, 0, 2),
		BorderSizePixel = 0,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(65, 65, 65),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = fade_alpha,
		Name = "",
		PaddingBottom = UDim.new(0, 1),
		PaddingLeft = UDim.new(0, 5),
	})
	--

	function cfg.set_visible(bool)
		picker_inline.Visible = bool
		content_inline.Visible = false

		if bool then
			if library.current_element_open and library.current_element_open ~= cfg then
				library.current_element_open.set_visible(false)
				library.current_element_open.open = false
			end

			library.current_element_open = cfg
		end

		picker_inline.Position = dim2(0, icon_inline.AbsolutePosition.X + 1, 0, icon_inline.AbsolutePosition.Y + 17)
		content_inline.Position = dim2(0, icon_inline.AbsolutePosition.X + 20, 0, icon_inline.AbsolutePosition.Y)
	end

	icon_inline.MouseButton1Click:Connect(function()
		cfg.open = not cfg.open

		cfg.set_visible(cfg.open)
	end)

	icon_inline.MouseButton2Click:Connect(function()
		if cfg.open then
			cfg.open = false
			cfg.set_visible(false)
		end

		content_inline.Visible = not content_inline.Visible

		picker_inline.Position = dim2(0, icon_inline.AbsolutePosition.X + 1, 0, icon_inline.AbsolutePosition.Y + 17)
		content_inline.Position = dim2(0, icon_inline.AbsolutePosition.X + 20, 0, icon_inline.AbsolutePosition.Y)
	end)

	function cfg.set(color, alpha)
		if color then
			h, s, v = color:ToHSV()
		else
			-- [OPT/fix] was hsv(s, s, v) (hue passed as saturation)
			cfg.saved_color = hsv(h, s, v)
		end

		if alpha then
			a = alpha
		end

		local visual = alpha_inline:FindFirstChildOfClass("Frame")

		if not visual then
			return
		end

		local hsv_position = Color3.fromHSV(h, s, v)
		local Color = Color3.fromHSV(h, s, v)

		local value = h
		local offset = (value < 1) and 0 or -4
		hue_cursor.Position = dim2(value, offset, 0, 0)

		local offset = (a < 1) and 0 or -4
		alpha_cursor.Position = dim2(a, offset, 0, 0)

		visual.BackgroundColor3 = Color
		glow.ImageColor3 = Color

		local RGB_Format = visual.BackgroundColor3

		icon_inline.BackgroundColor3 = Color3.fromRGB(RGB_Format.R / 4, RGB_Format.G / 4, RGB_Format.B / 4)
		icon.BorderColor3 = Color3.fromRGB(
			math.floor((Color.R * 255) + 0.5) / 2,
			math.floor((Color.G * 255) + 0.5) / 2,
			math.floor((Color.B * 255) + 0.5) / 2
		)
		icon.BackgroundColor3 = Color

		__input.Text = math.floor(RGB_Format.R * 255)
			.. ", "
			.. math.floor(RGB_Format.G * 255)
			.. ", "
			.. math.floor(RGB_Format.B * 255)
			.. ", "
			.. library:round(a, 0.01)
		preview.BackgroundColor3 = Color
		preview_image.ImageTransparency = 1 - a

		sat.BackgroundColor3 = Color3.fromHSV(h, 1, 1)

		local s_offset = (s < 1) and 0 or -3
		local v_offset = (1 - v < 1) and 0 or -3
		sat_black_cursor.Position = dim2(s, s_offset, 1 - v, v_offset)

		cfg.color = Color
		cfg.alpha = a

		-- [OPT/fix] keep the animation mode in the flag (it used to be wiped on every set)
		flags[cfg.flag] = {
			Color = Color,
			Transparency = a,
			animation = cfg.animation,
		}

		-- only remember the "base" color while not animating, so switching back to normal restores it
		if cfg.animation == "normal" then
			cfg.saved_color = hsv(h, s, v)
		end

		cfg.callback(Color, a)
	end

	__input.FocusLost:Connect(function()
		local text = __input.Text
		local r, g, b, a = library:convert_string_rgb(text)

		if r and g and b and a then
			cfg.set(rgb(r, g, b), a)
		end
	end)

	function cfg.update_color()
		local mouse = uis:GetMouseLocation()

		if dragging_sat then
			s = math.clamp(
				(vec2(mouse.X, mouse.Y - gui_offset) - sat_white.AbsolutePosition).X / sat_white.AbsoluteSize.X,
				0,
				1
			)
			v = 1
				- math.clamp(
					(vec2(mouse.X, mouse.Y - gui_offset) - sat_black.AbsolutePosition).Y / sat_black.AbsoluteSize.Y,
					0,
					1
				)
		elseif dragging_hue then
			h = 1
				- math.clamp(
					1
						- (vec2(mouse.X, mouse.Y - gui_offset) - hue_inline.AbsolutePosition).X
							/ hue_inline.AbsoluteSize.X,
					0,
					1
				)
		elseif dragging_alpha then
			a = math.clamp(
				(vec2(mouse.X, mouse.Y - gui_offset) - alpha_inline.AbsolutePosition).X / alpha_inline.AbsoluteSize.X,
				0,
				1
			)
		end

		cfg.set(nil, nil)
	end

	alpha_inline.MouseButton1Down:Connect(function()
		dragging_alpha = true
	end)

	hue_inline.MouseButton1Down:Connect(function()
		dragging_hue = true
	end)

	sat_inline.MouseButton1Down:Connect(function()
		dragging_sat = true
	end)

	-- [OPT] Animation modes.
	-- Before: `selected` was the `normal` *Instance*, so `selected ~= "normal"` was always true and
	-- EVERY colorpicker re-ran cfg.set (≈15 property writes + callback) on EVERY frame forever.
	-- Now: `selected` is a string, and only pickers in rainbow/fade/fade alpha are registered in
	-- library.animated_pickers, which is stepped by the single shared Heartbeat loop above.
	cfg.saved_color = hsv(h, s, v)
	local selected = "normal"
	local selected_button = normal
	flags[cfg.flag]["animation"] = "normal"

	local function set_animation(mode, button)
		if selected == "normal" then
			cfg.saved_color = hsv(h, s, v)
		end

		selected_button.BackgroundTransparency = 1
		selected_button = button
		button.BackgroundTransparency = 0

		selected = mode
		cfg.animation = mode
		flags[cfg.flag]["animation"] = mode

		if mode == "normal" then
			library.animated_pickers[cfg] = nil
			cfg.set(cfg.saved_color)
		else
			library.animated_pickers[cfg] = true
		end
	end

	function cfg.animate()
		local sin = library.sin

		cfg.set(
			hsv(
				selected == "rainbow" and sin or h,
				selected == "rainbow" and 1 or s,
				selected == "fade" and sin or v
			),
			selected == "fade_alpha" and sin or nil
		)
	end

	rainbow.MouseButton1Down:Connect(function()
		set_animation("rainbow", rainbow)
	end)

	fade_alpha.MouseButton1Down:Connect(function()
		set_animation("fade_alpha", fade_alpha)
	end)

	fade.MouseButton1Down:Connect(function()
		set_animation("fade", fade)
	end)

	normal.MouseButton1Down:Connect(function()
		set_animation("normal", normal)
	end)

	-- [OPT] now tracked by library so unload() disconnects them
	library:connection(uis.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging_sat = false
			dragging_hue = false
			dragging_alpha = false
		end
	end)

	library:connection(uis.InputChanged, function(input)
		if
			(dragging_sat or dragging_hue or dragging_alpha)
			and input.UserInputType == Enum.UserInputType.MouseMovement
		then
			cfg.update_color()
		end
	end)

	cfg.set(cfg.color, cfg.alpha)

	self.previous_holder = parent

	library.config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:keybind(properties)
	local cfg = {
		flag = properties.flag or tostring(2 ^ math.random(1, 30) * 3),
		keybind_name = properties.keybind_name or nil,
		callback = properties.callback or function() end,
		open = false,
		binding = nil,
		name = properties.name or nil,
		key = properties.default or properties.key or nil,
		mode = properties.mode or "toggle",
		active = properties.default or false,
		display = properties.displayName or properties.display or properties.name or nil,
		hold_instances = {},
	}

	flags[cfg.flag] = {}

	local key = library:new_keybind({
		text = cfg.display,
		key = cfg.key,
		mode = cfg.mode,
	})

	-- Instances
	local right_components
	if cfg.name then
		local object = library:create("TextLabel", {
			Parent = self.holder,
			Name = "",
			FontFace = library.font,
			TextColor3 = Color3.fromRGB(170, 170, 170),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Text = cfg.name,
			TextStrokeTransparency = 0.5,
			Size = UDim2.new(1, -26, 0, 12),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextSize = 12,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})

		library:apply_theme(object, "text", "TextColor3")

		right_components = library:create("Frame", {
			Parent = object,
			Name = "",
			Position = UDim2.new(1, 15, 0, 1),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			Size = UDim2.new(0, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		})

		local list = library:create("UIListLayout", {
			Parent = right_components,
			Name = "",
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = UDim.new(0, 3),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	end

	local keybind = library:create("TextButton", {
		Parent = cfg.name and right_components or self.right_holder,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = "ERROR",
		TextStrokeTransparency = 0.5,
		Size = UDim2.new(0, 16, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local content_inline = library:create("Frame", {
		Parent = library.gui,
		Name = "",
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(0, 57, 0, 0),
		Position = dim2(0, keybind.AbsolutePosition.X, 0, keybind.AbsolutePosition.Y - 5),
		BorderSizePixel = 0,
		ZIndex = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Visible = false,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	-- [OPT] only track the anchor's position while the popup is open (was always-on)
	local position_conn

	local function update_content_pos()
		content_inline.Position = UDim2.new(0, keybind.AbsolutePosition.X, 0, keybind.AbsolutePosition.Y + 15)
	end

	local content = library:create("Frame", {
		Parent = content_inline,
		Name = "",
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Size = UDim2.new(1, -4, 1, -4),
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	local options = library:create("Frame", {
		Parent = content,
		Name = "",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 2, 0, 2),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.new(1, -4, 1, -4),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
	})

	local UIListLayout = library:create("UIListLayout", {
		Parent = options,
		Name = "",
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local press = library:create("TextButton", {
		Parent = options,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "press",
		TextStrokeTransparency = 0.5,
		Size = UDim2.new(1, 0, 0, 12),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 2, 0, 2),
		BorderSizePixel = 0,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(65, 65, 65),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = press,
		Name = "",
		PaddingBottom = UDim.new(0, 1),
		PaddingLeft = UDim.new(0, 5),
	})

	local hold = library:create("TextButton", {
		Parent = options,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "hold",
		TextStrokeTransparency = 0.5,
		Size = UDim2.new(1, 0, 0, 12),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 2, 0, 2),
		BorderSizePixel = 0,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(65, 65, 65),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = hold,
		Name = "",
		PaddingBottom = UDim.new(0, 1),
		PaddingLeft = UDim.new(0, 5),
	})

	local always = library:create("TextButton", {
		Parent = options,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "always",
		TextStrokeTransparency = 0.5,
		Size = UDim2.new(1, 0, 0, 12),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Position = UDim2.new(0, 2, 0, 2),
		BorderSizePixel = 0,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(65, 65, 65),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = always,
		Name = "",
		PaddingBottom = UDim.new(0, 1),
		PaddingLeft = UDim.new(0, 5),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = options,
		Name = "",
		PaddingBottom = UDim.new(0, 4),
	})
	--

	function cfg.set_visible(bool)
		if position_conn then
			position_conn:Disconnect()
			position_conn = nil
		end

		if bool then
			update_content_pos()
			position_conn = keybind:GetPropertyChangedSignal("AbsolutePosition"):Connect(update_content_pos)
		end

		content_inline.Visible = bool

		if bool then
			if library.current_element_open and library.current_element_open ~= cfg then
				library.current_element_open.set_visible(false)
				library.current_element_open.open = false
			end

			library.current_element_open = cfg
		end
	end

	function cfg.set_mode(mode)
		cfg.mode = mode

		if mode == "always" then
			cfg.set(true)
		elseif mode == "hold" then
			cfg.set(false)
		end

		flags[cfg.flag] = {
			mode = cfg.mode,
			key = cfg.key,
			active = cfg.active,
		}

		flags[cfg.flag]["mode"] = mode
	end

	function cfg.set(input)
		if type(input) == "boolean" then
			local __cached = input

			if cfg.mode == "always" then
				__cached = true
			end

			cfg.active = __cached
			flags[cfg.flag]["active"] = __cached
			cfg.callback(__cached)

			flags[cfg.flag] = {
				mode = cfg.mode,
				key = cfg.key,
				active = cfg.active,
			}
		elseif tostring(input):find("Enum") then
			input = input.Name == "Escape" and "..." or input

			cfg.key = input or "..."

			local _text = keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")
			local _text2 = (tostring(_text):gsub("KeyCode.", ""):gsub("UserInputType.", "")) or "..."
			cfg.key_name = _text2

			flags[cfg.flag]["mode"] = cfg.mode
			flags[cfg.flag]["key"] = cfg.key

			keybind.Text = "[" .. string.lower(_text2) .. "]"

			cfg.callback(cfg.active or false)

			flags[cfg.flag] = {
				mode = cfg.mode,
				key = cfg.key,
				active = cfg.active,
			}
		elseif table.find({ "toggle", "hold", "always" }, input) then
			cfg.set_mode(input)

			if input == "always" then
				cfg.active = true
			end

			cfg.callback(cfg.active or false)

			flags[cfg.flag] = {
				mode = cfg.mode,
				key = cfg.key,
				active = cfg.active,
			}
		elseif type(input) == "table" then
			input.key = type(input.key) == "string" and input.key ~= "..." and library:convert_enum(input.key)
				or input.key

			input.key = input.key == Enum.KeyCode.Escape and "..." or input.key
			cfg.key = input.key or "..."

			cfg.mode = input.mode or "toggle"

			if input.active then
				cfg.active = input.active
			end

			flags[cfg.flag] = {
				mode = cfg.mode,
				key = cfg.key,
				active = cfg.active,
			}

			local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
			local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))

			keybind.Text = "[" .. string.lower(__text) .. "]" or "..."
			cfg.key_name = __text
		end

		if cfg.keybind_name then
			key.change_text(keybind.Text .. " " .. cfg.keybind_name .. " (" .. flags[cfg.flag].mode .. ")")
			key.set_visible(cfg.active)
		end

		key.set_active(cfg.active == true)
	end

	local selected

	hold.MouseButton1Click:Connect(function()
		if selected then
			selected.BackgroundTransparency = 1
		end
		selected = hold
		hold.BackgroundTransparency = 0

		cfg.set_mode("hold")
		cfg.set_visible(false)
		cfg.open = false

		key.update({
			text = cfg.display,
			key = cfg.key,
			mode = cfg.mode,
		})
	end)

	press.MouseButton1Click:Connect(function()
		if selected then
			selected.BackgroundTransparency = 1
		end
		selected = press
		press.BackgroundTransparency = 0

		cfg.set_mode("toggle")
		cfg.set_visible(false)
		cfg.open = false

		key.update({
			text = cfg.display,
			key = cfg.key,
			mode = cfg.mode,
		})
	end)

	always.MouseButton1Click:Connect(function()
		if selected then
			selected.BackgroundTransparency = 1
		end
		selected = always

		always.BackgroundTransparency = 0
		cfg.set_mode("always")
		cfg.set_visible(false)
		cfg.open = false

		key.update({
			text = cfg.display,
			key = cfg.key,
			mode = cfg.mode,
		})
	end)

	keybind.MouseButton2Click:Connect(function()
		cfg.open = not cfg.open

		cfg.set_visible(cfg.open)
	end)

	keybind.MouseButton1Down:Connect(function()
		task.wait()
		keybind.Text = "..."

		cfg.binding = library:connection(uis.InputBegan, function(input, game_event)
			if input.UserInputType == Enum.UserInputType.Keyboard then
				cfg.set(input.KeyCode)
			elseif
				input.UserInputType == Enum.UserInputType.MouseButton1
				or Enum.UserInputType.MouseButton2
				or Enum.UserInputType.MouseButton3
			then
				-- I put this giant elseif to avoid having "mousemovement" as a keybind

				cfg.set(input.UserInputType)
			end

			key.update({
				text = cfg.display,
				key = cfg.key,
				mode = cfg.mode,
			})
			cfg.binding:Disconnect()
			cfg.binding = nil
		end)
	end)

	library:connection(uis.InputBegan, function(input, game_event)
		if not game_event then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == cfg.key then
					if cfg.mode == "toggle" then
						-- [fix] was a shared global `toggled` across every keybind
						cfg.set(not cfg.active)
					elseif cfg.mode == "hold" then
						cfg.set(true)
					end
				end
			else
				if input.UserInputType == cfg.key then
					if cfg.mode == "toggle" then
						cfg.set(not cfg.active)
					elseif cfg.mode == "hold" then
						cfg.set(true)
					end
				end
			end
		end
	end)

	library:connection(uis.InputEnded, function(input, game_event)
		if game_event then
			return
		end

		local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

		if selected_key == cfg.key then
			if cfg.mode == "hold" then
				cfg.set(false)
			end
		end
	end)

	cfg.set({ mode = cfg.mode, active = cfg.active, key = cfg.key })
	key.update({
		text = cfg.display,
		key = cfg.key,
		mode = cfg.mode,
	})

	library.config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:button(properties)
	local cfg = {
		callback = properties.callback or function() end,
		name = properties.text or properties.name or "Button",
	}

	local button_inline = library:create("Frame", {
		Parent = self.holder,
		Name = "",
		Position = UDim2.new(0, -15, 0, 2),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -26, 0, 16),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local button = library:create("TextButton", {
		Parent = button_inline,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = cfg.name,
		TextStrokeTransparency = 0.5,
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	library:apply_theme(button, "text", "TextColor3")

	button.MouseButton1Click:Connect(function()
		cfg.callback()
	end)

	return setmetatable(cfg, library)
end

function library:textbox(properties)
	local cfg = {
		placeholder = properties.placeholder
			or properties.placeholdertext
			or properties.holder
			or properties.holdertext
			or "type here...",
		default = properties.default,
		clear_on_focus = properties.clearonfocus or false,
		flag = properties.flag or "...",
		callback = properties.callback or function() end,
	}

	local textbox_inline = library:create("Frame", {
		Parent = self.holder,
		Name = "",
		Position = UDim2.new(0, -15, 0, 2),
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		Size = UDim2.new(1, -26, 0, 16),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
	})

	local textbox = library:create("TextBox", {
		Parent = textbox_inline,
		Name = "",
		FontFace = library.font,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(56, 56, 56),
		Text = "",
		TextStrokeTransparency = 0.5,
		Position = UDim2.new(0, 2, 0, 2),
		Size = UDim2.new(1, -4, 1, -4),
		ClearTextOnFocus = cfg.clear_on_focus,
		PlaceholderColor3 = Color3.fromRGB(90, 90, 90),
		CursorPosition = -1,
		PlaceholderText = cfg.placeholder,
		TextSize = 12,
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
	})

	library:apply_theme(textbox, "text", "TextColor3")

	textbox:GetPropertyChangedSignal("Text"):Connect(function()
		flags[cfg.flag] = textbox.text
		cfg.callback(textbox.text)
	end)

	function cfg.set(text)
		flags[cfg.flag] = text
		textbox.Text = text
		cfg.callback(text)
	end

	if cfg.default then
		cfg.set(cfg.default)
	end

	library.config_flags[cfg.flag] = cfg.set

	return setmetatable(cfg, library)
end

function library:panel(properties)
	if library.__panel == true then
		return
	end

	library.__panel = true

	local cfg = {
		name = properties.name or "Are you sure?",
		options = properties.options or { "Confirm", "Discard" },
		callback = properties.callback or function() end,
	}

	local panel_main_frame = library:create("Frame", {
		Parent = library.gui,
		Name = "",
		BackgroundTransparency = 0.4000000059604645,
		Size = UDim2.new(1, 0, 1, 0),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		ZIndex = 3,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	})

	local holder = library:create("Frame", {
		Parent = panel_main_frame,
		Name = "",
		BorderColor3 = Color3.fromRGB(19, 19, 19),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		ZIndex = 4,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
	})

	local inline1 = library:create("Frame", {
		Parent = holder,
		Name = "",
		BorderColor3 = Color3.fromRGB(8, 8, 8),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(56, 56, 56),
	})

	local main = library:create("Frame", {
		Parent = inline1,
		Name = "",
		Position = UDim2.new(0, 4, 0, 4),
		BorderColor3 = Color3.fromRGB(26, 26, 26),
		Size = UDim2.new(1, -8, 1, -8),
		BorderSizePixel = 2,
		BackgroundColor3 = Color3.fromRGB(26, 26, 26),
	})

	local UIStroke = library:create("UIStroke", {
		Parent = main,
		Name = "",
		Color = Color3.fromRGB(57, 57, 57),
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local tabs = library:create("Frame", {
		Parent = main,
		Name = "",
		Position = UDim2.new(0, 8, 0, 8),
		BorderColor3 = Color3.fromRGB(8, 8, 8),
		Size = UDim2.new(1, -16, 1, -16),
		BorderSizePixel = 2,
		BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	})

	local UIStroke = library:create("UIStroke", {
		Parent = tabs,
		Name = "",
		Color = Color3.fromRGB(57, 57, 57),
		LineJoinMode = Enum.LineJoinMode.Miter,
	})

	local UIPadding = library:create("UIPadding", {
		Parent = tabs,
		Name = "",
		PaddingTop = UDim.new(0, 5),
		PaddingBottom = UDim.new(0, 22),
		PaddingRight = UDim.new(0, 20),
		PaddingLeft = UDim.new(0, 20),
	})

	local aimbot = library:create("TextLabel", {
		Parent = tabs,
		Name = "",
		FontFace = library.font,
		LineHeight = 1.2000000476837158,
		TextStrokeTransparency = 0.5,
		AnchorPoint = Vector2.new(0.5, 0),
		TextSize = 12,
		Size = UDim2.new(0, 0, 0, 11),
		TextColor3 = Color3.fromRGB(170, 170, 170),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		Text = cfg.name,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0, 8),
		BorderSizePixel = 0,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	library:apply_theme(aimbot, "text", "TextColor3")

	local UIPadding = library:create("UIPadding", {
		Parent = aimbot,
		Name = "",
		PaddingTop = UDim.new(0, 6),
	})

	local UIListLayout = library:create("UIListLayout", {
		Parent = tabs,
		Name = "",
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = UDim.new(0, 4),
	})

	local Frame = library:create("Frame", {
		Parent = tabs,
		Name = "",
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	})

	local UIListLayout = library:create("UIListLayout", {
		Parent = Frame,
		Name = "",
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = UDim.new(0, 3),
	})

	local UIPadding = library:create("UIPadding", {
		Parent = Frame,
		Name = "",
	})

	for _, v in next, cfg.options do
		local button_inline = library:create("Frame", {
			Parent = Frame,
			Name = "",
			Position = UDim2.new(0, 0, 0, 4),
			BorderColor3 = Color3.fromRGB(19, 19, 19),
			Size = UDim2.new(0, 130, 0, 16),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(8, 8, 8),
		})

		local button = library:create("TextButton", {
			Parent = button_inline,
			Name = "",
			FontFace = library.font,
			TextColor3 = Color3.fromRGB(170, 170, 170),
			BorderColor3 = Color3.fromRGB(56, 56, 56),
			Text = v,
			TextStrokeTransparency = 0.5,
			Position = UDim2.new(0, 2, 0, 2),
			Size = UDim2.new(1, -4, 1, -4),
			TextSize = 12,
			BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		})

		library:apply_theme(button, "text", "TextColor3")

		button.MouseButton1Click:Connect(function()
			cfg.callback(v)
			panel_main_frame:Destroy()
			library.__panel = false
		end)
	end
end
--
--

--!native
--!optimize 2


do -- sections + tabs
 local window = library:window({
  	name = os.date("Legacy | %b %d %Y"),
  	size = UDim2.fromOffset(500, 650),
 })


 local AimingTab = window:tab({ name = "Aiming" })
 local VisualsTab = window:tab({ name = "Visuals" })
 local MiscTab = window:tab({ name = "Misc" })
 
 
 do --// Combat
	
   do --// Legitbot
     local legitBot = AimingTab:section({ name = "Legitbot", side = "left" })
 
     legitBot:toggle({ name = "Enabled", flag = "aimLockToggle", default = false, warningType = "warning" })
	 legitBot:toggle({ name = "Control Recoil", flag = "controlRecoilToggle", default = false})
	 legitBot:slider({ name = "Smoothing", min = 0, max = 100, default = 0, interval = 1, flag = "smoothingValue" })
   	 
   	 legitBot:dropdown({
   		name = "Targeting Style",
   		flag = "lockTargetStyle",
   		items = { "FOV", "Mouse" },
   		default = "FOV",
   	 })
   

   	 local fovToggle = legitBot:toggle({ name = "FOV", flag = "FOVToggle", default = false })
       legitBot:colorpicker({ object = "Gradient One", flag = "lockFOVGradientOne", color = Color3.fromRGB(255, 255, 255) })
       legitBot:colorpicker({ object = "Gradient Two", flag = "lockFOVGradientTwo", color = Color3.fromRGB(255, 255, 255) })
   	
   
   	 legitBot:toggle({ name = "FOV Outline", flag = "lockFOVOutline", default = false })
       legitBot:colorpicker({ object = "Outline Color", flag = "lockOutlineColor", color = Color3.fromRGB(255, 255, 255) })
   
   	 legitBot:toggle({ name = "FOV Fill", flag = "lockFovFillEnabled", default = false })
   		:colorpicker({ flag = "fovFillColor", color = Color3.fromHex("#FFFFFF") })
   	
   
   	 legitBot:slider({ name = "Radius", min = 10, max = 1000, default = 100, interval = 1, flag = "lockFovRadius" })

   	 legitBot:slider({ name = "Thickness", min = 1, max = 5, default = 1, interval = 1, flag = "lockFovThickness" })

   	 legitBot:toggle({ name = "Gradient Spin", flag = "Gradient_Spin", default = false })

   	 legitBot:slider({ name = "Rotation Speed", min = 1, max = 5, default = 0, interval = 1, flag = "lockGradient_Spin_Speed" })
   end
 	
   do --// Silent Aim
     local silentAim = AimingTab:section({ name = "Silent Aim", side = "right" })
 
     silentAim:toggle({ name = "Enabled", flag = "SilentAimToggle", default = false, warningType = "risky" })
   	 silentAim:toggle({ name = "Wallbang", flag = "Wallbang", default = false })
   	 silentAim:toggle({ name = "Force-Hit", flag = "ForceHit", default = false })
   
   	 silentAim:dropdown({
   		name = "Targeting Style",
   		flag = "targetStyle",
   		items = { "FOV", "Mouse" },
   		default = "FOV",
   	 })
   
   	local fovToggle = silentAim:toggle({ name = "FOV", flag = "FOVToggle", default = false })
       silentAim:colorpicker({ object = "Gradient One", flag = "FOVGradientOne", color = Color3.fromRGB(255, 255, 255) })
       silentAim:colorpicker({ object = "Gradient Two", flag = "FOVGradientTwo", color = Color3.fromRGB(255, 255, 255) })
   	
   
   	silentAim:toggle({ name = "FOV Outline", flag = "FOVOutline", default = false })
       silentAim:colorpicker({ object = "Outline Color", flag = "OutlineColor", color = Color3.fromRGB(255, 255, 255) })
   
   	silentAim:toggle({ name = "FOV Fill", flag = "fovFillEnabled", default = false })
   		:colorpicker({ flag = "fovFillColor", color = Color3.fromHex("#FFFFFF") })
   
   	silentAim:toggle({ name = "Render On Barrel", flag = "renderFOVOnBarrel", default = false })
   
   	silentAim:slider({ name = "Radius", min = 10, max = 1000, default = 100, interval = 1, flag = "FOVRadius" })
   	silentAim:slider({ name = "Thickness", min = 1, max = 5, default = 1, interval = 1, flag = "fovThickness" })
   	silentAim:toggle({ name = "Gradient Spin", flag = "Gradient_Spin", default = false })
   	silentAim:slider({ name = "Rotation Speed", min = 1, max = 5, default = 0, interval = 1, flag = "Gradient_Spin_Speed" })
     
     
     AimingTab:hitpart_picker({
   		name = "Target Position",
   		side = "right",
   		flag = "hitPart",
   		default = { "Head" },
   		multi = false,
   		type = "R15"
   	})
 
   end
   
 	
   do --// Hitbox Expander
     local hitboxSection = AimingTab:section({ name = "HitBox Expander & Melee", side = "left" })
   	hitboxSection:toggle({ name = "Hitbox Expander Enabled", flag = "hitboxExpander", default = false })
   	hitboxSection:slider({ name = "Head Size", min = 1, max = 20, default = 10, interval = 1, flag = "hitboxExpanderAmount" })
   	hitboxSection:slider({ name = "Head Transparency", min = 0, max = 1, default = 0.5, interval = 0.1, flag = "hitboxTransparencyAmount" })
   end
 	
   do --// Snapline
     local snaplineSection = AimingTab:section({ name = "Snapline & Indicators", side = "left" })
   	snaplineSection:toggle({ name = "Snapline", flag = "Snapline", default = false })
       snaplineSection:colorpicker({ object = "Snapline Color", flag = "SnaplineColor", color = Color3.fromRGB(255, 255, 255) })
   	snaplineSection:toggle({ name = "Snapline Outline", flag = "SnaplineOutline", default = false })
       snaplineSection:colorpicker({ object = "Snapline Outline Color", flag = "SnaplineOutlineColor", color = Color3.fromRGB(255, 255, 255) })
   	snaplineSection:slider({ name = "Thickness", min = 1, max = 5, default = 1, interval = 1, flag = "SnaplineThickness" })
   
   	
   	snaplineSection:toggle({ name = "Hit Notifications", flag = "HitNotis", default = false })
   	snaplineSection:slider({ name = "Notification Time", min = 1, max = 10, default = 2, interval = 1, flag = "HitTime" })
   end
 	
   do --// Manipulation + ragebot
     local manipSection = AimingTab:section({ name = "Manipulation", side = "left" })
   	manipSection:toggle({ name = "Enabled", flag = "ManipulationToggle", default = false })
       manipSection:keybind({
     		name = "Manipulation",
     		mode = "hold",
         flag = "ManipBind"
     	})
     manipSection:toggle({ name = "Resolver(UG)", flag = "floorResolver", default = false })
   	manipSection:slider({ name = "Max Horizontal Scan", min = 1, max = 10, default = 3, interval = 0.1, flag = "HorzManip" })
   	manipSection:slider({ name = "Max Vertical Scan", min = 1, max = 10, default = 3, interval = 0.1, flag = "VertManip" })
   	manipSection:slider({ name = "Max Corner Radius", min = 1, max = 15, default = 3, interval = 0.1, flag = "MaxCornerRadius" })
   
   	local rageSection = AimingTab:section({ name = "RageBot", side = "left" })
   	rageSection:toggle({ name = "RageBot", flag = "RageBotToggle", default = false })
       rageSection:keybind({
      		name = "RageBot",
      		mode = "toggle",
         flag = "RageBotBind"
      	})
       rageSection:toggle({ name = "KnifeBot", flag = "KnifeBotToggle", default = false })
       rageSection:keybind({
      		name = "KnifeBot",
      		mode = "toggle",
          flag = "KnifeBotBind"
      	})
   	rageSection:dropdown({
   		name = "Fire Checks",
   		flag = "fireCheck",
   		items = { "Manipulation", "Visible"},
       multi = true
   	})
   end
 
 	
   do --// Crosshair
     local crosshairSection = AimingTab:section({ name = "Crosshair", side = "right" })
   	crosshairSection:toggle({ name = "Crosshair", flag = "CrosshairEnabled", default = false })
   		:colorpicker({ name = "Crosshair Color", flag = "Crosshair_Color", color = Color3.fromHex("#000000") })
   	crosshairSection:toggle({ name = "Outline", flag = "CrosshairOutline", default = false })
   	crosshairSection:toggle({ name = "Follow Target", flag = "FollowTarget", default = false })
   	crosshairSection:toggle({ name = "Show On Barrel", flag = "OnBarrel", default = false })
   	crosshairSection:toggle({ name = "Spin", flag = "CrosshairSpin", default = false })
   
   	crosshairSection:dropdown({
   		name = "Crosshair Animation",
   		flag = "CrosshairAnim",
   		items = { "Static", "Breathing" },
   		default = "Static",
   	})
   	crosshairSection:dropdown({
   		name = "Visual Crosshair Animation",
   		flag = "visualCrosshairAnim",
   		items = { "Fading", "Flashing" },
   		default = "Fading",
   	})
   	crosshairSection:slider({ name = "Max Pulse", min = 0, max = 20, default = 5, interval = 1, flag = "MaxPulse" })
   	crosshairSection:slider({ name = "Cap Rate", min = 1, max = 5, default = 1.5, interval = 0.5, flag = "MaxRate" })
   	crosshairSection:slider({ name = "Visual Animation Speed", min = 1, max = 10, default = 2, interval = 1, flag = "visualAnimSpeed" })
   	crosshairSection:slider({ name = "Animation Speed", min = 1, max = 10, default = 2, interval = 1, flag = "animSpeed" })
   	crosshairSection:slider({ name = "Crosshair Length", min = 0, max = 10, default = 1, interval = 1, flag = "CrosshairLength" })
   	crosshairSection:slider({ name = "Crosshair Thickness", min = 0, max = 3, default = 1, interval = 1, flag = "CrossHairThickness" })
   	crosshairSection:slider({ name = "Crosshair Gap", min = 0, max = 5, default = 1, interval = 1, flag = "CrosshairGap" })
   	crosshairSection:slider({ name = "Crosshair Spin Speed", min = 0, max = 5, default = 1, interval = 1, flag = "CrosshairSpinSped" })
   
   	crosshairSection:toggle({ name = "Show Name Info", flag = "showTargetName", default = false })
   		:colorpicker({ name = "Target Name Color", flag = "Target_Name_Color", color = Color3.fromHex("#FFFDFD") })
   	crosshairSection:toggle({ name = "Show Distance Info", flag = "showTargetDistance", default = false })
   		:colorpicker({ name = "Distance Color", flag = "Target_Distance_Color", color = Color3.fromHex("#FFFDFD") })
   	crosshairSection:toggle({ name = "Show Manipulated", flag = "showManipulated", default = false })
   		:colorpicker({ name = "Manipulated Color", flag = "Target_Manipulated_Color", color = Color3.fromHex("#FFFDFD") })
   	crosshairSection:toggle({ name = "Show Wallbang", flag = "showWallbang", default = false })
   		:colorpicker({ name = "Wallbang Color", flag = "Target_Wallbang_Color", color = Color3.fromHex("#FFFDFD") })
   end
 	
   do --// Weapon
     local weaponSection = AimingTab:section({ name = "Weapon Mods", side = "right" })
   	weaponSection:toggle({ name = "Auto-Reload", flag = "AutoReload", default = false })
   	weaponSection:toggle({ name = "Auto-Load Magazines On Reload", flag = "autoLoadMags", default = false })
   	weaponSection:toggle({ name = "Remove Aim Speed Penalty", flag = "aimCharacterSlowdown", default = false })
   	weaponSection:toggle({ name = "Remove Jump Block", flag = "blocksJumpWhileHeld", default = false })
   	weaponSection:toggle({ name = "Disable Aim Requires Crouch", flag = "aimRequiresCrouch", default = false })
   	weaponSection:toggle({ name = "Remove Spread", flag = "NoSpread", default = false })
   	weaponSection:toggle({ name = "All Fire Modes", flag = "AllFireModes", default = false })
   	weaponSection:toggle({ name = "Custom Fire-Rate", flag = "CustomFireRate", default = false })
   	weaponSection:slider({ name = "Fire-Rate", min = 1, max = 1100, default = 800, interval = 1, flag = "FireRateValue" } )
   	weaponSection:toggle({ name = "Change Aiming Field of View", flag = "ChangeAimFOV", default = false })
   	weaponSection:slider({ name = "Field of View", min = 10, max = 99, default = 80, interval = 1, flag = "newAimFieldOfView" } )
   	weaponSection:toggle({ name = "Remove Recoil", flag = "NoRecoil", default = false })
   	weaponSection:slider({ name = "Vertical Shift", min = 0, max = 100, default = 0, interval = 1, flag = "VerticalShift", suffix = "%" })
   	weaponSection:slider({ name = "Back Shift", min = 0, max = 100, default = 0, interval = 1, flag = "BackShift", suffix = "%" })
   	weaponSection:dropdown({
   		name = "Recoil Type",
   		flag = "RecoilType",
   		items = { "Custom", "Remove All" },
   		default = "Custom",
   	})
   	weaponSection:toggle({
   		name = "Hit Sounds",
   		flag = "HitSoundEnabled",
   		default = false,
   		callback = function(bool)
   			HitsoundEnabled = bool
   		end,
   	})
   	weaponSection:dropdown({
   		name = "Headshot Sound",
   		flag = "HeadshotSound",
   		items = { "default", "neverlose", "xp", "rust", "skeet", "tf2", "sonic", "bow", "fingersnap" },
   		default = "default",
   	})
   	weaponSection:slider({ name = "Sound Volume", min = 0.5, max = 10, default = 1, interval = 0.1, flag = "SoundVolume" })
   end
 
   do --// Bullet Tracers
     local tracerSection = AimingTab:section({ name = "Bullet Tracers", side = "right" })
   	tracerSection:toggle({ name = "Bullet Tracers", flag = "BulletTracers", default = false })
       tracerSection:colorpicker({ object = "Tracer Color", flag = "BulletTracerColor", color = Color3.fromRGB(255, 255, 255) })
   	tracerSection:dropdown({
   		name = "Tracer Type",
   		flag = "TracerType",
   		items = { "Part", "Trail" },
   		default = "Trail",
   	})
   	tracerSection:dropdown({
   		name = "Tracer Shading",
   		flag = "TracerShading",
   		items = { "AlwaysOnTop", "XRayShaded", "XRay" },
   		default = "XRayShaded",
   	})
   	tracerSection:toggle({ name = "Fade Animation", flag = "TracerAnimation", default = false })
   	tracerSection:toggle({ name = "Fade Reverses", flag = "TweenReverse", default = false })
   	tracerSection:dropdown({
   		name = "Easing Style",
   		flag = "EasingStyle",
   		items = { "Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponetial", "Circular", "Cubic" },
   		default = "Quad",
   	})
   	tracerSection:dropdown({
   		name = "Easing Direction",
   		flag = "EasingDirection",
   		items = { "In", "Out", "InOut" },
   		default = "Out",
   	})
   	tracerSection:dropdown({
   		name = "Material",
   		flag = "ChamMaterial",
   		items = { "Neon", "ForceField", "Glass" },
   		default = "Neon",
   	})
   	tracerSection:slider({ name = "Glow Multiplier", min = 1, max = 10, default = 5, interval = 1, flag = "GlowMultiplier" })
   	tracerSection:slider({ name = "FadeTime", min = 1, max = 10, default = 2, interval = 1, flag = "FadeTime" })
   	tracerSection:slider({ name = "Tracer Size", min = 0.001, max = 1, default = 0.05, interval = 0.001, flag = "TracerSize" })
   	tracerSection:slider({ name = "Reflectance", min = 0, max = 1, default = 0, interval = 0.1, flag = "Reflectance" })
   	tracerSection:dropdown({
   		name = "Tracer Texture",
   		flag = "TrailID",
   		items = { "Electricity", "Pulse", "Lightning", "LightPulse", "Reflex", "Shards" },
   		default = "Electricity",
   	})
   	tracerSection:slider({ name = "Texture Speed", min = 1, max = 10, default = 1, interval = 1, flag = "TextureSpeed" })
   	tracerSection:slider({ name = "Trail Lifetime", min = 1, max = 10, default = 1, interval = 1, flag = "TrailLifetime" })
   	tracerSection:slider({ name = "Texture Length", min = 1, max = 10, default = 1, interval = 1, flag = "TextureLength" })
   end
 
 end
 
 
 do --// Visuals
   
   do --// Element Settings
     local playerEsp = VisualsTab:section({ name = "Settings", side = "left" })
	 playerEsp:toggle({ name = "Enable All", flag = "EnableAll", default = false, callback = update_elements })
	 playerEsp:toggle({ name = "Team Check", flag = "TeamCheck", default = false, callback = update_elements })
      
	 playerEsp:toggle({ name = "Player Join Notification", flag = "playerJoin", default = false })
	 playerEsp:toggle({ name = "Player Leave Notification", flag = "playerLeave", default = false})
    	
	 playerEsp:dropdown({
		name = "Distance Type",
		flag = "DistanceType",
		items = { "M", "ST", " Meters", " Studs" },
		default = "M",
	 })
    	
	 --[[playerEsp:dropdown({
		name = "Fonts",
		flag = "TextFont",
		items = { "SmallestPixel", "ProggyTiny", "Minecraftia", "Tahoma", "RetroSpace" },
		default = "Minecraftia",
	 })]]
    	
	 --[[playerEsp:dropdown({
		name = "Flag Font",
		flag = "TextFlagFont",
		items = { "SmallestPixel", "ProggyTiny", "Minecraftia", "Tahoma", "RetroSpace" },
		default = "Minecraftia",
	 })]]
      
	 playerEsp:slider({ name = "Max Distance", suffix = "m", flag = "MaxDistance", value = 1000, minimum = 100, maximum = 10000 })
   end
   
   do --// Texts
         local espTexts = VisualsTab:section({ name = "ESP Text & Elements", side = "left" })
         espTexts:toggle({ name = "Names", flag = "Names", default = false, tooltip = "name :p", callback = function(bool) window.preview_names(bool) end })
     	  espTexts:colorpicker({ object = "Name Color", flag = "Name_Color", color = Color3.fromRGB(255, 255, 255), callback = function(color) window.change_name(color)end })
		  window.preview_bounding_box(false)
      	  window.preview_reload_bar(false)
      	  window.preview_weapon(false)
      	  window.preview_health(true)
      	  window.preview_names(false)
		  window.preview_icons(false)
	      window.preview_armor(false)
		  
     
     	espTexts:toggle({ name = "Use Display Name", flag = "UseDisplayName", default = false, callback = update_elements })
        
     	espTexts:toggle({ name = "Distance", flag = "Distance", default = false, callback = function(bool) window.preview_distance(bool) end })
          espTexts:colorpicker({ object = "Distance Color", flag = "Distance_Color", color = Color3.fromRGB(255, 255, 255), callback = function(color) window.change_distance(color) end })
        
     	espTexts:toggle({ name = "Weapon", flag = "Weapon", default = false, callback = function(bool) window.preview_weapon(bool) end })
          espTexts:colorpicker({ object = "Weapon Color", flag = "Weapon_Color", color = Color3.fromRGB(255, 255, 255), callback = function(color) window.change_weapon(color) end })
     	
        
     	espTexts:toggle({ name = "Visible", flag = "Vis", default = false, callback = function(bool) window.preview_visible(bool) end })
          espTexts:colorpicker({ object = "Visible Color", flag = "Vis_Color", color = Color3.fromRGB(255, 255, 255), callback = function(color) window.change_visible(color) end })
          espTexts:colorpicker({ object = "Not Visible Color", flag = "Not_Vis_Color", color = Color3.fromRGB(255, 255, 255) })
   
   
     	espTexts:toggle({ name = "Health Flag", flag = "HealthText", default = false, callback = update_elements })
          espTexts:colorpicker({ object = "Health Text Color", flag = "Health_Text_Color", color = Color3.fromRGB(255, 255, 255) })
		  espTexts:colorpicker({ object = "Low Health Text Color", flag = "Low_Health_Text_Color", color = Color3.fromRGB(255, 10, 10) })
   
   
     	espTexts:toggle({ name = "Aiming", flag = "AimingText", default = false, callback = update_elements })
          espTexts:colorpicker({ object = "Is Aiming Color", flag = "Aiming_Color", color = Color3.fromRGB(255, 255, 255) })
          espTexts:colorpicker({ object = "Not Aiming Color", flag = "Not_Aiming_Color", color = Color3.fromRGB(255, 255, 255) })
   
   
     	espTexts:toggle({ name = "In Inventory", flag = "InventoryText", default = false, callback = update_elements })
          espTexts:colorpicker({ object = "Is Searching Color", flag = "Inventory_Color", color = Color3.fromRGB(255, 255, 255) })
          espTexts:colorpicker({ object = "Not Searching Color", flag = "Not_Inventory_Color", color = Color3.fromRGB(255, 255, 255) })
   end
   
   do --// Boxes
     local espBoxes = VisualsTab:section({ name = "Misc Elements", side = "left" })
	 --library:update_esp_instance(themes.utility["Box"].Box, "Boxes")
   	 espBoxes:toggle({ name = "Boxes", flag = "Boxes", default = false, callback = function(bool) window.preview_bounding_box(bool) window.preview_filler(bool) end })
       espBoxes:colorpicker({ object = "Box Color", flag = "Box_Color", color = Color3.fromRGB(255, 255, 255), callback = function(color) window.change_box(color) end })
 
     
   	 espBoxes:toggle({ name = "Box Fill", flag = "BoxFill", default = false, callback = function(bool) window.preview_filler(bool) end })
       espBoxes:colorpicker({ object = "Box Fill Color One", flag = "Box_Fill_Color", color = Color3.fromRGB(255, 255, 255), callback = function(color) window.change_fill_gradient() end })
 	   espBoxes:colorpicker({ object = "Box Fill Color One", flag = "Box_Fill_Color_Two", color = Color3.fromRGB(255, 255, 255), callback = function(color) window.change_fill_gradient() end })
 	  
     
   	 espBoxes:toggle({ name = "Fill Spin", flag = "gradientSpin", default = false })
       espBoxes:slider({ name = "Fill Rotation", suffix = "%", flag = "FillRotation", value = 90, minimum = 0, maximum = 360, callback = function(rotation) window.change_fill_rotation(rotation) end })
       espBoxes:slider({ name = "Rotation Speed", suffix = "%", flag = "gradientAnimationSpeed", value = 2, minimum = 1, maximum = 5 })
 
   	
   	 espBoxes:toggle({ name = "Health Bar", flag = "Healthbar", default = false, callback = function(bool) window.preview_health(bool) end })
       espBoxes:colorpicker({ object = "Gradient Color One", flag = "GradientColor1", color = Color3.fromRGB(255, 255, 255), callback = function(color) window.change_health_gradient() end })
       espBoxes:colorpicker({ object = "Gradient Color Two", flag = "GradientColor2", color = Color3.fromRGB(255, 255, 255), callback = function(color) window.change_health_gradient() end })
 	  espBoxes:slider({ name = "Animation Speed", suffix = "%", flag = "healthBarSpeed", value = 1, minimum = 1, maximum = 3 })
 
 
 	 espBoxes:dropdown({ name = "Health Bar Position", items = { "Left", "Right", "Bottom" }, flag = "healthBarPosition", default = "Left" })
     espBoxes:dropdown({ name = "Health Bar Padding", items = { "1 Pixel", "2 Pixel" }, flag = "HealthBarPadding", default = "1 Pixel" })
 
   end
   
   do --// Chams
     local chams = VisualsTab:section({ name = "Chams", side = "left" })
     chams:toggle({ name = "Glow Adornments", flag = "BoxChams", default = false, callback = function(bool) window.preview_chams(bool) end })
       chams:colorpicker({ object = "Box Chams Color", flag = "Box_Cham_Color", color = Color3.fromRGB(255, 255, 255), callback = function(color) window.preview_cham_color(color) end })
     
     chams:slider({ name = "Glow Multiplier", suffix = "%", flag = "ChamGlowMultiplier", value = 10, minimum = 5, maximum = 10 })
   end
 	
   do --// Vehicle ESP
        local vehicleEsp = VisualsTab:section({ name = "Vehicle", side = "left" })
    	vehicleEsp:toggle({ name = "Names", flag = "VehicleNames", default = false})
		    vehicleEsp:colorpicker({ object = "Name Color", flag = "Vehicle_Name_Color", color = Color3.fromRGB(255, 255, 255) })

    	vehicleEsp:toggle({ name = "Distance", flag = "VehicleDistance", default = false})
		    vehicleEsp:colorpicker({ object = "Distance Color", flag = "Vehicle_Distance_Color", color = Color3.fromRGB(255, 255, 255) })
			
		vehicleEsp:toggle({ name = "Boxes", flag = "VehicleBoxes", default = false })
            vehicleEsp:colorpicker({ object = "Box Color", flag = "Vehicle_Box_Color", color = Color3.fromRGB(255, 255, 255) })

    	vehicleEsp:dropdown({
    		name = "Distance Type",
    		flag = "VehicleDistanceType",
    		items = { "M", "ST", " Meters", " Studs" },
    		default = "M",
    	})

    	vehicleEsp:slider({ name = "Max Distance", min = 100, max = 20000, default = 1000, interval = 1, flag = "VehicleMaxDistance" })
   end
   
   do --// Corpse ESP
     local corpseEsp = VisualsTab:section({ name = "Corpse", side = "left" })
    	corpseEsp:toggle({ name = "Names", flag = "CorpseNames", default = false})
		    corpseEsp:colorpicker({ object = "Name Color", flag = "Corpse_Name_Color", color = Color3.fromRGB(255, 255, 255) })

    	corpseEsp:toggle({ name = "Distance", flag = "CorpseDistance", default = false})
		    corpseEsp:colorpicker({ object = "Distance Color", flag = "Corpse_Distance_Color", color = Color3.fromRGB(255, 255, 255) })
			
		corpseEsp:toggle({ name = "Boxes", flag = "CorpseBoxes", default = false })
            corpseEsp:colorpicker({ object = "Box Color", flag = "Corpse_Box_Color", color = Color3.fromRGB(255, 255, 255) })

    	corpseEsp:dropdown({
    		name = "Distance Type",
    		flag = "CorpseDistanceType",
    		items = { "M", "ST", " Meters", " Studs" },
    		default = "M",
    	})

    	corpseEsp:slider({ name = "Max Distance", min = 100, max = 20000, default = 1000, interval = 1, flag = "CorpseMaxDistance" })
   end
   
   do --// World
      local worldSection = VisualsTab:section({ name = "World & Lighting", side = "right" })
    	worldSection:toggle({ name = "Masterswitch", flag = "worldMasterSwitch", default = false })
    	worldSection:toggle({ name = "Custom Lighting", flag = "CustomLighting", default = false })
    	worldSection:toggle({ name = "Ambient", flag = "Ambient", default = false, callback = update_elements })
    		:colorpicker({ name = "Ambient Color", flag = "Ambient_Color" })
    	worldSection:toggle({ name = "Skybox", flag = "Skybox", default = false, callback = update_elements })
    	worldSection:dropdown({
    		name = "Skybox Texture",
    		flag = "SkyboxTexture",
    		items = { "Blood Moon", "Starry Night" },
    		default = "Blood Moon",
    	})
    	worldSection:toggle({ name = "FullBright", flag = "FullBright", default = false, callback = update_elements })
    	worldSection:slider({ name = "Expose Amount", min = 0, max = 3, default = 1, interval = 1, flag = "ExposureAmount" })
    	worldSection:toggle({ name = "Clouds", flag = "Clouds", default = false, callback = update_elements })
    		:colorpicker({ name = "Cloud Color", flag = "Cloud_Color" })
    	worldSection:toggle({ name = "Custom Atmosphere", flag = "Atmosphere", default = false, callback = update_elements })
    		:colorpicker({ name = "Haze", flag = "Atmosphere_Color" })
    	worldSection:slider({ name = "Fog Density", min = 0, max = 1, default = 0.33, interval = 0.1, flag = "FogDensity" })
    	worldSection:slider({
    		name = "Time Of Day",
    		min = 12,
    		max = 24,
    		default = 12,
    		interval = 1,
    		flag = "TimeOfDay",
    		callback = function(float)
    			if Variables and Variables.ChangeLighting then
    				Variables.ChangeLighting(float)
    			end
    		end,
    	})
    	worldSection:toggle({
    		name = "Remove Moon/Sun",
    		flag = "AllowCelestialBodies",
    		default = false,
    		callback = function(bool)
    			if Variables and Variables.RemoveCelestialBodies then
    				Variables.RemoveCelestialBodies(bool)
    			end
    		end,
    	})
    	worldSection:toggle({
    		name = "Edit Celestial Size",
    		flag = "EditCelestialBodies",
    		default = false,
    		callback = function(bool)
    			if Variables and Variables.EditCelestialBodies then
    				Variables.EditCelestialBodies(bool)
    			end
    		end,
    	})
    	worldSection:toggle({
    		name = "Remove Shadows",
    		flag = "RemoveShadows",
    		default = false,
    		callback = function(bool)
    			if Variables and Variables.RemoveShadows then
    				Variables.RemoveShadows(bool)
    			end
    		end,
    	})
    	worldSection:slider({
    		name = "Celestial Size",
    		min = 12,
    		max = 60,
    		default = 12,
    		interval = 1,
    		flag = "CelestialSize",
    		callback = function(float)
    			if Variables and Variables.EditCelestialBodies then
    				Variables.EditCelestialBodies(float)
    			end
    		end,
    	})
    	worldSection:slider({ name = "Glare", min = 0, max = 10, default = 0.5, interval = 0.5, flag = "GlareAmount" })
    	worldSection:slider({ name = "Haze", min = 0, max = 10, default = 0.5, interval = 0.5, flag = "HazeAmount" })
 
   end
   
   do --// Quality of Life
      local qolSection = VisualsTab:section({ name = "Quality of Life", side = "right" })
    	qolSection:toggle({ name = "Zoom", flag = "zoomToggle", default = false })
        qolSection:keybind({
          name = "Zooming",
          mode = "hold",
          flag = "zoomingBind"
        })
    	qolSection:toggle({
    		name = "Remove Inventory Blur",
    		flag = "MenuBlur",
    		default = false,
    		callback = function(bool)
    			if Variables and Variables.RemoveBlur then
    				Variables.RemoveBlur(bool)
    			end
    		end,
    	})
    	qolSection:toggle({ name = "Remove Bullet Flinch", flag = "noFlinch", default = false })
    	qolSection:toggle({ name = "Remove Damage Effects", flag = "removeDamageAffect", default = false })
    	qolSection:toggle({ name = "Remove Muzzle Flash", flag = "removeMuzzleFlash", default = false })
    	qolSection:toggle({ name = "Spoof Kill-Feed", flag = "spoofKillFeed", default = false })
   end
   
   do --// Player Chams
      local chamsSection = VisualsTab:section({ name = "Weapon Model Chams", side = "right" })
      chamsSection:toggle({ name = "Player Chams", flag = "PlayerChams", default = false })
  
      chamsSection:dropdown({
    		name = "Cham Type",
    		flag = "playerChamType",
    		items = { "Material", "Wireframe" },
    		default = "Wireframe",
    	})
  
      chamsSection:dropdown({
    		name = "Hat Style",
    		flag = "hatShape",
    		items = { "None", "Chinese Hat", "Sombrero" },
    		default = "Chinese Hat",
    	})
  
      chamsSection:dropdown({
    		name = "Cham Animation Style",
    		flag = "playerChamAnimType",
    		items = { "Static", "Fading" },
    		default = "Static",
    	})
  
      chamsSection:slider({ name = "Animation Speed", suffix = "%", flag = "chamAnimationSpeed", value = 1, minimum = 0, maximum = 10, interval = 1, tooltip = "Mainl for dynamic animations obviously :3" })
      chamsSection:slider({ name = "Min Transparency", suffix = "%", flag = "minTransparency", value = 1, minimum = 0, maximum = 1, interval = 0.1 })
      chamsSection:slider({ name = "Max Transparency", suffix = "%", flag = "maxTransparency", value = 1, minimum = 0, maximum = 1, interval = 0.1 })
      chamsSection:dropdown({
    		name = "Cham Texture",
    		flag = "playerChamTexture",
    		items = { "ForceField", "Glass", "Neon" },
    		default = "Neon",
    	})
      
  
      chamsSection:colorpicker({ object = "Cham Color", flag = "Player_Cham_Color", color = Color3.fromRGB(255, 255, 255) })
  
    	chamsSection:toggle({ name = "Weapon Chams", flag = "WeaponChams", default = false })
      chamsSection:colorpicker({ object = "Cham Color", flag = "Weapon_Cham_Color", color = Color3.fromRGB(255, 255, 255) })
    	
  
      chamsSection:dropdown({
    		name = "Cham Texture",
    		flag = "WeaponChamTexture",
    		items = { "ForceField", "Glass", "Neon" },
    		default = "Neon",
    	})
    	
      chamsSection:slider({ name = "Transparency", suffix = "%", flag = "weaponChamTransparency", value = 0, minimum = 0, maximum = 1, interval = 0.1 })
      chamsSection:slider({ name = "Reflectance", suffix = "%", flag = "weaponChamReflectance", value = 0, minimum = 0, maximum = 1, interval = 0.1 })
  
   end
   
 end
 
 
 do --// Movement/Character
   
 	do --// Character/Movement
   	local moveSection = MiscTab:section({ name = "Movement", side = "left" })
   	moveSection:toggle({ name = "Speed-Hack", flag = "speedhackEnabled", default = false })
   	moveSection:slider({ name = "Walk-Speed", min = 12, max = 35, default = 20, interval = 1, flag = "speedAmount" })
   	
 
     moveSection:toggle({ name = "Reject Stagger Animation", flag = "rejectFallAnimation", default = false })
   	moveSection:toggle({ name = "Bunny-Hop", flag = "RemoveJumpDebounce", default = false })
     moveSection:toggle({ name = "Teleport To Body After Death", flag = "TpAfterDeath", default = false })
   end
   
   do --// Anti-Aim
     local charSection = MiscTab:section({ name = "Anti-Aim", side = "left" })
   	charSection:toggle({ name = "Edit Character Pitch", flag = "AAEnabled", default = false })
     charSection:toggle({ name = "Position Desync", flag = "posDesync", tooltip = "Meant for making shittier aim cheats(entirely prediction based) miss often or entirely medium-far ranges.", default = false })
       charSection:keybind({
     		name = "Position Desync",
         flag = "posDesyncBind"
     	})
 
   	charSection:toggle({ name = "Spinbot", flag = "Spinbot", default = false })
   	charSection:slider({ name = "Pitch Angle", min = -1, max = 1, default = 0, interval = 1, flag = "PitchAngle" })
   end
 	
 end
 
 
 do -- Configs
 	local configs = window:tab({ name = "Configs" })
 	local config = configs:section({ name = "Theming System", side = "right" })
 
 	config:label({text = "UI Accent"})
 	config:colorpicker({
 		color = Color3.fromHex("#6464FF"),
 		flag = "accent",
 		callback = function(color)
 			library:update_theme("accent", color)
			--ibrary:apply_theme(innerStroke, "Color", "BoxColor")
 		end,
 	})
 
 	config:label({text = "Text Color"})
 	config:colorpicker({
 		color = Color3.fromHex("#fdfdff"),
 		flag = "text",
 		callback = function(color)
 			library:update_theme("text", color)
 		end,
 	})
 
 	config:label({text = "Unselected Text Color"})
 	config:colorpicker({
 		color = Color3.fromHex("#7e7e7e"),
 		flag = "unselected_textColor",
 		callback = function(color)
 			library:update_theme("unselected_text", color)
 		end,
 	})
 
 	config:label({text = "Risky Color"})
 	config:colorpicker({
 		color = Color3.fromHex("#ff4141"),
 		flag = "text",
 		callback = function(color)
 			library:update_theme("risky", color)
 		end,
 	})
 
 	config:label({text = "Warning Color"})
 	config:colorpicker({
 		color = Color3.fromHex("#ffa034"),
 		flag = "text",
 		callback = function(color)
 			library:update_theme("warning", color)
 		end,
 	})
 
 	config:button({
 		name = "Noti Test",
 		callback = function()
 			setthreadidentity(8)
 			library:notification({time = 5, text = "Hit Enemy For 500 Damage", flashing = true, })
 			setthreadidentity(2)
 		end,
 	})
 
 	config:toggle({
 		name = "Keybind List",
 		flag = "keybind_list",
 		default = false,
 		callback = function(bool)
 			window.toggle_list(bool)
 		end,
 	})
 	config:toggle({
 		name = "Player List",
 		flag = "player_list",
 		default = false,
 		callback = function(bool)
 			window.toggle_playerlist(bool)
 		end,
 	})
	config:toggle({
 		name = "ESP Preview",
 		flag = "esp_preview",
 		default = false,
 		callback = function(bool)
 			window.toggle_espPreview(bool)
 		end,
 	})
 	config:toggle({
 		name = "Watermark",
 		flag = "watermark",
 		default = false,
 		callback = function(bool)
 			window.toggle_watermark(bool)
 		end,
 	})
 	config:dropdown({ name = "Themes", items = { "Neverlose", "Skeet/Gamesense", "Interwebz" }, default = "" })
 	config:keybind({
 		name = "UI Bind",
 		default = Enum.KeyCode.End,
 		display = "menu",
 		callback = window.set_menu_visibility,
     flag = "menuBind"
 	})
 	config:slider({
 		name = "Colorpicker Animation Speed",
 		flag = "color_picker_anim_speed",
 		min = 0,
 		max = 5,
 		default = 2,
 		interval = 0.01,
 		suffix = "",
 	})
 	
 	config:button({
 		name = "Copy JobId",
 		callback = function()
 			setclipboard(game.JobId)
 		end,
 	})
 	config:button({
 		name = "Copy GameID",
 		callback = function()
 			setclipboard(game.GameId)
 		end,
 	})
 	config:button({
 		name = "Copy Join Script",
 		callback = function()
 			setclipboard(
 				'game:GetService("TeleportService"):TeleportToPlaceInstance('
 					.. game.PlaceId
 					.. ', "'
 					.. game.JobId
 					.. '", game.Players.LocalPlayer)'
 			)
 		end,
 	})
 	config:button({
 		name = "Rejoin",
 		callback = function()
 			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
 		end,
 	})
 
 	local configs_section = configs:section({ name = "Configuration System", side = "left" })
 	local dir = library.directory .. "/configs/"
 	library.config_holder = configs_section:dropdown({ name = "Configs", items = {}, flag = "config_name_list" })
 	configs_section:textbox({ flag = "config_name_text_box" })
 	configs_section:button({
 		name = "Create",
 		callback = function()
       library:panel({
 				name = "Are you sure you want to create " .. flags["config_name_text_box"] .. " ?",
 				options = { "Yes", "No" },
 				callback = function(option)
 					print(option)
 					if option == "Yes" then
 						writefile(dir .. flags["config_name_text_box"] .. ".cfg", library:get_config())
 			      library:config_list_update()
             library:notification({time = 5, text = string.format("%s Has Been Created", flags["config_name_text_box"] .. ".cfg"), flashing = true, })
 					end
 				end,
 			})
 		end,
 	})
 	configs_section:button({
 		name = "Delete",
 		callback = function()
 			library:panel({
 				name = "Are you sure you want to delete " .. flags["config_name_list"] .. " ?",
 				options = { "Yes", "No" },
 				callback = function(option)
 					print(option)
 					if option == "Yes" then
 						delfile(dir .. flags["config_name_list"] .. ".cfg")
 						library:config_list_update()
             library:notification({time = 5, text = string.format("%s Has Been Deleted", flags["config_name_text_box"] .. ".cfg"), flashing = true, })
 					end
 				end,
 			})
 		end,
 	})
 	configs_section:button({
 		name = "Load",
 		callback = function()
 			library:load_config(readfile(dir .. flags["config_name_list"] .. ".cfg"))
       --setthreadidentity(8)
       library:notification({time = 5, text = string.format("%s Has Been Loaded", flags["config_name_list"] .. ".cfg"), flashing = true, })
       --setthreadidentity(2)
 		end,
 	})
 	configs_section:button({
 		name = "Save",
 		callback = function()
 			writefile(dir .. flags["config_name_text_box"] .. ".cfg", library:get_config())
 			library:config_list_update()
       library:notification({time = 5, text = string.format("%s Has Been Saved", flags["config_name_text_box"] .. ".cfg"), flashing = true, })
 		end,
 	})
 	configs_section:button({
 		name = "Unload Config",
 		callback = function(old_config)
 			warn(old_config)
 			--library:load_config(old_config)
 		end,
 	})
 	configs_section:button({
 		name = "Unload Menu",
 		callback = function()
 			library:unload()
 		end,
 	})
 	
 
 	library:config_list_update()
 end
 
 
 do --// Random Noti
   library:notification({ text = "Cheat is loaded!" })
 end


 AimingTab.open_tab()
end


--local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampro1240/LegacyClient-Temporary-Place-/refs/heads/main/VaderHaxx%20Drawing/UI/VaderHaxx%20UI.lua"))()
local getService, getFunction, getGCFunction, deepCopy, Variables, Math, FindFirstChild, FindFirstChildOfClass, wtvpp = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampro1240/LegacyClient-Temporary-Place-/refs/heads/main/Legacy%20Lua%20Project/Libraries/Services.lua"))()
local espConnection


local ESP = {
  fontSettings = {
    Minecraftia = {FontSize = 10, namePadding = 13, bottomPadding = 2, bottomListLayoutPadding = -3, leftListLayoutPadding = 10, bottomHealthTextPadding = -11, leftHealthTextPadding = -19};
	SilkScreen = {FontSize = 10, namePadding = 13, bottomPadding = 2, bottomListLayoutPadding = -3, leftListLayoutPadding = 10, bottomHealthTextPadding = -11, leftHealthTextPadding = -19};
    ProggyTiny = {FontSize = 9, namePadding = 12, bottomPadding = 3, bottomListLayoutPadding = 2, leftListLayoutPadding = 10, bottomHealthTextPadding = -7, leftHealthTextPadding = -14};
	small_pixel = {FontSize = 9, namePadding = 5, bottomPadding = 3, bottomListLayoutPadding = 2, leftListLayoutPadding = 10, bottomHealthTextPadding = -7, leftHealthTextPadding = -14};
    SmallestPixel = {FontSize = 9, namePadding = 12, bottomPadding = 1, bottomListLayoutPadding = 0, leftListLayoutPadding = 10, bottomHealthTextPadding = -3, leftHealthTextPadding = -10};
    RetroSpace = {FontSize = 9, namePadding = 12, bottomPadding = 1, bottomListLayoutPadding = 0, leftListLayoutPadding = 10, bottomHealthTextPadding = -3, leftHealthTextPadding = -10};
    Tahoma = {FontSize = 12, namePadding = 15, bottomPadding = 1, bottomListLayoutPadding = 0, leftListLayoutPadding = 40, bottomHealthTextPadding = -5, leftHealthTextPadding = -12, leftHealthTextPadding = -22, rightHealthTextPadding = 25};
  };
  
  
  healthBarSettings = {
    ["1 Pixel"] = {Padding = 3, Size = 1},
    ["2 Pixel"] = {Padding = 4, Size = 2},

    ["Left"] = {Parent = "LeftFlags", AnchorPoint = .5, Enum = "Left", HealthTextPadding = -22, aimingFlagPaddingBottom = -1.2, aimingFlagPaddingLeft = 35};
    ["Right"] = {Parent = "RightFlags", AnchorPoint = 1, Enum = "Right", HealthTextPadding = 25, aimingFlagPaddingBottom = -1.2, aimingFlagPaddingLeft = 35};
	["Bottom"] = {Parent = "BottomFlags", AnchorPoint = 1, Enum = "Center", HealthTextPadding = 25, aimingFlagPaddingBottom = -1.2, aimingFlagPaddingLeft = 35};
  };

  
  ValidParts = {
  	"Head",

  	"UpperTorso",
  	"LowerTorso",
  	"LeftUpperArm",
  	"LeftLowerArm",
  	"LeftHand",
  	"RightUpperArm",
  	"RightLowerArm",
  	"RightHand",
  	"LeftUpperLeg",
  	"LeftLowerLeg",
  	"LeftFoot",
  	"RightUpperLeg",
  	"RightLowerLeg",
  	"RightFoot",

    "Torso",
    "LeftArm",
    "RightArm",
    "LeftLeg",
    "RightLeg",
  };

}
local FontNames = {
  ["Tahoma"] = "fs-tahoma-8px.ttf",
  ["SmallestPixel"] = "smallest_pixel-7.ttf",
  ["ProggyTiny"] = "ProggyTiny.ttf",
  ["Minecraftia"] = "Minecraftia-Regular.ttf",
  ["SegoeUI"] = "segoeuil.ttf";
  ["small_pixel"] = "small_pixel.ttf",
  ["SilkScreen"] = "slkscr.ttf"
}


local Fonts = {}
local FontIndexes = {"Tahoma", "SmallestPixel", "ProggyTiny", "Minecraftia", "SegoeUI", "small_pixel", "SilkScreen"}
local espCache = {}
local vehicleCache = {}
local corpseCache = {}


local rayOrigin
local flags = library.flags


local currentCamera = workspace.CurrentCamera
local Raycast = Workspace.Raycast
local WorldToViewportPoint = currentCamera.WorldToViewportPoint
local viewportSize = currentCamera.ViewportSize


local typeOf = typeof
local clock = os.clock



local round = math.round
local floor = math.floor
local clamp = math.clamp
local mathatan2 = math.atan2
local mathdeg = math.deg
local mathsin = math.sin
local mathcos = math.cos
local mathmax = math.max


local UDim2new = UDim2.new
local UDimnew = UDim.new
local fromOffset = UDim2.fromOffset
local vectorcreate = vector.create
local vector2New = Vector2.new
local center = vector2New(viewportSize.X / 2, viewportSize.Y / 2)


local fromRGB = Color3.fromRGB
local Color3new = Color3.new
local ColorSequencenew = ColorSequence.new
local ColorSequenceKeypointnew = ColorSequenceKeypoint.new
local NumberSequencenew = NumberSequence.new
local NumberSequenceKeypointnew = NumberSequenceKeypoint.new


local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Instancenew = Instance.new


local Vehicles = workspace.Vehicles
local Corpses = workspace.Corpses


local visualHolder = Instancenew("ScreenGui", gethui())
visualHolder.IgnoreGuiInset = true
visualHolder.Enabled = true
visualHolder.ResetOnSpawn = false


-- Font Registering
local function RegisterFont(Name, Weight, Style, Asset)
    -- Write the raw font file if it doesn't already exist in the workspace
    if not isfile(Asset.Id) then
        writefile(Asset.Id, Asset.Font)
    end

    -- Clear old font metadata file if it exists
    if isfile(Name .. ".font") then
        delfile(Name .. ".font")
    end

    -- Create the font face configuration data structure required by Roblox
    local Data = {
        name = Name,
        faces = {
            {
                name = "Normal",
                weight = Weight,
                style = Style,
                assetId = getcustomasset(Asset.Id),
            },
        },
    }

    -- Encode and write the JSON metadata file
    writefile(Name .. ".font", game:GetService("HttpService"):JSONEncode(Data))

    -- Return the custom asset URI for the .font metadata file
    return getcustomasset(Name .. ".font")
end


for name, suffix in FontNames do 
    local Weight = 400 
    
    -- Fix: Use the raw GitHub link instead of the /blob/ HTML page link
    local rawUrl = "https://raw.githubusercontent.com/iampro1240/LegacyClient-Temporary-Place-/main/Legacy%20Lua%20Project/Libraries/ESP/Fonts/" .. suffix

    local success, fontData = pcall(function()
        return game:HttpGet(rawUrl)
    end)

    if success and fontData then
        local RegisteredFont = RegisterFont(name, Weight, "Normal", {
            Id = suffix,
            Font = fontData,
        }) 
        
        Fonts[name] = Font.new(RegisteredFont, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    else
        warn("Failed to download font: " .. name)
    end
end


local function getBoneValue(cache, bonePart, value)
    return cache[bonePart][value]
end
  
  
local function setBoneVis(cache, visible)
    for _, item in cache do
		item.Line.Visible = visible
		item.Outline.Visible = visible
    end
end


local function DrawFrame(properties)
	local obj = Instancenew("Frame")
	obj.Name = properties.Name
	obj.Parent = properties.Parent
       
	obj.BackgroundTransparency = properties.BackgroundTransparency
	obj.BackgroundColor3 = properties.Color
	obj.BorderColor3 = fromRGB(0, 0, 0)
       
	obj.BorderSizePixel = properties.BorderSizePixel
	obj.Position = properties.Position
	obj.Size = properties.Size
       
	obj.ZIndex = properties.Zindex
	obj.Rotation = properties.Rotation
	obj.AnchorPoint = properties.AnchorPoint
	obj.AutomaticSize = properties.AutomaticSize or Enum.AutomaticSize.None
	obj.LayoutOrder = properties.LayoutOrder or 0
end


local function DrawText(properties)
	local obj = Instancenew("TextLabel")
	local stroke = Instancenew("UIStroke")
	obj.Name = properties.Name
	obj.TextSize = 10
	obj.RichText = true
	stroke.LineJoinMode = Enum.LineJoinMode.Miter
       
	obj.Parent = properties.Parent
	obj.BackgroundTransparency = 1
           
	obj.BorderColor3 = fromRGB(0, 0, 0)
	obj.BorderSizePixel = 0
       
	obj.TextStrokeTransparency = 1
	obj.FontFace = Fonts.Tahoma
	   
	obj.Size = obj.Size or UDim2.new(0, 0, 0, 0)
       
	obj.AnchorPoint = properties.AnchorPoint
       
	obj.AutomaticSize = Enum.AutomaticSize.Y
	stroke.Parent = obj
	stroke.LineJoinMode = Enum.LineJoinMode.Miter
end


local function DrawUIStroke(properties)
    local obj = Instancenew("UIStroke")
    obj.Parent = properties.Parent
  return obj
end


local function DrawGradient(properties)
	local obj = Instancenew("UIGradient")
	obj.Name = "UIGradient"
	obj.Parent = properties.Parent or nil
        
	obj.Rotation = properties.Rotation or 0
	obj.Color = properties.Color or fromRGB(255, 255, 255)
 return obj
end


local function getParts(esp, character)
    if not character or character == nil then
      return
    end
  
  
    local folder = Instance.new("Folder", esp.holder)
    for _, part in character:GetChildren() do
        if part:IsA("MeshPart") or part:IsA("Part") then
          if part.Name == "HumanoidRootPart" or part.Name == "HeadCollider" then
            continue
          end
          -- 1. Glowing Cham (In Front)
          esp.chamCache[part] = Instance.new("BoxHandleAdornment", folder)
          esp.chamCache[part].ZIndex = 2
          esp.chamCache[part].Adornee = part
          esp.chamCache[part].Size = part.Size
          esp.chamCache[part].Visible = false
          esp.chamCache[part].Transparency = -1
          esp.chamCache[part].Shading = Enum.AdornShading.XRay
          
          -- 2. Blacked Out Cham (Behind / Inner Layer)
          esp.chamCacheTwo[part] = Instance.new("BoxHandleAdornment", folder)
          esp.chamCacheTwo[part].ZIndex = 1
          esp.chamCacheTwo[part].Adornee = part
          -- Make it slightly smaller so it sits cleanly inside the glowing cham without z-fighting
          esp.chamCacheTwo[part].Size = part.Size - Vector3.new(0.05, 0.05, 0.05)
          esp.chamCacheTwo[part].Visible = false
          esp.chamCacheTwo[part].Transparency = -1
          esp.chamCacheTwo[part].Color3 = Color3.fromRGB(0, 0, 0)
          esp.chamCacheTwo[part].Name = "BlackedOut"
          esp.chamCacheTwo[part].Shading = Enum.AdornShading.XRay -- Crucial: Allows it to render through character parts
  
          esp.partCache[part] = part or {part}
        end
    end
end


local function getBones(esp, character)
    if not character or character == nil then
      return
    end
  
  
    for _, part in character:GetChildren() do
      if cheat.ValidParts[part.Name] then
        esp.partCache[part] = part or {part}
      end
    end
end
  
  
local function connectBone(Bone, Visible, From, To, Thickness, Color, Zindex)
	Bone.Visible = Visible
	Bone.From = From
	Bone.To = To
	Bone.Thickness = Thickness
	Bone.Color = Color
	Bone.ZIndex = Zindex
end


local function getVis(vis, isVisColor, notVisColor)
    if vis then
      return isVisColor
     else
      return notVisColor
    end
end


local function renderESP()
    local lastTick = os.clock()
    local visParams = RaycastParams.new()
    local animationSpeed = 1
    

    local lastShotUpdate = tick()
    local waitTime

      
    visParams.FilterType = Enum.RaycastFilterType.Exclude
    visParams.IgnoreWater = false
    visParams.CollisionGroup = "Default"


    local accumulatedTime = 0
    local TARGET_INTERVAL = 1 / 60


    local fontSettings = ESP.fontSettings
	local healthBarSettings = ESP.healthBarSettings
    
    
    local getVisFunc = getVis
    local filterTable = {}
    
    espConnection = runService.PreRender:Connect(function(deltatime)
        accumulatedTime += deltatime
        if accumulatedTime < TARGET_INTERVAL then
            return
        end
        accumulatedTime -= TARGET_INTERVAL
		
		local isEnableAll = flags["EnableAll"]
		local cameraPos = currentCamera.CFrame.Position
		local localCharacter = LocalPlayer.Character
        

		if not isEnableAll or localCharacter == nil then
           for _, player in espCache do
              player.holder.Visible = false

			  for _, cham in player.chamCache do
			    cham.Visible = false
			  end
           end

		   for _, vehicle in vehicleCache do
              vehicle.holder.Visible = false
		   end

		   for _, corpse in corpseCache do
              corpse.holder.Visible = false
		   end

		   return
        end 

		
       	do --// Player
		  local charFind = localCharacter.FindFirstChild
       	  local currentTextFont, flagFont = flags["TextFont"], flags["TextFlagFont"]
       	  local textFont, flagTextFont = Fonts[currentTextFont], Fonts[flagFont]
       	 
               
       	  local healthBarPadding = healthBarSettings[flags["HealthBarPadding"]].Padding
       	  local healthBarPaddingSize = healthBarSettings[flags["HealthBarPadding"]].Size
       	  local textFlagFont = fontSettings[flagFont]
       	  local healthBarPositionFlag = flags["healthBarPosition"]
      
       	  local rayOriginPart = localCharacter and charFind(localCharacter, "Head")
       	  if not rayOriginPart then return end
       
               
       	  local isMaxDistance = flags["MaxDistance"]
       	  local isName, nameColor, isDisplayName = flags["Names"], flags["Name_Color"].Color, flags["UseDisplayName"]
       	  local isDistance, distanceColor, distanceType = flags["Distance"], flags["Distance_Color"].Color, flags["DistanceType"]
       	  local isWeapon, weaponColor = flags["Weapon"], flags["Weapon_Color"].Color
       	  local isVisFlag, visColor, notVisColor = flags["Vis"], flags["Vis_Color"].Color, flags["Not_Vis_Color"].Color
       	  local isHealthText, healthTextColor = flags["HealthText"], flags["Health_Text_Color"].Color
       	  local isAimingText, isAimingColor, notAimingColor = flags["AimingText"], flags["Aiming_Color"].Color, flags["Not_Aiming_Color"].Color
       	  local isInventoryText, isInventoryColor, notInventoryColor = flags["InventoryText"], flags["Inventory_Color"].Color, flags["Not_Inventory_Color"].Color
          

       	  local isBox, boxColor, isBoxFill, boxFillColorOne, boxFillColorTwo, boxFillVisOne, boxFillVisTwo = flags["Boxes"], flags["Box_Color"].Color, flags["BoxFill"], flags["Box_Fill_Color"].Color, flags["Box_Fill_Color_Two"].Color, flags["Box_Fill_Color"].Transparency, flags["Box_Fill_Color_Two"].Transparency
       	  local isHealthBar, barGradientOne, barGradientTwo = flags["Healthbar"], flags["GradientColor1"].Color, flags["GradientColor2"].Color
       	  local healthSpeed = flags["healthBarSpeed"] * 10
       	  local fullFlag = flags["Health_Text_Color"].Color
       	  local lowFlag = flags["Low_Health_Text_Color"].Color
       	  local speed = flags["healthBarSpeed"] or 2
       		
       		
       	  local boxFillRotation = flags["FillRotation"]
       	  local boxFillColorSequence, boxFillTransparencySequence = ColorSequencenew{ColorSequenceKeypointnew(0, boxFillColorOne), ColorSequenceKeypointnew(1, boxFillColorTwo)}, NumberSequencenew{NumberSequenceKeypointnew(0, boxFillVisOne), NumberSequenceKeypointnew(1, boxFillVisTwo)}
       	  local barColorSequence = ColorSequencenew{ColorSequenceKeypointnew(0, barGradientOne), ColorSequenceKeypointnew(1, barGradientTwo)}
       
       		
       	  local isChams, cColor, ChamGlowMultiplier = flags["BoxChams"], flags["Box_Cham_Color"].Color, flags["ChamGlowMultiplier"]
       	  local chamColor = Color3new(cColor.R * ChamGlowMultiplier, cColor.G * ChamGlowMultiplier, cColor.B * ChamGlowMultiplier)
       	  local rayOriginPos = rayOriginPart.Position
       	  local currentClock = clock()	
		  
       
            for _, player in espCache do
                   local esp, UI, chamCache = player.holder, player.UI, player.chamCache
                   local actualPlayer = player.Player
                   local character = player.Character


				   local nameText, distanceText, weaponText = UI.PName, UI.Distance, UI.Weapon
       			   local healthFlagHolder = UI.HealthTextHolder
                   local visFlag, healthFlag, aimingFlag, inventoryFlag = UI.VisFlag, UI.HealthText, UI.AimingText, UI.InventoryText
                   

                   local box, boxFill, BoxFillGradient, boxStrokeColor = UI.Box, UI.BoxFill, UI.BoxFillGradient, UI.topColor
                   local healthBar, bar, barGradient = UI.HealthBar, UI.Bar, UI.BarGradient
				   local leftFlags, rightFlags = UI.LeftFlags, UI.RightFlags
       

         		   if not character then
         			  esp.Visible = false
                    continue
         		   end
       

       			   local findFirstChild, findFirstChildOfClass = character.FindFirstChild, character.FindFirstChildOfClass
                   local head, root, humanoid, equipped, animator = findFirstChild(character, "Head"), findFirstChild(character, "HumanoidRootPart"), findFirstChild(character, "Humanoid"), findFirstChild(character, "Equipped"), findFirstChild(character, "Animator")
                   if not head or not root or not humanoid or not equipped or not animator or humanoid.Health <= 0 then
                     esp.Visible = false
                    continue
                   end
                   
                   
                   local rootPos = root.Position
                   local distancemag = round((rootPos - cameraPos).Magnitude)
                   
                   
                   local pos2, isRootVis = WorldToViewportPoint(currentCamera, rootPos)
                   if not isRootVis or distancemag >= isMaxDistance then
                     esp.Visible = false
         			 for _, cham in chamCache do
					   cham.Visible = false
         			 end
                    continue
                   end
                   esp.Visible = true
                   
                   
                   local offsetVector = vectorcreate(0, root.Size.Y * 1.25, 0)
                   local top2D = WorldToViewportPoint(currentCamera, rootPos + offsetVector)
                   local bottom2D = WorldToViewportPoint(currentCamera, rootPos - offsetVector)
                   

                   local height = (bottom2D.Y - top2D.Y)
                   local width = height * 0.73
                   
                   
                   local centerX = pos2.X
                   local centerY = top2D.Y + (height / 2)
                   
                   
                   local boxYSize = height * 1.16 + 7
                   local boxTotalWidth = floor(width * 1.16 + 5)
                   
                   
                   local halfBoxWidth = floor(boxTotalWidth * 0.5)
                   local halfBoxHeight = floor(boxYSize * 0.5)
                   
                   
                   local boxLeftX = floor(centerX - halfBoxWidth)
                   local posClamp = floor(centerY - halfBoxHeight)


				   local cutOff = clamp((distancemag - 250) / 80, 0, 1)
				   local aimingStroke, inventoryStroke = aimingFlag:FindFirstChild("UIStroke"), inventoryFlag:FindFirstChild("UIStroke")
                   
                   
                   nameText.Visible = isName
                   if isName then
                       nameText.Position = fromOffset(centerX, posClamp - 11)
                       nameText.TextColor3 = nameColor
                       nameText.Text = isDisplayName and actualPlayer.DisplayName or actualPlayer.Name
                   end
                   
                   
                   distanceText.Visible = isDistance
                   if isDistance then
                       distanceText.Text = distancemag .. distanceType
                       distanceText.TextColor3 = distanceColor
                   end
                   
				   
				   weaponText.Visible = isWeapon
                   if isWeapon then
					   local weapon = findFirstChildOfClass(equipped, "Model")
				       local weaponValue = weapon and string.format("%s", weapon.Name) or "Empty"
                       weaponText.TextColor3 = weaponColor
                       weaponText.Text = weaponValue
                   end
                   
                   
                   visFlag.Visible = isVisFlag
                   if isVisFlag then
                       --visFlag.FontFace = textFont
                       --visFlag.TextSize = fontSize
           
                       if (currentClock - player.lastRaycast) > 0.1 then
                           player.lastRaycast = currentClock
                           
                           filterTable[1] = localCharacter
                           filterTable[2] = rayOriginPart
                           filterTable[3] = character
                           visParams.FilterDescendantsInstances = filterTable
						   
                           local visCheck = Raycast(Workspace, rayOriginPos, head.Position - rayOriginPos, visParams)
                           player.playerVis = not visCheck or visCheck.Instance == head or visCheck.Instance.Parent == character
                       end
                       
                       visFlag.TextColor3 = getVisFunc(player.playerVis, visColor, notVisColor)
                   end
                   
                   
       			   healthFlagHolder.Visible = isHealthText
                   if isHealthText then
                     healthFlag.TextColor3 = healthTextColor
                     healthFlag.Text = floor(humanoid.Health)
					 inventoryFlag.TextTransparency = cutOff
       			     inventoryFlag["UIStroke"].Transparency = cutOff
                   end
                   
                   
                   aimingFlag.Visible = isAimingText
                   if isAimingText then
                     aimingFlag.TextColor3 = getVisFunc(animator.Zooming.Value, isAimingColor, notAimingColor)
					 aimingFlag.TextTransparency = cutOff
					 if aimingStroke then
       			       aimingStroke.Transparency = cutOff
					 end
                   end
                   
                   
                   inventoryFlag.Visible = isInventoryText
                   if isInventoryText then
					 inventoryFlag.TextColor3 = getVisFunc(animator.InventorySearch.Value, isInventoryColor, notInventoryColor)
					 inventoryFlag.TextTransparency = cutOff
					 if inventoryStroke then
       			       inventoryStroke.Transparency = cutOff
					 end
					 --inventoryFlag["UIStroke"].Transparency = cutOff
                   end
                   
                   
                   box.Visible = isBox
                   if isBox then
					box.Position = UDim2new(0, centerX, 0, posClamp)
					box.Size = UDim2new(0, boxTotalWidth, 0, boxYSize)
					boxStrokeColor.Color = boxColor
					boxFill.Visible = isBoxFill
       				if isBoxFill then
           			   BoxFillGradient.Color = boxFillColorSequence
       				   BoxFillGradient.Transparency = boxFillTransparencySequence
       				   BoxFillGradient.Rotation = boxFillRotation
       				end
                   end
                   
                   
                   healthBar.Visible = isHealthBar
                   if isHealthBar then
       				player.MaxHealth = player.MaxHealth + (humanoid.Health - player.MaxHealth) * clamp(healthSpeed * deltatime, 0, 1)
       				local maxHealth = humanoid.MaxHealth > 0 and humanoid.MaxHealth or 100
					local healthPercent = clamp(player.MaxHealth / maxHealth, 0, 1)
       			
       				--UI.leftListLayout.HorizontalAlignment = Enum.HorizontalAlignment[healthBarSettings[healthBarPositionFlag].Enum]
       				--UI.HealthTextPadding.PaddingLeft = UDimnew(0, healthBarSettings[healthBarPositionFlag].HealthTextPadding)
       				
       				healthBar.Size = UDim2new(0, healthBarPaddingSize, 0, boxYSize)
					leftFlags.Size = fromOffset(-1, boxYSize)
       				bar.Size = UDim2new(1, 0, healthPercent, 0)
       
       				leftFlags.Position = fromOffset(boxLeftX - healthBarPadding, posClamp)
					barGradient.Color = barColorSequence
       				
       				healthFlag.Position = UDim2new(0, 0, 1 - healthPercent, 0)
					healthFlag.TextColor3 = fullFlag:Lerp(lowFlag, 1 - healthPercent)
                   end
       			
                   
        		   for _, cham in chamCache do
					cham.Visible = isChams
					cham.Color3 = chamColor
				   end

				   
				   rightFlags.Position = fromOffset(boxLeftX + boxTotalWidth + healthBarPadding, posClamp)
                   rightFlags.Size = fromOffset(1, boxYSize)
                   UI.BottomFlags.Position = fromOffset(centerX, floor(posClamp + boxYSize + 2))
                   
            end

       	end


    	do --// Vehicle
    		local isMaxDistance = flags["VehicleMaxDistance"]
            local isName, nameColor = flags["VehicleNames"], flags["Vehicle_Name_Color"].Color
            local isDistance, distanceColor, distanceType = flags["VehicleDistance"], flags["Vehicle_Distance_Color"].Color, flags["VehicleDistanceType"]
    		local isBox, boxColor = flags["VehicleBoxes"], flags["Vehicle_Box_Color"].Color
            

    		for _, vehicle in vehicleCache do
                local esp, UI, chamCache = vehicle.holder, vehicle.UI, vehicle.chamCache
    			local vehicleModel = vehicle.Vehicle


				local nameText, distanceText = UI.PName, UI.Distance
                local box, boxStrokeColor = UI.Box, UI.topColor
				
                
    			if not vehicleModel then
    			  esp.Visible = false
                 continue
    			end
    		
               
				local getBoundingBox = vehicleModel.GetBoundingBox
				local boxCFrame, boxSize = getBoundingBox(vehicleModel)


                local centerPos = boxCFrame.Position
                local distancemag = floor((centerPos - cameraPos).Magnitude)


				if distancemag >= isMaxDistance then
    			  esp.Visible = false
    			  for _, cham in chamCache do
    				cham.Visible = false
    			  end
                  continue
                end
        

				local center2D, isRootVis = WorldToViewportPoint(currentCamera, centerPos)
                if not isRootVis then
                  esp.Visible = false
                 continue
                end
                esp.Visible = true

				
                local offsetVector = vectorcreate(0, boxSize.Y * .5, 0)
                local top2D = WorldToViewportPoint(currentCamera, centerPos + offsetVector)
                local bottom2D = WorldToViewportPoint(currentCamera, centerPos - offsetVector)
                
                local height = (bottom2D.Y - top2D.Y)
                local maxHorizontal = math.max(boxSize.X, boxSize.Z)
				
                local safeY = math.max(boxSize.Y, 0.001)
                local width = height * (maxHorizontal / safeY)
                
                local centerX = center2D.X
                local centerY = center2D.Y
                
                local boxYSize = height * 1.16 + 7
                local boxTotalWidth = floor(width * 1.16 + 7)
                local halfBoxWidth = floor(boxTotalWidth * 0.5)
                local halfBoxHeight = floor(boxYSize * 0.5)
                local posClamp = floor(centerY - halfBoxHeight)
				

                nameText.Visible = isName
                if isName then
				  nameText.Position = fromOffset(centerX, posClamp - 11)
                  nameText.TextColor3 = nameColor
                  nameText.Text = vehicleModel.Name
                end
        
                
                distanceText.Visible = isDistance
                if isDistance then
                  distanceText.Text = distancemag .. distanceType
                  distanceText.TextColor3 = distanceColor
                end
                
                
                box.Visible = isBox
                if isBox then
                  box.Position = UDim2new(0, centerX, 0, posClamp)
                  box.Size = UDim2new(0, boxTotalWidth, 0, boxYSize)
                  boxStrokeColor.Color = boxColor
                end

				UI.BottomFlags.Position = fromOffset(centerX, floor(posClamp + boxYSize + 2))
            end

    	end


		do --// Corpse
    		local isMaxDistance = flags["CorpseMaxDistance"]
            local isName, nameColor = flags["CorpseNames"], flags["Corpse_Name_Color"].Color
            local isDistance, distanceColor, distanceType = flags["CorpseDistance"], flags["Corpse_Distance_Color"].Color, flags["CorpseDistanceType"]
    		local isBox, boxColor = flags["CorpseBoxes"], flags["Corpse_Box_Color"].Color
            
            
    		for _, corpse in corpseCache do
                local esp, UI, chamCache = corpse.holder, corpse.UI, corpse.chamCache
    			local corpseModel = corpse.Corpse


				local nameText, distanceText = UI.PName, UI.Distance
                local box, boxStrokeColor = UI.Box, UI.topColor
				
                
    			if not corpseModel then
    			  esp.Visible = false
                 continue
    			end
    		
               
				local getBoundingBox = corpseModel.GetBoundingBox
				local boxCFrame, boxSize = getBoundingBox(corpseModel)


                local centerPos = boxCFrame.Position
                local distancemag = floor((centerPos - cameraPos).Magnitude)
				

				local center2D, isRootVis = WorldToViewportPoint(currentCamera, centerPos)
                if not isRootVis or distancemag >= isMaxDistance then
                  esp.Visible = false
                 continue
                end
                esp.Visible = true
                
				
                local offsetVector = vectorcreate(0, boxSize.Y * .5, 0)
                local top2D = WorldToViewportPoint(currentCamera, centerPos + offsetVector)
                local bottom2D = WorldToViewportPoint(currentCamera, centerPos - offsetVector)
                local height = (bottom2D.Y - top2D.Y)

				local maxHorizontal = math.max(boxSize.X, boxSize.Z)
                local safeY = math.max(boxSize.Y, 0.001)
                local width = height * (maxHorizontal / safeY)
				--height * (mathmax(boxSize.X, boxSize.Z) / boxSize.Y)
                
                local centerX = center2D.X
                local centerY = center2D.Y
                
                local boxYSize = height * 1.16 + 7
                local boxTotalWidth = floor(width * 1.16 + 7)
                local halfBoxWidth = floor(boxTotalWidth * 0.5)
                local halfBoxHeight = floor(boxYSize * 0.5)
                local posClamp = floor(centerY - halfBoxHeight)
				
                
                nameText.Visible = isName
                if isName then
				  nameText.Position = fromOffset(centerX, posClamp - 11)
                  nameText.TextColor3 = nameColor
                  nameText.Text = corpseModel.Name
                end
        
                
                distanceText.Visible = isDistance
                if isDistance then
                  distanceText.Text = distancemag .. distanceType
                  distanceText.TextColor3 = distanceColor
                end
                
                
                box.Visible = isBox
                if isBox then
                  box.Position = UDim2new(0, centerX, 0, posClamp)
                  box.Size = UDim2new(0, boxTotalWidth, 0, boxYSize)
                  boxStrokeColor.Color = boxColor
                end

				UI.BottomFlags.Position = fromOffset(centerX, floor(posClamp + boxYSize + 2))
            end

    	end

    end)

end


local function PlayerObject(self)
     espCache[self] = {Name = self.Name, Player = self, Character = self.Character, holder = Instancenew("Frame", visualHolder), playerVis = false, playerManip = false, partCache = {}, boneCache = {}, chamCache = {}, chamCacheTwo = {}, Colors = Instancenew("Folder"), Borders = Instancenew("Folder"), chamsholder = Instancenew("Folder"), highlight = Instancenew("Highlight", visualHolder), lastRaycast = 0, weapon = nil}
     local esp, player = espCache[self], espCache[self]
     local Colors = esp.Colors
     local Borders = esp.Borders 
     local espholder, cache, chamsholder, esphighlight = esp.holder, esp.cache, esp.chamsholder, esp.highlight
     esp.UI = {}
                
   
     espholder.Name = self.Name
     espholder.Visible = false
   
     chamsholder.Parent = espholder
   
   
     Colors.Parent = espholder
     Borders.Parent = espholder
     Colors.Name = "Colors"
     Borders.Name = "Borders"
     
     
     do -- Bottom Flags & PName
        DrawFrame({
         Name = "BottomFlags",
         Parent = esp.holder,
         Color = fromRGB(255, 255, 255),
         BackgroundTransparency = 1,
         BorderSizePixel = 0,
         Position = UDim2new(0, 632, 0, 569),
         Size = UDim2new({0.062, 0},{0.126, 0}),
         Zindex = 9999999999,
         Rotation = 0,
         AnchorPoint = vector2New(0, 0)
        })

		local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = esp.holder["BottomFlags"]
		listLayout.Padding = UDimnew(0, 1)
   
        -- PName Frame & Text
        DrawFrame({
           Name = "PNameText",
           Parent = esp.holder,
           Color = fromRGB(255, 255, 255),
           BackgroundTransparency = 1,
           BorderSizePixel = 0,
           Position = UDim2new(0, 0, 0, 0),
           Size = UDim2new(1, 0, 0, 0),
           Zindex = 9999999999,
           Rotation = 0,
           AnchorPoint = vector2New(0, 0),
		   AutomaticSize = Enum.AutomaticSize.Y
        })

        DrawText({
           Name = "PName", 
           Parent = esp.holder["PNameText"],
           TextSize = 10,
           AnchorPoint = vector2New(0, 0),
           Size = UDim2.new(1, 0, 0, 0)
        })
   
        -- Distance Frame & Text
        DrawFrame({
           Name = "DistanceText",
           Parent = esp.holder["BottomFlags"],
           Color = fromRGB(255, 255, 255),
           BackgroundTransparency = 1,
           BorderSizePixel = 0,
           Position = UDim2new(0, 0, 0, 0),
           Size = UDim2new(1, 0, 0, 0),
           Zindex = 9999999999,
           Rotation = 0,
           AnchorPoint = vector2New(0, 0),
		   AutomaticSize = Enum.AutomaticSize.Y,
        })

        DrawText({
           Name = "distanceValue", 
           Parent = esp.holder["BottomFlags"]["DistanceText"],
           TextSize = 10,
           AnchorPoint = vector2New(0, 0),
           Size = UDim2.new(1, 0, 0, 0)
        })
   
        -- Weapon Frame & Text
        DrawFrame({
           Name = "WeaponText",
           Parent = esp.holder["BottomFlags"],
           Color = fromRGB(255, 255, 255),
           BackgroundTransparency = 1,
           BorderSizePixel = 0,
           Position = UDim2new(0, 0, 0, 0),
           Size = UDim2new(1, 0, 0, 0),
           Zindex = 9999999999,
           Rotation = 0,
           AnchorPoint = vector2New(0, 0),
		   AutomaticSize = Enum.AutomaticSize.Y,
        })

        DrawText({
           Name = "weaponValue", 
           Parent = esp.holder["BottomFlags"]["WeaponText"],
           TextSize = 10,
           AnchorPoint = vector2New(0, 0),
           Size = UDim2.new(1, 0, 0, 0)
        })

        -- VisFlag Frame & Text
        DrawFrame({
           Name = "VisFlagText",
           Parent = esp.holder["BottomFlags"],
           Color = fromRGB(255, 255, 255),
           BackgroundTransparency = 1,
           BorderSizePixel = 0,
           Position = UDim2new(0, 0, 0, 0),
           Size = UDim2new(1, 0, 0, 0),
           Zindex = 9999999999,
           Rotation = 0,
           AnchorPoint = vector2New(0, 0),
		   AutomaticSize = Enum.AutomaticSize.Y,
		   LayoutOrder = 2
        })

        DrawText({
           Name = "visValue", 
           Parent = esp.holder["BottomFlags"]["VisFlagText"],
           TextSize = 10,
           AnchorPoint = vector2New(0, 0),
           Size = UDim2.new(1, 0, 0, 0),
        })

        -- ManipFlag Frame & Text
        DrawFrame({
           Name = "ManipFlagText",
           Parent = esp.holder["BottomFlags"],
           Color = fromRGB(255, 255, 255),
           BackgroundTransparency = 1,
           BorderSizePixel = 0,
           Position = UDim2new(0, 0, 0, 0),
           Size = UDim2new(1, 0, 0, 0),
           Zindex = 9999999999,
           Rotation = 0,
           AnchorPoint = vector2New(0, 0)
        })

        DrawText({
           Name = "manipValue", 
           Parent = esp.holder["BottomFlags"]["ManipFlagText"],
           TextSize = 10,
           AnchorPoint = vector2New(0, 0),
           Size = UDim2.new(1, 0, 0, 0)
        })
       
        --uiPadding.PaddingBottom = UDimnew(1, 0)

        --local weaponPadding, distancePadding = Instancenew("UIPadding", esp.holder["BottomFlags"]["WeaponText"]), Instancenew("UIPadding", esp.holder["BottomFlags"]["DistanceText"])
     end
   
     do -- box
        DrawFrame({
            Name = "Box",
            Parent = esp.holder,
            Color = fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 1,
            Position = UDim2new(0.17, 0, 0.12, 0),
            Size = UDim2new(0.65, 0, 0.88, 0),
            Zindex = 5,
            Rotation = 0,
            AnchorPoint = vector2New(.5, 0),
        })

        DrawFrame({
            Name = "BoxFill",
            Parent = esp.holder["Box"],
            Color = fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 1,
            Position = UDim2new(0, 0, 0, 0),
            Size = UDim2new(1, 0, 1, 0),
            Zindex = -5,
            Rotation = 0,
            AnchorPoint = vector2New(0, 0),
        })

        esp.UI.BoxFillGradient = DrawGradient({
          Parent = esp.holder["Box"]["BoxFill"],
          Rotation = -90,
          Color = ColorSequence.new{ColorSequenceKeypoint.new(0, fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, fromRGB(255, 255, 255))},
          Transparency = 0
       })
   
       Colors.Parent = esp.holder["Box"]
       Borders.Parent = esp.holder["Box"]
     end
   
     do -- HealthBar
      DrawFrame({
        Name = "LeftFlags",
        Parent = esp.holder,
        Color = fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2new(0, 632, 0, 569),
        Size = UDim2new({0.062, 0},{0.126, 0}),
        Zindex = 9999999999,
        Rotation = 0,
        AnchorPoint = vector2New(0, 0)
       })

       DrawFrame({
        Name = "LeftFlagsTwo",
        Parent = esp.holder["LeftFlags"],
        Color = fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2new(0, 632, 0, 569),
        Size = UDim2new({0.062, 0},{0.126, 0}),
        Zindex = 9999999999,
        Rotation = 0,
        AnchorPoint = vector2New(0, 0)
       })

       local listLayout = Instancenew("UIListLayout", esp.holder["LeftFlags"])
       listLayout.Padding = UDimnew(0, -5)
       listLayout.FillDirection = "Horizontal"
       listLayout.HorizontalAlignment = "Left"
       listLayout.HorizontalFlex = "None"
       listLayout.VerticalAlignment = "Top"
       listLayout.ItemLineAlignment = "Start"

       local listLayout2 = Instancenew("UIListLayout", esp.holder["LeftFlags"]["LeftFlagsTwo"])
       listLayout2.Padding = UDimnew(0, 10)
       listLayout2.FillDirection = "Vertical"
       listLayout2.HorizontalAlignment = "Left"
       listLayout2.HorizontalFlex = "None"
       listLayout2.VerticalAlignment = "Top"
       listLayout2.ItemLineAlignment = "Start"

       DrawFrame({
            Name = "HealthBar",
            Parent = esp.holder["LeftFlags"],
            Color = fromRGB(0, 0, 0),
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Position = UDim2new(0.17, 0, 0.12, 0),
            Size = UDim2new(0.65, 0, 0.88, 0),
            Zindex = 9999999999,
            Rotation = 0,
            AnchorPoint = vector2New(.5, 0),
       })
       
       DrawFrame({
            Name = "Bar",
            Parent = esp.holder["LeftFlags"]["HealthBar"],
            Color = fromRGB(255, 255, 255),
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Position = UDim2new(0, 0, 1, 0),
            Size = UDim2new(1, 0, 1, 0),
            Zindex = 9999999999,
            Rotation = 0,
            AnchorPoint = vector2New(0, 1)
       })
       
       DrawFrame({
            Name = "HealthText",
            Parent = esp.holder["LeftFlags"]["HealthBar"],
            Color = fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2new(0, 0, 0, 0),
            Size = UDim2new(1, 0, 1, 0),
            Zindex = 9999999999,
            Rotation = 0,
            AnchorPoint = vector2New(0, 0)
       })

       DrawText({
          Name = "healthValue", 
          Parent = esp.holder["LeftFlags"]["HealthBar"]["HealthText"],
          TextSize = 10,
          AnchorPoint = vector2New(0, 0),
          Size = UDim2.new(1, 0, 0, 0)
       })

       local HealthTextPadding = Instancenew("UIPadding", esp.holder["LeftFlags"]["HealthBar"]["HealthText"]["healthValue"])
       HealthTextPadding.PaddingBottom = UDimnew(.3, 0)
       HealthTextPadding.PaddingLeft = UDimnew(0, -22)
       
       local healthBarStroke = DrawUIStroke({Parent = esp.holder["LeftFlags"]["HealthBar"]})
       healthBarStroke.LineJoinMode = "Miter"
       
       DrawGradient({
          Parent = esp.holder["LeftFlags"]["HealthBar"]["Bar"],
          Rotation = -90,
          Color = ColorSequence.new{ColorSequenceKeypoint.new(0, fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, fromRGB(255, 255, 255))}
       })
     end

     do -- Right Flags
      DrawFrame({
        Name = "RightFlags",
        Parent = esp.holder,
        Color = fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2new(0, 632, 0, 569),
        Size = UDim2new({0.062, 0},{0.126, 0}),
        Zindex = 9999999999,
        Rotation = 0,
        AnchorPoint = vector2New(0, 0)
       })

       DrawFrame({
        Name = "RightFlagsTwo",
        Parent = esp.holder["RightFlags"],
        Color = fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2new(0, 632, 0, 569),
        Size = UDim2new({0.062, 0},{0, 0}),
        Zindex = 9999999999,
        Rotation = 0,
        AnchorPoint = vector2New(0, 0)
       })
	   
       
       local listLayout = Instancenew("UIListLayout", esp.holder["RightFlags"])
       listLayout.Padding = UDimnew(0, -2)
       listLayout.FillDirection = "Horizontal"
       listLayout.HorizontalAlignment = "Right"
       listLayout.HorizontalFlex = "None"
       listLayout.VerticalAlignment = "Top"
       listLayout.ItemLineAlignment = "Start"
       
       local listLayout2 = Instancenew("UIListLayout", esp.holder["RightFlags"]["RightFlagsTwo"])
       listLayout2.Padding = UDimnew(-1, 0)
       listLayout2.FillDirection = "Vertical"
       listLayout2.HorizontalAlignment = "Left"
       listLayout2.HorizontalFlex = "None"
       listLayout2.VerticalAlignment = "Top"
       listLayout2.ItemLineAlignment = "Start"
       
       DrawText({
          Name = "AimingText", 
          Parent = esp.holder["RightFlags"]["RightFlagsTwo"],
          TextSize = 10,
          AnchorPoint = vector2New(0, 0)
       })
       
       DrawText({
          Name = "InventoryText", 
          Parent = esp.holder["RightFlags"]["RightFlagsTwo"],
          TextSize = 10,
          AnchorPoint = vector2New(0, 0)
       })

	   local AimTextPadding = Instancenew("UIPadding", esp.holder["RightFlags"]["RightFlagsTwo"]["AimingText"])
       AimTextPadding.PaddingTop = UDimnew(0, -3)
	   AimTextPadding.PaddingLeft = UDimnew(0, -2)


       local InventoryTextPadding = Instancenew("UIPadding", esp.holder["RightFlags"]["RightFlagsTwo"]["InventoryText"])
       InventoryTextPadding.PaddingTop = UDimnew(0, -1)
       InventoryTextPadding.PaddingLeft = UDimnew(0, -1)
     end
     
     local colorStroke, outerStroke, innerStroke = DrawUIStroke({Parent = esp.holder["Box"]}), DrawUIStroke({Parent = esp.holder["Box"]}), DrawUIStroke({Parent = esp.holder["Box"]})
     esp.itemCache = {}
     esp.UI = {
        GUI = esp.holder;
        PName = esp.holder["PNameText"]["PName"];
        Distance = esp.holder["BottomFlags"]["DistanceText"]["distanceValue"];
        VisFlag = esp.holder["BottomFlags"]["VisFlagText"]["visValue"];
        Weapon = esp.holder["BottomFlags"]["WeaponText"]["weaponValue"];
        HealthTextHolder = esp.holder["LeftFlags"]["HealthBar"]["HealthText"];
        HealthText = esp.holder["LeftFlags"]["HealthBar"]["HealthText"]["healthValue"];
        ManipFlag = esp.holder["BottomFlags"]["ManipFlagText"]["manipValue"];

        BottomFlags = esp.holder["BottomFlags"];
        LeftFlags = esp.holder["LeftFlags"];
        LeftFlagsTwo = esp.holder["LeftFlags"]["LeftFlagsTwo"];
        RightFlags = esp.holder["RightFlags"];

        bottomListLayout = esp.holder["BottomFlags"]["UIListLayout"];
        leftListLayout = esp.holder["LeftFlags"]["UIListLayout"];
        HealthTextPadding = esp.holder["LeftFlags"]["HealthBar"]["HealthText"]["healthValue"]["UIPadding"];
		

        AimingText = esp.holder["RightFlags"]["RightFlagsTwo"]["AimingText"];
        InventoryText = esp.holder["RightFlags"]["RightFlagsTwo"]["InventoryText"];
        
        Box = esp.holder["Box"];
        BoxFill = esp.holder["Box"]["BoxFill"];
		BoxFillGradient = esp.holder["Box"]["BoxFill"]["UIGradient"];

        HealthBar = esp.holder["LeftFlags"]["HealthBar"];
        Bar = esp.holder["LeftFlags"]["HealthBar"]["Bar"];
        BarGradient = esp.holder["LeftFlags"]["HealthBar"]["Bar"]["UIGradient"];
     }
     

	 esp.UI.PName.AutomaticSize = Enum.AutomaticSize.Y
	 esp.UI.PName.FontFace = Fonts["ProggyTiny"]
	 esp.UI.PName.TextSize = 9
     

     esp.UI.AimingText.Text = "Aiming"
	 esp.UI.AimingText.FontFace = Fonts["SmallestPixel"]
	 esp.UI.AimingText.TextSize = 9


     esp.UI.InventoryText.Text = "Searching"
	 esp.UI.InventoryText.FontFace = Fonts["SmallestPixel"]
	 esp.UI.InventoryText.TextSize = 9


	 esp.UI.AimingText.AutomaticSize = Enum.AutomaticSize.XY
	 esp.UI.InventoryText.AutomaticSize = Enum.AutomaticSize.XY


     esp.UI.Distance.LayoutOrder = 1
	 esp.UI.Distance.TextSize = 12
     esp.UI.Weapon.LayoutOrder = 2


	 esp.UI.VisFlag.Text = "Visible"
     esp.UI.VisFlag.LayoutOrder = 3
	 esp.UI.VisFlag.FontFace = Fonts["ProggyTiny"]
	 esp.UI.VisFlag.TextSize = 9
	

	 esp.UI.Weapon.FontFace = Fonts["ProggyTiny"]
	 esp.UI.Weapon.TextSize = 9


	 esp.UI.Distance.FontFace = Fonts["ProggyTiny"]
	 esp.UI.Distance.TextSize = 9

     
     esp.UI.ManipFlag.Visible = false
	 esp.UI.HealthText.FontFace = Fonts["ProggyTiny"]
	 esp.UI.HealthText.TextSize = 9

     local colorStroke = Instancenew("UIStroke", esp.UI.Box)
	 colorStroke.ApplyStrokeMode = "Contextual"
     colorStroke.StrokeSizingMode = "FixedSize"
	 colorStroke.LineJoinMode = "Miter"
	 colorStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	 colorStroke.ZIndex = 1
	 colorStroke.Color = fromRGB(0, 255, 255)

     local outerStroke = Instancenew("UIStroke", esp.UI.Box)
	 outerStroke.ApplyStrokeMode = "Border"
     outerStroke.StrokeSizingMode = "FixedSize"
     outerStroke.LineJoinMode = "Miter"
     outerStroke.BorderStrokePosition = Enum.BorderStrokePosition.Outer
     outerStroke.ZIndex = 0
     
     local innerStroke = Instancenew("UIStroke", esp.UI.Box)
	 innerStroke.ApplyStrokeMode = "Contextual"
     innerStroke.StrokeSizingMode = "FixedSize"
     innerStroke.LineJoinMode = "Miter"
     innerStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
     innerStroke.ZIndex = 0
     innerStroke.Thickness = 2

     esp.UI.topColor = colorStroke
     esp.UI.outerStroke = outerStroke
     esp.UI.innerStroke = innerStroke

     esp.UI.BoxFill.Transparency = 0

     local Character = self.Character
     esp.root, esp.humanoid, esp.head = Character:WaitForChild("HumanoidRootPart", 60), Character:WaitForChild("Humanoid", 60), Character:WaitForChild("Head", 60)

	 getParts(esp, Character)
     
	 if esp.humanoid ~= nil then
		esp.MaxHealth = esp.humanoid.MaxHealth
	 end
  
  return espCache[self]
end


local function VehicleObject(self)
     vehicleCache[self] = {Name = self.Name, Vehicle = self, holder = Instancenew("Frame", visualHolder), playerVis = false, playerManip = false, partCache = {}, boneCache = {}, chamCache = {}, chamCacheTwo = {}, Colors = Instancenew("Folder"), Borders = Instancenew("Folder"), chamsholder = Instancenew("Folder"), highlight = Instancenew("Highlight", visualHolder), lastRaycast = 0, weapon = nil}
     local esp, player = vehicleCache[self], vehicleCache[self]
     local Colors = esp.Colors
     local Borders = esp.Borders 
     local espholder, cache, chamsholder, esphighlight = esp.holder, esp.cache, esp.chamsholder, esp.highlight
     esp.UI = {}
                
   
     espholder.Name = self.Name
     espholder.Visible = false
   
     chamsholder.Parent = espholder
   
   
     Colors.Parent = espholder
     Borders.Parent = espholder
     Colors.Name = "Colors"
     Borders.Name = "Borders"
     
     
     do -- Bottom Flags & PName
        DrawFrame({
         Name = "BottomFlags",
         Parent = esp.holder,
         Color = fromRGB(255, 255, 255),
         BackgroundTransparency = 1,
         BorderSizePixel = 0,
         Position = UDim2new(0, 632, 0, 569),
         Size = UDim2new({0.062, 0},{0.126, 0}),
         Zindex = 9999999999,
         Rotation = 0,
         AnchorPoint = vector2New(0, 0)
        })

		local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = esp.holder["BottomFlags"]
		listLayout.Padding = UDimnew(0, 1)
   
        -- PName Frame & Text
        DrawFrame({
           Name = "PNameText",
           Parent = esp.holder,
           Color = fromRGB(255, 255, 255),
           BackgroundTransparency = 1,
           BorderSizePixel = 0,
           Position = UDim2new(0, 0, 0, 0),
           Size = UDim2new(1, 0, 0, 0),
           Zindex = 9999999999,
           Rotation = 0,
           AnchorPoint = vector2New(0, 0),
		   AutomaticSize = Enum.AutomaticSize.Y
        })

        DrawText({
           Name = "PName", 
           Parent = esp.holder["PNameText"],
           TextSize = 10,
           AnchorPoint = vector2New(0, 0),
           Size = UDim2.new(1, 0, 0, 0)
        })
   
        -- Distance Frame & Text
        DrawFrame({
           Name = "DistanceText",
           Parent = esp.holder["BottomFlags"],
           Color = fromRGB(255, 255, 255),
           BackgroundTransparency = 1,
           BorderSizePixel = 0,
           Position = UDim2new(0, 0, 0, 0),
           Size = UDim2new(1, 0, 0, 0),
           Zindex = 9999999999,
           Rotation = 0,
           AnchorPoint = vector2New(0, 0),
		   AutomaticSize = Enum.AutomaticSize.Y,
        })

        DrawText({
           Name = "distanceValue", 
           Parent = esp.holder["BottomFlags"]["DistanceText"],
           TextSize = 10,
           AnchorPoint = vector2New(0, 0),
           Size = UDim2.new(1, 0, 0, 0)
        })
   
     end
   

     do -- box
        DrawFrame({
            Name = "Box",
            Parent = esp.holder,
            Color = fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 1,
            Position = UDim2new(0.17, 0, 0.12, 0),
            Size = UDim2new(0.65, 0, 0.88, 0),
            Zindex = 5,
            Rotation = 0,
            AnchorPoint = vector2New(.5, 0),
        })
     end
    
     
     local colorStroke, outerStroke, innerStroke = DrawUIStroke({Parent = esp.holder["Box"]}), DrawUIStroke({Parent = esp.holder["Box"]}), DrawUIStroke({Parent = esp.holder["Box"]})
     esp.itemCache = {}
     esp.UI = {
        GUI = esp.holder;

        PName = esp.holder["PNameText"]["PName"];
        Distance = esp.holder["BottomFlags"]["DistanceText"]["distanceValue"];
        BottomFlags = esp.holder["BottomFlags"];
        bottomListLayout = esp.holder["BottomFlags"]["UIListLayout"];

        Box = esp.holder["Box"];
     }
     

	 esp.UI.PName.AutomaticSize = Enum.AutomaticSize.Y
	 esp.UI.PName.FontFace = Fonts["ProggyTiny"]
	 esp.UI.PName.TextSize = 9
     

     esp.UI.Distance.LayoutOrder = 1
	 esp.UI.Distance.TextSize = 12
	

	 esp.UI.Distance.FontFace = Fonts["ProggyTiny"]
	 esp.UI.Distance.TextSize = 9

    
     local colorStroke = Instancenew("UIStroke", esp.UI.Box)
	 colorStroke.ApplyStrokeMode = "Contextual"
     colorStroke.StrokeSizingMode = "FixedSize"
	 colorStroke.LineJoinMode = "Miter"
	 colorStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	 colorStroke.ZIndex = 1
	 colorStroke.Color = fromRGB(0, 255, 255)

     local outerStroke = Instancenew("UIStroke", esp.UI.Box)
	 outerStroke.ApplyStrokeMode = "Border"
     outerStroke.StrokeSizingMode = "FixedSize"
     outerStroke.LineJoinMode = "Miter"
     outerStroke.BorderStrokePosition = Enum.BorderStrokePosition.Outer
     outerStroke.ZIndex = 0
     
     local innerStroke = Instancenew("UIStroke", esp.UI.Box)
	 innerStroke.ApplyStrokeMode = "Contextual"
     innerStroke.StrokeSizingMode = "FixedSize"
     innerStroke.LineJoinMode = "Miter"
     innerStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
     innerStroke.ZIndex = 0
     innerStroke.Thickness = 2

     esp.UI.topColor = colorStroke
     esp.UI.outerStroke = outerStroke
     esp.UI.innerStroke = innerStroke
     
     
     esp.root = esp.Vehicle:WaitForChild("Base", 60)
  return vehicleCache[self]
end


local function getVis(vis, isVisColor, notVisColor)
  if vis then
    return isVisColor
   else
    return notVisColor
  end
end


local function CorpseObject(self)
     corpseCache[self] = {Name = self.Name, Corpse = self, holder = Instancenew("Frame", visualHolder), playerVis = false, playerManip = false, partCache = {}, boneCache = {}, chamCache = {}, chamCacheTwo = {}, Colors = Instancenew("Folder"), Borders = Instancenew("Folder"), chamsholder = Instancenew("Folder"), highlight = Instancenew("Highlight", visualHolder), lastRaycast = 0, weapon = nil}
     local esp, player = corpseCache[self], corpseCache[self]
     local Colors = esp.Colors
     local Borders = esp.Borders 
     local espholder, cache, chamsholder, esphighlight = esp.holder, esp.cache, esp.chamsholder, esp.highlight
     esp.UI = {}
                
   
     espholder.Name = self.Name
     espholder.Visible = false
   
     chamsholder.Parent = espholder
   
   
     Colors.Parent = espholder
     Borders.Parent = espholder
     Colors.Name = "Colors"
     Borders.Name = "Borders"
     
     
     do -- Bottom Flags & PName
        DrawFrame({
         Name = "BottomFlags",
         Parent = esp.holder,
         Color = fromRGB(255, 255, 255),
         BackgroundTransparency = 1,
         BorderSizePixel = 0,
         Position = UDim2new(0, 632, 0, 569),
         Size = UDim2new({0.062, 0},{0.126, 0}),
         Zindex = 9999999999,
         Rotation = 0,
         AnchorPoint = vector2New(0, 0)
        })

		local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = esp.holder["BottomFlags"]
		listLayout.Padding = UDimnew(0, 1)
   
        -- PName Frame & Text
        DrawFrame({
           Name = "PNameText",
           Parent = esp.holder,
           Color = fromRGB(255, 255, 255),
           BackgroundTransparency = 1,
           BorderSizePixel = 0,
           Position = UDim2new(0, 0, 0, 0),
           Size = UDim2new(1, 0, 0, 0),
           Zindex = 9999999999,
           Rotation = 0,
           AnchorPoint = vector2New(0, 0),
		   AutomaticSize = Enum.AutomaticSize.Y
        })

        DrawText({
           Name = "PName", 
           Parent = esp.holder["PNameText"],
           TextSize = 10,
           AnchorPoint = vector2New(0, 0),
           Size = UDim2.new(1, 0, 0, 0)
        })
   
        -- Distance Frame & Text
        DrawFrame({
           Name = "DistanceText",
           Parent = esp.holder["BottomFlags"],
           Color = fromRGB(255, 255, 255),
           BackgroundTransparency = 1,
           BorderSizePixel = 0,
           Position = UDim2new(0, 0, 0, 0),
           Size = UDim2new(1, 0, 0, 0),
           Zindex = 9999999999,
           Rotation = 0,
           AnchorPoint = vector2New(0, 0),
		   AutomaticSize = Enum.AutomaticSize.Y,
        })

        DrawText({
           Name = "distanceValue", 
           Parent = esp.holder["BottomFlags"]["DistanceText"],
           TextSize = 10,
           AnchorPoint = vector2New(0, 0),
           Size = UDim2.new(1, 0, 0, 0)
        })
   
     end
   

     do -- box
        DrawFrame({
            Name = "Box",
            Parent = esp.holder,
            Color = fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 1,
            Position = UDim2new(0.17, 0, 0.12, 0),
            Size = UDim2new(0.65, 0, 0.88, 0),
            Zindex = 5,
            Rotation = 0,
            AnchorPoint = vector2New(.5, 0),
        })
     end
    
     
     local colorStroke, outerStroke, innerStroke = DrawUIStroke({Parent = esp.holder["Box"]}), DrawUIStroke({Parent = esp.holder["Box"]}), DrawUIStroke({Parent = esp.holder["Box"]})
     esp.itemCache = {}
     esp.UI = {
        GUI = esp.holder;

        PName = esp.holder["PNameText"]["PName"];
        Distance = esp.holder["BottomFlags"]["DistanceText"]["distanceValue"];
        BottomFlags = esp.holder["BottomFlags"];
        bottomListLayout = esp.holder["BottomFlags"]["UIListLayout"];

        Box = esp.holder["Box"];
     }
     

	 esp.UI.PName.AutomaticSize = Enum.AutomaticSize.Y
	 esp.UI.PName.FontFace = Fonts["ProggyTiny"]
	 esp.UI.PName.TextSize = 9
     

     esp.UI.Distance.LayoutOrder = 1
	 esp.UI.Distance.TextSize = 12
	

	 esp.UI.Distance.FontFace = Fonts["ProggyTiny"]
	 esp.UI.Distance.TextSize = 9

    
     local colorStroke = Instancenew("UIStroke", esp.UI.Box)
	 colorStroke.ApplyStrokeMode = "Contextual"
     colorStroke.StrokeSizingMode = "FixedSize"
	 colorStroke.LineJoinMode = "Miter"
	 colorStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	 colorStroke.ZIndex = 1
	 colorStroke.Color = fromRGB(0, 255, 255)

     local outerStroke = Instancenew("UIStroke", esp.UI.Box)
	 outerStroke.ApplyStrokeMode = "Border"
     outerStroke.StrokeSizingMode = "FixedSize"
     outerStroke.LineJoinMode = "Miter"
     outerStroke.BorderStrokePosition = Enum.BorderStrokePosition.Outer
     outerStroke.ZIndex = 0
     
     local innerStroke = Instancenew("UIStroke", esp.UI.Box)
	 innerStroke.ApplyStrokeMode = "Contextual"
     innerStroke.StrokeSizingMode = "FixedSize"
     innerStroke.LineJoinMode = "Miter"
     innerStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
     innerStroke.ZIndex = 0
     innerStroke.Thickness = 2

     esp.UI.topColor = colorStroke
     esp.UI.outerStroke = outerStroke
     esp.UI.innerStroke = innerStroke
  

  return corpseCache[self]
end


local function destroyESP(cache, value)
  if cache[value] then
    cache[value].holder:Destroy()
	cache[value].chamCache:Destroy()
	for _, tble in cache[value] do
	  if type(tble) == "table" then
		tble = nil
	  end
	end
    cache[value] = nil
  end
end


local function createESP(Player)
  if Player.Character then
  	task.defer(PlayerObject, Player)
  end
  
  Player.CharacterAdded:Connect(function(Character)
    task.defer(PlayerObject, Player)
  end)
    
  Player.CharacterRemoving:Connect(function(Character)
    task.defer(destroyESP, vehicleCache, Player)
  end)
end


function ESP.loadESP()
  Players.PlayerAdded:Connect(createESP)
  Players.PlayerRemoving:Connect(function(player)
	destroyESP(espCache, player)
  end)

  for _, player in Players:GetPlayers() do
    --if player.Name ~= Players.LocalPlayer.Name then
      task.defer(createESP, player)
    --end
  end
  

  Vehicles.ChildAdded:Connect(VehicleObject)
  Vehicles.ChildRemoved:Connect(function(vehicle)
	destroyESP(vehicleCache, destroyESP)
  end)

  for _, vehicle in Vehicles:GetChildren() do
    VehicleObject(vehicle)
  end


  Corpses.ChildAdded:Connect(CorpseObject)
  Corpses.ChildRemoved:Connect(function(Corpse)
	destroyESP(corpseCache, Corpse)
  end)

  for _, corpse in Corpses:GetChildren() do
    CorpseObject(corpse)
  end

  renderESP()
end
ESP.loadESP()


--return library, themes, ESP, espConnection, espCache
