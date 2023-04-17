local _, ImproveAny = ...
local mmdelay = 0.1
local minimapshape = "ROUND"

function ImproveAny:UpdateMinimapSettings()
	if ImproveAny:IsEnabled("MINIMAP", true) and ImproveAny:IsEnabled("MINIMAPSHAPESQUARE", true) then
		IASHAPE("SQUARE")
	else
		IASHAPE("ROUND")
	end

	if ImproveAny:IsEnabled("MINIMAP", true) and ImproveAny:IsEnabled("MINIMAPHIDEBORDER", true) then
		if MinimapBorder then
			MinimapBorder:Hide()
		end

		if MinimapBorderTop then
			MinimapBorderTop:Hide()
		end

		if MinimapCompassTexture then
			MinimapCompassTexture:Hide()
		end
	else
		if MinimapBorder then
			MinimapBorder:Show()
		end

		if MinimapBorderTop then
			MinimapBorderTop:Show()
		end

		if MinimapCompassTexture then
			MinimapCompassTexture:Show()
		end
	end

	if ImproveAny:IsEnabled("MINIMAP", true) and ImproveAny:IsEnabled("MINIMAPHIDEZOOMBUTTONS", true) then
		if MinimapZoomIn then
			MinimapZoomIn:Hide()
		end

		if MinimapZoomOut then
			MinimapZoomOut:Hide()
		end
	else
		if MinimapZoomIn then
			MinimapZoomIn:Show()
		end

		if MinimapZoomOut then
			MinimapZoomOut:Show()
		end
	end

	if ImproveAny:IsEnabled("MINIMAP", true) and ImproveAny:IsEnabled("MINIMAPSCROLLZOOM", true) then
		function IAOnMouseWheel(sel, dir)
			if dir > 0 then
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

		Minimap:SetScript("OnMouseWheel", IAOnMouseWheel)
	else
		Minimap:SetScript("OnMouseWheel", function() end) --
	end

	C_Timer.After(0.1, function()
		if ImproveAny:IsEnabled("MINIMAP", true) and ImproveAny:IsEnabled("MINIMAPHIDEBORDER", true) then
			if MinimapBorder then
				MinimapBorder:SetParent(IAHIDDEN)
			end

			if MinimapCompassTexture then
				MinimapCompassTexture:SetParent(IAHIDDEN)
			end

			if MiniMapWorldMapButton and MiniMapWorldMapButton:GetNormalTexture():GetTexture() == 452113 then
				MiniMapWorldMapButton:SetNormalTexture("Interface\\AddOns\\ImproveAny\\media\\UI-Minimap-WorldMapSquare")
				MiniMapWorldMapButton:SetPushedTexture("Interface\\AddOns\\ImproveAny\\media\\UI-Minimap-WorldMapSquare")
			end
		else
			if GetMinimapShape() == "ROUND" then
				if MinimapBorder then
					MinimapBorder:SetParent(Minimap)
				end

				if MinimapCompassTexture then
					MinimapCompassTexture:SetParent(Minimap)
				end
			else
				if MinimapBorder then
					MinimapBorder:SetParent(IAHIDDEN)
				end

				if MinimapCompassTexture then
					MinimapCompassTexture:SetParent(IAHIDDEN)
				end
			end
		end
	end)
end

