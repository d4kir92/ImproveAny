
local AddOnName, ImproveAny = ...

local config_update = 0.3

function ImproveAny:InitIACoordsFrame()
	if ImproveAny:IsEnabled( "IACoordsFrame", true ) then
		IACoordsFrame = CreateFrame( "Frame", "IACoordsFrame", UIParent )
		IACoordsFrame:SetSize( 100, 20 )
		IACoordsFrame:SetPoint( "BOTTOM", Minimap, "BOTTOM", 0, 0 )
		
		IACoordsFrame.coords = IACoordsFrame:CreateFontString( "IACoordsFrame.coords", "BACKGROUND" )
		IACoordsFrame.coords:SetPoint( "CENTER", IACoordsFrame, "CENTER", 0, 0 )
		IACoordsFrame.coords:SetFont( STANDARD_TEXT_FONT, 14, "THINOUTLINE" )

		function IAFPSThink()
			if ImproveAny.GetBestPosXY then
				local x, y = ImproveAny:GetBestPosXY( "PLAYER" )
				IACoordsFrame.coords:SetText( format( "|cff3FC7EB%0.1f, %0.1f", x * 100, y * 100 ) )
			end
			C_Timer.After( config_update, IAFPSThink )
		end
		IAFPSThink()
	end
end
