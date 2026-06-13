local Menu = {}
Menu.Visible = false
Menu.CurrentCategory = 2
Menu.CurrentPage = 1
Menu.ItemsPerPage = 8          -- más ítems por página
Menu.scrollbarY = nil
Menu.scrollbarHeight = nil
Menu.OpenedCategory = nil
Menu.CurrentItem = 1
Menu.CurrentTab = 1
Menu.ItemScrollOffset = 0
Menu.CategoryScrollOffset = 0
Menu.EditorDragging = false
Menu.EditorDragOffsetX = 0
Menu.EditorDragOffsetY = 0
Menu.EditorMode = false
Menu.ShowSnowflakes = false
Menu.SelectorY = 0
Menu.CategorySelectorY = 0
Menu.TabSelectorX = 0
Menu.TabSelectorWidth = 0
Menu.SmoothFactor = 0.2
Menu.GradientType = 1
Menu.ScrollbarPosition = 1   -- 1=izquierda, 2=derecha, pero aquí lo ocultamos

Menu.LoadingBarAlpha = 0.0
Menu.KeySelectorAlpha = 0.0
Menu.KeybindsInterfaceAlpha = 0.0

Menu.LoadingProgress = 0.0
Menu.IsLoading = true
Menu.LoadingComplete = false
Menu.LoadingStartTime = nil
Menu.LoadingDuration = 3000

Menu.SelectingKey = false
Menu.SelectedKey = nil
Menu.SelectedKeyName = nil

Menu.SelectingBind = false
Menu.BindingItem = nil
Menu.BindingKey = nil
Menu.BindingKeyName = nil

Menu.ShowKeybinds = false
Menu.CurrentTopTab = 1

-- ========== NUEVO ESTILO CYBERPUNK TERMINAL ==========
Menu.Colors = {
    Bg = { r = 6, g = 8, b = 12 },           -- fondo principal oscuro
    Card = { r = 12, g = 16, b = 24 },        -- fondo de tarjetas
    Border = { r = 0, g = 255, b = 255 },     -- borde neón cian
    Accent = { r = 255, g = 0, b = 255 },     -- magenta para acentos
    Warn = { r = 255, g = 240, b = 0 },       -- amarillo para advertencias
    Text = { r = 220, g = 230, b = 255 },     -- texto principal
    TextDim = { r = 120, g = 140, b = 180 },  -- texto secundario
}

Menu.CurrentTheme = "Cyberpunk"

function Menu.ApplyTheme(themeName)
    -- Solo soportamos este tema, pero mantenemos la función por compatibilidad
    if themeName then end
    Menu.Colors.Bg = { r = 6, g = 8, b = 12 }
    Menu.Colors.Card = { r = 12, g = 16, b = 24 }
    Menu.Colors.Border = { r = 0, g = 255, b = 255 }
    Menu.Colors.Accent = { r = 255, g = 0, b = 255 }
    Menu.Colors.Warn = { r = 255, g = 240, b = 0 }
    Menu.Colors.Text = { r = 220, g = 230, b = 255 }
    Menu.Colors.TextDim = { r = 120, g = 140, b = 180 }
    if Menu.Banner.enabled and Menu.Banner.imageUrl then
        Menu.LoadBannerTexture(Menu.Banner.imageUrl)
    end
end

-- Dimensiones del nuevo menú (más ancho)
Menu.Position = {
    x = 100,
    y = 80,
    width = 900,
    itemHeight = 48,
    mainMenuHeight = 0,   -- ya no se usa, las categorías son horizontales
    headerHeight = 60,
    footerHeight = 32,
    footerSpacing = 8,
    mainMenuSpacing = 12,
    footerRadius = 0,
    itemRadius = 6,
    scrollbarWidth = 0,   -- ocultamos scrollbar, usamos navegación por páginas
    scrollbarPadding = 0,
    headerRadius = 0
}
Menu.Scale = 1.0

function Menu.GetScaledPosition()
    local scale = Menu.Scale or 1.0
    return {
        x = Menu.Position.x,
        y = Menu.Position.y,
        width = Menu.Position.width * scale,
        itemHeight = Menu.Position.itemHeight * scale,
        mainMenuHeight = Menu.Position.mainMenuHeight * scale,
        headerHeight = Menu.Position.headerHeight * scale,
        footerHeight = Menu.Position.footerHeight * scale,
        footerSpacing = Menu.Position.footerSpacing * scale,
        mainMenuSpacing = Menu.Position.mainMenuSpacing * scale,
        footerRadius = Menu.Position.footerRadius * scale,
        itemRadius = Menu.Position.itemRadius * scale,
        scrollbarWidth = Menu.Position.scrollbarWidth * scale,
        scrollbarPadding = Menu.Position.scrollbarPadding * scale,
        headerRadius = Menu.Position.headerRadius * scale
    }
end

-- Funciones de dibujo optimizadas
function Menu.DrawRect(x, y, w, h, r, g, b, a)
    a = a or 1.0
    if r > 1.0 then r = r/255.0 end
    if g > 1.0 then g = g/255.0 end
    if b > 1.0 then b = b/255.0 end
    if a > 1.0 then a = a/255.0 end
    if Susano.DrawFilledRect then
        Susano.DrawFilledRect(x, y, w, h, r, g, b, a)
    elseif Susano.FillRect then
        Susano.FillRect(x, y, w, h, r, g, b, a)
    elseif Susano.DrawRect then
        for i=0, h-1 do Susano.DrawRect(x, y+i, w, 1, r, g, b, a) end
    end
end

function Menu.DrawText(x, y, text, size, r, g, b, a)
    local scale = Menu.Scale or 1.0
    size = (size or 16) * scale
    if r > 1.0 then r = r/255.0 end
    if g > 1.0 then g = g/255.0 end
    if b > 1.0 then b = b/255.0 end
    if a > 1.0 then a = a/255.0 end
    Susano.DrawText(x, y, text, size, r, g, b, a)
end

