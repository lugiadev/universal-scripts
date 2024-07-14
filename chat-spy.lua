-- Original script: https://github.com/dehoisted/Chat-Spy
-- Simple Chat Spy (Fixed to work on Solara)
-- Type "spy" to enable or disable the chat spy.

-- Config
Config = {
    enabled = true,
    spyOnMyself = true,
    public = false,
    publicItalics = true
}

-- Customizing Log Output
PrivateProperties = {
    Color = Color3.fromRGB(0, 255, 255),
    Font = Enum.Font.SourceSansBold,
    TextSize = 18
}

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local SayMessageRequest = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
local OnMessageDoneFiltering = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering")
local ChatSpyInstance = (_G.chatSpyInstance or 0) + 1
_G.chatSpyInstance = ChatSpyInstance

local function onChatted(player, message)
    if _G.chatSpyInstance == ChatSpyInstance then
        if player == LocalPlayer and message:lower():sub(1, 4) == "/spy" then
            Config.enabled = not Config.enabled
            wait(0.3)
            PrivateProperties.Text = "{SPY " .. (Config.enabled and "EN" or "DIS") .. "ABLED}"
            StarterGui:SetCore("ChatMakeSystemMessage", PrivateProperties)
        elseif Config.enabled and (Config.spyOnMyself or player ~= LocalPlayer) then
            message = message:gsub("[\n\r]", ''):gsub("\t", ' '):gsub("[ ]+", ' ')
            local hidden = true
            local conn
            conn = OnMessageDoneFiltering.OnClientEvent:Connect(function(packet, channel)
                if packet.SpeakerUserId == player.UserId and packet.Message == message:sub(#message - #packet.Message + 1) and (channel == "All" or (channel == "Team" and not Config.public and Players[packet.FromSpeaker].Team == LocalPlayer.Team)) then
                    hidden = false
                end
            end)
            wait(1)
            conn:Disconnect()
            if hidden and Config.enabled then
                if Config.public then
                    SayMessageRequest:FireServer((Config.publicItalics and "/me " or '') .. "{SPY} [" .. player.Name .. "]: " .. message, "All")
                else
                    PrivateProperties.Text = "{SPY} [" .. player.Name .. "]: " .. message
                    StarterGui:SetCore("ChatMakeSystemMessage", PrivateProperties)
                end
            end
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(message) onChatted(player, message) end)
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message) onChatted(player, message) end)
end)

PrivateProperties.Text = "{SPY " .. (Config.enabled and "EN" or "DIS") .. "ABLED}"
StarterGui:SetCore("ChatMakeSystemMessage", PrivateProperties)
local chatFrame = LocalPlayer.PlayerGui.Chat.Frame
chatFrame.ChatChannelParentFrame.Visible = true
chatFrame.ChatBarParentFrame.Position = chatFrame.ChatChannelParentFrame.Position + UDim2.new(UDim.new(), chatFrame.ChatChannelParentFrame.Size.Y)
