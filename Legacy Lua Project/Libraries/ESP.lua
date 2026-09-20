--[[

DDDDDDDDDDDDD                                          kkkkkkkk           HHHHHHHHH     HHHHHHHHH                                                                                                             iiii                   
D::::::::::::DDD                                       k::::::k           H:::::::H     H:::::::H                                                                                                            i::::i                  
D:::::::::::::::DD                                     k::::::k           H:::::::H     H:::::::H                                                                                                             iiii                   
DDD:::::DDDDD:::::D                                    k::::::k           HH::::::H     H::::::HH                                                                                                                                    
  D:::::D    D:::::D  aaaaaaaaaaaaa  nnnn  nnnnnnnn     k:::::k    kkkkkkk  H:::::H     H:::::H    aaaaaaaaaaaaa   xxxxxxx      xxxxxxxxxxxxxx      xxxxxxx        wwwwwww           wwwww           wwwwwwwiiiiiiinnnn  nnnnnnnn    
  D:::::D     D:::::D a::::::::::::a n:::nn::::::::nn   k:::::k   k:::::k   H:::::H     H:::::H    a::::::::::::a   x:::::x    x:::::x  x:::::x    x:::::x          w:::::w         w:::::w         w:::::w i:::::in:::nn::::::::nn  
  D:::::D     D:::::D aaaaaaaaa:::::an::::::::::::::nn  k:::::k  k:::::k    H::::::HHHHH::::::H    aaaaaaaaa:::::a   x:::::x  x:::::x    x:::::x  x:::::x            w:::::w       w:::::::w       w:::::w   i::::in::::::::::::::nn 
  D:::::D     D:::::D          a::::ann:::::::::::::::n k:::::k k:::::k     H:::::::::::::::::H             a::::a    x:::::xx:::::x      x:::::xx:::::x              w:::::w     w:::::::::w     w:::::w    i::::inn:::::::::::::::n
  D:::::D     D:::::D   aaaaaaa:::::a  n:::::nnnn:::::n k::::::k:::::k      H:::::::::::::::::H      aaaaaaa:::::a     x::::::::::x        x::::::::::x                w:::::w   w:::::w:::::w   w:::::w     i::::i  n:::::nnnn:::::n
  D:::::D     D:::::D aa::::::::::::a  n::::n    n::::n k:::::::::::k       H::::::HHHHH::::::H    aa::::::::::::a      x::::::::x          x::::::::x                  w:::::w w:::::w w:::::w w:::::w      i::::i  n::::n    n::::n
  D:::::D     D:::::Da::::aaaa::::::a  n::::n    n::::n k:::::::::::k       H:::::H     H:::::H   a::::aaaa::::::a      x::::::::x          x::::::::x                   w:::::w:::::w   w:::::w:::::w       i::::i  n::::n    n::::n
  D:::::D    D:::::Da::::a    a:::::a  n::::n    n::::n k::::::k:::::k      H:::::H     H:::::H  a::::a    a:::::a     x::::::::::x        x::::::::::x                   w:::::::::w     w:::::::::w        i::::i  n::::n    n::::n
DDD:::::DDDDD:::::D a::::a    a:::::a  n::::n    n::::nk::::::k k:::::k   HH::::::H     H::::::HHa::::a    a:::::a    x:::::xx:::::x      x:::::xx:::::x                   w:::::::w       w:::::::w        i::::::i n::::n    n::::n
D:::::::::::::::DD  a:::::aaaa::::::a  n::::n    n::::nk::::::k  k:::::k  H:::::::H     H:::::::Ha:::::aaaa::::::a   x:::::x  x:::::x    x:::::x  x:::::x   ......          w:::::w         w:::::w         i::::::i n::::n    n::::n
D::::::::::::DDD     a::::::::::aa:::a n::::n    n::::nk::::::k   k:::::k H:::::::H     H:::::::H a::::::::::aa:::a x:::::x    x:::::x  x:::::x    x:::::x  .::::.           w:::w           w:::w          i::::::i n::::n    n::::n
DDDDDDDDDDDDD         aaaaaaaaaa  aaaa nnnnnn    nnnnnnkkkkkkkk    kkkkkkkHHHHHHHHH     HHHHHHHHH  aaaaaaaaaa  aaaaxxxxxxx      xxxxxxxxxxxxxx      xxxxxxx ......            www             www           iiiiiiii nnnnnn    nnnnnn


]]


--!optimize 2
--!nocheck
setthreadidentity(8)
local library, themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/iampro1240/Atlanta-Samet-is-a-retard-/refs/heads/main/Atlanta%20UI.lua"))()
local savedFunctions = {}
local closest, manipulatedPlayer, currentPlayerTarget
local Client
local doneLoading = false
local Camera = workspace.CurrentCamera
local visualHolder = Instance.new("ScreenGui", gethui())
visualHolder.IgnoreGuiInset = true
visualHolder.Enabled = true
local CFrame_new_ret = CFrame.new(Vector3.new(-7349.55, 0, -6187.35), Vector3.new(-7349.55, 0, -6186.35))
local previousVelocity = Vector3.new(0, 0, 0)
local getService = function(value)
    if game:GetService(value) then
        return cloneref(game:GetService(value))
    end
end


local getFunction = function(value)
    if type(value) == "function" then
        return clonefunction(value)
    else
        warn(tostring(value) .. " is not a function!")
        return      
    end
end


local getGCFunction = function(funcName)
  local Func = filtergc("function", {Name = funcName, IgnoreExecutor = false}, true)
    if Func ~= nil then
      savedFunctions[Func] = Func
      return Func
     else
     library:notification({time = 5, text = funcName .. " can not be traced, contact developer's for support.", flashing = false, })
     return function() return end
  end
end


local function deepCopy(orig, copies)
    copies = copies or {} -- Track already processed tables AND functions

    -- Base case: Return early if primitive, or if already copied in this run
    if type(orig) ~= "table" and type(orig) ~= "function" then
        return orig
    elseif copies[orig] then
        return copies[orig]
    end

    -- 1. Handle Functions
    if type(orig) == "function" then
        local success, bytecode = pcall(string.dump, orig)
        if success then
            local new_func = load(bytecode)
            copies[orig] = new_func -- Track copied function
            return new_func
        else
            return orig -- Fallback for C-functions
        end
    end

    -- 2. Handle Tables
    local copy = {}
    copies[orig] = copy -- Track copied table BEFORE recursing to prevent infinite loops

    for k, v in pairs(orig) do
        -- Deep copy both key and value
        copy[deepCopy(k, copies)] = deepCopy(v, copies)
    end

    -- 3. Safely Handle Metatables (Avoid __index loops)
    local mt = getmetatable(orig)
    if mt then
        -- Avoid recursing on metatables that point to the table itself
        if mt == orig then
            setmetatable(copy, copy)
        else
            setmetatable(copy, deepCopy(mt, copies))
        end
    end

    return copy
end


local function deepCopy2(original, copyMetatable, seen)
    -- Validate input
    if type(original) ~= "table" then
        return original -- Non-tables are returned as-is
    end

    -- Track already copied tables to handle cycles
    seen = seen or {}
    if seen[original] then
        return seen[original]
    end

    local copy = {}
    seen[original] = copy

    for key, value in pairs(original) do
        local newKey = deepCopy(key, copyMetatable, seen)
        local newValue = deepCopy(value, copyMetatable, seen)
        copy[newKey] = newValue
    end

    -- Optionally copy metatable
    if copyMetatable then
        local mt = getmetatable(original)
        if mt then
            setmetatable(copy, deepCopy(mt, copyMetatable, seen))
        end
    end

    return copy
end


function dc(tbl, seen)
    if type(tbl) ~= "table" then return tbl end
    seen = seen or {}
    if seen[tbl] then return seen[tbl] end
    local copy = {}
    seen[tbl] = copy
    for k, v in next, tbl do
        copy[deepCopy(k, seen)] = deepCopy(v, seen)
    end
    return setmetatable(copy, getmetatable(tbl))
end


local Variables = {
    ["Players"] = getService("Players"),
    ["LocalPlayer"] = getService("Players").LocalPlayer,
    ["ReplicatedStorage"] = getService("ReplicatedStorage"),
    ["Httpservice"] = getService("HttpService"),
    ["RunService"] = getService("RunService"),
    ["TweenService"] = getService("TweenService"),
    ["UserInputService"] = getService("UserInputService"),
    ["HideUI"] = function() 
      return gethui() or game.CoreGui 
    end;



    ["Camera"] = cloneref(workspace.CurrentCamera),
    ["Workspace"] = getService("Workspace"),
    ["Lighting"] = getService("Lighting"),



    ["Instancenew"] = getFunction(Instance.new),
    ["NewGradient"] = getFunction(ColorSequence.new),
    ["GradientNumberSequence"] = getFunction(ColorSequenceKeypoint.new),
    ["NumberSequence"] = getFunction(NumberSequence.new),
   


    ["Color3new"] = getFunction(Color3.new),
    ["Color3fromRGB"] = getFunction(Color3.fromRGB),



    ["UDim2new"] = getFunction(UDim2.new),
    ["UDimnew"] = getFunction(UDim.new),
    ["UDimfromScale"] = getFunction(UDim2.fromScale),
    ["UDim2fromOffset"] = getFunction(UDim2.fromOffset),
    ["Vector2new"] = getFunction(Vector2.new),
    ["Vector3new"] = getFunction(Vector3.new),
    ["CFramenew"] = getFunction(CFrame.new),



    ["taskdefer"] = getFunction(task.defer),
    ["taskwait"] = getFunction(task.wait),


    Weapon,
    FakeCharacter
}


local Math = {
    ["Floor"] = getFunction(math.floor),
    ["Abs"] = getFunction(math.abs),
    ["Ceil"] = getFunction(math.ceil),
    ["Pow"] = getFunction(math.pow),
    ["Clamp"] = getFunction(math.clamp),
    ["Cos"] = getFunction(math.cos),
    ["Sin"] = getFunction(math.sin),
    ["Rad"] = getFunction(math.rad),
    ["Round"] = getFunction(math.round),
    ["Min"] = getFunction(math.min),
    ["Max"] = getFunction(math.max),
    ["Sqrt"] = getFunction(math.sqrt),
}


local FindFirstChild = function(p1, p2)
    return p1:FindFirstChild(p2)
end


local FindFirstChildOfClass = function(p1, p2)
    return p1:FindFirstChildOfClass(p2)
end


local WorldToViewportPoint = function(camera, p)
  return camera:WorldToViewportPoint(p)
end


local lib = {}
local vehicle = {}
local corpsecache = {}
local characterCache = {}


local rageBot = {}
local ESP = {}
local visuals = {
  HealthValues = {};
}


local weapon = {}
local Fonts = {}
local targeting = {}
local LocalCharacter, LocalCamera


local FontIndexes = {"ProggyClean", "Tahoma", "Verdana", "SmallestPixel", "ProggyTiny", "Minecraftia", "Tahoma Bold", "Rubik"}
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


local cheat = {
  visualcache = {circle = Drawing.new("Circle"), outlinecircle = Drawing.new("Circle"), snapline = Drawing.new("Line"), snaplineOutline = Drawing.new("Line"), clientHighlight = Variables.Instancenew("Highlight", gethui()), vmHighlight = Variables.Instancenew("Highlight", gethui())};
  vehiclecache = {};



  fontSettings = {
    Minecraftia = {FontSize = 10, namePadding = 13, bottomPadding = 2, bottomListLayoutPadding = -3, leftListLayoutPadding = 10, bottomHealthTextPadding = -9, leftHealthTextPadding = -14};
    ProggyTiny = {FontSize = 9, namePadding = 12, bottomPadding = 3, bottomListLayoutPadding = 2, leftListLayoutPadding = 10, bottomHealthTextPadding = -7, leftHealthTextPadding = -14};
    ProggyClean = {FontSize = 12, namePadding = 8, bottomPadding = 8, bottomListLayoutPadding = 12, leftListLayoutPadding = 10, bottomHealthTextPadding = -8, leftHealthTextPadding = -18};
    SmallestPixel = {FontSize = 9, namePadding = 8, bottomPadding = 5, bottomListLayoutPadding = 9, leftListLayoutPadding = 10, bottomHealthTextPadding = -3, leftHealthTextPadding = -10};
    ["Tahoma Bold"] = {FontSize = 11, namePadding = 14, bottomPadding = 2, bottomListLayoutPadding = 1, leftListLayoutPadding = 10, bottomHealthTextPadding = -3, leftHealthTextPadding = -10};
    Tahoma = {FontSize = 12, namePadding = 15, bottomPadding = 1, bottomListLayoutPadding = 0, leftListLayoutPadding = 13, bottomHealthTextPadding = -5, leftHealthTextPadding = -12};
  };



  healthBarSettings = {
    ["1 Pixel"] = {Padding = 3, Size = 1},
    ["2 Pixel"] = {Padding = 4, Size = 2},

    ["Left"] = {Parent = "LeftFlags", AnchorPoint = .5};
    ["Right"] = {Parent = "RightFlags", AnchorPoint = 1};
  };
  
  

  oldGunStats = {
    
  };



  connections = {
    silent;
    lock;
    facetarget;
    speedhack;
    jumpheight;
    zoom;
    customfov;
    removevfx;
    customtime;
    customambient;
    TPKill;
    chams;
    selfchams;
    noclip;
    customatmosphere;
    removeinventoryblur;
    customclouds;
    custombloom;
    spinbot;


    PAdded;
    PRemoved;

    gunAdded
  };



  BulletTrails = {
    Electricity = "rbxassetid://12996830609";
    Lightning = "rbxassetid://7151778302";
    Pulse = "rbxassetid://11226108137";
    LightPulse = "rbxassetid://917186750";
    Reflex = "rbxassetid://833874434";
    Shards = "rbxassetid://13712007292";
  };



  soundAssets = {
  	xp = writefile("xp.mp3", base64decode(game:HttpGet("https://gitlab.com/jaydenmyers215/sigma-hook-assets/-/raw/main/Audios/minecraftxp.txt?ref_type=heads")));
  	neverlose = writefile("neverlose.mp3", base64decode(game:HttpGet("https://gitlab.com/jaydenmyers215/sigma-hook-assets/-/raw/main/Audios/neverlose.txt?ref_type=heads")));
  	rust  = writefile("rust.mp3", base64decode(game:HttpGet("https://gitlab.com/jaydenmyers215/sigma-hook-assets/-/raw/main/Audios/rust.txt?ref_type=heads")));
  	niggers  = writefile("niggers.mp3", base64decode(game:HttpGet("https://gitlab.com/jaydenmyers215/sigma-hook-assets/-/raw/main/niggers_string.txt?ref_type=heads")));
    tf2 = writefile("tf2.mp3", base64decode(game:HttpGet("https://gitlab.com/jaydenmyers215/sigma-hook-assets/-/raw/main/Audios/tf2.txt")));
    skeet = writefile("skeet.mp3", base64decode(game:HttpGet("https://gitlab.com/jaydenmyers215/sigma-hook-assets/-/raw/main/Audios/skeet2.txt")));
    sonic = writefile("sonic.mp3", base64decode(game:HttpGet("https://gitlab.com/jaydenmyers215/sigma-hook-assets/-/raw/main/Audios/sonic.txt")));
    fingersnap = writefile("fingersnap.mp3", base64decode(game:HttpGet("https://gitlab.com/jaydenmyers215/sigma-hook-assets/-/raw/main/Audios/fingersnap.txt")));
    bow = writefile("bow.mp3", base64decode(game:HttpGet("https://gitlab.com/jaydenmyers215/sigma-hook-assets/-/raw/main/Audios/bow_shoot.txt?ref_type=heads")));
  };
  


  oldGunAssets = {};
  modules = {
    
  };
  
  

  playerCache = {};
  originalHitSounds = {};
  


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



  InvalidGunParts = {
    "Barrel";
  };



  characterSettings = {
    RateLimit = .3

  };
  


  locktarget;
  gunmodel;
  barrelspoof;
  hitplr;
  targetvis;
  targetmanip;
  



}


