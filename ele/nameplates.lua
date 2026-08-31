local _, ImproveAny = ...
local font = "Interface\\AddOns\\ImproveAny\\media\\Prototype.ttf"
local MAXDEPTH = 4

local function ApplyFont(region, useCustom)
	if region == nil then return end
	if region.GetObjectType == nil then return end
	if region:GetObjectType() ~= "FontString" then return end
	if region.GetFont == nil or region.SetFont == nil then return end
	local oldFont, size, flags = region:GetFont()
	if oldFont == nil then return end
	if region.IAOldFont == nil then region.IAOldFont = oldFont end
	if useCustom then
		region:SetFont(font, size, flags)
	else
		region:SetFont(region.IAOldFont, size, flags)
	end
end

local function ApplyToFrame(frame, useCustom, depth)
	if frame == nil then return end
	if depth > MAXDEPTH then return end
	if frame.GetRegions then ImproveAny:ForeachRegions(frame, function(region) ApplyFont(region, useCustom) end, "UpdateNameplateFont") end
	if frame.GetChildren then ImproveAny:ForeachChildren(frame, function(child) ApplyToFrame(child, useCustom, depth + 1) end, "UpdateNameplateFont") end
end

function ImproveAny:UpdateNameplateFont(plate)
	if plate == nil then return end
	local useCustom = ImproveAny:IAGV("fontName", "Default") ~= "Default"
	ApplyToFrame(plate.UnitFrame or plate, useCustom, 1)
end

function ImproveAny:UpdateNameplateFonts()
	if C_NamePlate == nil or C_NamePlate.GetNamePlates == nil then return end
	for i, plate in ipairs(C_NamePlate.GetNamePlates()) do
		ImproveAny:UpdateNameplateFont(plate)
	end
end

function ImproveAny:InitNameplateFonts()
	if C_NamePlate == nil or C_NamePlate.GetNamePlateForUnit == nil then return end
	local f = CreateFrame("Frame", "IANameplateFonts")
	ImproveAny:RegisterEvent(f, "NAME_PLATE_UNIT_ADDED")
	ImproveAny:OnEvent(
		f,
		function(sel, event, unit)
			local plate = C_NamePlate.GetNamePlateForUnit(unit)
			if plate == nil then return end
			ImproveAny:UpdateNameplateFont(plate)
		end, "NAME_PLATE_UNIT_ADDED"
	)

	ImproveAny:UpdateNameplateFonts()
end
