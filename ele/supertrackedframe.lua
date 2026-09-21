local _, ImproveAny = ...
function ImproveAny:InitSuperTrackedFrame()
	local stf = SuperTrackedFrame
	if stf == nil then stf = WorldSpacePin end
	if stf then
		local function ShouldForceAlpha()
			if not C_Navigation or not C_Navigation.GetDistance then return false end
			local distance = C_Navigation.GetDistance()
			if ImproveAny:IsCamelot() then return stf.navFrame ~= nil and distance > 0 end

			return distance >= 1000
		end

		if stf.GetTargetAlphaBaseValue then
			local fAlpha = stf.GetTargetAlphaBaseValue
			function stf:GetTargetAlphaBaseValue()
				local alpha = fAlpha(self)
				if alpha == 0 and ShouldForceAlpha() then
					return 0.5
				else
					return alpha
				end
			end
		end

		if stf.GetTargetAlpha then
			local fAlpha = stf.GetTargetAlpha
			function stf:GetTargetAlpha()
				local alpha = fAlpha(self)
				if alpha == 0 and ShouldForceAlpha() then
					return 0.5
				else
					return alpha
				end
			end
		end

		if stf.DistanceText == nil then stf.DistanceText = WorldSpacePin.text end
		stf.DistanceTime = stf:CreateFontString(nil, "ARTWORK")
		if C_Navigation then
			stf.DistanceTime:SetFont(STANDARD_TEXT_FONT, 12, "")
			stf.DistanceTime:SetPoint("TOP", stf, "BOTTOM", 0, 2)
		else
			stf.DistanceTime:SetFont(STANDARD_TEXT_FONT, 10, "")
			stf.DistanceTime:SetPoint("TOP", stf, "BOTTOM", 0, -12)
		end

		stf.DistanceTime:SetText("LOADING (IA)")
		stf.DistanceTime:SetTextColor(stf.DistanceText:GetTextColor())
		stf.DistanceTime:SetShadowOffset(stf.DistanceText:GetShadowOffset())
		if C_Navigation or WorldMapPin_GetDistance then
			local sec = ImproveAny:ReplaceStr(INT_SPELL_DURATION_SEC, "%d", "%0.0f")
			local min = ImproveAny:ReplaceStr(INT_SPELL_DURATION_MIN, "%d", "%0.1f")
			local lastDist = 0
			local lastDistPerSec = 0
			local distPerSec = 0
			local timeToTarget = 0
			local scale = 10
			function ImproveAny:ThinkSTF()
				local distance = 0
				if WorldMapPin_GetDistance then distance = WorldMapPin_GetDistance() end
				if C_Navigation and C_Navigation.GetDistance then distance = C_Navigation.GetDistance() end
				local distDif = lastDist - distance
				distPerSec = distDif * scale
				distPerSec = floor(distPerSec)
				if distPerSec ~= 0 then
					distPerSec = ImproveAny:Lerp(lastDistPerSec, distPerSec, 0.3)
					timeToTarget = distance / distPerSec * 5
				else
					timeToTarget = 0
				end

				local secs = timeToTarget
				local clamped = false
				if C_Navigation then clamped = C_Navigation.WasClampedToScreen() end
				if clamped then
					stf.DistanceTime:SetText("")
				else
					if secs == 0 then
						stf.DistanceTime:SetText("∞")
					elseif secs > -60 and secs < 60 then
						stf.DistanceTime:SetText(format(sec, secs))
					else
						stf.DistanceTime:SetText(format(min, secs / 60))
					end
				end

				lastDistPerSec = distPerSec
				lastDist = distance
				ImproveAny:Debug("supertrackedframe.lua: ThinkSTF " .. distance, "think")
				ImproveAny:After(0.5, ImproveAny.ThinkSTF, "ThinkSTF")
			end

			ImproveAny:ThinkSTF()
		end
	end
end
