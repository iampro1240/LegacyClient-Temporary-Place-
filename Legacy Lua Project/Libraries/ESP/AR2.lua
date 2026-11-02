local getService, getFunction, w, deepCopy, Variables, Math, FindFirstChild, FindFirstChildOfClass, wtvpp = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampro1240/LegacyClient-Temporary-Place-/refs/heads/main/Legacy%20Lua%20Project/Libraries/Services.lua"))()
local espConnection
local getGCFunction = function(funcName)
  local Func = filtergc("function", {Name = funcName, IgnoreExecutor = false}, true)
    if Func ~= nil then
      return Func
     else
     warn("Can Not Be Found!")
     return function() return end
  end
end


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
local itemCache = {}


local rayOrigin


local currentCamera = workspace.CurrentCamera
local Raycast = Workspace.Raycast
local WorldToViewportPoint = currentCamera.WorldToViewportPoint
local viewportSize = currentCamera.ViewportSize


local typeOf = typeof
local clock = os.clock
local stringformat = string.format
local currentClock = clock()


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
local Raycast = Workspace.Raycast
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


local function renderESP(flags)
    local visParams = RaycastParams.new()
    visParams.FilterType = Enum.RaycastFilterType.Exclude
    visParams.IgnoreWater = false
    visParams.CollisionGroup = "Default"
    
    
    local accumulatedTime = 0
  	local accumulatedTime2 = 0
  	local accumulatedTime3 = 0
    local accumulatedTime4 = 0
  
    local TARGET_INTERVAL = 1 / 60
  	local TARGET_INTERVAL2 = 1 / 40

    local fontSettings = ESP.fontSettings
	  local healthBarSettings = ESP.healthBarSettings
    
    local getVisFunc = getVis
    local filterTable = {}
	

    runService.PreRender:Connect(function(deltatime)
        accumulatedTime += deltatime
        if accumulatedTime < TARGET_INTERVAL then
            return
        end
        accumulatedTime -= TARGET_INTERVAL
		    
        
    		local isEnableAll = flags["EnableAll"]
    		local localCharacter = LocalPlayer.Character
        
		
       	do --// Player
       	  local currentTextFont, flagFont = flags["TextFont"], flags["TextFlagFont"]
       	  local textFont, flagTextFont = Fonts[currentTextFont], Fonts[flagFont]
       	  
          
		      if not isEnableAll or not localCharacter then
              for _, player in espCache do
                  if player.holder then
                      player.holder.Visible = false
                  end
                  if player.chamCache then
                      for _, cham in player.chamCache do
                          cham.Visible = false
                      end
                  end
              end
            return
          end
          
          
		      local charFind = localCharacter.FindFirstChild
       	  local rayOriginPart = localCharacter.PrimaryPart and localCharacter.Head
       	  if not rayOriginPart then return end
       	  local cColor, ChamGlowMultiplier = flags["Box_Cham_Color"].Color, flags["ChamGlowMultiplier"]
          
          
          for _, player in espCache do
            local esp, UI, chamCache = player.holder, player.UI, player.chamCache
            local actualPlayer = player.Player
            local character = player.Character
            local espVisible = esp.Visible


            if not character then
              esp.Visible = false
					    for _, cham in chamCache do
					      cham.Visible = false
              end
              continue
            end


				    local root = character.PrimaryPart
				    if not root then
              esp.Visible = false
              for _, cham in chamCache do
                cham.Visible = false
              end
              continue
            end


            local rootPos = root.Position
            local distancemag = round((rootPos - currentCamera.CFrame.Position).Magnitude)


            local pos2, isRootVis = WorldToViewportPoint(currentCamera, rootPos)
            if not isRootVis or distancemag >= flags["MaxDistance"] then
              esp.Visible = false
              for _, cham in chamCache do
                cham.Visible = false
              end
              continue
            end
            
            
            local head, humanoid, equipped, animator = character.Head, character.Humanoid, character.Equipped, character.Animator
            if not head or not root or not humanoid or not equipped or not animator or humanoid and humanoid.Health <= 0 then
              esp.Visible = false
              for _, cham in chamCache do
                 cham.Visible = false
              end
             continue
            end
            esp.Visible = true
            
            
            local nameText, distanceText, weaponText = UI.PName, UI.Distance, UI.Weapon
            local healthFlagHolder = UI.HealthTextHolder
            local visFlag, healthFlag, aimingFlag, inventoryFlag = UI.VisFlag, UI.HealthText, UI.AimingText, UI.InventoryText
            
            
            local box, boxFill, BoxFillGradient, boxStrokeColor = UI.Box, UI.BoxFill, UI.BoxFillGradient, UI.topColor
            local healthBar, bar, barGradient = UI.HealthBar, UI.Bar, UI.BarGradient
				    local leftFlags, rightFlags = UI.LeftFlags, UI.RightFlags
            local paddingSettings = healthBarSettings[flags["HealthBarPadding"]]
            
            
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
            local aimingStroke, inventoryStroke = aimingFlag["UIStroke"], inventoryFlag["UIStroke"]
            
            
            nameText.Parent.Visible = flags["Names"]
            if flags["Names"] then
             nameText.Position = fromOffset(centerX, posClamp - 11)
             nameText.TextColor3 = flags["Name_Color"].Color
             nameText.Text = flags["UseDisplayName"] and actualPlayer.DisplayName or actualPlayer.Name
            end
            
            
            distanceText.Visible = flags["Distance"]
            if flags["Distance"] then
             distanceText.Text = distancemag .. flags["DistanceType"]
             distanceText.TextColor3 = flags["Distance_Color"].Color
            end
            
            
            weaponText.Visible = flags["Weapon"]
            if flags["Weapon"] then
             local weapon = equipped:FindFirstChildOfClass("Model")
             weaponText.TextColor3 = flags["Weapon_Color"].Color
             weaponText.Text = weapon and weapon.Name or "Hands"
            end
            
            
            visFlag.Visible = flags["Vis"]
            if flags["Vis"] then
             if (os.clock() - player.lastRaycast) > .5 then
               player.lastRaycast = os.clock()
                         
               filterTable[1] = localCharacter
               filterTable[2] = rayOriginPart
               filterTable[3] = character
               visParams.FilterDescendantsInstances = filterTable
                         
               local visCheck = Raycast(Workspace, rayOriginPart.Position, head.Position - rayOriginPart.Position, visParams)
               player.playerVis = not visCheck or visCheck.Instance == head or visCheck.Instance.Parent == character
             end
             visFlag.TextColor3 = getVisFunc(player.playerVis, flags["Vis_Color"].Color, flags["Not_Vis_Color"].Color)
            end
            
            
            aimingFlag.Visible = flags["AimingText"]
            if flags["AimingText"] then
             aimingFlag.TextColor3 = getVisFunc(animator.Zooming.Value, flags["Aiming_Color"].Color, flags["Not_Aiming_Color"].Color)
             aimingFlag.Transparency = cutOff
             if aimingStroke then
               aimingStroke.Transparency = cutOff
 					   end
            end
            
            
            inventoryFlag.Visible = flags["InventoryText"]
            if flags["InventoryText"] then
             inventoryFlag.TextColor3 = getVisFunc(animator.InventorySearch.Value, flags["Inventory_Color"].Color, flags["Not_Inventory_Color"].Color)
             inventoryFlag.Transparency = cutOff
             if inventoryStroke then
               inventoryStroke.Transparency = cutOff
             end
            end
            
            
            box.Visible = flags["Boxes"]
            if flags["Boxes"] then
             box.Position = UDim2new(0, centerX, 0, posClamp)
             box.Size = UDim2new(0, boxTotalWidth, 0, boxYSize)

             UI.colorGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, flags["boxColor1"].Color), ColorSequenceKeypoint.new(1, flags["boxColor2"].Color)}
             UI.colorGradient.Rotation = flags["boxColorRotation"]
             boxFill.Visible = flags["BoxFill"]
             if flags["BoxFill"] then
               BoxFillGradient.Color = ColorSequencenew{ColorSequenceKeypointnew(0, flags["Box_Fill_Color"].Color), ColorSequenceKeypointnew(1, flags["Box_Fill_Color_Two"].Color)}
               BoxFillGradient.Transparency = NumberSequencenew{NumberSequenceKeypointnew(0, flags["Box_Fill_Color"].Transparency), NumberSequenceKeypointnew(1, flags["Box_Fill_Color_Two"].Transparency)}
               BoxFillGradient.Rotation = flags["FillRotation"]
             end
            end
            
            
            healthBar.Visible = flags["Healthbar"]
            if flags["Healthbar"] then
             leftFlags.Position = fromOffset(boxLeftX - paddingSettings.Padding, posClamp)
             leftFlags.Size = fromOffset(-1, boxYSize)

             local maxHP = player.MaxHealth
             player.MaxHealth = maxHP + (humanoid.Health - maxHP) * clamp(flags["healthBarSpeed"] * 10 * deltatime, 0, 1)
             local maxHealth = humanoid.MaxHealth > 0 and maxHP or 100
             local healthPercent = clamp(maxHP / maxHealth, 0, 1)
        				
             healthBar.Size = UDim2new(0, paddingSettings.Size, 0, boxYSize)
             bar.Size = UDim2new(1, 0, healthPercent, 0)
             barGradient.Color = ColorSequencenew{ColorSequenceKeypointnew(0, flags["GradientColor2"].Color), ColorSequenceKeypointnew(1, flags["GradientColor1"].Color)}
        				
             healthFlag.Position = UDim2new(0, 0, 1 - healthPercent, 0)
             healthFlag.TextColor3 = flags["Health_Text_Color"].Color:Lerp(flags["Low_Health_Text_Color"].Color, 1 - healthPercent)


             healthFlagHolder.Visible = flags["HealthText"]
             if flags["HealthText"] then
              healthFlag.TextColor3 = flags["Health_Text_Color"].Color
              healthFlag.Text = floor(humanoid.Health)
             end
             
            end
            
            
            for _, cham in chamCache do
             cham.Visible = flags["BoxChams"]
             cham.Color3 = Color3new(cColor.R * ChamGlowMultiplier, cColor.G * ChamGlowMultiplier, cColor.B * ChamGlowMultiplier)
            end
 				    
            
            rightFlags.Position = fromOffset(boxLeftX + boxTotalWidth + paddingSettings.Padding, posClamp)
            rightFlags.Size = fromOffset(1, boxYSize)
            UI.BottomFlags.Position = fromOffset(centerX, floor(posClamp + boxYSize + 2))
            
          end

       	end
        
    end)
    
    
  	runService.PreRender:Connect(function(deltatime)
     accumulatedTime2 += deltatime
     if accumulatedTime2 < TARGET_INTERVAL2 then
       return
     end
     accumulatedTime2 -= TARGET_INTERVAL2
 		
 		 local localCharacter = LocalPlayer.Character
     do --// Vehicle
     		
       for _, vehicle in vehicleCache do
         local esp, UI, chamCache = vehicle.holder, vehicle.UI, vehicle.chamCache
         local vehicleModel = vehicle.Vehicle
 
 				
         if not flags["vehicleEnableAll"] or not localCharacter then
           esp.Visible = false
           continue
 				end
 
 
 				local nameText, distanceText = UI.PName, UI.Distance  
         local box, boxStrokeColor = UI.Box, UI.topColor
 				
     			
         if not vehicleModel then
            esp.Visible = false
          continue
         end
     		
                
 				local getBoundingBox = vehicleModel.GetBoundingBox
 				local boxCFrame, boxSize = getBoundingBox(vehicleModel)
 
                 
         local centerPos = boxCFrame.Position
         local distancemag = floor((centerPos - currentCamera.CFrame.Position).Magnitude)
 			  
         
 				local center2D, isRootVis = WorldToViewportPoint(currentCamera, centerPos)
         if not isRootVis or distancemag >= flags["VehicleMaxDistance"] then
           esp.Visible = false
           continue
         end
         esp.Visible = true
                
         
         local offsetVector = vectorcreate(0, boxSize.Y * .5, 0)
         local top2D = WorldToViewportPoint(currentCamera, centerPos + offsetVector)
         local bottom2D = WorldToViewportPoint(currentCamera, centerPos - offsetVector)
                 
 
         local height = (bottom2D.Y - top2D.Y)
         local maxHorizontal = mathmax(boxSize.X, boxSize.Z)
                 
 
         local safeY = mathmax(boxSize.Y, 0.001)
         local width = height * (maxHorizontal / safeY)
                 
 
         local centerX = center2D.X
         local centerY = center2D.Y
                 
 
         local boxYSize = height * 1.16 + 7
         local boxTotalWidth = floor(width * 1.16 + 7)
         local halfBoxWidth = floor(boxTotalWidth * 0.5)
         local halfBoxHeight = floor(boxYSize * 0.5)
         local posClamp = floor(centerY - halfBoxHeight)
 				
                 
         nameText.Visible = flags["VehicleNames"]
         if flags["VehicleNames"] then
           nameText.Position = fromOffset(centerX, posClamp - 11)
           nameText.TextColor3 = flags["Vehicle_Name_Color"].Color
           nameText.Text = vehicleModel.Name
         end
                
         
         distanceText.Visible = flags["VehicleDistance"]
         if flags["VehicleDistance"] then
           distanceText.Text = distancemag .. flags["VehicleDistanceType"]
           distanceText.TextColor3 = flags["Vehicle_Distance_Color"].Color
         end
                
         
         box.Visible = flags["VehicleBoxes"]
         if flags["VehicleBoxes"] then
           box.Position = UDim2new(0, centerX, 0, posClamp)
           box.Size = UDim2new(0, boxTotalWidth, 0, boxYSize)
           boxStrokeColor.Color = flags["Vehicle_Box_Color"].Color
         end
 
 
 				UI.BottomFlags.Position = fromOffset(centerX, floor(posClamp + boxYSize + 2))
       end
     	
       end
 		
         
    
    end)
    
    
  	runService.PreRender:Connect(function(deltatime)
      accumulatedTime3 += deltatime
      if accumulatedTime3 < TARGET_INTERVAL2 then
       return
      end
      accumulatedTime3 -= TARGET_INTERVAL2
 
 
      local isEnableAll = flags["EnableAll"]
      local cameraPos = currentCamera.CFrame.Position
      local localCharacter = LocalPlayer.Character
 
 
   	 if not isEnableAll or not localCharacter then
        for _, player in espCache do
          player.holder.Visible = false
  
  			  for _, cham in player.chamCache do
  			    cham.Visible = false
  			  end
        end
     end 
         
 
  	 do --// Corpse
      		
      for _, corpse in corpseCache do
          local esp, UI, chamCache = corpse.holder, corpse.UI, corpse.chamCache
          local corpseModel = corpse.Corpse
  
                  
  				if not flags["corpseEnableAll"] or not localCharacter then
            esp.Visible = false
            continue
          end
  
  
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
  				
  
  				local center2D, isRootVis = WorldToViewportPoint(currentCamera, centerPos - vectorcreate(0, .5))
          if not isRootVis or distancemag >= flags["CorpseMaxDistance"] then
             esp.Visible = false
             continue
          end
          esp.Visible = true
                  
            
          local offsetVector = vectorcreate(0, boxSize.Y / 5, 0)
          local top2D = WorldToViewportPoint(currentCamera, centerPos + offsetVector)
          local bottom2D = WorldToViewportPoint(currentCamera, centerPos - offsetVector)
          local height = (bottom2D.Y - top2D.Y)
            

          local maxHorizontal = mathmax(boxSize.X + 3, boxSize.Z + 3)
          local safeY = mathmax(boxSize.Y, 0.001)
          local width = height * (maxHorizontal / safeY)
                  

          local centerX = center2D.X
          local centerY = center2D.Y
                  

          local boxYSize = height * 1.16 + 7
          local boxTotalWidth = floor(width * 1.16 + 7)
          local halfBoxWidth = floor(boxTotalWidth * 0.5)
          local halfBoxHeight = floor(boxYSize * 0.5)
          local posClamp = floor(centerY - halfBoxHeight)
                
          
          nameText.Visible = flags["CorpseNames"]
          if flags["CorpseNames"] then
            nameText.Position = fromOffset(centerX, posClamp - 11)
            nameText.TextColor3 = flags["Corpse_Name_Color"].Color
            nameText.Text = corpseModel.Name
          end

          
          distanceText.Visible = flags["CorpseDistance"]
          if flags["CorpseDistance"] then
            distanceText.Text = distancemag .. flags["CorpseDistanceType"]
            distanceText.TextColor3 = flags["Corpse_Distance_Color"].Color
          end


          box.Visible = flags["CorpseBoxes"]
          if flags["CorpseBoxes"] then
            box.Position = UDim2new(0, centerX, 0, posClamp)
            box.Size = UDim2new(0, boxTotalWidth, 0, boxYSize)
            boxStrokeColor.Color = flags["Corpse_Box_Color"].Color
          end
  				     
          
          UI.BottomFlags.Position = fromOffset(centerX, floor(posClamp + boxYSize + 2))
      end
  
     end
 
    end)


    runService.PreRender:Connect(function(deltatime)
      accumulatedTime4 += deltatime
      if accumulatedTime4 < TARGET_INTERVAL2 then
       return
      end
      accumulatedTime4 -= TARGET_INTERVAL2
 
 
      local isEnableAll = flags["EnableAll"]
      local cameraPos = currentCamera.CFrame.Position
      local localCharacter = LocalPlayer.Character
 
 
   	 if not isEnableAll or not localCharacter then
        for _, player in espCache do
          player.holder.Visible = false
  
  			  for _, cham in player.chamCache do
  			    cham.Visible = false
  			  end
        end
     end 
         
 
  	 do --// Item
      		
      for _, corpse in itemCache do
          local esp, UI, chamCache = corpse.holder, corpse.UI, corpse.chamCache
          local corpseModel = corpse.Corpse
  
                  
  				if not flags["itemEnableAll"] or not localCharacter then
            esp.Visible = false
            continue
          end
  
  
  				local nameText, distanceText = UI.PName, UI.Distance
          if not corpseModel then
            esp.Visible = false
           continue
      		end
                
          
          local part = corpseModel:FindFirstChildOfClass("Model")
          if not part or not part and not part.PrimaryPart then
            esp.Visible = false
           continue
          end

          
  				local boxCFrame, boxSize = part.PrimaryPart.CFrame, part.PrimaryPart.Size
          --part.PrimaryPart.CFrame, part.PrimaryPart.Size
                 
          
          local centerPos = boxCFrame.Position
          local distancemag = floor((centerPos - cameraPos).Magnitude)
  

  				local center2D, isRootVis = WorldToViewportPoint(currentCamera, centerPos - vectorcreate(0, .5))
          if not isRootVis or distancemag >= flags["ItemMaxDistance"] then
             esp.Visible = false
             continue
          end
          esp.Visible = true
                  
            
          local offsetVector = vectorcreate(0, boxSize.Y, 0)
          local top2D = WorldToViewportPoint(currentCamera, centerPos + offsetVector)
          local bottom2D = WorldToViewportPoint(currentCamera, centerPos - offsetVector)
          local height = (bottom2D.Y - top2D.Y)
            

          local maxHorizontal = mathmax(boxSize.X + 3, boxSize.Z + 3)
          local safeY = mathmax(boxSize.Y, 0.001)
          local width = height * (maxHorizontal / safeY)
                  

          local centerX = center2D.X
          local centerY = center2D.Y
                  

          local boxYSize = height * 1.16 + 5
          local boxTotalWidth = floor(width * 1.16 + 5)
          local halfBoxWidth = floor(boxTotalWidth * 0.5)
          local halfBoxHeight = floor(boxYSize * 0.5)
          local posClamp = floor(centerY - halfBoxHeight)
          local info = corpse.info
                
          
          nameText.Visible = flags["ItemNames"]
          if flags["ItemNames"] then
            nameText.Position = fromOffset(centerX, posClamp - 1)
            nameText.TextColor3 = flags["Item_Name_Color"].Color
            if info.Type == "Ammo" then
              nameText.Text = string.format("%s (Capacity: %s, Caliber: %s)", info.DisplayName, info.Capacity, info.Caliber)
             else
              nameText.Text = info.DisplayName
            end
          end

          
          distanceText.Visible = flags["ItemDistance"]
          if flags["ItemDistance"] then
            distanceText.Text = distancemag .. flags["ItemDistanceType"]
            distanceText.TextColor3 = flags["Item_Distance_Color"].Color
          end
         
          
          UI.BottomFlags.Position = fromOffset(centerX, floor(posClamp + boxYSize / 2))
      end
  
     end
 
    end)

