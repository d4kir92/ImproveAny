
local AddOnName, ImproveAny = ...

local config_update = 1

function ImproveAny:InitIAPingFrame()
	if ImproveAny:IsEnabled( "IAPingFrame", true ) then
		IAPingFrame = CreateFrame( "Frame", "IAPingFrame", UIParent )
		IAPingFrame:SetSize( 100, 20 )
		IAPingFrame:SetPoint( "TOPLEFT", UIParent, "TOPLEFT", 10, -10 )
		
		IAPingFrame.ping = IAPingFrame:CreateFontString( "IAPingFrame.ping", "BACKGROUND" )
		IAPingFrame.ping:SetPoint( "CENTER", IAPingFrame, "CENTER", 0, 0 )
		IAPingFrame.ping:SetFont( STANDARD_TEXT_FONT, 14, "THINOUTLINE" )

		function IAFPSThink()
			local down, up, lagHome, lagWorld = GetNetStats();
			local dif = abs( lagHome - lagWorld )
			local lagNorm = lagHome + dif
			if lagWorld < lagHome then
				lagNorm = lagWorld + dif
			end
			if dif > 10 then
				IAPingFrame.ping:SetText( format( "|cff3FC7EBPing|r: %4dms (H) %4dms (W)", lagHome, lagWorld ) )
			else
				IAPingFrame.ping:SetText( format( "|cff3FC7EBPing|r: %4dms", lagNorm ) )
			end
			C_Timer.After( config_update, IAFPSThink )
		end
		IAFPSThink()
	end
end
