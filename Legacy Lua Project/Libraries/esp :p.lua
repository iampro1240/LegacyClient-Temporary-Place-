local library, themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampro1240/LegacyClient-Temporary-Place-/refs/heads/main/Legacy%20Lua%20Project/UI/Library.lua"))()
local getService, getFunction, getGCFunction, deepCopy, Variables, Math, FindFirstChild, FindFirstChildOfClass, wtvpp = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampro1240/LegacyClient-Temporary-Place-/refs/heads/main/Legacy%20Lua%20Project/Libraries/Services.lua"))()
local espConnection
local ESP = {
  fontSettings = {
    Minecraftia = {FontSize = 10, namePadding = 13, bottomPadding = 2, bottomListLayoutPadding = -3, leftListLayoutPadding = 10, bottomHealthTextPadding = -11, leftHealthTextPadding = -19};
    ProggyTiny = {FontSize = 9, namePadding = 12, bottomPadding = 3, bottomListLayoutPadding = 2, leftListLayoutPadding = 10, bottomHealthTextPadding = -7, leftHealthTextPadding = -14};
    SmallestPixel = {FontSize = 9, namePadding = 12, bottomPadding = 1, bottomListLayoutPadding = 0, leftListLayoutPadding = 10, bottomHealthTextPadding = -3, leftHealthTextPadding = -10};
    Tahoma = {FontSize = 12, namePadding = 15, bottomPadding = 1, bottomListLayoutPadding = 0, leftListLayoutPadding = 13, bottomHealthTextPadding = -5, leftHealthTextPadding = -12};
  };
  

  healthBarSettings = {
    ["1 Pixel"] = {Padding = 3, Size = 1},
    ["2 Pixel"] = {Padding = 4, Size = 2},

    ["Left"] = {Parent = "LeftFlags", AnchorPoint = .5};
    ["Right"] = {Parent = "RightFlags", AnchorPoint = 1};
  };

  
  ValidParts = {
  	"Head",
  	"UpperTorso",
  	"LowerTorso",
  	"HumanoidRootPart",
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
  ["ProggyClean"] = "ProggyClean.ttf",
  ["Tahoma"] = "fs-tahoma-8px.ttf",
  ["Verdana"] = "Verdana-Font.ttf",
  ["SmallestPixel"] = "smallest_pixel-7.ttf",
  ["ProggyTiny"] = "ProggyTiny.ttf",
  ["Minecraftia"] = "Minecraftia-Regular.ttf",
  ["Tahoma Bold"] = "tahoma_bold.ttf",
  ["Rubik"] = "Rubik-Regular.ttf"
}
local FontIndexes = {"ProggyClean", "Tahoma", "Verdana", "SmallestPixel", "ProggyTiny", "Minecraftia", "Tahoma Bold", "Rubik"}
local espCache = {}
local Fonts = {}
local libraryFunctions = {}
local visuals = {}
local lib = {}
local rayOrigin
local flags = library.flags
local visualHolder = Instance.new("ScreenGui", gethui())
visualHolder.IgnoreGuiInset = true
visualHolder.Enabled = true


local typeOf = typeof
local clock = os.clock
local currentCamera = workspace.CurrentCamera
local WorldToViewportPoint = currentCamera.WorldToViewportPoint


local round = math.round
local floor = math.floor
local UDim2new = UDim2.new
local UDimnew = UDim.new
local fromOffset = UDim2.fromOffset
local vectorcreate = vector.create
local vector2New = Vector2.new


local fromRGB = Color3.fromRGB
local ColorSequencenew = ColorSequence.new
local ColorSequenceKeypointnew = ColorSequenceKeypoint.new
local NumberSequencenew = NumberSequence.new
local NumberSequenceKeypointnew = NumberSequenceKeypoint.new



do -- Font Registering
        local function RegisterFont(Name, Weight, Style, Asset)
            if not isfile(Asset.Id) then
                writefile(Asset.Id, Asset.Font)
            end

            if isfile(Name .. ".font") then
                delfile(Name .. ".font")
            end

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

            writefile(Name .. ".font", game:GetService("HttpService"):JSONEncode(Data))

            return getcustomasset(Name .. ".font");
        end

        for name, suffix in FontNames do 
            local Weight = 400 

            if name == "Rubik" then -- fuckin stupid 
                Weight = 900 
            end 

            local RegisteredFont = RegisterFont(name, Weight, "Normal", {
                Id = suffix,
                Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/" .. suffix),
            }) 
            
            Fonts[name] = Font.new(RegisteredFont, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        end
end


do --// ESP functions
  function lib.DrawGradient(properties)
        local obj = Variables.Instancenew("UIGradient")
        obj.Name = "UIGradient"
        obj.Parent = properties.Parent or nil
    
        obj.Rotation = properties.Rotation or 0
        obj.Color = properties.Color or fromRGB(255, 255, 255)
        return obj
  end
   
   
  function lib.DrawUIStroke(properties)
       local obj = Variables.Instancenew("UIStroke")
       obj.Parent = properties.Parent
       return obj
  end
   
   
  function lib.DrawText(properties)
       local obj = Variables.Instancenew("TextLabel")
       local stroke = Variables.Instancenew("UIStroke")
       obj.Name = properties.Name
       obj.TextSize = 10
       obj.RichText = true
       stroke.LineJoinMode = Enum.LineJoinMode.Miter
   
       obj.Parent = properties.Parent
       obj.BackgroundTransparency = 1
           
       obj.BorderColor3 = fromRGB(0, 0, 0)
       obj.BorderSizePixel = 0
   
       obj.TextStrokeTransparency = 1
   	   obj.FontFace = Fonts.Minecraftia
   
       obj.AnchorPoint = properties.AnchorPoint

       obj.AutomaticSize = Enum.AutomaticSize.Y
       stroke.Parent = obj
  end
   
   
  function lib.DrawFrame(properties)
       local obj = Variables.Instancenew("Frame")
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
  end
   
   
  function lib.DrawImage(properties)
      local obj = Variables.Instancenew("ImageLabel")
      obj.Name = properties.Name
      obj.Parent = properties.Parent
      obj.Image = properties.Image
   
      obj.BackgroundTransparency = 1
    	obj.BorderColor3 = fromRGB(0, 0, 0)
   
    	obj.BorderSizePixel = properties.BorderSizePixel
    	obj.Position = properties.Position
    	obj.Size = properties.Size
    
      obj.ZIndex = properties.Zindex
      obj.Rotation = properties.Rotation
      obj.AnchorPoint = properties.AnchorPoint
  end


  function ESP.getWeapon(weapon)
    if weapon then
      return weapon.Name
     else
      return "Hands"
    end
  end


  function ESP.getVis(vis, isVisColor, notVisColor)
    if vis then
      return isVisColor
     else
      return notVisColor
    end
  end
  
  
  function ESP.getManip(manip, isManipColor, notManipColor)
    if manip then
      return isManipColor
     else
      return notManipColor
    end
  end
  
  
  function ESP.getParts(esp, character)
    if not character or character == nil then
      return
    end
  
  
    local folder = Instance.new("Folder", esp.holder)
    for _, part in character:GetChildren() do
        if part:IsA("MeshPart") or part:IsA("Part") then
          if ESP.ValidParts[part.Name] then
            continue
          end
          esp.chamCache[part] = Instance.new("BoxHandleAdornment", folder)
          esp.chamCache[part].ZIndex = -1
          esp.chamCache[part].Adornee = part
          esp.chamCache[part].Size = part.Size
          esp.chamCache[part].Visible = false
  
  
          esp.chamCacheTwo[part] = Instance.new("BoxHandleAdornment", folder)
          esp.chamCacheTwo[part].ZIndex = -2
          esp.chamCacheTwo[part].Adornee = part
          esp.chamCacheTwo[part].Size = part.Size
          esp.chamCacheTwo[part].Visible = false
          esp.chamCacheTwo[part].Transparency = .7
          esp.chamCacheTwo[part].Color3 = fromRGB(0, 0, 0)
          esp.chamCacheTwo[part].Name = "BlackedOut"
  
          esp.partCache[part] = part or {part}
        end
    end
  
  end
  
  
  function ESP.getBones(esp, character)
    if not character or character == nil then
      return
    end
  
  
    for _, part in character:GetChildren() do
      if cheat.ValidParts[part.Name] then
        esp.partCache[part] = part or {part}
      end
    end
  
  end
  
  
  function ESP.distanceCheck(distancemag, onScreen)
      if distancemag <= visuals.returnflag("MaxDistance") and onScreen then
         return true
        else
          return false
       end
  end
  
  
  function ESP.vehicleDistanceCheck(distancemag, onScreen)
      if distancemag <= visuals.returnflag("VehicleMaxDistance") and onScreen then
        return true
       else
        return false
      end
  end
  
  
  function ESP.corpseDistanceCheck(distancemag, onScreen)
      if distancemag <= visuals.returnflag("CorpseMaxDistance") and onScreen then
        return true
       else
        return false
      end
  end
  
  
  function connectBone(Bone, Visible, From, To, Thickness, Color, Zindex)
      Bone.Visible = Visible
      Bone.From = From
      Bone.To = To
      Bone.Thickness = Thickness
      Bone.Color = Color
      Bone.ZIndex = Zindex
  end
  
  
  function ESP.getBoneValue(cache, bonePart, value)
      return cache[bonePart][value]
  end
  
  
  function ESP.setBoneVis(cache, visible)
      for _, item in cache do
          item.Line.Visible = visible
          item.Outline.Visible = visible
      end
  end
  
  
  function ESP.color3ToHex(color)
      local r = Math.floor(color.R * 255)
      local g = Math.floor(color.G * 255)
      local b = Math.floor(color.B * 255)
     return string.format("#%02X%02X%02X", r, g, b)
  end
  
  
  function ESP.lerp(a, b, t)
    	return a + (b - a) * t
  end
    
  
  function ESP.applyPulseSequence(originalKeypoints, t)
        local newKeypoints = {}
        
        -- Oscillates the wave position smoothly back and forth between 0 (left) and 1 (right)
        -- If 't' is already a 0-to-1 ping-pong value from a tween, you can set wavePos = t
        local wavePos = (math.sin(t) + 1) / 2 
        
        -- Controls how far the fade influence spreads (1.0 spans the full sequence)
        local waveWidth = 1.0 
    
        for _, kp in originalKeypoints do
            -- Distance between the keypoint's position (0 to 1) and the wave position
            local dist = math.abs(kp.Time - wavePos)
            
            -- Local fade factor (1 = closest to wave center / most transparent, 0 = farthest)
            local fadeAlpha = math.clamp(1 - (dist / waveWidth), 0, 1)
            
            -- Lerp keypoint transparency towards 1 (invisible) based on fadeAlpha
            local currentTrans = visuals:lerp(kp.Value, 1, fadeAlpha)
            currentTrans = math.clamp(currentTrans, 0, 1)
            
            table.insert(newKeypoints, NumberSequenceKeypoint.new(kp.Time, currentTrans))
        end
        
        return NumberSequence.new(newKeypoints)
  end

end


do --// Library Functions
  function visuals.returnflag(flag)
    return flags[flag]
  end

   
  function visuals.returnflagcolor(color)
    return flags[color].Color
  end
   

  function visuals.returnflagtransparency(color)
    return flags[color].Transparency
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
    --local WorldToViewportPoint = cam.WorldToViewportPoint
    
    
    espConnection = Variables.RunService.PreRender:Connect(function(deltatime)
      local timeElapsed = 0
      accumulatedTime += deltatime
      if accumulatedTime < TARGET_INTERVAL then
        return
      end
        
      accumulatedTime -= TARGET_INTERVAL

      local currentTextFont, flagFont = flags["TextFont"], flags["TextFlagFont"]
      local textFont, flagTextFont = Fonts[currentTextFont], Fonts[flagFont]


      local textSettings, flagTextSettings = ESP.fontSettings[currentTextFont], ESP.fontSettings[flagFont]
      local isSkeleton, boneThickness, outlineThickness, boneColor, outlineColor, boneZIndex, outlineZIndex = flags["skeletonEnabled"], 1, 3, flags["boneColor"].Color, Color3.fromRGB(0, 0, 0), 2, 1
       

      local healthBarPadding = ESP.healthBarSettings[flags["HealthBarPadding"]].Padding
      local healthBarPaddingSize = ESP.healthBarSettings[flags["HealthBarPadding"]].Size
      local textFlagFont = ESP.fontSettings[flagFont]
      
  
      local Client = Variables.Players.LocalPlayer
      local cameraPos = Variables.Camera.CFrame.Position
      local clientCharacter = Variables.Players.LocalPlayer.Character
      if clientCharacter then
        rayOrigin = clientCharacter.Head
      end


      local isEnableAll = flags["EnableAll"]
      local isMaxDistance = flags["MaxDistance"]


      local isName = flags["Names"]
      local isDistance = flags["Distance"]
      local isWeapon = flags["Weapon"]
      local isVisFlag = flags["Vis"]
      local isHealthText = flags["HealthText"]
      local isAimingText = flags["AimingText"]
      local isInventoryText = flags["InventoryText"]
                
      
      local isBox = flags["Boxes"]
      local isHealthBar = flags["Healthbar"]
      

      for _, player in espCache do
            local esp, UI, partCache, boneCache, chamCache, chamCacheTwo = player.holder, player.UI, player.partCache, player.boneCache, player.chamCache, player.chamCacheTwo
            local character = player.Character
           

            if not isEnableAll or not clientCharacter then
              esp.Visible = false
             continue
            end
            
            
            local head, root, humanoid = player.head, player.root, player.humanoid
            if not character or not rayOrigin or not head or not root or not humanoid or humanoid.Health <= 0 then
              esp.Visible = false
             continue
            end
            
            
            local rootPos = root.Position
            local distancemag = round((rootPos - cameraPos).Magnitude)
            if distancemag >= isMaxDistance then
              esp.Visible = false
             continue
            end
            
            
            local pos2, isRootVis = WorldToViewportPoint(currentCamera, rootPos)
            if not isRootVis then
              esp.Visible = false
             continue
            end


            esp.Visible = true
            local leftFlags, leftListLayout = UI.LeftFlags, UI.leftListLayout
            local rightFlags, rightListLayout = UI.RightFlags, UI.rightListLayout
          
                
            local halfHeight = (root.Size.X + root.Size.Y) / 1.5
            local top2D, isTopVisible = WorldToViewportPoint(currentCamera, rootPos + vectorcreate(0, halfHeight))
            local bottom2D, isBottomVisible = WorldToViewportPoint(currentCamera, rootPos - vectorcreate(0, halfHeight))
  
                
            local isPlayerVis, isPlayerManip = player.playerVis, player.playerManip
            local nameText, distanceText, weaponText, visFlag, manipFlag, healthFlag, aimingFlag, inventoryFlag = UI.PName, UI.Distance, UI.Weapon, UI.VisFlag, UI.ManipFlag, UI.HealthText, UI.AimingText, UI.InventoryText
            local aimingFlagStroke, inventoryFlagStroke = UI.aimingFlagStroke, UI.inventoryFlagStroke
            local healthTextPadding = UI.HealthTextPadding

          
            local centerX = top2D.X
            local height = (bottom2D.Y - top2D.Y)
              
                
            local width = (height * .6) 
            local boxYSize = (height * 1.16 + 7)
            local posClamp = floor(top2D.Y - height * .019)
  
                
            local boxTotalWidth = floor(width * 1.16 + 5)
            local halfBoxWidth = floor(boxTotalWidth * .5)


            local boxLeftX = floor(centerX - halfBoxWidth)
            local boxRightX = boxLeftX + boxTotalWidth
           

            do --// Texts
                do --// Name
                  
                  nameText.Visible = isName
                  if isName then
                    nameText.Position = fromOffset(centerX, posClamp - textSettings.namePadding)
                    nameText.TextColor3 = flags["Name_Color"].Color
                    nameText.FontFace = textFont
                    nameText.TextSize = textSettings.FontSize

                    if flags["UseDisplayName"] then
                      nameText.Text = player.Player.DisplayName
                     else
                      nameText.Text = player.Player.Name
                    end
                  end

                end
    
  
                do --// Distance
                  distanceText.Visible = isDistance
                  if isDistance then
                    distanceText.Text = distancemag .. flags["DistanceType"]
                    distanceText.TextColor3 = flags["Distance_Color"].Color
                    distanceText.FontFace = textFont
                    distanceText.TextSize = textSettings.FontSize
                  end
                end
                
    
                do -- Weapon
                  weaponText.Visible = isWeapon
                  if isWeapon then
                    weaponText.TextColor3 = flags["Weapon_Color"].Color
                    weaponText.Text = player.weapon or "Empty"
                    weaponText.FontFace = textFont
                    weaponText.TextSize = textSettings.FontSize
                  end
                end
    
  
                do --// Vis Check
                  visFlag.Visible = isVisFlag and rayOrigin
                  if visFlag.Visible then
                    visFlag.FontFace = textFont

                    visFlag.TextSize = textSettings.FontSize
                    visParams.FilterDescendantsInstances = {clientCharacter, rayOrigin, character}

                    if (clock() - player.lastRaycast) > 0.1 then
                        player.lastRaycast = clock()
                        local visCheck = Variables.Workspace:Raycast(rayOrigin.Position, (head.Position - rayOrigin.Position), visParams)            
                        if not visCheck or visCheck.Instance == head or visCheck.Instance.Parent == head.Parent then
                          player.playerVis = true
                         else
                          player.playerVis = false
                        end
                    end
                    visFlag.TextColor3 = ESP.getVis(player.playerVis, flags["Vis_Color"].Color, flags["Not_Vis_Color"].Color)
                  end
                end
               

                do --// Misc Flags

                  local cutOff = math.clamp((distancemag-250)/(330-250), 0, 1)
                  aimingFlag.Transparency = cutOff
                  aimingFlagStroke.Transparency = cutOff
                  inventoryFlag.Transparency = cutOff
                  inventoryFlagStroke.Transparency = cutOff

                  
                  healthFlag.Visible = isHealthText
                  if isHealthText then
                    healthFlag.TextColor3 = flags["Health_Text_Color"].Color
                    healthFlag.Text = floor(humanoid.Health)
                    healthFlag.FontFace = flagTextFont
                    healthFlag.TextSize = flagTextSettings.FontSize
                  end

                  
                  aimingFlag.Visible = isAimingText
                  if isAimingText then
                    aimingFlag.TextColor3 = getVis(true, flags["Aiming_Color"].Color, flags["Not_Aiming_Color"].Color)
                    aimingFlag.FontFace = flagTextFont
                    aimingFlag.TextSize = flagTextSettings.FontSize
                  end
                  
                  
                  inventoryFlag.Visible = isInventoryText
                  if isInventoryText then
                    inventoryFlag.TextColor3 = getVis(true, flags["Inventory_Color"].Color, flags["Not_Inventory_Color"].Color)
                    inventoryFlag.TextSize = textFlagFont.FontSize
                    inventoryFlag.FontFace = flagTextFont
                  end

                end

               
                rightFlags.Position = fromOffset(rightX, posClamp)
                rightFlags.Size = fromOffset(1, boxYSize)
            

                UI.BottomFlags.Position = fromOffset(centerX, floor( posClamp + boxYSize + textSettings.bottomPadding))
                UI.bottomListLayout.Padding = UDimnew(0, textSettings.bottomListLayoutPadding)
            end
          

            do --// Other
                do -- Box
                  local box, boxFill, boxGradient = UI.Box, UI.BoxFill, UI.BoxFillGradient
                  box.Visible = isBox
                  if isBox then
                    box.Position = UDim2new(0, centerX, 0, posClamp)
                    box.Size = UDim2new(0, boxTotalWidth, 0, boxYSize)
                    UI.topColor.Color = flags["Box_Color"].Color
                    
                    
                    boxFill.Visible = flags["Boxes"] and flags["BoxFill"]
                    --boxGradient.Color = ColorSequencenew{ColorSequenceKeypointnew(0, flags["Box_Fill_Color"].Color), ColorSequenceKeypointnew(1, flags["Box_Fill_ColorTwo"].Color)}
                    

                    --boxGradient.Transparency = NumberSequencenew{NumberSequenceKeypointnew(0, flags["GradientColor1"].Transparency), NumberSequenceKeypointnew(1, flags["GradientColor2"].Transparency)}
                    if flags["gradientSpin"] then
                       --boxGradient.Rotation += flags["gradientAnimationSpeed"] / 100
                     else
                      --boxGradient.Rotation = flags["FillRotation"]
                    end
                  end
                end
  
                do -- Health Bar
                  local healthBar, bar, barGradient = UI.HealthBar, UI.Bar, UI.BarGradient
                  healthBar.Visible = isHealthBar
                  if isHealthBar then
                    leftListLayout.Padding = UDimnew(0, textSettings.leftListLayoutPadding)
                    
  
                    healthBar.Size = UDim2new(0, healthBarPaddingSize, 0, boxYSize)
                    leftFlags.Size = fromOffset(-1, boxYSize)
                    bar.Size = UDim2new(1, 0, humanoid.Health / humanoid.MaxHealth, 0)
                     
                     
                    leftFlags.Position = fromOffset(boxLeftX - healthBarPadding, posClamp)
                    barGradient.Color = ColorSequencenew{ColorSequenceKeypointnew(0, flags["GradientColor1"].Color), ColorSequenceKeypointnew(1, flags["GradientColor2"].Color)}
                  end
                end
            end


            do --// Flags
              rightFlags.Position = fromOffset(boxRightX + healthBarPadding, posClamp)
              rightFlags.Size = fromOffset(1, boxYSize)
            end

      end

    end)

end


local function ESPObject(self)
     espCache[self] = {Name = self.Name, Player = self, Character = self.Character, holder = Variables.Instancenew("Frame", visualHolder), playerVis = false, playerManip = false, partCache = {}, boneCache = {}, chamCache = {}, chamCacheTwo = {}, Colors = Variables.Instancenew("Folder"), Borders = Variables.Instancenew("Folder"), chamsholder = Variables.Instancenew("Folder"), highlight = Variables.Instancenew("Highlight", visualHolder), lastRaycast = 0, weapon = nil}
     local esp, player = espCache[self], espCache[self]
     local Colors = esp.Colors
     local Borders = esp.Borders 
     local espholder, cache, chamsholder, esphighlight = esp.holder, esp.cache, esp.chamsholder, esp.highlight
     esp.UI = {}
                
   
     espholder.Name = self.Name
     espholder.Visible = false
   
     chamsholder.Parent = espholder
     --esphighlight.Parent = espholder
   
   
     Colors.Parent = espholder
     Borders.Parent = espholder
     Colors.Name = "Colors"
     Borders.Name = "Borders"
   
   
     do -- main text
       lib.DrawFrame({
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
   
   
   
       lib.DrawText({
        Name = "PName", 
   		  Parent = esp.holder,
        TextSize = 10,
        AnchorPoint = vector2New(0, 0)
       })

   
   
       lib.DrawText({
        Name = "Distance", 
   		  Parent = esp.holder["BottomFlags"],
        TextSize = 10,
        AnchorPoint = vector2New(0, 0)
       })
   
   
       lib.DrawText({
        Name = "Weapon", 
   		  Parent = esp.holder["BottomFlags"],
        TextSize = 10,
        AnchorPoint = vector2New(0, 0)
       })


       lib.DrawText({
        Name = "VisFlag", 
   		  Parent = esp.holder["BottomFlags"],
        TextSize = 10,
        AnchorPoint = vector2New(0, 0)
       })


       lib.DrawText({
        Name = "ManipFlag", 
   		  Parent = esp.holder["BottomFlags"],
        TextSize = 10,
        AnchorPoint = vector2New(0, 0)
       })
       


       local listLayout = Variables.Instancenew("UIListLayout", esp.holder["BottomFlags"])
       local uiPadding = Variables.Instancenew("UIPadding", esp.holder["BottomFlags"])
       listLayout.Padding = UDimnew(0, 11)
       listLayout.VerticalAlignment = "Top"
       listLayout.HorizontalAlignment = "Center"
       listLayout.ItemLineAlignment = "Center"
       listLayout.SortOrder = "LayoutOrder"
       uiPadding.PaddingBottom = UDimnew(1, 0)


       local weaponPadding, distancePadding = Variables.Instancenew("UIPadding", esp.holder["BottomFlags"]["Weapon"]), Variables.Instancenew("UIPadding", esp.holder["BottomFlags"]["Distance"])
       --weaponPadding.PaddingBottom = UDimnew(-0.23, 0)
       --weaponPadding.PaddingTop = UDimnew(-0.15, 0)


       --distancePadding.PaddingBottom = UDimnew(-0.32, 0)
       --distancePadding.PaddingTop = UDimnew(-0.15, 0)
   
   
     end
   

     do -- box
       lib.DrawFrame({
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



       lib.DrawFrame({
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



       esp.UI.BoxFillGradient = lib.DrawGradient({
          Parent = esp.holder["Box"]["BoxFill"],
          Rotation = -90,
          Color = ColorSequence.new{ColorSequenceKeypoint.new(0, fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, fromRGB(255, 255, 255))},
          Transparency = 0
       })
   
   
   
       Colors.Parent = esp.holder["Box"]
       Borders.Parent = esp.holder["Box"]
   
   
     end
   

     do -- HealthBar
      lib.DrawFrame({
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



       lib.DrawFrame({
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

       

       local listLayout = Variables.Instancenew("UIListLayout", esp.holder["LeftFlags"])
       listLayout.Padding = UDimnew(0, -6)
       listLayout.FillDirection = "Horizontal"
       listLayout.HorizontalAlignment = "Left"
       listLayout.HorizontalFlex = "None"
       listLayout.VerticalAlignment = "Top"
       listLayout.ItemLineAlignment = "Start"



       local listLayout2 = Variables.Instancenew("UIListLayout", esp.holder["LeftFlags"]["LeftFlagsTwo"])
       listLayout2.Padding = UDimnew(0, 10)
       listLayout2.FillDirection = "Vertical"
       listLayout2.HorizontalAlignment = "Left"
       listLayout2.HorizontalFlex = "None"
       listLayout2.VerticalAlignment = "Top"
       listLayout2.ItemLineAlignment = "Start"

       

       lib.DrawFrame({
           Name = "HealthBar",
           Parent = esp.holder["LeftFlags"],
           --Parent = esp.holder,
           Color = fromRGB(0, 0, 0),
           BackgroundTransparency = 0,
           BorderSizePixel = 0,
           Position = UDim2new(0.17, 0, 0.12, 0),
           Size = UDim2new(0.65, 0, 0.88, 0),
           Zindex = 9999999999,
           Rotation = 0,
           AnchorPoint = vector2New(.5, 0),
       })
       
   
       lib.DrawFrame({
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
      

       lib.DrawText({
        Name = "HealthText", 
   		  Parent = esp.holder["LeftFlags"]["LeftFlagsTwo"],
        TextSize = 10,
        AnchorPoint = vector2New(0, 0)
       })


       local HealthTextPadding = Variables.Instancenew("UIPadding", esp.holder["LeftFlags"]["LeftFlagsTwo"]["HealthText"])
       HealthTextPadding.PaddingBottom = UDimnew(.3, 0)
       HealthTextPadding.PaddingLeft = UDimnew(0, -12)


       local healthBarStroke = lib.DrawUIStroke({Parent = esp.holder["LeftFlags"]["HealthBar"]})
       healthBarStroke.LineJoinMode = "Miter"

   
       lib.DrawGradient({
          Parent = esp.holder["LeftFlags"]["HealthBar"]["Bar"],
          Rotation = -90,
          Color = ColorSequence.new{ColorSequenceKeypoint.new(0, fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, fromRGB(255, 255, 255))}
       })
     end


     do -- Right Flags
      lib.DrawFrame({
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



       lib.DrawFrame({
        Name = "RightFlagsTwo",
        Parent = esp.holder["RightFlags"],
        Color = fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2new(0, 632, 0, 569),
        Size = UDim2new({0.062, 0},{0.126, 0}),
        Zindex = 9999999999,
        Rotation = 0,
        AnchorPoint = vector2New(0, 0)
       })



       local listLayout = Variables.Instancenew("UIListLayout", esp.holder["RightFlags"])
       listLayout.Padding = UDimnew(0, 0)
       listLayout.FillDirection = "Horizontal"
       listLayout.HorizontalAlignment = "Right"
       listLayout.HorizontalFlex = "None"
       listLayout.VerticalAlignment = "Top"
       listLayout.ItemLineAlignment = "Start"



       local listLayout2 = Variables.Instancenew("UIListLayout", esp.holder["RightFlags"]["RightFlagsTwo"])
       listLayout2.Padding = UDimnew(0, 10)
       listLayout2.FillDirection = "Vertical"
       listLayout2.HorizontalAlignment = "Right"
       listLayout2.HorizontalFlex = "None"
       listLayout2.VerticalAlignment = "Top"
       listLayout2.ItemLineAlignment = "Start"



       lib.DrawText({
        Name = "AimingText", 
   		  Parent = esp.holder["RightFlags"]["RightFlagsTwo"],
        TextSize = 10,
        AnchorPoint = vector2New(0, 0)
       })



       lib.DrawText({
        Name = "InventoryText", 
   		  Parent = esp.holder["RightFlags"]["RightFlagsTwo"],
        TextSize = 10,
        AnchorPoint = vector2New(0, 0)
       })
       


       local AimTextPadding = Variables.Instancenew("UIPadding", esp.holder["RightFlags"]["RightFlagsTwo"]["AimingText"])
       AimTextPadding.PaddingBottom = UDimnew(0, -9)
       AimTextPadding.PaddingRight = UDimnew(0, -25)
       AimTextPadding.PaddingTop = UDimnew(0, -2)



       local InventoryTextPadding = Variables.Instancenew("UIPadding", esp.holder["RightFlags"]["RightFlagsTwo"]["InventoryText"])
       InventoryTextPadding.PaddingTop = UDimnew(0, -4)
       InventoryTextPadding.PaddingRight = UDimnew(0, -48)
     end


     local colorStroke, outerStroke, innerStroke = lib.DrawUIStroke({Parent = esp.holder["Box"]}), lib.DrawUIStroke({Parent = esp.holder["Box"]}), lib.DrawUIStroke({Parent = esp.holder["Box"]})
     esp.itemCache = {}
     esp.UI = {
        GUI = esp.holder;
        PName = esp.holder["PName"];
        Distance = esp.holder["BottomFlags"]["Distance"];
        VisFlag = esp.holder["BottomFlags"]["VisFlag"];
        Weapon = esp.holder["BottomFlags"]["Weapon"];
        HealthText = esp.holder["LeftFlags"]["LeftFlagsTwo"]["HealthText"];
        ManipFlag = esp.holder["BottomFlags"]["ManipFlag"];



        BottomFlags = esp.holder["BottomFlags"];
        LeftFlags = esp.holder["LeftFlags"];
        LeftFlagsTwo = esp.holder["LeftFlags"]["LeftFlagsTwo"];
        RightFlags = esp.holder["RightFlags"];



        bottomListLayout = esp.holder["BottomFlags"]["UIListLayout"];
        leftListLayout = esp.holder["LeftFlags"]["LeftFlagsTwo"]["UIListLayout"];
        HealthTextPadding = esp.holder["LeftFlags"]["LeftFlagsTwo"]["HealthText"]["UIPadding"];



        AimingText = esp.holder["RightFlags"]["RightFlagsTwo"]["AimingText"];
        AimingTextPadding = esp.holder["RightFlags"]["RightFlagsTwo"]["AimingText"]["UIPadding"];
        InventoryText = esp.holder["RightFlags"]["RightFlagsTwo"]["InventoryText"];
        InventoryTextPadding = esp.holder["RightFlags"]["RightFlagsTwo"]["InventoryText"]["UIPadding"];
        
      

        Box = esp.holder["Box"];
        BoxFill = esp.holder["Box"]["BoxFill"];
   
   

        HealthBar = esp.holder["LeftFlags"]["HealthBar"];
        Bar = esp.holder["LeftFlags"]["HealthBar"]["Bar"];
        BarGradient = esp.holder["LeftFlags"]["HealthBar"]["Bar"]["UIGradient"];
     }
     
    
     esp.UI.VisFlag.Text = "Visible"
     esp.UI.AimingText.Text = "Aiming"
     esp.UI.InventoryText.Text = "Searching"
     

     esp.UI.Distance.LayoutOrder = 1
     esp.UI.Weapon.LayoutOrder = 2


     esp.UI.VisFlag.LayoutOrder = 3
     esp.UI.VisFlag.FontFace = Fonts["Minecraftia"]


     esp.UI.ManipFlag.Text = "Manipulated"
     esp.UI.ManipFlag.LayoutOrder = 4
     esp.UI.ManipFlag.Visible = false


     esp.UI.PName.AutomaticSize = Enum.AutomaticSize.Y
     esp.UI.BottomFlags.AutomaticSize = Enum.AutomaticSize.Y


     local VisTextPadding = Variables.Instancenew("UIPadding", esp.holder["BottomFlags"]["VisFlag"])
     VisTextPadding.PaddingBottom = UDimnew(0, 0)
     VisTextPadding.PaddingLeft = UDimnew(0, 0)


     colorStroke.ApplyStrokeMode = "Contextual"
     colorStroke.StrokeSizingMode = "FixedSize"
     colorStroke.LineJoinMode = "Miter"
     colorStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
     colorStroke.ZIndex = 1
     colorStroke.Color = fromRGB(0, 255, 255)


     outerStroke.ApplyStrokeMode =  "Border"
     outerStroke.StrokeSizingMode = "FixedSize"
     outerStroke.LineJoinMode = "Miter"
     outerStroke.BorderStrokePosition = Enum.BorderStrokePosition.Outer
     outerStroke.ZIndex = 0


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
     esp.UI.aimingFlagStroke, esp.UI.inventoryFlagStroke = lib.DrawUIStroke({Parent = esp.UI.AimingText}), lib.DrawUIStroke({Parent = esp.UI.InventoryText})


     local Character = self.Character
     esp.root, esp.humanoid, esp.head = Character:WaitForChild("HumanoidRootPart", 60), Character:WaitForChild("Humanoid", 60), Character:WaitForChild("Head", 60)
    
    
     return espCache[self]
end


local function GetPFromChar(p)
  return Variables.Players:GetPlayerFromCharacter(p)
end


local function newCharacter(Character)
  local v = ESPObject(GetPFromChar(Character))
  ESP.getParts(v, Character)
end


local function destroyESP(Player)
	local cachedPlayer = espCache[Player] or espCache[Player.Name]
  if cachedPlayer then
    cachedPlayer.holder:Destroy()
    cachedPlayer.boneCache = nil
    cachedPlayer = nil
  end
end


local function newPlayer(player)
  --Variables.taskdefer(newCharacter, player.Character)
  if player.Character then
    task.defer(newCharacter, player.Character)
  end

     
  player.CharacterAdded:Connect(newCharacter)
  player.CharacterRemoving:Connect(destroyESP)

end


local function OnRemoved(player)
  if espCache[player] then
    espCache[player].holder:Destroy()
    espCache[player] = nil
  end
end


local function createESP(Player)
  if Player.Character then
  	task.defer(ESPObject, Player)
  end
  
  Player.CharacterAdded:Connect(function(Character)
    task.defer(ESPObject, Player)
  end)
    
  Player.CharacterRemoving:Connect(function(Character)
    task.defer(destroyESP, Player)
  end)
end


function ESP.loadESP()
  

  Variables.Players.PlayerAdded:Connect(createESP)
  Variables.Players.PlayerRemoving:Connect(destroyESP)
  for _, player in Variables.Players:GetPlayers() do
    if player.Name ~= Variables.Players.LocalPlayer.Name then
      task.defer(createESP, player)
    end
  end


  Variables.LocalPlayer.ChildAdded:Connect(function(character) 
    rayOrigin = character:FindFirstChild("Head") or character:WaitForChild("Head")
  end)


  renderESP()
end


return library, themes, ESP, espConnection, espCache
