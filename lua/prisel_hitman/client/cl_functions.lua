function Prisel.Hitman.ConfigMenu()
  local frame = vgui.Create("Prisel.Frame")
  frame:SetSize(DarkRP.ScrW * 0.5,DarkRP.ScrH * 0.5)
  frame:Center()
  frame:SetTitle("Hitman Config")
  frame:MakePopup()

  local panelConfig = vgui.Create("DPanel", frame)
  panelConfig:Dock(FILL)
  panelConfig:DockMargin(DarkRP.ScrW * 0.01, DarkRP.ScrH * 0.08, DarkRP.ScrW * 0.01, DarkRP.ScrH * 0.01)

  function panelConfig:Paint(w, h)
      draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 0, 0, w, h, DarkRP.Config.Colors.Secondary)
  end

  local labelName = vgui.Create("DLabel", panelConfig)
  labelName:SetText("Configuration du système de Hitman")
  labelName:Dock(TOP)
  labelName:SetFont(DarkRP.Library.Font(12))
  labelName:SetContentAlignment(5)
  labelName:SizeToContents()

  local scrollPanel = vgui.Create("DScrollPanel", panelConfig)
  scrollPanel:Dock(FILL)
  scrollPanel:DockMargin(DarkRP.ScrW * 0.01, DarkRP.ScrH * 0.01, DarkRP.ScrW * 0.01, DarkRP.ScrH * 0.01)

  local function createConfigElement(parent, key, value)
      local typeOfValue = type(value)

      if typeOfValue == "table" then return end

      local labelType = vgui.Create("DLabel", parent)
      labelType:Dock(TOP)
      labelType:DockMargin(DarkRP.ScrW * 0.01, 0, DarkRP.ScrW * 0.01, DarkRP.ScrH * 0.01)
      labelType:SetText(key)
      labelType:SetFont(DarkRP.Library.Font(12))
      labelType:SetContentAlignment(5)
      labelType:SizeToContents()

      if typeOfValue == "number" or typeOfValue == "string" then
          local textEntry = vgui.Create("DTextEntry", parent)
          textEntry:SetTall(DarkRP.ScrH * 0.04) -- Adjust the height to make it more compact
          textEntry:SetFont(DarkRP.Library.Font(12))
          textEntry:SetDrawLanguageID(false)
          textEntry:Dock(TOP)
          textEntry:DockMargin(DarkRP.ScrW * 0.01, 0, DarkRP.ScrW * 0.01, DarkRP.ScrH * 0.01)
          textEntry:SetText(tostring(value))
          textEntry:SetPlaceholderText("Actuel: " .. tostring(value)) -- Show the current value as a placeholder

          function textEntry:Paint(w, h)
              draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 0, 0, w, h, DarkRP.Config.Colors.Main)
              self:DrawTextEntryText(color_white, DarkRP.Config.Colors.Secondary, color_white)
          end

          textEntry.OnEnter = function(self)
              local newValue = self:GetValue()
              if typeOfValue == "number" then
                  newValue = tonumber(newValue)
              end
              if newValue ~= nil then
                  Prisel.Hitman.Config[key] = newValue
                  net.Start("Prisel.Hitman.SendConfig")
                  net.WriteTable(Prisel.Hitman.Config)
                  net.SendToServer()
              else
                  print("Erreur : Veuillez entrer une valeur valide pour " .. key .. ".")
              end
          end
      elseif typeOfValue == "boolean" then
          local checkbox = vgui.Create("DCheckBoxLabel", parent)
          checkbox:Dock(TOP)
          checkbox:DockMargin(DarkRP.ScrW * 0.01, DarkRP.ScrH * 0.01, DarkRP.ScrW * 0.01, DarkRP.ScrH * 0.01)
          checkbox:SetText(key)
          checkbox:SetFont(DarkRP.Library.Font(12))
          checkbox:SetValue(value)

          checkbox.OnChange = function(self, val)
              Prisel.Hitman.Config[key] = val
              net.Start("Prisel.Hitman.SendConfig")
              net.WriteTable(Prisel.Hitman.Config)
              net.SendToServer()
          end
      else
          print("Erreur : Type de valeur non pris en charge pour " .. key .. ".")
      end
  end

  local sortedKeys = {}
  for key, _ in pairs(Prisel.Hitman.Config) do
      table.insert(sortedKeys, key)
  end
  table.sort(sortedKeys)

  for _, key in ipairs(sortedKeys) do
      createConfigElement(scrollPanel, key, Prisel.Hitman.Config[key])
  end

    local function createFakeNPCModelEntry(parent, category, value)
        local panelItems = vgui.Create("DPanel", parent)
        panelItems:Dock(TOP)
        panelItems:SetTall(DarkRP.ScrH * 0.04)
        panelItems:DockMargin(DarkRP.ScrW * 0.05, 0, DarkRP.ScrW * 0.05, DarkRP.ScrH * 0.01)

        function panelItems:Paint(w, h)
            draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 0, 0, w, h, DarkRP.Config.Colors.Main)
        end

        local TextEntry = vgui.Create("DTextEntry", panelItems)
        TextEntry:Dock(LEFT)
        TextEntry:DockMargin(DarkRP.ScrW * 0.002, DarkRP.ScrH * 0.002, DarkRP.ScrW * 0.01, DarkRP.ScrH * 0.002)
        TextEntry:SetWide(DarkRP.ScrW * 0.33)
        TextEntry:SetFont(DarkRP.Library.Font(10))
        TextEntry:SetDrawLanguageID(false)
        TextEntry:SetText(value)
        TextEntry:SetPlaceholderText("Actuel: " .. value)

        function TextEntry:Paint(w, h)
            draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 0, 0, w, h, DarkRP.Config.Colors.Secondary)
            draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 1.5, 1.5, w-3, h-3, DarkRP.Config.Colors.Main)
            self:DrawTextEntryText(color_white, DarkRP.Config.Colors.Secondary, color_white)
        end

        local deleteButton = vgui.Create("Prisel.Button", panelItems)
        deleteButton:Dock(RIGHT)
        deleteButton:SetText("-")
        deleteButton:SetFont(DarkRP.Library.Font(10))
        deleteButton:SetWide(DarkRP.ScrW * 0.02)
        deleteButton:SetTall(DarkRP.ScrH * 0.1)
        deleteButton:SetBackgroundColor(DarkRP.Config.Colors.Red)

        function deleteButton:DoClick()
            for k, v in ipairs(Prisel.Hitman.Config.FakeNPCModel[category]) do
                if v == value then
                    table.remove(Prisel.Hitman.Config.FakeNPCModel[category], k)
                    break
                end
            end
            panelItems:Remove()
            net.Start("Prisel.Hitman.SendConfig")
            net.WriteTable(Prisel.Hitman.Config)
            net.SendToServer()
        end
    end

    local function addFakeNPCModelEntry(category, value)
        if not Prisel.Hitman.Config.FakeNPCModel[category] then
            Prisel.Hitman.Config.FakeNPCModel[category] = {}
        end

        table.insert(Prisel.Hitman.Config.FakeNPCModel[category], value)
        createFakeNPCModelEntry(scrollPanel, category, value)
        net.Start("Prisel.Hitman.SendConfig")
        net.WriteTable(Prisel.Hitman.Config)
        net.SendToServer()
    end

    for k, v in pairs(Prisel.Hitman.Config.FakeNPCModel) do
        local labelCateg = vgui.Create("DLabel", scrollPanel)
        labelCateg:Dock(TOP)
        labelCateg:DockMargin(DarkRP.ScrW * 0.01, 0, DarkRP.ScrW * 0.01, DarkRP.ScrH * 0.01)
        labelCateg:SetText(k)
        labelCateg:SetFont(DarkRP.Library.Font(10))
        labelCateg:SetContentAlignment(5)
        labelCateg:SizeToContents()

        for _, value in ipairs(v) do
            createFakeNPCModelEntry(scrollPanel, k, value)
        end

        local addButton = vgui.Create("DButton", scrollPanel)
        addButton:Dock(TOP)
        addButton:DockMargin(DarkRP.ScrW * 0.05, 0, DarkRP.ScrW * 0.05, DarkRP.ScrH * 0.01)
        addButton:SetText("Ajouter")
        addButton:SetFont(DarkRP.Library.Font(10))
        addButton:SetTall(DarkRP.ScrH * 0.04)

        function addButton:Paint(w, h)
            draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 0, 0, w, h, DarkRP.Config.Colors.Main)
        end

        function addButton:DoClick()
            Derma_StringRequest("Ajouter un modèle", "Veuillez entrer un modèle à ajouter :", "", function(text)
                addFakeNPCModelEntry(k, text)
            end)
        end
    end
