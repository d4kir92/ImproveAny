
local AddOnName, ImproveAny = ...

SLASH_RL1 = "/rl"
SlashCmdList["RL"] = function(msg)
	C_UI.Reload()
end

IABUILDNR = select(4, GetBuildInfo())
IABUILD = "CLASSIC"
if IABUILDNR > 90000 then
	IABUILD = "RETAIL"
elseif IABUILDNR > 29999 then
	IABUILD = "WRATH"
elseif IABUILDNR > 19999 then
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



SLASH_RL1 = "/rl"
SlashCmdList["RL"] = function(msg)
	C_UI.Reload()
end

SLASH_IMAN1, SLASH_IMAN2 = "/iman", "/improveany"
SlashCmdList["IMAN"] = function(msg)
	ImproveAny:ToggleSettings()
end



IAHIDDEN = CreateFrame( "FRAME", "IAHIDDEN" )
IAHIDDEN:Hide()



function ImproveAny:Event( event, ... )
	if ImproveAny.Setup == nil then
		ImproveAny.Setup = true

		if IsAddOnLoaded("D4KiR MoveAndImprove") then
			ImproveAny:MSG( "DON'T use MoveAndImprove, when you use ImproveAny" )
		end

		ImproveAny:InitDB()

		if ImproveAny:IsEnabled( "CASTBAR", true ) then
			ImproveAny:InitCastBar()
		end
		if ImproveAny:IsEnabled( "DURABILITY", true ) then
			ImproveAny:InitDurabilityFrame()
		end
		ImproveAny:InitItemLevel()
		ImproveAny:InitMinimap()
		ImproveAny:InitMoneyBar()
		ImproveAny:InitTokenBar()
		ImproveAny:InitSkillBars()
		if ImproveAny:IsEnabled( "BAGS", true ) then
			ImproveAny:InitBags()
		end
		if ImproveAny:IsEnabled( "WORLDMAP", true ) then
			ImproveAny:InitWorldMapFrame()
		end
		ImproveAny:InitXPBar()
		
		ImproveAny:InitIASettings()

		if ImproveAny:IsEnabled( "CHAT", true ) then
			ImproveAny:InitChat()
			IAUpdateChatChannels()
		end

		C_Timer.After( 1, function()
			for i = 2.6, 4.1, 0.1 do
				ConsoleExec( "cameraDistanceMaxZoomFactor " .. i )
			end
			ConsoleExec( "WorldTextScale " .. 1.2 )
		end )

		function ImproveAny:UpdateMinimapButton()
			if IAMMBTN then
				if ImproveAny:IsEnabled( "SHOWMINIMAPBUTTON", true ) then
					IAMMBTN:Show("ImproveAnyMinimapIcon")
				else
					IAMMBTN:Hide("ImproveAnyMinimapIcon")
				end
			end
		end

		function ImproveAny:ToggleMinimapButton()
			ImproveAny:SetEnabled( "SHOWMINIMAPBUTTON", not ImproveAny:IsEnabled( "SHOWMINIMAPBUTTON", true ) )
			if IAMMBTN then
				if ImproveAny:IsEnabled( "SHOWMINIMAPBUTTON", true ) then
					IAMMBTN:Show("ImproveAnyMinimapIcon")
				else
					IAMMBTN:Hide("ImproveAnyMinimapIcon")
				end
			end
		end
		
		function ImproveAny:HideMinimapButton()
			ImproveAny:SetEnabled( "SHOWMINIMAPBUTTON", false )
			if IAMMBTN then
				IAMMBTN:Hide("ImproveAnyMinimapIcon")
			end
		end
		
		function ImproveAny:ShowMinimapButton()
			ImproveAny:SetEnabled( "SHOWMINIMAPBUTTON", true )
			if IAMMBTN then
				IAMMBTN:Show("ImproveAnyMinimapIcon")
			end
		end

		local ImproveAnyMinimapIcon = LibStub("LibDataBroker-1.1"):NewDataObject("ImproveAnyMinimapIcon", {
			type = "data source",
			text = "ImproveAnyMinimapIcon",
			icon = 136033,
			OnClick = function(self, btn)
				if btn == "LeftButton" then
					ImproveAny:ToggleSettings()
				elseif btn == "RightButton" then
					ImproveAny:HideMinimapButton()
				end
			end,
			OnTooltipShow = function(tooltip)
				if not tooltip or not tooltip.AddLine then return end
				tooltip:AddLine( "ImproveAny")
				tooltip:AddLine( IAGT( "MMBTNLEFT" ) )
				tooltip:AddLine( IAGT( "MMBTNRIGHT" ) )
			end,
		})
		if ImproveAnyMinimapIcon then
			IAMMBTN = LibStub("LibDBIcon-1.0", true)
			if IAMMBTN then
				IAMMBTN:Register( "ImproveAnyMinimapIcon", ImproveAnyMinimapIcon, ImproveAny:GetMinimapTable() )
			end
		end

		if IAMMBTN then
			if ImproveAny:IsEnabled( "SHOWMINIMAPBUTTON", true ) then
				IAMMBTN:Show("ImproveAnyMinimapIcon")
			else
				IAMMBTN:Hide("ImproveAnyMinimapIcon")
			end
		end
	end
end

local f = CreateFrame("Frame")
f:SetScript( "OnEvent", ImproveAny.Event )
f:RegisterEvent( "PLAYER_LOGIN" )
f.incombat = false 



local ts = 0
function FastLooting()
    if GetTime() - ts >= 0.2 and ImproveAny:IsEnabled( "FASTLOOTING", true ) then
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
