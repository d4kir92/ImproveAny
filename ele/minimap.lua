local _, ImproveAny = ...
local deg, atan2 = math.deg, math.atan2
local mmdelay = 0.4
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

		if Minimap.ZoomIn then
			hooksecurefunc(
				Minimap.ZoomIn,
				"Show",
				function(sel)
					sel:Hide()
				end
			)

			Minimap.ZoomIn:Hide()
		end

		if Minimap.ZoomOut then
			hooksecurefunc(
				Minimap.ZoomOut,
				"Show",
				function(sel)
					sel:Hide()
				end
			)

			Minimap.ZoomOut:Hide()
		end
	else
		if MinimapZoomIn then
			MinimapZoomIn:Show()
		end

		if MinimapZoomOut then
			MinimapZoomOut:Show()
		end
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
				if minimapshape == "ROUND" then
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
local function GetVaultData()
	local vaultData = C_WeeklyRewards.GetActivities()
	if not vaultData then return {}, {}, {} end
	local res = {}
	res["raid"] = {}
	res["mplus"] = {}
	res["world"] = {}
	for x, data in pairs(vaultData) do
		if data.type == 1 then
			table.insert(res["mplus"], data)
		elseif data.type == 3 then
			table.insert(res["raid"], data)
		elseif data.type == 6 then
			table.insert(res["world"], data)
		else
			ImproveAny:MSG("[GetVaultData] Missing Type")
		end
	end

	return res
end

local function GetVaultStatus(vaultData, name)
	local res = ""
	for i, data in pairs(vaultData[name]) do
		local color = "|cFFFFFFFF"
		if data.progress == 0 then
			color = "|cFFFF0000"
		elseif data.progress >= data.threshold then
			color = "|cFF00FF00"
		else
			color = "|cFFFFFF00"
		end

		local status = color .. data.progress .. "|cFFFFFFFF/" .. color .. data.threshold
		if data.progress > data.threshold then
			status = color .. data.threshold .. "|cFFFFFFFF/" .. color .. data.threshold
		end

		if res ~= "" then
			res = res .. "     "
		end

		res = res .. status
	end

	res = res .. "  "

	return res
end

local function GetVaultStatusIlvl(vaultData, name)
	local res = ""
	for i, data in pairs(vaultData[name]) do
		local ilvl = nil
		local itemLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(data.id)
		if itemLink then
			ilvl = GetDetailedItemLevelInfo(itemLink)
		end

		local color = "|cFFFFFFFF"
		if data.progress == 0 then
			color = "|cFFFF0000"
		elseif data.progress >= data.threshold then
			color = "|cFF00FF00"
		else
			color = "|cFFFFFF00"
		end

		if res ~= "" then
			res = res .. " "
		end

		if ilvl then
			res = res .. " |cFFFFFFFF(" .. color .. ilvl .. "|cFFFFFFFF" .. ")"
		else
			res = res .. "         "
		end
	end

	return res