end

function Prisel.Hitman.OpenContracts()
  local frame = vgui.Create("Prisel.Frame")
  frame:SetSize(DarkRP.ScrW * 0.4,DarkRP.ScrH * 0.55)
  frame:Center()
  frame:SetTitle("Menu Contrat")
  frame:MakePopup()

  local LabelFaire = vgui.Create("DLabel", frame)
  LabelFaire:Dock(TOP)
  LabelFaire:DockMargin(DarkRP.ScrW * 0.05,DarkRP.ScrH * 0.085, DarkRP.ScrW * 0.05,0)
  LabelFaire:SetText("Choisir une cible")
  LabelFaire:SetFont(DarkRP.Library.Font(15))
  LabelFaire:SetContentAlignment(5)
  LabelFaire:SizeToContents()

  local comboboxPlayer = vgui.Create("Prisel.ComboBox", frame)
  comboboxPlayer:Dock(TOP)
  comboboxPlayer:DockMargin(DarkRP.ScrW * 0.05,DarkRP.ScrH * 0.01, DarkRP.ScrW * 0.05,0)
  comboboxPlayer:SetTall(ScrH() * 0.05)

  for k, v in ipairs(player.GetAll()) do
    if v ~= LocalPlayer() then
      comboboxPlayer:AddChoice(v:Nick(), v)
    end
  end

  local lblReason = vgui.Create("DLabel", frame)
  lblReason:Dock(TOP)
  lblReason:DockMargin(DarkRP.ScrW * 0.05,DarkRP.ScrH * 0.01, DarkRP.ScrW * 0.05,0)
  lblReason:SetText("Raison")
  lblReason:SetFont(DarkRP.Library.Font(15))
  lblReason:SetContentAlignment(5)
  lblReason:SizeToContents()

  local reasonEntry = vgui.Create("DTextEntry", frame)
  reasonEntry:Dock(TOP)
  reasonEntry:DockMargin(DarkRP.ScrW * 0.05,DarkRP.ScrH * 0.01, DarkRP.ScrW * 0.05,0)
  reasonEntry:SetFont(DarkRP.Library.Font(10))
  reasonEntry:SetTall(ScrH() * 0.05)
  reasonEntry:SetPlaceholderText("Raison")
  reasonEntry:SetDrawLanguageID(false)

  function reasonEntry:Paint(w, h)
    draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 0, 0, w, h, DarkRP.Config.Colors.Secondary)
    draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 1.5, 1.5, w-3, h-3, DarkRP.Config.Colors.Main)
    self:DrawTextEntryText(color_white, DarkRP.Config.Colors.Secondary, color_white)
  end

  local lblPrice = vgui.Create("DLabel", frame)
  lblPrice:Dock(TOP)
  lblPrice:DockMargin(DarkRP.ScrW * 0.05,DarkRP.ScrH * 0.01, DarkRP.ScrW * 0.05,0)
  lblPrice:SetText("Prix")
  lblPrice:SetFont(DarkRP.Library.Font(15))
  lblPrice:SetContentAlignment(5)
  lblPrice:SizeToContents()

  local priceEntry = vgui.Create("DTextEntry", frame)
  priceEntry:Dock(TOP)
  priceEntry:DockMargin(DarkRP.ScrW * 0.05,DarkRP.ScrH * 0.01, DarkRP.ScrW * 0.05,0)
  priceEntry:SetFont(DarkRP.Library.Font(10))
  priceEntry:SetTall(ScrH() * 0.05)
  priceEntry:SetPlaceholderText("Prix")
  priceEntry:SetDrawLanguageID(false)

  function priceEntry:Paint(w, h)
    draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 0, 0, w, h, DarkRP.Config.Colors.Secondary)
    draw.RoundedBox(DarkRP.Config.RoundedBoxValue, 1.5, 1.5, w-3, h-3, DarkRP.Config.Colors.Main)
    self:DrawTextEntryText(color_white, DarkRP.Config.Colors.Secondary, color_white)
  end

  function priceEntry:Think()
    local text = self:GetText()
    if text ~= "" then
        if not tonumber(text) or string.match(text, "[^%d]") then
            self:SetText(string.gsub(text, "[^%d]", ""))
        end
    end
  end

  local buttonFaire = vgui.Create("Prisel.Button", frame)
  buttonFaire:Dock(TOP)
  buttonFaire:DockMargin(DarkRP.ScrW * 0.05,DarkRP.ScrH * 0.02, DarkRP.ScrW * 0.05, DarkRP.ScrH * 0.01)
  buttonFaire:SetText("Faire un contrat")
  buttonFaire:SetFont(DarkRP.Library.Font(10))
  buttonFaire:SetTall(ScrH() * 0.05)
  buttonFaire:SetBackgroundColor(DarkRP.Config.Colors.Blue)

  function buttonFaire:DoClick()
    if LocalPlayer():IsHitmanMode() then
        notification.AddLegacy("Vous êtes chasseur de primes, vous ne pouvez pas faire de contrat !", NOTIFY_ERROR, 5)
        return
    end

    if not comboboxPlayer:GetSelectedValue() then
        notification.AddLegacy("Vous devez choisir une cible !", NOTIFY_ERROR, 5)
        return
    end

    local reasonText = reasonEntry:GetText()

    if not DarkRP.Library.IsValidReason(reasonText) then
        notification.AddLegacy("La raison est invalide !", NOTIFY_ERROR, 5)
        return
    end
    
    local priceText = priceEntry:GetText()
    local price = tonumber(priceText)
    if not price or price % 1 ~= 0 then
        notification.AddLegacy("Le prix doit être un nombre entier !", NOTIFY_ERROR, 5)
        return
    end

    if price < 0 then
        notification.AddLegacy("Le prix doit être positif !", NOTIFY_ERROR, 5)
        return
    end

    if price > LocalPlayer():getDarkRPVar("money") then
        notification.AddLegacy("Vous n'avez pas assez d'argent !", NOTIFY_ERROR, 5)
        return
    end

    if price > 1000000 then
        notification.AddLegacy("Le prix ne peut pas dépasser 1 000 000 $ !", NOTIFY_ERROR, 5)
        return
    end

    if Prisel.Hitman.Contracts[comboboxPlayer:GetSelectedValue():SteamID64()] then
        notification.AddLegacy("Vous ne pouvez pas faire de contrat sur cette personne.", NOTIFY_ERROR, 5)
        return
    end


    LocalPlayer():SendContrat(comboboxPlayer:GetSelectedValue(), reasonText, price)
  end

  local buttonDevenir = vgui.Create("Prisel.Button", frame)
  buttonDevenir:Dock(TOP)
  buttonDevenir:DockMargin(DarkRP.ScrW * 0.05,0, DarkRP.ScrW * 0.05, 0)
  buttonDevenir:SetText(LocalPlayer():IsHitmanMode() and "Arrêter la traque" or "Rejoindre les chasseurs de primes")
  buttonDevenir:SetFont(DarkRP.Library.Font(10))
  buttonDevenir:SetTall(ScrH() * 0.05)
  buttonDevenir:SetBackgroundColor(LocalPlayer():IsHitmanMode() and DarkRP.Config.Colors.Red or DarkRP.Config.Colors.Green)

  function buttonDevenir:DoClick()
    LocalPlayer():RequestHitman()

    if not LocalPlayer():IsHitmanMode() then
      buttonDevenir:SetText("Arrêter la traque")
      buttonDevenir:SetBackgroundColor(DarkRP.Config.Colors.Red)
    else
      buttonDevenir:SetText("Rejoindre les chasseurs de primes")
      buttonDevenir:SetBackgroundColor(DarkRP.Config.Colors.Green)
    end
  end

  hook.Add("HUDPaint", "Prisel.Hitman.PaintContract", function()
    if not IsValid(frame) then hook.Remove("HUDPaint", "Prisel.Hitman.PaintContract") return end
    local target = comboboxPlayer:GetSelectedValue()
    if IsValid(target) then
    draw.SimpleTextOutlined("Contrat : " .. target:Nick(), DarkRP.Library.Font(15,0, "Montserrat Bold"), ScrW()/2, ScrH() * 0.02, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
    end
  end)
end

local PLAYER = FindMetaTable("Player")

function PLAYER:RequestConfig()
  net.Start("Prisel.Hitman.RequestConfig")
  net.SendToServer()
end

function PLAYER:SendContrat(target, reason, price)
    if not IsValid(target) then return end
    if not isstring(reason) then return end
    if not isnumber(price) then return end

    if not DarkRP.Library.IsValidReason(reason) then return end
    if price < 0 then return end
    if price > 1000000 then return end
    
    net.Start("Prisel.Hitman.HitmanNetworking")
    net.WriteUInt(2, 4)
    net.WriteEntity(target)
    net.WriteString(reason)
    net.WriteInt(price, 20)
    net.SendToServer()
end

function Prisel.Hitman.ShowContracts()
    if not IsValid(LocalPlayer()) then return end
    if not LocalPlayer():IsHitmanMode() then return end

    local frame = vgui.Create("Prisel.Frame")
    frame:SetSize(DarkRP.ScrW * 0.3, DarkRP.ScrH * 0.8)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("Contrats en cours")

    local labelDesc = vgui.Create("DLabel", frame)
    labelDesc:Dock(TOP)
    labelDesc:DockMargin(DarkRP.ScrW * 0.05,DarkRP.ScrH * 0.09, DarkRP.ScrW * 0.05, DarkRP.ScrH * 0.01)
    labelDesc:SetText("Liste des contrats en cours")
    labelDesc:SetFont(DarkRP.Library.Font(12))
    labelDesc:SetTextColor(color_white)
    labelDesc:SetContentAlignment(5)
    labelDesc:SizeToContents()

    local panelList = vgui.Create("DScrollPanel", frame)
    panelList:Dock(FILL)
    panelList:DockMargin(DarkRP.ScrW * 0.05,DarkRP.ScrH * 0.01, DarkRP.ScrW * 0.05, DarkRP.ScrH * 0.01)

    for k, v in pairs(Prisel.Hitman.Contracts) do
        local panel = vgui.Create("DPanel", panelList)
        panel:Dock(TOP)
        panel:DockMargin(0,0,0, DarkRP.ScrH * 0.01)
        panel:SetTall(DarkRP.ScrH * 0.16)
        function panel:Paint(w,h)
            draw.RoundedBox(DarkRP.Config.RoundedBoxValue,0,0,w,h, DarkRP.Config.Colors["Secondary"])
            draw.RoundedBox(DarkRP.Config.RoundedBoxValue,3,3,w-6,h-6, DarkRP.Config.Colors["Main"])
        end

        local nameLbael = vgui.Create("DLabel", panel)
        nameLbael:Dock(TOP)
        nameLbael:DockMargin(DarkRP.ScrW * 0.005,DarkRP.ScrH * 0.01, DarkRP.ScrW * 0.005, 0)
        nameLbael:SetText("Identité: Inconnu")
        nameLbael:SetFont(DarkRP.Library.Font(10))
        nameLbael:SetTextColor(color_white)
        nameLbael:SetContentAlignment(4)
        nameLbael:SizeToContents()

        local nameReason = vgui.Create("DLabel", panel)
        nameReason:Dock(TOP)
        nameReason:DockMargin(DarkRP.ScrW * 0.005,DarkRP.ScrH * 0.01, DarkRP.ScrW * 0.005, 0)
        nameReason:SetText("Raison: " ..v.Reason)
        nameReason:SetFont(DarkRP.Library.Font(10))
        nameReason:SetTextColor(color_white)
        nameReason:SetContentAlignment(4)
        nameReason:SizeToContents()

        local namePrice = vgui.Create("DLabel", panel)
        namePrice:Dock(TOP)
        namePrice:DockMargin(DarkRP.ScrW * 0.005,DarkRP.ScrH * 0.01, DarkRP.ScrW * 0.005, 0)
        namePrice:SetText("Prix: " .. DarkRP.formatMoney(v.Price))
        namePrice:SetFont(DarkRP.Library.Font(10))
        namePrice:SetTextColor(color_white)
        namePrice:SetContentAlignment(4)
        namePrice:SizeToContents()

        local labelHint = vgui.Create("DLabel", panel)
        labelHint:Dock(TOP)
        labelHint:DockMargin(DarkRP.ScrW * 0.005,DarkRP.ScrH * 0.01, DarkRP.ScrW * 0.005, 0)
        labelHint:SetText(Prisel.Hitman.GenerateHints(v.Target))
        labelHint:SetFont(DarkRP.Library.Font(10))
        labelHint:SetTextColor(color_white)
        labelHint:SetContentAlignment(7)
        labelHint:SetWrap(true)
        labelHint:SetAutoStretchVertical(true)

        local _, h = labelHint:GetSize()
        panel:SetTall(h + DarkRP.ScrH * 0.165)

    end
end

concommand.Add("prisel_hitman", function()
    Prisel.Hitman.ShowContracts()
end)

local coords = {
    [1] = {
        coords = Vector(-4616.649902, -5628.497559, 128.031250),
        label = "Mairie",
        prefix = "de la"
    },

    [2] = {
        coords = Vector(596.441956, 2550.659912, 600.031250),
        label = "Taco Bell",
        prefix = "du"
    }
}

function getPlayerNearestCoords(target, prefix)
    local nearest = nil
    local nearestDist = 0

    for k, v in ipairs(coords) do
        local dist = target:GetPos():Distance(v.coords)
        if not nearest or dist < nearestDist then
            nearest = v
            nearestDist = dist
        end
    end

    if not nearest then return end

    return (prefix and (nearest.prefix .. " ") or "") .. nearest.label
end

function Prisel.Hitman.GenerateHints(target)
    local hints = {}

    hints[#hints + 1] = ("Indice : vu près %s"):format(getPlayerNearestCoords(target, true))
    hints[#hints + 1] = ("Indice : Nom commencant par %s"):format(string.sub(target:Nick(), 1, 2))
    hints[#hints + 1] = ("Indice : Son job commence par %s"):format(string.sub(team.GetName(target:Team()), 1, 3))
    if target:Team() == LocalPlayer():Team() then
        hints[#hints + 1] = ("Indice : Il travail dans le même métier que vous.")
    end

    local selectHint = math.random(1, #hints)
    local hint = hints[selectHint]

    return hint
end