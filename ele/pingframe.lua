
local AddOnName, ImproveAny = ...

local config_update = 1

function ImproveAny:InitIAPingFrame()
	if ImproveAny:IsEnabled( "IAPingFrame", true ) then
		IAPingFrame = CreateFrame( "Frame", "IAPingFrame", UIParent )
		IAPingFrame:SetSize( 200, 20 )
		IAPingFrame:SetPoint( "TOPLEFT", UIParent, "TOPLEFT", 10, -10 )
		
		IAPingFrame.ping = IAPingFrame:CreateFontString( "IAPingFrame.ping", "BACKGROUND" )
		IAPingFrame.ping:SetPoint( "CENTER", IAPingFrame, "CENTER", 0, 0 )
		IAPingFrame.ping:SetFont( STANDARD_TEXT_FONT, 14, "THINOUTLINE" )

		function IAFPSThink()
			local down, up, lagHome, lagWorld = GetNetStats();
			IAPingFrame.ping:SetText( format( "|cff3FC7EBPing|r: %3dms (H) %3dms (W)", lagHome, lagWorld ) )
			C_Timer.After( config_update, IAFPSThink )
		end
		IAFPSThink()
	end
end