function Menu.DrawRoundedRect(x, y, w, h, r, g, b, a, radius)
    radius = radius or 0
    if radius <= 0 then
        Menu.DrawRect(x, y, w, h, r, g, b, a)
        return
    end
    Menu.DrawRect(x+radius, y, w-2*radius, h, r, g, b, a)
    Menu.DrawRect(x, y+radius, radius, h-2*radius, r, g, b, a)
    Menu.DrawRect(x+w-radius, y+radius, radius, h-2*radius, r, g, b, a)
    for i=0, radius-1 do
        local sw = math.ceil(math.sqrt(radius*radius - i*i))
        local ty = y+radius-1-i
        Menu.DrawRect(x+radius-sw, ty, sw, 1, r, g, b, a)
        Menu.DrawRect(x+w-radius, ty, sw, 1, r, g, b, a)
        local by = y+h-radius+i
        Menu.DrawRect(x+radius-sw, by, sw, 1, r, g, b, a)
        Menu.DrawRect(x+w-radius, by, sw, 1, r, g, b, a)
    end
end

-- Header minimalista con título neón
function Menu.DrawHeader()
    local p = Menu.GetScaledPosition()
    local x, y, w = p.x, p.y, p.width
    local h = p.headerHeight
    Menu.DrawRect(x, y, w, h, Menu.Colors.Bg.r, Menu.Colors.Bg.g, Menu.Colors.Bg.b, 255)
    Menu.DrawRect(x, y+h-2, w, 2, Menu.Colors.Border.r, Menu.Colors.Border.g, Menu.Colors.Border.b, 255)
    local title = ">_ TERMINAL v2.0"
    local fontSize = 24
    local tw = Susano.GetTextWidth and Susano.GetTextWidth(title, fontSize) or (string.len(title)*12)
    Menu.DrawText(x+20, y+h/2-fontSize/2, title, fontSize, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255)
end

