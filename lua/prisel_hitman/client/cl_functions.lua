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
            Derma_StringRequest("Ajouter un modèle factice", "Veuillez entrer un modèle factice à ajouter :", "", function(text)
                addFakeNPCModelEntry(k, text)
            end)
        end
    end
end

function Prisel.Hitman.OpenContracts()
  local frame = vgui.Create("Prisel.Frame")
  frame:SetSize(DarkRP.ScrW * 0.5,DarkRP.ScrH * 0.55)
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
  buttonFaire:DockMargin(DarkRP.ScrW * 0.05,DarkRP.ScrH * 0.015, DarkRP.ScrW * 0.05, DarkRP.ScrH * 0.02)
  buttonFaire:SetText("Faire un contrat")
  buttonFaire:SetFont(DarkRP.Library.Font(10))
  buttonFaire:SetTall(ScrH() * 0.05)
  buttonFaire:SetBackgroundColor(DarkRP.Config.Colors.Red)


  local buttonDevenir = vgui.Create("Prisel.Button", frame)
  buttonDevenir:Dock(BOTTOM)
  buttonDevenir:DockMargin(DarkRP.ScrW * 0.05,DarkRP.ScrH * 0.2, DarkRP.ScrW * 0.05, DarkRP.ScrH * 0.02)
  buttonDevenir:SetText("Devenir Hitman")
  buttonDevenir:SetFont(DarkRP.Library.Font(10))
  buttonDevenir:SetTall(ScrH() * 0.05)
  buttonDevenir:SetBackgroundColor(DarkRP.Config.Colors.Green)
end

local PLAYER = FindMetaTable("Player")

function PLAYER:RequestConfig()
  net.Start("Prisel.Hitman.RequestConfig")
  net.SendToServer()
end