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
	fontsize = ImproveAny:GV("COORDSFONTSIZE", 8)
end

function ImproveAny:InitWorldMapFrame()
	fontsize = ImproveAny:GV("COORDSFONTSIZE", 8)

	if WorldMapFrame and ImproveAny:GetWoWBuild() ~= "RETAIL" then
		WorldMapFrame.ScrollContainer.GetCursorPosition = function(f)
			local x, y = MapCanvasScrollControllerMixin.GetCursorPosition(f)
			local scale = WorldMapFrame:GetScale()

			if not IsAddOnLoaded("Mapster") then
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
			hooksecurefunc(WorldMapFrame.BlackoutFrame, "Show", function(sel)
				if sel.iahide then return end
				sel.iahide = true
				sel:Hide()
				sel.iahide = false
			end)

			WorldMapFrame.BlackoutFrame:Hide()
		end

		if WorldMapFrame.ScrollContainer and WorldMapFrame.ScrollContainer.Child and WorldMapFrame.ScrollContainer.Child.TiledBackground then
			hooksecurefunc(WorldMapFrame.ScrollContainer.Child.TiledBackground, "Show", function(sel)
				if sel.iahide then return end
				sel.iahide = true
				sel:Hide()
				sel.iahide = false
			end)

			WorldMapFrame.ScrollContainer.Child.TiledBackground:Hide()
		end

		if WorldMapFrame.ScrollContainer then
			WorldMapFrame.ScrollContainer:HookScript("OnMouseWheel", function(sel, delta)
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
			end)
		end
	end

	local fontdist = 24

	if WorldMapFrame and WorldMapFrame.ScrollContainer and ImproveAny:IsEnabled("COORDSP", true) then
		WorldMapFrame.ScrollContainer.Child.plycoords = CreateFrame("FRAME", "plycoords", WorldMapFrame.ScrollContainer.Child)
		WorldMapFrame.ScrollContainer.Child.plycoords:SetSize(200, 60)
		WorldMapFrame.ScrollContainer.Child.plycoords:SetPoint("TOPLEFT", WorldMapFrame.ScrollContainer.Child, "TOPLEFT", 0, 0)
		WorldMapFrame.ScrollContainer.Child.plycoords:SetFrameLevel(9999)
		WorldMapFrame.ScrollContainer.Child.plycoords:SetFrameStrata("FULLSCREEN_DIALOG")
		WorldMapFrame.ScrollContainer.Child.plycoords.f = WorldMapFrame.ScrollContainer.Child.plycoords:CreateFontString("plycoords.f", "OVERLAY", "GameFontNormal")
		WorldMapFrame.ScrollContainer.Child.plycoords.f:SetText("TEST")
		WorldMapFrame.ScrollContainer.Child.plycoords.f:SetFont(STANDARD_TEXT_FONT, fontsize, "")
		WorldMapFrame.ScrollContainer.Child.plycoords.f:SetPoint("CENTER")

		WorldMapFrame.ScrollContainer.Child.plycoords:HookScript("OnUpdate", function()
			local x, y = ImproveAny:GetBestPosXY("PLAYER")
			local w, h = WorldMapFrame.ScrollContainer.Child:GetSize()

			if x and y then
				local mf = w / 1200
				local zoom = 2 - WorldMapFrame:GetCanvasZoomPercent()
				WorldMapFrame.ScrollContainer.Child.plycoords:ClearAllPoints()
				local xOffset = 0

				if x > 0.97 then
					xOffset = -40
				elseif x < 0.03 then
					xOffset = 40
				end

				if y < 0.9 then
					WorldMapFrame.ScrollContainer.Child.plycoords:SetPoint("TOP", WorldMapFrame.ScrollContainer.Child, "TOPLEFT", w * x + xOffset, -h * y - zoom * fontdist * mf)
				else
					WorldMapFrame.ScrollContainer.Child.plycoords:SetPoint("TOP", WorldMapFrame.ScrollContainer.Child, "TOPLEFT", w * x + xOffset, -h * y + zoom * fontdist * mf)
				end

				WorldMapFrame.ScrollContainer.Child.plycoords.f:SetFont(STANDARD_TEXT_FONT, zoom * fontsize * mf, "")
				WorldMapFrame.ScrollContainer.Child.plycoords.f:SetText(format("%0.1f, %0.1f", x * 100, y * 100))
				local fw = WorldMapFrame.ScrollContainer.Child.plycoords.f:GetStringWidth()
				local fh = WorldMapFrame.ScrollContainer.Child.plycoords.f:GetStringHeight()
				WorldMapFrame.ScrollContainer.Child.plycoords:SetSize(fw, fh)
			else
				WorldMapFrame.ScrollContainer.Child.plycoords.f:SetText("")
			end
		end)
	end

	if WorldMapFrame and WorldMapFrame.ScrollContainer and ImproveAny:IsEnabled("COORDSC", true) then
		WorldMapFrame.ScrollContainer.Child.curcoords = CreateFrame("FRAME", "curcoords", WorldMapFrame.ScrollContainer.Child)
		WorldMapFrame.ScrollContainer.Child.curcoords:SetSize(200, 60)
		WorldMapFrame.ScrollContainer.Child.curcoords:SetParent(WorldMapFrame.ScrollContainer.Child)
		WorldMapFrame.ScrollContainer.Child.curcoords:SetPoint("TOPLEFT", WorldMapFrame.ScrollContainer.Child, "TOPLEFT", 0, 0)
		WorldMapFrame.ScrollContainer.Child.curcoords:SetFrameLevel(9999)
		WorldMapFrame.ScrollContainer.Child.curcoords:SetFrameStrata("FULLSCREEN_DIALOG")
		WorldMapFrame.ScrollContainer.Child.curcoords.f = WorldMapFrame.ScrollContainer.Child.curcoords:CreateFontString("curcoords.f", "OVERLAY", "GameFontNormal")
		WorldMapFrame.ScrollContainer.Child.curcoords.f:SetText("TEST")
		WorldMapFrame.ScrollContainer.Child.curcoords.f:SetFont(STANDARD_TEXT_FONT, fontsize, "")
		WorldMapFrame.ScrollContainer.Child.curcoords.f:SetPoint("CENTER")

		WorldMapFrame.ScrollContainer.Child.curcoords:HookScript("OnUpdate", function(sel)
			if WorldMapFrame.ScrollContainer.Child and WorldMapFrame.ScrollContainer.GetNormalizedCursorPosition then
				local x, y = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
				local w, h = WorldMapFrame.ScrollContainer.Child:GetSize()

				if x and y then
					local mf = w / 1200
					local zoom = 2 - WorldMapFrame:GetCanvasZoomPercent()
					WorldMapFrame.ScrollContainer.Child.curcoords:ClearAllPoints()
					local xOffset = 0

					if x > 0.97 then
						xOffset = -40
					elseif x < 0.03 then
						xOffset = 40
					end

					if y < 0.9 then
						WorldMapFrame.ScrollContainer.Child.curcoords:SetPoint("TOP", WorldMapFrame.ScrollContainer.Child, "TOPLEFT", w * x + xOffset, -h * y - zoom * fontdist * mf)
					else
						WorldMapFrame.ScrollContainer.Child.curcoords:SetPoint("TOP", WorldMapFrame.ScrollContainer.Child, "TOPLEFT", w * x + xOffset, -h * y + zoom * fontdist * mf)
					end

					WorldMapFrame.ScrollContainer.Child.curcoords.f:SetFont(STANDARD_TEXT_FONT, zoom * fontsize * mf, "")
					WorldMapFrame.ScrollContainer.Child.curcoords.f:SetText(format("%0.1f, %0.1f", x * 100, y * 100))
					local fw = WorldMapFrame.ScrollContainer.Child.curcoords.f:GetStringWidth()
					local fh = WorldMapFrame.ScrollContainer.Child.curcoords.f:GetStringHeight()
					WorldMapFrame.ScrollContainer.Child.curcoords:SetSize(fw, fh)
				end
			end
		end)
	end
end