end


local function destroyESP(cache, value)
  if cache[value] then
    cache[value].holder:Destroy()
  
  	for _, cham in cache[value].chamCache do
  	  cham:Destroy()
  	end

  	for _, tble in cache[value] do
  	  if type(tble) == "table" then
  		tble = nil
  	  end
  	end
    cache[value] = nil
  end
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
            Size = UDim2new(0.062, 0, 0.126, 0),
            Zindex = 9999999999,
            Rotation = 0,
            AnchorPoint = vector2New(0, 0)
        })
        
        -- Text Elements (Directly inside BottomFlags)
        DrawText({
            Name = "PName", 
            Parent = esp.holder,
            TextSize = 10,
            AnchorPoint = vector2New(0, 0)
        })
         
        DrawText({
            Name = "distanceValue", 
            Parent = esp.holder["BottomFlags"],
            TextSize = 10,
            AnchorPoint = vector2New(0, 0),
            Size = UDim2.new(1, 0, 0, 0),
            LayoutOrder = 2
        })
        
        DrawText({
            Name = "weaponValue", 
            Parent = esp.holder["BottomFlags"],
            TextSize = 10,
            AnchorPoint = vector2New(0, 0),
            Size = UDim2.new(1, 0, 0, 0),
            LayoutOrder = 3
        })
        
        DrawText({
            Name = "visValue", 
            Parent = esp.holder["BottomFlags"],
            TextSize = 10,
            AnchorPoint = vector2New(0, 0),
            Size = UDim2.new(1, 0, 0, 0),
            LayoutOrder = 4
        })
        
        DrawText({
            Name = "manipValue", 
            Parent = esp.holder["BottomFlags"],
            TextSize = 10,
            AnchorPoint = vector2New(0, 0),
            Size = UDim2.new(1, 0, 0, 0),
            LayoutOrder = 5
        })
        
        -- Layout and Padding Configuration
        local listLayout = Instance.new("UIListLayout", esp.holder["BottomFlags"])
        listLayout.Padding = UDim.new(0, 1)
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.ItemLineAlignment = Enum.ItemLineAlignment.Center
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
       
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


     esp.itemCache = {}
     esp.UI = {
        GUI = esp.holder;
        PName = esp.holder["PName"];
        Distance = esp.holder["BottomFlags"]["distanceValue"];
        VisFlag = esp.holder["BottomFlags"]["visValue"];
        Weapon = esp.holder["BottomFlags"]["weaponValue"];
        HealthTextHolder = esp.holder["LeftFlags"]["HealthBar"]["HealthText"];
        HealthText = esp.holder["LeftFlags"]["HealthBar"]["HealthText"]["healthValue"];
        ManipFlag = esp.holder["BottomFlags"]["manipValue"];

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
  	 esp.UI.Distance.LayoutOrder = 1
     
     
     esp.UI.ManipFlag.Visible = false
	   esp.UI.HealthText.FontFace = Fonts["ProggyTiny"]
	   esp.UI.HealthText.TextSize = 9

     local colorStroke = Instancenew("UIStroke", esp.UI.Box)
	   colorStroke.ApplyStrokeMode = "Contextual"
     colorStroke.StrokeSizingMode = "FixedSize"
	   colorStroke.LineJoinMode = "Miter"
	   colorStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	   colorStroke.ZIndex = 1
	   colorStroke.Color = fromRGB(255, 255, 255)

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
     
     local colorGradient = DrawGradient({Parent = colorStroke, Rotation = 0, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, fromRGB(255, 255, 255))}, Transparency = 0})

     esp.UI.topColor = colorStroke
     esp.UI.outerStroke = outerStroke
     esp.UI.innerStroke = innerStroke
     esp.UI.colorGradient = colorGradient

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


