
local AddOnName, ImproveAny = ...

local font = "Interface\\AddOns\\ImproveAny\\media\\Prototype.ttf"
IAOldFonts = IAOldFonts or {}

local BlizDefaultFonts = {
	"STANDARD_TEXT_FONT",
	"UNIT_NAME_FONT",
	"DAMAGE_TEXT_FONT",
	"NAMEPLATE_FONT",
	"NAMEPLATE_SPELLCAST_FONT"
}

local BlizFontObjects = {
	SystemFont_NamePlateCastBar, SystemFont_NamePlateFixed, SystemFont_LargeNamePlateFixed, SystemFont_World, SystemFont_World_ThickOutline,

	SystemFont_Outline_Small, SystemFont_Outline, SystemFont_InverseShadow_Small, SystemFont_Med2, SystemFont_Med3, SystemFont_Shadow_Med3,
	SystemFont_Huge1, SystemFont_Huge1_Outline, SystemFont_OutlineThick_Huge2, SystemFont_OutlineThick_Huge4, SystemFont_OutlineThick_WTF,
	NumberFont_GameNormal, NumberFont_Shadow_Small, NumberFont_OutlineThick_Mono_Small, NumberFont_Shadow_Med, NumberFont_Normal_Med, 
	NumberFont_Outline_Med, NumberFont_Outline_Large, NumberFont_Outline_Huge, Fancy22Font, QuestFont_Huge, QuestFont_Outline_Huge,
	QuestFont_Super_Huge, QuestFont_Super_Huge_Outline, SplashHeaderFont, Game11Font, Game12Font, Game13Font, Game13FontShadow,
	Game15Font, Game18Font, Game20Font, Game24Font, Game27Font, Game30Font, Game32Font, Game36Font, Game48Font, Game48FontShadow,
	Game60Font, Game72Font, Game11Font_o1, Game12Font_o1, Game13Font_o1, Game15Font_o1, QuestFont_Enormous, DestinyFontLarge,
	CoreAbilityFont, DestinyFontHuge, QuestFont_Shadow_Small, MailFont_Large, SpellFont_Small, InvoiceFont_Med, InvoiceFont_Small,
	Tooltip_Med, Tooltip_Small, AchievementFont_Small, ReputationDetailFont, FriendsFont_Normal, FriendsFont_Small, FriendsFont_Large,
	FriendsFont_UserText, GameFont_Gigantic, ChatBubbleFont, Fancy16Font, Fancy18Font, Fancy20Font, Fancy24Font, Fancy27Font, Fancy30Font,
	Fancy32Font, Fancy48Font, SystemFont_NamePlate, SystemFont_LargeNamePlate, GameFontNormal, 

	SystemFont_Tiny2, SystemFont_Tiny, SystemFont_Shadow_Small, SystemFont_Small, SystemFont_Small2, SystemFont_Shadow_Small2, SystemFont_Shadow_Med1_Outline,
	SystemFont_Shadow_Med1, QuestFont_Large, SystemFont_Large, SystemFont_Shadow_Large_Outline, SystemFont_Shadow_Med2, SystemFont_Shadow_Large, 
	SystemFont_Shadow_Large2, SystemFont_Shadow_Huge1, SystemFont_Huge2, SystemFont_Shadow_Huge2, SystemFont_Shadow_Huge3, SystemFont_Shadow_Outline_Huge3,
	SystemFont_Shadow_Outline_Huge2, SystemFont_Med1, SystemFont_WTF2, SystemFont_Outline_WTF2, 
	GameTooltipHeader, System_IME,
}

local function IASaveOld( ele )
	if IAOldFonts[ ele ] == nil then
		IAOldFonts[ ele ] = _G[ ele ]
	end
end

function IAFonts()
	for i, fontName in pairs( BlizDefaultFonts ) do
		IASaveOld( fontName )
		if IAGV( "fontName", "Default" ) == "Default" then
			_G[fontName] = IAOldFonts[fontName]
		else
			_G[fontName] = font
		end
	end

	local ForcedFontSize = {10, 14, 20, 64, 64}
 
	for i, FontObject in pairs( BlizFontObjects ) do
		if FontObject and FontObject.GetFont then
			local oldFont, oldSize, oldStyle = FontObject:GetFont()
			if IAOldFonts[i] == nil then
				IAOldFonts[i] = oldFont
			end

			oldSize = ForcedFontSize[i] or oldSize
			
			if IAGV( "fontName", "Default" ) == "Default" then
				FontObject:SetFont( IAOldFonts[i], oldSize, oldStyle )
			else
				FontObject:SetFont( font, oldSize, oldStyle )
			end
		end
	end
