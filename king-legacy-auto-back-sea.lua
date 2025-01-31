repeat
	task.wait()
until game:IsLoaded() and game.Players.LocalPlayer

local plr = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local Remotes = game:GetService("ReplicatedStorage").Chest:WaitForChild("Remotes")

function CurrentDialog()
	for _, gui in pairs(plr.PlayerGui:GetChildren()) do
		if not gui:IsA("ScreenGui") or gui.Name == "PeoDialogue" then
			continue
		end
		if gui:FindFirstChild("Dialogue") and gui.Dialogue.Visible then
			print(gui.Name)
			return gui
		end
	end
	return nil
end

function AcceptDialog(name)
	if not name then
		return
	end

	local Dialog = CurrentDialog()
	if not Dialog or Dialog.Name ~= name then
		return
	end

	print(Dialog.Name)

	local Accept = Dialog.Dialogue:FindFirstChild("Accept")
	if Accept then
		print(Accept.Name)
		for _, connection in pairs(getconnections(Accept.MouseButton1Click)) do
			connection:Fire()
		end
	end
end

-- Anti-AFK
plr.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Start the script
local function main()
	local NPCs = workspace:WaitForChild("AllNPC", 10) -- Added timeout
	print(NPCs)
	if not NPCs then
		warn("Failed to find AllNPC folder")
		return
	end

	if not plr.PlayerStats or not plr.PlayerStats:FindFirstChild("SecondSeaProgression") then
		warn("PlayerStats or SecondSeaProgression not found")
		return
	end

	repeat
		task.wait(1)
	until plr.PlayerStats.SecondSeaProgression.Value == "Yes"

	while true do
		if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
			task.wait(1)
			continue
		end

		local elitePirate = NPCs:FindFirstChild("Elite Pirate")
		if not elitePirate then
			task.wait(1)
			continue
		end

		plr.Character.HumanoidRootPart.CFrame = elitePirate.CFrame * CFrame.new(0, 0, -4)
		local _ = Remotes.Functions.CheckQuest:InvokeServer(elitePirate)
		task.wait(1)
		AcceptDialog("Elite Pirate")

		task.wait(1) -- Prevent infinite loop from consuming too much CPU
	end
end
task.spawn(main)