local function ItemObject(self, config)
     itemCache[self] = {Name = self.Name, Corpse = self, holder = Instancenew("Frame", visualHolder), info = config}
     local esp, player = itemCache[self], itemCache[self]
     local espholder = esp.holder
     esp.UI = {}
                
   
     espholder.Name = self.Name
     espholder.Visible = false
    
     
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

     
     esp.itemCache = {}
     esp.UI = {
        GUI = esp.holder;

        PName = esp.holder["PNameText"]["PName"];
        Distance = esp.holder["BottomFlags"]["DistanceText"]["distanceValue"];
        BottomFlags = esp.holder["BottomFlags"];
        bottomListLayout = esp.holder["BottomFlags"]["UIListLayout"];
     }
     

  	 esp.UI.PName.AutomaticSize = Enum.AutomaticSize.Y
  	 esp.UI.PName.FontFace = Fonts["SmallestPixel"]
  	 esp.UI.PName.TextSize = 9
     

     esp.UI.Distance.LayoutOrder = 1
  	 esp.UI.Distance.FontFace = Fonts["SmallestPixel"]
  	 esp.UI.Distance.TextSize = 9
  

  return itemCache[self]
end


local function createESP(Player)
  if Player.Character then
  	task.defer(PlayerObject, Player)
  end
  
  Player.CharacterAdded:Connect(function(Character)
    destroyESP(espCache, Player)
    task.defer(PlayerObject, Player)
  end)
    
  Player.CharacterRemoving:Connect(function(Character)
	  destroyESP(espCache, Player)
  end)