end

local function AddCheckBox( x, y, key, lstr )
	local cb = CreateFrame( "CheckButton", key .. "_CB", IASettings, "UICheckButtonTemplate" ) --CreateFrame("CheckButton", "moversettingsmove", mover, "UICheckButtonTemplate")
	cb:SetSize( 24, 24 )
	cb:SetPoint( "TOPLEFT", IASettings, "TOPLEFT", x, y )
	cb:SetChecked( ImproveAny:IsEnabled( key, true ) )
	cb:SetScript( "OnClick", function( self )
		ImproveAny:SetEnabled( key, self:GetChecked() )

		if IASettings.save then
			IASettings.save:Enable()
		end
	end)

	cb.f = cb:CreateFontString( nil, nil, "GameFontNormal" )
	cb.f:SetPoint( "LEFT", cb, "RIGHT", 0, 0 )
	cb.f:SetText( lstr )
end

function ImproveAny:InitIASettings()
	IASettings = CreateFrame( "FRAME", "IASettings", UIParent )
	IASettings:SetSize( 420, 250 )
	IASettings:SetPoint( "CENTER", UIParent, "CENTER", 0, 0 )

	IASettings:SetFrameStrata( "HIGH" )
	IASettings:SetFrameLevel( 999 )

	IASettings:SetClampedToScreen( true )
	IASettings:SetMovable( true )
	IASettings:EnableMouse( true )
	IASettings:RegisterForDrag( "LeftButton" )
	IASettings:SetScript( "OnDragStart", IASettings.StartMoving )
	IASettings:SetScript( "OnDragStop", function()
		IASettings:StopMovingOrSizing()

		local p1, p2, p3, p4, p5 = IASettings:GetPoint()
		ImproveAny:SetElePoint( "IASettings", p1, _, p3, p4, p5 )
	end )

	IASettings.bg = IASettings:CreateTexture( "IASettings.bg", "BACKGROUND", nil, 7 )
	IASettings.bg:SetAllPoints( IASettings )
	IASettings.bg:SetColorTexture( 0.03, 0.03, 0.03, 1 )

	IASettings.f = IASettings:CreateFontString( nil, nil, "GameFontNormal" )
	IASettings.f:SetPoint( "TOP", IASettings, "TOP", 0, -6 )
	IASettings.f:SetText( "ImproveAny" )

	local sh = 24
	local py = -sh
	local fontNames = {
		["name"] = "fontNames",
		["parent"]= IASettings,
		["title"] = "Ui Font",
		["items"]= { "Default", "Prototype" },
		["defaultVal"] = IAGV( "fontName", "Default" ), 
		["changeFunc"] = function( dropdown_frame, dropdown_val )
			IASV( "fontName", dropdown_val )
			IAFonts()
		end
	}
	local ddfontNames = MACreateDropdown( fontNames )
	ddfontNames:SetPoint( "TOPLEFT", IASettings, "TOPLEFT", 0, -36 );
	--py = py - sh

	IASettings.close = CreateFrame( "BUTTON", "IASettings" .. ".opt.close", IASettings, "UIPanelButtonTemplate" )
	IASettings.close:SetSize( 120, 24 )
	IASettings.close:SetPoint( "TOPLEFT", IASettings, "TOPLEFT", 10, -IASettings:GetHeight() + 24 + 10 )
	IASettings.close:SetText( CLOSE )
	IASettings.close:SetScript("OnClick", function()
		ImproveAny:ToggleSettings()
	end)

	local dbp1, dbp2, dbp3, dbp4, dbp5 = ImproveAny:GetElePoint( "IASettings" )
	if dbp1 and dbp3 then
		IASettings:ClearAllPoints()
		IASettings:SetPoint( dbp1, UIParent, dbp3, dbp4, dbp5 )
	end

	IASettings:Hide()

	IAFonts()
end

function ImproveAny:ToggleSettings()
	if IASettings:IsVisible() then
		IASettings:Hide()
	else
		IASettings:Show()
	end
end