local UICache = {
  
}


do -- variables
    Client = Variables.Players.LocalPlayer
    Variables["Camera"] = cloneref(workspace.CurrentCamera)
    Variables["CameraOrigin"] = Vector2.new(Variables.Camera.ViewportSize.X / 2, Variables.Camera.ViewportSize.Y / 2)
    Variables["Mouse"] = Client:GetMouse()
    --Variables["Client"]:GetMouse()
    

    Variables["RemoveBlur"] = function(bool)
      local success, error = pcall(function()
        local blur = FindFirstChild(game:GetService("Lighting"), "GameMenuBlur")
        if not blur then
          return
        end

        if bool then
          blur.Size = 0
         else
          blur.Size = 18
        end
        
      end)

    end


    Variables["RemoveCelestialBodies"] = function(bool)
      local success, error = pcall(function()
        local skybox = Variables.Lighting:FindFirstChildOfClass("Sky")

        if bool then
          skybox.CelestialBodiesShown = false
          warn(bool)
         else
          skybox.CelestialBodiesShown = true
        end
        
      end)

    end


    Variables["EditCelestialBodies"] = function(bool)
      local success, error = pcall(function()
        local skybox = game:GetService("Lighting"):FindFirstChildOfClass("Sky")
        if not skybox then
          return
        end

        if visuals:returnflag("EditCelestialBodies") then
          skybox.MoonAngularSize = visuals:returnflag("CelestialSize")
          skybox.SunAngularSize = visuals:returnflag("CelestialSize")
         else
          skybox.MoonAngularSize = 12
          skybox.SunAngularSize = 12
        end
        
      end)

    end


    Variables["RemoveShadows"] = function(bool)
      local success, error = pcall(function()
        if bool then
          game:GetService("Lighting").GlobalShadows = false
         else
          game:GetService("Lighting").GlobalShadows = true
        end
        
      end)

    end


    Variables["ChangeLighting"] = function(float)
      local success, error = pcall(function()
        if visuals:returnflag("CustomLighting") then
         Variables.Lighting.TimeOfDay = float
        end
        
      end)
    end
    

end


do -- ESP functions


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



  function visuals:returnflag(flag)
    return library.flags[flag]
  end
   

   
  function visuals:returnflagcolor(color)
    return visuals:returnflag(color).Color
    --Library.Flags[color].c
  end
   
   

  function visuals:returnflagtransparency(color)
    return visuals:returnflag(color).Alpha or visuals:returnflag(color).Transparency
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
        warn(part)
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


end


do -- rageBot functions
  rageBot.previousWeapon = nil
  

  --[[function rageBot:FindTargetOrigin(origin, targetPart, radius, height, steps, referencePosition, ignoreList)
    -- 1. Automatically convert origin (handles Cameras, Parts, Models, Vector3, etc.)
    if typeof(origin) == "Instance" then
        if origin:IsA("Model") then
            origin = origin:GetPivot().Position
        elseif origin:IsA("BasePart") then
            origin = origin.Position
        elseif origin:IsA("Camera") then
            origin = origin.CFrame.Position
        end
    elseif type(origin) == "table" then
        origin = Vector3.new(origin[1] or origin.X or 0, origin[2] or origin.Y or 0, origin[3] or origin.Z or 0)
    elseif typeof(origin) == "CFrame" then
        origin = origin.Position
    end

    -- 2. Automatically convert targetPart into a clean Vector3 position
    local targetPos = nil
    local targetInstanceModel = nil
    
    if typeof(targetPart) == "Instance" then
        if targetPart:IsA("Model") then
            targetInstanceModel = targetPart
            local root = targetPart.PrimaryPart or targetPart:FindFirstChild("HumanoidRootPart") or targetPart:FindFirstChildWhichIsA("BasePart")
            targetPos = root and root.Position or targetPart:GetPivot().Position
        elseif targetPart:IsA("BasePart") then
            targetInstanceModel = targetPart.Parent
            targetPos = targetPart.Position
        end
    elseif typeof(targetPart) == "Vector3" then
        targetPos = targetPart
    elseif type(targetPart) == "table" then
        targetPos = Vector3.new(targetPart[1] or targetPart.X or 0, targetPart[2] or targetPart.Y or 0, targetPart[3] or targetPart.Z or 0)
    end

    if not targetPos or typeof(origin) ~= "Vector3" then
        warn("FindTargetOrigin: Invalid origin or target provided! origin type:", typeof(origin), "targetPos:", tostring(targetPos))
        return nil, nil
    end

    -- 3. Safeguard ignoreList to ensure it's always a table for RaycastParams
    if typeof(ignoreList) == "Instance" then
        ignoreList = {ignoreList}
    elseif type(ignoreList) ~= "table" then
        ignoreList = {}
    end

    local bestOrigin = nil
    local bestReach = math.huge 

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = ignoreList
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true

    local targetDistance = (targetPos - origin).Magnitude
    radius = math.clamp(targetDistance * 0.1, math.min(5, radius), radius)

    local forward = (targetPos - origin) * Vector3.new(1, 0, 1)
    forward = forward.Magnitude > 1e-3 and forward.Unit or Vector3.new(0, 0, -1)
    local rightVector = forward:Cross(Vector3.new(0, 1, 0))

    local side = nil
    if referencePosition then
        if typeof(referencePosition) == "Instance" then
            referencePosition = referencePosition:IsA("Camera") and referencePosition.CFrame.Position or (referencePosition:IsA("Model") and referencePosition:GetPivot().Position or referencePosition.Position)
        elseif type(referencePosition) == "table" then
            referencePosition = Vector3.new(referencePosition[1] or referencePosition.X or 0, referencePosition[2] or referencePosition.Y or 0, referencePosition[3] or referencePosition.Z or 0)
        elseif typeof(referencePosition) == "CFrame" then
            referencePosition = referencePosition.Position
        end
        if typeof(referencePosition) == "Vector3" then
            local offset = referencePosition - origin
            side = Vector3.new(offset.X, 0, offset.Z):Dot(rightVector) >= 0 and 1 or -1
        end
    end

    local heightsToCheck = {0}
    for h = 1, height do
        table.insert(heightsToCheck, -h)
        table.insert(heightsToCheck, h)
    end

    for i = 0, steps - 1 do
        local angle = (math.pi * 2) * (i / steps)
        local offsetX = math.cos(angle) * radius
        local offsetZ = math.sin(angle) * radius

        if side then
            local sideValue = Vector3.new(offsetX, 0, offsetZ):Dot(rightVector)
            if sideValue * side < 0 then
                continue
            end
        end

        for _, h in ipairs(heightsToCheck) do
            local candidateOffset = Vector3.new(offsetX, h, offsetZ)
            local candidate = origin + candidateOffset
            local direction = targetPos - candidate

            local ray = workspace:Raycast(candidate, direction, raycastParams)

            if ray then
                local hitValid = false
                if targetInstanceModel and ray.Instance:IsDescendantOf(targetInstanceModel) then
                    hitValid = true
                elseif not targetInstanceModel then
                    hitValid = true 
                end

                if hitValid then
                    local reach = candidateOffset.Magnitude
                    if reach < bestReach then
                        bestOrigin = candidate
                        bestReach = reach
                        break 
                    end
                end
            end
        end
    end

    return bestOrigin, bestReach
  end]]


  function rageBot:FindTargetOrigin(origin, targetPart, radius, height, steps, referencePosition, ignoreList)
    -- 1. Automatically convert origin
    if typeof(origin) == "Instance" then
        if origin:IsA("Model") then
            origin = origin:GetPivot().Position
        elseif origin:IsA("BasePart") then
            origin = origin.Position
        elseif origin:IsA("Camera") then
            origin = origin.CFrame.Position
        end
    elseif type(origin) == "table" then
        origin = Vector3.new(origin[1] or origin.X or 0, origin[2] or origin.Y or 0, origin[3] or origin.Z or 0)
    elseif typeof(origin) == "CFrame" then
        origin = origin.Position
    end

    -- 2. Automatically convert targetPart into a clean Vector3 position
    local targetPos = nil
    local targetInstanceModel = nil
    
    if typeof(targetPart) == "Instance" then
        if targetPart:IsA("Model") then
            targetInstanceModel = targetPart
            local root = targetPart.PrimaryPart or targetPart:FindFirstChild("HumanoidRootPart") or targetPart:FindFirstChildWhichIsA("BasePart")
            targetPos = root and root.Position or targetPart:GetPivot().Position
        elseif targetPart:IsA("BasePart") then
            targetInstanceModel = targetPart.Parent
            targetPos = targetPart.Position
        end
    elseif typeof(targetPart) == "Vector3" then
        targetPos = targetPart
    elseif type(targetPart) == "table" then
        targetPos = Vector3.new(targetPart[1] or targetPart.X or 0, targetPart[2] or targetPart.Y or 0, targetPart[3] or targetPart.Z or 0)
    end

    if not targetPos or typeof(origin) ~= "Vector3" then
        warn("FindTargetOrigin: Invalid origin or target provided! origin type:", typeof(origin), "targetPos:", tostring(targetPos))
        return nil, nil
    end

    -- 3. Safeguard ignoreList to ensure it's always a table for RaycastParams
    if typeof(ignoreList) == "Instance" then
        ignoreList = {ignoreList}
    elseif type(ignoreList) ~= "table" then
        ignoreList = {}
    end

    local bestOrigin = nil
    local bestReach = math.huge 

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = ignoreList
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true

    local targetDistance = (targetPos - origin).Magnitude
    
    -- UPDATED: Clamps the radius to strictly use your provided value, bounding it between 0 and the target's distance
    radius = math.clamp(radius, 0, targetDistance)

    local forward = (targetPos - origin) * Vector3.new(1, 0, 1)
    forward = forward.Magnitude > 1e-3 and forward.Unit or Vector3.new(0, 0, -1)
    local rightVector = forward:Cross(Vector3.new(0, 1, 0))

    local side = nil
    if referencePosition then
        if typeof(referencePosition) == "Instance" then
            referencePosition = referencePosition:IsA("Camera") and referencePosition.CFrame.Position or (referencePosition:IsA("Model") and referencePosition:GetPivot().Position or referencePosition.Position)
        elseif type(referencePosition) == "table" then
            referencePosition = Vector3.new(referencePosition[1] or referencePosition.X or 0, referencePosition[2] or referencePosition.Y or 0, referencePosition[3] or referencePosition.Z or 0)
        elseif typeof(referencePosition) == "CFrame" then
            referencePosition = referencePosition.Position
        end
        if typeof(referencePosition) == "Vector3" then
            local offset = referencePosition - origin
            side = Vector3.new(offset.X, 0, offset.Z):Dot(rightVector) >= 0 and 1 or -1
        end
    end

    -- NOTE: If you want height to ONLY check the exact value you provided instead of scanning 
    -- multiple heights (0, 1, -1, 2, -2), change this array to just: local heightsToCheck = {height}
    local heightsToCheck = {0}
    for h = 1, height do
        table.insert(heightsToCheck, -h)
        table.insert(heightsToCheck, h)
    end

    for i = 0, steps - 1 do
        local angle = (math.pi * 2) * (i / steps)
        local offsetX = math.cos(angle) * radius
        local offsetZ = math.sin(angle) * radius

        if side then
            local sideValue = Vector3.new(offsetX, 0, offsetZ):Dot(rightVector)
            if sideValue * side < 0 then
                continue
            end
        end

        for _, h in ipairs(heightsToCheck) do
            local candidateOffset = Vector3.new(offsetX, h, offsetZ)
            local candidate = origin + candidateOffset
            local direction = targetPos - candidate

            local ray = workspace:Raycast(candidate, direction, raycastParams)

            if ray then
                local hitValid = false
                if targetInstanceModel and ray.Instance:IsDescendantOf(targetInstanceModel) then
                    hitValid = true
                elseif not targetInstanceModel then
                    hitValid = true 
                end

                if hitValid then
                    local reach = candidateOffset.Magnitude
                    if reach < bestReach then
                        bestOrigin = candidate
                        bestReach = reach
                        break 
                    end
                end
            end
        end
    end

    return bestOrigin, bestReach
  end
  

  function rageBot:GetAmmo(Weapon)
      if not Weapon then return 0 end
      

      if Weapon.FireConfig.InternalMag or Weapon.InternalMag and Weapon.WorkingAmount then
        return Weapon.WorkingAmount
      end

      if Weapon.Attachments and Weapon.Attachments.Ammo then
        return Weapon.Attachments.Ammo.WorkingAmount
      end

      return (Weapon.__item and Weapon.__item.Amount) or 0
  end


  function rageBot:GetWeapon()
      if not LocalCharacter then return end
      if rageBot.previousWeapon ~= nil then 
        local Ammo = rageBot:GetAmmo(rageBot.previousWeapon)
        if Ammo > 0 then
            return rageBot.previousWeapon
        end
      end

      if LocalCharacter.EquippedItem and LocalCharacter.EquippedItem.Type == 'Firearm' then
          local Ammo = rageBot:GetAmmo(LocalCharacter.EquippedItem)
          if Ammo > 0 then
             return LocalCharacter.EquippedItem
            end
          end
          
      return
  end


  function rageBot:Fire(Weapon, Target)
     if not Weapon or not rageBot.previousWeapon or not Target then return end
      local lastFireTime = 0
      local getAmmo = rageBot:GetAmmo(Weapon)
      


      --if typeof(FakeCharacter.EquippedItem) ~= "table" and FakeCharacter.EquippedItem.Type ~= "Firearm" then
        --return
      --end

      local Origin = workspace.CurrentCamera.CFrame.Position
      local getPrediction = weapon:getAdvancedPrediction(Origin, closest.Position, closest.AssemblyLinearVelocity, previousVelocity, Weapon.FireConfig.MuzzleVelocity, -31.392)
      local Direction = (getPrediction - Origin).Unit
      
      if getAmmo == 0 then
        return
      end
      
    
      local Timestamp = tick()
      local fireRateDelay = Timestamp + (60 / Weapon.FireConfig.FireRate)
      

      
      lastFireTime = Timestamp 
      local realName = Weapon.RealName
      local FakeCharacter = dc(LocalCharacter)
      local FakeCamera = dc(cheat.modules.Cameras:GetCamera("Character"))
      FakeCharacter.MoveState = 'Crouching'
      FakeCharacter.Zooming = true
      FakeCamera.FirstPerson = true
       
        
        
      cheat.modules.Bullets:Fire(
        FakeCharacter,
        FakeCamera,
        Weapon,
        Origin,
        Direction,
        nil
      )


       
      if Weapon.FireConfig.InternalMag then
        Weapon.WorkingAmount = (Weapon.WorkingAmount or 1) - 1
        elseif Weapon.Attachments and Weapon.Attachments.Ammo then
         Weapon.Attachments.Ammo.WorkingAmount = (Weapon.Attachments.Ammo.WorkingAmount or 1) - 1
        elseif Weapon.__item and Weapon.__item.Amount then
         Weapon.__item.Amount -= 1
      end
      Weapon.LastShot = Timestamp
      Weapon.NextShotValid = Timestamp + (60 / Weapon.FireConfig.FireRate)
  
      
     return true, Weapon.NextShotValid, lastFireTime
  end

end


