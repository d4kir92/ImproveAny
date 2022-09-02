
local AddOnName, ImproveAny = ...

local COL_R = "|cFFFF0000"

function ImproveAny:MSG_Error( msg )
	print( "|cFFA4A4FF" .. "[ImproveAny] " .. COL_R .. "[ERROR] |r|r" .. msg )
		
end

function ImproveAny:GetCP()
	IATAB = IATAB or {}
	IATAB["CURRENTPROFILE"] = IATAB["CURRENTPROFILE"] or "DEFAULT"

	return IATAB["CURRENTPROFILE"]
end

function ImproveAny:AddProfile( name )
	IATAB = IATAB or {}
	IATAB["PROFILES"] = IATAB["PROFILES"] or {}

	-- Profile
	IATAB["PROFILES"][name] = IATAB["PROFILES"][name] or {}

	-- Frames
	IATAB["PROFILES"][name]["FRAMES"] =  IATAB["PROFILES"][name]["FRAMES"] or {}
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

	ImproveAny:AddProfile( "DEFAULT" )
end

function ImproveAny:GetTab()
	return IATAB["PROFILES"][ImproveAny:GetCP()]
end

function ImproveAny:GetElePoint( key )
	ImproveAny:GetTab()["ELES"]["POINTS"][key] = ImproveAny:GetTab()["ELES"]["POINTS"][key] or {}

	local an = ImproveAny:GetTab()["ELES"]["POINTS"][key]["AN"]
	local pa = ImproveAny:GetTab()["ELES"]["POINTS"][key]["PA"]
	local re = ImproveAny:GetTab()["ELES"]["POINTS"][key]["RE"]
	local px = ImproveAny:GetTab()["ELES"]["POINTS"][key]["PX"]
	local py = ImproveAny:GetTab()["ELES"]["POINTS"][key]["PY"]
	return an, pa, re, px, py
end

function ImproveAny:SetElePoint( key, p1, p2, p3, p4, p5 )
	ImproveAny:GetTab()["ELES"]["POINTS"][key]["AN"] = p1
	ImproveAny:GetTab()["ELES"]["POINTS"][key]["PA"] = p2
	ImproveAny:GetTab()["ELES"]["POINTS"][key]["RE"] = p3
	ImproveAny:GetTab()["ELES"]["POINTS"][key]["PX"] = p4
	ImproveAny:GetTab()["ELES"]["POINTS"][key]["PY"] = p5

	local frame = _G[key]
	if frame then
		frame:ClearAllPoints()
		frame:SetPoint( p1, UIParent, p3, p4, p5 )
	end
end

function IASV( name, value )
	IATAB = IATAB or {}
	IATAB["VALUES"] = IATAB["VALUES"] or {}
	IATAB["VALUES"][name] = value
end

function IAGV( name, value )
	IATAB = IATAB or {}
	IATAB["VALUES"] = IATAB["VALUES"] or {}
	if IATAB["VALUES"][name] == nil then
		IASV( name, value )
	end
	return IATAB["VALUES"][name] or value
end
