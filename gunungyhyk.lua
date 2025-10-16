--// 🏔️ Auto-Walk Gunung YHAYUK v1 (Manual + Auto)
--// By GPT-5 x wayahepro-afk

-- Hapus GUI lama kalau ada
if game.CoreGui:FindFirstChild("YHAYUK_GUI") then
    game.CoreGui.YHAYUK_GUI:Destroy()
end

-- Buat GUI utama
local gui = Instance.new("ScreenGui")
gui.Name = "YHAYUK_GUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 180)
frame.Position = UDim2.new(0.5, -130, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Auto-Walk YHAYUK v1"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -55, 0, 3)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -28, 0, 3)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = frame

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, 0, 0, 25)
statusLbl.Position = UDim2.new(0, 0, 0.8, 0)
statusLbl.Text = "Status: Idle"
statusLbl.TextColor3 = Color3.new(1, 1, 1)
statusLbl.Font = Enum.Font.SourceSans
statusLbl.BackgroundTransparency = 1
statusLbl.Parent = frame

--// 🗺️ Checkpoints (isi sendiri koordinat sesuai gunung YHAYUK)
local checkpoints = {
    Vector3.new(0, 0, 0), -- CP1
    Vector3.new(0, 0, 0), -- CP2
    Vector3.new(0, 0, 0), -- CP3
    Vector3.new(0, 0, 0), -- CP4
    Vector3.new(0, 0, 0), -- dst...
}

--// Services
local PathfindingService = game:GetService("PathfindingService")
local player = game.Players.LocalPlayer
local running = false
local delayValue = 5 -- detik antar CP

--// Fungsi jalan otomatis (pakai pathfinding)
local function walkTo(targetPos)
    local char = player.Character
    if not char or not char:FindFirstChild("Humanoid") or not char:FindFirstChild("HumanoidRootPart") then return end
    local humanoid = char.Humanoid
    local root = char.HumanoidRootPart

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true
    })

    path:ComputeAsync(root.Position, targetPos)
    if path.Status == Enum.PathStatus.Success then
        for _, waypoint in ipairs(path:GetWaypoints()) do
            if not running then break end
            humanoid:MoveTo(waypoint.Position)
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                humanoid.Jump = true
            end
            humanoid.MoveToFinished:Wait()
        end
    else
        warn("⚠️ Gagal menemukan jalur ke CP berikutnya")
    end
end

--// MODE FRAME
local modeFrame = Instance.new("Frame")
modeFrame.Size = UDim2.new(0.8, 0, 0, 60)
modeFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
modeFrame.BackgroundTransparency = 1
modeFrame.Parent = frame

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0.45, 0, 0, 25)
autoBtn.Position = UDim2.new(0, 0, 0, 0)
autoBtn.Text = "Auto Walk"
autoBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
autoBtn.TextColor3 = Color3.new(1, 1, 1)
autoBtn.Font = Enum.Font.SourceSansBold
autoBtn.Parent = modeFrame

local manualBtn = Instance.new("TextButton")
manualBtn.Size = UDim2.new(0.45, 0, 0, 25)
manualBtn.Position = UDim2.new(0.55, 0, 0, 0)
manualBtn.Text = "Manual Walk"
manualBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 40)
manualBtn.TextColor3 = Color3.new(1, 1, 1)
manualBtn.Font = Enum.Font.SourceSansBold
manualBtn.Parent = modeFrame

--// AUTO WALK MODE
local function autoWalk()
    running = true
    statusLbl.Text = "Status: Auto Walk Aktif"
    for i, cp in ipairs(checkpoints) do
        if not running then break end
        statusLbl.Text = "Menuju CP " .. i
        walkTo(cp)
        if i < #checkpoints then
            task.wait(delayValue)
        end
    end
    statusLbl.Text = "Status: Selesai ✅"
    running = false
end

autoBtn.MouseButton1Click:Connect(function()
    if not running then
        task.spawn(autoWalk)
    else
        running = false
        statusLbl.Text = "Status: Auto Walk Dihentikan"
    end
end)

--// MANUAL WALK MODE
local cpFrame = Instance.new("ScrollingFrame")
cpFrame.Size = UDim2.new(0.8, 0, 0, 70)
cpFrame.Position = UDim2.new(0.1, 0, 0.55, 0)
cpFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
cpFrame.BorderSizePixel = 1
cpFrame.CanvasSize = UDim2.new(0, 0, 0, #checkpoints * 25)
cpFrame.ScrollBarThickness = 6
cpFrame.Parent = frame

for i, cp in ipairs(checkpoints) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 25)
    btn.Position = UDim2.new(0, 5, 0, (i - 1) * 25)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = "CP " .. i
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextScaled = true
    btn.Parent = cpFrame

    btn.MouseButton1Click:Connect(function()
        statusLbl.Text = "Berjalan ke CP " .. i
        running = true
        walkTo(cp)
        running = false
        statusLbl.Text = "Tiba di CP " .. i
    end)
end

--// MINIMIZE & CLOSE
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, v in ipairs(frame:GetChildren()) do
        if v ~= title and v ~= minimizeBtn and v ~= closeBtn then
            v.Visible = not minimized
        end
    end
    frame.Size = minimized and UDim2.new(0, 260, 0, 35) or UDim2.new(0, 260, 0, 180)
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("✅ Auto-Walk Gunung YHAYUK v1 (Manual + Auto) berhasil dimuat.")
