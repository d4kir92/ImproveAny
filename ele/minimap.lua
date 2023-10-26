local _, ImproveAny = ...
local mmdelay = 0.1
local minimapshape = "ROUND"
function ImproveAny:UpdateMinimapSettings()
	if ImproveAny:IsEnabled("MINIMAP", false) and ImproveAny:IsEnabled("MINIMAPSHAPESQUARE", false) then
		ImproveAny:SHAPE("SQUARE")
	else
		ImproveAny:SHAPE("ROUND")
	end

	if ImproveAny:IsEnabled("MINIMAP", false) and ImproveAny:IsEnabled("MINIMAPHIDEBORDER", false) then
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

	if ImproveAny:IsEnabled("MINIMAP", false) and ImproveAny:IsEnabled("MINIMAPHIDEZOOMBUTTONS", false) then
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

	C_Timer.After(
		0.1,
		function()
			ImproveAny:Debug("minimap.lua: delay")
			if ImproveAny:IsEnabled("MINIMAP", false) and ImproveAny:IsEnabled("MINIMAPHIDEBORDER", false) then
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
		end
	)
end

local IAMMBtns = {}
local IAMMBtnsConverted = {}
local MMBtnSize = 31
function ImproveAny:InitMinimap()
	function GetMinimapShape()
		return minimapshape
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
		C_Timer.After(
			0.3,
			function()
				local mmBtnsNames = {"Lib_GPI_Minimap_", "LibDBIcon10_", "BtWQuests", "MinimapButton", "MinimapIcon", "_Minimap_"}
				local IAMMBtnsBliz = {}
				local IAMMBtnsFrame = CreateFrame("Frame", "IAMMBtnsFrame", UIParent)
				IAMMBtnsFrame:SetSize(100, 100)
				IAMMBtnsFrame.bg = IAMMBtnsFrame:CreateTexture("IAMMBtnsFrame.bg", "ARTWORK")
				IAMMBtnsFrame.bg:SetAllPoints(IAMMBtnsFrame)
				IAMMBtnsFrame.bg:SetColorTexture(0.03, 0.03, 0.03, 0.5)
				IAMMBtnsFrame:EnableMouse(true)
				IAMMBtnsFrame:SetMovable(true)
				IAMMBtnsFrame:RegisterForDrag("LeftButton")
				IAMMBtnsFrame:SetScript(
					"OnDragStart",
					function()
						IAMMBtnsFrame:StartMoving()
					end
				)

				IAMMBtnsFrame:SetScript(
					"OnDragStop",
					function()
						IAMMBtnsFrame:StopMovingOrSizing()
						local p1, _, p3, p4, p5 = IAMMBtnsFrame:GetPoint()
						ImproveAny:SetElePoint("IAMMBtnsFrame", p1, _, p3, p4, p5)
					end
				)

				local p1, _, p3, p4, p5 = ImproveAny:GetElePoint("IAMMBtnsFrame")
				if p1 then
					IAMMBtnsFrame:SetPoint(p1, UIParent, p3, p4, p5)
				else
					IAMMBtnsFrame:SetPoint("CENTER", 0, 0)
				end

				IAMMBtnsFrame:Hide()
				IAMMBtnsFrame.hide = true
				if ImproveAny:IsEnabled("COMBINEMMBTNS", false) then
					local mmbtn = nil
					D4:CreateMinimapButton(
						{
							["name"] = "ImproveAnyMMBtns",
							["icon"] = 1120721,
							["var"] = mmbtn,
							["dbtab"] = IATAB["MMBtns"],
							["vTT"] = {"Minimap Buttons"},
							["funcL"] = function()
								IAMMBtnsFrame.hide = not IAMMBtnsFrame.hide
								ImproveAny:UpdateIAMMBtns()
							end,
						}
					)
				end

				function ImproveAny:UpdateIAMMBtns()
					local sum = 0
					for i, v in pairs(IAMMBtns) do
						if v:IsShown() then
							sum = sum + 1
						end
					end

					local function sortFunc(a, b)
						local a1 = a:GetName()
						local b1 = b:GetName()
						for i, v in pairs(mmBtnsNames) do
							a1 = string.gsub(a1, v, "")
							b1 = string.gsub(b1, v, "")
						end

						return a1 < b1
					end

					table.sort(IAMMBtns, sortFunc)
					local rows, cols = ImproveAny:GetRowsCols(sum)
					IAMMBtnsFrame:SetSize(cols * MMBtnSize, rows * MMBtnSize)
					local row, col = 0, 0
					for i, v in pairs(IAMMBtns) do
						if v:IsShown() then
							if col == cols then
								col = 0
								row = row + 1
							end

							v:SetParent(IAMMBtnsFrame)
							v:ClearAllPoints()
							v:SetPoint("TOPLEFT", IAMMBtnsFrame, "TOPLEFT", col * MMBtnSize, -row * MMBtnSize)
							col = col + 1
						end
					end

					if not IAMMBtnsFrame.hide then
						IAMMBtnsFrame:Show()
					else
						IAMMBtnsFrame:Hide()
					end
				end

				function ImproveAny:ConvertToMinimapButton(name, stay, hide)
					if not ImproveAny:IsEnabled("MINIMAPMINIMAPBUTTONSMOVABLE", false) then return end
					local btn = _G[name]
					if btn and not tContains(IAMMBtnsConverted, name) then
						tinsert(IAMMBtnsConverted, name)
						if hide then
							tinsert(IAMMBtnsBliz, btn)
							btn:Hide()
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
							if ImproveAny:IsEnabled("COMBINEMMBTNS", false) and not stay then return end
							if btn.lockupdate then return end
							btn.lockupdate = true
							if btn.maiinit == nil then
								btn.maiinit = true
								hooksecurefunc(
									btn,
									"SetPoint",
									function(sel)
										if sel.ia_setpoint_mmbtn then return end
										sel.ia_setpoint_mmbtn = true
										sel:SetParent(Minimap)
										sel:SetMovable(true)
										sel:SetUserPlaced(false)
										sel:ClearAllPoints()
										sel:SetPoint("CENTER", Minimap, "CENTER", IATAB[name .. "ofsx"], IATAB[name .. "ofsy"])
										sel.ia_setpoint_mmbtn = false
									end
								)

								btn:SetParent(Minimap)
								btn:ClearAllPoints()
								btn:SetPoint("CENTER", Minimap, "CENTER", IATAB[name .. "ofsx"], IATAB[name .. "ofsy"])
							end

							if btn.moving then
								if GetMinimapShape() == "ROUND" then
									local Xpoa, Ypoa = GetCursorPosition()
									local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
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

								C_Timer.After(
									0.006,
									function()
										ImproveAny:Debug("minimap.lua: UpdatePos #1", "think")
										btn.lockupdate = false
										btn:UpdatePos()
									end
								)
							else
								C_Timer.After(
									0.1,
									function()
										ImproveAny:Debug("minimap.lua: UpdatePos #2", "think")
										btn.lockupdate = false
										btn:UpdatePos()
									end
								)
							end
						end

						if stay or not ImproveAny:IsEnabled("COMBINEMMBTNS", false) then
							btn:UpdatePos()
							btn:RegisterForDrag("LeftButton")
							btn:SetScript(
								"OnDragStart",
								function()
									btn:StartMoving()
									btn.moving = true
								end
							)

							btn:SetScript(
								"OnDragStop",
								function()
									btn:StopMovingOrSizing()
									btn.moving = false
								end
							)
						end

						if not stay then
							table.insert(IAMMBtns, btn)
							ImproveAny:UpdateIAMMBtns()
						end
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
				ImproveAny:ConvertToMinimapButton("MiniMapWorldMapButton", true, true) -- WorldMap
				ImproveAny:ConvertToMinimapButton("MiniMapMailFrame", true) -- Mail
				-- Retail
				ImproveAny:ConvertToMinimapButton("MiniMapTrackingButton", true) -- Tracking
				if MiniMapTracking then
					hooksecurefunc(
						MiniMapTrackingButton,
						"SetPoint",
						function(sel, ...)
							if sel.ia_setpoint then return end
							sel.ia_setpoint = true
							MiniMapTracking:ClearAllPoints()
							MiniMapTracking:SetPoint(MiniMapTrackingButton:GetPoint())
							sel.ia_setpoint = false
						end
					)

					hooksecurefunc(
						MiniMapTracking,
						"SetPoint",
						function(sel, ...)
							if sel.ia_setpoint then return end
							sel.ia_setpoint = true
							MiniMapTracking:ClearAllPoints()
							MiniMapTracking:SetPoint(MiniMapTrackingButton:GetPoint())
							sel.ia_setpoint = false
						end
					)

					MiniMapTracking:ClearAllPoints()
					MiniMapTracking:SetPoint(MiniMapTrackingButton:GetPoint())
					if MiniMapTrackingButton:GetFrameLevel() > 1 then
						MiniMapTracking:SetFrameLevel(MiniMapTrackingButton:GetFrameLevel() - 1)
					else
						MiniMapTrackingButton:SetFrameLevel(3)
						MiniMapTracking:SetFrameLevel(MiniMapTrackingButton:GetFrameLevel() - 1)
					end
				end

				if GameTimeFrame then
					GameTimeFrame:SetFrameLevel(10)
				end

				if select(4, GetBuildInfo()) < 100000 then
					ImproveAny:ConvertToMinimapButton("GameTimeFrame", true, true) -- Calendar
				end

				ImproveAny:ConvertToMinimapButton("ExpansionLandingPageMinimapButton", true) -- Sanctum
				ImproveAny:ConvertToMinimapButton("GarrisonLandingPageMinimapButton", true) -- Sanctum
				ImproveAny:ConvertToMinimapButton("QueueStatusMinimapButton", true) -- LFG
				if MiniMapInstanceDifficulty then
					MiniMapInstanceDifficulty:SetParent(Minimap)
				end

				-- Classic ERA
				ImproveAny:ConvertToMinimapButton("MiniMapTrackingFrame", true) -- Tracking
				ImproveAny:ConvertToMinimapButton("MiniMapLFGFrame", true) -- LFG
				-- Blizzard Minimap Buttons Dragging
				ImproveAny:ConvertToMinimapButton("MiniMapBattlefieldFrame", true) -- PVP
				ImproveAny:ConvertToMinimapButton("MinimapZoomIn", true)
				ImproveAny:ConvertToMinimapButton("MinimapZoomOut", true)
				ImproveAny:ConvertToMinimapButton("CodexBrowserIcon", true)
				-- ADDONS
				local mmbtns = {}
				function ImproveAny:UpdateMMBtns()
					for i, child in pairs({Minimap:GetChildren()}) do
						if not tContains(mmbtns, child) and child:GetName() then
							for x, w in pairs(mmBtnsNames) do
								if strfind(child:GetName(), w) and not tContains(mmbtns, child) and not strfind(child:GetName(), "Peggle") then
									tinsert(mmbtns, child)
									ImproveAny:ConvertToMinimapButton(child:GetName(), strfind(child:GetName(), "ImproveAnyMMBtns") ~= nil)
								end
							end
						end
					end

					mmdelay = mmdelay + 0.1
					if mmdelay <= 1.0 then
						ImproveAny:Debug("minimap.lua: mmdelay", "retry")
						C_Timer.After(mmdelay, ImproveAny.UpdateMMBtns)
					end
				end

				ImproveAny:UpdateMMBtns()
			end
		)
	end
end