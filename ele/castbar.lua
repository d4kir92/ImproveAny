
local AddOnName, ImproveAny = ...

local br = 0.068

local f = CreateFrame("FRAME")
f.update = 0.1

function ImproveAny:InitCastBar()
	local castbar = CastingBarFrame
	local height = 24
	if PlayerCastingBarFrame then
		castbar = PlayerCastingBarFrame
		height = 16
	end
	if castbar then -- OLD CastBar
		hooksecurefunc(castbar.Border, "Show", function(self, ...)
			if true then
				self:Hide()
			end
		end)
		if true then
			castbar.Border:Hide()
		end

		if true then
			castbar.Flash:SetParent( IAHIDDEN )

			if PlayerCastingBarFrame then
				castbar.Text:SetFont( STANDARD_TEXT_FONT, 10, "" )
				castbar.Text:ClearAllPoints()
				castbar.Text:SetPoint( "CENTER", castbar, "CENTER", 0, -14 )
			else
				castbar.Text:SetFont( STANDARD_TEXT_FONT, 10, "" )
				castbar.Text:ClearAllPoints()
				castbar.Text:SetPoint( "CENTER", castbar, "CENTER", 0, 0 )
			end

			castbar:SetHeight(height)
			castbar.Spark:SetHeight(height)
			castbar.Border:SetHeight(96)
			castbar.Border:ClearAllPoints()
			castbar.Border:SetPoint("CENTER", castbar, "CENTER", 0, 0)

			castbar.icon = castbar:CreateTexture(nil, "ARTWORK")
			castbar.icon:SetSize(height, height)
			castbar.icon:SetPoint("RIGHT", castbar, "LEFT", 0, 0)
			castbar.icon:SetTexCoord( br, 1 - br, br, 1 - br )

			castbar.timer = castbar:CreateFontString(nil)
			castbar.timer:SetFont(STANDARD_TEXT_FONT, 10, "")
			castbar.timer:SetPoint("CENTER", castbar, "RIGHT", 12, 0)

			f:HookScript( "OnUpdate", function(self, elapsed)
				if castbar.timer ~= nil then
					if self.update and self.update < elapsed then
						local name, text, texture = nil, nil, nil
						if UnitCastingInfo ~= nil then
							name, text, texture = UnitCastingInfo("PLAYER")
						end
						if name == nil and UnitChannelInfo ~= nil then
							name, text, texture = UnitChannelInfo("PLAYER")
						end
						if CastingInfo ~= nil then
							name, text, texture = CastingInfo()
						end
						if name == nil and ChannelInfo ~= nil then
							name, text, texture = ChannelInfo()
						end
						
						if ImproveAny:GetWoWBuild() ~= "RETAIL" and texture == 136235 then
							texture = 136243 -- 136192
						end
						if castbar.icon ~= nil and castbar.icon:GetTexture() ~= texture then
							castbar.icon:SetTexture(texture)
						end

						if castbar.casting then
							castbar.timer:SetText(format("%2.1f", max(castbar.maxValue - castbar.value, 0)))
						elseif castbar.channeling then
							castbar.timer:SetText(format("%.1f", max(castbar.value, 0)))
						else
							castbar.timer:SetText("")
						end
						self.update = 0.1
					else
						self.update = self.update - elapsed
					end
				end
			end )
		end
	end
end
