
local AddOnName, ImproveAny = ...

function ImproveAny:InitWorldMapFrame()
	if WorldMapFrame and ImproveAny:GetWoWBuild() ~= "RETAIL" then	
		WorldMapFrame.ScrollContainer.GetCursorPosition = function( f )
			local x, y = MapCanvasScrollControllerMixin.GetCursorPosition( f )
			local scale = WorldMapFrame:GetScale()
			if not IsAddOnLoaded( "Mapster" ) then
				return x / scale, y / scale
			else
				local reverseEffectiveScale = 1 / UIParent:GetEffectiveScale();
				return x / scale * reverseEffectiveScale, y / scale * reverseEffectiveScale
			end
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
