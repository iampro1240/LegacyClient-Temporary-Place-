local library;
local getService, getFunction, getGCFunction, deepCopy, Variables, Math, FindFirstChild, FindFirstChildOfClass, WorldToViewportPoint = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampro1240/LegacyClient-Temporary-Place-/refs/heads/main/Legacy%20Lua%20Project/Libraries/Services.lua"))()
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
local visualHolder = Instance.new("ScreenGui", gethui())
visualHolder.IgnoreGuiInset = true
visualHolder.Enabled = true


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
  function lib:DrawGradient(properties)
        local obj = Variables.Instancenew("UIGradient")
        obj.Name = "UIGradient"
        obj.Parent = properties.Parent or nil
    
        obj.Rotation = properties.Rotation or 0
        obj.Color = properties.Color or Variables.Color3fromRGB(255, 255, 255)
  end
   
   
  function lib:DrawUIStroke(properties)
       local obj = Variables.Instancenew("UIStroke")
       obj.Parent = properties.Parent
       return obj
  end
   
   
  function lib:DrawText(properties)
       local obj = Variables.Instancenew("TextLabel")
       local stroke = Variables.Instancenew("UIStroke")
       obj.Name = properties.Name
       obj.TextSize = 10
       obj.RichText = true
       stroke.LineJoinMode = Enum.LineJoinMode.Miter
   
       obj.Parent = properties.Parent
       obj.BackgroundTransparency = 1
           
       obj.BorderColor3 = Variables.Color3fromRGB(0, 0, 0)
       obj.BorderSizePixel = 0
   
       obj.TextStrokeTransparency = 1
   	   obj.FontFace = library.font
   
       obj.AnchorPoint = properties.AnchorPoint

       obj.AutomaticSize = Enum.AutomaticSize.Y
       stroke.Parent = obj
  end
   
   
  function lib:DrawFrame(properties)
       local obj = Variables.Instancenew("Frame")
       obj.Name = properties.Name
       obj.Parent = properties.Parent
   
       obj.BackgroundTransparency = properties.BackgroundTransparency
   	   obj.BackgroundColor3 = properties.Color
   	   obj.BorderColor3 = Variables.Color3fromRGB(0, 0, 0)
   
       obj.BorderSizePixel = properties.BorderSizePixel
       obj.Position = properties.Position
       obj.Size = properties.Size
   
       obj.ZIndex = properties.Zindex
       obj.Rotation = properties.Rotation
       obj.AnchorPoint = properties.AnchorPoint
  end
   
   
  function lib:DrawImage(properties)
      local obj = Variables.Instancenew("ImageLabel")
      obj.Name = properties.Name
      obj.Parent = properties.Parent
      obj.Image = properties.Image
   
      obj.BackgroundTransparency = 1
    	obj.BorderColor3 = Variables.Color3fromRGB(0, 0, 0)
   
    	obj.BorderSizePixel = properties.BorderSizePixel
    	obj.Position = properties.Position
    	obj.Size = properties.Size
    
      obj.ZIndex = properties.Zindex
      obj.Rotation = properties.Rotation
      obj.AnchorPoint = properties.AnchorPoint
  end


  function ESP:getWeapon(weapon)
    if weapon then
      return weapon.Name
     else
      return "Hands"
    end
  end


  function ESP:getVis(vis, isVisColor, notVisColor)
    if vis then
      return isVisColor
     else
      return notVisColor
    end
  end
  
  
  function ESP:getManip(manip, isManipColor, notManipColor)
    if manip then
      return isManipColor
     else
      return notManipColor
    end
  end
  
  
  function ESP:getParts(esp, character)
    if not character or character == nil then
      return
    end
  
  
    local folder = Instance.new("Folder", esp.holder)
    for _, part in character:GetChildren() do
        if part:IsA("MeshPart") or part:IsA("Part") then
          if cheat.ValidParts[part.Name] then
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
          esp.chamCacheTwo[part].Color3 = Variables.Color3fromRGB(0, 0, 0)
          esp.chamCacheTwo[part].Name = "BlackedOut"
  
          esp.partCache[part] = part or {part}
        end
    end
  
  end
  
  
  function ESP:getBones(esp, character)
    if not character or character == nil then
      return
    end
  
  
    for _, part in character:GetChildren() do
      if cheat.ValidParts[part.Name] then
        esp.partCache[part] = part or {part}
      end
    end
  
  end
  
  
  function ESP:distanceCheck(distancemag, onScreen)
      if distancemag <= visuals:returnflag("MaxDistance") and onScreen then
         return true
        else
          return false
       end
  end
  
  
  function ESP:vehicleDistanceCheck(distancemag, onScreen)
      if distancemag <= visuals:returnflag("VehicleMaxDistance") and onScreen then
        return true
       else
        return false
      end
  end
  
  
  function ESP:corpseDistanceCheck(distancemag, onScreen)
      if distancemag <= visuals:returnflag("CorpseMaxDistance") and onScreen then
        return true
       else
        return false
      end
  end
  
  
  function ESP:connectBone(Bone, Visible, From, To, Thickness, Color, Zindex)
      Bone.Visible = Visible
      Bone.From = From
      Bone.To = To
      Bone.Thickness = Thickness
      Bone.Color = Color
      Bone.ZIndex = Zindex
  end
  
  
  function ESP:getBoneValue(cache, bonePart, value)
      return cache[bonePart][value]
  end
  
  
  function ESP:setBoneVis(cache, visible)
      for _, item in cache do
          item.Line.Visible = visible
          item.Outline.Visible = visible
      end
  end
  
  
  function ESP:color3ToHex(color)
      local r = Math.floor(color.R * 255)
      local g = Math.floor(color.G * 255)
      local b = Math.floor(color.B * 255)
     return string.format("#%02X%02X%02X", r, g, b)
  end
  
  
  function ESP:lerp(a, b, t)
    	return a + (b - a) * t
  end
    
  
  function ESP:applyPulseSequence(originalKeypoints, t)
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
  function visuals:returnflag(flag)
    return library.flags[flag]
  end

   
  function visuals:returnflagcolor(color)
    return visuals:returnflag(color).Color
  end
   

  function visuals:returnflagtransparency(color)
    return visuals:returnflag(color).Alpha or visuals:returnflag(color).Transparency
  end
