local _, ImproveAny = ...
local BuildNr = select(4, GetBuildInfo())
local Build = "CLASSIC"
if BuildNr >= 100000 then
	Build = "RETAIL"
elseif BuildNr > 29999 then
	Build = "WRATH"
elseif BuildNr > 19999 then
	Build = "TBC"
end

function ImproveAny:GetWoWBuildNr()
	return BuildNr
end

function ImproveAny:GetWoWBuild()
	return Build
end

local COL_R = "|cFFFF0000"
local COL_Y = "|cFFFFFF00"
function ImproveAny:MSG(msg)
	print("|cff3FC7EB" .. "[ImproveAny |T136033:16:16:0:0|t]|r " .. COL_Y .. msg)
end

function ImproveAny:MSG_Error(msg)
	print("|cff3FC7EB" .. "[ImproveAny |T136033:16:16:0:0|t]|r " .. COL_R .. "[ERROR] |r" .. msg)
end

function ImproveAny:GetCP()
	IATAB = IATAB or {}
	IATAB["CURRENTPROFILE"] = IATAB["CURRENTPROFILE"] or "DEFAULT"

	return IATAB["CURRENTPROFILE"]
end

function ImproveAny:AddProfile(name)
	IATAB = IATAB or {}
	IATAB["PROFILES"] = IATAB["PROFILES"] or {}
	-- Profile
	IATAB["PROFILES"][name] = IATAB["PROFILES"][name] or {}
	-- Frames
	IATAB["PROFILES"][name]["FRAMES"] = IATAB["PROFILES"][name]["FRAMES"] or {}
	IATAB["PROFILES"][name]["FRAMES"]["POINTS"] = IATAB["PROFILES"][name]["FRAMES"]["POINTS"] or {}
	IATAB["PROFILES"][name]["FRAMES"]["SIZES"] = IATAB["PROFILES"][name]["FRAMES"]["SIZES"] or {}
	-- Eles
	IATAB["PROFILES"][name]["ELES"] = IATAB["PROFILES"][name]["ELES"] or {}
	IATAB["PROFILES"][name]["ELES"]["POINTS"] = IATAB["PROFILES"][name]["ELES"]["POINTS"] or {}
	IATAB["PROFILES"][name]["ELES"]["SIZES"] = IATAB["PROFILES"][name]["ELES"]["SIZES"] or {}
	IATAB["PROFILES"][name]["ELES"]["OPTIONS"] = IATAB["PROFILES"][name]["ELES"]["OPTIONS"] or {}
	IATAB["PROFILES"][name]["ELES"]["OPTIONS"]["ACTIONBARS"] = IATAB["PROFILES"][name]["ELES"]["OPTIONS"]["ACTIONBARS"] or {}
end

function ImproveAny:InitDB()
	-- DB
	IATAB = IATAB or {}
	-- PROFILES
	IATAB["PROFILES"] = IATAB["PROFILES"] or {}
	IATAB["CURRENTPROFILE"] = IATAB["CURRENTPROFILE"] or "DEFAULT"
	ImproveAny:AddProfile("DEFAULT")
end

function ImproveAny:GetTab()
	IATAB = IATAB or {}
	IATAB["PROFILES"] = IATAB["PROFILES"] or {}

	return IATAB["PROFILES"][ImproveAny:GetCP()]
end

function ImproveAny:SetEnabled(element, value)
	ImproveAny:GetTab()["ELES"]["OPTIONS"][element] = ImproveAny:GetTab()["ELES"]["OPTIONS"][element] or {}
	ImproveAny:GetTab()["ELES"]["OPTIONS"][element]["ENABLED"] = value
end

function ImproveAny:IsEnabled(element, value)
	if element == nil then
		ImproveAny:MSG_Error("[IsEnabled] Missing Name")

		return false
	end

	if value == nil then
		ImproveAny:MSG_Error("[IsEnabled] Missing Value")

		return false
	end

	if ImproveAny:GetTab() and ImproveAny:GetTab()["ELES"] then
		ImproveAny:GetTab()["ELES"]["OPTIONS"][element] = ImproveAny:GetTab()["ELES"]["OPTIONS"][element] or {}
		if ImproveAny:GetTab()["ELES"]["OPTIONS"][element]["ENABLED"] == nil then
			ImproveAny:GetTab()["ELES"]["OPTIONS"][element]["ENABLED"] = value
		end

		return ImproveAny:GetTab()["ELES"]["OPTIONS"][element]["ENABLED"]
	end

	return value
end

function ImproveAny:GetElePoint(key)
	ImproveAny:GetTab()["ELES"]["POINTS"][key] = ImproveAny:GetTab()["ELES"]["POINTS"][key] or {}
	local an = ImproveAny:GetTab()["ELES"]["POINTS"][key]["AN"]
	local pa = ImproveAny:GetTab()["ELES"]["POINTS"][key]["PA"]
	local re = ImproveAny:GetTab()["ELES"]["POINTS"][key]["RE"]
	local px = ImproveAny:GetTab()["ELES"]["POINTS"][key]["PX"]
	local py = ImproveAny:GetTab()["ELES"]["POINTS"][key]["PY"]

	return an, pa, re, px, py
end

function ImproveAny:SetElePoint(key, p1, p2, p3, p4, p5)
	ImproveAny:GetTab()["ELES"]["POINTS"][key]["AN"] = p1
	ImproveAny:GetTab()["ELES"]["POINTS"][key]["PA"] = p2
	ImproveAny:GetTab()["ELES"]["POINTS"][key]["RE"] = p3
	ImproveAny:GetTab()["ELES"]["POINTS"][key]["PX"] = p4
	ImproveAny:GetTab()["ELES"]["POINTS"][key]["PY"] = p5
	local frame = _G[key]
	if frame then
		frame:ClearAllPoints()
		frame:SetPoint(p1, UIParent, p3, p4, p5)
	end
end

function ImproveAny:SV(name, value)
	IATAB = IATAB or {}
	IATAB["VALUES"] = IATAB["VALUES"] or {}
	IATAB["VALUES"][name] = value
end

function ImproveAny:GV(name, value)
	IATAB = IATAB or {}
	IATAB["VALUES"] = IATAB["VALUES"] or {}
	if IATAB["VALUES"][name] == nil then
		ImproveAny:SV(name, value)
	end

	return IATAB["VALUES"][name] or value
end

function ImproveAny:GetMinimapTable()
	IATAB["PROFILES"] = IATAB["PROFILES"] or {}
	ImproveAny:GetTab()["MMICON"] = ImproveAny:GetTab()["MMICON"] or {}

	return ImproveAny:GetTab()["MMICON"]
end