local function renderESP()
    local lastTick = os.clock()
    local visParams = RaycastParams.new()
    local animationSpeed = 1
    

    local lastShotUpdate = tick()
    local waitTime
    local ESP = ESP

      
    visParams.FilterType = Enum.RaycastFilterType.Exclude
    visParams.IgnoreWater = false
    visParams.CollisionGroup = "Default"


    local accumulatedTime = 0
    local TARGET_INTERVAL = 1 / 60 
    local getBoneValue, connectBone, setBoneVis = ESP.getBoneValue, ESP.connectBone, ESP.setBoneVis
    local setBoneVis = ESP.setBoneVis
    
    
    espConnection = Variables.RunService.PreRender:Connect(function(deltatime)
      local timeElapsed = 0
      local Client = Variables.Players.LocalPlayer
      
      local cameraPos = Variables.Camera.CFrame.Position
      local clientCharacter = Variables.Players.LocalPlayer.Character

      accumulatedTime += deltatime
      if accumulatedTime < TARGET_INTERVAL then
        return
      end
        
      accumulatedTime -= TARGET_INTERVAL

      local currentTextFont, flagFont = library.flags["TextFont"], library.flags["TextFlagFont"]
      local textFont, flagTextFont = Fonts[currentTextFont], Fonts[flagFont]


      local textSettings, flagTextSettings = ESP.fontSettings[currentTextFont], ESP.fontSettings[flagFont]
      local isSkeleton, boneThickness, outlineThickness, boneColor, outlineColor, boneZIndex, outlineZIndex = library.flags["skeletonEnabled"], 1, 3, library.flags["boneColor"].Color, Color3.fromRGB(0, 0, 0), 2, 1
       

      local healthBarPadding = ESP.healthBarSettings[library.flags["HealthBarPadding"]].Padding
      local healthBarPaddingSize = ESP.healthBarSettings[library.flags["HealthBarPadding"]].Size
      local textFlagFont = ESP.fontSettings[flagFont]

      for _, player in espCache do
            local holder = player
            local esp, UI, partCache, boneCache, chamCache, chamCacheTwo = holder.holder, holder.UI, holder.partCache, holder.boneCache, holder.chamCache, holder.chamCacheTwo
            local character = holder.Character


            local chams = holder.chamsholder
            if not clientCharacter or not character or not clientCharacter.Head then
               esp.Visible = false
               setBoneVis(boneCache, false)
              continue
             else
               esp.Visible = true
               setBoneVis(boneCache, isSkeleton)
            end


            local head, root, humanoid = holder.head, holder.root, holder.humanoid
            if not library.flags["EnableAll"] or not head or not root or not humanoid then
              esp.Visible = false
              setBoneVis(boneCache, false)
             continue
             else
              esp.Visible = true
              setBoneVis(boneCache, isSkeleton)
            end


            rayOrigin = clientCharacter.Head
            local rootPos, rootSize = root.Position, root.Size
            local pos2, isRootVis = WorldToViewportPoint(Camera, root.Position)
  
                
            local distancemag = math.floor((root.Position - cameraPos).Magnitude)
            local canSee = ESP.distanceCheck(distancemag, isRootVis)
            
  
            local healthCheck, maxHealth = humanoid.Health, humanoid.MaxHealth
            if not isRootVis or not canSee or healthCheck <= 0 then
               esp.Visible = false
               setBoneVis(boneCache, false)
              continue
             else
               esp.Visible = true
               setBoneVis(boneCache, isSkeleton)
            end
            
            
            local leftFlags, leftListLayout = UI.LeftFlags, UI.leftListLayout
            local rightFlags, rightListLayout = UI.RightFlags, UI.rightListLayout
          
                
            local halfHeight = (rootSize.X + rootSize.Y) / 1.5
            local top2D, isTopVisible = WorldToViewportPoint(Camera, rootPos + Vector3.new(0, halfHeight, 0))
            local bottom2D, isBottomVisible = WorldToViewportPoint(Camera, rootPos - Vector3.new(0, halfHeight, 0))
  
                
            local isPlayerVis, isPlayerManip = holder.playerVis, holder.playerManip
            local nameText, distanceText, weaponText, visFlag, manipFlag, healthFlag, aimingFlag, inventoryFlag = UI.PName, UI.Distance, UI.Weapon, UI.VisFlag, UI.ManipFlag, UI.HealthText, UI.AimingText, UI.InventoryText
            

            local highlightCham = holder.highlight
            local healthTextPadding = UI.HealthTextPadding

            
            local healthBar, bar, barGradient = UI.HealthBar, UI.Bar
            local weapon = holder.weapon or "Empty"
  
                
            local centerX = top2D.X
            local centerY = top2D.Y
            local height = (bottom2D.Y - centerY)
              
                
            local width = (height * .6) 
            local boxYSize = (height * 1.16 + 7)
            local posClamp = math.floor(centerY - height * .019)
  
                
            local boxTotalWidth = math.floor(width * 1.16 + 5)
            local halfBoxWidth = math.floor(boxTotalWidth * .5)


            local boxLeftX = math.floor(centerX - halfBoxWidth)
            local boxRightX = boxLeftX + boxTotalWidth
            local getVis = ESP.getVis
           

            do --// Texts

                do --// Name

                  nameText.Visible = library.flags["Names"]
                  if library.flags["Names"] then
                    nameText.Position = UDim2.fromOffset(centerX, posClamp - textSettings.namePadding)
                    nameText.TextColor3 = library.flags["Name_Color"].Color
                    nameText.FontFace = textFont
                    nameText.TextSize = textSettings.FontSize

                    if library.flags["UseDisplayName"] then
                      nameText.Text = player.Player.DisplayName
                     else
                      nameText.Text = player.Player.Name
                    end
                  end

                end
    
  
                do --// Distance
                  distanceText.Visible = library.flags["Distance"]
                  if library.flags["Distance"] then
                    distanceText.Text = distancemag .. library.flags["DistanceType"]
                    distanceText.TextColor3 = library.flags["Distance_Color"].Color
                    distanceText.FontFace = textFont
                    distanceText.TextSize = textSettings.FontSize
                  end
                end
    
    
                do -- Weapon
                  weaponText.Visible = library.flags["Weapon"]
                  if library.flags["Weapon"] then
                    weaponText.TextColor3 = library.flags["Weapon_Color"].Color
                    weaponText.Text = weapon
                    weaponText.FontFace = textFont
                    weaponText.TextSize = textSettings.FontSize
                  end
                end
    
  
                do --// Vis Check
                  visFlag.Visible = library.flags["Vis"] and rayOrigin
                  if library.flags["Vis"] and rayOrigin then
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
                    visFlag.TextColor3 = getVis(player.playerVis, library.flags["Vis_Color"].Color, library.flags["Not_Vis_Color"].Color)
                  end
                end
               

                do --// Misc Flags

                  local cutOff = math.clamp((distancemag-250)/(330-250), 0, 1)
                  aimingFlag.Transparency = cutOff
                  aimingFlag["UIStroke"].Transparency = cutOff

                  inventoryFlag.Transparency = cutOff
                  inventoryFlag["UIStroke"].Transparency = cutOff

                  healthFlag.Visible = library.flags["HealthText"]
                  if library.flags["HealthText"] then
                    healthFlag.TextColor3 = library.flags["Health_Text_Color"].Color
                    healthFlag.Text = math.floor(healthCheck)
                    healthFlag.FontFace = flagTextFont
                    healthFlag.TextSize = flagTextSettings.FontSize
                  end

                  aimingFlag.Visible = library.flags["AimingText"]
                  if library.flags["AimingText"] then
                    aimingFlag.TextColor3 = getVis(true, library.flags["Aiming_Color"].Color, library.flags["Not_Aiming_Color"].Color)
                    aimingFlag.FontFace = flagTextFont
                    aimingFlag.TextSize = flagTextSettings.FontSize
                  end
                  
                  inventoryFlag.Visible = library.flags["InventoryText"]
                  if library.flags["InventoryText"] then
                    inventoryFlag.TextColor3 = getVis(true, library.flags["Inventory_Color"].Color, library.flags["Not_Inventory_Color"].Color)
                    inventoryFlag.TextSize = textFlagFont.FontSize
                    inventoryFlag.FontFace = flagTextFont
                  end

                end

               
                rightFlags.Position = UDim2.fromOffset(rightX, posClamp)
                rightFlags.Size = UDim2.fromOffset(1, boxYSize)
            

                UI.BottomFlags.Position = UDim2.fromOffset(centerX, Math.floor( posClamp + boxYSize + textSettings.bottomPadding))
                UI.bottomListLayout.Padding = UDim.new(0, textSettings.bottomListLayoutPadding)
            end

               
            do --// Skeleton

              if isSkeleton then
                local upperTorso, lowerTorso = getBoneValue(boneCache, "UpperTorso", "Part"), getBoneValue(boneCache, "LowerTorso", "Part")
                  
                  local headPos, headBone, headOutline = WorldToViewportPoint(Camera, head.Position - Variables.Vector3new(0, .5, 0)), getBoneValue(boneCache, "Head", "Line"), getBoneValue(boneCache, "Head", "Outline")
                  local upperTorsoPos, upperTorsoBone, upperTorsoOutline = WorldToViewportPoint(Camera, upperTorso.Position), getBoneValue(boneCache, "UpperTorso", "Line"), getBoneValue(boneCache, "UpperTorso", "Outline")
                  local lowerTorsoPos, lowerTorsoBone, lowerTorsoOutline = WorldToViewportPoint(Camera, lowerTorso.Position), getBoneValue(boneCache, "LowerTorso", "Line"), getBoneValue(boneCache, "LowerTorso", "Outline")
              

                  do --// Torso
                      connectBone(headBone, isSkeleton and isRootVis, Vector2.new(headPos.X, headPos.Y), Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(headOutline, isSkeleton and isRootVis, Vector2.new(headPos.X, headPos.Y), Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      connectBone(upperTorsoBone, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(upperTorsoOutline, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), outlineThickness, outlineColor, outlineZIndex)
                  end
              

                  do --// Left Arm
                      local leftUpperArm, leftLowerArm, leftHand = getBoneValue(boneCache, "LeftUpperArm", "Part"), getBoneValue(boneCache, "LeftLowerArm", "Part"), getBoneValue(boneCache, "LeftHand", "Part")
              
                      local leftUpperArmPos, leftUpperArmBone, leftUpperArmOutline = WorldToViewportPoint(Camera, leftUpperArm.Position + Variables.Vector3new(0, .5, 0)), getBoneValue(boneCache, "LeftUpperArm", "Line"), getBoneValue(boneCache, "LeftUpperArm", "Outline")
                      local leftLowerArmPos, leftLowerArmBone, leftLowerArmOutline = WorldToViewportPoint(Camera, leftLowerArm.Position), getBoneValue(boneCache, "LeftLowerArm", "Line"), getBoneValue(boneCache, "LeftLowerArm", "Outline")
                      local leftHandPos, leftHandBone, leftHandOutline = WorldToViewportPoint(Camera, leftHand.Position), getBoneValue(boneCache, "LeftHand", "Line"), getBoneValue(boneCache, "LeftHand", "Outline")
              
                      connectBone(leftUpperArmBone, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(leftUpperArmPos.X, leftUpperArmPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(leftUpperArmOutline, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(leftUpperArmPos.X, leftUpperArmPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      connectBone(leftLowerArmBone, isSkeleton and isRootVis, Vector2.new(leftUpperArmPos.X, leftUpperArmPos.Y), Vector2.new(leftLowerArmPos.X, leftLowerArmPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(leftLowerArmOutline, isSkeleton and isRootVis, Vector2.new(leftUpperArmPos.X, leftUpperArmPos.Y), Vector2.new(leftLowerArmPos.X, leftLowerArmPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      connectBone(leftHandBone, isSkeleton and isRootVis, Vector2.new(leftLowerArmPos.X, leftLowerArmPos.Y), Vector2.new(leftHandPos.X, leftHandPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(leftHandOutline, isSkeleton and isRootVis, Vector2.new(leftLowerArmPos.X, leftLowerArmPos.Y), Vector2.new(leftHandPos.X, leftHandPos.Y), outlineThickness, outlineColor, outlineZIndex)
                  end
              

                  do --// Right Arm
                      local rightUpperArm, rightLowerArm, rightHand = getBoneValue(boneCache, "RightUpperArm", "Part"), getBoneValue(boneCache, "RightLowerArm", "Part"), getBoneValue(boneCache, "RightHand", "Part")
              
                      local rightUpperArmPos, rightUpperArmBone, rightUpperArmOutline = WorldToViewportPoint(Camera, rightUpperArm.Position + Variables.Vector3new(0, .5, 0)), getBoneValue(boneCache, "RightUpperArm", "Line"), getBoneValue(boneCache, "RightUpperArm", "Outline")
                      local rightLowerArmPos, rightLowerArmBone, rightLowerArmOutline = WorldToViewportPoint(Camera, rightLowerArm.Position), getBoneValue(boneCache, "RightLowerArm", "Line"), getBoneValue(boneCache, "RightLowerArm", "Outline")
                      local rightHandPos, rightHandBone, rightHandOutline = WorldToViewportPoint(Camera, rightHand.Position), getBoneValue(boneCache, "RightHand", "Line"), getBoneValue(boneCache, "RightHand", "Outline")
              
                      connectBone(rightUpperArmBone, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(rightUpperArmPos.X, rightUpperArmPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(rightUpperArmOutline, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(rightUpperArmPos.X, rightUpperArmPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      connectBone(rightLowerArmBone, isSkeleton and isRootVis, Vector2.new(rightUpperArmPos.X, rightUpperArmPos.Y), Vector2.new(rightLowerArmPos.X, rightLowerArmPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(rightLowerArmOutline, isSkeleton and isRootVis, Vector2.new(rightUpperArmPos.X, rightUpperArmPos.Y), Vector2.new(rightLowerArmPos.X, rightLowerArmPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      connectBone(rightHandBone, isSkeleton and isRootVis, Vector2.new(rightLowerArmPos.X, rightLowerArmPos.Y), Vector2.new(rightHandPos.X, rightHandPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(rightHandOutline, isSkeleton and isRootVis, Vector2.new(rightLowerArmPos.X, rightLowerArmPos.Y), Vector2.new(rightHandPos.X, rightHandPos.Y), outlineThickness, outlineColor, outlineZIndex)
                  end
                  

                  do --// Left Leg
                      local leftUpperLeg, leftLowerLeg, leftFoot = getBoneValue(boneCache, "LeftUpperLeg", "Part"), getBoneValue(boneCache, "LeftLowerLeg", "Part"), getBoneValue(boneCache, "LeftFoot", "Part")
              
                      local leftUpperLegPos, leftUpperLegBone, leftUpperLegOutline = WorldToViewportPoint(Camera, leftUpperLeg.Position + Variables.Vector3new(0, .5, 0)), getBoneValue(boneCache, "LeftUpperLeg", "Line"), getBoneValue(boneCache, "LeftUpperLeg", "Outline")
                      local leftLowerLegPos, leftLowerLegBone, leftLowerLegOutline = WorldToViewportPoint(Camera, leftLowerLeg.Position), getBoneValue(boneCache, "LeftLowerLeg", "Line"), getBoneValue(boneCache, "LeftLowerLeg", "Outline")
                      local leftFootPos, leftFootBone, leftFootOutline = WorldToViewportPoint(Camera, leftFoot.Position), getBoneValue(boneCache, "LeftFoot", "Line"), getBoneValue(boneCache, "LeftFoot", "Outline")
              
                      connectBone(leftUpperLegBone, isSkeleton and isRootVis, Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(leftUpperLegOutline, isSkeleton and isRootVis, Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      connectBone(leftLowerLegBone, isSkeleton and isRootVis, Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y), Vector2.new(leftLowerLegPos.X, leftLowerLegPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(leftLowerLegOutline, isSkeleton and isRootVis, Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y), Vector2.new(leftLowerLegPos.X, leftLowerLegPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      connectBone(leftFootBone, isSkeleton and isRootVis, Vector2.new(leftLowerLegPos.X, leftLowerLegPos.Y), Vector2.new(leftFootPos.X, leftFootPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(leftFootOutline, isSkeleton and isRootVis, Vector2.new(leftLowerLegPos.X, leftLowerLegPos.Y), Vector2.new(leftFootPos.X, leftFootPos.Y), outlineThickness, outlineColor, outlineZIndex)
                  end
              

                  do --// Right Leg
                      local rightUpperLeg, rightLowerLeg, rightFoot = getBoneValue(boneCache, "RightUpperLeg", "Part"), getBoneValue(boneCache, "RightLowerLeg", "Part"), getBoneValue(boneCache, "RightFoot", "Part")
              
                      local rightUpperLegPos, rightUpperLegBone, rightUpperLegOutline = WorldToViewportPoint(Camera, rightUpperLeg.Position + Variables.Vector3new(0, .5, 0)), getBoneValue(boneCache, "RightUpperLeg", "Line"), getBoneValue(boneCache, "RightUpperLeg", "Outline")
                      local rightLowerLegPos, rightLowerLegBone, rightLowerLegOutline = WorldToViewportPoint(Camera, rightLowerLeg.Position), getBoneValue(boneCache, "RightLowerLeg", "Line"), getBoneValue(boneCache, "RightLowerLeg", "Outline")
                      local rightFootPos, rightFootBone, rightFootOutline = WorldToViewportPoint(Camera, rightFoot.Position), getBoneValue(boneCache, "RightFoot", "Line"), getBoneValue(boneCache, "RightFoot", "Outline")
              
                      connectBone(rightUpperLegBone, isSkeleton and isRootVis, Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(rightUpperLegOutline, isSkeleton and isRootVis, Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      connectBone(rightLowerLegBone, isSkeleton and isRootVis, Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y), Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(rightLowerLegOutline, isSkeleton and isRootVis, Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y), Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      connectBone(rightFootBone, isSkeleton and isRootVis, Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y), Vector2.new(rightFootPos.X, rightFootPos.Y), boneThickness, boneColor, boneZIndex)
                      connectBone(rightFootOutline, isSkeleton and isRootVis, Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y), Vector2.new(rightFootPos.X, rightFootPos.Y), outlineThickness, outlineColor, outlineZIndex)
                  end
               
              end
                  
            end
         

            do --// Other
                do -- Box
                  local box, boxFill = UI.Box, UI.BoxFill
                  box.Visible = library.flags["Boxes"]
                  if library.flags["Boxes"] then
                    box.Position = UDim2.new(0, centerX, 0, posClamp)
                    box.Size = UDim2.new(0, boxTotalWidth, 0, boxYSize)
                    UI.topColor.Color = library.flags["Box_Color"].Color
                    
                    
                    boxFill.Visible = library.flags["Boxes"] and library.flags["BoxFill"]
                    boxFill.UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, library.flags["Box_Fill_Color"].Color), ColorSequenceKeypoint.new(1, library.flags["Box_Fill_ColorTwo"].Color)}
                   

                    boxFill.UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, library.flags["GradientColor1"].Transparency), NumberSequenceKeypoint.new(1, library.flags["GradientColor2"].Transparency)}
                    if library.flags["gradientSpin"] then
                       boxFill.UIGradient.Rotation += library.flags["gradientAnimationSpeed"] / 100
                     else
                      boxFill.UIGradient.Rotation = library.flags["FillRotation"]
                    end
                  end
                end
  
                do -- Health Bar
                  local healthBar, bar, barGradient = UI.HealthBar, UI.Bar, UI.BarGradient
                  healthBar.Visible = library.flags["Healthbar"]
                  if library.flags["Healthbar"] then
                    leftListLayout.Padding = UDim.new(0, textSettings.leftListLayoutPadding)
                    
  
                    healthBar.Size = UDim2.new(0, healthBarPaddingSize, 0, boxYSize)
                    leftFlags.Size = UDim2.fromOffset(-1, boxYSize)
                    bar.Size = UDim2.new(1, 0, healthCheck / maxHealth, 0)
                     
                     
                    leftFlags.Position = UDim2.fromOffset(boxLeftX - healthBarPadding, posClamp)
                    barGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, library.flags["GradientColor1"].Color), ColorSequenceKeypoint.new(1, library.flags["GradientColor2"].Color)}
                  end
                end
            end


            do --// Flags
              rightFlags.Position = UDim2.fromOffset(boxRightX + healthBarPadding, posClamp)
              rightFlags.Size = UDim2.fromOffset(1, boxYSize)
            end

      end

    end)

end
