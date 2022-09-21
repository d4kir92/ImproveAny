
local AddOnName, ImproveAny = ...

function ImproveAny:InitWorldMapFrame()
	if WorldMapFrame then
		if WorldMapFrame.ScrollContainer.Child.TiledBackground then
			WorldMapFrame.ScrollContainer.Child.TiledBackground:Hide()
		end
		if WorldMapFrame.BlackoutFrame then
			WorldMapFrame.BlackoutFrame.Show = WorldMapFrame.BlackoutFrame.Hide
			WorldMapFrame.BlackoutFrame:Hide()
		end

		WorldMapFrame.ScrollContainer.GetCursorPosition = function(f)
			local x,y = MapCanvasScrollControllerMixin.GetCursorPosition(f)
			local s = WorldMapFrame:GetScale()
			return x/s, y/s
		end

		if MABUILD ~= "RETAIL" then -- TBC, ERA
			WorldMapFrame.ScrollContainer:HookScript("OnMouseWheel", function(self, delta)
				local x, y = self:GetNormalizedCursorPosition()
				local nextZoomOutScale, nextZoomInScale = self:GetCurrentZoomRange()
				if delta == 1 then
					if nextZoomInScale > self:GetCanvasScale() then
						self:InstantPanAndZoom( nextZoomInScale, x, y )
					end
				else
					if nextZoomOutScale < self:GetCanvasScale() then
						self:InstantPanAndZoom( nextZoomOutScale, x, y )
					end
				end
			end)
		end
	end
end
