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


local getGCFunction = function(funcName, savedFunctions, library)
  if not savedFunctions then
    return
  end

  local Func = filtergc("function", {Name = funcName, IgnoreExecutor = false}, true)
  if Func ~= nil then
     savedFunctions[Func] = Func
    return Func
   else

    if library then
       library:notification({time = 5, text = funcName .. " can not be traced, contact developer's for support.", flashing = false, })
     else
       warn(funcName .. " can not be traced, contact developer's for support.")
      return function() return end
    end

  end

end


local function deepCopy(orig, copies) -->I just grabbed this shit off of the internet, credits to whoever made it(probably made by someone using AI obviously xd)
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
  return Variables.Camera:WorldToViewportPoint(p)
end


return getService, getFunction, getGCFunction, deepCopy, Variables, Math, FindFirstChild, FindFirstChildOfClass, WorldToViewportPoint


