
local AddOnName, ImproveAny = ...

function ImproveAny:InitWorldMapFrame()
	if WorldMapFrame then

		if WorldMapFrame.ScrollContainer.Child.TiledBackground then
			print("HIDE ScrollContainer")
			WorldMapFrame.ScrollContainer.Child.TiledBackground:Hide()
		end
		if WorldMapFrame.BlackoutFrame then
			print("HIDE BLACK")
			hooksecurefunc( WorldMapFrame.BlackoutFrame, "Show", function( self )
				if self.iahide then return end
				self.iahide = true
				self:Hide()
				self.iahide = false
			end )
			WorldMapFrame.BlackoutFrame:Hide()
		end
		
		if WorldMapFrame.ScrollContainer.GetCursorPosition == nil then
			WorldMapFrame.ScrollContainer.GetCursorPosition = function(f)
				local x,y = MapCanvasScrollControllerMixin.GetCursorPosition(f)
				local s = WorldMapFrame:GetScale()
				return x/s, y/s
			end
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
