
local AddOnName, ImproveAny = ...

if SuperTrackedFrame and SuperTrackedFrame.GetTargetAlphaBaseValue then
	local fAlpha = SuperTrackedFrame.GetTargetAlphaBaseValue

	function SuperTrackedFrame:GetTargetAlphaBaseValue()
		if fAlpha(self) == 0 and C_Navigation.GetDistance() >= 1000 then
			return 0.5
		else
			return fAlpha(self)
		end
	end
	
	SuperTrackedFrame.DistanceTime = SuperTrackedFrame:CreateFontString( nil, "ARTWORK" )
	SuperTrackedFrame.DistanceTime:SetFont( STANDARD_TEXT_FONT, 12, "" )
	SuperTrackedFrame.DistanceTime:SetPoint( "TOP", SuperTrackedFrame, "BOTTOM", 0, -38 )
	SuperTrackedFrame.DistanceTime:SetText( "LOADING" )
	SuperTrackedFrame.DistanceTime:SetTextColor(SuperTrackedFrame.DistanceText:GetTextColor())
	SuperTrackedFrame.DistanceTime:SetShadowOffset(SuperTrackedFrame.DistanceText:GetShadowOffset())

	if C_Navigation then
		FLOAT_SPELL_DURATION_SEC = string.iareplace( INT_SPELL_DURATION_SEC, "%d", "%0.0f" )
		FLOAT_SPELL_DURATION_MIN = string.iareplace( INT_SPELL_DURATION_MIN, "%d", "%0.1f" )

		local lastDist = 0
		local lastDistPerSec = 0
		local distPerSec = 0
		local timeToTarget = 0
		local scale = 10
		local cd = 1 / scale
		function IAThinkSuperTrackedFrame()
			local distance = C_Navigation.GetDistance()
			local distDif = lastDist - distance
			distPerSec = distDif * scale
			distPerSec = floor( distPerSec )

			if distPerSec ~= 0 then
				distPerSec = IALerp( lastDistPerSec, distPerSec, 0.2 )
				timeToTarget = distance / distPerSec
			else
				timeToTarget = 0
			end

			local secs = timeToTarget
			local clamped = C_Navigation.WasClampedToScreen()
			if clamped then
				SuperTrackedFrame.DistanceTime:SetText( "" )
			else
				if secs == 0 then
					SuperTrackedFrame.DistanceTime:SetText( "∞" )
				elseif secs > -60 and secs < 60 then
					SuperTrackedFrame.DistanceTime:SetText( format(FLOAT_SPELL_DURATION_SEC, secs ) )
				else
					SuperTrackedFrame.DistanceTime:SetText( format(FLOAT_SPELL_DURATION_MIN, secs / 60 ) )
				end
			end

			lastDistPerSec = distPerSec
			lastDist = distance
			C_Timer.After( cd, IAThinkSuperTrackedFrame )
		end
		IAThinkSuperTrackedFrame()
	end
end
