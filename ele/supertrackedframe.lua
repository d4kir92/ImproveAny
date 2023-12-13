local _, ImproveAny = ...
function ImproveAny:InitSuperTrackedFrame()
	if SuperTrackedFrame == nil then
		SuperTrackedFrame = WorldSpacePin
	end

	if SuperTrackedFrame then
		if SuperTrackedFrame.GetTargetAlphaBaseValue then
			local fAlpha = SuperTrackedFrame.GetTargetAlphaBaseValue
			function SuperTrackedFrame:GetTargetAlphaBaseValue()
				if fAlpha(self) == 0 and C_Navigation.GetDistance() >= 1000 then
					return 0.5
				else
					return fAlpha(self)
				end
			end
		end

		if SuperTrackedFrame.GetTargetAlpha then
			local fAlpha = SuperTrackedFrame.GetTargetAlpha
			function SuperTrackedFrame:GetTargetAlpha()
				if fAlpha(self) == 0 and C_Navigation.GetDistance() >= 1000 then
					return 0.5
				else
					return fAlpha(self)
				end
			end
		end

		if SuperTrackedFrame.DistanceText == nil then
			SuperTrackedFrame.DistanceText = WorldSpacePin.text
		end

		SuperTrackedFrame.DistanceTime = SuperTrackedFrame:CreateFontString(nil, "ARTWORK")
		if C_Navigation then
			SuperTrackedFrame.DistanceTime:SetFont(STANDARD_TEXT_FONT, 12, "")
			SuperTrackedFrame.DistanceTime:SetPoint("TOP", SuperTrackedFrame, "BOTTOM", 0, -38)
		else
			SuperTrackedFrame.DistanceTime:SetFont(STANDARD_TEXT_FONT, 10, "")
			SuperTrackedFrame.DistanceTime:SetPoint("TOP", SuperTrackedFrame, "BOTTOM", 0, -12)
		end

		SuperTrackedFrame.DistanceTime:SetText("LOADING (IA)")
		SuperTrackedFrame.DistanceTime:SetTextColor(SuperTrackedFrame.DistanceText:GetTextColor())
		SuperTrackedFrame.DistanceTime:SetShadowOffset(SuperTrackedFrame.DistanceText:GetShadowOffset())
		if C_Navigation or WorldMapPin_GetDistance then
			FLOAT_SPELL_DURATION_SEC = ImproveAny:ReplaceStr(INT_SPELL_DURATION_SEC, "%d", "%0.0f")
			FLOAT_SPELL_DURATION_MIN = ImproveAny:ReplaceStr(INT_SPELL_DURATION_MIN, "%d", "%0.1f")
			local lastDist = 0
			local lastDistPerSec = 0
			local distPerSec = 0
			local timeToTarget = 0
			local scale = 10
			function ImproveAny:ThinkSuperTrackedFrame()
				local distance = 0
				if WorldMapPin_GetDistance then
					distance = WorldMapPin_GetDistance()
				end

				if C_Navigation and C_Navigation.GetDistance then
					distance = C_Navigation.GetDistance()
				end

				local distDif = lastDist - distance
				distPerSec = distDif * scale
				distPerSec = floor(distPerSec)
				if distPerSec ~= 0 then
					distPerSec = ImproveAny:Lerp(lastDistPerSec, distPerSec, 0.3)
					timeToTarget = distance / distPerSec
				else
					timeToTarget = 0
				end

				local secs = timeToTarget
				local clamped = false
				if C_Navigation then
					clamped = C_Navigation.WasClampedToScreen()
				end

				if clamped then
					SuperTrackedFrame.DistanceTime:SetText("")
				else
					if secs == 0 then
						SuperTrackedFrame.DistanceTime:SetText("∞")
					elseif secs > -60 and secs < 60 then
						SuperTrackedFrame.DistanceTime:SetText(format(FLOAT_SPELL_DURATION_SEC, secs))
					else
						SuperTrackedFrame.DistanceTime:SetText(format(FLOAT_SPELL_DURATION_MIN, secs / 60))
					end
				end

				lastDistPerSec = distPerSec
				lastDist = distance
				ImproveAny:Debug("supertrackedframe.lua: ThinkSuperTrackedFrame " .. distance, "think")
				C_Timer.After(0.1, ImproveAny.ThinkSuperTrackedFrame)
			end

			ImproveAny:ThinkSuperTrackedFrame()
		end
	end
end