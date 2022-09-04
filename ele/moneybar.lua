
local AddOnName, ImproveAny = ...

IAMoneyBar = CreateFrame( "FRAME", "IAMoneyBar", UIParent )
IAMoneyBar:SetSize( 180, 20 )
IAMoneyBar:SetPoint( "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -200, 100 )

function ImproveAny:InitMoneyBar()
	IAMoneyBar.text = IAMoneyBar:CreateFontString(nil, "ARTWORK")
	IAMoneyBar.text:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
	IAMoneyBar.text:SetPoint("CENTER", IAMoneyBar, "CENTER", 0, 0)
	IAMoneyBar.text:SetText(GetCoinTextureString(GetMoney()))

	IAMoneyBar:RegisterEvent("PLAYER_MONEY")
	IAMoneyBar:SetScript("OnEvent", function(self, ...)
		IAMoneyBar.text:SetText( GetCoinTextureString( GetMoney() ) )
	end)

	if IABUILD ~= "RETAIL" then
		GOLD_AMOUNT_SYMBOL = "|TInterface\\MoneyFrame\\UI-GoldIcon:12:12:2:0|t"
		SILVER_AMOUNT_SYMBOL = "|TInterface\\MoneyFrame\\UI-SilverIcon:12:12:2:0|t"
		COPPER_AMOUNT_SYMBOL = "|TInterface\\MoneyFrame\\UI-CopperIcon:12:12:2:0|t"
	end
end
