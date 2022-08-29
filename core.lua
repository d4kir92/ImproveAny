
local AddOnName, ImproveAny = ...

SLASH_RL1 = "/rl"
SlashCmdList["RL"] = function(msg)
	C_UI.Reload()
end

IABUILD = "CLASSIC"
if select(4, GetBuildInfo()) > 90000 then
	IABUILD = "RETAIL"
elseif select(4, GetBuildInfo()) > 29999 then
	IABUILD = "WRATH"
elseif select(4, GetBuildInfo()) > 19999 then
	IABUILD = "TBC"
end

function IAMathC( val, vmin, vmax )
	if val == nil then
		return 0
	end
	if vmin == nil then
		return 0
	end
	if vmax == nil then
		return 1
	end
	if val < vmin then
		return vmin
	elseif val > vmax then
		return vmax
	else
		return val
	end
end

IAHIDDEN = CreateFrame( "FRAME", "IAHIDDEN" )
IAHIDDEN:Hide()

function ImproveAny:Event( event, ... )
	if ImproveAny.Setup == nil then
		ImproveAny.Setup = true

		IATAB = IATAB or {}

		ImproveAny:InitCastBar()
		ImproveAny:InitDurabilityFrame()
		ImproveAny:InitItemLevel()
		ImproveAny:InitMinimap()
		ImproveAny:InitMoneyBar()
		ImproveAny:InitSkillBars()
		ImproveAny:InitBags()
		
		IAUpdateChatChannels()

		--print("|cff00ff00Loaded " .. AddOnName )
	end
end

local f = CreateFrame("Frame")
f:SetScript( "OnEvent", ImproveAny.Event )
f:RegisterEvent( "PLAYER_LOGIN" )
f.incombat = false 
