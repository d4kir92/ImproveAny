local _, ImproveAny = ...
local deg, atan2 = math.deg, math.atan2
local minimapshape = "ROUND"
function ImproveAny:UpdateMinimapSettings()
	if ImproveAny:IsEnabled("MINIMAP", false) and ImproveAny:IsEnabled("MINIMAPSHAPESQUARE", false) and not ImproveAny:IsAddOnLoaded("DragonflightUI", "SHAPE") then
		ImproveAny:SHAPE("SQUARE")
	else
		ImproveAny:SHAPE("ROUND")
	end

	if ImproveAny:IsEnabled("MINIMAP", false) and ImproveAny:IsEnabled("MINIMAPHIDEBORDER", false) and not ImproveAny:IsAddOnLoaded("DragonflightUI", "MinimapBorder") then
		if MinimapBorder then MinimapBorder:Hide() end
		if MinimapBorderTop then MinimapBorderTop:Hide() end
		if MinimapCompassTexture then MinimapCompassTexture:Hide() end
	elseif not ImproveAny:IsAddOnLoaded("DragonflightUI", "MinimapBorder2") then
		if MinimapBorder then MinimapBorder:Show() end
		if MinimapBorderTop then MinimapBorderTop:Show() end
		if MinimapCompassTexture then MinimapCompassTexture:Show() end
	end

	if ImproveAny:IsEnabled("MINIMAP", false) and ImproveAny:IsEnabled("MINIMAPHIDEZOOMBUTTONS", false) then
		if MinimapZoomIn then MinimapZoomIn:Hide() end
		if MinimapZoomOut then MinimapZoomOut:Hide() end
		if Minimap.ZoomIn then
			hooksecurefunc(Minimap.ZoomIn, "Show", function(sel) sel:Hide() end)
			Minimap.ZoomIn:Hide()
		end

		if Minimap.ZoomOut then
			hooksecurefunc(Minimap.ZoomOut, "Show", function(sel) sel:Hide() end)
			Minimap.ZoomOut:Hide()
		end
	else
		if MinimapZoomIn then MinimapZoomIn:Show() end
		if MinimapZoomOut then MinimapZoomOut:Show() end
	end

	if ImproveAny:GetWoWBuild() ~= "RETAIL" then
		if ImproveAny:IsEnabled("MINIMAP", false) and ImproveAny:IsEnabled("MINIMAPSCROLLZOOM", false) then
			function ImproveAny:OnMouseWheel(dir)
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

			Minimap:SetScript("OnMouseWheel", ImproveAny.OnMouseWheel)
		else
			Minimap:SetScript("OnMouseWheel", function() end) --
		end
	end

	ImproveAny:After(0.1, function()
		ImproveAny:Debug("minimap.lua: delay")
		if ImproveAny:IsEnabled("MINIMAP", false) and ImproveAny:IsEnabled("MINIMAPHIDEBORDER", false) and not ImproveAny:IsAddOnLoaded("DragonflightUI", "MinimapBorder3") then
			if MinimapBorder then MinimapBorder:SetParent(IAHIDDEN) end
			if MinimapCompassTexture then MinimapCompassTexture:SetParent(IAHIDDEN) end
			if MiniMapWorldMapButton and MiniMapWorldMapButton:GetNormalTexture():GetTexture() == 452113 then
				MiniMapWorldMapButton:SetNormalTexture("Interface\\AddOns\\ImproveAny\\media\\UI-Minimap-WorldMapSquare")
				MiniMapWorldMapButton:SetPushedTexture("Interface\\AddOns\\ImproveAny\\media\\UI-Minimap-WorldMapSquare")
			end
		else
			if minimapshape == "ROUND" then
				if MinimapBorder then MinimapBorder:SetParent(Minimap) end
				if MinimapCompassTexture then MinimapCompassTexture:SetParent(Minimap) end
			else
				if MinimapBorder then MinimapBorder:SetParent(IAHIDDEN) end
				if MinimapCompassTexture then MinimapCompassTexture:SetParent(IAHIDDEN) end
			end
		end
	end, "UpdateMinimapSettings")
