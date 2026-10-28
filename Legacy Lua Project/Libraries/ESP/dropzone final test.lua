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
local Corpses = workspace.Loot


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


function renderESP(flags)
    local visParams = RaycastParams.new()
    visParams.FilterType = Enum.RaycastFilterType.Exclude
    visParams.IgnoreWater = false
    visParams.CollisionGroup = "Default"
    
    
    local accumulatedTime = 0
	  local accumulatedTime2 = 0
	  local accumulatedTime3 = 0


    local TARGET_INTERVAL = 1 / 60
	  local TARGET_INTERVAL2 = 1 / 40


    local fontSettings = ESP.fontSettings
	  local healthBarSettings = ESP.healthBarSettings
    
    
    local getVisFunc = getVis
    local filterTable = {}
	
    
	  --espConnection = runService.PreRender
    runService.PreRender:Connect(function(deltatime)
        accumulatedTime += deltatime
        if accumulatedTime < TARGET_INTERVAL then
            return
        end
        accumulatedTime -= TARGET_INTERVAL
		
        
    		local isEnableAll = flags["EnableAll"]
    		local cameraPos = currentCamera.CFrame.Position
    		local localCharacter = LocalPlayer.Character
        
		
       	do --// Player
       	  local currentTextFont, flagFont = flags["TextFont"], flags["TextFlagFont"]
       	  local textFont, flagTextFont = Fonts[currentTextFont], Fonts[flagFont]
       	 
               
       	  local healthBarPadding = healthBarSettings[flags["HealthBarPadding"]].Padding
       	  local healthBarPaddingSize = healthBarSettings[flags["HealthBarPadding"]].Size
       	  local textFlagFont = fontSettings[flagFont]
       	  local healthBarPositionFlag = flags["healthBarPosition"]


		      if not isEnableAll then
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
              return -- Exit early so we don't process further when disabled
          end
          
          if not localCharacter then
            return
          end
      
		      local charFind = localCharacter.FindFirstChild
       	  local rayOriginPart = localCharacter.Head
       	  if not rayOriginPart then return end
       
               
       	  local isMaxDistance = flags["MaxDistance"]
       	  local isName, nameColor, isDisplayName = flags["Names"], flags["Name_Color"].Color, flags["UseDisplayName"]
       	  local isDistance, distanceColor, distanceType = flags["Distance"], flags["Distance_Color"].Color, flags["DistanceType"]
       	  local isWeapon, weaponColor = flags["Weapon"], flags["Weapon_Color"].Color
       	  local isVisFlag, visColor, notVisColor = flags["Vis"], flags["Vis_Color"].Color, flags["Not_Vis_Color"].Color
       	  local isHealthText, healthTextColor = flags["HealthText"], flags["Health_Text_Color"].Color
       	  local isAimingText, isAimingColor, notAimingColor = flags["AimingText"], flags["Aiming_Color"].Color, flags["Not_Aiming_Color"].Color
       	  local isInventoryText, isInventoryColor, notInventoryColor = flags["InventoryText"], flags["Inventory_Color"].Color, flags["Not_Inventory_Color"].Color
          
       	  
       	  local healthSpeed = flags["healthBarSpeed"] * 10
       	  local fullFlag = flags["Health_Text_Color"].Color
       	  local lowFlag = flags["Low_Health_Text_Color"].Color
       	  local speed = flags["healthBarSpeed"] or 2
          
          
		      local isBox, boxColor, isBoxFill, boxFillColorOne, boxFillColorTwo, boxFillVisOne, boxFillVisTwo = flags["Boxes"], flags["Box_Color"].Color, flags["BoxFill"], flags["Box_Fill_Color"].Color, flags["Box_Fill_Color_Two"].Color, flags["Box_Fill_Color"].Transparency, flags["Box_Fill_Color_Two"].Transparency
          local isHealthBar, barGradientOne, barGradientTwo = flags["Healthbar"], flags["GradientColor1"].Color, flags["GradientColor2"].Color
          local boxFillColorSequence, boxFillTransparencySequence = ColorSequencenew{ColorSequenceKeypointnew(0, boxFillColorOne), ColorSequenceKeypointnew(1, boxFillColorTwo)}, NumberSequencenew{NumberSequenceKeypointnew(0, boxFillVisOne), NumberSequenceKeypointnew(1, boxFillVisTwo)}
          local barColorSequence = ColorSequencenew{ColorSequenceKeypointnew(0, barGradientOne), ColorSequenceKeypointnew(1, barGradientTwo)}
		      local boxFillRotation = flags["FillRotation"]
       	
       		
       	  local isChams, cColor, ChamGlowMultiplier = flags["BoxChams"], flags["Box_Cham_Color"].Color, flags["ChamGlowMultiplier"]
       	  local chamColor = Color3new(cColor.R * ChamGlowMultiplier, cColor.G * ChamGlowMultiplier, cColor.B * ChamGlowMultiplier)
       	  local rayOriginPos = rayOriginPart.Position
		  
            
            for _, player in espCache do
                   local esp, UI, chamCache = player.holder, player.UI, player.chamCache
                   local actualPlayer = player.Player
                   local character = player.Character
                   local lastRaycast = player.lastRaycast
    

       				     if not character then
               			esp.Visible = false
            					for _, cham in chamCache do
            					  cham.Visible = false
                 		end
                    continue
               	   end
    

     				       local nameText, distanceText, weaponText = UI.PName, UI.Distance, UI.Weapon
            			 local healthFlagHolder = UI.HealthTextHolder
                   local visFlag, healthFlag, aimingFlag, inventoryFlag = UI.VisFlag, UI.HealthText, UI.AimingText, UI.InventoryText
                        
                        
                   local box, boxFill, BoxFillGradient, boxStrokeColor = UI.Box, UI.BoxFill, UI.BoxFillGradient, UI.topColor
                   local healthBar, bar, barGradient = UI.HealthBar, UI.Bar, UI.BarGradient
                   local leftFlags, rightFlags = UI.LeftFlags, UI.RightFlags
				   
				   
                   local findFirstChild, findFirstChildOfClass = character.FindFirstChild, character.FindFirstChildOfClass
                   local root = character.PrimaryPart
                   if not root then
                     esp.Visible = false
                     for _, cham in chamCache do
                       cham.Visible = false
                     end
                     continue
                   end
                   
                   
                   local head, humanoid = character.Head, character.Humanoid
                   if not head or not root or not humanoid or humanoid and humanoid.Health <= 0 then
                     esp.Visible = false
                     for _, cham in chamCache do
                       cham.Visible = false
                     end
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
        				   local aimingStroke, inventoryStroke = aimingFlag["UIStroke"], inventoryFlag["UIStroke"]
                   
                   
                   nameText.Parent.Visible = isName
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
           					local weapon = nil
                    --findFirstChildOfClass(equipped, "Model")
           					local weaponValue = weapon and weapon.Name or "Hands"
           					weaponText.TextColor3 = weaponColor
           					weaponText.Text = weaponValue
                   end
                   
                      
                   visFlag.Visible = isVisFlag
                   if isVisFlag then
            				local playerVis = player.playerVis
            				if distancemag < 300 and (currentClock - lastRaycast) > .5 then
            						lastRaycast = currentClock
                        
                        filterTable[1] = localCharacter
                        filterTable[2] = rayOriginPart
                        filterTable[3] = character
                        visParams.FilterDescendantsInstances = filterTable
                        
                        local visCheck = Raycast(Workspace, rayOriginPos, head.Position - rayOriginPos, visParams)
                        playerVis = not visCheck or visCheck.Instance == head or visCheck.Instance.Parent == character
                    end
					          visFlag.TextColor3 = getVisFunc(playerVis, visColor, notVisColor)
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
                     aimingFlag.TextColor3 = getVisFunc(true, isAimingColor, notAimingColor)
          					 aimingFlag.TextTransparency = cutOff
          					 if aimingStroke then
                 			aimingStroke.Transparency = cutOff
          					 end
                   end
                   
                   
                   inventoryFlag.Visible = isInventoryText
                   if isInventoryText then
          					 inventoryFlag.TextColor3 = getVisFunc(true, isInventoryColor, notInventoryColor)
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
        
    end)
    
    
	runService.PreRender:Connect(function(deltatime)
        accumulatedTime2 += deltatime
        if accumulatedTime2 < TARGET_INTERVAL2 then
            return
        end
        accumulatedTime2 -= TARGET_INTERVAL2

		local cameraPos = currentCamera.CFrame.Position
		local localCharacter = LocalPlayer.Character
        
    	do --// Vehicle
			      local isESP = flags["vehicleEnableAll"]
    		    local isMaxDistance = flags["VehicleMaxDistance"]
            local isName, nameColor = flags["VehicleNames"], flags["Vehicle_Name_Color"].Color
            local isDistance, distanceColor, distanceType = flags["VehicleDistance"], flags["Vehicle_Distance_Color"].Color, flags["VehicleDistanceType"]
    		    local isBox, boxColor = flags["VehicleBoxes"], flags["Vehicle_Box_Color"].Color
            local isHealthText, healthTextColor = flags["VehicleHealthText"], flags["Vehicle_Health_Text_Color"].Color


            local currentTextFont, flagFont = flags["VehicleTextFont"], flags["VehicleTextFlagFont"]
       	    local textFont, flagTextFont = Fonts[currentTextFont], Fonts[flagFont]


            local healthBarPadding = healthBarSettings[flags["VehicleHealthBarPadding"]].Padding
         	  local healthBarPaddingSize = healthBarSettings[flags["VehicleHealthBarPadding"]].Size
         	  local textFlagFont = fontSettings[flagFont]


            local isHealthBar, barGradientOne, barGradientTwo = flags["VehicleHealthbar"], flags["VehicleGradientColor1"].Color, flags["VehicleGradientColor2"].Color
            --local boxFillColorSequence, boxFillTransparencySequence = ColorSequencenew{ColorSequenceKeypointnew(0, boxFillColorOne), ColorSequenceKeypointnew(1, boxFillColorTwo)}, NumberSequencenew{NumberSequenceKeypointnew(0, boxFillVisOne), NumberSequenceKeypointnew(1, boxFillVisTwo)}
            local barColorSequence = ColorSequencenew{ColorSequenceKeypointnew(0, barGradientOne), ColorSequenceKeypointnew(1, barGradientTwo)}
            
            
            local healthSpeed = flags["vehicleHealthBarSpeed"] * 10
         	  local fullFlag = flags["Vehicle_Health_Text_Color"].Color
         	  local lowFlag = flags["Vehicle_Low_Health_Text_Color"].Color
            

    		for _, vehicle in vehicleCache do
				  local esp, UI, chamCache = vehicle.holder, vehicle.UI, vehicle.chamCache
    			local vehicleModel = vehicle.Vehicle

				
   				if not isESP or not localCharacter then
   				  esp.Visible = false
           continue
   				end

				        
          local nameText, distanceText = UI.PName, UI.Distance
          local box, boxStrokeColor = UI.Box, UI.topColor
          local healthBar, bar, barGradient = UI.HealthBar, UI.Bar, UI.BarGradient
				
                
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
                local health = vehicleModel:GetAttribute("Health")
				

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
                
                healthBar.Visible = isHealthBar
                if isHealthBar then
                  local maxHealth = vehicleModel:GetAttribute("MaxHealth")
       				    vehicle.MaxHealth = maxHealth+ (health - maxHealth) * clamp(healthSpeed * deltatime, 0, 1)
       				    local maxHealth = maxHealth > 0 and maxHealth or 100
					        local healthPercent = clamp(health / maxHealth, 0, 1)
       			    
       				
       				    healthBar.Size = UDim2new(0, healthBarPaddingSize, 0, boxYSize)
					        leftFlags.Size = fromOffset(-1, boxYSize)
       				    bar.Size = UDim2new(1, 0, healthPercent, 0)
       
       				    leftFlags.Position = fromOffset(boxLeftX - healthBarPadding, posClamp)
					        barGradient.Color = barColorSequence
       				
                  healthFlag.Text = floor(health)
       				    healthFlag.Position = UDim2new(0, 0, 1 - healthPercent, 0)
					        healthFlag.TextColor3 = fullFlag:Lerp(lowFlag, 1 - healthPercent)
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
			  local isESP = flags["corpseEnableAll"]
    		local isMaxDistance = flags["CorpseMaxDistance"]
        local isName, nameColor = flags["CorpseNames"], flags["Corpse_Name_Color"].Color
        local isDistance, distanceColor, distanceType = flags["CorpseDistance"], flags["Corpse_Distance_Color"].Color, flags["CorpseDistanceType"]
    		local isBox, boxColor = flags["CorpseBoxes"], flags["Corpse_Box_Color"].Color
            
            
    		for _, corpse in corpseCache do
          local esp, UI, chamCache = corpse.holder, corpse.UI, corpse.chamCache
    			local corpseModel = corpse.Corpse

                
				   if not isESP or not localCharacter then
    			  esp.Visible = false
           continue
    			 end


				   local nameText, distanceText = UI.PName, UI.Distance
           local box, boxStrokeColor = UI.Box, UI.topColor
				
    			
           if not corpseModel then
            esp.Visible = false
            continue
           end


           if not corpseModel.PrimaryPart then
            esp.Visible = false
            continue
           end
    		
               
  				 local getBoundingBox = corpseModel.PrimaryPart.GetBoundingBox
  				 local boxCFrame, boxSize = getBoundingBox(corpseModel.PrimaryPart)

                
           local centerPos = boxCFrame.Position
           local distancemag = floor((centerPos - cameraPos).Magnitude)
				
				
           local center2D, isRootVis = WorldToViewportPoint(currentCamera, centerPos - vectorcreate(0, .5))
                if not isRootVis or distancemag >= isMaxDistance then
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

     local colorStroke, outerStroke, innerStroke = DrawUIStroke({Parent = esp.holder["Box"]}), DrawUIStroke({Parent = esp.holder["Box"]}), DrawUIStroke({Parent = esp.holder["Box"]})
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


local function createESP(Player)
  if Player.Character then
  	task.defer(PlayerObject, Player)
  end
  
  Player.CharacterAdded:Connect(function(Character)
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
  

  Vehicles.ChildAdded:Connect(VehicleObject)
  Vehicles.ChildRemoved:Connect(function(vehicle)
	destroyESP(vehicleCache, vehicle)
  end)
  
  for _, vehicle in Vehicles:GetChildren() do
	task.defer(VehicleObject, vehicle)
  end


  Corpses.ChildAdded:Connect(CorpseObject)
  Corpses.ChildRemoved:Connect(function(Corpse)
	  destroyESP(corpseCache, Corpse)
  end)

  for _, corpse in Corpses:GetChildren() do
	  task.defer(CorpseObject, corpse)
  end

  renderESP(flags)
end


return ESP, espConnection, espCache
