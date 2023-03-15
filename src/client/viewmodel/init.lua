--[[
take care of caching the viewmodel
take care of animations and caching them   DONE
take care of setting the position of the viewmodel
take care of dealing with offsets DONE
integrated springs
]]

local Viewmodel = {}
Viewmodel.__index = Viewmodel

local PlayerUtil = require(shared.Utilities.Player)

function Viewmodel.new(WeaponName : string)
    local self = setmetatable({}, Viewmodel)

    self.Model = shared.Assets:FindFirstChild(WeaponName):Clone()
    self.Model.Parent = workspace.CurrentCamera
    self.Model:MoveTo(Vector3.new(0, 10000, 0))

    self.Data = require(shared.Data:FindFirstChild(WeaponName))

    self.Animator = require(shared.Utilities.FastAnimator).new(self.Model.Humanoid)
    self.Offsets = require(shared.Utilities.EasyOffsets).new()
    self.Springs = require(shared.Utilities.EasySprings).new()

    self.States = {
        Equipped = false,
        Ads = false,
    }

    --/ Init
    self.Animator:LoadFolder(self.Data.Animations)
    
    self.Offsets:Add("Sway", CFrame.new(), false)
    self.Offsets:Add("Walk", CFrame.new(), false)
    self.Offsets:Add("Bob", CFrame.new(), false)
    self.Offsets:Add("Recoil", CFrame.new(), false)
    self.CameraRecoilOffset = CFrame.new()

    self.Springs:Add("Sway")
    self.Springs:Add("Walk")
    self.Springs:Add("Bob")
    self.Springs:Add("Recoil")
    self.Springs:Add("CameraRecoil")

    return self
end

function Viewmodel:Update(DeltaTime : number)

    --/ Shove springs
    local mDelta = shared.UserInputService:GetMouseDelta()
    self.Springs:Shove("Sway", self.Data.SpringFunctions.Sway(mDelta) or CFrame.new(
        mDelta.X,
        mDelta.Y,
        0
    ))

    if PlayerUtil.IsMoving() and PlayerUtil.IsGrounded() then
        self.Springs:Shove("Walk", self.Data.SpringFunctions.Walk() or CFrame.new(
            math.sin(tick()/2),
            math.cos(tick()),
            0
        ))
    end

    if not self.States.Ads and not self.Data.Type == "Melee" then
        self.Springs:Shove("Bob", self.Data.SpringFunctions.Bob() or CFrame.new(
            math.sin(tick()/2)*.3,
            math.cos(tick())*.6,
            0
        ))
    end

    --/ Set positions
    self.Springs:UpdateAll(DeltaTime)

    self.Offsets:Set("Sway", self.Springs:GetValue("Sway"))
    self.Offsets:Set("Walk", self.Springs:GetValue("Walk"))
    self.Offsets:Set("Bob", self.Springs:GetValue("Bob"))
    self.Offsets:Set("Recoil", self.Springs:GetValue("Recoil"))

    self.Model.PrimaryPart.CFrame = workspace.CurrentCamera.CFrame * self.Offsets:Compile() * self.CameraRecoilOffset
end

return Viewmodel