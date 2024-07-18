local decalsyeeted = true -- Leaving this on makes games look shitty but the fps goes up by at least 20.
local g = game
local w = g.Workspace
local l = g.Lighting
local t = w.Terrain

t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 0
l.GlobalShadows = 0
l.FogEnd = 9e9
l.Brightness = 0

settings().Rendering.QualityLevel = "Level01"

local function optimizePart(v)
	if v:IsA("BasePart") or v:IsA("Part") and not v:IsA("MeshPart") then
		v.Material = "Plastic"
		v.Reflectance = 0
	elseif (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
		v.Transparency = 1
	elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
		v.Lifetime = NumberRange.new(0)
	elseif v:IsA("Explosion") then
		v.BlastPressure = 1
		v.BlastRadius = 1
	elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
		v.Enabled = false
	elseif v:IsA("MeshPart") and decalsyeeted then
		v.Material = "Plastic"
		v.Reflectance = 0
		v.TextureID = 10385902758728957
		v.Color = Color3.fromRGB(0, 0, 0)
	elseif v:IsA("SpecialMesh") and decalsyeeted then
		v.TextureId = 0
	elseif v:IsA("ShirtGraphic") and decalsyeeted then
		v.Graphic = 0
	elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
		v[v.ClassName .. "Template"] = 0
	end
end

for _, v in pairs(w:GetDescendants()) do
	optimizePart(v)
end

local function optimizeLightingEffect(effect)
	if
		effect:IsA("BlurEffect")
		or effect:IsA("SunRaysEffect")
		or effect:IsA("ColorCorrectionEffect")
		or effect:IsA("BloomEffect")
		or effect:IsA("DepthOfFieldEffect")
	then
		effect.Enabled = false
	end
end

for _, effect in pairs(l:GetChildren()) do
	optimizeLightingEffect(effect)
end

l.ChildAdded:Connect(optimizeLightingEffect)

w.DescendantAdded:Connect(function(v)
	task.wait() -- prevent errors
	optimizePart(v)
end)