-- Footer minimalista
function Menu.DrawFooter()
    local p = Menu.GetScaledPosition()
    local x = p.x
    local y = p.y + p.headerHeight + (Menu.OpenedCategory and (p.itemHeight * Menu.ItemsPerPage + 40) or (p.itemHeight * (#Menu.Categories-1) + 40))
    local w = p.width
    local h = p.footerHeight
    Menu.DrawRect(x, y, w, h, Menu.Colors.Bg.r, Menu.Colors.Bg.g, Menu.Colors.Bg.b, 230)
    Menu.DrawRect(x, y, w, 1, Menu.Colors.Border.r, Menu.Colors.Border.g, Menu.Colors.Border.b, 120)
    local text = " .gg/sentexmodz  |  ← → categorías  |  ↑ ↓ items  |  F9 keybind"
    local fontSize = 12
    Menu.DrawText(x+15, y+h/2-fontSize/2, text, fontSize, Menu.Colors.TextDim.r, Menu.Colors.TextDim.g, Menu.Colors.TextDim.b, 200)
    -- Página actual
    local page = ""
    if Menu.OpenedCategory then
        local cat = Menu.Categories[Menu.OpenedCategory]
        if cat and cat.hasTabs and cat.tabs then
            local tab = cat.tabs[Menu.CurrentTab]
            if tab and tab.items then
                page = string.format("%d/%d", Menu.CurrentItem, #tab.items)
            end
        end
    else
        page = string.format("%d/%d", Menu.CurrentCategory-1, #Menu.Categories-1)
    end
    if page ~= "" then
        local pw = Susano.GetTextWidth and Susano.GetTextWidth(page, fontSize) or (string.len(page)*6)
        Menu.DrawText(x+w-pw-15, y+h/2-fontSize/2, page, fontSize, Menu.Colors.Text.r, Menu.Colors.Text.g, Menu.Colors.Text.b, 255)
    end
end

-- Barra de categorías (horizontal) con estilo de "pestañas grandes"
function Menu.DrawCategories()
    if Menu.OpenedCategory then
        -- Dibujar el contenido de la categoría abierta
        local cat = Menu.Categories[Menu.OpenedCategory]
        if not cat or not cat.hasTabs or not cat.tabs then
            Menu.OpenedCategory = nil
            return
        end

        local p = Menu.GetScaledPosition()
        local x = p.x + 20
        local y = p.y + p.headerHeight + 20
        local w = p.width - 40
        local itemH = p.itemHeight
        local spacing = 10

        -- Pestañas (si hay tabs)
        if #cat.tabs > 1 then
            local tabW = 140
            local tabH = 32
            for i, tab in ipairs(cat.tabs) do
                local tabX = x + (i-1)*(tabW+5)
                local isSel = (i == Menu.CurrentTab)
                Menu.DrawRoundedRect(tabX, y, tabW, tabH, Menu.Colors.Card.r, Menu.Colors.Card.g, Menu.Colors.Card.b, isSel and 255 or 150, 4)
                if isSel then
                    Menu.DrawRect(tabX, y+tabH-2, tabW, 2, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255)
                end
                local tw = Susano.GetTextWidth and Susano.GetTextWidth(tab.name, 14) or (string.len(tab.name)*7)
                Menu.DrawText(tabX+tabW/2-tw/2, y+tabH/2-7, tab.name, 14, Menu.Colors.Text.r, Menu.Colors.Text.g, Menu.Colors.Text.b, 255)
            end
            y = y + tabH + spacing
        end

        -- Lista de items
        local curTab = cat.tabs[Menu.CurrentTab]
        if curTab and curTab.items then
            local total = #curTab.items
            local maxVis = Menu.ItemsPerPage
            if Menu.CurrentItem > Menu.ItemScrollOffset + maxVis then
                Menu.ItemScrollOffset = Menu.CurrentItem - maxVis
            elseif Menu.CurrentItem <= Menu.ItemScrollOffset then
                Menu.ItemScrollOffset = math.max(0, Menu.CurrentItem - 1)
            end
            for i=1, math.min(maxVis, total) do
                local idx = i + Menu.ItemScrollOffset
                if idx <= total then
                    local itemY = y + (i-1)*itemH
                    local isSel = (idx == Menu.CurrentItem)
                    Menu.DrawRoundedRect(x, itemY, w, itemH-2, Menu.Colors.Card.r, Menu.Colors.Card.g, Menu.Colors.Card.b, isSel and 255 or 180, 4)
                    if isSel then
                        Menu.DrawRect(x, itemY, 4, itemH-2, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255)
                    end
                    local item = curTab.items[idx]
                    local textX = x + 16
                    local textY = itemY + (itemH-2)/2 - 8
                    Menu.DrawText(textX, textY, item.name, 16, Menu.Colors.Text.r, Menu.Colors.Text.g, Menu.Colors.Text.b, 255)
                    -- Dibujar controles (toggle, slider, selector) estilo terminal
                    if item.type == "toggle" then
                        local toggleW = 50
                        local toggleH = 22
                        local toggleX = x + w - toggleW - 16
                        local toggleY = itemY + (itemH-2)/2 - toggleH/2
                        if item.value then
                            Menu.DrawRoundedRect(toggleX, toggleY, toggleW, toggleH, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255, 11)
                        else
                            Menu.DrawRoundedRect(toggleX, toggleY, toggleW, toggleH, 40, 40, 60, 255, 11)
                        end
                        local knobSize = toggleH - 6
                        local knobX = item.value and (toggleX + toggleW - knobSize - 3) or (toggleX + 3)
                        Menu.DrawRoundedRect(knobX, toggleY+3, knobSize, knobSize, 255,255,255, 255, knobSize/2)
                    elseif item.type == "slider" then
                        local sliderW = 120
                        local sliderH = 6
                        local sliderX = x + w - sliderW - 80
                        local sliderY = itemY + (itemH-2)/2 - sliderH/2
                        local minV = item.min or 0
                        local maxV = item.max or 100
                        local val = item.value or minV
                        local percent = (val - minV) / (maxV - minV)
                        percent = math.min(1, math.max(0, percent))
                        Menu.DrawRect(sliderX, sliderY, sliderW, sliderH, Menu.Colors.TextDim.r, Menu.Colors.TextDim.g, Menu.Colors.TextDim.b, 100)
                        if percent > 0 then
                            Menu.DrawRect(sliderX, sliderY, sliderW*percent, sliderH, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255)
                        end
                        local thumbSize = 10
                        local thumbX = sliderX + sliderW*percent - thumbSize/2
                        local thumbY = sliderY + sliderH/2 - thumbSize/2
                        Menu.DrawRoundedRect(thumbX, thumbY, thumbSize, thumbSize, 255,255,255, 255, thumbSize/2)
                        local valText = string.format("%.0f", val)
                        local tw = Susano.GetTextWidth and Susano.GetTextWidth(valText, 12) or (string.len(valText)*6)
                        Menu.DrawText(sliderX+sliderW+10, sliderY-2, valText, 12, Menu.Colors.Text.r, Menu.Colors.Text.g, Menu.Colors.Text.b, 200)
                    elseif item.type == "selector" and item.options then
                        local idxSel = item.selected or 1
                        local opt = item.options[idxSel] or ""
                        local fullText = "< " .. opt .. " >"
                        local tw = Susano.GetTextWidth and Susano.GetTextWidth(fullText, 15) or (string.len(fullText)*8)
                        local tx = x + w - tw - 16
                        Menu.DrawText(tx, textY, fullText, 15, Menu.Colors.TextDim.r, Menu.Colors.TextDim.g, Menu.Colors.TextDim.b, 255)
                    elseif item.type == "toggle_selector" then
                        local toggleW = 44
                        local toggleH = 20
                        local toggleX = x + w - toggleW - 16
                        local toggleY = itemY + (itemH-2)/2 - toggleH/2
                        if item.value then
                            Menu.DrawRoundedRect(toggleX, toggleY, toggleW, toggleH, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255, 10)
                        else
                            Menu.DrawRoundedRect(toggleX, toggleY, toggleW, toggleH, 40,40,60, 255, 10)
                        end
                        local knobSize = toggleH - 4
                        local knobX = item.value and (toggleX + toggleW - knobSize - 2) or (toggleX + 2)
                        Menu.DrawRoundedRect(knobX, toggleY+2, knobSize, knobSize, 255,255,255, 255, knobSize/2)
                        -- selector de opciones
                        if item.options then
                            local selIdx = item.selected or 1
                            local opt = item.options[selIdx] or ""
                            local optText = "< " .. opt .. " >"
                            local tw = Susano.GetTextWidth and Susano.GetTextWidth(optText, 13) or (string.len(optText)*7)
                            local optX = toggleX - tw - 10
                            Menu.DrawText(optX, textY, optText, 13, Menu.Colors.TextDim.r, Menu.Colors.TextDim.g, Menu.Colors.TextDim.b, 200)
                        end
                    end
                end
            end
        end
        return
    end

    -- Vista de categorías principales (horizontal)
    local p = Menu.GetScaledPosition()
    local x = p.x + 20
    local y = p.y + p.headerHeight + 20
    local w = p.width - 40
    local itemH = p.itemHeight
    local cats = {}
    for i=2, #Menu.Categories do
        table.insert(cats, Menu.Categories[i])
    end
    local totalCats = #cats
    local maxVis = Menu.ItemsPerPage
    if Menu.CurrentCategory - 1 > Menu.CategoryScrollOffset + maxVis then
        Menu.CategoryScrollOffset = (Menu.CurrentCategory - 1) - maxVis
    elseif Menu.CurrentCategory - 1 <= Menu.CategoryScrollOffset then
        Menu.CategoryScrollOffset = math.max(0, (Menu.CurrentCategory - 1) - 1)
    end
    for i=1, math.min(maxVis, totalCats) do
        local idx = i + Menu.CategoryScrollOffset
        if idx <= totalCats then
            local cat = cats[idx]
            local catY = y + (i-1)*itemH
            local isSel = (idx+1 == Menu.CurrentCategory)
            Menu.DrawRoundedRect(x, catY, w, itemH-2, Menu.Colors.Card.r, Menu.Colors.Card.g, Menu.Colors.Card.b, isSel and 255 or 180, 4)
            if isSel then
                Menu.DrawRect(x, catY, 4, itemH-2, Menu.Colors.Border.r, Menu.Colors.Border.g, Menu.Colors.Border.b, 255)
            end
            local textX = x + 20
            local textY = catY + (itemH-2)/2 - 8
            Menu.DrawText(textX, textY, cat.name, 18, Menu.Colors.Text.r, Menu.Colors.Text.g, Menu.Colors.Text.b, 255)
            Menu.DrawText(x+w-30, textY, "▶", 14, Menu.Colors.Border.r, Menu.Colors.Border.g, Menu.Colors.Border.b, 200)
        end
    end
    -- Top tabs (si existen) los mostramos arriba de las categorías
    if Menu.TopLevelTabs then
        local tabY = y - 40
        local tabW = 120
        for i, tab in ipairs(Menu.TopLevelTabs) do
            local tabX = x + (i-1)*(tabW+10)
            local isSel = (i == Menu.CurrentTopTab)
            Menu.DrawRoundedRect(tabX, tabY, tabW, 30, Menu.Colors.Card.r, Menu.Colors.Card.g, Menu.Colors.Card.b, isSel and 255 or 150, 4)
            if isSel then
                Menu.DrawRect(tabX, tabY+28, tabW, 2, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255)
            end
            local tw = Susano.GetTextWidth and Susano.GetTextWidth(tab.name, 14) or (string.len(tab.name)*7)
            Menu.DrawText(tabX+tabW/2-tw/2, tabY+15-7, tab.name, 14, Menu.Colors.Text.r, Menu.Colors.Text.g, Menu.Colors.Text.b, 255)
        end
    end
end

function Menu.DrawBackground()
    local p = Menu.GetScaledPosition()
    local x = p.x
    local y = p.y
    local w = p.width
    local h = 700 -- altura dinámica aproximada, pero no importa
    Menu.DrawRect(x, y, w, h, Menu.Colors.Bg.r, Menu.Colors.Bg.g, Menu.Colors.Bg.b, 240)
    Menu.DrawRect(x, y, w, 1, Menu.Colors.Border.r, Menu.Colors.Border.g, Menu.Colors.Border.b, 80)
    Menu.DrawRect(x, y+h-1, w, 1, Menu.Colors.Border.r, Menu.Colors.Border.g, Menu.Colors.Border.b, 80)
end

-- Barra de carga lineal
function Menu.DrawLoadingBar(alpha)
    if alpha <= 0 then return end
    local sw, sh = 1920, 1080
    if Susano.GetScreenWidth then sw, sh = Susano.GetScreenWidth(), Susano.GetScreenHeight() end
    local w = 400
    local h = 6
    local x = sw/2 - w/2
    local y = sh - 100
    Menu.DrawRect(x, y, w, h, 30,30,50, 200*alpha)
    Menu.DrawRect(x, y, w * (Menu.LoadingProgress/100), h, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255*alpha)
    local percent = string.format("%.0f%%", Menu.LoadingProgress)
    local tw = Susano.GetTextWidth and Susano.GetTextWidth(percent, 14) or (string.len(percent)*7)
    Menu.DrawText(x+w/2-tw/2, y-20, percent, 14, Menu.Colors.Text.r, Menu.Colors.Text.g, Menu.Colors.Text.b, 255*alpha)
    local text = "INICIANDO..."
    if Menu.LoadingProgress >= 100 then text = "LISTO" end
    local tw2 = Susano.GetTextWidth and Susano.GetTextWidth(text, 14) or (string.len(text)*7)
    Menu.DrawText(x+w/2-tw2/2, y-40, text, 14, Menu.Colors.Border.r, Menu.Colors.Border.g, Menu.Colors.Border.b, 255*alpha)
end

-- Selector de teclas estilo terminal
function Menu.DrawKeySelector(alpha)
    if alpha <= 0 then return end
    local sw, sh = 1920, 1080
    if Susano.GetScreenWidth then sw, sh = Susano.GetScreenWidth(), Susano.GetScreenHeight() end
    local w = 400
    local h = 120
    local x = sw/2 - w/2
    local y = sh - 180
    Menu.DrawRoundedRect(x, y, w, h, Menu.Colors.Bg.r, Menu.Colors.Bg.g, Menu.Colors.Bg.b, 230*alpha, 8)
    Menu.DrawRect(x, y, w, 2, Menu.Colors.Border.r, Menu.Colors.Border.g, Menu.Colors.Border.b, 200*alpha)
    local title = "> ASIGNAR TECLA"
    Menu.DrawText(x+20, y+15, title, 16, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255*alpha)
    local itemName = Menu.BindingItem and Menu.BindingItem.name or "Opción"
    local keyName = Menu.BindingKeyName or "..."
    Menu.DrawText(x+20, y+45, itemName, 15, Menu.Colors.Text.r, Menu.Colors.Text.g, Menu.Colors.Text.b, 255*alpha)
    Menu.DrawText(x+20, y+70, "Presiona cualquier tecla...", 12, Menu.Colors.TextDim.r, Menu.Colors.TextDim.g, Menu.Colors.TextDim.b, 180*alpha)
    local boxW = 70
    local boxH = 40
    local boxX = x + w - boxW - 20
    local boxY = y + h/2 - boxH/2
    Menu.DrawRect(boxX, boxY, boxW, boxH, Menu.Colors.Card.r, Menu.Colors.Card.g, Menu.Colors.Card.b, 255*alpha)
    Menu.DrawRect(boxX, boxY, boxW, 1, Menu.Colors.Border.r, Menu.Colors.Border.g, Menu.Colors.Border.b, 200*alpha)
    local kw = Susano.GetTextWidth and Susano.GetTextWidth(keyName, 18) or (string.len(keyName)*9)
    Menu.DrawText(boxX+boxW/2-kw/2, boxY+boxH/2-9, keyName, 18, Menu.Colors.Warn.r, Menu.Colors.Warn.g, Menu.Colors.Warn.b, 255*alpha)
end

-- Panel de teclas rápidas (lateral derecho)
function Menu.DrawKeybindsInterface(alpha)
    if alpha <= 0 then return end
    local sw, sh = 1920, 1080
    if Susano.GetScreenWidth then sw, sh = Susano.GetScreenWidth(), Susano.GetScreenHeight() end
    local binds = {}
    for _,cat in ipairs(Menu.Categories) do
        if cat.hasTabs and cat.tabs then
            for _,tab in ipairs(cat.tabs) do
                if tab.items then
                    for _,it in ipairs(tab.items) do
                        if it.bindKey and it.bindKeyName and (it.type=="toggle" or it.type=="action") then
                            table.insert(binds, {name=it.name, key=it.bindKeyName, active=it.type=="toggle" and it.value})
                        end
                    end
                end
            end
        end
    end
    if #binds == 0 then return end
    local w = 240
    local h = 40 + #binds * 26
    local x = sw - w - 20
    local y = 80
    Menu.DrawRoundedRect(x, y, w, h, Menu.Colors.Bg.r, Menu.Colors.Bg.g, Menu.Colors.Bg.b, 200*alpha, 6)
    Menu.DrawRect(x, y, w, 1, Menu.Colors.Border.r, Menu.Colors.Border.g, Menu.Colors.Border.b, 150*alpha)
    Menu.DrawText(x+15, y+10, "KEYBINDS", 13, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255*alpha)
    for i, bind in ipairs(binds) do
        local lineY = y + 35 + (i-1)*24
        local text = bind.name .. "  [" .. bind.key .. "]"
        if bind.active ~= nil then
            text = text .. (bind.active and "  ✓" or "  ✗")
        end
        Menu.DrawText(x+15, lineY, text, 12, Menu.Colors.Text.r, Menu.Colors.Text.g, Menu.Colors.Text.b, 200*alpha)
    end
end

-- Función para omitir separadores (igual)
local function findNextNonSeparator(items, startIndex, direction)
    local idx = startIndex
    local attempts = 0
    while attempts < #items do
        idx = idx + direction
        if idx < 1 then idx = #items
        elseif idx > #items then idx = 1 end
        if items[idx] and not items[idx].isSeparator then return idx end
        attempts = attempts + 1
    end
    return startIndex
end

-- ========== MANEJO DE ENTRADA (navegación innovadora) ==========
Menu.KeyStates = {}
function Menu.IsKeyJustPressed(keyCode)
    if not Susano.GetAsyncKeyState then return false end
    local down, pressed = Susano.GetAsyncKeyState(keyCode)
    local wasDown = Menu.KeyStates[keyCode] or false
    Menu.KeyStates[keyCode] = down == true
    return (pressed == true) or (down == true and not wasDown)
end

-- Lista completa de teclas capturables
local captureKeys = {
    0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,
    0x4E,0x4F,0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A,
    0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,
    0x20,0x1B,0x08,0x09,0x10,0x11,0x12,
    0x25,0x26,0x27,0x28,
    0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A,0x7B,
    0x2D,0x2E,0x21,0x22,0x23,0x24
}
Menu.KeyNames = {
    [0x08]="Retroceso", [0x09]="Tabulador", [0x0D]="Intro", [0x10]="Mayús",
    [0x11]="Ctrl", [0x12]="Alt", [0x13]="Pausa", [0x14]="Bloq Mayús",
    [0x1B]="ESC", [0x20]="Espacio", [0x21]="Re Pág", [0x22]="Av Pág",
    [0x23]="Fin", [0x24]="Inicio", [0x25]="Izquierda", [0x26]="Arriba",
    [0x27]="Derecha", [0x28]="Abajo", [0x2D]="Insert", [0x2E]="Supr",
    [0x30]="0", [0x31]="1", [0x32]="2", [0x33]="3", [0x34]="4",
    [0x35]="5", [0x36]="6", [0x37]="7", [0x38]="8", [0x39]="9",
    [0x41]="A", [0x42]="B", [0x43]="C", [0x44]="D", [0x45]="E",
    [0x46]="F", [0x47]="G", [0x48]="H", [0x49]="I", [0x4A]="J",
    [0x4B]="K", [0x4C]="L", [0x4D]="M", [0x4E]="N", [0x4F]="O",
    [0x50]="P", [0x51]="Q", [0x52]="R", [0x53]="S", [0x54]="T",
    [0x55]="U", [0x56]="V", [0x57]="W", [0x58]="X", [0x59]="Y",
    [0x5A]="Z", [0x60]="0 num", [0x61]="1 num", [0x62]="2 num",
    [0x63]="3 num", [0x64]="4 num", [0x65]="5 num", [0x66]="6 num",
    [0x67]="7 num", [0x68]="8 num", [0x69]="9 num",
    [0x6A]="Multiplicar", [0x6B]="Sumar", [0x6D]="Restar", [0x6E]="Decimal",
    [0x6F]="Dividir", [0x70]="F1", [0x71]="F2", [0x72]="F3", [0x73]="F4",
    [0x74]="F5", [0x75]="F6", [0x76]="F7", [0x77]="F8", [0x78]="F9",
    [0x79]="F10", [0x7A]="F11", [0x7B]="F12",
    [0x90]="Bloq Num", [0x91]="Bloq Despl",
    [0xA0]="Mayús Izq", [0xA1]="Mayús Der", [0xA2]="Ctrl Izq",
    [0xA3]="Ctrl Der", [0xA4]="Alt Izq", [0xA5]="Alt Der"
}
function Menu.GetKeyName(k) return Menu.KeyNames[k] or ("0x"..string.format("%02X",k)) end

function Menu.HandleInput()
    if Menu.IsLoading or not Menu.LoadingComplete then return end
    if Menu.InputOpen then return end

    -- Selección de tecla para binding
    if Menu.SelectingBind then
        if Menu.IsKeyJustPressed(0x0D) then
            if Menu.BindingKey and Menu.BindingItem then
                Menu.BindingItem.bindKey = Menu.BindingKey
                Menu.BindingItem.bindKeyName = Menu.BindingKeyName
            end
            Menu.SelectingBind = false
            Menu.BindingItem = nil
            return
        end
        for _,k in ipairs(captureKeys) do
            if k ~= 0x0D and Menu.IsKeyJustPressed(k) then
                Menu.BindingKey = k
                Menu.BindingKeyName = Menu.GetKeyName(k)
                break
            end
        end
        return
    end

    -- Selección de tecla para abrir menú
    if Menu.SelectingKey then
        if Menu.IsKeyJustPressed(0x0D) then
            if Menu.SelectedKey then Menu.SelectingKey = false end
            return
        end
        for _,k in ipairs(captureKeys) do
            if k ~= 0x0D and Menu.IsKeyJustPressed(k) then
                Menu.SelectedKey = k
                Menu.SelectedKeyName = Menu.GetKeyName(k)
                break
            end
        end
        return
    end

    -- Ejecutar keybinds
    for _,cat in ipairs(Menu.Categories) do
        if cat.hasTabs and cat.tabs then
            for _,tab in ipairs(cat.tabs) do
                if tab.items then
                    for _,it in ipairs(tab.items) do
                        if it.bindKey and (it.type=="toggle" or it.type=="action") then
                            if Menu.IsKeyJustPressed(it.bindKey) then
                                if it.type=="toggle" then
                                    it.value = not it.value
                                    if it.name == "Modo editor" then Menu.EditorMode = it.value end
                                    if it.name == "Mostrar teclas rápidas" then Menu.ShowKeybinds = it.value end
                                    if it.name == "Copos de nieve" then Menu.ShowSnowflakes = it.value end
                                    if it.onClick then it.onClick(it.value) end
                                elseif it.type=="action" then
                                    if it.onClick then it.onClick() end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- Tecla para mostrar/ocultar menú
    local toggleKey = Menu.SelectedKey or 0x31
    if Menu.IsKeyJustPressed(toggleKey) then
        Menu.Visible = not Menu.Visible
        if not Menu.Visible and not Menu.ShowKeybinds then
            if Susano.ResetFrame then Susano.ResetFrame() end
        end
    end

    if not Menu.Visible then return end

    -- Modo editor (arrastrar con ratón)
    if Menu.EditorMode then
        local sw, sh = 1920, 1080
        if Susano.GetScreenWidth then sw, sh = Susano.GetScreenWidth(), Susano.GetScreenHeight() end
        local cursor = Susano.GetCursorPos and Susano.GetCursorPos()
        local mx, my = 0,0
        if cursor then
            if type(cursor)=="table" then
                mx = cursor[1] or cursor.x or 0
                my = cursor[2] or cursor.y or 0
            else
                mx, my = cursor.x or 0, cursor.y or 0
            end
        end
        local lmb = false
        if Susano.GetAsyncKeyState then
            local d,p = Susano.GetAsyncKeyState(0x01)
            lmb = d==true or d==1
        end
        if lmb and not Menu.EditorDragging then
            local menuW = Menu.Position.width
            local totalH = Menu.Position.headerHeight + (Menu.OpenedCategory and (Menu.Position.itemHeight * Menu.ItemsPerPage + 60) or (Menu.Position.itemHeight * (#Menu.Categories-1) + 60))
            if mx>=Menu.Position.x and mx<=Menu.Position.x+menuW and my>=Menu.Position.y and my<=Menu.Position.y+totalH then
                Menu.EditorDragging = true
                Menu.EditorDragOffsetX = mx - Menu.Position.x
                Menu.EditorDragOffsetY = my - Menu.Position.y
            end
        elseif not lmb then
            Menu.EditorDragging = false
        end
        if Menu.EditorDragging then
            local newX = mx - Menu.EditorDragOffsetX
            local newY = my - Menu.EditorDragOffsetY
            newX = math.max(0, math.min(sw-Menu.Position.width, newX))
            newY = math.max(0, math.min(sh-400, newY))
            Menu.Position.x = newX
            Menu.Position.y = newY
        end
        return
    end

    -- Navegación principal (innovadora: izquierda/derecha cambian categoría, arriba/abajo items)
    if Menu.OpenedCategory then
        local cat = Menu.Categories[Menu.OpenedCategory]
        if not cat or not cat.hasTabs or not cat.tabs then
            Menu.OpenedCategory = nil
            return
        end
        local curTab = cat.tabs[Menu.CurrentTab]
        if curTab and curTab.items then
            if Menu.IsKeyJustPressed(0x26) then -- Up
                Menu.CurrentItem = findNextNonSeparator(curTab.items, Menu.CurrentItem, -1)
            elseif Menu.IsKeyJustPressed(0x28) then -- Down
                Menu.CurrentItem = findNextNonSeparator(curTab.items, Menu.CurrentItem, 1)
            elseif Menu.IsKeyJustPressed(0x25) or Menu.IsKeyJustPressed(0x41) then -- Left / A (disminuir slider/selector)
                local item = curTab.items[Menu.CurrentItem]
                if item then
                    if item.type == "slider" then
                        local step = item.step or 1
                        item.value = math.max(item.min or 0, (item.value or 0) - step)
                        if item.name == "Menú suave" then Menu.SmoothFactor = item.value/100 end
                        if item.name == "Tamaño del menú" then Menu.Scale = item.value/100 end
                        if item.onClick then item.onClick(item.value) end
                    elseif item.type == "selector" then
                        local idx = (item.selected or 1) - 1
                        if idx < 1 then idx = #item.options end
                        item.selected = idx
                        if item.name == "Tema del menú" then Menu.ApplyTheme(item.options[idx]) end
                        if item.onClick then item.onClick(item.selected, item.options[item.selected]) end
                    elseif item.type == "toggle_selector" then
                        local idx = (item.selected or 1) - 1
                        if idx < 1 then idx = #item.options end
                        item.selected = idx
                        if item.onClick then item.onClick(item.selected) end
                    elseif item.type == "toggle" and item.hasSlider then
                        item.sliderValue = math.max(item.sliderMin or 0, (item.sliderValue or 0) - (item.sliderStep or 0.1))
                    end
                end
            elseif Menu.IsKeyJustPressed(0x27) or Menu.IsKeyJustPressed(0x45) then -- Right / E (aumentar)
                local item = curTab.items[Menu.CurrentItem]
                if item then
                    if item.type == "slider" then
                        local step = item.step or 1
                        item.value = math.min(item.max or 100, (item.value or 0) + step)
                        if item.name == "Menú suave" then Menu.SmoothFactor = item.value/100 end
                        if item.name == "Tamaño del menú" then Menu.Scale = item.value/100 end
                        if item.onClick then item.onClick(item.value) end
                    elseif item.type == "selector" then
                        local idx = (item.selected or 1) + 1
                        if idx > #item.options then idx = 1 end
                        item.selected = idx
                        if item.name == "Tema del menú" then Menu.ApplyTheme(item.options[idx]) end
                        if item.onClick then item.onClick(item.selected, item.options[item.selected]) end
                    elseif item.type == "toggle_selector" then
                        local idx = (item.selected or 1) + 1
                        if idx > #item.options then idx = 1 end
                        item.selected = idx
                        if item.onClick then item.onClick(item.selected) end
                    elseif item.type == "toggle" and item.hasSlider then
                        item.sliderValue = math.min(item.sliderMax or 100, (item.sliderValue or 0) + (item.sliderStep or 0.1))
                    end
                end
            elseif Menu.IsKeyJustPressed(0x08) then -- Backspace
                if Menu.TopLevelTabs and Menu.TopLevelTabs[Menu.CurrentTopTab].autoOpen then
                    if Menu.CurrentTopTab > 1 then
                        Menu.CurrentTopTab = 1
                        Menu.UpdateCategoriesFromTopTab()
                    else
                        Menu.Visible = false
                    end
                else
                    Menu.OpenedCategory = nil
                    Menu.CurrentItem = 1
                    Menu.CurrentTab = 1
                end
            elseif Menu.IsKeyJustPressed(0x0D) then -- Enter
                local item = curTab.items[Menu.CurrentItem]
                if item and not item.isSeparator then
                    if item.type == "toggle" or item.type == "toggle_selector" then
                        item.value = not item.value
                        if item.name == "Mostrar teclas rápidas" then Menu.ShowKeybinds = item.value end
                        if item.name == "Modo editor" then Menu.EditorMode = item.value end
                        if item.name == "Copos de nieve" then Menu.ShowSnowflakes = item.value end
                        if item.onClick then item.onClick(item.value) end
                    elseif item.type == "action" then
                        if item.name == "Cambiar tecla de menú" then
                            Menu.SelectingKey = true
                        end
                        if item.onClick then item.onClick() end
                    elseif item.type == "selector" then
                        if item.onClick then item.onClick(item.selected, item.options[item.selected]) end
                    end
                end
            elseif Menu.IsKeyJustPressed(0x78) then -- F9
                local item = curTab.items[Menu.CurrentItem]
                if item and not item.isSeparator then
                    Menu.SelectingBind = true
                    Menu.BindingItem = item
                    Menu.BindingKey = item.bindKey
                    Menu.BindingKeyName = item.bindKeyName
                end
            end
            -- Cambiar pestañas con Q/E (si hay más de una)
            if Menu.IsKeyJustPressed(0x51) and #cat.tabs > 1 then -- Q
                Menu.CurrentTab = Menu.CurrentTab - 1
                if Menu.CurrentTab < 1 then Menu.CurrentTab = #cat.tabs end
                local newTab = cat.tabs[Menu.CurrentTab]
                if newTab and newTab.items then
                    Menu.CurrentItem = findNextNonSeparator(newTab.items, 0, 1)
                else
                    Menu.CurrentItem = 1
                end
            elseif Menu.IsKeyJustPressed(0x45) and #cat.tabs > 1 then -- E
                Menu.CurrentTab = Menu.CurrentTab + 1
                if Menu.CurrentTab > #cat.tabs then Menu.CurrentTab = 1 end
                local newTab = cat.tabs[Menu.CurrentTab]
                if newTab and newTab.items then
                    Menu.CurrentItem = findNextNonSeparator(newTab.items, 0, 1)
                else
                    Menu.CurrentItem = 1
                end
            end
        end
    else
        -- Navegación de categorías (horizontal)
        if Menu.IsKeyJustPressed(0x25) or Menu.IsKeyJustPressed(0x41) then -- Left / A
            Menu.CurrentCategory = Menu.CurrentCategory - 1
            if Menu.CurrentCategory < 2 then Menu.CurrentCategory = #Menu.Categories end
        elseif Menu.IsKeyJustPressed(0x27) or Menu.IsKeyJustPressed(0x45) then -- Right / E
            Menu.CurrentCategory = Menu.CurrentCategory + 1
            if Menu.CurrentCategory > #Menu.Categories then Menu.CurrentCategory = 2 end
        elseif Menu.IsKeyJustPressed(0x26) then -- Up (cambiar top tab si existe)
            if Menu.TopLevelTabs then
                Menu.CurrentTopTab = Menu.CurrentTopTab - 1
                if Menu.CurrentTopTab < 1 then Menu.CurrentTopTab = #Menu.TopLevelTabs end
                Menu.UpdateCategoriesFromTopTab()
            end
        elseif Menu.IsKeyJustPressed(0x28) then -- Down
            if Menu.TopLevelTabs then
                Menu.CurrentTopTab = Menu.CurrentTopTab + 1
                if Menu.CurrentTopTab > #Menu.TopLevelTabs then Menu.CurrentTopTab = 1 end
                Menu.UpdateCategoriesFromTopTab()
            end
        elseif Menu.IsKeyJustPressed(0x0D) then -- Enter
            local cat = Menu.Categories[Menu.CurrentCategory]
            if cat and cat.hasTabs and cat.tabs then
                Menu.OpenedCategory = Menu.CurrentCategory
                Menu.CurrentTab = 1
                if cat.tabs[1] and cat.tabs[1].items then
                    Menu.CurrentItem = findNextNonSeparator(cat.tabs[1].items, 0, 1)
                else
                    Menu.CurrentItem = 1
                end
            end
        end
    end
end

-- Funciones auxiliares (banner, actualización de categorías, etc.)
function Menu.UpdateCategoriesFromTopTab()
    if not Menu.TopLevelTabs then return end
    local currentTop = Menu.TopLevelTabs[Menu.CurrentTopTab]
    if not currentTop then return end
    Menu.Categories = {}
    table.insert(Menu.Categories, { name = currentTop.name })
    for _, cat in ipairs(currentTop.categories) do
        table.insert(Menu.Categories, cat)
    end
    Menu.CurrentCategory = 2
    Menu.CategoryScrollOffset = 0
    Menu.OpenedCategory = nil
    if currentTop.autoOpen then
        Menu.OpenedCategory = 2
        Menu.CurrentTab = 1
        Menu.ItemScrollOffset = 0
        Menu.CurrentItem = 1
    end
end

Menu.Banner = { enabled = false, imageUrl = "", height = 0 } -- deshabilitado para este diseño
Menu.bannerTexture = nil
function Menu.LoadBannerTexture(url) end

function Menu.Render()
    if Menu.TopLevelTabs and not Menu.Categories then Menu.UpdateCategoriesFromTopTab() end
    if not Susano.BeginFrame then return end
    local dt = GetFrameTime and GetFrameTime() or 0.016
    local anim = 5.0 * dt
    if Menu.IsLoading then
        Menu.LoadingBarAlpha = math.min(1, Menu.LoadingBarAlpha + anim)
    else
        Menu.LoadingBarAlpha = math.max(0, Menu.LoadingBarAlpha - anim)
    end
    if Menu.SelectingKey or Menu.SelectingBind then
        Menu.KeySelectorAlpha = math.min(1, Menu.KeySelectorAlpha + anim)
    else
        Menu.KeySelectorAlpha = math.max(0, Menu.KeySelectorAlpha - anim)
    end
    if Menu.ShowKeybinds then
        Menu.KeybindsInterfaceAlpha = math.min(1, Menu.KeybindsInterfaceAlpha + anim)
    else
        Menu.KeybindsInterfaceAlpha = math.max(0, Menu.KeybindsInterfaceAlpha - anim)
    end
    Susano.BeginFrame()
    if Menu.KeybindsInterfaceAlpha > 0 then Menu.DrawKeybindsInterface(Menu.KeybindsInterfaceAlpha) end
    if Menu.Visible then
        if Menu.EditorMode and Susano.EnableOverlay then Susano.EnableOverlay(true)
        elseif not Menu.EditorMode and Susano.EnableOverlay then Susano.EnableOverlay(false) end
        Menu.DrawBackground()
        Menu.DrawHeader()
        Menu.DrawCategories()
        Menu.DrawFooter()
    end
    if Menu.InputOpen then Menu.DrawInputWindow() end
    if Menu.LoadingBarAlpha > 0 then Menu.DrawLoadingBar(Menu.LoadingBarAlpha) end
    if Menu.KeySelectorAlpha > 0 then Menu.DrawKeySelector(Menu.KeySelectorAlpha) end
    if Menu.OnRender then pcall(Menu.OnRender) end
    if Susano.SubmitFrame then Susano.SubmitFrame() end
    if not Menu.Visible and not Menu.ShowKeybinds and Menu.LoadingBarAlpha<=0 and Menu.KeySelectorAlpha<=0 then
        if Susano.ResetFrame then Susano.ResetFrame() end
    end
end

-- Input window (similar al original pero adaptado)
function Menu.OpenInput(title, subtitle, callback)
    if type(subtitle)=="function" then callback, subtitle = subtitle, "Escribe el texto abajo" end
    Menu.InputTitle = title
    Menu.InputSubtitle = subtitle
    Menu.InputText = ""
    Menu.InputCallback = callback
    Menu.InputOpen = true
    Menu.SelectingKey = false
    Menu.SelectingBind = false
end
function Menu.DrawInputWindow()
    if not Menu.InputOpen then return end
    local sw, sh = 1920,1080
    if Susano.GetScreenWidth then sw, sh = Susano.GetScreenWidth(), Susano.GetScreenHeight() end
    local w, h = 350, 140
    local x, y = sw/2-w/2, sh/2-h/2
    Menu.DrawRoundedRect(x, y, w, h, Menu.Colors.Bg.r, Menu.Colors.Bg.g, Menu.Colors.Bg.b, 230, 8)
    Menu.DrawRect(x, y, w, 2, Menu.Colors.Border.r, Menu.Colors.Border.g, Menu.Colors.Border.b, 255)
    Menu.DrawText(x+20, y+20, Menu.InputTitle, 18, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255)
    Menu.DrawText(x+20, y+50, Menu.InputSubtitle, 13, Menu.Colors.TextDim.r, Menu.Colors.TextDim.g, Menu.Colors.TextDim.b, 255)
    local boxW = w-40
    local boxH = 30
    local boxX = x+20
    local boxY = y+80
    Menu.DrawRect(boxX-1, boxY-1, boxW+2, boxH+2, Menu.Colors.Card.r, Menu.Colors.Card.g, Menu.Colors.Card.b, 255)
    Menu.DrawRect(boxX, boxY, boxW, boxH, Menu.Colors.Bg.r, Menu.Colors.Bg.g, Menu.Colors.Bg.b, 255)
    local display = Menu.InputText
    if math.floor(GetGameTimer()/500)%2==0 then display = display.."|" end
    if #display>30 then display = "..."..string.sub(display,-30) end
    Menu.DrawText(boxX+10, boxY+5, display, 16, Menu.Colors.Text.r, Menu.Colors.Text.g, Menu.Colors.Text.b, 255)
    if Menu.IsKeyJustPressed(0x0D) then
        Menu.InputOpen = false
        if Menu.InputCallback then Menu.InputCallback(Menu.InputText) end
    end
    if Menu.IsKeyJustPressed(0x08) then
        Menu.InputText = string.sub(Menu.InputText,1,-2)
    end
    if Menu.IsKeyJustPressed(0x1B) then Menu.InputOpen = false end
    local shift = Susano.GetAsyncKeyState and (Susano.GetAsyncKeyState(0x10) or Susano.GetAsyncKeyState(0xA0) or Susano.GetAsyncKeyState(0xA1))
    for i=0x41,0x5A do
        if Menu.IsKeyJustPressed(i) then
            local ch = string.char(i)
            if not shift then ch = string.lower(ch) end
            Menu.InputText = Menu.InputText .. ch
        end
    end
    for i=0x30,0x39 do
        if Menu.IsKeyJustPressed(i) then Menu.InputText = Menu.InputText .. string.char(i) end
    end
    if Menu.IsKeyJustPressed(0x20) then Menu.InputText = Menu.InputText .. " " end
    if Menu.IsKeyJustPressed(0xBD) then
        Menu.InputText = Menu.InputText .. (shift and "_" or "-")
    end
end

-- Inicialización
CreateThread(function()
    Menu.LoadingStartTime = GetGameTimer() or 0
    while Menu.IsLoading do
        local now = GetGameTimer() or Menu.LoadingStartTime
        local elapsed = now - Menu.LoadingStartTime
        Menu.LoadingProgress = (elapsed / Menu.LoadingDuration) * 100
        if Menu.LoadingProgress >= 100 then
            Menu.LoadingProgress = 100
            Menu.IsLoading = false
            Menu.LoadingComplete = true
            Menu.SelectingKey = true
            break
        end
        Wait(0)
    end
end)

CreateThread(function()
    while true do
        Menu.Render()
        if Menu.LoadingComplete then Menu.HandleInput() end
        Wait(0)
    end
end)

-- Aplicar tema y configurar valores por defecto (fondo negro desactivado, nieve activada)
Menu.ApplyTheme("Cyberpunk")
CreateThread(function()
    while not Menu.Categories do Wait(100) end
    Wait(500)
    for _,cat in ipairs(Menu.Categories) do
        if cat.name == "Ajustes" and cat.tabs then
            for _,tab in ipairs(cat.tabs) do
                if tab.name == "General" and tab.items then
                    for _,it in ipairs(tab.items) do
                        if it.name == "Fondo negro" and it.type == "toggle" then
                            it.value = false
                        end
                        if it.name == "Copos de nieve" and it.type == "toggle" then
                            it.value = true
                            Menu.ShowSnowflakes = true
                        end
                    end
                end
            end
        end
    end
end)

return Menu