do -- visuals
  function visuals:multiplyColor(color, factor)
      -- Convert to 0–255 integers
      local r = Math.Floor(color.R * 255)
      local g = Math.Floor(color.G * 255)
      local b = Math.Floor(color.B * 255)
      
      -- Multiply and clamp to 0–255
      local newR = r * factor
      local newG = g * factor
      local newB = b * factor
      
      -- Return new Color3
    return Color3.fromRGB(newR, newG, newB)
  end
  


  function visuals:CreateBulletTracer(origin, pos)
    if visuals:returnflag("TracerType") == "Part" then
         task.spawn(function()
          local part = Instance.new("Part", workspace)
          local shading = Instance.new("BoxHandleAdornment", part)
          local distance = Math.Floor((origin - pos).Magnitude)
  
  
          local distance = (pos - origin).Magnitude
          local direction = CFrame.new(origin - Vector3.new(0, .5, 0), pos)
          
  
          part.Size = Vector3.new(distance, visuals:returnflag("TracerSize"), visuals:returnflag("TracerSize"))
          part.CFrame = direction * CFrame.new(0, 0, -distance / 2) * CFrame.Angles(0, math.rad(90), 0)
          part.CanTouch = false
          part.CanQuery = false
  
  
          part.CanCollide = false
          part.Transparency = 0
          part.Anchored = true
          --CFrame.new(origin, pos) * CFrame.Angles(0, 1.570796326794896, 0) * CFrame.new(distance / 2, 0, 0)
          part.Material = Enum.Material[visuals:returnflag("ChamMaterial")]
          part.Shape = "Cylinder"
          part.Reflectance = visuals:returnflag("Reflectance")
  
  
          shading.Adornee = part
          shading.ZIndex = 10
          shading.Size = part.Size
          shading.AlwaysOnTop = true
          shading.Color3 = visuals:multiplyColor(visuals:returnflagcolor("BulletTracerColor"), visuals:returnflag("GlowMultiplier"))
          shading.Shading = visuals:returnflag("TracerShading")
          
  
          if visuals:returnflag("TracerAnimation") then
            local tweenInfo = TweenInfo.new(
            	visuals:returnflag("FadeTime"),
            	Enum.EasingStyle[visuals:returnflag("EasingStyle")],
            	Enum.EasingDirection[visuals:returnflag("EasingDirection")],
            	0,
            	visuals:returnflag("TweenReverse"),
            	0
            )
            
  
            local tween = Variables.TweenService:Create(shading, tweenInfo, { Transparency = 1 })
            local tween2 = Variables.TweenService:Create(part, tweenInfo, { Transparency = 1 })
            tween:Play()
            tween2:Play()
            
  
            if visuals:returnflag("TweenReverse") then
              task.wait(visuals:returnflag("FadeTime") + 4 / 1)
              part:Destroy()
             else
              task.wait(visuals:returnflag("FadeTime") + 1 / 1)
              part:Destroy()
            end
  
           else
            task.wait(visuals:returnflag("TrailLifetime") / 1)
            part:Destroy()
  
          end
          
    
         end)
  
        elseif visuals:returnflag("TracerType") == "Trail" then
  
         task.spawn(function()
          local part = Variables.Instancenew("Part", workspace)
          local part2 = Variables.Instancenew("Part", workspace)
          local beam = Variables.Instancenew("Beam", part)
          local at1 = Variables.Instancenew("Attachment", part)
          local at2 = Variables.Instancenew("Attachment", part2)
                  
      
          part.CanCollide = false
          part.Transparency = 1
          part.Anchored = true
          part.Position = origin
          part.Size = Variables.Vector3new(0.001, 0.001, 0.001)
          part.Shape = "Ball"
      
      
          part2.CanCollide = false
          part2.Transparency = 1
          part2.Anchored = true
          part2.Position = closest.Position
          part2.Size = Variables.Vector3new(0.001, 0.001, 0.001)
          part2.Shape = "Ball"
      
      
          beam.Texture = cheat.BulletTrails[visuals:returnflag("TrailID")]
          beam.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, visuals:returnflagcolor("BulletTracerColor")), ColorSequenceKeypoint.new(1, visuals:returnflagcolor("BulletTracerColor"))}
          beam.TextureSpeed = visuals:returnflag("TextureSpeed")
          beam.TextureLength = visuals:returnflag("TextureLength")
          beam.TextureMode = Enum.TextureMode.Stretch
          beam.Attachment0 = at1
          beam.Attachment1 = at2
          beam.LightInfluence = 0
          beam.LightEmission = 0
          beam.ZOffset = 0
      
      
          task.wait(visuals:returnflag("TrailLifetime") / 1)
          part:Destroy()
          part2:Destroy()
          
         end)
  
    end  
  end



  function visuals:createFOV()
    local G2L = {};
    do -- Crosshair shit
     -- StarterGui.FOV Circle
     G2L["1"] = Variables.Instancenew("ScreenGui", gethui());
     G2L["1"]["IgnoreGuiInset"] = true;
     G2L["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
     G2L["1"]["Name"] = [[FOV Circle]];
     G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
     
     
     -- StarterGui.FOV Circle.Frame
     G2L["2"] = Variables.Instancenew("Frame", G2L["1"]);
     G2L["2"]["BorderSizePixel"] = 0;
     G2L["2"]["BackgroundColor3"] = Variables.Color3fromRGB(255, 255, 255);
     G2L["2"]["AnchorPoint"] = Variables.Vector2new(0.5, 0.5);
     G2L["2"]["Size"] = Variables.UDim2new(0, 500, 0, 500);
     G2L["2"]["Position"] = Variables.UDim2new(0.5, 0, 0.5, 0);
     G2L["2"]["BorderColor3"] = Variables.Color3fromRGB(0, 0, 0);
     G2L["2"]["BackgroundTransparency"] = 1;


     G2L["Fill"] = Variables.Instancenew("UIShadow", G2L["2"])
     G2L["Fill"].Enabled = false
     
     
     -- StarterGui.FOV Circle.Frame.UICorner
     G2L["3"] = Variables.Instancenew("UICorner", G2L["2"]);
     G2L["3"]["CornerRadius"] = Variables.UDimnew(100, 100);
     
     
     -- StarterGui.FOV Circle.Frame.circle
     G2L["4"] = Variables.Instancenew("UIStroke", G2L["2"]);
     G2L["4"]["ZIndex"] = 5;
     G2L["4"]["Color"] = Variables.Color3fromRGB(255, 255, 255);
     G2L["4"]["Name"] = [[circle]];

     
     -- StarterGui.FOV Circle.Frame.circle.UIGradient
     G2L["5"] = Variables.Instancenew("UIGradient", G2L["4"]);
     G2L["5"]["Color"] = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Variables.Color3fromRGB(255, 0, 0)),ColorSequenceKeypoint.new(1.000, Variables.Color3fromRGB(255, 255, 255))};
     
     
     -- StarterGui.FOV Circle.Frame.circle.UIGradient.LocalScript
     G2L["6"] = Variables.Instancenew("LocalScript", G2L["5"]);
     
     
     -- StarterGui.FOV Circle.Frame.outline2
     G2L["7"] = Variables.Instancenew("UIStroke", G2L["2"]);
     G2L["7"].Enabled = false
     G2L["7"]["ZIndex"] = 0;
     G2L["7"]["Thickness"] = 2;
     G2L["7"]["Name"] = [[outline2]];
     G2L["7"]["BorderStrokePosition"] = Enum.BorderStrokePosition.Center;
     
     
     -- StarterGui.FOV Circle.Frame.outline
     G2L["8"] = Variables.Instancenew("UIStroke", G2L["2"]);
     G2L["8"].Enabled = false
     G2L["8"]["Thickness"] = 2;
     G2L["8"]["Name"] = [[outline]];
    end
  
   return G2L
  end



  function visuals:createCrosshair()
    local G2L = {};
    
    do -- Crosshair shit
      G2L["1"] = Variables.Instancenew("ScreenGui", gethui());
      G2L["1"]["IgnoreGuiInset"] = true;
      G2L["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
      G2L["1"]["Name"] = [[GunGUI]];
      G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
      G2L["1"].Enabled = false
  
  
      -- StarterGui.GunGUI.CrosshairFrame
      G2L["2"] = Variables.Instancenew("Frame", G2L["1"]);
      G2L["2"]["ZIndex"] = 0;
      G2L["2"]["BorderSizePixel"] = 0;
      G2L["2"]["BackgroundColor3"] = Variables.Color3fromRGB(255, 255, 255);
      G2L["2"]["Position"] = Variables.UDim2new(0.5, 0, 0.5, 0);
      G2L["2"]["BorderColor3"] = Variables.Color3fromRGB(28, 43, 54);
      G2L["2"]["Name"] = [[CrosshairFrame]];
      G2L["2"]["BackgroundTransparency"] = 1;
  
  
     -- StarterGui.GunGUI.CrosshairFrame.Left
     G2L["3"] = Variables.Instancenew("Frame", G2L["2"]);
     G2L["3"]["BorderSizePixel"] = 0;
     G2L["3"]["BackgroundColor3"] = Variables.Color3fromRGB(255, 255, 255);
     G2L["3"]["Size"] = Variables.UDim2new(0, 40, 0, 2);
     G2L["3"]["Position"] = Variables.UDim2new(0, -60, 0, -1);
     G2L["3"]["BorderColor3"] = Variables.Color3fromRGB(114, 114, 114);
     G2L["3"]["Name"] = [[Left]];
  
  
     -- StarterGui.GunGUI.CrosshairFrame.Left.UIStroke
     G2L["4"] = Variables.Instancenew("UIStroke", G2L["3"]);
     G2L["4"]["Thickness"] = 1;
  
  
     -- StarterGui.GunGUI.CrosshairFrame.Right
     G2L["5"] = Variables.Instancenew("Frame", G2L["2"]);
     G2L["5"]["BorderSizePixel"] = 0;
     G2L["5"]["BackgroundColor3"] = Variables.Color3fromRGB(255, 255, 255);
     G2L["5"]["Size"] = Variables.UDim2new(0, -40, 0, 2);
     G2L["5"]["Position"] = Variables.UDim2new(0, 60, 0, -1);
     G2L["5"]["BorderColor3"] = Variables.Color3fromRGB(114, 114, 114);
     G2L["5"]["Name"] = [[Right]]; 
  
  
      -- StarterGui.GunGUI.CrosshairFrame.Right.UIStroke
      G2L["6"] = Variables.Instancenew("UIStroke", G2L["5"]);
      G2L["6"]["Thickness"] = 1;
  
  
      -- StarterGui.GunGUI.CrosshairFrame.Bottom
      G2L["7"] = Variables.Instancenew("Frame", G2L["2"]);
      G2L["7"]["BorderSizePixel"] = 0;
      G2L["7"]["BackgroundColor3"] = Variables.Color3fromRGB(255, 255, 255);
      G2L["7"]["Size"] = Variables.UDim2new(0, 2, 0, -40);
      G2L["7"]["Position"] = Variables.UDim2new(0, -1, 0, 60);
      G2L["7"]["BorderColor3"] = Variables.Color3fromRGB(114, 114, 114);
      G2L["7"]["Name"] = [[Bottom]];
  
  
      -- StarterGui.GunGUI.CrosshairFrame.Bottom.UIStroke
      G2L["8"] = Variables.Instancenew("UIStroke", G2L["7"]);
      G2L["8"]["Thickness"] = 1;
  
  
      -- StarterGui.GunGUI.CrosshairFrame.Top
      G2L["9"] = Variables.Instancenew("Frame", G2L["2"]);
      G2L["9"]["BorderSizePixel"] = 0;
      G2L["9"]["BackgroundColor3"] = Variables.Color3fromRGB(255, 255, 255);
      G2L["9"]["Size"] = Variables.UDim2new(0, 2, 0, 40);
      G2L["9"]["Position"] = Variables.UDim2new(0, -1, 0, -60);
      G2L["9"]["BorderColor3"] = Variables.Color3fromRGB(114, 114, 114);
      G2L["9"]["Name"] = [[Top]];
  
  
  
      G2L["10"] = Variables.Instancenew("ImageLabel", G2L["2"]);
      G2L["10"]["ZIndex"] = 0;
      G2L["10"]["BorderSizePixel"] = 0;
      G2L["10"]["BackgroundColor3"] = Variables.Color3fromRGB(255, 255, 255);
      G2L["10"]["Position"] = Variables.UDim2new(0.5, 0, 0.5, 0);
      G2L["10"]["BorderColor3"] = Variables.Color3fromRGB(255, 255, 255);
      G2L["10"]["Name"] = [[Image]];
      G2L["10"]["BackgroundTransparency"] = 1;



      G2L["infoHolder"] = Variables.Instancenew("Frame", G2L["1"]);
      G2L["infoHolder"]["BorderSizePixel"] = 0;
      G2L["infoHolder"]["BackgroundColor3"] = Variables.Color3fromRGB(255, 255, 255);
      G2L["infoHolder"]["Size"] = Variables.UDim2new(0, 0, 0, 0);
      G2L["infoHolder"]["Position"] = Variables.UDim2new(0.5, 0, .525, 0);
      G2L["infoHolder"]["BorderColor3"] = Variables.Color3fromRGB(114, 114, 114);
      G2L["infoHolder"]["Name"] = [[infoHolder]];



      G2L["PlayerText"] = Variables.Instancenew("TextLabel", G2L["infoHolder"]);
      G2L["PlayerText"]["ZIndex"] = 0;
      G2L["PlayerText"]["BorderSizePixel"] = 0;
      G2L["PlayerText"]["BackgroundColor3"] = Variables.Color3fromRGB(255, 255, 255);
      G2L["PlayerText"]["Position"] = Variables.UDim2new(0, 0, 0, 0);
      G2L["PlayerText"]["BorderColor3"] = Variables.Color3fromRGB(28, 43, 54);
      G2L["PlayerText"]["Name"] = [[PlayerText]];
      G2L["PlayerText"]["BackgroundTransparency"] = 1;
      G2L["PlayerText"]["FontFace"] = Fonts["Minecraftia"]
      G2L["PlayerText"]["TextSize"] = 10
      G2L["PlayerText"]["Text"] = "Manipulated"
      G2L["PlayerText"]["TextColor3"] = Variables.Color3fromRGB(255, 32, 77)
      G2L["PlayerText"]["Visible"] = false
      G2L["PlayerText"]["RichText"] = true
      G2L["PlayerText"]["LayoutOrder"] = 1



      G2L["DistanceText"] = Variables.Instancenew("TextLabel", G2L["infoHolder"]);
      G2L["DistanceText"]["ZIndex"] = 0;
      G2L["DistanceText"]["BorderSizePixel"] = 0;
      G2L["DistanceText"]["BackgroundColor3"] = Variables.Color3fromRGB(255, 255, 255);
      G2L["DistanceText"]["Position"] = Variables.UDim2new(0, 0, 0, 0);
      G2L["DistanceText"]["BorderColor3"] = Variables.Color3fromRGB(28, 43, 54);
      G2L["DistanceText"]["Name"] = [[DistanceText]];
      G2L["DistanceText"]["BackgroundTransparency"] = 1;
      G2L["DistanceText"]["FontFace"] = Fonts["Minecraftia"]
      G2L["DistanceText"]["TextSize"] = 10
      G2L["DistanceText"]["Text"] = "Manipulated"
      G2L["DistanceText"]["TextColor3"] = Variables.Color3fromRGB(255, 32, 77)
      G2L["DistanceText"]["Visible"] = false
      G2L["DistanceText"]["RichText"] = true
      G2L["DistanceText"]["LayoutOrder"] = 2
      


      G2L["ManipulatedText"] = Variables.Instancenew("TextLabel", G2L["infoHolder"]);
      G2L["ManipulatedText"]["ZIndex"] = 0;
      G2L["ManipulatedText"]["BorderSizePixel"] = 0;
      G2L["ManipulatedText"]["BackgroundColor3"] = Variables.Color3fromRGB(255, 255, 255);
      G2L["ManipulatedText"]["Position"] = Variables.UDim2new(0, 0, 0, 0);
      G2L["ManipulatedText"]["BorderColor3"] = Variables.Color3fromRGB(28, 43, 54);
      G2L["ManipulatedText"]["Name"] = [[ManipulatedText]];
      G2L["ManipulatedText"]["BackgroundTransparency"] = 1;
      G2L["ManipulatedText"]["FontFace"] = Fonts["Minecraftia"]
      G2L["ManipulatedText"]["TextSize"] = 10
      G2L["ManipulatedText"]["Text"] = "Manipulated"
      G2L["ManipulatedText"]["TextColor3"] = Variables.Color3fromRGB(255, 32, 77)
      G2L["ManipulatedText"]["Visible"] = false
      G2L["ManipulatedText"]["RichText"] = true
      G2L["ManipulatedText"]["LayoutOrder"] = 3


      G2L["listLayout"] = Variables.Instancenew("UIListLayout", G2L["infoHolder"])
      G2L["listLayout"]["Padding"] = Variables.UDimnew(0, 12)
      G2L["listLayout"]["SortOrder"] = "LayoutOrder"
  
  
      -- StarterGui.GunGUI.CrosshairFrame.Top.UIStroke
      G2L["a"] = Variables.Instancenew("UIStroke", G2L["9"]);
      G2L["b"] = Variables.Instancenew("UIStroke", G2L["PlayerText"]);
      G2L["c"] = Variables.Instancenew("UIStroke", G2L["DistanceText"]);
      G2L["d"] = Variables.Instancenew("UIStroke", G2L["ManipulatedText"]);
  

    end

   return G2L
  end



  function visuals:connectBone(Bone, Visible, From, To, Thickness, Color, Zindex)
    Bone.Visible = Visible
    Bone.From = From
    Bone.To = To
    Bone.Thickness = Thickness
    Bone.Color = Color
    Bone.ZIndex = Zindex
  end



  function visuals:getBoneValue(cache, bonePart, value)
    return cache[bonePart][value]
  end



  function visuals:color3ToHex(color)
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
   return string.format("#%02X%02X%02X", r, g, b)
	end
 


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


end


local currenthitsound
do -- weapon

  weapon["manipOrigin"] = nil
  function weapon:TestHitSoundNew(sfx)
    task.spawn(function()
      if not getcustomasset(sfx) then
          return
      end
  
      local asset_id = getcustomasset(sfx)
      local sound = Instance.new("Sound", game.CoreGui)
  
      sound.SoundId = asset_id
      sound.Volume = visuals:returnflag("SoundVolume")
      currenthitsound = sfx
      sound:Play()
  
      task.wait(3)
      sound:Destroy()
        
    end)
  end

 
  function weapon:getAdvancedPrediction(originPos, targetPos, targetVelocity, targetAcceleration, v0, g)

     targetAcceleration = targetAcceleration or Vector3.new(0, 0, 0)

     

     local maxAccelTime = 0.5

     local predictedPos = targetPos

     local t = 0

     local MAX_ITERATIONS = 5

     

     -- 1. Convergence loop to find exact Time of Flight (ToF)

     for i = 1, MAX_ITERATIONS do

         local tAccel = math.min(t, maxAccelTime)

         

         -- Lead target position based on velocity & acceleration (jiggle check)
         local delta = (targetPos - originPos)
         local angleRad = math.atan2(delta.Y, delta.X)
         local vX, vY, vZ = (targetVelocity.X), (targetVelocity.Y * angleRad), (targetVelocity.Z)

         predictedPos = targetPos + (Vector3.new(vX, vY, vZ) * t) + (0.5 * targetAcceleration * tAccel * tAccel)

         

         -- Straight-line 3D distance between shooter and predicted position

         local distance = (predictedPos - originPos).Magnitude

         

         if distance == 0 then return targetPos, 0 end

         

         -- Time = Distance / Speed

         t = distance / v0

     end

     

     -- 2. Direct Gravity Drop Compensation

     -- Bullet drop = 1/2 * g * t^2

     -- To hit the target, we offset our aim UP by subtracting the negative gravity effect

     local dropCompensation = .5 - g * math.pow(t, 2)

     

     -- Add the drop offset directly to the predicted target's Y coordinate

     local aimTargetPos = Vector3.new(

         predictedPos.X,

         predictedPos.Y + dropCompensation, -- Offsets for drop (works automatically for targets above/below)

         predictedPos.Z

     )

     

     return aimTargetPos, t

  end
 
  
  function weapon:getPureMathOffsetVector(cameraCFrame, targetPosition, offsetX, offsetY, offsetZ)
      -- 1. Extract the local orientation axes from the camera's CFrame
      local camPos = cameraCFrame.Position
      local right = cameraCFrame.RightVector
      local up = cameraCFrame.UpVector
      local forward = cameraCFrame.LookVector
      
      -- 2. Mathematically shift the origin using local space offsets
      -- offsetX: positive = right, negative = left
      -- offsetY: positive = up, negative = down
      -- offsetZ: positive = forward, negative = backward (useful for pulling the origin inside or out)
      local shiftedOrigin = camPos + (right * offsetX) + (up * offsetY) + (forward * offsetZ)
      
      -- 3. Draw a pure directional vector from the new math-shifted origin to the target
      local direction = (targetPosition - shiftedOrigin).Unit
      
     return direction, shiftedOrigin
  end


  function weapon:getShiftedOrigin(origin, targetPosition, targetVelocity, bulletSpeed, bGravity, pingDelay, humanoid)
      local maxXShift = 0.5
      local maxYShiftBase = 3      -- base max vertical shift at standard bullet speeds
      local maxZShift = 0.5
      local maxVel = 25
      local verticalVelocityThreshold = 0.3
  
      -- Clamp horizontal velocity
      local vx = math.clamp(targetVelocity.X, -maxVel, maxVel)
      local vz = math.clamp(targetVelocity.Z, -maxVel, maxVel)
  
      local proportionX = math.abs(vx) / maxVel
      local proportionZ = math.abs(vz) / maxVel
  
      local xShift = proportionX * maxXShift * (vx >= 0 and 1 or -1)
      local zShift = proportionZ * maxZShift * (vz >= 0 and 1 or -1)
  
      local baseOrigin = origin + Vector3.new(xShift, 0, zShift)
  
      local verticalShiftAmount = 0
  
      if humanoid then
          local state = humanoid:GetState()
  
          if state == Enum.HumanoidStateType.Freefall
             or state == Enum.HumanoidStateType.Jumping
             or state == Enum.HumanoidStateType.Swimming
             or state == Enum.HumanoidStateType.Climbing
             or math.abs(targetVelocity.Y) > verticalVelocityThreshold then
  
              local vy = math.clamp(targetVelocity.Y, -maxVel, maxVel)
              local vyProportion = math.clamp(math.abs(vy) / maxVel, 0, 1)
              local moveDir = 0
  
              if state == Enum.HumanoidStateType.Climbing then
                  moveDir = math.sign(vy)
              elseif state == Enum.HumanoidStateType.Swimming then
                  moveDir = 1
              else
                  moveDir = math.sign(vy)
              end
  
              -- Calculate distance to target for bullet travel time
              local delta = targetPosition - baseOrigin
              local distanceToTarget = delta.Magnitude
  
              -- Calculate bullet travel time accurately
              local timeToHit = distanceToTarget / bulletSpeed + (pingDelay or 0)
  
              -- Bullet drop physics
              local gravity = bGravity or workspace.Gravity
              local bulletDrop = 0.5 * gravity * (timeToHit ^ 2)
  
              -- Scale vertical shift with bullet speed: slower bullets get larger allowance
              local speedFactor = math.clamp(100 / bulletSpeed, 1, 4)
              local maxVerticalShift = maxYShiftBase * speedFactor
  
              verticalShiftAmount = vyProportion * maxVerticalShift * moveDir + bulletDrop
          end
  
          -- Seated state (optional: add vertical shift if needed)
          if state == Enum.HumanoidStateType.Seated then
              verticalShiftAmount = verticalShiftAmount + 1.5  -- tune as needed
          end
      else
          -- Fallback for no humanoid
          local vy = math.clamp(targetVelocity.Y, -maxVel, maxVel)
          if math.abs(vy) > verticalVelocityThreshold then
              local delta = targetPosition - baseOrigin
              local distanceToTarget = delta.Magnitude
              local timeToHit = distanceToTarget / bulletSpeed + (pingDelay or 0)
              local gravity = bGravity or workspace.Gravity
              local bulletDrop = 0.5 * gravity * (timeToHit ^ 2)
              local speedFactor = math.clamp(100 / bulletSpeed, 1, 4)
              local maxVerticalShift = maxYShiftBase * speedFactor
              verticalShiftAmount = (math.abs(vy) / maxVel) * maxVerticalShift * math.sign(vy) + bulletDrop
          end
      end
  
      verticalShiftAmount = math.clamp(verticalShiftAmount, -maxYShiftBase * 4, maxYShiftBase * 4)
  
      -- Clamp origin above floor
      local rayOrigin = baseOrigin + Vector3.new(0, 2, 0)
      local rayDirection = Vector3.new(0, -50, 0)
      local rayResult = workspace:Raycast(rayOrigin, rayDirection)
      local floorY = rayResult and (rayResult.Position.Y + 3) or (baseOrigin.Y - 15)
  
      if baseOrigin.Y + verticalShiftAmount < floorY then
          verticalShiftAmount = floorY - baseOrigin.Y
      end
  
      local adjustedOrigin = baseOrigin + Vector3.new(0, verticalShiftAmount, 0)
      return adjustedOrigin
  end


  function weapon:FindTargetOrigin(origin, targetPart, radius, height, steps, referencePosition)
    	local bestOrigin = nil
    	local bestDistance = math.huge
    	local bestReach = nil -- how far bestOrigin ended up from `origin`
    
    	local targetDistance = (targetPart.Position - origin).Magnitude
    	radius = Math.Clamp(targetDistance * 0.1, 5, radius)
    
    	-- Reference direction: standing at origin, facing the target.
    	local forward = (targetPart.Position - origin) * Variables.Vector3new(1, 0, 1)
    	forward = forward.Magnitude > 1e-3 and forward.Unit or Variables.Vector3new(0, 0, -1)
    	local rightVector = forward:Cross(Variables.Vector3new(0, 1, 0))
    
    	local side = nil
    	if referencePosition then
    		local offset = referencePosition - origin
    		side = Variables.Vector3new(offset.X, 0, offset.Z):Dot(rightVector) >= 0 and 1 or -1
    	end
    
    	for i = 0, steps - 1 do
    		local angle = (math.pi * 2) * (i / steps)
    		local offsetX = Math.Cos(angle) * radius
    		local offsetZ = Math.Sin(angle) * radius
    
    		if side then
    			local sideValue = Variables.Vector3new(offsetX, 0, offsetZ):Dot(rightVector)
    			if sideValue * side < 0 then
    				continue
    			end
    		end
    
    		for h = -height, height, 1 do
    			local candidateOffset = Variables.Vector3new(offsetX, h, offsetZ)
    			local candidate = origin + candidateOffset
    			local direction = targetPart.Position - candidate
    
    			local ray = workspace:Raycast(candidate, direction)
    
    			if ray and ray.Instance:IsDescendantOf(targetPart.Parent) then
    				local distance = direction.Magnitude
    
    				if distance < bestDistance then
    					bestDistance = distance
    					bestOrigin = candidate
    					bestReach = candidateOffset.Magnitude
    				end
    			end
    		end
    	end
    
    	return bestOrigin, bestReach
  end


  function weapon:getVerticalAngleDegrees(origin: Vector3, target: Vector3): number
    local direction = target - origin
    local horizontalDistance = math.sqrt(direction.X^2 + direction.Z^2)
    
   
    local angleRadians = math.atan2(direction.Y, horizontalDistance)
    local angleDegrees = math.rad(angleRadians)
    
    return angleDegrees
  end

end


local indicator
function targeting:getTarget()
    local distance
    local target, targetPlayer


    local camera = workspace.CurrentCamera
    local maxDistance = visuals:returnflag("MaxDistance")


    local targetStyle = visuals:returnflag("targetStyle")
    local fovRadius = visuals:returnflag("FOVRadius")
    
    
    for _, P in lib do
      if typeof(P) ~= "table" then
        continue
      end

 
      
      local head, humanoid, player =  P.head, P.humanoid, P.Player
      if head and humanoid then
        if (head.Position - camera.CFrame.Position).Magnitude >= maxDistance then
          continue
        end

        local pos2, os = WorldToViewportPoint(camera, head.Position)
        local mouseP = Variables.UserInputService:GetMouseLocation()
        local targetPos, camPos, mousePos = Variables.Vector2new(pos2.X, pos2.Y), Variables.Vector2new(Variables["CameraOrigin"].X, Variables["CameraOrigin"].Y), Vector2.new(mouseP.X, mouseP.Y)
        local dist

        if targetStyle == "Mouse" then
          local mouseP = Variables.UserInputService:GetMouseLocation()
          dist = Math.Floor((targetPos - mousePos).Magnitude)
         else
          dist = Math.Floor((targetPos - camPos).Magnitude)
        end


        local validDist = ((dist <= (distance or Math.Floor(fovRadius) * 1.15)))
             
    
        if not os then
          continue
        end
    
    
        if validDist then
          target = head
          distance = dist
          targetPlayer = P
          indicator.change_health(humanoid.Health or 100)
          indicator.change_profile(player)
        end
        
    
        end
    end
    
        
  return target, targetPlayer
end


local dim2 = UDim2.new
local hex = Color3.fromHex
do -- sections + tabs
	local window = library:window({name = os.date('DankHaxx | %b %d %Y'), size = dim2(0, 750, 0, 782)})
	indicator = library:indicator()


	local Aiming = window:tab({name = "Aiming"})
  local Visuals = window:tab({name = "Visuals"})
	local Misc = window:tab({name = "Misc"})


  --section:button_holder({})
  --section:button({name = "Rejoin", callback = function()
    --game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
  --end})

	
  do --// Combat


  	do --// Silent
  			local column =  Aiming:column() 
  			local silentAim, RageBot = column:multi_section({names = {"Silent Aim", "RageBot"}})
        local manipulation = column:section({name = "Manipulation", toggle = false})


  			do --// Silent Aim
         silentAim:toggle({name = "Enabled", flag = "SilentAimToggle", risky = true})
         silentAim:toggle({name = "Wallbang", flag = "Wallbang", risky = true})
         silentAim:toggle({name = "Force-Hit", flag = "ForceHit", risky = true})
         silentAim:dropdown({
          	  name = "Targeting Style",
             flag = "targetStyle",
             items = {"FOV", "Mouse"},
             default = "FOV",
         })


   			 local fovToggle = silentAim:toggle({name = "FOV", flag = "FOVToggle"}):colorpicker({flag = "FOVGradientOne", color = hex("#FFFFFF")})
         fovToggle:colorpicker({flag = "FOVGradientTwo", color = hex("#FFFFFF")})
         silentAim:toggle({name = "FOV Outline", flag = "FOVOutline"}):colorpicker({flag = "OutlineColor", color = hex("#ffffff")})
         silentAim:toggle({name = "FOV Fill", flag = "fovFillEnabled"}):colorpicker({flag = "fovFillColor", color = hex("#ffffff")})
         silentAim:toggle({name = "Render On Barrel", flag = "renderFOVOnBarrel"})
         
   
          silentAim:slider({name = "Radius", min = 10, max = 1000, default = 100, interval = 1, flag = "FOVRadius"})
          silentAim:slider({name = "Thickness", min = 1, max = 5, default = 1, interval = 1, flag = "fovThickness"})
    			silentAim:toggle({name = "Gradient Spin", flag = "Gradient_Spin"})
    			silentAim:slider({name = "Rotation Speed", min = 1, max = 5, default = 0, interval = 1, flag = "Gradient_Spin_Speed"})

          silentAim:separator({name = "HitBox Expander"})

          silentAim:toggle({name = "Enabled", flag = "hitboxExpander", risky = false, warning = true, tooltip = "Recommended for people in the open, or close scenarios. Sadly not as OP as it used to be, so this may be 50/50 in your favor."})
          silentAim:slider({name = "Head Size", min = 1, max = 20, default = 10, interval = 1, flag = "hitboxExpanderAmount"})
          silentAim:slider({name = "Head Transparency", min = 0, max = 1, default = .5, interval = .1, flag = "hitboxTransparencyAmount"})
  
          silentAim:separator({name = "Melee"})

          silentAim:toggle({name = "Enabled", flag = "KnifeBotToggle", risky = true, tooltip = "tis, but a scratch."})
          silentAim:toggle({name = "Show Hit Tracers", flag = "meleeHitTracers", risky = false})
  
          silentAim:separator({name = "SnapLine Settings"})
  
          silentAim:toggle({name = "Snapline", flag = "Snapline"}):colorpicker({flag = "SnaplineColor", color = hex("#FFFFFF")})
          silentAim:toggle({name = "Snapline Outline", flag = "SnaplineOutline"}):colorpicker({flag = "SnaplineOutlineColor", color = hex("#000000")})
          silentAim:slider({name = "Thickness", min = 1, max = 5, default = 1, interval = 1, flag = "SnaplineThickness"})
  
          silentAim:separator({name = "Miscellanious"})
 
    			silentAim:toggle({
    				name = "Target Indicator", 
    				flag = "TargetIndicator",
    				callback = function(bool)
              indicator.set_visible(bool)
    				end
    			})
   			
   
          silentAim:toggle({name = "Hit Notifications", flag = "HitNotis"})
          silentAim:slider({name = "Notification Time", min = 1, max = 10, default = 2, interval = 1, flag = "HitTime"})
        end
      

        do --// Manip
          manipulation:toggle({
            name = "Enabled", 
            flag = "ManipulationToggle"
          }):keybind({
            name = "Manipulation",
            key = Enum.KeyCode.J,
            mode = "hold",
            flag = "ManipBind",
          })


          manipulation:slider({name = "Max Horizontal Scan", min = 1, max = 10, default = 3, interval = .1, flag = "HorzManip"})
          manipulation:slider({name = "Max Vertical Scan", min = 1, max = 10, default = 3, interval = .1, flag = "VertManip"})
          manipulation:slider({name = "Max Corner Radius", min = 1, max = 15, default = 3, interval = .1, flag = "MaxCornerRadius"})
        end
              
              
  			do --// RageBot
      		RageBot:toggle({name = "RageBot", flag = "RageBotToggle"}):keybind({
            name = "RageBot",
            key = nil,
            mode = "toggle",
            flag = "RageBotBind"
          })
          
  
  				RageBot:toggle({name = "Spoof On Shot", flag = "RageBotToggle", tooltip = "Desyncs your server position around while shooting. Or just TP's you a bit in simple terms.."})
  				RageBot:dropdown({
         	  name = "Spoof Checks",
            flag = "SpoofCheck",
            items = {"Randomize", "X-Axis Only", "X & Y Axis"},
            default = "Randomize",
          })
  
  
  			end
  	end 
      
      
    do --// Crosshair + gun mods
        local column2 = Aiming:column() 
        local Misc, Weapon  = column2:multi_section({names = {"Crosshair", "Weapon"}})
        local bulletTracers = column2:section({name = "Bullet Tracers", toggle = false})
          				

        do --// Misc
         Misc:toggle({name = "Crosshair", flag = "CrosshairEnabled"}):colorpicker({name = "Crosshair Color", flag = "Crosshair_Color", color = hex("#000000")})
         Misc:toggle({name = "Outline", flag = "CrosshairOutline"})
         Misc:toggle({name = "Follow Target", flag = "FollowTarget"})
         Misc:toggle({name = "Show On Barrel", flag = "OnBarrel"})
         Misc:toggle({name = "Spin", flag = "CrosshairSpin"})
   
         Misc:separator({name = "Animations"})
   
         Misc:dropdown({
           name = "Crosshair Animation",
           flag = "CrosshairAnim",
           items = {"Static", "Breathing"},
           default = "Static",
         })


         Misc:dropdown({
           name = "Visual Crosshair Animation",
           flag = "visualCrosshairAnim",
           items = {"Fading", "Flashing"},
           default = "Fading",
         })

         
         Misc:slider({name = "Max Pulse", min = 0, max = 20, default = 5, interval = 1, flag = "MaxPulse"})
         Misc:slider({name = "Cap Rate", min = 1, max = 5, default = 1.5, interval = .5, flag = "MaxRate"})
         Misc:slider({name = "Visual Animation Speed", min = 1, max = 10, default = 2, interval = 1, flag = "visualAnimSpeed"})
         Misc:slider({name = "Animation Speed", min = 1, max = 10, default = 2, interval = 1, flag = "animSpeed"})
         --Misc:slider({name = "Max Crosshair Thickness", min = 0, max = 3, default = 1, interval = 1, flag = "MaxCrossHairThickness"})
   
         Misc:separator({name = "Crosshair Settings"})
                     
         Misc:slider({name = "Crosshair Length", min = 0, max = 10, default = 1, interval = 1, flag = "CrosshairLength"})
     		 Misc:slider({name = "Crosshair Thickness", min = 0, max = 3, default = 1, interval = 1, flag = "CrossHairThickness"})
         Misc:slider({name = "Crosshair Gap", min = 0, max = 5, default = 1, interval = 1, flag = "CrosshairGap"})
         Misc:slider({name = "Crosshair Spin Speed", min = 0, max = 5, default = 1, interval = 1, flag = "CrosshairSpinSped"})
   
         Misc:separator({name = "Target Information"})
     
         Misc:toggle({name = "Show Name Info", flag = "showTargetName"}):colorpicker({name = "Target Name Color", flag = "Target_Name_Color", color = hex("#fffdfd")})
         Misc:toggle({name = "Show Distance Info", flag = "showTargetDistance"}):colorpicker({name = "Target Name Color", flag = "Target_Distance_Color", color = hex("#fffdfd")})
         Misc:toggle({name = "Show Manipulated", flag = "showManipulated"}):colorpicker({name = "Manipulated Color", flag = "Target_Manipulated_Color", color = hex("#fffdfd")})
         Misc:toggle({name = "Show Wallbang", flag = "showWallbang"}):colorpicker({name = "Manipulated Color", flag = "Target_Wallbang_Color", color = hex("#fffdfd")})
        end
  		

        do --// Weapon
          Weapon:separator({name = "Reloading"}) 
          Weapon:toggle({name = "Auto-Reload", flag = "AutoReload", tooltip = "Will re-stack your magazines."}) 
          Weapon:toggle({name = "Auto-Load Magazines On Reload", flag = "autoLoadMags"})

          Weapon:separator({name = "Movement"}) 

          Weapon:toggle({name = "Remove Aim Speed Penalty", flag = "aimCharacterSlowdown", tooltip = "Allows you run/walk the same speed while ADS no matter the gun"})
          Weapon:toggle({name = "Remove Jump Block", flag = "blocksJumpWhileHeld", tooltip = "Removes the jump block with consumables."})
          Weapon:toggle({name = "Disable Aim Requires Crouch", flag = "aimRequiresCrouch", tooltip = "Mainly affects the tank gun."})
  
          Weapon:separator({name = "Weapon Modifications"})
    
          Weapon:toggle({name = "Remove Spread", flag = "NoSpread"})
          Weapon:toggle({name = "All Fire Modes", flag = "AllFireModes"})
          Weapon:toggle({name = "Custom Fire-Rate", flag = "CustomFireRate"})
          Weapon:slider({name = "Fire-Rate", min = 1, max = 1100, default = 800, interval = 1, flag = "FireRateValue"})
                    
          Weapon:separator({name = "Aiming"})
  
          Weapon:toggle({name = "Change Aiming Field of View", flag = "ChangeAimFOV"})
          Weapon:slider({name = "Field of View", min = 10, max = 99, default = 80, interval = 1, flag = "newAimFieldOfView"})
  
          Weapon:separator({name = "Recoil Settings"})
  
          Weapon:toggle({name = "Remove Recoil", flag = "NoRecoil"})
          Weapon:slider({name = "Vertical Shift", min = 0, max = 1, default = 0, interval = .1, flag = "VerticalShift"})
          Weapon:slider({name = "Back Shift", min = 0, max = 10, default = 0, interval = 1, flag = "BackShift"})
          Weapon:dropdown({
           	name = "Recoil Type",
            flag = "RecoilType",
            items = {"Custom", "Remove All"},
            default = "Custom",
          })
  
          Weapon:separator({name = "Hit Sounds"})
  
          Weapon:toggle({name = "Hit Sounds", flag = "HitSoundEnabled", callback = function(bool) HitsoundEnabled = bool end}) 
          Weapon:dropdown({
           	name = "Headshot Sound",
            flag = "HeadshotSound",
            items = {"default", "neverlose", "xp", "rust", "skeet", "tf2", "sonic", "bow", "fingersnap"},
            default = "default",
          })
          Weapon:slider({name = "Sound Volume", min = .5, max = 10, default = 1, interval = .1, flag = "SoundVolume"})

        end
          
        
        do --// Bullet Tracers
          bulletTracers:toggle({name = "Bullet Tracers", flag = "BulletTracers"}):colorpicker({name = "Tracer Color", flag = "BulletTracerColor", color = hex("#000000")})
          bulletTracers:dropdown({
            name = "Tracer Type",
            flag = "TracerType",
            items = {"Part", "Trail"},
            default = "Trail",
          })

          bulletTracers:separator({name = "3D Tracers"})
  
          bulletTracers:dropdown({
           	name = "Tracer Shading",
            flag = "TracerShading",
            items = {"AlwaysOnTop", "XRayShaded", "XRay"},
            default = "XRayShaded",
          })


          bulletTracers:toggle({name = "Fade Animation", flag = "TracerAnimation"})
          bulletTracers:toggle({name = "Fade Reverses", flag = "TweenReverse"})
  
  
          bulletTracers:dropdown({
           	name = "Easing Style",
            flag = "EasingStyle",
            items = {"Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponetial", "Circular", "Cubic"},
            default = "Quad",
          })
          bulletTracers:dropdown({ 
            name = "Easing Direction",
            flag = "EasingDirection",
            items = {"In", "Out", "InOut"},
            default = "Out",
          })
          bulletTracers:dropdown({ 
            name = "Material",
            flag = "ChamMaterial",
            items = {"Neon", "ForceField", "Glass"},
            default = "Neon",
          })


          bulletTracers:slider({name = "Glow Multiplier", min = 1, max = 10, default = 5, interval = 1, flag = "GlowMultiplier"})
          bulletTracers:slider({name = "FadeTime", min = 1, max = 10, default = 2, interval = 1, flag = "FadeTime"})
          
          bulletTracers:slider({name = "Tracer Size", min = .001, max = 1, default = .05, interval = .001, flag = "TracerSize"})
          bulletTracers:slider({name = "Reflectance", min = 0, max = 1, default = 0, interval = .1, flag = "Reflectance"})
                    
          bulletTracers:separator({name = "2D Tracers"}) 
          
          bulletTracers:dropdown({
           	name = "Tracer Texture",
            flag = "TrailID",
            items = {"Electricity", "Pulse", "Lightning", "LightPulse", "Reflex", "Shards"},
            default = "Electricity",
          }) 

          bulletTracers:slider({name = "Texture Speed", min = 1, max = 10, default = 1, interval = 1, flag = "TextureSpeed"})
          bulletTracers:slider({name = "Trail Lifetime", min = 1, max = 10, default = 1, interval = 1, flag = "TrailLifetime"})

          bulletTracers:slider({name = "Texture Length", min = 1, max = 10, default = 1, interval = 1, flag = "TextureLength"})
        end 
    end


	end


  do --// Visuals
  		local esp;
  		local function update_elements() if esp and esp.refresh_elements then esp.refresh_elements() end end 


  		local column = Visuals:column()
      local section, vehicle, corpse = column:multi_section({names = {"Enemies", "Vehicles", "Corpse"}})


      local worldColumn = Visuals:column()
      local world = worldColumn:section({name = "World", toggle = false})


      local extra = column:section({name = "Quality Of Life", toggle = false})
      local chams = worldColumn:section({name = "Weapon Model", toggle = false})


  		do --// Player/Enemy
        section:toggle({name = "Enable ESP", flag = "EnableAll", callback = function() end})
        section:toggle({name = "Team Check", flag = "TeamCheck", callback = function() end})
        section:slider({name = "ESP Limit", min = 60, max = 360, default = 240, interval = 1, flag = "espLimit"})

        section:separator({name = "Animations"})

        section:toggle({name = "Fade On Distance", flag = "fadeOnDistance"})
        section:slider({name = "Max Fade Distance", min = 100, max = 20000, default = 1000, interval = 1, flag = "MaxFadeDistance"})
        section:slider({name = "Min Fade Distance", min = 100, max = 10000, default = 1000, interval = 1, flag = "MinFadeDistance"})
        section:slider({name = "Min Fade Transparency", min = 0, max = 1, default = .8, interval = .1, flag = "maxFadeTransparency"})

        section:separator({name = "Map"})

        section:toggle({name = "Map ESP", flag = "mapEnabled"})

        section:separator({name = "Texts"})

        local nameToggle = section:toggle({name = "Names", flag = "Names", callback = function() end}):colorpicker({flag = "Name_Color", callback = update_elements})
        section:toggle({name = "Use Display Name", flag = "UseDisplayName", callback = function() end})

    
        section:toggle({name = "Distance", flag = "Distance", callback = update_elements}):colorpicker({name = "Distance Color", flag = "Distance_Color", callback = update_elements})
        section:toggle({name = "Weapon", flag = "Weapon", callback = update_elements}):colorpicker({name = "Weapon Color", flag = "Weapon_Color", callback = update_elements})
  
  
    		section:toggle({name = "Visible", flag = "Vis", callback = update_elements}):colorpicker({name = "Visible Color", flag = "Vis_Color", callback = update_elements})
        :colorpicker({name = "Not Visible Color", flag = "Not_Vis_Color", callback = update_elements})
        

        section:toggle({name = "Manipulated", flag = "Manip", callback = update_elements}):colorpicker({name = "Manipulated Color", flag = "Manip_Color", callback = update_elements})
        :colorpicker({name = "Not Manipulated Color", flag = "Not_Manip_Color", callback = update_elements})


        section:toggle({name = "Health Flag", flag = "HealthText", callback = update_elements}):colorpicker({name = "Health Text Color", flag = "Health_Text_Color", callback = update_elements})
        section:toggle({name = "Aiming", flag = "AimingText", callback = update_elements}):colorpicker({name = "Aiming Color", flag = "Aiming_Color", callback = update_elements})
        :colorpicker({name = "Aiming Color", flag = "Not_Aiming_Color", callback = update_elements})
        section:toggle({name = "In Inventory", flag = "InventoryText", callback = update_elements}):colorpicker({name = "Inventory Color", flag = "Inventory_Color", callback = update_elements})
        :colorpicker({name = "Inventory Color", flag = "Not_Inventory_Color", callback = update_elements})
       

        section:separator({name = "Box"})
        
        section:toggle({name = "Boxes", flag = "Boxes", callback = update_elements}):colorpicker({name = "Box Color", flag = "Box_Color", callback = update_elements})
        section:toggle({name = "Box Fill", flag = "BoxFill", callback = update_elements}):colorpicker({name = "Box Fill Color One", flag = "Box_Fill_Color", callback = update_elements})
        :colorpicker({name = "Box Fill Color Two", flag = "Box_Fill_ColorTwo", callback = update_elements})
        section:slider({name = "Fill Rotation", min = 0, max = 180, default = 1000, interval = 1, flag = "FillRotation"})
        
        section:separator({name = "Health Bar"})
    
    		section:toggle({name = "Health Bar", flag = "Healthbar", callback = update_elements}):colorpicker({name = "Gradient Color One", flag = "GradientColor1", callback = update_elements})
    	  :colorpicker({name = "Gradient Color Two", flag = "GradientColor2", callback = update_elements})
        
        section:dropdown({
          name = "Health Bar Padding",
          flag = "HealthBarPadding",
          items = {"1 Pixel", "2 Pixel"},
          default = "1 Pixel",
        })


        section:toggle({name = "Skeleton", flag = "skeletonEnabled", callback = update_elements}):colorpicker({name = "Bone Color", flag = "boneColor", callback = update_elements})

        section:separator({name = "Chams"})
  
        section:toggle({name = "Glow Adornments", flag = "BoxChams", callback = update_elements}):colorpicker({name = "Box Chams Color", flag = "Box_Cham_Color", callback = update_elements})
        section:toggle({name = "Chams", flag = "Chams", callback = update_elements}):colorpicker({name = "Cham Color", flag = "Cham_Color", callback = update_elements})
        :colorpicker({name = "Cham Outline Color", flag = "Cham_Outline_Color", callback = update_elements})


        section:slider({name = "GlowMultiplier", min = 1, max = 10, default = 5, interval = 1, flag = "ChamGlowMultiplier"})
        section:dropdown({
          name = "Cham Shading",
          flag = "ChamShading",
          items = {"XRayShaded", "XRay"},
          default = "XRayShaded",
        })
        

        section:separator({name = "ESP Settings"})

        section:dropdown({
          name = "Distance Type",
          flag = "DistanceType",
          items = {"M", "ST", " Meters", " Studs"},
          default = "M",
        })
        section:dropdown({
          name = "Fonts",
          flag = "TextFont",
          items = {"SmallestPixel", "ProggyClean", "ProggyTiny", "Minecraftia", "Tahoma", "Tahoma Bold"},
          default = "Minecraftia",
        })

        section:dropdown({
          name = "Flag Font",
          flag = "TextFlagFont",
          items = {"SmallestPixel", "ProggyClean", "ProggyTiny", "Minecraftia", "Tahoma", "Tahoma Bold"},
          default = "Minecraftia",
        })
    		section:slider({name = "Max Distance", min = 100, max = 20000, default = 1000, interval = 1, flag = "MaxDistance"})
      end
 


      do --// Vehicle
        vehicle:toggle({name = "Names", flag = "VehicleNames", callback = function() end}):colorpicker({flag = "Vehicle_Name_Color", callback = update_elements})
    		vehicle:toggle({name = "Healthbar", flag = "VehicleHealthbar", callback = update_elements}):colorpicker({name = "High HP Color", flag = "Vehicle_Health_High", callback = update_elements})
    		:colorpicker({name = "Medium HP Color", flag = "Vehicle_Health_Medium", callback = update_elements})
    		:colorpicker({name = "Low HP Color", flag = "Vehicle_Health_Low", callback = update_elements})
    
    		vehicle:toggle({name = "Healthbar Gradient", flag = "VehicleHealthbarGradient", callback = update_elements}):colorpicker({name = "Gradient Color One", flag = "VehicleGradientColor1", callback = update_elements})
    	    :colorpicker({name = "Gradient Color Two", flag = "VehicleGradientColor2", callback = update_elements})
   
    		vehicle:toggle({name = "Distance", flag = "VehicleDistance", callback = update_elements}):colorpicker({name = "Distance Color", flag = "Vehicle_Distance_Color", callback = update_elements})
        vehicle:toggle({name = "Fade On Distance", flag = "VehicleFadeOnDistance"})
   
        vehicle:dropdown({
          name = "Distance Type",
          flag = "VehicleDistanceType",
          items = {"M", "ST", " Meters", " Studs"},
          default = "M",
        })
   
        vehicle:slider({name = "Max Distance", min = 100, max = 20000, default = 1000, interval = 1, flag = "VehicleMaxDistance"})
      end



      do --// Corpse
        corpse:toggle({name = "Names", flag = "CorpseNames", callback = function() end}):colorpicker({flag = "Corpse_Name_Color"})
    		corpse:toggle({name = "Healthbar", flag = "CorpseHealthbar", callback = update_elements}):colorpicker({name = "High HP Color", flag = "Corpse_Health_High", callback = update_elements})
    		:colorpicker({name = "Medium HP Color", flag = "Corpse_Health_Medium", callback = update_elements})
    		:colorpicker({name = "Low HP Color", flag = "Corpse_Health_Low", callback = update_elements})
        
    
    		corpse:toggle({name = "Healthbar Gradient", flag = "CorpseHealthbarGradient", callback = update_elements}):colorpicker({name = "Gradient Color One", flag = "CorpseGradientColor1", callback = update_elements})
    	  :colorpicker({name = "Gradient Color Two", flag = "CorpseGradientColor2", callback = update_elements})
   

    		corpse:toggle({name = "Distance", flag = "CorpseDistance", callback = update_elements}):colorpicker({name = "Distance Color", flag = "Corpse_Distance_Color", callback = update_elements})
        corpse:toggle({name = "Time Flag", flag = "CorpseHealthText", callback = update_elements}):colorpicker({name = "Time Text Color", flag = "Corpse_Health_Text_Color", callback = update_elements})
        corpse:dropdown({
          name = "Distance Type",
          flag = "CorpseDistanceType",
          items = {"M", "ST", " Meters", " Studs"},
          default = "M",
        })
   
        corpse:slider({name = "Max Distance", min = 100, max = 20000, default = 1000, interval = 1, flag = "CorpseMaxDistance"})
      end



      do --// World
        world:toggle({name = "Masterswitch", flag = "worldMasterSwitch", callback = function() end})
        world:toggle({name = "Custom Lighting", flag = "CustomLighting", callback = function() end})
    		world:toggle({name = "Ambient", flag = "Ambient", callback = update_elements}):colorpicker({name = "Ambient Color", flag = "Ambient_Color"})


        world:toggle({name = "Skybox", flag = "Skybox", callback = update_elements})
        world:dropdown({
          name = "Skybox Texture",
          flag = "SkyboxTexture",
          items = {"Blood Moon", "Starry Night"},
          default = "Blood Moon",
        })
        
        
        world:toggle({name = "FullBright", flag = "FullBright", callback = update_elements})
        world:slider({
          name = "Expose Amount",
           min = 0, 
           max = 3, 
           default = 12, 
           interval = 1, 
           flag = "ExposureAmount",
           callback = function(float) 
           end
        })
        
       
        world:toggle({name = "Clouds", flag = "Clouds", callback = update_elements}):colorpicker({name = "Cloud Color", flag = "Cloud_Color"})
        world:toggle({name = "Custom Atmosphere", flag = "Atmosphere", callback = update_elements}):colorpicker({name = "Haze", flag = "Atmosphere_Color"})
        :colorpicker({name = "Decay", flag = "Atmosphere_Color_Two"})
        world:slider({
          name = "Fog Density",
           min = 0, 
           max = 1, 
           default = .33, 
           interval = .1, 
           flag = "FogDensity",
           callback = function(float) 
           end
        })
        

        world:slider({
          name = "Time Of Day",
           min = 12, 
           max = 24, 
           default = 12, 
           interval = 1, 
           flag = "TimeOfDay",
           callback = function(float) 
            Variables.ChangeLighting(float)
           end
        })
      

        world:toggle({
          name = "Remove Moon/Sun", 
          flag = "AllowCelestialBodies",
          callback = function(bool) 
            Variables.RemoveCelestialBodies(bool)
          end
        })


        world:toggle({
          name = "Edit Celestial Size", 
          flag = "EditCelestialBodies",
          callback = function(bool) 
            Variables.EditCelestialBodies(bool)
          end
        })


        world:toggle({
          name = "Remove Shadows", 
          flag = "RemoveShadows",
          callback = function(bool) 
            Variables.RemoveShadows(bool)
          end
        })

       
        world:slider({
          name = "Celestial Size",
           min = 12, 
           max = 60, 
           default = 1, 
           interval = 1, 
           flag = "CelestialSize",
           callback = function(float) 
            Variables.EditCelestialBodies(float)
           end
        })
        world:slider({name = "Glare", min = 0, max = 10, default = .5, interval = .5, flag = "GlareAmount"})
        world:slider({name = "Haze", min = 0, max = 10, default = .5, interval = .5, flag = "HazeAmount"})
        
        --world:slider({name = "Max Distance", min = 100, max = 20000, default = 1000, interval = 1, flag = "FogDistance"})
      end



      do --// Quality Of Life/Extra
        extra:toggle({
          name = "Zoom", 
          flag = "zoomToggle", 
          tooltip = "useful for far range"
        }):keybind({
          name = "Zooming",
          key = nil,
          mode = "toggle",
          flag = "zoomingBind"
        })


        extra:toggle({
          name = "Remove Inventory Blur",
          flag = "MenuBlur",
          callback = function(bool) 
            Variables.RemoveBlur(bool)
          end
        })



        extra:toggle({
          name = "Remove Bullet Flinch",
          flag = "noFlinch",
          tooltip = "Removes the flinching affect when you are shot at."
        })



        extra:toggle({
          name = "Remove Damage Effects",
          flag = "removeDamageAffect"
        })



        extra:toggle({
          name = "Remove Muzzle Flash",
          flag = "removeMuzzleFlash"
        })



        extra:toggle({
          name = "Spoof Kill-Feed",
          flag = "spoofKillFeed",
          tooltip = "just changes your name in the feed, most likely client sided(?)"
        })


      end



      do --// Chams
        chams:toggle({
          name = "Weapon Chams",
          flag = "WeaponChams",
        }):colorpicker({name = "Cham Color", flag = "Weapon_Cham_Color"})


        chams:toggle({
          name = "Inverted Chams",
          flag = "InvertedWeaponChams",
        })


        chams:toggle({
          name = "Any Weapon Model",
          flag = "anyWeaponModel",
        })


        chams:dropdown({
          name = "Cham Texture",
          flag = "WeaponChamTexture",
          items = {"ForceField", "Glass", "Neon"},
          default = "Neon",
        })


        world:slider({
          name = "Transparency",
           min = 0, 
           max = 1, 
           default = 0, 
           interval = .5, 
           flag = "TransparencyAmount",
           callback = function(float) 
           end
        })


        world:slider({
          name = "Reflectance",
           min = 0, 
           max = 1, 
           default = 0, 
           interval = .5, 
           flag = "ReflectanceAmount",
           callback = function(float) 
           end
        })


      end



	end


  do --// Movement + Anti-Aim
		local column, column2 = Misc:column(), Misc:column()
		local movementSection = column:section({name = "Movement", toggle = false})
    local characterSection, weaponSection = column:multi_section({names = {"Character", "Weapon"}})


    local vehicleTPSection = column2:section({name = "Vehicle", toggle = false})
    local vehicleModsSection = column2:section({name = "Vehicle Mods", toggle = false})


    do --// Movement Based
      movementSection:toggle({
        name = "Bunny-Hop", 
        flag = "RemoveJumpDebounce",
        callback = function(bool) 
          --local func = getGCFunction("attemptJump")
        
          if bool then
            --debug.setconstant(func, 26, Enum.HumanoidStateType.Climbing)
           else
            --debug.setconstant(func, 26, Enum.HumanoidStateType.Jumping)
          end
  
        end
      })


      movementSection:toggle({
        name = "Auto-Hop", 
        flag = "autoHop"
      }):keybind({
        name = "Auto-Hop",
        key = nil,
        mode = "toggle",
        flag = "AutoHopBind"
      })


      movementSection:toggle({
        name = "Jesus", 
        flag = "Jesus",
        tooltip = "Allows you to walk on water."
      })


      movementSection:toggle({
        name = "Remove Ragdoll/Vehicle Stun", 
        flag = "removeRagdollStun"
      })


    end


    do --// misc
      characterSection:toggle({
        name = "Edit Character Pitch",
        flag = "AAEnabled"
      })
      characterSection:toggle({
        name = "Spinbot",
        flag = "Spinbot"
      })
      characterSection:toggle({
        name = "Randomize Pitch",
        flag = "RandomizePitch"
      })


      movementSection:toggle({
        name = "Self-Backtrack", 
        flag = "selfBacktrack",
        risky = true,
        tooltip = "Should only be used with a hold bind, best for peeking angles on high ping servers and for HvH in general :3"
      }):keybind({
            name = "Self-Backtrack",
            key = nil,
            mode = "hold",
            flag = "selfBacktrackBind"
      })


      characterSection:slider({name = "Pitch Angle", min = -1, max = 1, default = 0, interval = 1, flag = "PitchAngle"})
      characterSection:toggle({
        name = "Teleport To Body After Death",
        flag = "TpAfterDeath"
      })
  

    end


    do --// weapon duping :money_mouth:
      weaponSection:button_holder({})
      weaponSection:button({name = "Dupe Attachments", callback = function()
        weapon:dupeAttachment()
      end})
      

    end


    do --// misc
      vehicleTPSection:button_holder({})
      vehicleTPSection:button({name = "Vehicle Teleport", callback = function()
        
      end})
      

    end


	end


  indicator.change_health(100)
  indicator.change_profile(Variables.Players.LocalPlayer)
  Aiming.open_tab()
  

end


do --// ESP Functions
   function lib:DrawGradient(properties)
       local obj = Variables.Instancenew("UIGradient")
       obj.Name = "UIGradient"
       obj.Parent = properties.Parent
   
       obj.Rotation = properties.Rotation
       obj.Color = properties.Color
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
  
   
   function lib:disconnect(self)
       lib[self].holder:Destroy()
       lib[self] = nil
   end
   
   
   function returngradientcolor(color, colortwo)
      return Variables.NewGradient{Variables.GradientSequence(0, visuals:returnflagcolor(color)), Variables.GradientSequence(1, visuals:returnflagcolor(colortwo))}
   end
   

   function returnGradientTransparency(color, colortwo)
      return Variables.GradientNumberSequence{GradientNumberKeypoint(0, visuals:returnflagtransparency(color)), GradientNumberKeypoint(1, visuals:returnflagtransparency(colortwo))}
   end
   
   
   local GetPFromChar = function(p)
    return Variables.Players:GetPlayerFromCharacter(p)
   end

   
   function lib:FindFlagSpace(fType, UI, item)
    if fType == "Bottom" then
        local f = UI.BottomFlags
        if not f then
            warn("BottomFlags doesn't exist!!!!")
            return
        end


        return f
    end


    if fType == "Left" then
        local f = UI.LeftFlags
        if not f then
            warn("LeftFlags doesn't exist!!!!")
            return
        end

        return f
    end


   end

   
   
   local ESPObject = function(self)
     lib[self] = {Name = self.Name, Player = self, Character = self.Character, holder = Variables.Instancenew("Frame", visualHolder), playerVis = false, playerManip = false, partCache = {}, boneCache = {}, chamCache = {}, chamCacheTwo = {}, headDrawing = Drawing.new("Circle"), headDrawingOutline = Drawing.new("Circle"), connection, Colors = Variables.Instancenew("Folder"), Borders = Variables.Instancenew("Folder"), chamsholder = Variables.Instancenew("Folder"), highlight = Variables.Instancenew("Highlight", visualHolder)}
     local esp, player = lib[self], lib[self]
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
          Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Variables.Color3fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Variables.Color3fromRGB(255, 255, 255))}
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
       HealthTextPadding.PaddingBottom = Variables.UDimnew(0, -9)
       HealthTextPadding.PaddingLeft = Variables.UDimnew(0, -14)


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
       AimTextPadding.PaddingRight = Variables.UDimnew(0, -29)
       AimTextPadding.PaddingTop = Variables.UDimnew(0, -2)



       local InventoryTextPadding = Variables.Instancenew("UIPadding", esp.holder["RightFlags"]["RightFlagsTwo"]["InventoryText"])
       InventoryTextPadding.PaddingTop = Variables.UDimnew(0, -4)
       InventoryTextPadding.PaddingRight = Variables.UDimnew(0, -51)

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


     local Character = self.Character
     esp.root, esp.humanoid = Character:WaitForChild("HumanoidRootPart", 60) or FindFirstChild(Character, "HumanoidRootPart"), Character:WaitForChild("Humanoid", 60) or FindFirstChild(Character, "Humanoid")
     esp.head = Character:WaitForChild("Head", 60) or FindFirstChild(Character, "Head")
     lib[self].highlight.Adornee = Character
     lib[self].highlight.Enabled = false
     lib[self].highlight.FillTransparency = -1

 
     for _, part in Character:GetChildren() do
        if part:IsA("MeshPart") or part:IsA("Part") then
         esp.partCache[part] = Character:WaitForChild(part.Name, 60) or FindFirstChild(Character, part.Name)
         esp.boneCache[part.Name] = {Part = Character:WaitForChild(part.Name, 60) or FindFirstChild(Character, part.Name), Line = Drawing.new("Line"), Outline = Drawing.new("Line")}
        end
     end
      
    
     return lib[self]
   end

 
   local newCharacter = function(Character)
    local v = ESPObject(GetPFromChar(Character))
    ESP:getParts(v, Character)


    v.Character.ChildAdded:Connect(function(weapon)
      v.weapon = weapon
    end)


    v.Character.ChildRemoved:Connect(function(weapon)
      v.weapon = nil
    end)

   end


   local OnRemoved = function(player)
      if lib[player] then
          lib[player].holder:Destroy()
          lib[player] = nil
      end

   end

   
   local newPlayer = function(player)
     if player.Character then
       Variables.taskdefer(newCharacter, player.Character)
     end

     
     player.CharacterAdded:Connect(newCharacter)
     player.CharacterRemoving:Connect(function()
       if lib[player] then
          lib[player].holder:Destroy()
          for _, bone in lib[player].boneCache do
            bone.Line:Destroy()
            bone.Outline:Destroy()
          end
          lib[player].boneCache = nil
          lib[player] = nil
       end
     end)

   end


   Variables.Players.PlayerAdded:Connect(newPlayer)
   Variables.Players.PlayerRemoving:Connect(OnRemoved)
   for _, player in Variables.Players:GetPlayers() do
      if player.Name ~= Variables.Players.LocalPlayer.Name then
        Variables.taskdefer(newPlayer, player)
      end
   end

