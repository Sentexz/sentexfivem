local Menu = {}
Menu.Visible = false
Menu.CurrentCategory = 2
Menu.CurrentPage = 1
Menu.ItemsPerPage = 9
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
Menu.ShowSnowflakes = true   -- <-- Activado por defecto
Menu.SelectorY = 0
Menu.CategorySelectorY = 0
Menu.TabSelectorX = 0
Menu.TabSelectorWidth = 0
Menu.SmoothFactor = 0.2
Menu.GradientType = 1
Menu.ScrollbarPosition = 1

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

-- ========== NUEVA ESTRUCTURA DE COLORES (Neon Glass) ==========
Menu.Colors = {
    GlassBg = { r = 10, g = 12, b = 20, a = 200 },        -- fondo semi-transparente oscuro
    GlassBorder = { r = 0, g = 243, b = 255, a = 120 },   -- borde neón
    Accent = { r = 0, g = 243, b = 255 },                 -- cian brillante
    AccentDark = { r = 0, g = 180, b = 200 },
    TextPrimary = { r = 255, g = 255, b = 255 },
    TextSecondary = { r = 180, g = 190, b = 220 },
    ItemBg = { r = 20, g = 25, b = 40, a = 180 },
    ItemSelectedBg = { r = 0, g = 80, b = 120, a = 100 },  -- sutil, el borde hará el efecto
}
Menu.CurrentTheme = "NeonGlass"

function Menu.ApplyTheme(themeName)
    if not themeName or type(themeName) ~= "string" then themeName = "NeonGlass" end
    local themeLower = string.lower(themeName)
    Menu.CurrentTheme = themeName

    if themeLower == "neonglass" then
        Menu.Colors.GlassBg = { r = 10, g = 12, b = 20, a = 200 }
        Menu.Colors.GlassBorder = { r = 0, g = 243, b = 255, a = 120 }
        Menu.Colors.Accent = { r = 0, g = 243, b = 255 }
        Menu.Colors.AccentDark = { r = 0, g = 180, b = 200 }
        Menu.Colors.TextPrimary = { r = 255, g = 255, b = 255 }
        Menu.Colors.TextSecondary = { r = 180, g = 190, b = 220 }
        Menu.Colors.ItemBg = { r = 20, g = 25, b = 40, a = 180 }
        Menu.Colors.ItemSelectedBg = { r = 0, g = 80, b = 120, a = 100 }
        Menu.Banner.imageUrl = "https://i.imgur.com/dWBrem7.jpeg"
    elseif themeLower == "purple" then
        Menu.Colors.GlassBg = { r = 18, g = 12, b = 28, a = 200 }
        Menu.Colors.GlassBorder = { r = 170, g = 90, b = 255, a = 120 }
        Menu.Colors.Accent = { r = 170, g = 90, b = 255 }
        Menu.Colors.AccentDark = { r = 120, g = 50, b = 200 }
        Menu.Colors.TextPrimary = { r = 255, g = 255, b = 255 }
        Menu.Colors.TextSecondary = { r = 200, g = 180, b = 240 }
        Menu.Colors.ItemBg = { r = 28, g = 18, b = 40, a = 180 }
        Menu.Colors.ItemSelectedBg = { r = 80, g = 40, b = 120, a = 100 }
        Menu.Banner.imageUrl = "https://i.imgur.com/dWBrem7.jpeg"
    elseif themeLower == "gray" then
        Menu.Colors.GlassBg = { r = 28, g = 28, b = 35, a = 200 }
        Menu.Colors.GlassBorder = { r = 160, g = 160, b = 180, a = 120 }
        Menu.Colors.Accent = { r = 180, g = 180, b = 200 }
        Menu.Colors.AccentDark = { r = 120, g = 120, b = 140 }
        Menu.Colors.TextPrimary = { r = 240, g = 240, b = 250 }
        Menu.Colors.TextSecondary = { r = 180, g = 180, b = 200 }
        Menu.Colors.ItemBg = { r = 35, g = 35, b = 45, a = 180 }
        Menu.Colors.ItemSelectedBg = { r = 70, g = 70, b = 85, a = 100 }
        Menu.Banner.imageUrl = "https://i.imgur.com/WBxgLw9.png"
    elseif themeLower == "pink" then
        Menu.Colors.GlassBg = { r = 25, g = 12, b = 20, a = 200 }
        Menu.Colors.GlassBorder = { r = 255, g = 20, b = 147, a = 120 }
        Menu.Colors.Accent = { r = 255, g = 20, b = 147 }
        Menu.Colors.AccentDark = { r = 200, g = 0, b = 100 }
        Menu.Colors.TextPrimary = { r = 255, g = 240, b = 250 }
        Menu.Colors.TextSecondary = { r = 220, g = 170, b = 200 }
        Menu.Colors.ItemBg = { r = 35, g = 18, b = 30, a = 180 }
        Menu.Colors.ItemSelectedBg = { r = 120, g = 30, b = 80, a = 100 }
        Menu.Banner.imageUrl = "https://i.imgur.com/dWBrem7.jpeg"
    else
        -- fallback
        Menu.ApplyTheme("NeonGlass")
        return
    end

    if Menu.Banner.enabled and Menu.Banner.imageUrl then
        Menu.LoadBannerTexture(Menu.Banner.imageUrl)
    end
end

