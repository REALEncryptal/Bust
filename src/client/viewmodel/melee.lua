
local Melee = {}
Melee.__index = Melee
setmetatable(Melee, require(script.Parent))

function Melee.new()
    local self = setmetatable({}, Melee)
    return self
end

function Melee.Use()

end

return Melee