end


local function renderESP()
    local visParams = RaycastParams.new()
    local lastTick = os.clock()
    local animationSpeed = 1


    local healthBarPadding = ESP.healthBarSettings[visuals:returnflag("HealthBarPadding")].Padding
    local currentTextFont, flagFont = visuals:returnflag("TextFont"), visuals:returnflag("TextFlagFont")


    local textFont = Fonts[currentTextFont]
    local textSettings = ESP.fontSettings[currentTextFont]
    
    
    local isHealthBarGradient = visuals:returnflag("HealthbarGradient")
    local healthBarPaddingSize = ESP.healthBarSettings[visuals:returnflag("HealthBarPadding")].Size


    local UseDisplayName = visuals:returnflag("UseDisplayName") 
    local textFlagFont = ESP.fontSettings[flagFont]


    local lastShotUpdate = tick()
    local waitTime
    
    
    espConnection = Variables.RunService.PreRender:Connect(function(deltatime)
      visParams.FilterType = Enum.RaycastFilterType.Exclude
      visParams.IgnoreWater = false
      visParams.CollisionGroup = "Default"


      local isFadeOnDistance, maxFadeDistance, minFadeDistance, maxFadeTransparency = visuals:returnflag("fadeOnDistance"), visuals:returnflag("MaxFadeDistance"), visuals:returnflag("MinFadeDistance"), visuals:returnflag("maxFadeTransparency")
      local isHealthText, healthTextColor = visuals:returnflag("HealthText"), visuals:returnflagcolor("Health_Text_Color")
      
      
      local isAimingText, isAimingColor, notAimingColor = visuals:returnflag("AimingText"), visuals:returnflagcolor("Aiming_Color"), visuals:returnflagcolor("Not_Aiming_Color")
      local isInventoryText, isInventoryColor, notInventoryColor  = visuals:returnflag("InventoryText"), visuals:returnflagcolor("Inventory_Color"), visuals:returnflagcolor("Not_Inventory_Color")
          
              
      local isName, nameColor  = visuals:returnflag("Names"), visuals:returnflagcolor("Name_Color")
      local isDistance, distanceColor, distanceType = visuals:returnflag("Distance"), visuals:returnflagcolor("Distance_Color"), visuals:returnflag("DistanceType")
          
              
      local isWeapon, weaponColor = visuals:returnflag("Weapon"), visuals:returnflagcolor("Weapon_Color")
      local isVisible, isVisColor, notVisColor = visuals:returnflag("Vis"), visuals:returnflagcolor("Vis_Color"), visuals:returnflagcolor("Not_Vis_Color")


      local isSkeleton, boneThickness, outlineThickness, boneColor, outlineColor, boneZIndex, outlineZIndex = visuals:returnflag("skeletonEnabled"), 1, 3, visuals:returnflagcolor("boneColor"), Color3.fromRGB(0, 0, 0), 2, 1
      local isBoxVis, isBoxFill, boxColor, fillRotation = visuals:returnflag("Boxes"), visuals:returnflag("BoxFill"), visuals:returnflagcolor("Box_Color"), visuals:returnflag("FillRotation")
      local isHealthBar = visuals:returnflag("Healthbar")


      local boxFillColorOneC, boxFillColorTwoC, boxFillColorOneT, boxFillColorTwoT = visuals:returnflagcolor("Box_Fill_Color"), visuals:returnflagcolor("Box_Fill_ColorTwo"), visuals:returnflagtransparency("Box_Fill_Color"), visuals:returnflagtransparency("Box_Fill_ColorTwo")
      local barGradientOne, barGradientTwo = visuals:returnflagcolor("GradientColor1"), visuals:returnflagcolor("GradientColor2")


      local isChams, chamOutlineTransparency, chamFillColor, chamOutlineColor = visuals:returnflag("Chams"), visuals:returnflagtransparency("Cham_Outline_Color"), visuals:returnflagcolor("Cham_Color"), visuals:returnflagcolor("Cham_Outline_Color")
      local isEnabled = visuals:returnflag("EnableAll")


      local barGradientPattern = Variables.NewGradient{Variables.GradientNumberSequence(0, barGradientOne), Variables.GradientNumberSequence(1, barGradientTwo)}
      local fillGradientTransparency = Variables.NumberSequence{NumberSequenceKeypoint.new(0, boxFillColorOneT), NumberSequenceKeypoint.new(1, boxFillColorTwoT)}
      local fillGradientColor = Variables.NewGradient{Variables.GradientNumberSequence(0, boxFillColorOneC), Variables.GradientNumberSequence(1, boxFillColorTwoC)}


      local espLimit = visuals:returnflag("espLimit")
      local isHBE = visuals:returnflag("hitboxExpander")
      local isGradientSpin, gradientAnimationSpeed = visuals:returnflag("gradientSpin"), visuals:returnflag("gradientAnimationSpeed")


      local currentTextFont, flagFont = visuals:returnflag("TextFont"), visuals:returnflag("TextFlagFont")
      local textFont = Fonts[currentTextFont]
      local textSettings = cheat.fontSettings[currentTextFont]

      
      local Client = Variables.Players.LocalPlayer
      local clientCharacter, rayOrigin = Client.Character
      local cameraPos = Variables.Camera.CFrame.Position
      

      if clientCharacter then
        rayOrigin = clientCharacter.Head
       else
        rayOrigin = nil
      end
      
       
      for _, player in espCache do
          local timeElapsed = 0
          local currentTick = clock()

          
          local elapsed = currentTick - lastTick
          timeElapsed += deltatime
      
      
          lastTick += deltatime
        	if (lastTick < 1 / espLimit) then
        		return
        	end
        	lastTick = 0


            local holder = player
            local esp, UI, partCache, boneCache, chamCache, chamCacheTwo = holder.holder, holder.UI, holder.partCache, holder.boneCache, holder.chamCache, holder.chamCacheTwo
            local character = holder.Character


            local chams = holder.chamsholder
            if not Client.Character or not character then
              esp.Visible = false
              visuals:setBoneVis(boneCache, false)
             continue
            end


            local head, root, humanoid = holder.head, holder.root, holder.humanoid
            if not isEnabled or not head or not root or not humanoid then
              esp.Visible = false
             continue
            end
  
                
            local rootPos = root.Position
            local pos2, isRootVis = WorldToViewportPoint(Camera, rootPos)
  
                
            local distancemag = Math.floor((rootPos - cameraPos).Magnitude)
            local canSee = ESP:distanceCheck(distancemag, isRootVis)
            
  
            local healthCheck, maxHealth = humanoid.Health, humanoid.MaxHealth
            if not isRootVis or not canSee or healthCheck <= 0 then
              esp.Visible = false
              visuals:setBoneVis(boneCache, false)
             continue
            end
            
            
            local leftFlags, leftListLayout = UI.LeftFlags, UI.leftListLayout
            local rightFlags, rightListLayout = UI.RightFlags, UI.rightListLayout
    
                
            local top2D, isTopVisible
            local bottom2D, isBottomVisible
            local newSize, halfHeight
  
                
            if distancemag <= 500 and not isHBE then
               newSize = character:GetExtentsSize()
               halfHeight = Variables.Vector3new(0, newSize.Y / 2.5, 0)
          
               top2D, isTopVisible = WorldToViewportPoint(Camera, rootPos + halfHeight)
               bottom2D, isBottomVisible = WorldToViewportPoint(Camera, rootPos - halfHeight)
             else
               halfHeight = (root.Size.X + root.Size.Y) / 1.5
               top2D, isTopVisible = WorldToViewportPoint(Camera, rootPos + Variables.Vector3new(0, halfHeight, 0))
               bottom2D, isBottomVisible = WorldToViewportPoint(Camera, rootPos - Variables.Vector3new(0, halfHeight, 0))
            end
  
                
            local isPlayerVis, isPlayerManip = holder.playerVis, holder.playerManip
            local nameText, distanceText, weaponText, visFlag, manipFlag, healthFlag, aimingFlag, inventoryFlag = UI.PName, UI.Distance, UI.Weapon, UI.VisFlag, UI.ManipFlag, UI.HealthText, UI.AimingText, UI.InventoryText
            

            local highlightCham = holder.highlight
            local healthTextPadding = UI.HealthTextPadding

            
            local healthBar, bar, barGradient = UI.HealthBar, UI.Bar
            local weapon = holder.weapon or "Empty"
  
                
            local centerX = top2D.X
            local centerY = top2D.Y


            local bottomY = bottom2D.Y
            local height = (bottomY - centerY)
              
                
            local width = (height * .6) 
            local boxYSize = (height * 1.16 + 7)
            local posClamp = Math.floor(centerY - height * .019)
  
                
            local boxTotalWidth = Math.floor(width * 1.16 + 5)
            local halfBoxWidth = Math.floor(boxTotalWidth * .5)


            local boxLeftX = Math.floor(centerX - halfBoxWidth)
            local boxRightX = boxLeftX + boxTotalWidth
            

            do
              esp.Visible = true
            end
          

            do --// Texts
                do --// Name
                 nameText.Visible = isName
                 nameText.Position = Variables.UDim2fromOffset(centerX, posClamp - textSettings.namePadding)
                 nameText.TextColor3 = nameColor
                 nameText.FontFace = textFont
                 nameText.TextSize = textSettings.FontSize
                
      
                 if UseDisplayName then
                   nameText.Text = player.Player.DisplayName
                  else
                   nameText.Text = player.Player.Name
                 end
        

                end
    
  
                do --// Distance
                 distanceText.Visible = isDistance
                 distanceText.Text = distancemag .. distanceType
                 distanceText.TextColor3 = distanceColor
                 distanceText.FontFace = textFont
                 distanceText.TextSize = textSettings.FontSize
                end
    
    
                do -- Weapon
                 weaponText.Visible = isWeapon
                 weaponText.TextColor3 = weaponColor
                 weaponText.Text = weapon
                 weaponText.FontFace = textFont
                 weaponText.TextSize = textSettings.FontSize
                end
    
  
                do --// Vis Check
                  visFlag.Visible = isVisible
                  visFlag.FontFace = textFont


                  visFlag.TextSize = textSettings.FontSize
                  visParams.FilterDescendantsInstances = {clientCharacter, rayOrigin, character}
                  

                  if isVisible and rayOrigin then
                    local visCheck = Variables.Workspace:Raycast(rayOrigin.Position, (head.Position - rayOrigin.Position), visParams)
                    visFlag.TextColor3 = ESP:getVis(isPlayerVis, isVisColor, notVisColor)
                    if not visCheck then
                        player.playerVis = true
                      elseif visCheck.Instance == head or visCheck.Instance.Parent == head.Parent then
                        player.playerVis = true
                      else
                        player.playerVis = false
                    end
                  end

                end
    
  
                do --// Manip
                 manipFlag.Visible = false
                end
               

                do --// Misc Flags
                  
              
                  -- Update animation if enough time has passed
                  if elapsed >= 1 / elapsed * animationSpeed then
                    local cutOff = Math.clamp((distancemag-250)/(330-250), 0, 1)
                    aimingFlag.Transparency = cutOff
                    aimingFlag["UIStroke"].Transparency = cutOff

                    inventoryFlag.Transparency = cutOff
                    inventoryFlag["UIStroke"].Transparency = cutOff


                    if isFadeOnDistance then
                      local cutOff = Math.clamp((distancemag-minFadeDistance)/(maxFadeDistance-minFadeDistance), 0, maxFadeTransparency)
                      nameText.Transparency = cutOff
                      nameText["UIStroke"].Transparency = cutOff
  
                      distanceText.Transparency = cutOff
                      distanceText["UIStroke"].Transparency = cutOff
  
                      weaponText.Transparency = cutOff
                      weaponText["UIStroke"].Transparency = cutOff
  
  
                      visFlag.Transparency = cutOff
                      visFlag["UIStroke"].Transparency = cutOff
  
                      manipFlag.Transparency = cutOff
                      manipFlag["UIStroke"].Transparency = cutOff
  
                      healthFlag.Transparency = cutOff
                      healthFlag["UIStroke"].Transparency = cutOff
  
                      UI.topColor.Transparency = cutOff
                      UI.outerStroke.Transparency = cutOff
                      UI.innerStroke.Transparency = cutOff
  
                      healthBar.Transparency = cutOff
                      healthBar["UIStroke"].Transparency = cutOff
  
                      bar.Transparency = cutOff
                     else
                      nameText.Transparency = 0
                      nameText["UIStroke"].Transparency = 0
  
                      distanceText.Transparency = 0
                      distanceText["UIStroke"].Transparency = 0
  
                      weaponText.Transparency = 0
                      weaponText["UIStroke"].Transparency = 0
  
  
                      visFlag.Transparency = 0
                      visFlag["UIStroke"].Transparency = 0
  
                      manipFlag.Transparency = 0
                      manipFlag["UIStroke"].Transparency = 0
  
                      healthFlag.Transparency = 0
                      healthFlag["UIStroke"].Transparency = 0
  
                      UI.topColor.Transparency = 0
                      UI.outerStroke.Transparency = 0
                      UI.innerStroke.Transparency = 0
  
                      healthBar.Transparency = 0
                      healthBar["UIStroke"].Transparency = 0
  
                      bar.Transparency = 0

                    end


                  end


                  healthFlag.Visible = isHealthText
                  healthFlag.TextColor3 = healthTextColor
                  healthFlag.Text = Math.floor(healthCheck)
                  

                  aimingFlag.Visible = isAimingText
                  aimingFlag.TextColor3 = ESP:getVis(true, isAimingColor, notAimingColor)
                 

                  inventoryFlag.Visible = isInventoryText
                  inventoryFlag.TextColor3 = ESP:getVis(true, isInventoryColor, notInventoryColor)
                  inventoryFlag.TextSize = textFlagFont.FontSize
                end
                

                UI.BottomFlags.Position = Variables.UDim2fromOffset(centerX, Math.floor( posClamp + boxYSize + textSettings.bottomPadding))
                UI.bottomListLayout.Padding = Variables.UDimnew(0, textSettings.bottomListLayoutPadding)
            end

               
            do --// Skeleton

              if isSkeleton then
                visuals:setBoneVis(boneCache, true)
                local upperTorso, lowerTorso = visuals:getBoneValue(boneCache, "UpperTorso", "Part"), visuals:getBoneValue(boneCache, "LowerTorso", "Part")
                  
                  local headPos, headBone, headOutline = WorldToViewportPoint(Camera, head.Position - Variables.Vector3new(0, .5, 0)), visuals:getBoneValue(boneCache, "Head", "Line"), visuals:getBoneValue(boneCache, "Head", "Outline")
                  local upperTorsoPos, upperTorsoBone, upperTorsoOutline = WorldToViewportPoint(Camera, upperTorso.Position), visuals:getBoneValue(boneCache, "UpperTorso", "Line"), visuals:getBoneValue(boneCache, "UpperTorso", "Outline")
                  local lowerTorsoPos, lowerTorsoBone, lowerTorsoOutline = WorldToViewportPoint(Camera, lowerTorso.Position), visuals:getBoneValue(boneCache, "LowerTorso", "Line"), visuals:getBoneValue(boneCache, "LowerTorso", "Outline")
              

                  do --// Torso
                      visuals:connectBone(headBone, isSkeleton and isRootVis, Vector2.new(headPos.X, headPos.Y), Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(headOutline, isSkeleton and isRootVis, Vector2.new(headPos.X, headPos.Y), Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      visuals:connectBone(upperTorsoBone, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(upperTorsoOutline, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), outlineThickness, outlineColor, outlineZIndex)
                  end
              

                  do --// Left Arm
                      local leftUpperArm, leftLowerArm, leftHand = visuals:getBoneValue(boneCache, "LeftUpperArm", "Part"), visuals:getBoneValue(boneCache, "LeftLowerArm", "Part"), visuals:getBoneValue(boneCache, "LeftHand", "Part")
              
                      local leftUpperArmPos, leftUpperArmBone, leftUpperArmOutline = WorldToViewportPoint(Camera, leftUpperArm.Position + Variables.Vector3new(0, .5, 0)), visuals:getBoneValue(boneCache, "LeftUpperArm", "Line"), visuals:getBoneValue(boneCache, "LeftUpperArm", "Outline")
                      local leftLowerArmPos, leftLowerArmBone, leftLowerArmOutline = WorldToViewportPoint(Camera, leftLowerArm.Position), visuals:getBoneValue(boneCache, "LeftLowerArm", "Line"), visuals:getBoneValue(boneCache, "LeftLowerArm", "Outline")
                      local leftHandPos, leftHandBone, leftHandOutline = WorldToViewportPoint(Camera, leftHand.Position), visuals:getBoneValue(boneCache, "LeftHand", "Line"), visuals:getBoneValue(boneCache, "LeftHand", "Outline")
              
                      visuals:connectBone(leftUpperArmBone, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(leftUpperArmPos.X, leftUpperArmPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(leftUpperArmOutline, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(leftUpperArmPos.X, leftUpperArmPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      visuals:connectBone(leftLowerArmBone, isSkeleton and isRootVis, Vector2.new(leftUpperArmPos.X, leftUpperArmPos.Y), Vector2.new(leftLowerArmPos.X, leftLowerArmPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(leftLowerArmOutline, isSkeleton and isRootVis, Vector2.new(leftUpperArmPos.X, leftUpperArmPos.Y), Vector2.new(leftLowerArmPos.X, leftLowerArmPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      visuals:connectBone(leftHandBone, isSkeleton and isRootVis, Vector2.new(leftLowerArmPos.X, leftLowerArmPos.Y), Vector2.new(leftHandPos.X, leftHandPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(leftHandOutline, isSkeleton and isRootVis, Vector2.new(leftLowerArmPos.X, leftLowerArmPos.Y), Vector2.new(leftHandPos.X, leftHandPos.Y), outlineThickness, outlineColor, outlineZIndex)
                  end
              

                  do --// Right Arm
                      local rightUpperArm, rightLowerArm, rightHand = visuals:getBoneValue(boneCache, "RightUpperArm", "Part"), visuals:getBoneValue(boneCache, "RightLowerArm", "Part"), visuals:getBoneValue(boneCache, "RightHand", "Part")
              
                      local rightUpperArmPos, rightUpperArmBone, rightUpperArmOutline = WorldToViewportPoint(Camera, rightUpperArm.Position + Variables.Vector3new(0, .5, 0)), visuals:getBoneValue(boneCache, "RightUpperArm", "Line"), visuals:getBoneValue(boneCache, "RightUpperArm", "Outline")
                      local rightLowerArmPos, rightLowerArmBone, rightLowerArmOutline = WorldToViewportPoint(Camera, rightLowerArm.Position), visuals:getBoneValue(boneCache, "RightLowerArm", "Line"), visuals:getBoneValue(boneCache, "RightLowerArm", "Outline")
                      local rightHandPos, rightHandBone, rightHandOutline = WorldToViewportPoint(Camera, rightHand.Position), visuals:getBoneValue(boneCache, "RightHand", "Line"), visuals:getBoneValue(boneCache, "RightHand", "Outline")
              
                      visuals:connectBone(rightUpperArmBone, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(rightUpperArmPos.X, rightUpperArmPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(rightUpperArmOutline, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(rightUpperArmPos.X, rightUpperArmPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      visuals:connectBone(rightLowerArmBone, isSkeleton and isRootVis, Vector2.new(rightUpperArmPos.X, rightUpperArmPos.Y), Vector2.new(rightLowerArmPos.X, rightLowerArmPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(rightLowerArmOutline, isSkeleton and isRootVis, Vector2.new(rightUpperArmPos.X, rightUpperArmPos.Y), Vector2.new(rightLowerArmPos.X, rightLowerArmPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      visuals:connectBone(rightHandBone, isSkeleton and isRootVis, Vector2.new(rightLowerArmPos.X, rightLowerArmPos.Y), Vector2.new(rightHandPos.X, rightHandPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(rightHandOutline, isSkeleton and isRootVis, Vector2.new(rightLowerArmPos.X, rightLowerArmPos.Y), Vector2.new(rightHandPos.X, rightHandPos.Y), outlineThickness, outlineColor, outlineZIndex)
                  end
                  

                  do --// Left Leg
                      local leftUpperLeg, leftLowerLeg, leftFoot = visuals:getBoneValue(boneCache, "LeftUpperLeg", "Part"), visuals:getBoneValue(boneCache, "LeftLowerLeg", "Part"), visuals:getBoneValue(boneCache, "LeftFoot", "Part")
              
                      local leftUpperLegPos, leftUpperLegBone, leftUpperLegOutline = WorldToViewportPoint(Camera, leftUpperLeg.Position + Variables.Vector3new(0, .5, 0)), visuals:getBoneValue(boneCache, "LeftUpperLeg", "Line"), visuals:getBoneValue(boneCache, "LeftUpperLeg", "Outline")
                      local leftLowerLegPos, leftLowerLegBone, leftLowerLegOutline = WorldToViewportPoint(Camera, leftLowerLeg.Position), visuals:getBoneValue(boneCache, "LeftLowerLeg", "Line"), visuals:getBoneValue(boneCache, "LeftLowerLeg", "Outline")
                      local leftFootPos, leftFootBone, leftFootOutline = WorldToViewportPoint(Camera, leftFoot.Position), visuals:getBoneValue(boneCache, "LeftFoot", "Line"), visuals:getBoneValue(boneCache, "LeftFoot", "Outline")
              
                      visuals:connectBone(leftUpperLegBone, isSkeleton and isRootVis, Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(leftUpperLegOutline, isSkeleton and isRootVis, Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      visuals:connectBone(leftLowerLegBone, isSkeleton and isRootVis, Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y), Vector2.new(leftLowerLegPos.X, leftLowerLegPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(leftLowerLegOutline, isSkeleton and isRootVis, Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y), Vector2.new(leftLowerLegPos.X, leftLowerLegPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      visuals:connectBone(leftFootBone, isSkeleton and isRootVis, Vector2.new(leftLowerLegPos.X, leftLowerLegPos.Y), Vector2.new(leftFootPos.X, leftFootPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(leftFootOutline, isSkeleton and isRootVis, Vector2.new(leftLowerLegPos.X, leftLowerLegPos.Y), Vector2.new(leftFootPos.X, leftFootPos.Y), outlineThickness, outlineColor, outlineZIndex)
                  end
              

                  do --// Right Leg
                      local rightUpperLeg, rightLowerLeg, rightFoot = visuals:getBoneValue(boneCache, "RightUpperLeg", "Part"), visuals:getBoneValue(boneCache, "RightLowerLeg", "Part"), visuals:getBoneValue(boneCache, "RightFoot", "Part")
              
                      local rightUpperLegPos, rightUpperLegBone, rightUpperLegOutline = WorldToViewportPoint(Camera, rightUpperLeg.Position + Variables.Vector3new(0, .5, 0)), visuals:getBoneValue(boneCache, "RightUpperLeg", "Line"), visuals:getBoneValue(boneCache, "RightUpperLeg", "Outline")
                      local rightLowerLegPos, rightLowerLegBone, rightLowerLegOutline = WorldToViewportPoint(Camera, rightLowerLeg.Position), visuals:getBoneValue(boneCache, "RightLowerLeg", "Line"), visuals:getBoneValue(boneCache, "RightLowerLeg", "Outline")
                      local rightFootPos, rightFootBone, rightFootOutline = WorldToViewportPoint(Camera, rightFoot.Position), visuals:getBoneValue(boneCache, "RightFoot", "Line"), visuals:getBoneValue(boneCache, "RightFoot", "Outline")
              
                      visuals:connectBone(rightUpperLegBone, isSkeleton and isRootVis, Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(rightUpperLegOutline, isSkeleton and isRootVis, Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      visuals:connectBone(rightLowerLegBone, isSkeleton and isRootVis, Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y), Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(rightLowerLegOutline, isSkeleton and isRootVis, Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y), Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      visuals:connectBone(rightFootBone, isSkeleton and isRootVis, Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y), Vector2.new(rightFootPos.X, rightFootPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(rightFootOutline, isSkeleton and isRootVis, Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y), Vector2.new(rightFootPos.X, rightFootPos.Y), outlineThickness, outlineColor, outlineZIndex)
                  end
               else
                  visuals:setBoneVis(boneCache, false)
              end
                  
            end
                

            do --// Right Flags
              rightFlags.Position = Variables.UDim2fromOffset(boxRightX + healthBarPadding, posClamp)
              rightFlags.Size = Variables.UDim2fromOffset(1, boxYSize)
            end


            do --// Other
                local healthBar, bar, barGradient = UI.HealthBar, UI.Bar, UI.BarGradient
                local box, boxFill = UI.Box, UI.BoxFill


                do -- Box
                    box.Visible = isBoxVis
                    box.Position = Variables.UDim2new(0, centerX, 0, posClamp)
                    box.Size = Variables.UDim2new(0, boxTotalWidth, 0, boxYSize)
                    UI.topColor.Color = boxColor
                    
                    
                    boxFill.Visible = isBoxVis and isBoxFill
                    boxFill.UIGradient.Color = fillGradientColor
                   

                    boxFill.UIGradient.Transparency = fillGradientTransparency
                    if isGradientSpin then
                      if elapsed >= 1 / elapsed * gradientAnimationSpeed then
                       boxFill.UIGradient.Rotation += visuals:returnflag("gradientAnimationSpeed")
                      end
                     else
                      boxFill.UIGradient.Rotation = fillRotation
                    end

                end
             
  
                do -- Health Bar
                  leftListLayout.Padding = Variables.UDimnew(0, textSettings.leftListLayoutPadding)
                  healthBar.Visible = isHealthBar


                  healthBar.Size = Variables.UDim2new(0, healthBarPaddingSize, 0, boxYSize)
                  leftFlags.Size = Variables.UDim2fromOffset(-1, boxYSize)
                  bar.Size = Variables.UDim2new(1, 0, healthCheck / maxHealth, 0)
                   
                   
                  leftFlags.Position = Variables.UDim2fromOffset(boxLeftX - healthBarPadding, posClamp)
                  barGradient.Color = barGradientPattern
                end
    
    
                do -- Chams
                  highlightCham.Enabled = isChams
                  highlightCham.OutlineTransparency = chamOutlineTransparency
                  highlightCham.FillColor = chamFillColor
                  highlightCham.OutlineColor = chamOutlineColor
                end


            end


            for place = 1, #UI do
              if text:IsA("TextLabel") or not text.Visible then
                continue
              end
               

              if tonumber(place) < text.LayoutOrder then
                text.LayoutOrder -= 1
               else
                ext.LayoutOrder += 1
              end
                
            end
      end

    end)


end


local function ESPObject(self)
     espCache[self] = {Name = self.Name, Player = self, Character = self.Character, holder = Variables.Instancenew("Frame", visualHolder), playerVis = false, playerManip = false, partCache = {}, boneCache = {}, chamCache = {}, chamCacheTwo = {}, headDrawing = Drawing.new("Circle"), headDrawingOutline = Drawing.new("Circle"), connection, Colors = Variables.Instancenew("Folder"), Borders = Variables.Instancenew("Folder"), chamsholder = Variables.Instancenew("Folder"), highlight = Variables.Instancenew("Highlight", visualHolder)}
     local esp, player = espCache[self], espCache[self]
     local Colors = esp.Colors
     local Borders = esp.Borders 
     local espholder, cache, chamsholder, esphighlight = esp.holder, esp.cache, esp.chamsholder, esp.highlight
                
   
     espholder.Name = self.Name
     espholder.Visible = false
   
     chamsholder.Parent = espholder
     --esphighlight.Parent = espholder
   
   
     Colors.Parent = espholder
     Borders.Parent = espholder
     Colors.Name = "Colors"
     Borders.Name = "Borders"
   

   
     do -- main text
       lib:DrawFrame({
        Name = "BottomFlags",
        Parent = esp.holder,
        Color = Variables.Color3fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = Variables.UDim2new(0, 632, 0, 569),
        Size = Variables.UDim2new({0.062, 0},{0.126, 0}),
        Zindex = 9999999999,
        Rotation = 0,
        AnchorPoint = Variables.Vector2new(0, 0)
       })
   
   
   
       lib:DrawText({
        Name = "PName", 
   		  Parent = esp.holder,
        TextSize = 10,
        AnchorPoint = Variables.Vector2new(0, 0)
       })

   
   
       lib:DrawText({
        Name = "Distance", 
   		  Parent = esp.holder["BottomFlags"],
        TextSize = 10,
        AnchorPoint = Variables.Vector2new(0, 0)
       })
   
   
       lib:DrawText({
        Name = "Weapon", 
   		  Parent = esp.holder["BottomFlags"],
        TextSize = 10,
        AnchorPoint = Variables.Vector2new(0, 0)
       })


       lib:DrawText({
        Name = "VisFlag", 
   		  Parent = esp.holder["BottomFlags"],
        TextSize = 10,
        AnchorPoint = Variables.Vector2new(0, 0)
       })


       lib:DrawText({
        Name = "ManipFlag", 
   		  Parent = esp.holder["BottomFlags"],
        TextSize = 10,
        AnchorPoint = Variables.Vector2new(0, 0)
       })
       


       local listLayout = Variables.Instancenew("UIListLayout", esp.holder["BottomFlags"])
       local uiPadding = Variables.Instancenew("UIPadding", esp.holder["BottomFlags"])
       listLayout.Padding = Variables.UDimnew(0, 11)
       listLayout.VerticalAlignment = "Top"
       listLayout.HorizontalAlignment = "Center"
       listLayout.ItemLineAlignment = "Center"
       listLayout.SortOrder = "LayoutOrder"
       uiPadding.PaddingBottom = Variables.UDimnew(1, 0)


       local weaponPadding, distancePadding = Variables.Instancenew("UIPadding", esp.holder["BottomFlags"]["Weapon"]), Variables.Instancenew("UIPadding", esp.holder["BottomFlags"]["Distance"])
       --weaponPadding.PaddingBottom = UDimnew(-0.23, 0)
       --weaponPadding.PaddingTop = UDimnew(-0.15, 0)


       --distancePadding.PaddingBottom = Variables.UDimnew(-0.32, 0)
       --distancePadding.PaddingTop = Variables.UDimnew(-0.15, 0)
   
   
     end
   
   

     do -- box
       lib:DrawFrame({
           Name = "Box",
           Parent = esp.holder,
           Color = Variables.Color3fromRGB(255, 255, 255),
           BackgroundTransparency = 1,
           BorderSizePixel = 1,
           Position = Variables.UDim2new(0.17, 0, 0.12, 0),
           Size = Variables.UDim2new(0.65, 0, 0.88, 0),
           Zindex = 5,
           Rotation = 0,
           AnchorPoint = Variables.Vector2new(.5, 0),
       })



       lib:DrawFrame({
           Name = "BoxFill",
           Parent = esp.holder["Box"],
           Color = Variables.Color3fromRGB(255, 255, 255),
           BackgroundTransparency = 1,
           BorderSizePixel = 1,
           Position = Variables.UDim2new(0, 0, 0, 0),
           Size = Variables.UDim2new(1, 0, 1, 0),
           Zindex = -5,
           Rotation = 0,
           AnchorPoint = Variables.Vector2new(0, 0),
       })



       lib:DrawGradient({
          Parent = esp.holder["Box"]["BoxFill"],
          Rotation = -90,
          Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Variables.Color3fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Variables.Color3fromRGB(255, 255, 255))},
          Transparency = 0
       })
   
   
   
       Colors.Parent = esp.holder["Box"]
       Borders.Parent = esp.holder["Box"]
   
   
     end
   
   

     do -- HealthBar
      lib:DrawFrame({
        Name = "LeftFlags",
        Parent = esp.holder,
        Color = Variables.Color3fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = Variables.UDim2new(0, 632, 0, 569),
        Size = Variables.UDim2new({0.062, 0},{0.126, 0}),
        Zindex = 9999999999,
        Rotation = 0,
        AnchorPoint = Variables.Vector2new(0, 0)
       })



       lib:DrawFrame({
        Name = "LeftFlagsTwo",
        Parent = esp.holder["LeftFlags"],
        Color = Variables.Color3fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = Variables.UDim2new(0, 632, 0, 569),
        Size = Variables.UDim2new({0.062, 0},{0.126, 0}),
        Zindex = 9999999999,
        Rotation = 0,
        AnchorPoint = Variables.Vector2new(0, 0)
       })

       

       local listLayout = Variables.Instancenew("UIListLayout", esp.holder["LeftFlags"])
       listLayout.Padding = Variables.UDimnew(0, -6)
       listLayout.FillDirection = "Horizontal"
       listLayout.HorizontalAlignment = "Left"
       listLayout.HorizontalFlex = "None"
       listLayout.VerticalAlignment = "Top"
       listLayout.ItemLineAlignment = "Start"



       local listLayout2 = Variables.Instancenew("UIListLayout", esp.holder["LeftFlags"]["LeftFlagsTwo"])
       listLayout2.Padding = Variables.UDimnew(0, 10)
       listLayout2.FillDirection = "Vertical"
       listLayout2.HorizontalAlignment = "Left"
       listLayout2.HorizontalFlex = "None"
       listLayout2.VerticalAlignment = "Top"
       listLayout2.ItemLineAlignment = "Start"

       

       lib:DrawFrame({
           Name = "HealthBar",
           Parent = esp.holder["LeftFlags"],
           --Parent = esp.holder,
           Color = Variables.Color3fromRGB(0, 0, 0),
           BackgroundTransparency = 0,
           BorderSizePixel = 0,
           Position = Variables.UDim2new(0.17, 0, 0.12, 0),
           Size = Variables.UDim2new(0.65, 0, 0.88, 0),
           Zindex = 9999999999,
           Rotation = 0,
           AnchorPoint = Variables.Vector2new(.5, 0),
       })
       
   
       lib:DrawFrame({
           Name = "Bar",
           Parent = esp.holder["LeftFlags"]["HealthBar"],
           Color = Variables.Color3fromRGB(255, 255, 255),
           BackgroundTransparency = 0,
           BorderSizePixel = 0,
           Position = Variables.UDim2new(0, 0, 1, 0),
           Size = Variables.UDim2new(1, 0, 1, 0),
           Zindex = 9999999999,
           Rotation = 0,
           AnchorPoint = Variables.Vector2new(0, 1)
       })
      

       lib:DrawText({
        Name = "HealthText", 
   		  Parent = esp.holder["LeftFlags"]["LeftFlagsTwo"],
        TextSize = 10,
        AnchorPoint = Variables.Vector2new(0, 0)
       })


       local HealthTextPadding = Variables.Instancenew("UIPadding", esp.holder["LeftFlags"]["LeftFlagsTwo"]["HealthText"])
       HealthTextPadding.PaddingBottom = Variables.UDimnew(.3, 0)
       HealthTextPadding.PaddingLeft = Variables.UDimnew(0, -12)


       local healthBarStroke = lib:DrawUIStroke({Parent = esp.holder["LeftFlags"]["HealthBar"]})
       healthBarStroke.LineJoinMode = "Miter"

   
       lib:DrawGradient({
          Parent = esp.holder["LeftFlags"]["HealthBar"]["Bar"],
          Rotation = -90,
          Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Variables.Color3fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Variables.Color3fromRGB(255, 255, 255))}
       })
     end



     do -- Right Flags
      lib:DrawFrame({
        Name = "RightFlags",
        Parent = esp.holder,
        Color = Variables.Color3fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = Variables.UDim2new(0, 632, 0, 569),
        Size = Variables.UDim2new({0.062, 0},{0.126, 0}),
        Zindex = 9999999999,
        Rotation = 0,
        AnchorPoint = Variables.Vector2new(0, 0)
       })



       lib:DrawFrame({
        Name = "RightFlagsTwo",
        Parent = esp.holder["RightFlags"],
        Color = Variables.Color3fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = Variables.UDim2new(0, 632, 0, 569),
        Size = Variables.UDim2new({0.062, 0},{0.126, 0}),
        Zindex = 9999999999,
        Rotation = 0,
        AnchorPoint = Variables.Vector2new(0, 0)
       })



       local listLayout = Variables.Instancenew("UIListLayout", esp.holder["RightFlags"])
       listLayout.Padding = Variables.UDimnew(0, 0)
       listLayout.FillDirection = "Horizontal"
       listLayout.HorizontalAlignment = "Right"
       listLayout.HorizontalFlex = "None"
       listLayout.VerticalAlignment = "Top"
       listLayout.ItemLineAlignment = "Start"



       local listLayout2 = Variables.Instancenew("UIListLayout", esp.holder["RightFlags"]["RightFlagsTwo"])
       listLayout2.Padding = Variables.UDimnew(0, 10)
       listLayout2.FillDirection = "Vertical"
       listLayout2.HorizontalAlignment = "Right"
       listLayout2.HorizontalFlex = "None"
       listLayout2.VerticalAlignment = "Top"
       listLayout2.ItemLineAlignment = "Start"



       lib:DrawText({
        Name = "AimingText", 
   		  Parent = esp.holder["RightFlags"]["RightFlagsTwo"],
        TextSize = 10,
        AnchorPoint = Variables.Vector2new(0, 0)
       })



       lib:DrawText({
        Name = "InventoryText", 
   		  Parent = esp.holder["RightFlags"]["RightFlagsTwo"],
        TextSize = 10,
        AnchorPoint = Variables.Vector2new(0, 0)
       })
       


       local AimTextPadding = Variables.Instancenew("UIPadding", esp.holder["RightFlags"]["RightFlagsTwo"]["AimingText"])
       AimTextPadding.PaddingBottom = Variables.UDimnew(0, -9)
       AimTextPadding.PaddingRight = Variables.UDimnew(0, -25)
       AimTextPadding.PaddingTop = Variables.UDimnew(0, -2)



       local InventoryTextPadding = Variables.Instancenew("UIPadding", esp.holder["RightFlags"]["RightFlagsTwo"]["InventoryText"])
       InventoryTextPadding.PaddingTop = Variables.UDimnew(0, -4)
       InventoryTextPadding.PaddingRight = Variables.UDimnew(0, -48)
     end


     local colorStroke, outerStroke, innerStroke = lib:DrawUIStroke({Parent = esp.holder["Box"]}), lib:DrawUIStroke({Parent = esp.holder["Box"]}), lib:DrawUIStroke({Parent = esp.holder["Box"]})
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


     esp.UI.PName.AutomaticSize = Enum.AutomaticSize.Y
     esp.UI.BottomFlags.AutomaticSize = Enum.AutomaticSize.Y


     local VisTextPadding = Variables.Instancenew("UIPadding", esp.holder["BottomFlags"]["VisFlag"])
     VisTextPadding.PaddingBottom = Variables.UDimnew(0, 0)
     VisTextPadding.PaddingLeft = Variables.UDimnew(0, 0)


     colorStroke.ApplyStrokeMode = "Contextual"
     colorStroke.StrokeSizingMode = "FixedSize"
     colorStroke.LineJoinMode = "Miter"
     colorStroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
     colorStroke.ZIndex = 1
     colorStroke.Color = Variables.Color3fromRGB(0, 255, 255)


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


     local Character = self.Character
     esp.root, esp.humanoid = Character:WaitForChild("HumanoidRootPart", 60) or FindFirstChild(Character, "HumanoidRootPart"), Character:WaitForChild("Humanoid", 60) or FindFirstChild(Character, "Humanoid")
     esp.head = Character:WaitForChild("Head", 60) or FindFirstChild(Character, "Head")
     espCache[self].highlight.Adornee = Character
     espCache[self].highlight.Enabled = false
     espCache[self].highlight.FillTransparency = -1

 
     for _, part in Character:GetChildren() do
        if part:IsA("MeshPart") or part:IsA("Part") then
         esp.partCache[part] = Character:WaitForChild(part.Name, 60) or FindFirstChild(Character, part.Name)
         esp.boneCache[part.Name] = {Part = Character:WaitForChild(part.Name, 60) or FindFirstChild(Character, part.Name), Line = Drawing.new("Line"), Outline = Drawing.new("Line")}
        end
     end


     espCache[self].weapon = nil
      
    
     return espCache[self]
end


local function GetPFromChar(p)
  return Variables.Players:GetPlayerFromCharacter(p)
end

 
local function newCharacter(Character)
    local v = ESPObject(GetPFromChar(Character))
    ESP:getParts(v, Character)


    local canGrabWeapon = FindFirstChildOfClass(v.Character, "Tool")
    if canGrabWeapon then
      v.weapon = canGrabWeapon.Name
    end


    v.Character.ChildAdded:Connect(function(weapon)
      if weapon:IsA("Tool") then
        v.weapon = weapon.Name
      end
    end)


    v.Character.ChildRemoved:Connect(function(weapon)
      if weapon.Name == v.weapon then
        v.weapon = "Empty"
      end
    end)

end


local function OnRemoved(player)
      if espCache[player] then
        espCache[player].holder:Destroy()
        espCache[player] = nil
      end
end

   
local function newPlayer(player)
  if player.Character then
    Variables.taskdefer(newCharacter, player.Character)
  end

     
  player.CharacterAdded:Connect(newCharacter)
  player.CharacterRemoving:Connect(function()
    if ESP[player] then
      ESP[player].holder:Destroy()
      for _, bone in ESP[player].boneCache do
        bone.Line:Destroy()
        bone.Outline:Destroy()
      end
      ESP[player].boneCache = nil
      ESP[player] = nil
    end
  end)

end


function ESP:loadESP(player)
  if player.Character then
    Variables.taskdefer(newCharacter, player.Character)
  end

     
  player.CharacterAdded:Connect(newCharacter)
  player.CharacterRemoving:Connect(function()
    if ESP[player] then
      ESP[player].holder:Destroy()
      for _, bone in ESP[player].boneCache do
        bone.Line:Destroy()
        bone.Outline:Destroy()
      end
      ESP[player].boneCache = nil
      ESP[player] = nil
    end
  end)


  Variables.Players.PlayerAdded:Connect(newPlayer)
  Variables.Players.PlayerRemoving:Connect(OnRemoved)


  for _, player in Variables.Players:GetPlayers() do
    if player.Name ~= Variables.Players.LocalPlayer.Name then
      Variables.taskdefer(newPlayer, player)
    end
  end

end


return library, ESP, espConnection