function ImproveAny:InitMinimap()
	function GetMinimapShape()
		return minimapshape
	end

	function IASHAPE(msg)
		msg = msg:upper()

		if minimapshape ~= msg then
			if msg == "SQUARE" then
				minimapshape = msg
				Minimap:SetMaskTexture("Interface\\AddOns\\ImproveAny\\media\\minimap_mask_square")
			elseif msg == "ROUND" then
				minimapshape = msg
				Minimap:SetMaskTexture("Interface\\AddOns\\ImproveAny\\media\\minimap_mask_round")
			end
		end
	end

	ImproveAny:UpdateMinimapSettings()

	if ImproveAny:IsEnabled("MINIMAP", true) then
		if ElvUI then return end

		C_Timer.After(0.3, function()
			local IAMMBtnsBliz = {}

			function ImproveAny:ConvertToMinimapButton(name, hide)
				if not ImproveAny:IsEnabled("MINIMAPMINIMAPBUTTONSMOVABLE", true) then return end
				local btn = _G[name]

				if btn then
					if hide then
						tinsert(IAMMBtnsBliz, btn)
					end

					btn:SetParent(Minimap)
					btn:SetMovable(true)
					btn:SetUserPlaced(false)
					local radius = 80

					if ImproveAny:GetWoWBuild() == "RETAIL" then
						radius = 110
					end

					local pos = random(0, 360)
					local ofsx = -radius * cos(pos)
					local ofsy = radius * sin(pos)
					IATAB[name .. "ofsx"] = IATAB[name .. "ofsx"] or ofsx
					IATAB[name .. "ofsy"] = IATAB[name .. "ofsy"] or ofsy

					function btn:UpdatePos()
						if btn.maiinit == nil then
							btn.maiinit = true

							hooksecurefunc(btn, "SetPoint", function(sel)
								if sel.ia_setpoint_mmbtn then return end
								sel.ia_setpoint_mmbtn = true
								sel:SetParent(Minimap)
								sel:SetMovable(true)
								sel:SetUserPlaced(false)
								sel:ClearAllPoints()
								sel:SetPoint("CENTER", Minimap, "CENTER", IATAB[name .. "ofsx"], IATAB[name .. "ofsy"])
								sel.ia_setpoint_mmbtn = false
							end)

							btn:ClearAllPoints()
							btn:SetPoint("CENTER", Minimap, "CENTER", IATAB[name .. "ofsx"], IATAB[name .. "ofsy"])
						end

						if btn.moving then
							local scale = Minimap:GetScale()

							if GetMinimapShape() == "ROUND" then
								local Xpoa, Ypoa = GetCursorPosition()
								local Xmin, Ymin = Minimap:GetLeft() * scale, Minimap:GetBottom() * scale
								Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + radius
								Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - radius
								myIconPos = math.deg(math.atan2(Ypoa, Xpoa))
								local ofsx1 = -radius * cos(myIconPos)
								local ofsy1 = radius * sin(myIconPos)
								IATAB[name .. "ofsx"] = ofsx1
								IATAB[name .. "ofsy"] = ofsy1
								btn:ClearAllPoints()
								btn:SetPoint("CENTER", Minimap, "CENTER", ofsx1, ofsy1)
							else
								local Xpoa, Ypoa = GetCursorPosition()
								local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
								Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + radius
								Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - radius
								local dist = radius

								if Ypoa >= dist or Ypoa <= -dist then
									Xpoa = ImproveAny:MathC(Xpoa, -dist, dist)
								else
									if Xpoa > 0 then
										Xpoa = dist
									else
										Xpoa = -dist
									end
								end

								if Xpoa >= dist or Xpoa <= -dist then
									Ypoa = ImproveAny:MathC(Ypoa, -dist, dist)
								else
									if Ypoa > 0 then
										Ypoa = dist
									else
										Ypoa = -dist
									end
								end

								local ofsx2 = -Xpoa
								local ofsy2 = Ypoa
								IATAB[name .. "ofsx"] = ofsx2
								IATAB[name .. "ofsy"] = ofsy2
								btn:ClearAllPoints()
								btn:SetPoint("CENTER", Minimap, "CENTER", ofsx2, ofsy2)
							end

							C_Timer.After(0.004, btn.UpdatePos)
						else
							C_Timer.After(0.3, btn.UpdatePos)
						end
					end

					btn:UpdatePos()
					btn:RegisterForDrag("LeftButton")

					btn:SetScript("OnDragStart", function()
						btn:StartMoving()
						btn.moving = true
					end)

					btn:SetScript("OnDragStop", function()
						btn:StopMovingOrSizing()
						btn.moving = false
					end)
				end
			end

			if MinimapToggleButton then
				MinimapToggleButton:Hide()
			end

			if ImproveAny:GetWoWBuild() ~= "RETAIL" and TimeManagerClockButton then
				local clocktexture = select(1, TimeManagerClockButton:GetRegions())

				if clocktexture and clocktexture.SetTexture then
					clocktexture:SetTexture(nil)
				end

				TimeManagerClockButton:ClearAllPoints()
				TimeManagerClockButton:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -4)
			end

			if MinimapZoneTextButton then
				MinimapZoneTextButton:ClearAllPoints()
				MinimapZoneTextButton:SetPoint("BOTTOM", Minimap, "TOP", 0, 6)
			end

			-- Blizzard Minimap Buttons Dragging
			-- ALL
			ImproveAny:ConvertToMinimapButton("MiniMapWorldMapButton", true) -- WorldMap
			ImproveAny:ConvertToMinimapButton("MiniMapMailFrame") -- Mail
			-- Retail
			ImproveAny:ConvertToMinimapButton("MiniMapTrackingButton") -- Tracking

			if GameTimeFrame then
				GameTimeFrame:SetFrameLevel(10)
			end

			if select(4, GetBuildInfo()) < 100000 then
				ImproveAny:ConvertToMinimapButton("GameTimeFrame", true) -- Calendar
			end

			ImproveAny:ConvertToMinimapButton("ExpansionLandingPageMinimapButton") -- Sanctum
			ImproveAny:ConvertToMinimapButton("GarrisonLandingPageMinimapButton") -- Sanctum
			ImproveAny:ConvertToMinimapButton("QueueStatusMinimapButton") -- LFG

			if MiniMapInstanceDifficulty then
				MiniMapInstanceDifficulty:SetParent(Minimap)
			end

			--ImproveAny:ConvertToMinimapButton( "MiniMapInstanceDifficulty" ) -- RAIDSize, not moveable somehow
			-- breaks retail if not checked
			if ImproveAny:GetWoWBuild() ~= "RETAIL" and MiniMapTracking then
				ImproveAny:ConvertToMinimapButton("MiniMapTracking") -- Tracking
			end

			-- Classic ERA
			ImproveAny:ConvertToMinimapButton("MiniMapTrackingFrame") -- Tracking
			ImproveAny:ConvertToMinimapButton("MiniMapLFGFrame") -- LFG
			-- Blizzard Minimap Buttons Dragging
			ImproveAny:ConvertToMinimapButton("MiniMapBattlefieldFrame") -- PVP
			ImproveAny:ConvertToMinimapButton("MinimapZoomIn")
			ImproveAny:ConvertToMinimapButton("MinimapZoomOut")
			ImproveAny:ConvertToMinimapButton("CodexBrowserIcon")

			local mmBtnsNames = {"LibDBIcon", "BtWQuests", "MinimapButton",}

			-- ADDONS
			local mmbtns = {}

			function IAUpdateMMBtns()
				for i, child in pairs({Minimap:GetChildren()}) do
					if not tContains(mmbtns, child) and child:GetName() then
						for x, w in pairs(mmBtnsNames) do
							if strfind(child:GetName(), w) and not tContains(mmbtns, child) then
								tinsert(mmbtns, child)
								ImproveAny:ConvertToMinimapButton(child:GetName())
							end
						end
					end
				end

				mmdelay = mmdelay + 0.1

				if mmdelay <= 1.0 then
					C_Timer.After(mmdelay, IAUpdateMMBtns)
				end
			end

			IAUpdateMMBtns()
		end)
	end
end