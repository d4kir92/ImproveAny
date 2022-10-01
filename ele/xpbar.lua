
local AddOnName, ImproveAny = ...

local textc = "|cFF00FF00" -- Colored
local textw = "|r" -- "WHITE"
local maxlevel = 60

local XPS = 0
function IAGetXPPerSec()
	return XPS
end
local XPH = 0
function IAGetXPPerHour()
	return XPH
end

local HOUR = string.iareplace( COOLDOWN_DURATION_HOURS, "%d ", "" )
HOUR = string.iareplace( HOUR, "%d", "" )

local inCombat = false
local f  = CreateFrame( "FRAME" )
f:RegisterEvent( "PLAYER_REGEN_ENABLED" )
f:RegisterEvent( "PLAYER_REGEN_DISABLED" )
f:SetScript( "OnEvent", function( self, event, ... )
	if event == "PLAYER_REGEN_ENABLED" then
		inCombat = false
	elseif event == "PLAYER_REGEN_DISABLED" then
		inCombat = true
	end
end )

local ts = 0
local totalxp = 0
local lastxp = UnitXP( "PLAYER" )
local lastxpmax = UnitXPMax( "PLAYER" )
function IAXPPerHourLoop()
	if inCombat or true then
		ts = ts + 0.2
	end

	local curxp = UnitXP( "PLAYER" )
	local curxpmax = UnitXPMax( "PLAYER" )
	local curxpexh = GetXPExhaustion() or 0

	local gainedxp = 0
	if curxp > lastxp then
		-- Gained Xp
		gainedxp = curxp - lastxp
	elseif curxp < lastxp then
		-- Gained Xp + Levelup
		--gainedxp = lastxpmax - lastxp + curxp
		ts = 0
		totalxp = 0
	end
	if gainedxp > 0 then
		totalxp = totalxp + gainedxp
	elseif gainedxp < 0 then
		print("ERROR", gainedxp)
	end
	lastxp = curxp
	lastxpmax = curxpmax

	if curxpmax ~= 0 and ts > 0 then
		local xps = totalxp / ts
		local xpm = xps * 60
		local xph = xpm * 60

		XPS = xps
		XPH = xph

		if MainMenuBarExpText then
			MainMenuBarExpText:SetText( "LOADING" )
		end

		if MainMenuExpBar then
			if MainMenuExpBar.xph then
				local sw, sh = MainMenuExpBar:GetSize()
				local px = ( curxp ) / curxpmax * sw
				local wi = xph / curxpmax * sw
				if wi <= 0 then
					wi = 1
				end
				if px + wi > sw then
					wi = sw - px
				end

				MainMenuExpBar.xph:SetPoint( "LEFT", MainMenuExpBar, "LEFT", px, 0 )
				MainMenuExpBar.xph:SetWidth( wi )
			end
		end
	end

	C_Timer.After( 0.2, IAXPPerHourLoop )
end

