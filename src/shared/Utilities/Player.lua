local Player = {
    Character = nil,
    Humanoid = nil
}

shared.LocalPlayer.CharacterAdded:Connect(function(Character)
    Player.Character = Character
    Player.Humanoid = Character:FindFirstChild("Humanoid") or Character:WaitForChild("Humanoid")
end)

function IsolateVectorXZ(Vector:Vector3) : Vector3
    return Vector3.new(
        Vector.X,
        0,
        Vector.Z
    )
end

function Player.IsMoving() : boolean
    return IsolateVectorXZ(Player.Humanoid.MoveDirection).Magnitude > 0
        and IsolateVectorXZ(Player.Character.PrimaryPart.AssemblyLinearVelocity).Magnitude > 0.1
end

function Player.IsGrounded() : boolean
    return Player.Humanoid.FloorMaterial ~= Enum.Material.Air
end

function Player.IsFalling() : boolean
    return Player.IsGrounded()
        and Player.Character.PrimaryPart.AssemblyLinearVelocity.Y < 0
end

function Player.IsAlive() : boolean
    return Player.Humanoid.Health > 0
end

return Player