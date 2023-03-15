--[[
Created by Encryptal
2023-02-23

  Purpose:
   Simple and practial library
   Animation handler
   Stores animations
   Usefull methods
--]]

local FastAnimator = {}
FastAnimator.__index = FastAnimator

function FastAnimator.new(Humanoid)
    local self = setmetatable({}, FastAnimator)

    self.AnimationTracks = {}
    self.AnimationObjects = {}
    self.MarkerReachedSignals = {}
    self.Humanoid = Humanoid
    self.Animator = Humanoid:FindFirstChildOfClass("Animator")

    self.Speed = 1

    return self
end

-- Loaders
function FastAnimator:LoadFolder(Folder : Folder)
    for _, Animation in ipairs(Folder:GetChildren()) do
        self.AnimationTracks[Animation.Name] = self.Animator:LoadAnimation(Animation)
        self.AnimationObjects[Animation.Name] = Animation
    end
end

function FastAnimator:LoadList(List : table)
    for AnimationName, AnimationId in ipairs(List) do
        local Animation = Instance.new("Animation")
        AnimationId.AnimationId = AnimationId
        Animation.Name = AnimationName

        self.AnimationTracks[AnimationName] = self.Animator:LoadAnimation(Animation)
        self.AnimationObjects[AnimationName] = Animation
    end
end
-- Marker methods
function FastAnimator:AddMarkerCallback(AnimationName : string, MarkerName : string, CallbackName : string, Callback)
    if not self.MarkerReachedSignals[AnimationName] then 
        self.MarkerReachedSignals[AnimationName] = {}
    end

    if not self.MarkerReachedSignals[AnimationName][MarkerName] then 
        self.MarkerReachedSignals[AnimationName][MarkerName] = {}
    end

    self.MarkerReachedSignals[AnimationName][MarkerName][CallbackName] = Callback

    if not self.MarkerReachedSignals[AnimationName][MarkerName]["_CONNECTION"] then return end

    self.AnimationTracks[AnimationName]:GetMarkerReachedSignal(MarkerName):Connect(function(paramString)
        for _, CallbackFunction in pairs(self.MarkerReachedSignals[AnimationName][MarkerName]) do
            if typeof(CallbackFunction) ~= "function" then continue end
                CallbackFunction(paramString)
        end
    end)
end

function FastAnimator:RemoveMarkerCallback(AnimationName : string, MarkerName : string, CallbackName)
    local callbackIndex =  table.find(self.MarkerReachedSignals[AnimationName][MarkerName], self.MarkerReachedSignals[AnimationName][MarkerName][CallbackName])
    table.remove(self.MarkerReachedSignals[AnimationName][MarkerName], callbackIndex)
end

-- Animation playback
function FastAnimator:Play(AnimationName : string)
    self.AnimationTracks[AnimationName]:AdjustSpeed(self.Speed)
    self.AnimationTracks[AnimationName]:Play()
end

function FastAnimator:PlaySpeed(AnimationName : string, Speed : number)
    self.AnimationTracks[AnimationName]:AdjustSpeed(Speed)
    self.AnimationTracks[AnimationName]:Play()
    self.AnimationTracks[AnimationName]:AdjustSpeed(self.Speed)
end

function FastAnimator:Stop(AnimationName : string)
    self.AnimationTracks[AnimationName]:Stop()
end

function FastAnimator:GetAnimationTrack(AnimationName : string)
    return self.AnimationTracks[AnimationName]
end

function FastAnimator:SetSpeedScale(Speed)
    self.Speed = Speed
end