-- Dimensiones del menú (más grandes y modernas)
Menu.Position = {
    x = 50,
    y = 100,
    width = 420,
    itemHeight = 44,
    mainMenuHeight = 34,
    headerHeight = 110,
    footerHeight = 32,
    footerSpacing = 8,
    mainMenuSpacing = 8,
    footerRadius = 8,
    itemRadius = 6,
    scrollbarWidth = 3,
    scrollbarPadding = 6,
    headerRadius = 10
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

-- Funciones de dibujo optimizadas (soportan alpha en color)
function Menu.DrawRect(x, y, width, height, r, g, b, a)
    a = a or 1.0
    if r > 1.0 then r = r/255.0 end
    if g > 1.0 then g = g/255.0 end
    if b > 1.0 then b = b/255.0 end
    if a > 1.0 then a = a/255.0 end
    if Susano.DrawFilledRect then
        Susano.DrawFilledRect(x, y, width, height, r, g, b, a)
    elseif Susano.FillRect then
        Susano.FillRect(x, y, width, height, r, g, b, a)
    elseif Susano.DrawRect then
        for i=0, height-1 do
            Susano.DrawRect(x, y+i, width, 1, r, g, b, a)
        end
    end
end

function Menu.DrawText(x, y, text, size_px, r, g, b, a)
    local scale = Menu.Scale or 1.0
    size_px = (size_px or 16) * scale
    if r > 1.0 then r = r/255.0 end
    if g > 1.0 then g = g/255.0 end
    if b > 1.0 then b = b/255.0 end
    if a > 1.0 then a = a/255.0 end
    Susano.DrawText(x, y, text, size_px, r, g, b, a)
end

function Menu.DrawRoundedRect(x, y, width, height, r, g, b, a, radius)
    radius = radius or 0
    if radius <= 0 then
        Menu.DrawRect(x, y, width, height, r, g, b, a)
        return
    end
    -- Implementación básica (se puede mejorar, pero funcional)
    Menu.DrawRect(x+radius, y, width-2*radius, height, r, g, b, a)
    Menu.DrawRect(x, y+radius, radius, height-2*radius, r, g, b, a)
    Menu.DrawRect(x+width-radius, y+radius, radius, height-2*radius, r, g, b, a)
    for i=0, radius-1 do
        local slice = math.ceil(math.sqrt(radius*radius - i*i))
        local topY = y+radius-1-i
        Menu.DrawRect(x+radius-slice, topY, slice, 1, r, g, b, a)
        Menu.DrawRect(x+width-radius, topY, slice, 1, r, g, b, a)
        local bottomY = y+height-radius+i
        Menu.DrawRect(x+radius-slice, bottomY, slice, 1, r, g, b, a)
        Menu.DrawRect(x+width-radius, bottomY, slice, 1, r, g, b, a)
    end
end

-- Header con efecto glass y borde neón
function Menu.DrawHeader()
    local p = Menu.GetScaledPosition()
    local x, y, w, h = p.x, p.y, p.width-1, p.headerHeight
    local radius = p.headerRadius
    -- Sombra / borde exterior
    Menu.DrawRoundedRect(x-1, y-1, w+2, h+2, Menu.Colors.GlassBorder.r, Menu.Colors.GlassBorder.g, Menu.Colors.GlassBorder.b, 60, radius+1)
    -- Fondo glass
    Menu.DrawRoundedRect(x, y, w, h, Menu.Colors.GlassBg.r, Menu.Colors.GlassBg.g, Menu.Colors.GlassBg.b, Menu.Colors.GlassBg.a, radius)
    -- Logo o texto
    local logoText = "⚡ MENU ⚡"
    local fontSize = 28
    local textW = Susano.GetTextWidth and Susano.GetTextWidth(logoText, fontSize) or (string.len(logoText)*14)
    local textX = x + w/2 - textW/2
    local textY = y + h/2 - fontSize/2
    Menu.DrawText(textX, textY, logoText, fontSize, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255)
end

-- Scrollbar ultrafina con glow
function Menu.DrawScrollbar(x, startY, visibleHeight, selectedIndex, totalItems, isMainMenu, menuWidth)
    if totalItems < 1 then return end
    local p = Menu.GetScaledPosition()
    local sbW = p.scrollbarWidth
    local pad = p.scrollbarPadding
    local width = menuWidth or p.width
    local sbX = (Menu.ScrollbarPosition == 2) and (x + width + pad) or (x - sbW - pad)
    local sbY = startY
    local sbH = visibleHeight

    local thumbH = sbH
    local thumbY = sbY
    if totalItems > Menu.ItemsPerPage then
        local scrollOffset = isMainMenu and Menu.CategoryScrollOffset or Menu.ItemScrollOffset
        local totalScroll = totalItems - Menu.ItemsPerPage
        local progress = scrollOffset / math.max(1, totalScroll)
        progress = math.min(1, math.max(0, progress))
        thumbH = math.max(20, sbH * (Menu.ItemsPerPage / totalItems))
        thumbY = sbY + progress * (sbH - thumbH)
        thumbY = math.max(sbY, math.min(sbY+sbH-thumbH, thumbY))
    end
    -- track
    Menu.DrawRect(sbX, sbY, sbW, sbH, Menu.Colors.TextSecondary.r, Menu.Colors.TextSecondary.g, Menu.Colors.TextSecondary.b, 40)
    -- thumb
    Menu.DrawRect(sbX, thumbY, sbW, thumbH, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 200)
    -- glow extra (opcional)
    Menu.DrawRect(sbX-1, thumbY, sbW+2, thumbH, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 50)
end

-- Pestañas con estilo neón (línea inferior)
function Menu.DrawTabs(category, x, startY, width, tabHeight)
    if not category or not category.hasTabs or not category.tabs then return end
    local scale = Menu.Scale or 1.0
    local numTabs = #category.tabs
    local tabWidth = width / numTabs
    for i, tab in ipairs(category.tabs) do
        local tabX = x + (i-1)*tabWidth
        local curWidth = (i==numTabs) and (x+width - tabX) or (tabWidth + 0.5*scale)
        local isSelected = (i == Menu.CurrentTab)
        -- fondo pestaña
        Menu.DrawRect(tabX, startY, curWidth, tabHeight, Menu.Colors.GlassBg.r, Menu.Colors.GlassBg.g, Menu.Colors.GlassBg.b, isSelected and 220 or 100)
        if isSelected then
            -- línea inferior neón
            Menu.DrawRect(tabX, startY+tabHeight-2, curWidth, 2, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255)
        end
        -- texto
        local textSize = 16
        local textW = Susano.GetTextWidth and Susano.GetTextWidth(tab.name, textSize) or (string.len(tab.name)*9)
        local textX = tabX + curWidth/2 - textW/2
        local textY = startY + tabHeight/2 - textSize/2
        local r,g,b = isSelected and Menu.Colors.TextPrimary.r or Menu.Colors.TextSecondary.r,
                      isSelected and Menu.Colors.TextPrimary.g or Menu.Colors.TextSecondary.g,
                      isSelected and Menu.Colors.TextPrimary.b or Menu.Colors.TextSecondary.b
        Menu.DrawText(textX, textY, tab.name, textSize, r, g, b, 255)
    end
end

-- Helper para saltar separadores
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

-- Dibujado de ítem con estilo tarjeta y borde neón al seleccionar
function Menu.DrawItem(x, itemY, width, itemHeight, item, isSelected)
    local scale = Menu.Scale or 1.0
    if item.isSeparator then
        -- separador estilizado
        Menu.DrawRect(x, itemY, width, itemHeight, Menu.Colors.GlassBg.r, Menu.Colors.GlassBg.g, Menu.Colors.GlassBg.b, 80)
        if item.separatorText then
            local textSize = 14
            local textW = Susano.GetTextWidth and Susano.GetTextWidth(item.separatorText, textSize) or (string.len(item.separatorText)*8)
            local textX = x + width/2 - textW/2
            local textY = itemY + itemHeight/2 - textSize/2
            Menu.DrawText(textX, textY, item.separatorText, textSize, Menu.Colors.TextSecondary.r, Menu.Colors.TextSecondary.g, Menu.Colors.TextSecondary.b, 180)
        end
        return
    end

    -- Fondo del ítem
    local bgAlpha = isSelected and Menu.Colors.ItemSelectedBg.a or Menu.Colors.ItemBg.a
    Menu.DrawRect(x, itemY, width, itemHeight, Menu.Colors.ItemBg.r, Menu.Colors.ItemBg.g, Menu.Colors.ItemBg.b, bgAlpha)

    if isSelected then
        -- Borde neón izquierdo y derecho sutil
        Menu.DrawRect(x, itemY, 4, itemHeight, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255)
        Menu.DrawRect(x+width-4, itemY, 4, itemHeight, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 150)
        -- Sombra de texto para legibilidad
    end

    -- Texto del ítem (siempre blanco, con sombra)
    local textX = x + 16
    local textY = itemY + itemHeight/2 - 8
    Menu.DrawText(textX-1, textY-1, item.name, 17, 0,0,0, 120) -- sombra
    Menu.DrawText(textX, textY, item.name, 17, Menu.Colors.TextPrimary.r, Menu.Colors.TextPrimary.g, Menu.Colors.TextPrimary.b, 255)

    -- Dibujar controles (toggle, slider, selector) con estilo moderno
    if item.type == "toggle" then
        local toggleW = 44 * scale
        local toggleH = 22 * scale
        local toggleX = x + width - toggleW - 16
        local toggleY = itemY + (itemHeight/2) - (toggleH/2)
        local radius = toggleH/2
        if item.value then
            Menu.DrawRoundedRect(toggleX, toggleY, toggleW, toggleH, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255, radius)
        else
            Menu.DrawRoundedRect(toggleX, toggleY, toggleW, toggleH, 60, 70, 90, 200, radius)
        end
        local knobSize = toggleH - 6
        local knobY = toggleY + 3
        local knobX = item.value and (toggleX + toggleW - knobSize - 3) or (toggleX + 3)
        Menu.DrawRoundedRect(knobX, knobY, knobSize, knobSize, 255,255,255, 255, knobSize/2)
    elseif item.type == "slider" then
        local sliderW = 120 * scale
        local sliderH = 6 * scale
        local sliderX = x + width - sliderW - 80
        local sliderY = itemY + (itemHeight/2) - (sliderH/2)
        local minV = item.min or 0
        local maxV = item.max or 100
        local val = item.value or minV
        local percent = (val - minV) / (maxV - minV)
        percent = math.min(1, math.max(0, percent))
        Menu.DrawRect(sliderX, sliderY, sliderW, sliderH, Menu.Colors.TextSecondary.r, Menu.Colors.TextSecondary.g, Menu.Colors.TextSecondary.b, 100)
        if percent > 0 then
            Menu.DrawRect(sliderX, sliderY, sliderW * percent, sliderH, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255)
        end
        local thumbSize = 10 * scale
        local thumbX = sliderX + sliderW*percent - thumbSize/2
        local thumbY = sliderY + sliderH/2 - thumbSize/2
        Menu.DrawRoundedRect(thumbX, thumbY, thumbSize, thumbSize, 255,255,255, 255, thumbSize/2)
        -- valor numérico
        local valText = string.format("%.0f", val)
        local textW = Susano.GetTextWidth and Susano.GetTextWidth(valText, 13) or (string.len(valText)*7)
        Menu.DrawText(sliderX + sliderW + 10, sliderY-2, valText, 13, Menu.Colors.TextSecondary.r, Menu.Colors.TextSecondary.g, Menu.Colors.TextSecondary.b, 255)
    elseif item.type == "selector" and item.options then
        local selIdx = item.selected or 1
        local option = item.options[selIdx] or ""
        local fullText = "< " .. option .. " >"
        local textSize = 17
        local textW = Susano.GetTextWidth and Susano.GetTextWidth(fullText, textSize) or (string.len(fullText)*9)
        local textX = x + width - textW - 16
        Menu.DrawText(textX, textY-1, fullText, textSize, Menu.Colors.TextSecondary.r, Menu.Colors.TextSecondary.g, Menu.Colors.TextSecondary.b, 200)
    elseif item.type == "toggle_selector" then
        -- similar a toggle pero con selector adicional
        local toggleW = 36
        local toggleH = 18
        local toggleX = x + width - toggleW - 16
        local toggleY = itemY + (itemHeight/2) - (toggleH/2)
        if item.value then
            Menu.DrawRoundedRect(toggleX, toggleY, toggleW, toggleH, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255, toggleH/2)
        else
            Menu.DrawRoundedRect(toggleX, toggleY, toggleW, toggleH, 60,70,90, 200, toggleH/2)
        end
        local knobSize = toggleH - 4
        local knobY = toggleY + 2
        local knobX = item.value and (toggleX + toggleW - knobSize - 2) or (toggleX + 2)
        Menu.DrawRoundedRect(knobX, knobY, knobSize, knobSize, 255,255,255, 255, knobSize/2)
        -- selector de opciones
        if item.options then
            local selIdx = item.selected or 1
            local opt = item.options[selIdx] or ""
            local optText = "< " .. opt .. " >"
            local optW = Susano.GetTextWidth and Susano.GetTextWidth(optText, 15) or (string.len(optText)*8)
            local optX = toggleX - optW - 10
            Menu.DrawText(optX, textY-1, optText, 15, Menu.Colors.TextSecondary.r, Menu.Colors.TextSecondary.g, Menu.Colors.TextSecondary.b, 200)
        end
    end
end

-- Navegación por categorías (pantalla principal)
function Menu.DrawCategories()
    if Menu.OpenedCategory then
        local cat = Menu.Categories[Menu.OpenedCategory]
        if not cat or not cat.hasTabs or not cat.tabs then
            Menu.OpenedCategory = nil
            return
        end

        local p = Menu.GetScaledPosition()
        local x = p.x
        local startY = p.y + p.headerHeight
        local width = p.width
        local itemH = p.itemHeight
        local tabH = p.mainMenuHeight
        local spacing = p.mainMenuSpacing

        Menu.DrawTabs(cat, x, startY, width, tabH)

        local curTab = cat.tabs[Menu.CurrentTab]
        if curTab and curTab.items then
            local itemsY = startY + tabH + spacing
            local total = #curTab.items
            local maxVis = Menu.ItemsPerPage
            -- ajustar scroll
            if Menu.CurrentItem > Menu.ItemScrollOffset + maxVis then
                Menu.ItemScrollOffset = Menu.CurrentItem - maxVis
            elseif Menu.CurrentItem <= Menu.ItemScrollOffset then
                Menu.ItemScrollOffset = math.max(0, Menu.CurrentItem - 1)
            end
            local visible = 0
            for i=1, math.min(maxVis, total) do
                local idx = i + Menu.ItemScrollOffset
                if idx <= total then
                    visible = visible + 1
                    local yPos = itemsY + (i-1)*itemH
                    local selected = (idx == Menu.CurrentItem)
                    Menu.DrawItem(x, yPos, width, itemH, curTab.items[idx], selected)
                end
            end
            -- scrollbar
            local nonSepCount = 0
            for _,it in ipairs(curTab.items) do if not it.isSeparator then nonSepCount = nonSepCount+1 end end
            if nonSepCount > 0 then
                Menu.DrawScrollbar(x, itemsY, visible*itemH, Menu.CurrentItem, nonSepCount, false, width)
            end
        end
        return
    end

    -- Menú principal (categorías)
    local p = Menu.GetScaledPosition()
    local x = p.x
    local startY = p.y + (Menu.Banner.enabled and (Menu.Banner.height*p.Scale) or p.headerHeight)
    local width = p.width
    local itemH = p.itemHeight
    local tabH = p.mainMenuHeight
    local spacing = p.mainMenuSpacing

    -- Barra de top tabs (si existen)
    if Menu.TopLevelTabs then
        local tabCount = #Menu.TopLevelTabs
        local tabW = width / tabCount
        for i, tab in ipairs(Menu.TopLevelTabs) do
            local tabX = x + (i-1)*tabW
            local isSelected = (i == Menu.CurrentTopTab)
            Menu.DrawRect(tabX, startY, tabW, tabH, Menu.Colors.GlassBg.r, Menu.Colors.GlassBg.g, Menu.Colors.GlassBg.b, isSelected and 220 or 100)
            if isSelected then
                Menu.DrawRect(tabX, startY+tabH-2, tabW, 2, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255)
            end
            local textSize = 16
            local textW = Susano.GetTextWidth and Susano.GetTextWidth(tab.name, textSize) or (string.len(tab.name)*9)
            local textX = tabX + tabW/2 - textW/2
            local textY = startY + tabH/2 - textSize/2
            local r,g,b = isSelected and Menu.Colors.TextPrimary.r or Menu.Colors.TextSecondary.r,
                          isSelected and Menu.Colors.TextPrimary.g or Menu.Colors.TextSecondary.g,
                          isSelected and Menu.Colors.TextPrimary.b or Menu.Colors.TextSecondary.b
            Menu.DrawText(textX, textY, tab.name, textSize, r, g, b, 255)
        end
        startY = startY + tabH + spacing
    else
        -- si no hay top tabs, mostrar título simple
        Menu.DrawRect(x, startY, width, tabH, Menu.Colors.GlassBg.r, Menu.Colors.GlassBg.g, Menu.Colors.GlassBg.b, 200)
        local title = Menu.Categories[1] and Menu.Categories[1].name or "MENÚ"
        local textW = Susano.GetTextWidth and Susano.GetTextWidth(title, 20) or (string.len(title)*10)
        Menu.DrawText(x+width/2-textW/2, startY+tabH/2-10, title, 20, Menu.Colors.TextPrimary.r, Menu.Colors.TextPrimary.g, Menu.Colors.TextPrimary.b, 255)
        startY = startY + tabH + spacing
    end

    -- Lista de categorías
    local totalCats = #Menu.Categories - 1
    local maxVis = Menu.ItemsPerPage
    if Menu.CurrentCategory > Menu.CategoryScrollOffset + maxVis + 1 then
        Menu.CategoryScrollOffset = Menu.CurrentCategory - maxVis - 1
    elseif Menu.CurrentCategory <= Menu.CategoryScrollOffset + 1 then
        Menu.CategoryScrollOffset = math.max(0, Menu.CurrentCategory - 2)
    end

    local visible = 0
    for i=1, math.min(maxVis, totalCats) do
        local idx = i + Menu.CategoryScrollOffset + 1
        if idx <= #Menu.Categories then
            visible = visible + 1
            local cat = Menu.Categories[idx]
            local yPos = startY + (i-1)*itemH
            local selected = (idx == Menu.CurrentCategory)
            -- fondo
            Menu.DrawRect(x, yPos, width, itemH, Menu.Colors.ItemBg.r, Menu.Colors.ItemBg.g, Menu.Colors.ItemBg.b, selected and 150 or 100)
            if selected then
                Menu.DrawRect(x, yPos, 4, itemH, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255)
            end
            local textX = x + 16
            local textY = yPos + itemH/2 - 8
            Menu.DrawText(textX, textY, cat.name, 17, Menu.Colors.TextPrimary.r, Menu.Colors.TextPrimary.g, Menu.Colors.TextPrimary.b, 255)
            -- flecha
            Menu.DrawText(x+width-22, textY, ">", 17, Menu.Colors.TextSecondary.r, Menu.Colors.TextSecondary.g, Menu.Colors.TextSecondary.b, 200)
        end
    end

    if totalCats > 0 then
        local scrollStartY = startY
        Menu.DrawScrollbar(x, scrollStartY, visible*itemH, Menu.CurrentCategory, totalCats, true, width)
    end
end

function Menu.DrawFooter()
    local p = Menu.GetScaledPosition()
    local x = p.x
    local bannerH = Menu.Banner.enabled and (Menu.Banner.height * p.Scale) or p.headerHeight
    local contentH = bannerH
    if Menu.OpenedCategory then
        local cat = Menu.Categories[Menu.OpenedCategory]
        if cat and cat.hasTabs and cat.tabs then
            local tab = cat.tabs[Menu.CurrentTab]
            if tab and tab.items then
                local vis = math.min(Menu.ItemsPerPage, #tab.items)
                contentH = contentH + p.mainMenuHeight + p.mainMenuSpacing + vis * p.itemHeight
            else
                contentH = contentH + p.mainMenuHeight + p.mainMenuSpacing
            end
        else
            contentH = contentH + p.mainMenuHeight + p.mainMenuSpacing
        end
    else
        local vis = math.min(Menu.ItemsPerPage, #Menu.Categories-1)
        contentH = contentH + p.mainMenuHeight + p.mainMenuSpacing + vis * p.itemHeight
    end
    local footerY = p.y + contentH + p.footerSpacing
    local w = p.width-1
    local h = p.footerHeight
    Menu.DrawRoundedRect(x, footerY, w, h, Menu.Colors.GlassBg.r, Menu.Colors.GlassBg.g, Menu.Colors.GlassBg.b, 220, p.footerRadius)
    local text = " .gg/sentexmodz [ESE DEFA MAKINA AY] "
    local textSize = 13
    local textW = Susano.GetTextWidth and Susano.GetTextWidth(text, textSize) or (string.len(text)*7)
    Menu.DrawText(x+15, footerY+h/2-6, text, textSize, Menu.Colors.TextSecondary.r, Menu.Colors.TextSecondary.g, Menu.Colors.TextSecondary.b, 200)
    local pageInfo = ""
    if Menu.OpenedCategory then
        local cat = Menu.Categories[Menu.OpenedCategory]
        if cat and cat.hasTabs and cat.tabs then
            local tab = cat.tabs[Menu.CurrentTab]
            if tab and tab.items then
                pageInfo = string.format("%d/%d", Menu.CurrentItem, #tab.items)
            end
        end
    else
        pageInfo = string.format("%d/%d", Menu.CurrentCategory-1, #Menu.Categories-1)
    end
    if pageInfo ~= "" then
        local infoW = Susano.GetTextWidth and Susano.GetTextWidth(pageInfo, textSize) or (string.len(pageInfo)*7)
        Menu.DrawText(x+w-infoW-15, footerY+h/2-6, pageInfo, textSize, Menu.Colors.TextPrimary.r, Menu.Colors.TextPrimary.g, Menu.Colors.TextPrimary.b, 255)
    end
end

-- Efecto de nieve mejorado (partículas)
Menu.Particles = {}
for i=1, 120 do
    table.insert(Menu.Particles, {
        x = math.random(0,1000)/1000,
        y = math.random(0,1000)/1000,
        speedY = math.random(30,150)/10000,
        speedX = math.random(-40,40)/10000,
        size = math.random(1,3),
    })
end

function Menu.DrawBackground()
    local p = Menu.GetScaledPosition()
    local x = p.x
    local y = p.y
    local w = p.width-1
    -- fondo principal semi-transparente
    Menu.DrawRoundedRect(x, y, w, 900, Menu.Colors.GlassBg.r, Menu.Colors.GlassBg.g, Menu.Colors.GlassBg.b, Menu.Colors.GlassBg.a, p.headerRadius)

    if Menu.ShowSnowflakes then
        -- calcular altura total aproximada
        local totalH = 600 -- placeholder, pero se puede mejorar
        for _, part in ipairs(Menu.Particles) do
            part.y = part.y + part.speedY
            part.x = part.x + part.speedX
            if part.y > 1 then
                part.y = 0
                part.x = math.random(0,1000)/1000
            end
            if part.x < 0 then part.x = 1
            elseif part.x > 1 then part.x = 0 end
            local px = x + part.x * w
            local py = y + part.y * totalH
            Menu.DrawRect(px, py, part.size, part.size, 200, 220, 255, 150)
        end
    end
end

-- KeySelector rediseñado (estilo tecla)
function Menu.DrawKeySelector(alpha)
    if alpha <= 0 then return end
    local sw, sh = 1920, 1080
    if Susano.GetScreenWidth then sw, sh = Susano.GetScreenWidth(), Susano.GetScreenHeight() end
    local w, h = 380, 140
    local x = sw/2 - w/2
    local y = sh - 180
    Menu.DrawRoundedRect(x, y, w, h, 0,0,0, 200*alpha, 12)
    local title = "ASIGNAR TECLA RÁPIDA"
    Menu.DrawText(x+20, y+20, title, 16, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255*alpha)
    local itemName = Menu.BindingItem and Menu.BindingItem.name or "Opción"
    local keyName = Menu.BindingKeyName or "..."
    local status = "Presiona una tecla..."
    Menu.DrawText(x+20, y+55, itemName, 15, 255,255,255, 255*alpha)
    Menu.DrawText(x+20, y+80, status, 13, 180,180,200, 200*alpha)
    -- recuadro de tecla
    local boxW = 70
    local boxH = 50
    local boxX = x + w - boxW - 20
    local boxY = y + h/2 - boxH/2
    Menu.DrawRoundedRect(boxX, boxY, boxW, boxH, 20,25,40, 255*alpha, 8)
    Menu.DrawText(boxX+boxW/2-10, boxY+boxH/2-8, keyName, 18, 255,255,255, 255*alpha)
end

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
    local h = 40 + #binds * 28
    local x = sw - w - 20
    local y = 20
    Menu.DrawRoundedRect(x, y, w, h, 0,0,0, 180*alpha, 8)
    Menu.DrawText(x+15, y+10, "TECLAS RÁPIDAS", 14, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255*alpha)
    for i, bind in ipairs(binds) do
        local lineY = y + 35 + (i-1)*24
        local text = bind.name .. "  [" .. bind.key .. "]"
        if bind.active ~= nil then
            text = text .. (bind.active and "  ✓" or "  ✗")
        end
        Menu.DrawText(x+15, lineY, text, 12, 220,220,240, 220*alpha)
    end
end

function Menu.DrawLoadingBar(alpha)
    if alpha <= 0 then return end
    local sw, sh = 1920, 1080
    if Susano.GetScreenWidth then sw, sh = Susano.GetScreenWidth(), Susano.GetScreenHeight() end
    local cx, cy = sw/2, sh-150
    local r = 45
    local thickness = 6
    local angleStep = 2 * math.pi / 60
    for i=0,60 do
        local angle = -math.pi/2 + i*angleStep
        local px = cx + r * math.cos(angle)
        local py = cy + r * math.sin(angle)
        local size = thickness
        if i <= (Menu.LoadingProgress/100)*60 then
            Menu.DrawRect(px-size/2, py-size/2, size, size, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255*alpha)
        else
            Menu.DrawRect(px-size/2, py-size/2, size, size, 60,70,90, 200*alpha)
        end
    end
    local percent = string.format("%.0f%%", Menu.LoadingProgress)
    local tw = Susano.GetTextWidth and Susano.GetTextWidth(percent, 18) or (string.len(percent)*9)
    Menu.DrawText(cx-tw/2, cy-9, percent, 18, 255,255,255, 255*alpha)
end

-- =================== MANEJO DE ENTRADA ===================
Menu.KeyStates = {}
function Menu.IsKeyJustPressed(keyCode)
    if not Susano.GetAsyncKeyState then return false end
    local down, pressed = Susano.GetAsyncKeyState(keyCode)
    local wasDown = Menu.KeyStates[keyCode] or false
    Menu.KeyStates[keyCode] = down == true
    return (pressed == true) or (down == true and not wasDown)
end

-- Lista extendida de teclas para capturar (incluye DEL, INS, AvPág, RePág, etc.)
local captureKeys = {
    0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,
    0x4E,0x4F,0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A,
    0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,
    0x20,0x1B,0x08,0x09,0x10,0x11,0x12,
    0x25,0x26,0x27,0x28,
    0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A,0x7B,
    0x2D, -- Insert
    0x2E, -- Delete
    0x21, -- Page Up
    0x22, -- Page Down
    0x23, -- End
    0x24, -- Home
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

    -- Captura de tecla para binding
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

    -- Ejecutar teclas rápidas (bindings)
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

    -- Tecla para abrir/cerrar menú
    local toggleKey = Menu.SelectedKey or 0x31
    if Menu.IsKeyJustPressed(toggleKey) then
        Menu.Visible = not Menu.Visible
        if not Menu.Visible and not Menu.ShowKeybinds then
            if Susano.ResetFrame then Susano.ResetFrame() end
        end
    end

    if not Menu.Visible then return end

    -- Modo editor (arrastrar)
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
            -- comprobar si está sobre el menú
            local menuW = Menu.Position.width
            local totalH = Menu.Position.headerHeight + (Menu.OpenedCategory and 400 or 300) -- aprox
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
            newY = math.max(0, math.min(sh-300, newY))
            Menu.Position.x = newX
            Menu.Position.y = newY
        end
        -- mover con teclas
        local step = 10
        if Menu.IsKeyJustPressed(0x25) then Menu.Position.x = math.max(0, Menu.Position.x - step) end
        if Menu.IsKeyJustPressed(0x27) then Menu.Position.x = math.min(sw-Menu.Position.width, Menu.Position.x + step) end
        if Menu.IsKeyJustPressed(0x26) then Menu.Position.y = math.max(0, Menu.Position.y - step) end
        if Menu.IsKeyJustPressed(0x28) then Menu.Position.y = math.min(sh-300, Menu.Position.y + step) end
        return
    end

    -- Navegación normal
    if Menu.OpenedCategory then
        local cat = Menu.Categories[Menu.OpenedCategory]
        if not cat or not cat.hasTabs or not cat.tabs then
            Menu.OpenedCategory = nil
            return
        end
        local curTab = cat.tabs[Menu.CurrentTab]
        if curTab and curTab.items then
            if Menu.IsKeyJustPressed(0x26) then -- up
                Menu.CurrentItem = findNextNonSeparator(curTab.items, Menu.CurrentItem, -1)
            elseif Menu.IsKeyJustPressed(0x28) then -- down
                Menu.CurrentItem = findNextNonSeparator(curTab.items, Menu.CurrentItem, 1)
            elseif Menu.IsKeyJustPressed(0x25) or Menu.IsKeyJustPressed(0x41) or Menu.IsKeyJustPressed(0x51) then -- left / A / Q
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
                        if item.name == "Tema del menú" then Menu.ApplyTheme(item.options[idx])
                        elseif item.name == "Gradiente" then Menu.GradientType = tonumber(item.options[idx]) or 1
                        elseif item.name == "Posición barra de desplazamiento" then
                            Menu.ScrollbarPosition = (item.options[idx] == "Izquierda") and 1 or 2
                        end
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
            elseif Menu.IsKeyJustPressed(0x27) or Menu.IsKeyJustPressed(0x45) then -- right / E
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
                        if item.name == "Tema del menú" then Menu.ApplyTheme(item.options[idx])
                        elseif item.name == "Gradiente" then Menu.GradientType = tonumber(item.options[idx]) or 1
                        elseif item.name == "Posición barra de desplazamiento" then
                            Menu.ScrollbarPosition = (item.options[idx] == "Izquierda") and 1 or 2
                        end
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
            elseif Menu.IsKeyJustPressed(0x08) then -- backspace
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
            elseif Menu.IsKeyJustPressed(0x0D) then -- enter
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
                        if item.onClick then
                            item.onClick(item.selected, item.options[item.selected])
                        end
                    end
                end
            elseif Menu.IsKeyJustPressed(0x78) then -- F9: asignar tecla rápida al item actual
                local item = curTab.items[Menu.CurrentItem]
                if item and not item.isSeparator then
                    Menu.SelectingBind = true
                    Menu.BindingItem = item
                    Menu.BindingKey = item.bindKey
                    Menu.BindingKeyName = item.bindKeyName
                end
            end
            -- Cambiar de pestaña con Q/E o A/D (ya manejado en left/right pero solo si no hay item seleccionado que consuma)
            -- Añadimos explícitamente cambio de pestaña con Q/E (sin importar el item)
            if Menu.IsKeyJustPressed(0x51) then -- Q
                if Menu.CurrentTab > 1 then
                    Menu.CurrentTab = Menu.CurrentTab - 1
                    local newTab = cat.tabs[Menu.CurrentTab]
                    if newTab and newTab.items then
                        Menu.CurrentItem = findNextNonSeparator(newTab.items, 0, 1)
                    else
                        Menu.CurrentItem = 1
                    end
                elseif Menu.TopLevelTabs then
                    Menu.CurrentTopTab = Menu.CurrentTopTab - 1
                    if Menu.CurrentTopTab < 1 then Menu.CurrentTopTab = #Menu.TopLevelTabs end
                    Menu.UpdateCategoriesFromTopTab()
                end
            elseif Menu.IsKeyJustPressed(0x45) then -- E
                if Menu.CurrentTab < #cat.tabs then
                    Menu.CurrentTab = Menu.CurrentTab + 1
                    local newTab = cat.tabs[Menu.CurrentTab]
                    if newTab and newTab.items then
                        Menu.CurrentItem = findNextNonSeparator(newTab.items, 0, 1)
                    else
                        Menu.CurrentItem = 1
                    end
                elseif Menu.TopLevelTabs then
                    Menu.CurrentTopTab = Menu.CurrentTopTab + 1
                    if Menu.CurrentTopTab > #Menu.TopLevelTabs then Menu.CurrentTopTab = 1 end
                    Menu.UpdateCategoriesFromTopTab()
                end
            end
        end
    else
        -- Navegación de categorías
        if Menu.IsKeyJustPressed(0x26) then -- up
            Menu.CurrentCategory = Menu.CurrentCategory - 1
            if Menu.CurrentCategory < 2 then Menu.CurrentCategory = #Menu.Categories end
        elseif Menu.IsKeyJustPressed(0x28) then -- down
            Menu.CurrentCategory = Menu.CurrentCategory + 1
            if Menu.CurrentCategory > #Menu.Categories then Menu.CurrentCategory = 2 end
        elseif Menu.IsKeyJustPressed(0x0D) then -- enter
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
        elseif Menu.IsKeyJustPressed(0x25) or Menu.IsKeyJustPressed(0x41) then -- left / A (cambiar top tab)
            if Menu.TopLevelTabs then
                Menu.CurrentTopTab = Menu.CurrentTopTab - 1
                if Menu.CurrentTopTab < 1 then Menu.CurrentTopTab = #Menu.TopLevelTabs end
                Menu.UpdateCategoriesFromTopTab()
            end
        elseif Menu.IsKeyJustPressed(0x27) or Menu.IsKeyJustPressed(0x45) then -- right / E
            if Menu.TopLevelTabs then
                Menu.CurrentTopTab = Menu.CurrentTopTab + 1
                if Menu.CurrentTopTab > #Menu.TopLevelTabs then Menu.CurrentTopTab = 1 end
                Menu.UpdateCategoriesFromTopTab()
            end
        end
    end
end

-- Función para actualizar categorías desde top tabs (igual que la original)
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

-- Banner (igual)
Menu.Banner = { enabled = true, imageUrl = "https://i.imgur.com/dWBrem7.jpeg", height = 100 }
Menu.bannerTexture = nil
function Menu.LoadBannerTexture(url) -- implementación simplificada, la original ya existe
    if not url or url=="" then return end
    if not Susano or not Susano.HttpGet or not Susano.LoadTextureFromBuffer then return end
    CreateThread(function()
        local status, body = Susano.HttpGet(url)
        if status==200 and body and #body>0 then
            local tex, w, h = Susano.LoadTextureFromBuffer(body)
            if tex and tex~=0 then
                Menu.bannerTexture = tex
                Menu.bannerWidth = w
                Menu.bannerHeight = h
            end
        end
    end)
end

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

-- Input window (sin cambios relevantes)
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
    Menu.DrawRoundedRect(x, y, w, h, 0,0,0, 200, 8)
    Menu.DrawRect(x, y, w, 2, Menu.Colors.Accent.r, Menu.Colors.Accent.g, Menu.Colors.Accent.b, 255)
    Menu.DrawText(x+20, y+20, Menu.InputTitle, 20, 255,255,255, 255)
    Menu.DrawText(x+20, y+50, Menu.InputSubtitle, 14, 180,180,200, 255)
    local boxW = w-40
    local boxH = 30
    local boxX = x+20
    local boxY = y+80
    Menu.DrawRect(boxX-1, boxY-1, boxW+2, boxH+2, 60,70,90, 255)
    Menu.DrawRect(boxX, boxY, boxW, boxH, 20,25,40, 255)
    local display = Menu.InputText
    if math.floor(GetGameTimer()/500)%2==0 then display = display.."|" end
    if #display>30 then display = "..."..string.sub(display,-30) end
    Menu.DrawText(boxX+10, boxY+5, display, 16, 255,255,255, 255)
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
        if Menu.IsKeyJustPressed(i) then
            Menu.InputText = Menu.InputText .. string.char(i)
        end
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

-- Forzar fondo negro desactivado por defecto y nieve activada
-- (buscamos el item "Fondo negro" en Ajustes > General y lo ponemos a false)
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

if Menu.Banner.enabled and Menu.Banner.imageUrl then Menu.LoadBannerTexture(Menu.Banner.imageUrl) end
Menu.ApplyTheme("NeonGlass")
return Menu
