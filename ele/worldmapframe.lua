local _, ImproveAny = ...
function ImproveAny:GetBestPosXY(unit)
	local ok, nx, ny = xpcall(
		function()
			local mapID = nil
			if C_Map then
				mapID = C_Map.GetBestMapForUnit(unit)
			end

			if mapID == nil and WorldMapFrame.mapID then
				mapID = WorldMapFrame.mapID
			end

			if mapID and unit then
				local mapPos = C_Map.GetPlayerMapPosition(mapID, unit)
				if mapPos then return mapPos.x, mapPos.y end
			end

			return nil, nil
		end, function(err) end
	)

	if not ok then return nil, nil end

	return nx, ny
end

function ImproveAny:InitWorldMapFrame()
	if WorldMapFrame and ImproveAny:GetWoWBuild() ~= "RETAIL" then
		WorldMapFrame.ScrollContainer.GetCursorPosition = function(fr)
			local x, y = MapCanvasScrollControllerMixin.GetCursorPosition(fr)
			local scale = WorldMapFrame:GetScale()
			if not ImproveAny:IsAddOnLoaded("Mapster") and not ImproveAny:IsAddOnLoaded("GW2_UI") then
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

		if ImproveAny:GetWoWBuild() ~= "RETAIL" and WorldMapFrame.ScrollContainer and ImproveAny:IsEnabled("WORLDMAPZOOM", false) then
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

end