end


function ESP.Unload()
  for _, value in espCache do
	  if value:IsA("GuiObject") then
		value:Destroy()
	  end

	  if type(value) == "table" then
		value = nil
	  end

	  if value:IsA("Folder") then
		value:Destroy()
	  end

	  value = nil
  end
	
  espConnection:Disconnect()
end


function ESP.loadESP(flags)
  Players.PlayerAdded:Connect(createESP)
  Players.PlayerRemoving:Connect(function(player)
	  destroyESP(espCache, player)
  end)
  
  for _, player in Players:GetPlayers() do
    if player.Name ~= Players.LocalPlayer.Name then
      task.defer(createESP, player)
    end
  end
  

  --// Vehicle ESP
    Vehicles.ChildAdded:Connect(VehicleObject)
    Vehicles.ChildRemoved:Connect(function(vehicle)
  	  destroyESP(vehicleCache, vehicle)
    end)
    
    for _, vehicle in Vehicles:GetChildren() do
  	  task.defer(VehicleObject, vehicle)
    end
  --//


  --// Corpse ESP
   Corpses.ChildAdded:Connect(CorpseObject)
   Corpses.ChildRemoved:Connect(function(Corpse)
 	  destroyESP(corpseCache, Corpse)
   end)
 
   for _, corpse in Corpses:GetChildren() do
 	  task.defer(CorpseObject, corpse)
   end
  --//

  --[==[
  --//Item ESP
   local Framework = require(game:GetService("ReplicatedFirst").Framework);
   Framework.require("Configs", "Globals");
   local Configs = Framework.require("Configs", "ItemData");
   
   local requestLootModel = getGCFunction("newLootModel")
   local LootNodes = game:GetService("ReplicatedStorage").Client.Entities["Loot Nodes"]
   
 
   local requestLootModelHook
   requestLootModelHook = hookfunction(requestLootModel, newcclosure(function(p23, p24, p25, p26, p27)
     if not checkcaller() then
       local config = Configs[p23.Name]
       --p25.Instance.Parent or p25.Instance
       
       
       if p25.Instance == nil or config == nil then
          return requestLootModelHook(p23, p24, p25, p26, p27)
       end
       

       local parent = p25.Instance
       p25.Instance.Parent.Name = config.RealName
       p25.Instance.AncestryChanged:Connect(function(p1, p2)
        --parent.AncestryChanged:Connect(function(p1, p2)
        setthreadidentity(8)
        destroyESP(itemCache, p25.Instance)
        setthreadidentity(2)
       end)
       
       setthreadidentity(8)
       ItemObject(p25.Instance.Parent, config)
       setthreadidentity(2)
       
       --print(config.RealName, p23.Name, config.Capacity)
       
       return requestLootModelHook(p23, p24, p25, p26, p27)
     end
    return requestLootModelHook(p23, p24, p25, p26, p27)
   end))
   
  --//]==]

  renderESP(flags)
end


local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampro1240/LegacyClient-Temporary-Place-/refs/heads/main/Legacy%20Lua%20Project/UI/UI%20Library.lua"))()
local flags = library.flags
do -- sections + tabs
  local window = library:window({
   	name = os.date("Legacy | %b %d %Y"),
   	size = UDim2.fromOffset(500, 650),
  })
 
  
  local VisualsTab = window:tab({ name = "Visuals" })

  
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


     espTexts:label({text = "Dropped Items"})
      espTexts:toggle({ name = "Enable All", flag = "itemEnableAll", default = false, callback = update_elements })
    	espTexts:toggle({ name = "Names", flag = "ItemNames", default = false})
		    espTexts:colorpicker({ object = "Name Color", flag = "Item_Name_Color", color = Color3.fromRGB(255, 255, 255) })

    	espTexts:toggle({ name = "Distance", flag = "ItemDistance", default = false})
		    espTexts:colorpicker({ object = "Distance Color", flag = "Item_Distance_Color", color = Color3.fromRGB(255, 255, 255) })
      espTexts:dropdown({
    		name = "Distance Type",
    		flag = "ItemDistanceType",
    		items = { "M", "ST", " Meters", " Studs" },
    		default = "M",
    	})

    	espTexts:slider({ name = "Max Distance", min = 100, max = 20000, default = 1000, interval = 1, flag = "ItemMaxDistance" })
       
   end
   
   do --// Boxes
     local espBoxes = VisualsTab:section({ name = "Misc Elements", side = "left" })
	   --library:update_esp_instance(themes.utility["Box"].Box, "Boxes")
   	 espBoxes:toggle({ name = "Boxes", flag = "Boxes", default = false, callback = function(bool) window.preview_bounding_box(bool) window.preview_filler(bool) end })
       espBoxes:colorpicker({ object = "Box Color", flag = "boxColor1", color = Color3.fromRGB(255, 255, 255), callback = function(color) window.change_box(color) end })
       espBoxes:colorpicker({ object = "Box Color", flag = "boxColor2", color = Color3.fromRGB(255, 255, 255), callback = function(color)  end })
       espBoxes:slider({ name = "Box Color Rotation", suffix = "%", flag = "boxColorRotation", value = 90, minimum = 0, maximum = 360 })
 
     
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
		vehicleEsp:toggle({ name = "Enable All", flag = "vehicleEnableAll", default = false, callback = update_elements })
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
	    corpseEsp:toggle({ name = "Enable All", flag = "corpseEnableAll", default = false, callback = update_elements })
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
        qolSection:textbox({flag = "spoofKillFeedText", callback = function(value) cheat.spoofValue = value end})
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
 
 
  VisualsTab.open_tab()
end


--ESP.loadESP(flags)

return ESP, espConnection, espCache
