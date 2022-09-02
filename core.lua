
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

		ImproveAny:InitDB()

		ImproveAny:InitCastBar()
		ImproveAny:InitDurabilityFrame()
		ImproveAny:InitItemLevel()
		ImproveAny:InitMinimap()
		ImproveAny:InitMoneyBar()
		ImproveAny:InitSkillBars()
		ImproveAny:InitBags()

		ImproveAny:InitIASettings()

		IAUpdateChatChannels()

		C_Timer.After( 1, function()
			for i = 2.6, 4.1, 0.1 do
				ConsoleExec( "cameraDistanceMaxZoomFactor " .. i )
			end
			ConsoleExec( "WorldTextScale " .. 1.2 )
		end )

		local ImproveAnyMinimapIcon = LibStub("LibDataBroker-1.1"):NewDataObject("ImproveAnyMinimapIcon", {
			type = "data source",
			text = "ImproveAnyMinimapIcon",
			icon = 136033,
			OnClick = function(self, btn)
				if btn == "LeftButton" then
					ImproveAny:ToggleSettings()
				elseif btn == "RightButton" then
					--ToggleMinimapButton()
				end
			end,
			OnTooltipShow = function(tooltip)
				if not tooltip or not tooltip.AddLine then return end
				tooltip:AddLine( "ImproveAny")
				tooltip:AddLine( "LeftClick = Options" )
				--tooltip:AddLine( "RightClick = Options" )
			end,
		})
		if ImproveAnyMinimapIcon then
			icon = LibStub("LibDBIcon-1.0", true)
			if icon then
				icon:Register( "ImproveAnyMinimapIcon", ImproveAnyMinimapIcon, IAGV( "MMICON", {} ) )
			end
		end

		--print("|cff00ff00Loaded " .. AddOnName )
	end
end

local f = CreateFrame("Frame")
f:SetScript( "OnEvent", ImproveAny.Event )
f:RegisterEvent( "PLAYER_LOGIN" )
f.incombat = false 



local ts = 0
function FastLooting()
    if GetTime() - ts >= 0.3 then
        ts = GetTime()
        if GetCVarBool( "autoLootDefault" ) ~= IsModifiedClick( "AUTOLOOTTOGGLE" ) then
            for i = GetNumLootItems(), 1, -1 do
                LootSlot( i )
            end
            ts = GetTime()
        end
    end
end

local f = CreateFrame( "Frame" )
f:RegisterEvent( "LOOT_READY" )
f:SetScript( "OnEvent", FastLooting )
