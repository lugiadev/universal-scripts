local function onDescendantAdded(descendant)
	  if descendant:IsA("Seat") or descendant:IsA("VehicleSeat") then
        descendant.Disabled = true
    end
end

for _, v in ipairs(workspace:GetDescendants()) do
    onDescendantAdded(v)
end

workspace.DescendantAdded:Connect(onDescendantAdded)