end

local IAMMBtnsConverted = {}
function ImproveAny:InitMinimap()
	if GetMinimapShape == nil then
		function GetMinimapShape()
			return minimapshape
		end
	end

	function ImproveAny:SHAPE(msg)
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
	if ImproveAny:IsEnabled("MINIMAP", false) then
		if ElvUI then return end
		ImproveAny:Debug("minimap.lua: delay #2")
		ImproveAny:After(0.3, function()
			local mmBtnsNames = {"Lib_GPI_Minimap_", "MinimapButton_D4Lib_", "LibDBIcon10_", "BtWQuests", "MinimapButton", "MinimapIcon", "_Minimap_"}
			local pendingConvert = {}
			local regenFrame = CreateFrame("Frame")
			regenFrame:SetScript("OnEvent", function(sel, event)
				sel:UnregisterEvent(event)
				for name, args in pairs(pendingConvert) do
					pendingConvert[name] = nil
					ImproveAny:ConvertToMinimapButton(name, args[1])
				end
			end)

			function ImproveAny:ConvertToMinimapButton(name, hide)
				if not ImproveAny:IsEnabled("MINIMAPMINIMAPBUTTONSMOVABLE", false) then return end
				local btn = _G[name]
				if btn and not tContains(IAMMBtnsConverted, name) then
					if InCombatLockdown() and btn:IsProtected() then
						pendingConvert[name] = {hide}
						regenFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
						return
					end

					tinsert(IAMMBtnsConverted, name)
					if hide then
						btn:Hide()
					end

					IATAB[name .. "db"] = IATAB[name .. "db"] or {}
					btn:SetParent(Minimap)
					btn:SetMovable(true)
					btn.db = IATAB[name .. "db"]
					btn.db.minimapPos = btn.db.minimapPos or 0
					btn.minimapPos = btn.minimapPos or 0
					ImproveAny:UpdatePosition(btn, btn.db.minimapPos)
					btn:RegisterForDrag("LeftButton")
					btn:SetScript("OnDragStart", function(sel)
						sel.isMouseDown = true
						sel:SetScript("OnUpdate", function(se)
							local mx, my = Minimap:GetCenter()
							local px, py = GetCursorPosition()
							local scale = Minimap:GetEffectiveScale()
							px, py = px / scale, py / scale
							local pos = 0
							if se.db then
								pos = deg(atan2(py - my, px - mx)) % 360
								se.db.minimapPos = pos
							else
								pos = deg(atan2(py - my, px - mx)) % 360
								se.minimapPos = pos
							end

							ImproveAny:UpdatePosition(se, pos)
						end)
					end)

					btn:SetScript("OnDragStop", function(sel)
						sel:SetScript("OnUpdate", nil)
						sel.isMouseDown = false
					end)
				end
			end

			if MinimapToggleButton then MinimapToggleButton:Hide() end
			if ImproveAny:GetWoWBuild() ~= "RETAIL" and TimeManagerClockButton then
				local clocktexture = select(1, TimeManagerClockButton:GetRegions())
				if clocktexture and clocktexture.SetTexture then clocktexture:SetTexture(nil) end
				TimeManagerClockButton:ClearAllPoints()
				TimeManagerClockButton:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -4)
			end

			if MinimapZoneTextButton and not ImproveAny:IsAddOnLoaded("DragonflightUI") then
				MinimapZoneTextButton:ClearAllPoints()
				MinimapZoneTextButton:SetPoint("BOTTOM", Minimap, "TOP", 0, 6)
			end

			-- Blizzard Minimap Buttons Dragging
			-- ALL
			ImproveAny:ConvertToMinimapButton("MiniMapWorldMapButton") -- WorldMap
			ImproveAny:ConvertToMinimapButton("MiniMapMailFrame") -- Mail
			-- Retail
			ImproveAny:ConvertToMinimapButton("MiniMapTrackingButton") -- Tracking
			if MiniMapTracking and MiniMapTrackingButton then
				hooksecurefunc(MiniMapTrackingButton, "SetPoint", function(sel, ...)
					if sel.ia_setpoint then return end
					sel.ia_setpoint = true
					local op1, op2, op3, op4, op5 = MiniMapTrackingButton:GetPoint()
					if op2 ~= MiniMapTracking then
						MiniMapTracking:ClearAllPoints()
						MiniMapTracking:SetPoint(op1, op2, op3, op4, op5)
					end

					sel.ia_setpoint = false
				end)

				local op1, op2, op3, op4, op5 = MiniMapTrackingButton:GetPoint()
				if op2 ~= MiniMapTracking then
					MiniMapTracking:ClearAllPoints()
					MiniMapTracking:SetPoint(op1, op2, op3, op4, op5)
				end

				if MiniMapTrackingButton:GetFrameLevel() > 1 then
					MiniMapTracking:SetFrameLevel(MiniMapTrackingButton:GetFrameLevel() - 1)
				else
					MiniMapTrackingButton:SetFrameLevel(3)
					MiniMapTracking:SetFrameLevel(MiniMapTrackingButton:GetFrameLevel() - 1)
				end
			end

			if GameTimeFrame then GameTimeFrame:SetFrameLevel(10) end
			if MiniMapInstanceDifficulty and ImproveAny:GetParent(MiniMapInstanceDifficulty) == "MinimapCluster" then MiniMapInstanceDifficulty:SetParent(Minimap) end
			if select(4, GetBuildInfo()) < 100000 then
				ImproveAny:ConvertToMinimapButton("GameTimeFrame", ImproveAny:GetWoWBuild() == "CLASSIC") -- Calendar
			end

			ImproveAny:ConvertToMinimapButton("ExpansionLandingPageMinimapButton") -- Sanctum
			ImproveAny:ConvertToMinimapButton("GarrisonLandingPageMinimapButton") -- Sanctum
			ImproveAny:ConvertToMinimapButton("QueueStatusMinimapButton") -- LFG
			-- Classic ERA
			if MiniMapTrackingFrame then
				ImproveAny:ConvertToMinimapButton("MiniMapTrackingFrame") -- Tracking
			elseif MiniMapTracking then
				MiniMapTracking:SetScale(1)
				ImproveAny:ConvertToMinimapButton("MiniMapTracking") -- Tracking
			end

			ImproveAny:ConvertToMinimapButton("MiniMapLFGFrame") -- LFG
			-- Blizzard Minimap Buttons Dragging
			ImproveAny:ConvertToMinimapButton("MiniMapBattlefieldFrame") -- PVP
			ImproveAny:ConvertToMinimapButton("MinimapZoomIn")
			ImproveAny:ConvertToMinimapButton("MinimapZoomOut")
			ImproveAny:ConvertToMinimapButton("CodexBrowserIcon")
			ImproveAny:ConvertToMinimapButton("CalendarButtonFrame")
			ImproveAny:ConvertToMinimapButton("HelpOpenWebTicketButton")
			if LFGMinimapFrame and ImproveAny:GetParent(LFGMinimapFrame) == MinimapBackdrop then ImproveAny:ConvertToMinimapButton("LFGMinimapFrame") end
			-- ADDONS
			local mmbtns = {}
			local numChilds = -1
			function ImproveAny:UpdateMMBtns()
				if numChilds ~= Minimap:GetNumChildren() then
					numChilds = Minimap:GetNumChildren()
					ImproveAny:ForeachChildren(Minimap, function(child, i)
						local name = ImproveAny:GetName(child)
						if child and not tContains(mmbtns, child) and name then
							for x, w in pairs(mmBtnsNames) do
								if strfind(name, w) and not tContains(mmbtns, child) and not strfind(name, "Peggle") then
									tinsert(mmbtns, child)
									ImproveAny:ConvertToMinimapButton(name)
								end
							end
						end
					end, "Minimap")
				end

				ImproveAny:After(3, ImproveAny.UpdateMMBtns, "UpdateMMBtns")
			end

			ImproveAny:UpdateMMBtns()
		end, "InitMinimap")
	end
end
