
local AddOnName, ImproveAny = ...

--local LibDD = LibStub:GetLibrary("LibUIDropDownMenu-4.0")

function ImproveAny:CreateDropdown( opts )
	--[[local CB = LibDD:Create_UIDropDownMenu( opts.name, opts.parent )
	LibDD:UIDropDownMenu_SetWidth( CB, 120 )
	LibDD:UIDropDownMenu_SetText( CB, opts.defaultVal )
	LibDD:UIDropDownMenu_Initialize( CB, function( self, level, menuList )
		local tab = {}
		for i, v in pairs( opts.items ) do
			local info = LibDD:UIDropDownMenu_CreateInfo()
			info.func = self.SetValue
			info.text = v
			info.arg1 = v
			LibDD:UIDropDownMenu_AddButton(info)
		end
	end)
	function CB:SetValue( newValue )
		opts.changeFunc( CB, newValue )
		LibDD:UIDropDownMenu_SetText( CB, newValue )
		CloseDropDownMenus()
	end
	CB:SetPoint("TOPLEFT", 0, -4)
	
	local text = CB:CreateFontString(nil, "ARTWORK")
	text:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
	text:SetPoint("LEFT", CB, "RIGHT", 0, 4)
	text:SetText( ImproveAny:GT(opts.title) )

    return CB]]

	local Menu = LibStub("LibDropDown"):NewButton(opts.parent, "MyMenuButton")
	Menu:SetPoint("TOPLEFT", 0, -4)
	Menu:SetJustifyH("LEFT")
	Menu:SetStyle("DEFAULT")
	Menu:SetText( opts.defaultVal )

	for i, v in pairs( opts.items ) do
		Menu:Add({
			text = v,
			args = {i, v},
			func = function(self, button, key, value)
				opts.changeFunc( Menu, value )
				Menu:SetText( value )
			end
		})
	end

	local text = Menu:CreateFontString(nil, "ARTWORK")
	text:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
	text:SetPoint("LEFT", Menu, "RIGHT", 0, 4)
	text:SetText( ImproveAny:GT(opts.title) )

	return Menu
end
