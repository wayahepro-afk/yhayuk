--// 🏔️ Auto Summit v2 (Manual & Auto)
--// Tambahan: Mode Manual + Auto dengan delay 10 detik

if game.CoreGui:FindFirstChild("SummitGUI") then
    game.CoreGui.SummitGUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "SummitGUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0.5, -125, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Auto Summit v2 (Manual & Auto)"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,25,0,25)
minimizeBtn.Position = UDim2.new(1,-55,0,3)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-28,0,3)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = frame

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, 0, 0, 25)
statusLbl.Position = UDim2.new(0, 0, 0.8, 0)
statusLbl.Text = "Status: Idle"
statusLbl.TextColor3 = Color3.new(1,1,1)
statusLbl.Font = Enum.Font.SourceSans
statusLbl.BackgroundTransparency = 1
statusLbl.Parent = frame

-- 🧭 Checkpoints (isi koordinat aslimu di sini!)
local checkpoints = {
    Vector3.new(-418.4,249.2,787.1),  -- CP1 : Titik awal / Basecamp
    Vector3.new(-327.7,388.2,526.4),  -- CP2 : Jalan awal tanjakan
    Vector3.new(293.9,429.8,495.3),  -- CP3 : Pos batu besar
    Vector3.new(323.8,490.2,364.6),  -- CP4 : Tanjakan curam
    Vector3.new(233.5,314.2,-144.3),  -- CP5 : Pohon besar / area tengah
    Vector3.new(-611.7,904.9,-554.5),  -- CP6 : Tebing kecil
}

-- Fungsi teleport
local function tpTo(pos)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- 🕒 Delay antar CP
local delayValue = 10

-- MODE FRAME
local modeFrame = Instance.new("Frame")
modeFrame.Size = UDim2.new(0.8,0,0,60)
modeFrame.Position = UDim2.new(0.1,0,0.3,0)
modeFrame.BackgroundTransparency = 1
modeFrame.Parent = frame

-- tombol auto
local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0.45,0,0,25)
autoBtn.Position = UDim2.new(0,0,0,0)
autoBtn.Text = "Auto Mode"
autoBtn.BackgroundColor3 = Color3.fromRGB(40,120,40)
autoBtn.TextColor3 = Color3.new(1,1,1)
autoBtn.Font = Enum.Font.SourceSansBold
autoBtn.Parent = modeFrame

-- tombol manual
local manualBtn = Instance.new("TextButton")
manualBtn.Size = UDim2.new(0.45,0,0,25)
manualBtn.Position = UDim2.new(0.55,0,0,0)
manualBtn.Text = "Manual Mode"
manualBtn.BackgroundColor3 = Color3.fromRGB(120,120,40)
manualBtn.TextColor3 = Color3.new(1,1,1)
manualBtn.Font = Enum.Font.SourceSansBold
manualBtn.Parent = modeFrame

-- ===================================
-- AUTO MODE
-- ===================================
local running = false
local function autoSummit()
    running = true
    statusLbl.Text = "Status: Auto Mode aktif"
    for i, cp in ipairs(checkpoints) do
        if not running then break end
        tpTo(cp)
        statusLbl.Text = "Teleport ke CP "..i
        task.wait(delayValue)
    end
    statusLbl.Text = "Status: Selesai ✅"
    running = false
end

autoBtn.MouseButton1Click:Connect(function()
    if not running then
        task.spawn(autoSummit)
    else
        running = false
        statusLbl.Text = "Status: Auto Mode dihentikan"
    end
end)

-- ===================================
-- MANUAL MODE
-- ===================================
local cpFrame = Instance.new("ScrollingFrame")
cpFrame.Size = UDim2.new(0.8,0,0,70)
cpFrame.Position = UDim2.new(0.1,0,0.55,0)
cpFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
cpFrame.BorderSizePixel = 1
cpFrame.CanvasSize = UDim2.new(0,0,0,#checkpoints*25)
cpFrame.ScrollBarThickness = 6
cpFrame.Parent = frame

for i, cp in ipairs(checkpoints) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-10,0,25)
    btn.Position = UDim2.new(0,5,0,(i-1)*25)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.Text = "CP "..i
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextScaled = true
    btn.Parent = cpFrame

    btn.MouseButton1Click:Connect(function()
        statusLbl.Text = "Teleport ke CP "..i
        tpTo(cp)
        task.wait(0.5)
        statusLbl.Text = "Selesai ke CP "..i
    end)
end

-- ===================================
-- MINIMIZE & CLOSE
-- ===================================
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in ipairs(frame:GetChildren()) do
        if v ~= title and v ~= minimizeBtn and v ~= closeBtn then
            v.Visible = not minimized
        end
    end
    frame.Size = minimized and UDim2.new(0,250,0,35) or UDim2.new(0,250,0,180)
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("✅ Auto Summit v2 (Manual & Auto) berhasil dimuat.")