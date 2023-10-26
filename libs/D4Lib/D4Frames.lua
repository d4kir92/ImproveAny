--[[ INPUTS ]]
function D4:AddCategory(tab)
    tab.sw = tab.sw or 25
    tab.sh = tab.sh or 25
    tab.parent = tab.parent or UIParent
    tab.pTab = tab.pTab or "CENTER"
    tab.parent.f = tab.parent:CreateFontString(nil, nil, "GameFontNormal")
    tab.parent.f:SetPoint(unpack(tab.pTab))
    tab.parent.f:SetText(D4:Trans(tab.name))
end

function D4:CreateCheckbox(tab)
    tab.sw = tab.sw or 25
    tab.sh = tab.sh or 25
    tab.parent = tab.parent or UIParent
    tab.pTab = tab.pTab or "CENTER"
    tab.value = tab.value or nil
    local cb = CreateFrame("CheckButton", tab.name, tab.parent, "UICheckButtonTemplate")
    cb:SetSize(tab.sw, tab.sh)
    cb:SetPoint(unpack(tab.pTab))
    cb:SetChecked(tab.value)
    cb:SetScript(
        "OnClick",
        function(sel)
            tab:funcV(sel:GetChecked())
        end
    )

    cb.f = cb:CreateFontString(nil, nil, "GameFontNormal")
    cb.f:SetPoint("LEFT", cb, "RIGHT", 0, 0)
    cb.f:SetText(D4:Trans(tab.name))

    return cb
end

function D4:CreateCheckboxForCVAR(tab)
    tab.sw = tab.sw or 25
    tab.sh = tab.sh or 25
    tab.parent = tab.parent or UIParent
    tab.pTab = tab.pTab or "CENTER"
    tab.value = tab.value or nil
    local cb = D4:CreateCheckbox(tab)
    local cb2 = CreateFrame("CheckButton", tab.name, tab.parent, "UICheckButtonTemplate")
    cb2:SetSize(tab.sw, tab.sh)
    local p1, p2, p3 = unpack(tab.pTab)
    cb2:SetPoint(p1, p2 + 25, p3)
    cb2:SetChecked(tab.value2)
    cb2:SetScript(
        "OnClick",
        function(sel)
            tab:funcV2(sel:GetChecked())
        end
    )

    cb.f:SetPoint("LEFT", cb, "RIGHT", 25, 0)

    return cb
end

function D4:CreateEditBox(tab)
    tab.sw = tab.sw or 200
    tab.sh = tab.sh or 25
    tab.parent = tab.parent or UIParent
    tab.pTab = tab.pTab or "CENTER"
    tab.value = tab.value or nil
    local cb = CreateFrame("EditBox", tab.name, tab.parent, "InputBoxTemplate")
    cb:SetSize(tab.sw, tab.sh)
    cb:SetPoint(unpack(tab.pTab))
    cb:SetText(tab.value)
    cb:SetScript(
        "OnTextChanged",
        function(sel)
            tab:funcV(sel:GetText())
        end
    )

    cb.f = cb:CreateFontString(nil, nil, "GameFontNormal")
    cb.f:SetPoint("LEFT", cb, "RIGHT", 0, 0)
    cb.f:SetText(D4:Trans(tab.name))

    return cb
end

function D4:CreateSlider(tab)
    tab.sw = tab.sw or 200
    tab.sh = tab.sh or 25
    tab.parent = tab.parent or UIParent
    tab.pTab = tab.pTab or "CENTER"
    tab.value = tab.value or nil
    tab.vmin = tab.vmin or 1
    tab.vmax = tab.vmax or 1
    tab.steps = tab.steps or 1
    tab.key = tab.key or tab.name or ""
    local slider = CreateFrame("Slider", tab.name, tab.parent, "OptionsSliderTemplate")
    slider:SetWidth(tab.sw)
    slider:SetPoint(unpack(tab.pTab))
    slider.Low:SetText(tab.vmin)
    slider.High:SetText(tab.vmax)
    slider.Text:SetText(format("%s: %s", D4:Trans(tab.key), tab.value))
    slider:SetMinMaxValues(tab.vmin, tab.vmax)
    slider:SetObeyStepOnDrag(true)
    slider:SetValueStep(tab.steps)
    slider:SetValue(tab.value)
    slider:SetScript(
        "OnValueChanged",
        function(sel, val)
            val = string.format("%" .. tab.steps .. "f", val)
            tab:funcV(val)
            slider.Text:SetText(format("%s: %s", D4:Trans(tab.key), val))
        end
    )

    return slider
end

--[[ FRAMES ]]
function D4:CreateFrame(tab)
    tab.sw = tab.sw or 100
    tab.sh = tab.sh or 100
    tab.parent = tab.parent or UIParent
    tab.pTab = tab.pTab or "CENTER"
    tab.title = tab.title or ""
    tab.templates = tab.templates or "BasicFrameTemplateWithInset"
    local fra = CreateFrame("FRAME", tab.name, tab.parent, tab.templates)
    fra:SetSize(tab.sw, tab.sh)
    fra:SetPoint(unpack(tab.pTab))
    fra:SetClampedToScreen(true)
    fra:SetMovable(true)
    fra:EnableMouse(true)
    fra:RegisterForDrag("LeftButton")
    fra:SetScript("OnDragStart", fra.StartMoving)
    fra:SetScript("OnDragStop", fra.StopMovingOrSizing)
    fra:Hide()
    fra.TitleText:SetText(tab.title)

    return fra
end