function ImproveAny:InitXPBar()
	C_Timer.After( 1, function()
		lastxp = UnitXP( "PLAYER" )
		lastxpmax = UnitXPMax( "PLAYER" )

		IAXPPerHourLoop()
	end )

	C_Timer.After( 0.01, function()
		if IABUILD == "TBC" then
			maxlevel = 70
		end
		if IABUILD == "WRATH" then
			maxlevel = 80
		end
		if GetMaxLevelForPlayerExpansion then
			maxlevel = GetMaxLevelForPlayerExpansion()
		end

		if MainMenuExpBar then
			MainMenuExpBar:SetHeight( 15 )

			MainMenuExpBar.show = true
			MainMenuExpBar:HookScript( "OnEnter", function( self )
				MainMenuExpBar.show = false
				MainMenuBarExpText:Hide()
			end )
			MainMenuExpBar:HookScript( "OnLeave", function( self )
				MainMenuExpBar.show = true
				MainMenuBarExpText:Show()
			end )
		end

		if ImproveAny:IsEnabled( "XPHIDEARTWORK", false ) then
			for i = 0, 3 do
				local art = _G["MainMenuXPBarTexture" .. i]
				if art then
					art:Hide()
				end
			end
		end

		if MainMenuExpBar then
			local sw, sh = MainMenuExpBar:GetSize()
			MainMenuExpBar.xph = MainMenuExpBar:CreateTexture( nil, "ARTWORK" )
			MainMenuExpBar.xph:SetTexture([[Interface\TargetingFrame\UI-StatusBar]])
			MainMenuExpBar.xph:SetVertexColor( 1, 1, 0.5, 0.5 )
			MainMenuExpBar.xph:SetDrawLayer( "ARTWORK", 1 )
			MainMenuExpBar.xph:SetSize( 1, sh )
		end

		if MainMenuExpBar and MainMenuBarExpText then
			local fontName, fontSize, fontFlags = MainMenuBarExpText:GetFont()	
			MainMenuBarExpText:SetFont( fontName, 12, fontFlags )
			MainMenuBarExpText:SetPoint( "CENTER", MainMenuExpBar, "CENTER", 0, 1 )
			hooksecurefunc( MainMenuBarExpText, "SetText", function( self, text )
				if self.iasettext then return end
				self.iasettext = true

				local currXP = UnitXP("PLAYER")
				local maxBar = UnitXPMax("PLAYER")
			
				if maxBar == 0 then
					self.iasettext = false
					return
				end

				if (GameLimitedMode_IsActive()) then
					local rLevel = GetRestrictedAccountData()
					if (UnitLevel("player") >= rLevel) then
						currXP = UnitTrialXP("player")
					end
				end
				local xps = IAGetXPPerSec()
				local xph = IAGetXPPerHour()
				local per = currXP / maxBar
				local percent = per * 100
				local missingXp = (maxBar - currXP)
				local percent2 = missingXp / maxBar * 100
				local xplu = 0
				if xps > 0 then
					xplu = missingXp / xps -- XP to  level up
				end

				local text = ""
				if ImproveAny:IsEnabled( "XPLEVEL", false ) then
					if text ~= "" then
						text = text .. "    "
					end
					text = text .. LEVEL .. ": " .. textc .. UnitLevel("PLAYER") .. textw .. "/" .. textc .. maxlevel .. textw
				end

				if ImproveAny:IsEnabled( "XPNUMBER", true ) then
					if text ~= "" then
						text = text .. "    "
					end
					text = text .. XP .. ": " .. textc .. IAFormatValue(currXP) .. textw .. "/" .. textc .. IAFormatValue(maxBar)
				end
				if ImproveAny:IsEnabled( "XPPERCENT", true ) then
					if ImproveAny:IsEnabled( "XPNUMBER", true ) then
						if text ~= "" then
							text = text .. textw .. " ("
						end
					else
						if text ~= "" then
							text = text .. "    "
						end
					end
					text = text .. textc .. format("%.2f", percent) .. textw .. "%"
					if ImproveAny:IsEnabled( "XPNUMBER", true ) then
						if text ~= "" then
							text = text .. textw .. ")"
						end
					end
				end

				if ImproveAny:IsEnabled( "XPEXHAUSTION", true ) then
					if GetXPExhaustion() and GetXPExhaustion() >= 0 then
						local eper = GetXPExhaustion() / maxBar
						local epercent = eper * 100
						if text ~= "" then
							text = text .. "    "
						end
						text = text .. textw .. TUTORIAL_TITLE26 .. ": " .. textc .. IAFormatValue( GetXPExhaustion() ) .. " " .. textw .. "(" .. textc .. format("%.2f", epercent) .. "%" .. textw .. ")"
					end
				end

				if ImproveAny:IsEnabled( "XPMISSING", true ) then
					if text ~= "" then
						text = text .. "    "
					end
					text = text .. ADDON_MISSING .. ": " .. textc .. IAFormatValue(missingXp) .. textw .. " (" .. textc .. format("%.2f", percent2) .. "%" .. textw .. ")"
				end

				if ImproveAny:IsEnabled( "XPXPPERHOUR", true ) then
					if text ~= "" then
						text = text .. " "
					end
					text = text .. textc .. string.format( SecondsToTime( xplu ) ) .. textw
				end

				if ImproveAny:IsEnabled( "XPXPPERHOUR", true ) then
					if xph > 0 then
						text = text .. "    " .. textc .. IAFormatValue( xph, xph <= 5000 and 1 or 0 ) .. textw .. " " .. textw .. XP .. "/" .. HOUR
					end
				end

				self:SetText(text)
				if MainMenuExpBar.show then
					self:Show()
				end

				self.iasettext = false
			end )
			MainMenuBarExpText:SetText( "LOADING" )
		end
	end )
end
