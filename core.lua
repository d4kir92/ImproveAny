
local AddOnName, ImproveAny = ...

SLASH_RL1 = "/rl"
SlashCmdList["RL"] = function(msg)
	C_UI.Reload()
end

IABUILDNR = select(4, GetBuildInfo())
IABUILD = "CLASSIC"
if IABUILDNR >= 100000 then
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

SLASH_IMPROVEANY1, SLASH_IMPROVEANY2 = "/improve", "/improveany"
SlashCmdList["IMPROVEANY"] = function(msg)
	ImproveAny:ToggleSettings()
end



IAHIDDEN = CreateFrame( "FRAME", "IAHIDDEN" )
IAHIDDEN:Hide()



local IAMaxZoom = 5
function ImproveAny:GetMaxZoom()
	return IAMaxZoom
end
for i = 2.6, 5.0, 0.1 do
	ConsoleExec( "cameraDistanceMaxZoomFactor " .. i )
end
IAMaxZoom = tonumber( GetCVar( "cameraDistanceMaxZoomFactor" ) )

function ImproveAny:UpdateMaxZoom()
	ConsoleExec( "cameraDistanceMaxZoomFactor " .. IAGV( "MAXZOOM", ImproveAny:GetMaxZoom() ) )
end

function ImproveAny:UpdateWorldTextScale()
	ConsoleExec( "WorldTextScale " .. IAGV( "WORLDTEXTSCALE", 1.0 ) )
end

function ImproveAny:CheckCVars()
	if IAGV( "MAXZOOM", ImproveAny:GetMaxZoom() ) ~= tonumber( GetCVar( "cameraDistanceMaxZoomFactor" ) ) then
		ImproveAny:UpdateMaxZoom()
	end
	if IAGV( "WORLDTEXTSCALE", 1.0 ) ~= tonumber( GetCVar( "WorldTextScale" ) ) then
		ImproveAny:UpdateWorldTextScale()
	end
	C_Timer.After( 1, ImproveAny.CheckCVars )
end



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
		ImproveAny:InitSuperTrackedFrame()
		
		ImproveAny:InitIASettings()

		if ImproveAny:IsEnabled( "CHAT", true ) then
			ImproveAny:InitChat()
			if IAUpdateChatChannels then
				IAUpdateChatChannels()
			end
		end

		ImproveAny:InitRaidFrames()

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


		ImproveAny:UpdateMaxZoom()
		ImproveAny:UpdateWorldTextScale()

		ImproveAny:CheckCVars()
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




if OnTooltipSetItem and OnTooltipSetSpell then
	for _,frame in pairs{ GameTooltip, ItemRefTooltip, WhatevahTooltip } do
		frame:SetScript( "OnTooltipSetItem", function( tt )
			local _, itemLink = tt:GetItem()
			if itemLink then	
				local itemId = tonumber(strmatch(itemLink, 'item:(%d*)'))
				if itemId then
					local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, price, classID, _, _, expacID, _, _ = GetItemInfo( itemId )
					if price and tt.shownMoneyFrames == nil then
						if price > 0 and GetItemCount and GetCoinTextureString then
							local count = GetItemCount( itemId )
							if ImproveAny:IsEnabled( "SELLPRICE", false ) then
								if count and count > 1 and itemStackCount and AUCTION_BROWSE_UNIT_PRICE_SORT then
									tt:AddDoubleLine( AUCTION_BROWSE_UNIT_PRICE_SORT .. "", GetCoinTextureString( price ) )
									tt:AddDoubleLine( SELL_PRICE .. " (" .. count .. "/" .. itemStackCount .. ")", GetCoinTextureString( price * count ) )
								else
									tt:AddDoubleLine( SELL_PRICE .. ":", GetCoinTextureString( price ) )
								end
							end
						else
							--tt:AddDoubleLine(ITEM_UNSELLABLE)
						end
					end
				end
			end
		end )

		frame:SetScript( "OnTooltipSetSpell", function( tt ) 
			local spellName, spellID = tt:GetSpell()
			if spellID then
				if ImproveAny:IsEnabled( "SETTINGS", false ) then
					tt:AddDoubleLine( "SpellID" .. ":", "|cFFFFFFFF" .. spellID )
				end
			end 
		end )
	end
end
