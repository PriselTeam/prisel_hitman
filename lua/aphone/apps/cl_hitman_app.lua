local APP = {}
APP.name = "Primes"
APP.color = Color( 255, 50, 50)
APP.icon = "akulla/aphone/app_bank.png"

function APP:ShowCondition()
    return tobool(LocalPlayer():IsHitmanMode())
end

function APP:Open(vMain, iMainX, iMainY)
    vMain:aphone_RemoveCursor()
    function vMain:Paint(w, h)
        surface.SetDrawColor(DarkRP.Config.Colors["Main"])
        surface.DrawRect(0, 0, w, h)

        
        draw.SimpleText("Primes en cours", DarkRP.Library.Font(12), w/2, h*0.08, color_white, TEXT_ALIGN_CENTER)
    end
end

aphone.RegisterApp(APP)