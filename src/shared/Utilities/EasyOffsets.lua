local EasyOffsets = {}
EasyOffsets.__index = EasyOffsets

EasyOffsets.Types = {
    INSTANCE = 0,
    VALUE = 1
}

function EasyOffsets.new()
    local self = setmetatable({}, EasyOffsets)

    self.Offsets = {}
    self.SingleOffsets = {}

    return self
end

function EasyOffsets:Add(Name : string, Offset : CFrame, IsTemporary : boolean,Type)
    assert(self.Offsets[Name], "Offset does not exist.")

    Offset = Offset or CFrame.new()
    IsTemporary = IsTemporary or true
    Type = Type or EasyOffsets.Types.VALUE

    -- Remove existing
    if self.Offsets[Name] and self.Offsets[Name].Value:IsA("CFrameValue") then
        warn("[EasyOffsets] Offset exists, overwriting.")
        self.Offsets[Name].Value:Destroy()
    end

    -- Add new
    if Type == EasyOffsets.Types.INSTANCE then
        self.Offsets[Name].Value = Instance.new("CFrameValue")
        self.Offsets[Name].Value.Value = Offset
        self.Offsets[Name].IsTemporary = IsTemporary
    elseif Type == EasyOffsets.Types.VALUE then
        self.Offsets[Name].Value = Offset
        self.Offsets[Name].IsTemporary = IsTemporary
    else
        warn("[EasyOffsets] Invalid Type, skipping.")
    end
end

function EasyOffsets:Set(Name : string, Offset : CFrame, IsTemporary : boolean)
    assert(self.Offsets[Name], "Offset does not exist.")
    
    Offset = Offset or CFrame.new()
    IsTemporary = IsTemporary or true

    if self.Offsets[Name].Value:IsA("CFrameValue") then
        self.Offsets[Name].Value.Value = Offset
    else
        self.Offsets[Name].Value = Offset
    end
    
    self.Offsets[Name].IsTemporary = IsTemporary
end

function EasyOffsets:Remove(Name : string)
    assert(self.Offsets[Name], "Offset does not exist.")

    if self.Offsets[Name].Value:IsA("CFrameValue") then
        self.Offsets[Name].Value:Destroy()
    end

    self.Offsets[Name] = nil
end

function EasyOffsets:Compile() : CFrame
    local CompiledCFrame = CFrame.new()

    for Name, Offset in ipairs(self.Offsets) do
        if Offset.Value:IsA("CFrameValue") then
            CompiledCFrame *= Offset.Value.Value
        else
            CompiledCFrame *= Offset.Value
        end

        if Offset.IsTemporary then self:Remove(Name) end
    end

    return CompiledCFrame
end