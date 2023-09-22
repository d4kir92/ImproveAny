local _, ImproveAny = ...
local fontSize = 12
IAMoneyBar = CreateFrame("FRAME", "IAMoneyBar", UIParent)
function ImproveAny:InitMoneyBar()
	if ImproveAny:IsEnabled("MONEYBAR", false) then
		IAMoneyBar:SetSize(180, 30)
		IAMoneyBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -240 - 10, 100)
		IAMoneyBar:EnableMouse(true)
		local oldMoney = GetMoney()
		local ts = 0
		IAMoneyBar.text = IAMoneyBar:CreateFontString(nil, "ARTWORK")
		IAMoneyBar.text:SetFont(STANDARD_TEXT_FONT, fontSize, "THINOUTLINE")
		IAMoneyBar.text:SetPoint("TOP", IAMoneyBar, "TOP", 0, 0)
		IAMoneyBar.text2 = IAMoneyBar:CreateFontString(nil, "ARTWORK")
		IAMoneyBar.text2:SetFont(STANDARD_TEXT_FONT, fontSize, "THINOUTLINE")
		IAMoneyBar.text2:SetPoint("BOTTOM", IAMoneyBar, "BOTTOM", 0, 0)
		IAMoneyBar.Reset = CreateFrame("Button", "ResetMoneyPerHour", IAMoneyBar, "UIPanelButtonTemplate")
		IAMoneyBar.Reset:SetSize(100, 20)
		IAMoneyBar.Reset:SetPoint("BOTTOM", IAMoneyBar, 0, 0)
		IAMoneyBar.Reset:SetText(RESET)
		IAMoneyBar.Reset:SetScript(
			"OnClick",
			function(sel, ...)
				ts = 0
				oldMoney = GetMoney()
			end
		)

		IAMoneyBar.Reset:Hide()
		function IAMoneyBar.Reset:GetMAEle()
			return IAMoneyBar
		end

		IAMoneyBar:SetScript(
			"OnEnter",
			function(sel)
				IAMoneyBar.Reset:Show()
			end
		)

		IAMoneyBar:SetScript(
			"OnLeave",
			function(sel)
				if not MouseIsOver(IAMoneyBar.Reset) then
					IAMoneyBar.Reset:Hide()
				end
			end
		)

		IAMoneyBar.Reset:SetScript(
			"OnLeave",
			function(sel)
				IAMoneyBar.Reset:Hide()
			end
		)

		function IAMoneyBar:MoneyThink()
			local text = GetCoinTextureString(GetMoney(), fontSize)
			IAMoneyBar.text:SetText(text)
			local text2 = ""
			if ts > 0 then
				local totalMoney = GetMoney() - oldMoney
				local mops = totalMoney / ts
				local mopm = mops * 60
				local moph = mopm * 60
				if moph >= 0 then
					text2 = GetCoinTextureString(moph, fontSize) .. "/" .. "H"
				elseif moph < 0 then
					text2 = "-" .. GetCoinTextureString(math.abs(moph), fontSize) .. "/" .. "H"
				end
			end

			IAMoneyBar.text2:SetText(text2)
			ts = ts + 1
			ImproveAny:Debug("moneybar.lua: MoneyThink", "think")
			C_Timer.After(1.5, IAMoneyBar.MoneyThink)
		end

		IAMoneyBar:MoneyThink()
		if ImproveAny:GetWoWBuild() ~= "RETAIL" and (GOLD_AMOUNT_SYMBOL == nil or GOLD_AMOUNT_SYMBOL == "G") then
			GOLD_AMOUNT_SYMBOL = "|TInterface\\MoneyFrame\\UI-GoldIcon:12:12:2:0|t"
			SILVER_AMOUNT_SYMBOL = "|TInterface\\MoneyFrame\\UI-SilverIcon:12:12:2:0|t"
			COPPER_AMOUNT_SYMBOL = "|TInterface\\MoneyFrame\\UI-CopperIcon:12:12:2:0|t"
		end
	end
end