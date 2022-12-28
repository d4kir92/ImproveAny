
local AddOnName, ImproveAny = ...

function ImproveAny:InitWorldMapFrame()
	if WorldMapFrame then		
		WorldMapFrame.ScrollContainer.GetCursorPosition = function( f )
			local x, y = MapCanvasScrollControllerMixin.GetCursorPosition( f )
			local s = WorldMapFrame:GetScale()
			return x / s, y / s
		end
	end
	
	if WorldMapFrame then
		if ImproveAny:GetWoWBuild() ~= "RETAIL" then -- TBC, ERA
			if WorldMapFrame.BlackoutFrame then
				hooksecurefunc( WorldMapFrame.BlackoutFrame, "Show", function( self )
					if self.iahide then return end
					self.iahide = true
					self:Hide()
					self.iahide = false
				end )
				WorldMapFrame.BlackoutFrame:Hide()
			end

			if WorldMapFrame.ScrollContainer.Child.TiledBackground then
				hooksecurefunc( WorldMapFrame.ScrollContainer.Child.TiledBackground, "Show", function( self )
					if self.iahide then return end
					self.iahide = true
					self:Hide()
					self.iahide = false
				end )
				WorldMapFrame.ScrollContainer.Child.TiledBackground:Hide()
			end

			WorldMapFrame.ScrollContainer:HookScript( "OnMouseWheel", function(self, delta)
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
			end )
		end
	end
end
