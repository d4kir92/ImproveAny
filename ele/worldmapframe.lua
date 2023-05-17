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

	local fontdist = 40

	if WorldMapFrame and WorldMapFrame.ScrollContainer and ImproveAny:IsEnabled("COORDSP", true) then
		local plyCoords = CreateFrame("FRAME", "plyCoords", WorldMapFrame.ScrollContainer.Child)
		plyCoords:SetSize(200, 60)
		plyCoords:SetPoint("TOPLEFT", WorldMapFrame.ScrollContainer.Child, "TOPLEFT", 0, 0)
		plyCoords:SetFrameLevel(9999)
		plyCoords:SetFrameStrata("FULLSCREEN_DIALOG")
		plyCoords.f = plyCoords:CreateFontString("plyCoords.f", "OVERLAY", "GameFontNormal")
		plyCoords.f:SetText("")
		plyCoords.f:SetFont(STANDARD_TEXT_FONT, fontsize, "THINOUTLINE")
		plyCoords.f:SetPoint("CENTER")

		function plyCoords:IAUpdate()
			if WorldMapFrame:IsShown() then
				local x, y = ImproveAny:GetBestPosXY("PLAYER")
				local w, h = WorldMapFrame.ScrollContainer.Child:GetSize()

				if x and y then
					local mf = w / 1200
					local zoom = 2 - WorldMapFrame:GetCanvasZoomPercent()
					plyCoords:ClearAllPoints()
					local px = x
					local py = y

					if x > 0.9 then
						px = 0.9
					elseif x < 0.1 then
						px = 0.1
					end

					if y > 0.8 then
						py = 0.8
					elseif y < 0 then
						py = 0
					end

					plyCoords:SetPoint("TOP", WorldMapFrame.ScrollContainer.Child, "TOPLEFT", w * px, -h * py - zoom * fontdist * mf)
					plyCoords.f:SetFont(STANDARD_TEXT_FONT, zoom * fontsize * mf, "THINOUTLINE")
					plyCoords.f:SetText(format("%0.1f, %0.1f", x * 100, y * 100))
					local fw = plyCoords.f:GetStringWidth()
					local fh = plyCoords.f:GetStringHeight()
					plyCoords:SetSize(fw, fh)
					C_Timer.After(0.05, plyCoords.IAUpdate)
				else
					plyCoords.f:SetText("")
					C_Timer.After(0.5, plyCoords.IAUpdate)
				end
			else
				C_Timer.After(0.5, plyCoords.IAUpdate)
			end
		end

		plyCoords:IAUpdate()
	end

	if WorldMapFrame and WorldMapFrame.ScrollContainer and ImproveAny:IsEnabled("COORDSC", true) then
		local curCoords = CreateFrame("FRAME", "curCoords", WorldMapFrame.ScrollContainer.Child)
		curCoords:SetSize(200, 60)
		curCoords:SetPoint("TOPLEFT", WorldMapFrame.ScrollContainer.Child, "TOPLEFT", 0, 0)
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
					local w, h = WorldMapFrame.ScrollContainer.Child:GetSize()

					if x and y then
						local mf = w / 1200
						local zoom = 2 - WorldMapFrame:GetCanvasZoomPercent()
						curCoords:ClearAllPoints()
						local px = x
						local py = y

						if x > 0.9 then
							px = 0.9
						elseif x < 0.1 then
							px = 0.1
						end

						if y > 0.8 then
							py = 0.8
						elseif y < 0 then
							py = 0
						end

						curCoords:SetPoint("TOP", WorldMapFrame.ScrollContainer.Child, "TOPLEFT", w * px, -h * py - zoom * fontdist * mf)
						curCoords.f:SetFont(STANDARD_TEXT_FONT, zoom * fontsize * mf, "THINOUTLINE")
						curCoords.f:SetText(format("%0.1f, %0.1f", x * 100, y * 100))
						local fw = curCoords.f:GetStringWidth()
						local fh = curCoords.f:GetStringHeight()
						curCoords:SetSize(fw, fh)
						C_Timer.After(0.01, curCoords.IAUpdate)
					else
						curCoords.f:SetText("")
						C_Timer.After(0.5, curCoords.IAUpdate)
					end
				else
					C_Timer.After(0.5, curCoords.IAUpdate)
				end
			else
				C_Timer.After(0.5, curCoords.IAUpdate)
			end
		end

		curCoords:IAUpdate()
	end
end