end

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
		C_Timer.After(
			0.3,
			function()
				local mmBtnsNames = {"Lib_GPI_Minimap_", "MinimapButton_D4Lib_", "LibDBIcon10_", "BtWQuests", "MinimapButton", "MinimapIcon", "_Minimap_"}
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
					IATAB["MMBtns"] = IATAB["MMBtns"] or {}
					ImproveAny:CreateMinimapButton(
						{
							["name"] = "ImproveAnyMMBtns",
							["icon"] = 1120721,
							["var"] = mmbtn,
							["dbtab"] = IATAB["MMBtns"],
							["vTT"] = {{"Minimap Buttons", "ImproveAny |T136033:16:16:0:0|t"}, {"Leftclick", "Toggle Visibility"}},
							["funcL"] = function()
								IAMMBtnsFrame.hide = not IAMMBtnsFrame.hide
								ImproveAny:UpdateIAMMBtns()
							end,
							["addoncomp"] = false
						}
					)
				end

				if ImproveAny:GetWoWBuild() == "RETAIL" and ImproveAny:IsEnabled("SHOWVAULTMMBTN", true) then
					local mmbtn = nil
					IATAB["MMBtnGreatVault"] = IATAB["MMBtnGreatVault"] or {}
					ImproveAny:CreateMinimapButton(
						{
							["name"] = "ImproveAnyGreatVault",
							["atlas"] = "gficon-chest-evergreen-greatvault-complete",
							["var"] = mmbtn,
							["dbtab"] = IATAB["MMBtnGreatVault"],
							["vTT"] = {{"Great Vault", "ImproveAny |T136033:16:16:0:0|t"}, {"Leftclick", "Toggle Great Vault"}},
							["vTTUpdate"] = function(sel, tt)
								if C_WeeklyRewards.HasAvailableRewards() or C_WeeklyRewards.HasGeneratedRewards() then
									tt:AddDoubleLine(" ", " ")
									tt:AddDoubleLine("GREAT VAULT HAS REWARD", "")
								end

								tt:AddDoubleLine(" ", " ")
								local vaultData = GetVaultData()
								local raid = GetVaultStatus(vaultData, "raid")
								tt:AddDoubleLine("Raid", raid)
								local raidIlvl = GetVaultStatusIlvl(vaultData, "raid")
								if strtrim(raidIlvl) ~= "" then
									tt:AddDoubleLine(" ", raidIlvl)
								end

								tt:AddDoubleLine(" ", " ")
								local mplus = GetVaultStatus(vaultData, "mplus")
								tt:AddDoubleLine("M+", mplus)
								local mplusIlvl = GetVaultStatusIlvl(vaultData, "mplus")
								if strtrim(mplusIlvl) ~= "" then
									tt:AddDoubleLine(" ", mplusIlvl)
								end

								tt:AddDoubleLine(" ", " ")
								local world = GetVaultStatus(vaultData, "world")
								tt:AddDoubleLine("World", world)
								local worldIlvl = GetVaultStatusIlvl(vaultData, "world")
								if strtrim(worldIlvl) ~= "" then
									tt:AddDoubleLine(" ", worldIlvl)
								end

								for i = 1, 99 do
									local tr = _G[tt:GetName() .. "TextRight" .. i]
									if tr then
										tr:SetFontObject("ConsoleFontNormal")
										local f1, _, f3 = tr:GetFont()
										tr:SetFont(f1, 14, f3)
									end
								end

								return false
							end,
							["funcL"] = function()
								if not InCombatLockdown() then
									if WeeklyRewardsFrame == nil then
										WeeklyRewards_ShowUI()
									elseif WeeklyRewardsFrame:IsShown() then
										WeeklyRewardsFrame:Hide()
									else
										WeeklyRewards_ShowUI()
									end
								end
							end,
							["addoncomp"] = false,
							["sw"] = 64,
							["sh"] = 64,
							["border"] = false,
						}
					)
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

				function ImproveAny:UpdateIAMMBtns()
					if ImproveAny:IsEnabled("COMBINEMMBTNS", false) then
						local br = 7
						local sr = 1
						local sum = 0
						for i, v in pairs(IAMMBtns) do
							if v:IsShown() and (v:GetParent() == Minimap or v:GetParent() == IAMMBtnsFrame) then
								sum = sum + 1
							end
						end

						table.sort(IAMMBtns, sortFunc)
						local rows, cols = ImproveAny:GetRowsCols(sum)
						IAMMBtnsFrame:SetSize(cols * (MMBtnSize + sr) + 2 * br - sr, rows * (MMBtnSize + sr) + 2 * br - sr)
						local row, col = 0, 0
						for i, v in pairs(IAMMBtns) do
							if v:IsShown() and (v:GetParent() == Minimap or v:GetParent() == IAMMBtnsFrame) then
								if col == cols then
									col = 0
									row = row + 1
								end

								v:SetParent(IAMMBtnsFrame)
								v:ClearAllPoints()
								local cSpace = 0
								local rSpace = 0
								if col > 0 then
									cSpace = col * sr
								end

								if row > 0 then
									rSpace = row * sr
								end

								v:SetPoint("TOPLEFT", IAMMBtnsFrame, "TOPLEFT", col * MMBtnSize + cSpace + br, -row * MMBtnSize - rSpace - br)
								col = col + 1
							end
						end

						if not IAMMBtnsFrame.hide then
							IAMMBtnsFrame:Show()
						else
							IAMMBtnsFrame:Hide()
						end
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

						if stay or not ImproveAny:IsEnabled("COMBINEMMBTNS", false) then
							IATAB[name .. "db"] = IATAB[name .. "db"] or {}
							btn:SetParent(Minimap)
							btn:SetMovable(true)
							btn.db = IATAB[name .. "db"]
							btn.db.minimapPos = btn.db.minimapPos or 0
							btn.minimapPos = btn.minimapPos or 0
							if not InCombatLockdown() then
								btn:ClearAllPoints()
								ImproveAny:UpdatePosition(btn, btn.db.minimapPos)
							end

							btn:RegisterForDrag("LeftButton")
							btn:SetScript(
								"OnDragStart",
								function(sel)
									sel.isMouseDown = true
									sel:SetScript(
										"OnUpdate",
										function(se)
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

											if not InCombatLockdown() then
												se:ClearAllPoints()
												ImproveAny:UpdatePosition(se, pos)
											end
										end
									)
								end
							)

							btn:SetScript(
								"OnDragStop",
								function(sel)
									sel:SetScript("OnUpdate", nil)
									sel.isMouseDown = false
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
				ImproveAny:ConvertToMinimapButton("MiniMapWorldMapButton", true) -- WorldMap
				ImproveAny:ConvertToMinimapButton("MiniMapMailFrame", true) -- Mail
				-- Retail
				ImproveAny:ConvertToMinimapButton("MiniMapTrackingButton", true) -- Tracking
				if MiniMapTracking and MiniMapTrackingButton then
					hooksecurefunc(
						MiniMapTrackingButton,
						"SetPoint",
						function(sel, ...)
							if sel.ia_setpoint then return end
							sel.ia_setpoint = true
							local op1, op2, op3, op4, op5 = MiniMapTrackingButton:GetPoint()
							if op2 ~= MiniMapTracking then
								MiniMapTracking:ClearAllPoints()
								MiniMapTracking:SetPoint(op1, op2, op3, op4, op5)
							end

							sel.ia_setpoint = false
						end
					)

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

				if GameTimeFrame then
					GameTimeFrame:SetFrameLevel(10)
				end

				if MiniMapInstanceDifficulty and MiniMapInstanceDifficulty:GetParent() == "MinimapCluster" then
					MiniMapInstanceDifficulty:SetParent(Minimap)
				end

				if select(4, GetBuildInfo()) < 100000 then
					ImproveAny:ConvertToMinimapButton("GameTimeFrame", true, ImproveAny:GetWoWBuild() == "CLASSIC") -- Calendar
				end

				ImproveAny:ConvertToMinimapButton("ExpansionLandingPageMinimapButton", true) -- Sanctum
				ImproveAny:ConvertToMinimapButton("GarrisonLandingPageMinimapButton", true) -- Sanctum
				ImproveAny:ConvertToMinimapButton("QueueStatusMinimapButton", true) -- LFG
				-- Classic ERA
				ImproveAny:ConvertToMinimapButton("MiniMapTrackingFrame", true) -- Tracking
				ImproveAny:ConvertToMinimapButton("MiniMapLFGFrame", true) -- LFG
				-- Blizzard Minimap Buttons Dragging
				ImproveAny:ConvertToMinimapButton("MiniMapBattlefieldFrame", true) -- PVP
				ImproveAny:ConvertToMinimapButton("MinimapZoomIn", true)
				ImproveAny:ConvertToMinimapButton("MinimapZoomOut", true)
				ImproveAny:ConvertToMinimapButton("CodexBrowserIcon", true)
				ImproveAny:ConvertToMinimapButton("CalendarButtonFrame", true)
				ImproveAny:ConvertToMinimapButton("HelpOpenWebTicketButton", true)
				-- ADDONS
				local mmbtns = {}
				function ImproveAny:UpdateMMBtns()
					for i, child in pairs({Minimap:GetChildren()}) do
						if not tContains(mmbtns, child) and child:GetName() then
							for x, w in pairs(mmBtnsNames) do
								if strfind(child:GetName(), w) and not tContains(mmbtns, child) and not strfind(child:GetName(), "Peggle") then
									tinsert(mmbtns, child)
									ImproveAny:ConvertToMinimapButton(child:GetName(), strfind(child:GetName(), "ImproveAnyMMBtns") ~= nil or strfind(child:GetName(), "ImproveAnyGreatVault") ~= nil or strfind(child:GetName(), "BugSack") ~= nil or strfind(child:GetName(), "AutoQueueWA") ~= nil)
								end
							end
						end
					end

					ImproveAny:UpdateIAMMBtns()
					C_Timer.After(mmdelay, ImproveAny.UpdateMMBtns)
				end

				ImproveAny:UpdateMMBtns()
			end
		)
	end
end
