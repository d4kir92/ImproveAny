
local AddOnName, ImproveAny = ...

function ImproveAny:InitMicroMenu()
	if ImproveAny:GetWoWBuild() == "RETAIL" and ImproveAny:IsEnabled( "MICROMENUCOLORED", true ) then
		local MBTNS = MICRO_BUTTONS
		if MICRO_BUTTONS == nil then
			MBTNS = {
				"CharacterMicroButton",
				"SpellbookMicroButton",
				"TalentMicroButton",
				"AchievementMicroButton",
				"QuestLogMicroButton",
				"GuildMicroButton",
				"LFDMicroButton",
				"CollectionsMicroButton",
				"EJMicroButton",
				"StoreMicroButton",
				"HelpMicroButton",
				"MainMenuMicroButton",
			}
		end

		local IAMBColors = {}
		IAMBColors["CharacterMicroButton"] = 	{	0.34, 	0.64, 	1.00	}
		IAMBColors["SpellbookMicroButton"] = 	{	1.00,	0.58, 	0.64	}
		IAMBColors["TalentMicroButton"] = 		{	0.22, 	1.00, 	0.94	}
		IAMBColors["AchievementMicroButton"] = 	{	1.00, 	0.62, 	0.10	}
		IAMBColors["QuestLogMicroButton"] = 	{	0.96, 	1.00, 	0.00	}
		IAMBColors["GuildMicroButton"] = 		{	0.00, 	1.00, 	0.10	}
		IAMBColors["LFDMicroButton"] = 			{	0.72, 	0.72, 	1.00	}
		IAMBColors["CollectionsMicroButton"] = 	{	1.00, 	0.72, 	0.58	}
		IAMBColors["EJMicroButton"] = 			{	1.00, 	1.00, 	1.00	}
		IAMBColors["StoreMicroButton"] = 		{	1.00, 	0.84, 	0.50	}
		IAMBColors["HelpMicroButton"] = 		{	1.00, 	1.00, 	1.00	}
		IAMBColors["MainMenuMicroButton"] = 	{	1.00, 	0.4, 	0.40	}
		
		for _, mbname in pairs( MBTNS ) do
			local mb = _G[mbname]
			if IAMBColors[mbname] then
				if mb then
					for _, tex in pairs( { mb:GetRegions() } ) do
						if tex:GetAtlas() then
							tex:SetVertexColor( IAMBColors[mbname][1], IAMBColors[mbname][2], IAMBColors[mbname][3] )
						end
					end
				end
			else
				ImproveAny:MSG( "MISSING MICRO BUTTON " .. mbname )
			end
		end
	end
end
