
local AddOnName, ImproveAny = ...

local mmdelay = 0.1
local minimapshape = "ROUND"

function ImproveAny:InitMinimap()
	function GetMinimapShape()
		return minimapshape
	end

	local function SHAPE(msg)
		msg = msg:upper()
		if msg == "SQUARE" then
			minimapshape = msg
			Minimap:SetMaskTexture([[Interface\AddOns\ImproveAny\media\minimap_mask_square]])
			
		elseif msg == "ROUND" then
			minimapshape = msg
			Minimap:SetMaskTexture([[Interface\AddOns\ImproveAny\media\minimap_mask_round]])
		end
	end
	SHAPE("SQUARE")

	if MinimapBorder then
		MinimapBorder:Hide()
	end
	if MinimapBorderTop then
		MinimapBorderTop:Hide()
	end
	if MinimapZoomIn then
		MinimapZoomIn:Hide()
	end
	if MinimapZoomOut then
		MinimapZoomOut:Hide()
	end

	function IAOnMouseWheel( self, dir )
		if ( dir > 0 ) then
			if MinimapZoomIn then
				MinimapZoomIn:Click()
			else
				Minimap.ZoomIn:Click()
			end
		else
			if MinimapZoomOut then
				MinimapZoomOut:Click()
			else
				Minimap.ZoomOut:Click()
			end
		end
	end
	Minimap:SetScript( "OnMouseWheel", IAOnMouseWheel )

	C_Timer.After( 0.3, function()
		if MinimapBorder then
			MinimapBorder:SetParent( IAHIDDEN )
		end

		if Minimap.Border then
			Minimap.Border:SetParent( IAHIDDEN )
		end

		local IAMMBtnsBliz = {}
		function IAConvertToMinimapButton( name, hide )
			local btn = _G[name]
			if btn then
				if hide then
					tinsert( IAMMBtnsBliz, btn )
				end
		
				btn:SetMovable( true )
				btn:SetUserPlaced( false )

				local radius = 76
				IATAB[name .. "ofsx"] = IATAB[name .. "ofsx"] or radius
				IATAB[name .. "ofsy"] = IATAB[name .. "ofsy"] or radius
				function btn:UpdatePos()
					if btn.maiinit == nil then
						btn.maiinit = true
						hooksecurefunc( btn, "SetPoint", function()
							if self.maipoint then return end
							self.maipoint = true
		
							btn:ClearAllPoints()
							btn:SetPoint( "CENTER", Minimap, "CENTER",  IATAB[name .. "ofsx"],  IATAB[name .. "ofsy"] )
							
							self.maipoint = false
						end )
						btn:ClearAllPoints()
						btn:SetPoint( "CENTER", Minimap, "CENTER", IATAB[name .. "ofsx"],  IATAB[name .. "ofsy"] )
					end
		
					if btn.moving then
						if GetMinimapShape() == "ROUND" then
							local Xpoa, Ypoa = GetCursorPosition()
							local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
							Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + 70
							Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - 70
							myIconPos = math.deg(math.atan2(Ypoa, Xpoa))
		
							local ofsx = (-80 * cos(myIconPos))
							local ofsy = (80 * sin(myIconPos))
		
							IATAB[name .. "ofsx"] = ofsx
							IATAB[name .. "ofsy"] = ofsy
		
							btn:ClearAllPoints()
							btn:SetPoint( "CENTER", Minimap, "CENTER", ofsx, ofsy )
						else
							local Xpoa, Ypoa = GetCursorPosition()
							local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
							Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + 70
							Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - 70
		
							if Ypoa >= radius or Ypoa <= -radius then
								Xpoa = IAMathC( Xpoa, -radius, radius )
							else
								if Xpoa > 0 then
									Xpoa = radius
								else
									Xpoa = -radius
								end
							end
							if Xpoa >= radius or Xpoa <= -radius then
								Ypoa = IAMathC( Ypoa, -radius, radius )
							else
								if Ypoa > 0 then
									Ypoa = radius
								else
									Ypoa = -radius
								end
							end
							
							local ofsx = -Xpoa
							local ofsy = Ypoa
		
							IATAB[name .. "ofsx"] = ofsx
							IATAB[name .. "ofsy"] = ofsy

							btn:ClearAllPoints()
							btn:SetPoint( "CENTER", Minimap, "CENTER", ofsx, ofsy )
						end

						C_Timer.After( 0.004, btn.UpdatePos )
					else
						C_Timer.After( 0.3, btn.UpdatePos )
					end
				end
				btn:UpdatePos()
		
				btn:RegisterForDrag("LeftButton")
				btn:SetScript( "OnDragStart", function()
					btn:StartMoving()
					btn.moving = true
				end )
		
				btn:SetScript( "OnDragStop", function()
					btn:StopMovingOrSizing();
					btn.moving = false
				end )
			end
		end

		if MinimapToggleButton then
			MinimapToggleButton:Hide()
		end

		if select(4, GetBuildInfo()) < 100000 then
			if TimeManagerClockButton then
				local clocktexture = select( 1, TimeManagerClockButton:GetRegions() )
				if clocktexture and clocktexture.SetTexture then
					clocktexture:SetTexture( nil )
				end

				TimeManagerClockButton:ClearAllPoints()
				TimeManagerClockButton:SetPoint( "BOTTOM", Minimap, "BOTTOM", 0, -4 )
			end
		end

		if MiniMapWorldMapButton then
			if MiniMapWorldMapButton:GetNormalTexture():GetTexture() == 452113 then -- "Interface\\minimap\\UI-Minimap-WorldMapSquare"
				MiniMapWorldMapButton:SetNormalTexture( "Interface\\AddOns\\ImproveAny\\media\\UI-Minimap-WorldMapSquare" )
				MiniMapWorldMapButton:SetPushedTexture( "Interface\\AddOns\\ImproveAny\\media\\UI-Minimap-WorldMapSquare" )
			end
		end



		if MinimapZoneTextButton then
			MinimapZoneTextButton:ClearAllPoints()
			MinimapZoneTextButton:SetPoint( "BOTTOM", Minimap, "TOP", 0, 6 )
		end

		-- Blizzard Minimap Buttons Dragging
		-- ALL
		IAConvertToMinimapButton( "MiniMapWorldMapButton", true ) -- WorldMap
		IAConvertToMinimapButton( "MiniMapMailFrame" ) -- Mail

		-- Retail
		IAConvertToMinimapButton( "MiniMapTrackingButton" ) -- Tracking
		if GameTimeFrame then
			GameTimeFrame:SetFrameLevel( 10 )
		end
		if select(4, GetBuildInfo()) < 100000 then
			IAConvertToMinimapButton( "GameTimeFrame", true ) -- Calendar
		end
		IAConvertToMinimapButton( "GarrisonLandingPageMinimapButton" ) -- Sanctum
		IAConvertToMinimapButton( "QueueStatusMinimapButton" ) -- LFG
		if MiniMapInstanceDifficulty then
			MiniMapInstanceDifficulty:SetParent( Minimap )
		end
		--IAConvertToMinimapButton( "MiniMapInstanceDifficulty" ) -- RAIDSize, not moveable somehow

		if IABUILD ~= "RETAIL" and MiniMapTracking then -- breaks retail if not checked
			IAConvertToMinimapButton( "MiniMapTracking" ) -- Tracking
		end

		-- Classic ERA
		IAConvertToMinimapButton( "MiniMapTrackingFrame" ) -- Tracking
		IAConvertToMinimapButton( "MiniMapLFGFrame" ) -- LFG
		-- Blizzard Minimap Buttons Dragging

		IAConvertToMinimapButton( "MiniMapBattlefieldFrame" ) -- PVP

		-- ADDONS
		local mmbtns = {}
		function IAUpdateMMBtns()
			for i, child in pairs({Minimap:GetChildren()}) do
				if not tContains( mmbtns, child ) and child:GetName() and strfind(child:GetName(), "LibDBIcon") then
					tinsert( mmbtns, child )
					IAConvertToMinimapButton( child:GetName() )
				end
			end

			mmdelay = mmdelay + 0.1
			
			if mmdelay <= 1.0 then
				C_Timer.After( mmdelay, IAUpdateMMBtns )
			end
		end
		IAUpdateMMBtns()
	end )
end
