local _, ImproveAny = ...
IAILVLBar = CreateFrame("FRAME", "IAILVLBar", UIParent)

function ImproveAny:InitIAILVLBar()
	if ImproveAny:IsEnabled("IAILVLBAR", false) then
		IAILVLBar:SetSize(180, 20)
		IAILVLBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -200, 180)
		IAILVLBar.textilvloverall = IAILVLBar:CreateFontString(nil)
		IAILVLBar.textilvloverall:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
		IAILVLBar.textilvloverall:SetPoint("TOP", IAILVLBar, "TOP", 0, 0)
		IAILVLBar.textilvloverall:SetText("")
		IAILVLBar.textilvloverall:SetTextColor(1.0, 1.0, 0.1)
		IAILVLBar.textilvlequipped = IAILVLBar:CreateFontString(nil)
		IAILVLBar.textilvlequipped:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
		IAILVLBar.textilvlequipped:SetPoint("BOTTOM", IAILVLBar, "BOTTOM", 0, 0)
		IAILVLBar.textilvlequipped:SetText("")
		IAILVLBar.textilvlequipped:SetTextColor(1.0, 1.0, 0.1)

		function IAILVLBar.Think()
			if IAILVLBar.textilvloverall and IAILVLBar.textilvlequipped then
				local overall, equipped = IAILVL, IAILVL

				if GetAverageItemLevel then
					overall, equipped = GetAverageItemLevel()
					overall = string.format("%.2f", overall)
					equipped = string.format("%.2f", equipped)
				end

				if overall and equipped then
					if tonumber(overall) == tonumber(equipped) then
						IAILVLBar.textilvloverall:ClearAllPoints()
						IAILVLBar.textilvloverall:SetPoint("CENTER", IAILVLBar, "CENTER", 0, 0)
						IAILVLBar.textilvloverall:SetText(overall .. " " .. ITEM_LEVEL_ABBR)
						IAILVLBar.textilvlequipped:SetText("")
					else
						IAILVLBar.textilvloverall:ClearAllPoints()
						IAILVLBar.textilvloverall:SetPoint("TOP", IAILVLBar, "TOP", 0, 0)
						IAILVLBar.textilvloverall:SetText(overall .. " " .. ITEM_LEVEL_ABBR)
						IAILVLBar.textilvlequipped:SetText(equipped .. " " .. ITEM_LEVEL_ABBR)
					end
				else
					IAILVLBar.textilvloverall:SetText("")
					IAILVLBar.textilvlequipped:SetText("")
				end
			elseif IAILVLBar.textilvloverall and IAILVLBar.textilvlequipped then
				IAILVLBar.textilvloverall:SetText("")
				IAILVLBar.textilvlequipped:SetText("")
			end

			C_Timer.After(1.0, IAILVLBar.Think)
		end

		IAILVLBar.Think()
	end
end