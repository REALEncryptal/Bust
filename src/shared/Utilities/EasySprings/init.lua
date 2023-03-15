local EasySprings = {}
EasySprings.__index = EasySprings

EasySprings.Spring = require(script.Spring3)

function EasySprings.new()
    local self = setmetatable({}, EasySprings)

    self.Springs = {}

    return self
end

function EasySprings:Add(Name:string, Mass:number, Force:number, Damping:number, Speed:number)
    assert(Name, "Must give a name for spring.")
    assert(not self.Springs[Name], "Spring already exists.")

    Mass = Mass or 5
    Force = Force or 50
    Speed = Speed or 4
    Damping = Damping or 4

    self.Springs[Name] = EasySprings.Spring.new(Mass, Force, Damping, Speed)
end

function EasySprings:Edit(Name:string, Mass:number, Force:number, Damping:number, Speed:number)
    assert(Name, "Must give a name to edit a spring.")
    assert(self.Springs[Name], "Spring doesn't exist.")

    self.Springs[Name].Mass = Mass or self.Springs[Name].Mass
    self.Springs[Name].Force = Force or self.Springs[Name].Force
    self.Springs[Name].Speed = Speed or self.Springs[Name].Speed
    self.Springs[Name].Damping = Damping or self.Springs[Name].Damping
end

function EasySprings:Shove(Name:string, Force:Vector3)
    assert(Name, "Must give a name.")
    assert(self.Springs[Name], "Spring doesn't exist.")

    self.Springs[Name]:Shove(Force)
end

function EasySprings:GetValue(Name:string)
    assert(Name, "Must give a name.")
    return self.Springs[Name].Position
end

function EasySprings:GetObject(Name:string)
    assert(Name, "Must give a name.")
    return self.Springs[Name]
end

function EasySprings:Update(Name:string, DeltaTime:number)
    assert(Name, "Must give a name.")
    assert(DeltaTime, "Must give a DeltaTime.")

    self.Springs[Name]:Update(DeltaTime)
end

function EasySprings:UpdateAll(DeltaTime:number)
    assert(DeltaTime, "Must give a DeltaTime.")

    for _, Spring in ipairs(self.Springs) do
        Spring:Update(DeltaTime)
    end
end

return EasySprings