end


do --// Connections
    local lastTick = os.clock()
    local targetFPS = 500


    local targetSeconds = 1 / targetFPS
    local animationSpeed = 1


    local healthBarPadding = cheat.healthBarSettings[visuals:returnflag("HealthBarPadding")].Padding
    local currentTextFont, flagFont = visuals:returnflag("TextFont"), visuals:returnflag("TextFlagFont")


    local textFont = Fonts[currentTextFont]
    local textSettings = cheat.fontSettings[currentTextFont]
    
    
    local isHealthBarGradient = visuals:returnflag("HealthbarGradient")
    local healthBarPaddingSize = cheat.healthBarSettings[visuals:returnflag("HealthBarPadding")].Size


    local UseDisplayName = visuals:returnflag("UseDisplayName") 
    local textFlagFont = cheat.fontSettings[flagFont]


    local lastShotUpdate = tick()
    local waitTime
    
 

    Variables.RunService.PreRender:Connect(function(deltatime)
      local isFadeOnDistance, maxFadeDistance, minFadeDistance, maxFadeTransparency = visuals:returnflag("fadeOnDistance"), visuals:returnflag("MaxFadeDistance"), visuals:returnflag("MinFadeDistance"), visuals:returnflag("maxFadeTransparency")
      local isHealthText, healthTextColor  = visuals:returnflag("HealthText"), visuals:returnflagcolor("Health_Text_Color")
      
      
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

       
      for _, player in lib do
          local currentTick = os.clock()
          local elapsed = currentTick - lastTick
      
      
          lastTick += deltatime
        	if (lastTick < 1 / espLimit) then
        		return
        	end
        	lastTick = 0


          if typeof(player) ~= "table" and typeof(player) ~= nil then
            continue
          end


          local head, root, humanoid, character = player.head, player.root, player.humanoid, player.Character
          local esp, UI = player.holder, player.UI
          if not Client.Character or not character or not root or not humanoid or not head then
            esp.Visible = false
            for _, cham in player.chamCache do
              cham.Visible = false
            end
  
            for _, cham in player.chamCacheTwo do
              cham.Visible = false
            end

            for _, bone in player.boneCache do
              bone.Line.Visible = false
              bone.Outline.Visible = false
            end
  
            continue
          end
  
  
          if not isEnabled or humanoid.Health < 0 then
            esp.Visible = false

            for _, bone in player.boneCache do
              bone.Line.Visible = false
              bone.Outline.Visible = false
            end
  
            continue
          end

              
          local rootPos = root.Position
          local pos2, isRootVis = WorldToViewportPoint(Camera, rootPos)

              
          local distancemag = Math.Floor((rootPos - Camera.CFrame.Position).Magnitude)
          local canSee = ESP:distanceCheck(distancemag, isRootVis)
          

          if not isRootVis or not canSee then
              esp.Visible = false

              for _, bone in player.boneCache do
                bone.Line.Visible = false
                bone.Outline.Visible = false
              end

            continue
          end

          
          local partCache, boneCache = player.partCache, player.boneCache
          local chams = player.chamsholder

          
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

              
          local isPlayerVis, isPlayerManip = player.playerVis, player.playerManip
          local healthTextPadding = UI.HealthTextPadding


          local nameText, distanceText, weaponText, visFlag, manipFlag, healthFlag, aimingFlag, inventoryFlag = UI.PName, UI.Distance, UI.Weapon, UI.VisFlag, UI.ManipFlag, UI.HealthText, UI.AimingText, UI.InventoryText
          local healthBar, bar, barGradient = UI.HealthBar, UI.Bar
          local weapon = player.Weapon or "Empty"

              
          local centerX = top2D.X
          local centerY = top2D.Y
          local height = Math.Floor(bottom2D.Y - centerY)
            
              
          local width = Math.Floor(height * .6) 
          local boxYSize = Math.Floor(height * 1.16 + 7)
          local posClamp = Math.Floor(centerY - height * .019)

              
          local boxTotalWidth = Math.Floor(width * 1.16 + 5)
          local halfBoxWidth = Math.Floor(boxTotalWidth * .5)

              
          local leftX = centerX - halfBoxWidth - healthBarPadding
          local rightX = centerX + halfBoxWidth + healthBarPadding
  
             
            do
                esp.Visible = true
            end
          

            do --// Texts
                do --// Name
                 nameText.Visible = isName
                 nameText.Position = Variables.UDim2fromOffset(centerX, Math.Floor( posClamp - textSettings.namePadding ))
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
                  visFlag.TextColor3 = ESP:getVis(true, isVisColor, notVisColor)
                  visFlag.FontFace = textFont
                  visFlag.TextSize = textSettings.FontSize
                  
    
                  if isVisible then

                   local visCheck = Camera:GetPartsObscuringTarget({Camera.CFrame.Position, head.Position}, {Client.Character, character})
                   if #visCheck > 0 then
                     player.playerVis = false
                    else
                     player.playerVis = true
                   end

                  end
    
                end
    
  
                do --// Manip
                 manipFlag.Visible = false
                end
               

                do --// Misc Flags
                  
              
                  -- Update animation if enough time has passed
                  if elapsed >= 1 / elapsed * animationSpeed then
                    local cutOff = Math.Clamp((distancemag-250)/(330-250), 0, 1)
                    aimingFlag.Transparency = cutOff
                    aimingFlag["UIStroke"].Transparency = cutOff

                    inventoryFlag.Transparency = cutOff
                    inventoryFlag["UIStroke"].Transparency = cutOff


                    if isFadeOnDistance then
                      local cutOff = Math.Clamp((distancemag-minFadeDistance)/(maxFadeDistance-minFadeDistance), 0, maxFadeTransparency)
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
                  healthFlag.Text = Math.Floor(humanoid.Health)


                  healthFlag.FontFace = textFont
                  healthFlag.TextSize = textFlagFont.FontSize
                  healthTextPadding.PaddingBottom = Variables.UDimnew(0, textSettings.bottomHealthTextPadding)
                  healthTextPadding.PaddingLeft = Variables.UDimnew(0, textSettings.leftHealthTextPadding)


                  aimingFlag.Visible = isAimingText
                  aimingFlag.TextColor3 = ESP:getVis(true, isAimingColor, notAimingColor)


                  aimingFlag.FontFace = textFont
                  aimingFlag.TextSize = textFlagFont.FontSize


                  inventoryFlag.Visible = isInventoryText
                  inventoryFlag.TextColor3 = ESP:getVis(true, isInventoryColor, notInventoryColor)


                  inventoryFlag.FontFace = textFont
                  inventoryFlag.TextSize = textFlagFont.FontSize


                  --healthTextPadding.PaddingBottom = Variables.UDimnew(0, textSettings.bottomHealthTextPadding)
                  --healthTextPadding.PaddingLeft = Variables.UDimnew(0, textSettings.leftHealthTextPadding)
                end
                

                UI.BottomFlags.Position = Variables.UDim2fromOffset(centerX, Math.Floor( posClamp + boxYSize + textSettings.bottomPadding))
                UI.bottomListLayout.Padding = Variables.UDimnew(0, textSettings.bottomListLayoutPadding)
            end

               
            do --// Skeleton
                  local upperTorso, lowerTorso = visuals:getBoneValue(boneCache, "UpperTorso", "Part"), visuals:getBoneValue(boneCache, "LowerTorso", "Part")
                  
                  local headPos, headBone, headOutline = WorldToViewportPoint(Camera, head.Position - Variables.Vector3new(0, .5, 0)), visuals:getBoneValue(boneCache, "Head", "Line"), visuals:getBoneValue(boneCache, "Head", "Outline")
                  local upperTorsoPos, upperTorsoBone, upperTorsoOutline = WorldToViewportPoint(Camera, upperTorso.Position), visuals:getBoneValue(boneCache, "UpperTorso", "Line"), visuals:getBoneValue(boneCache, "UpperTorso", "Outline")
                  local lowerTorsoPos, lowerTorsoBone, lowerTorsoOutline = WorldToViewportPoint(Camera, upperTorso.Position), visuals:getBoneValue(boneCache, "LowerTorso", "Line"), visuals:getBoneValue(boneCache, "LowerTorso", "Outline")
              

                  do --// Torso
                      visuals:connectBone(headBone, isSkeleton and isRootVis, Vector2.new(headPos.X, headPos.Y), Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(headOutline, isSkeleton and isRootVis, Vector2.new(headPos.X, headPos.Y), Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      visuals:connectBone(upperTorsoBone, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(pos2.X, pos2.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(upperTorsoOutline, isSkeleton and isRootVis, Vector2.new(upperTorsoPos.X, upperTorsoPos.Y), Vector2.new(pos2.X, pos2.Y), outlineThickness, outlineColor, outlineZIndex)
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
              

                  do --// Lower Torso
                      visuals:connectBone(lowerTorsoBone, isSkeleton and isRootVis, Vector2.new(pos2.X, pos2.Y), Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(lowerTorsoOutline, isSkeleton and isRootVis, Vector2.new(pos2.X, pos2.Y), Vector2.new(lowerTorsoPos.X, lowerTorsoPos.Y), outlineThickness, outlineColor, outlineZIndex)
                  end
              

                  do --// Left Leg
                      local leftUpperLeg, leftLowerLeg, leftFoot = visuals:getBoneValue(boneCache, "LeftUpperLeg", "Part"), visuals:getBoneValue(boneCache, "LeftLowerLeg", "Part"), visuals:getBoneValue(boneCache, "LeftFoot", "Part")
              
                      local leftUpperLegPos, leftUpperLegBone, leftUpperLegOutline = WorldToViewportPoint(Camera, leftUpperLeg.Position + Variables.Vector3new(0, .5, 0)), visuals:getBoneValue(boneCache, "LeftUpperLeg", "Line"), visuals:getBoneValue(boneCache, "LeftUpperLeg", "Outline")
                      local leftLowerLegPos, leftLowerLegBone, leftLowerLegOutline = WorldToViewportPoint(Camera, leftLowerLeg.Position), visuals:getBoneValue(boneCache, "LeftLowerLeg", "Line"), visuals:getBoneValue(boneCache, "LeftLowerLeg", "Outline")
                      local leftFootPos, leftFootBone, leftFootOutline = WorldToViewportPoint(Camera, leftFoot.Position), visuals:getBoneValue(boneCache, "LeftFoot", "Line"), visuals:getBoneValue(boneCache, "LeftFoot", "Outline")
              
                      visuals:connectBone(leftUpperLegBone, isSkeleton and isRootVis, Vector2.new(pos2.X, pos2.Y), Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(leftUpperLegOutline, isSkeleton and isRootVis, Vector2.new(pos2.X, pos2.Y), Vector2.new(leftUpperLegPos.X, leftUpperLegPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
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
              
                      visuals:connectBone(rightUpperLegBone, isSkeleton and isRootVis, Vector2.new(pos2.X, pos2.Y), Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(rightUpperLegOutline, isSkeleton and isRootVis, Vector2.new(pos2.X, pos2.Y), Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      visuals:connectBone(rightLowerLegBone, isSkeleton and isRootVis, Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y), Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(rightLowerLegOutline, isSkeleton and isRootVis, Vector2.new(rightUpperLegPos.X, rightUpperLegPos.Y), Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y), outlineThickness, outlineColor, outlineZIndex)
              
                      visuals:connectBone(rightFootBone, isSkeleton and isRootVis, Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y), Vector2.new(rightFootPos.X, rightFootPos.Y), boneThickness, boneColor, boneZIndex)
                      visuals:connectBone(rightFootOutline, isSkeleton and isRootVis, Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y), Vector2.new(rightFootPos.X, rightFootPos.Y), outlineThickness, outlineColor, outlineZIndex)
                  end

            end
                

            do --// Flags
                rightFlags.Position = Variables.UDim2fromOffset(rightX, posClamp)
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
                    boxFill.UIGradient.Rotation = fillRotation
                    boxFill.Transparency = 0
                    boxFill.UIGradient.Transparency = fillGradientTransparency
                    boxFill.UIGradient.Color = fillGradientColor
                end
             
  
                do -- Health Bar
                  leftListLayout.Padding = Variables.UDimnew(0, textSettings.leftListLayoutPadding)
                  healthBar.Visible = isHealthBar


                  healthBar.Size = Variables.UDim2new(0, healthBarPaddingSize, 0, boxYSize)
                  leftFlags.Size = Variables.UDim2fromOffset(-1, boxYSize)
                  bar.Size = Variables.UDim2new(1, 0, humanoid.Health / humanoid.MaxHealth, 0)
                   
                   
                  leftFlags.Position = Variables.UDim2fromOffset(leftX, posClamp)
                  barGradient.Color = barGradientPattern
                end
    
    
                do -- Chams
                  local highlightCham = player.highlight
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


    do --// Targeting
      local fov = visuals:createFOV()
      local crosshair = visuals:createCrosshair()


      local circle, circleColor, actualCircle, ol1, ol2, fill = fov["4"], fov["5"], fov["2"], fov["7"], fov["8"], fov["Fill"]
      circle.Enabled = false
      local elapsedTime = 0


      Variables.RunService.PreRender:Connect(function(deltatime)
        local currentTick = tick()
        local elapsed = currentTick - lastTick
      
      
        if elapsed < currentTick then
          task.wait(targetSeconds - elapsed)
        end


        local isSilentEnabled = visuals:returnflag("SilentAimToggle")
        local isFOVEnabled = (isSilentEnabled and visuals:returnflag("FOVToggle"))
        local isSnapLineEnabled = (isSilentEnabled and visuals:returnflag("Snapline"))


        local snapline, snaplineOutline = cheat.visualcache.snapline, cheat.visualcache.snaplineOutline
        local crossHairColor, crossHairGap, CrossHairLength, CrossHairThickness = visuals:returnflagcolor("Crosshair_Color"), visuals:returnflag("CrosshairGap"), visuals:returnflag("CrosshairLength"), visuals:returnflag("CrossHairThickness")


        local mouseP = Variables.UserInputService:GetMouseLocation()
        local circleMousePos, mousePos = Variables.UDim2fromOffset(mouseP.X, mouseP.Y), Vector2.new(mouseP.X, mouseP.Y)


        local fovThickness = visuals:returnflag("fovThickness")
        local fovOutlineBool = visuals:returnflag("FOVOutline") and isFOVEnabled
        local fovOutlineColor = visuals:returnflagcolor("OutlineColor")


        local fovRadius = visuals:returnflag("FOVRadius")
        local newFovRadius = Math.Floor(fovRadius * 2.25)

        local isMouse = visuals:returnflag("targetStyle") == "Mouse"
            
        
        if isSilentEnabled then
          closest, currentPlayerTarget = targeting:getTarget()


        
          do --// Circle
            circle.Enabled = isFOVEnabled
            circleColor.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, visuals:returnflagcolor("FOVGradientOne")), ColorSequenceKeypoint.new(1, visuals:returnflagcolor("FOVGradientTwo"))}
            circle.Thickness = fovThickness
            ol2.Thickness = fovThickness + 1
         
         
            ol1.Enabled = fovOutlineBool
            ol2.Enabled = fovOutlineBool
            ol1.Color = fovOutlineColor


            ol2.Color = fovOutlineColor
            actualCircle.Size = Variables.UDim2new(0, newFovRadius, 0, newFovRadius)


            if isMouse then
              local mouseP = Variables.UserInputService:GetMouseLocation()
              actualCircle.Position = circleMousePos
             else
              actualCircle.Position = Variables.UDimfromScale(.5, .5)
            end
                
         
            if visuals:returnflag("Gradient_Spin") then
              Variables.TweenService:Create(circleColor, TweenInfo.new(1), {Rotation = circleColor.Rotation + visuals:returnflag("Gradient_Spin_Speed") * 20}):Play()
            end
            

          end
      

      
          do --// Crosshair
                local main, holder, left, right, top, bottom = crosshair["1"], crosshair["2"], crosshair["3"], crosshair["5"], crosshair["9"], crosshair["7"]
                main.Enabled = visuals:returnflag("CrosshairEnabled")
                local pulseSpeed = visuals:returnflag("MaxRate")
                local pulseAmount = visuals:returnflag("MaxPulse")


                local rotationSpeed = (visuals:returnflag("CrosshairSpinSped") * 100)
                local offset, crosshairOffset = math.sin(elapsedTime * math.pi * pulseSpeed), currentTick * 360 * (rotationSpeed / 1000)
                local scale = offset * pulseAmount
                
  
                elapsedTime += deltatime
                if main.Enabled then
                  left.BackgroundColor3 = crossHairColor
                  right.BackgroundColor3 = crossHairColor
                  top.BackgroundColor3 = crossHairColor
                  bottom.BackgroundColor3 = crossHairColor


                  local currentTick = os.clock()
                  local elapsed = currentTick - lastTick
                  local fadingScale = offset * 2
                  --local flashingScale = offset * visuals:returnflag("visualAnimSpeed")
                  
   
                	local leftPos = Variables.UDim2new(-1, (crossHairGap * 10) - scale / 2, 0, -1)
                  local rightPos = Variables.UDim2new(-1, -(crossHairGap * 10) + scale / 2, 0, -1)
                  local topPos = Variables.UDim2new(0, 0, 1, -(crossHairGap * 10) + scale / 2)
                  local bottomPos = Variables.UDim2new(0, 0, -1, (crossHairGap * 10) - scale / 2)
  
                  
                  if visuals:returnflag("CrosshairAnim") == "Static" then
                    left.Size = Variables.UDim2new(1, (CrossHairLength + crossHairGap), 0, CrossHairThickness)
                    right.Size = Variables.UDim2new(-1, -(CrossHairLength + crossHairGap), 0, CrossHairThickness)
                      
                 
                    bottom.Size = Variables.UDim2new(1, -CrossHairThickness, 0, CrossHairLength + crossHairGap)
                    top.Size = Variables.UDim2new(1, -CrossHairThickness, 0, -CrossHairLength + -crossHairGap)
                 
                 
                    left.Position = Variables.UDim2new(-1, (crossHairGap * 10), 0, -1)
                    right.Position = Variables.UDim2new(-1, -(crossHairGap * 10), 0, -1)
                      
                 
                    bottom.Position = Variables.UDim2new(0, 0, -1, (crossHairGap * 10))
                    top.Position = Variables.UDim2new(0, 0, 1, -(crossHairGap * 10))
                   elseif visuals:returnflag("CrosshairAnim") == "Breathing" then


                    if elapsed >= 1 / elapsed * visuals:returnflag("animSpeed") then
                      left.Size = Variables.UDim2new(1, (CrossHairLength + crossHairGap) - scale, 0, CrossHairThickness)
                      --Variables.UDim2new(1, Math.Clamp((CrossHairLength + crossHairGap) - scale, -20, -1), 0, CrossHairThickness)
                      right.Size = Variables.UDim2new(-1, -(CrossHairLength + crossHairGap) + scale, 0, CrossHairThickness)
                        
                   
                      bottom.Size = Variables.UDim2new(1, -CrossHairThickness, 0, CrossHairLength + crossHairGap - scale)
                      top.Size = Variables.UDim2new(1, -CrossHairThickness, 0, -CrossHairLength + -crossHairGap + scale)
                      
      
                      left.Position = leftPos
                      right.Position = rightPos
    
                      
                      top.Position = topPos
                      bottom.Position = bottomPos
                    end


                  end


                  if visuals:returnflag("visualCrosshairAnim") == "Fading" then
                    left.BackgroundTransparency = fadingScale
                    left["UIStroke"].Transparency = fadingScale

                    right.BackgroundTransparency = fadingScale
                    right["UIStroke"].Transparency = fadingScale
                 
                    bottom.BackgroundTransparency = fadingScale
                    bottom["UIStroke"].Transparency = fadingScale

                    top.BackgroundTransparency = fadingScale
                    top["UIStroke"].Transparency = fadingScale
                   elseif visuals:returnflag("visualCrosshairAnim") == "Flashing" then
                    local flashingScale = offset * visuals:returnflag("visualAnimSpeed")
                    left.BackgroundTransparency = flashingScale
                    right.BackgroundTransparency = flashingScale
                  
                    bottom.BackgroundTransparency = flashingScale
                    top.BackgroundTransparency = flashingScale
                  end


                  if visuals:returnflag("CrosshairSpin") then
                    holder.Rotation = (holder.Rotation + (rotationSpeed * deltatime)) % 360
                   else
                    holder.Rotation = 0
                  end
  
  
                end
  
        
                if visuals:returnflag("OnBarrel") then
                  if Client.Character and FindFirstChild(Client.Character, "Equipped") then
                    local weapon = FindFirstChildOfClass(Client.Character["Equipped"], "Model")
                    if weapon ~= nil and FindFirstChild(weapon, "Muzzle") then
                      local muzzle = weapon["Muzzle"]
                      local raycastParams = RaycastParams.new()
                      raycastParams.FilterDescendantsInstances = {FindFirstChild(weapon, "Barrel"), FindFirstChild(weapon, "BarrelMount")}
                      raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                      raycastParams.IgnoreWater = true
      
                      local ray = Variables.Workspace:Raycast(muzzle.Position, (muzzle.CFrame * CFrame.new(0, 0, -100000)).Position - muzzle.Position, raycastParams)
                      if ray ~= nil then
                        local pos = WorldToViewportPoint(workspace.CurrentCamera, ray.Position)
                        local pos2 = WorldToViewportPoint(workspace.CurrentCamera, muzzle.Position - Variables.Vector3new(0, .15, 0))
                        

                        crosshair["2"].Position = Variables.UDim2new(0, pos.X, 0, pos.Y)
                        crosshair["infoHolder"].Position = Variables.UDim2new(0, pos2.X, 0, pos2.Y)
                      end
      
                     else
      
                      crosshair["2"].Position = Variables.UDim2new(.5, 0, .5, 0)
                      crosshair["infoHolder"].Position = Variables.UDim2new(.5, 0, .525, 0)
            
                    end
      
                  end
                end


                if visuals:returnflag("renderFOVOnBarrel") then
                  if Client.Character ~= nil and FindFirstChild(Client.Character, "Equipped") then
                    local weapon = FindFirstChildOfClass(Client.Character["Equipped"], "Model")
                    if weapon ~= nil and FindFirstChild(weapon, "Muzzle") ~= nil then
                      local muzzle = weapon["Muzzle"]
                      local raycastParams = RaycastParams.new()
                      raycastParams.FilterDescendantsInstances = {FindFirstChild(weapon, "Barrel")}
                      raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                      raycastParams.IgnoreWater = true
      
                      local ray = Variables.Workspace:Raycast(muzzle.Position, (muzzle.CFrame * CFrame.new(0, 0, -100000)).Position - muzzle.Position, raycastParams)
                      if ray ~= nil then
                        local pos = WorldToViewportPoint(workspace.CurrentCamera, ray.Position)
                        fov["2"].Position = Variables.UDim2new(0, pos.X, 0, pos.Y)


                        if closest then
                          local pos2 = WorldToViewportPoint(workspace.CurrentCamera, closest.Position)
                          snapline.From = Variables.Vector2new(pos.X, pos.Y)
                          snapline.To = Variables.Vector2new(pos2.X, pos2.Y)
          
                          snaplineOutline.From = Variables.Vector2new(pos.X, pos.Y)
                          snaplineOutline.To = Variables.Vector2new(pos2.X, pos2.Y)

                        end

                      end
      
                     else
      
                      fov["2"].Position = Variables.UDim2new(.5, 0, .5, 0)
            
                    end
      
                  end
                end
                    
        
          end
          


          do --// Fill
            fill.Enabled = visuals:returnflag("fovFillEnabled")
            fill.Color = visuals:returnflagcolor("fovFillColor")
            fill.Transparency = visuals:returnflagtransparency("fovFillColor")
          end



          local isManipulated = false
          local playerText, distanceText, manipText = crosshair["PlayerText"], crosshair["DistanceText"], crosshair["ManipulatedText"]
       


          local playerColor, distanceColor, manipColor = visuals:returnflagcolor("Target_Name_Color"), visuals:returnflagcolor("Target_Distance_Color"), visuals:returnflagcolor("Target_Manipulated_Color")
          local wallbangColor = visuals:returnflagcolor("Target_Wallbang_Color")
          local canWallbangText = visuals:returnflag("showWallbang")
          

          
          if closest then

            do --// Manipulation

             if Variables.Players.LocalPlayer.Character and visuals:returnflag("ManipulationToggle") and visuals:returnflag("ManipBind").active then
               local clientChar = Variables.Players.LocalPlayer.Character
               local bestOrigin, bestReach = rageBot:FindTargetOrigin(workspace.CurrentCamera.CFrame.Position, closest, visuals:returnflag("HorzManip"), visuals:returnflag("VertManip"), visuals:returnflag("MaxCornerRadius"), workspace.CurrentCamera.CFrame.Position + workspace.CurrentCamera.CFrame.LookVector * 5, {clientChar, workspace.CurrentCamera})
               if bestOrigin and bestReach > 2 then
                 isManipulated = true
                 manipText.Visible = visuals:returnflag("showManipulated") and isManipulated
                 weapon.manipOrigin = bestOrigin
 
                 local isManip, isWallbangable = visuals:color3ToHex(manipColor), visuals:color3ToHex(wallbangColor)
                 manipText.Text = "Manipulated"
                 manipText.TextColor3 = manipColor
 
                else
                 isManipulated = false
                 manipText.Visible = false
                 weapon.manipOrigin = nil
               end
 
             
 
              else
 
               manipText.Visible = false
               weapon.manipOrigin = nil
 
             end

            end


            do --// Snapline

              if not visuals:returnflag("renderFOVOnBarrel") then
                local pos = WorldToViewportPoint(workspace.CurrentCamera, closest.Position)
                snapline.Visible = isSnapLineEnabled
                snaplineOutline.Visible = isSnapLineEnabled and visuals:returnflag("SnaplineOutline") and (closest ~= nil)
  
  
                snapline.Color = visuals:returnflagcolor("SnaplineColor")
                snaplineOutline.Color = visuals:returnflagcolor("SnaplineOutlineColor")
        
        
                snapline.Thickness = visuals:returnflag("SnaplineThickness")
                snaplineOutline.Thickness = snapline.Thickness + 2
        
                snapline.ZIndex = 1
                snaplineOutline.ZIndex = 0
  
                if isMouse then
                  snapline.From = mousePos
                  snapline.To = Variables.Vector2new(pos.X, pos.Y)
              
                  snaplineOutline.From = mousePos
                  snaplineOutline.To = Variables.Vector2new(pos.X, pos.Y)
                 else
                  snapline.From = Variables["CameraOrigin"]
                  snapline.To = Variables.Vector2new(pos.X, pos.Y)
              
                  snaplineOutline.From = Variables["CameraOrigin"]
                  snaplineOutline.To = Variables.Vector2new(pos.X, pos.Y)
                end
  
  
               else
                snapline.Visible = false
                snaplineOutline.Visible = false
              end
    
            end


            do -- Other Texts
              local dist = Math.Floor((closest.Position - workspace.CurrentCamera.CFrame.Position).Magnitude) .. " Studs"

              playerText.Visible = visuals:returnflag("showTargetName")
              playerText.Text = currentPlayerTarget.Name
              playerText.TextColor3 = playerColor


              distanceText.Visible = visuals:returnflag("showTargetDistance")
              distanceText.Text = dist
              distanceText.TextColor3 = distanceColor
            end

           else

            snapline.Visible = false
            snaplineOutline.Visible = false
            playerText.Visible = false
            manipText.Visible = false
            distanceText.Visible = false

          end
          


         else

          circle.Enabled = false
          crosshair["1"].Enabled = false
          fill.Enabled = false
          ol1.Enabled = false
          ol2.Enabled = false
          snapline.Visible = false
          snaplineOutline.Visible = false

        end
      
    
      end)

    end


    Variables.RunService.PreRender:Connect(function(deltatime)
      local isHitBox, hitboxSize, hitboxTransparency = visuals:returnflag("hitboxExpander"), visuals:returnflag("hitboxExpanderAmount"), visuals:returnflag("hitboxTransparencyAmount")
      
      for _, character in lib do
        if typeof(character) ~= "table" and typeof(character) ~= nil then
          continue
        end

        local head = character.head
        if not head then
          continue
        end

        if isHitBox then
          head.Size = Vector3.one * hitboxSize
          head.CanCollide = true
          head.CanQuery = true
          head.CanTouch = true
          head.Transparency = hitboxTransparency
          head.Massless = true
        else
          head.Size = Vector3.one * 1.15
          head.Transparency = 0
          head.Massless = false
        end

      end

    end)
   
   
    
end



library:config_list_update()
for index, value in themes.preset do 
	pcall(function()
		library:update_theme(index, value)
	end)
end
task.wait()
library.old_config = library:get_config()


doneLoading = true
