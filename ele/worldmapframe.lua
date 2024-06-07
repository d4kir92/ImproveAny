local _, ImproveAny = ...
function ImproveAny:GetBestPosXY(unit)
	local mapID = nil
	if WorldMapFrame.mapID then
		mapID = WorldMapFrame.mapID
	elseif C_Map then
		mapID = C_Map.GetBestMapForUnit(unit)
	end

	if mapID and unit then
		local mapPos = C_Map.GetPlayerMapPosition(mapID, unit)
		if mapPos then return mapPos:GetXY() end
	end

	return nil, nil
end

local fontsize = 8
function ImproveAny:UpdateCoordsFontSize()
	fontsize = ImproveAny:GV("COORDSFONTSIZE", 10)
end

function ImproveAny:InitWorldMapFrame()
	fontsize = ImproveAny:GV("COORDSFONTSIZE", 10)
	if WorldMapFrame and D4:GetWoWBuild() ~= "RETAIL" then
		WorldMapFrame.ScrollContainer.GetCursorPosition = function(fr)
			local x, y = MapCanvasScrollControllerMixin.GetCursorPosition(fr)
			local scale = WorldMapFrame:GetScale()
			if not D4:IsAddOnLoaded("Mapster") and not D4:IsAddOnLoaded("GW2_UI") then
				return x / scale, y / scale
			else
				local reverseEffectiveScale = 1 / UIParent:GetEffectiveScale()

				return x / scale * reverseEffectiveScale, y / scale * reverseEffectiveScale
			end
		end
	end

	if WorldMapFrame then
		-- TBC, ERA
		if WorldMapFrame.BlackoutFrame then
			hooksecurefunc(
				WorldMapFrame.BlackoutFrame,
				"Show",
				function(sel)
					if sel.iahide then return end
					sel.iahide = true
					sel:Hide()
					sel.iahide = false
				end
			)

			WorldMapFrame.BlackoutFrame:Hide()
		end

		if WorldMapFrame.ScrollContainer and WorldMapFrame.ScrollContainer.Child and WorldMapFrame.ScrollContainer.Child.TiledBackground then
			hooksecurefunc(
				WorldMapFrame.ScrollContainer.Child.TiledBackground,
				"Show",
				function(sel)
					if sel.iahide then return end
					sel.iahide = true
					sel:Hide()
					sel.iahide = false
				end
			)

			WorldMapFrame.ScrollContainer.Child.TiledBackground:Hide()
		end

		if WorldMapFrame.ScrollContainer then
			WorldMapFrame.ScrollContainer:HookScript(
				"OnMouseWheel",
				function(sel, delta)
					local x, y = sel:GetNormalizedCursorPosition()
					local nextZoomOutScale, nextZoomInScale = sel:GetCurrentZoomRange()
					if delta == 1 then
						if nextZoomInScale > sel:GetCanvasScale() then
							sel:InstantPanAndZoom(nextZoomInScale, x, y)
						end
					else
						if nextZoomOutScale < sel:GetCanvasScale() then
							sel:InstantPanAndZoom(nextZoomOutScale, x, y)
						end
					end
				end
			)
		end
	end

	function ImproveAny:GetNormalizedPosition(frame, x, y)
		local frameLeft = frame:GetLeft()
		local frameTop = frame:GetTop()
		local frameWidth = frame:GetWidth()
		local frameHeight = frame:GetHeight()
		local scale = frame:GetEffectiveScale()
		local normalizedX = (x / scale - frameLeft) / frameWidth
		local normalizedY = (frameTop - y / scale) / frameHeight

		return normalizedX, normalizedY
	end

	if WorldMapFrame and WorldMapFrame.ScrollContainer and ImproveAny:IsEnabled("COORDSP", false) then
		local plyCoords = CreateFrame("FRAME", "plyCoords", WorldMapFrame.ScrollContainer)
		plyCoords:SetSize(200, 60)
		plyCoords:SetPoint("CENTER", WorldMapFrame.ScrollContainer, "TOPLEFT", 0, 0)
		plyCoords:SetFrameLevel(9999)
		plyCoords:SetFrameStrata("FULLSCREEN_DIALOG")
		plyCoords.f = plyCoords:CreateFontString("plyCoords.f", "OVERLAY", "GameFontNormal")
		plyCoords.f:SetText("")
		plyCoords.f:SetFont(STANDARD_TEXT_FONT, fontsize, "THINOUTLINE")
		plyCoords.f:SetPoint("CENTER")
		--[[plyCoords.t = plyCoords:CreateTexture("plyCoords.t", "ARTWORK")
		plyCoords.t:SetAllPoints(plyCoords)
		plyCoords.t:SetColorTexture(0.03, 0.03, 0.03, 0.5)]]
		function plyCoords:IAUpdate()
			if WorldMapFrame.ScrollContainer.GetNormalizedCursorPosition then
				if WorldMapFrame:IsShown() then
					local x, y = ImproveAny:GetBestPosXY("PLAYER")
					local w, h = WorldMapFrame.ScrollContainer:GetSize()
					if x and y then
						local scale = WorldMapFrame.ScrollContainer.Child:GetScale()
						if D4:GetWoWBuild() == "RETAIL" then
							scale = 1 + WorldMapFrame:GetCanvasZoomPercent()
						end

						local left = WorldMapFrame.ScrollContainer:GetLeft() - WorldMapFrame.ScrollContainer.Child:GetLeft() * WorldMapFrame.ScrollContainer.Child:GetScale()
						local mx = x * scale - left / WorldMapFrame.ScrollContainer:GetWidth()
						local top = WorldMapFrame.ScrollContainer:GetTop() - WorldMapFrame.ScrollContainer.Child:GetTop() * WorldMapFrame.ScrollContainer.Child:GetScale()
						local my = y * scale + top / WorldMapFrame.ScrollContainer:GetHeight()
						local bx, by = mx, my
						plyCoords:ClearAllPoints()
						local offsetY = 0.1
						local px = bx
						local py = by + offsetY
						if bx > 0.9 then
							px = 0.9
						elseif bx < 0.1 then
							px = 0.1
						end

						if py > 0.9 then
							py = 0.9
						elseif py < 0.1 then
							py = 0.1
						end

						plyCoords:SetPoint("CENTER", WorldMapFrame.ScrollContainer, "TOPLEFT", w * px, -h * py)
						plyCoords.f:SetFont(STANDARD_TEXT_FONT, fontsize, "THINOUTLINE")
						plyCoords.f:SetText(format("%0.1f, %0.1f", x * 100, y * 100))
						local fw = plyCoords.f:GetStringWidth()
						local fh = plyCoords.f:GetStringHeight()
						plyCoords:SetSize(fw, fh)
						ImproveAny:Debug("worldmapframe.lua: IAUpdate #1")
						C_Timer.After(0.01, plyCoords.IAUpdate)
					else
						plyCoords.f:SetText("")
						ImproveAny:Debug("worldmapframe.lua: IAUpdate #2")
						C_Timer.After(0.5, plyCoords.IAUpdate)
					end
				else
					ImproveAny:Debug("worldmapframe.lua: IAUpdate #3", "retry")
					C_Timer.After(1, plyCoords.IAUpdate)
				end
			else
				ImproveAny:Debug("worldmapframe.lua: IAUpdate #4", "retry")
				C_Timer.After(1, plyCoords.IAUpdate)
			end
		end

		plyCoords:IAUpdate()
	end

	if WorldMapFrame and WorldMapFrame.ScrollContainer and ImproveAny:IsEnabled("COORDSC", false) then
		local curCoords = CreateFrame("FRAME", "curCoords", WorldMapFrame.ScrollContainer)
		curCoords:SetSize(200, 60)
		curCoords:SetPoint("CENTER", WorldMapFrame.ScrollContainer, "TOPLEFT", 0, 0)
		curCoords:SetFrameLevel(9999)
		curCoords:SetFrameStrata("FULLSCREEN_DIALOG")
		curCoords.f = curCoords:CreateFontString("curCoords.f", "OVERLAY", "GameFontNormal")
		curCoords.f:SetText("")
		curCoords.f:SetFont(STANDARD_TEXT_FONT, fontsize, "THINOUTLINE")
		curCoords.f:SetPoint("CENTER")
		function curCoords:IAUpdate()
			if WorldMapFrame.ScrollContainer.GetNormalizedCursorPosition then
				if WorldMapFrame:IsShown() then
					local x, y = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
					local w, h = WorldMapFrame.ScrollContainer:GetSize()
					if x and y then
						local bx, by = ImproveAny:GetNormalizedPosition(WorldMapFrame.ScrollContainer, GetCursorPosition())
						curCoords:ClearAllPoints()
						local offsetY = 0.1
						local px = bx
						local py = by + offsetY
						if bx > 0.9 then
							px = 0.9
						elseif bx < 0.1 then
							px = 0.1
						end

						if py > 0.9 then
							py = 0.9
						elseif py < 0.1 then
							py = 0.1
						end

						curCoords:SetPoint("CENTER", WorldMapFrame.ScrollContainer, "TOPLEFT", w * px, -h * py)
						curCoords.f:SetFont(STANDARD_TEXT_FONT, fontsize, "THINOUTLINE")
						curCoords.f:SetText(format("%0.1f, %0.1f", x * 100, y * 100))
						local fw = curCoords.f:GetStringWidth()
						local fh = curCoords.f:GetStringHeight()
						curCoords:SetSize(fw, fh)
						ImproveAny:Debug("worldmapframe.lua: IAUpdate #5")
						C_Timer.After(0.01, curCoords.IAUpdate)
					else
						curCoords.f:SetText("")
						ImproveAny:Debug("worldmapframe.lua: IAUpdate #6")
						C_Timer.After(0.5, curCoords.IAUpdate)
					end
				else
					ImproveAny:Debug("worldmapframe.lua: IAUpdate #7", "retry")
					C_Timer.After(1, curCoords.IAUpdate)
				end
			else
				ImproveAny:Debug("worldmapframe.lua: IAUpdate #8", "retry")
				C_Timer.After(1, curCoords.IAUpdate)
			end
		end

		curCoords:IAUpdate()
	end
end
