local APP = {}
APP.name = "Primes"
APP.icon = "prisel_hitman/logo_prisel_hitman.png"

function APP:ShowCondition()
    return tobool(LocalPlayer():IsHitmanMode())
end

function APP:Open(vMain, iMainX, iMainY)
    vMain:aphone_RemoveCursor()
    function vMain:Paint(w, h)
        surface.SetDrawColor(DarkRP.Config.Colors["Main"])
        surface.DrawRect(0, 0, w, h)
    end
    
    aphone.AddNotif("bell", "Soyez le premier à effectuer le contrat.", 2)

    local vLabelPrime = vMain:Add("DLabel")
    vLabelPrime:SetFont(DarkRP.Library.Font(12, 0, "Montserrat Bold"))
    vLabelPrime:SetText("Contrats en cours")
    vLabelPrime:SetTextColor(color_white)
    vLabelPrime:SetContentAlignment(5)
    vLabelPrime:SizeToContents()
    vLabelPrime:Dock(TOP)
    vLabelPrime:DockMargin(0, iMainY*0.05, 0, 0)

    local vPanelScroll = vMain:Add("DScrollPanel")
    vPanelScroll:SetSize(iMainX*0.9, iMainY*0.8)
    vPanelScroll:Dock(TOP)
    vPanelScroll:DockMargin(iMainX*0.05, iMainY*0.05, iMainX*0.05, 0)
    vPanelScroll:aphone_RemoveCursor()
    vPanelScroll:GetVBar():SetWide(0)

    for k, v in pairs(Prisel.Hitman.Contracts) do

        if not IsValid(v.Target) then continue end

        local vPanelPrime = vPanelScroll:Add("DPanel")
        vPanelPrime:SetSize(vPanelScroll:GetWide(), iMainY*0.23)
        vPanelPrime:Dock(TOP)
        vPanelPrime:DockMargin(0, 0, 0, iMainY*0.01)
        vPanelPrime:aphone_RemoveCursor()

        function vPanelPrime:Paint(w,h)
            draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 0, 0, w, h, DarkRP.Config.Colors["Secondary"])
        end

        local vReason = vPanelPrime:Add("DLabel")
        vReason:SetFont(DarkRP.Library.Font(12))
        vReason:SetText(v.Reason)
        vReason:SetTextColor(color_white)
        vReason:SizeToContents()
        vReason:Dock(TOP)
        vReason:DockMargin(iMainX*0.05, iMainY*0.01, 0, 0)

        local vPrice = vPanelPrime:Add("DLabel")
        vPrice:SetFont(DarkRP.Library.Font(12))
        vPrice:SetText("Récompense : " .. DarkRP.formatMoney(v.Price))
        vPrice:SetTextColor(color_white)
        vPrice:SizeToContents()
        vPrice:Dock(TOP)
        vPrice:DockMargin(iMainX*0.05, iMainY*0.01, 0, 0)

        local vHint = vPanelPrime:Add("DLabel")
        vHint:SetFont(DarkRP.Library.Font(12))
        vHint:SetText(Prisel.Hitman.GenerateHints(v.Target))
        vHint:SetTextColor(color_white)
        vHint:SetWrap(true)
        vHint:SetAutoStretchVertical(true)
        vHint:Dock(TOP)
        vHint:DockMargin(iMainX*0.05, iMainY*0.01, 0, 0)

    end


end

aphone.RegisterApp(APP)