local Parser = require'module/parser'
local GuiUtils = {}
GuiUtils.VERSION = '0.2'
GuiUtils.AUTHOR = 'Hadestia & Erksmit'
GuiUtils.DEFAULT_PADDING = {1, 1, 1, 1}

local CONTROLLER_ID = 'hdst.vendorMainController'

function GuiUtils.__tostring()
    return 'GUI helper module'
end

-----> UTILITY FUNCTIONS

---@return GUI[] root
local function getRoot()
    local main = GUI.getRoot()
    -- index easy size fetcher
    main.w = main:getWidth()
    main.h = main:getHeight()
    main.vW = main:getClientWidth()
    main.vH = main:getClientHeight()
    
    return main
end

-- a function that check whether the desire size was in decimal or a whole number, if true the value will be calculated to the given max value to get the part of it, this is for gui object sizes
---@param maxvalue? number the maxsize of a gui object returned by e.g obj:getClientWidth()
---@param value? number o float
---@return number return the value if it was a whole number or a calculated part taken from the given max value
local function parseSize(maxvalue, value)
    if not maxvalue or not value then
        error('Attempt to perform arithmetic operation to a nil value')
    end
    -- check decimal
    if value >= 0 and value <= 1 then
        return maxvalue * value
    end
    return value
end

--# former adjustSize()
-- makes the size secure with the given max value
---@param max number the max size
---@param value number the initial size
---@return number
local function clamp(max, value)
    -- parse first the size
    value = parseSize(max, value)
    if max >= value then
        return value
    elseif max < value then
        return max
    end
end

--# former parseHexColor()
-- a function that parse whether the parameter color was a hex color code
---@param color it can be a table of rgb values or a string(hex code: 4 or 7 characters including '#')
---@return nunber or unpacked numbers from rgb table
local function parseHexColor(color)
    if not color then
        error('Attemp to parse a nil value color')
    end

    if type(color) == 'table' then
        for i = 1, 3 do
            -- set a default color if the table element was not 3 in size
            if not color[i] then color[i] = 255 end
        end
        return table.unpack(color)
    elseif type(color) == 'string' then
        local hex = color:gsub("#","")
        if hex:len() == 3 then
            return ((tonumber("0x"..hex:sub(1,1))*17)/255)*255,
            ((tonumber("0x"..hex:sub(2,2))*17)/255)*255,
            ((tonumber("0x"..hex:sub(3,3))*17)/255)*255
        elseif hex:len() == 6 then
            return (tonumber("0x"..hex:sub(1,2))/255)*255,
            (tonumber("0x"..hex:sub(3,4))/255)*255,
            (tonumber("0x"..hex:sub(5,6))/255)*255
        else
            error('You can only parse 4 and 7 hex characters including \'#\'')
        end
    end
end

---@param size number constant size
---@param data number[] data size
---@return number
local function getBarScale(size, data)
    local sum = 0
    for _, v in pairs(data) do
        sum = sum + v.value
    end
    return size / sum
end

---@param size number constant size
---@param data number[] table of values
---@return number scale
local function getBarSize(size, scale, data)
    return (size * scale) * (data / size)
end

---@param index number the index of the progress bar, this is for the gradient scaling for bar colors if color parameter wasn't specified [optional]
---@param color number[] table of rgb values
---@return number, number, number unpacked values
local function getBarColor(index, color)
    local default = 255 - ((index or 1) * 10)
    if color then
        return parseHexColor(color)
    end
    return default, default, default
end

-- a function that parse a padding from table or number that was related to CSS
---@param pt number value for all sides or number[] table of values
---@param size number alternative value for nil values
---@return number, number, number, number
local function getPadding(pt, size)
    if pt then
        local types = type(pt)
        if types == 'table' then
            local pl, pt, pr, pb = table.unpack(pt)
            pl = pl or size
            pt = pt or size or pl
            pr = pr or size or pl
            pb = pb or size or pt
            return pl, pt, pr, pb
        elseif types == 'number' then
            return pt, pt, pt, pt
        end
    end
    size = size or 0
    return size, size, size, size
end

---@param alignment number[] table of x & y decimal value
---@return number, number unpacked values
local function getAlignment(alignment)
    if alignment then 
        return table.unpack(alignment)
    end
    return 0.5, 0.5
end

-----> ON EVENTS

function GuiUtils.enterCity(cmd)
	Parser.log('GuiUtils - enterCity')
    Vendor.secure(cmd)
    GuiUtils.floating_notifs = Array()
end

function GuiUtils.buildCityGui(cmd)
	Parser.log('GuiUtils - buildCityGui')
    Vendor.secure(cmd)
    local main = getRoot()
    -- ## FLOATING NOTIF ROOT OBJECT ## --
    -- delete if the object was already exist
    local layout = GUI.get('hdst.vendor.guiutils.floating.notifs.section.gui00')
    
    if layout then
        layout:delete()
        layout = nil
    end
    layout = main:addLayout{}
    layout:setChildIndex(999)
    local vw, vh = layout:getClientWidth(), layout:getClientHeight()
    local refresher = layout:getCenterPart():addCanvas{
        id = 'hdst.vendor.guiutils.floating.notifs.section.gui00',
        y = GUI.get('cmdBuild'):getHeight(),
        w = (vw * 0.4) * -1,
        h = (vh * 0.6) * -1,
        onInit = function (self)
            self:setTouchThrough(false)
        end,
        onUpdate = function ()
            local notifSection = GUI.get('hdst.vendor.guiutils.floating.notifs.mainList')
            if notifSection and #GuiUtils.floating_notifs > 0 then
                GuiUtils.floating_notifs:forEach(function (notif)
                    if notifSection.itemCount < 4 and not GUI.get(notif.id) then
                        local textLayout = notifSection:addLayout{
                            h = notifSection.itemH,
                            id = notif.id,
                            onInit = function (self)
                                notifSection.itemCount = notifSection.itemCount + 1
                                self:setChildIndex(notifSection.itemCount)
                                Runtime.postpone(function ()
                                    self:delete()
                                    notifSection.itemCount = notifSection.itemCount - 1
                                    GuiUtils.floating_notifs:remove(notif)
                                end, 2000)
                            end
                        }
                        textLayout:addLabel{
                            text = notif.text,
                            onInit = function (self)
                                self:setColor(parseHexColor(notif.color))
                                self:setFont(notif.font)
                            end
                        }:setAlignment(0.5, 0.5)
                        
                    end
                end)
            end
        end
    }
    
    
    refresher:getCenterPart():addLayout{
        id = 'hdst.vendor.guiutils.floating.notifs.mainList',
        vertical = true, spacing = 1,
        onInit = function (self)
            self.itemCount = 0
            self.itemH = (self:getClientHeight() - 4)/4
        end
    }
end

-----> API

-- function that checks whether the screen was landscape or portrait
---@return number 0 being landscape | 1 for being portrait
function GuiUtils.orientation()
    local w, h = Drawing.getSize()
    if w >= h then
        return 0
    elseif w < h then
        return 1
    end
end

-- returns the absolute screen size for gui
---@param getRoot boolean determine whether to returns the root gui [optional]
---@return root GUI[] the root gui [optional]
---@return width width inside the root
---@return height height inside the root
function GuiUtils.getScreenSize(getRoot)
    local root = getRoot()
    if getRoot then
        return root, root:getClientWidth(), root:getClientHeight()
    end
    return root:getClientWidth(), root:getClientHeight()
end

--# former GuiUtils.getSectionSize()
-- divides the size(max size) by the given amount
---@param size number
---@param count number
---@return number a part from the whole size
function GuiUtils.getPart(size, count)
    return (size - count) / count
end

-- sets a window size by providing sizes(in decimal) function calculate it as similar to (size * 0.5). returns a size depending on users resolution
---@param root GUI[] gui object where the calculation takes place, if not provided calculation takes place from the object returned by GUI.getRoot() [optional]
---@return width: the width from the calculated percentage
---@retuen height: the height from the calculated percentage
function GuiUtils.setWindowSize(root, pw, ph)
    root = root or getRoot()
    return (root:getClientWidth() * pw), (root:getClientHeight() * ph)
end

-- creates a 'custom raw' window layout from the main screen
---@param arg table of arguments
---@returns GUI[] Layout object
function GuiUtils.createBaseWindow(arg)
    -- set default state
    arg.sensitiveTouch = arg.sensitiveTouch or true

    -- get root
    local main_screen = getRoot()
    -- draw background canvas (blur behind the main window actually shadow)
    local blur = main_screen:addCanvas{
        onInit = function (self)
            self:setPadding(0, 0, 0, 0)
            self.backup_cityspeed = City.getSpeed()
            if arg.pause then
                City.setSpeed(0)
            end
        end,
        onDraw = function (self, x, y, w, h)
            -- returns all the param from this function if committed to modify
            if arg.background then
                arg.background(self, x, y, w, h)
            else
                Drawing.setAlpha(0.5)
                Drawing.setColor(0, 0, 0)
                Drawing.drawRect(-50, y, w + 100, h)
                Drawing.reset()
            end
        end,
        onClick = function (self)
            if arg.sensitiveTouch then
                if arg.onClose then
                    arg.onClose(self)
                    if arg.pause then
                        City.setSpeed(self.backup_cityspeed)
                    end
                end
                self:delete()
                self = nil
            end
        end,
        onUpdate = arg.onUpdate
    }
    -- set background sizes
    local screen_w, screen_h = blur:getClientWidth(), blur:getClientHeight()
    
    -- main window
    local layout = blur:addLayout{
        id = arg.id or nil,
        x = (screen_w - (clamp(screen_w, arg.width)))/2,
        y = (screen_h - (clamp(screen_h, arg.height)))/2,
        w = clamp(screen_w, arg.width or arg.w or 200),
        h = clamp(screen_h, arg.height or arga.h or 200),
        spacing = arg.spacing or 0,
        onInit = function (self)
            if arg.onInit then
                arg.onInit(self, self:getX(), self:getY(), self:getClientWidth(), self:getClientHeight())
            end
            self.delete = function ()
                blur:delete()
                blur = nil
            end
        end,
        onUpdate = function (self)
            if arg.onUpdate then
                arg.onUpdate(self, self:getX(), self:getY(), self:getClientWidth(), self:getClientHeight())
            end
        end
    }
    ---@type GUI[] Layout
    return layout
end

-- creates a dialog, where the borders and center of the 9patch are looped, to prevent stretching
---@param baseFrame number the base frame of the 9patch
---@param tileSize number int, the size of a tile in the frame. Both the width and height of the dialog MUST be divisble by this value, 10, 20, 40 are reccomended values
---@param dialog? gui the dialog to apply the background to, leave empty to create a new dialog
---@param overlapBorders? boolean whether to overlap side and center tiles of the frame by 1 pixel, false by default
---@return gui dialog the created dialog
function GuiUtils.tileDialogBackground(baseFrame, tileSize, dialog, overlapBorders)
    local function setOnDraw(dialog, func)
        local panelRoot = dialog.content:getParent()
        local pl, pt, pr, pb = panelRoot:getPadding() -- Extract padding information to place overlay panel correctly

        local panelOverlay = panelRoot:addPanel { onDraw = func }

        panelOverlay:setChildIndex(1) -- Ensure that the overlay is drawn directly on top of the window before other stuff
        panelOverlay:setPosition(-pl, -pt)
        panelOverlay:setSize(panelOverlay:getWidth() + pl + pr, panelOverlay:getHeight() + pt + pb)
        return panelOverlay
    end

    ---@type number[]
    NinePatch = {}
    for i = 0, 8, 1 do
        NinePatch[i + 1] = baseFrame + i
    end

    -- set default values
    dialog = dialog or GUI.createDialog {}
    overlapBorders = overlapBorders or false
    local panelRoot = dialog.content:getParent()
    local pl, pt, pr, pb = panelRoot:getPadding()
    local w, h = panelRoot:getClientWidth() + pl + pr, panelRoot:getClientHeight() + pt + pb

    -- lets precalculate where we need to draw the frames
    local frames = {}
    local locationsX = {}
    local locationsY = {}
    local function addDrawOrder(x, y, frame)
        table.insert(frames, frame)
        table.insert(locationsX, x)
        table.insert(locationsY, y)
    end

    local verticalTileCount = h / tileSize
    local horizontalTileCount = w / tileSize

    -- start with the center frames
    for x = 1, horizontalTileCount - 1, 1 do
        for y = 1, verticalTileCount - 1, 1 do
            addDrawOrder(x * tileSize, y * tileSize, NinePatch[4])
        end
    end

    -- left and right border
    for y = 1, verticalTileCount - 1, 1 do
        addDrawOrder(0, y * tileSize, NinePatch[3])
        addDrawOrder(w - tileSize, y * tileSize, NinePatch[5])
    end

    -- top and bottom border
    for x = 1, horizontalTileCount - 1, 1 do
        addDrawOrder(x * tileSize, 0, NinePatch[1])
        addDrawOrder(x * tileSize, h - tileSize, NinePatch[7])
    end

    -- corners
    addDrawOrder(0, 0, NinePatch[0])
    addDrawOrder(w - tileSize, 0, NinePatch[2])
    addDrawOrder(0, h - tileSize, NinePatch[6])
    addDrawOrder(w - tileSize, h - tileSize, NinePatch[8])

    -- overlay the dialog's ondraw
    setOnDraw(dialog, function(self, x, y, w, h)
        for i = 1, #frames, 1 do
            Drawing.drawImageRect(frames[i], locationsX[i] + x, locationsY[i] + y, tileSize, tileSize)
        end
    end)

    return dialog
end

-- draws a NinePatch as a background on a gui object. Probably doesnt work on dialog objects
---@param parent GUI[] layout
---@param frame number ninpatch frame to use as background
---@param padding? number[] for padding that will set for all sides, can also put a single number
---@return GUI canvas the created canvas
function GuiUtils.addBackground(parent, frame, padding)
    local pl, pt, pr, pb = parent:getPadding()
    local overlayBackground = parent:addPanel {
        onInit = function (self)
            if padding then
                self:setPadding(getPadding(padding))
            else
                self:setPadding(table.unpack(GuiUtils.DEFAULT_PADDING))
            end
        end,
        onDraw = function(self, x, y, w, h)
            if frame then
                --Drawing.reset()
                Drawing.drawNinePatch(frame, x, y, w, h)
            end
        end
    }
    
    overlayBackground:setChildIndex(1)
    overlayBackground:setPosition(pl, pt)
    overlayBackground:setSize(parent:getWidth() - pl - pr, parent:getHeight() - pt - pb)
    return overlayBackground
end

-- draws a horizontal progress bar up to 4 values
---@param arg table of arguments
function GuiUtils.addHorizontalBar(arg)
    ---@type GUI
    local parent = arg.parent
    ---@type table[]
    local values = arg.values
    ---@type number
    local frame = arg.frame or NinePatch.PANEL
    return parent:addCanvas {
        h = arg.h or arg.height or nil, w = arg.w or arg.width or nil,
        onDraw = function(self, x, y, w, h)
            local fw, sw, tw, ffw
            local scale = getBarScale(w, values)
            -- first bar
            fw = getBarSize(w, scale, values[1].value)
            Drawing.setColor(getBarColor(1, values[1].color))
            Drawing.drawImageRect(frame, x, y, fw, h)
            -- second bar
            sw = getBarSize(w, scale, values[2].value)
            Drawing.setColor(getBarColor(2, values[2].color))
            Drawing.drawImageRect(frame, x + fw, y, sw, h)

            -- for more than 2 values
            -- third bar
            if values[3] then
                tw = getBarSize(w, scale, values[3].value)
                Drawing.setColor(getBarColor(3, values[3].color))
                Drawing.drawImageRect(frame, x + fw + sw, y, tw, h)
            end
            -- fourth bar
            if values[4] then
                ffw = getBarSize(w, scale, values[4].value)
                Drawing.setColor(getBarColor(4, values[4].color))
                Drawing.drawImageRect(frame, x + fw + sw + tw, y, ffw, h)
            end
            
            arg.showLabel = arg.showLabel or true
            if arg.showLabel and arg.label then
                local font = arg.font or Font.DEFAULT
                local label = arg.label
                Drawing.setColor(parseHexColor(arg.color))
                Drawing.drawText(label, x + w / 2, y + h / 2, font, 0.5, 0.5)
            end

            Drawing.reset()
        end,

        onInit = function(self)
            local pl, pt, _, _ = arg.parent:getPadding()
            self:setPadding(getPadding(arg.padding))
            self:setPosition(pl, pt)
            self:setSize(arg.parent:getClientWidth() - pl, arg.parent:getClientHeight() - pt)
        end
    }
end

-- draws a vertical progress bar up to 4 values
---@param arg = table or arguments
function GuiUtils.addVerticalBar(arg)
    local parent = arg.parent
    local values = arg.values
    local frame = arg.frame
    return parent:addCanvas {
        h = arg.h or arg.height, w = arg.w or arg.width,
        onDraw = function(self, x, y, w, h)
            local scale = getBarScale(h, values)
            local ffh, th, sh, fh
            -- indexed in descending order

            -- fourth bar
            if values[4] then
                ffh = getBarSize(h, scale, values[3].value)
                Drawing.setColor(getBarColor(3, values[3].color))
                Drawing.drawRect(x, y, w, ffh)
            end

            -- third bar
            if values[3] then
                th = getBarSize(h, scale, values[3].value)
                Drawing.setColor(getBarColor(3, values[3].color))
                Drawing.drawRect(x, y + (ffh or 0), w, th)
            end

            -- second bar
            sh = getBarSize(h, scale, values[2].value)
            Drawing.setColor(getBarColor(2, values[2].color))
            Drawing.drawRect(x, y + (th or 0), w, sh)

            -- first bar
            fh = getBarSize(h, scale, values[1].value)
            Drawing.setColor(getBarColor(1, values[1].color))
            Drawing.drawRect(x, y + th + sh, w, fh)
            Drawing.reset()
        end,

        onInit = function(self)
            local pl, pt, _, _ = arg.parent:getPadding()
            self:setPadding(getPadding(arg.padding))
            self:setPosition(pl, pt)
            self:setSize(arg.parent:getClientWidth() - pl, arg.parent:getClientHeight() - pt)
        end
    }
end

-- adds multiple layouts (either rows or columns) to the given gui parent
---@param arg? table[] table of arguments
-- arg.parent gui the gui object to add the rows to
-- arg.amount number the amount of rows to create
-- arg.vertical boolean whether to create columns, or rows
-- arg.size? number[] the heights of the rows, values should add up to 1. If left empty rows will take up as much height as possible
-- arg.padding? number[] the default padding to apply to the parent of created rows or column, can be a single number [optional]
-- arg.contentPadding? number[][] the default padding to apply in every created sections, can be a single number or all 4 sides [optional]
-- arg.contentOrientation? boolean[] the orientation of the created layout whether to make it vertical or not, default false if not provided [optional]
---@return gui[] rows a table of created rows
function GuiUtils.createLayouts(arg)
    local layouts = {}
    local baseSize

    if arg.vertical then
        baseSize = arg.parent:getClientHeight()
    else
        baseSize = arg.parent:getClientWidth()
    end

    local layoutSize = GuiUtils.getPart(baseSize, arg.amount)

    local layout = arg.parent:addLayout{
        vertical = arg.vertical,
        spacing = arg.spacing or 0,
        onInit = function(self)
            self:setPosition(0, 0)
        end
    }
    -- set padding on parent gui if provided
    if arg.padding then
        layout:setPadding(getPadding(arg.padding))
    end

    for i = 1, arg.amount do
        local adjustedSize, id
        if arg.ids then id = arg.ids[i] end

        if arg.sizes then
            adjustedSize = arg.sizes[i] * baseSize
        else
            adjustedSize = layoutSize
        end

        local section
        local orientation = arg.contentOrientation or {}
        if arg.vertical then
            section = layout:addLayout{
                id = id or nil,
                vertical = orientation[i] or false,
                height = adjustedSize,
            }
        else
            section = layout:addLayout{
                id = id or nil,
                vertical = orientation[i] or false,
                width = adjustedSize,
            }
        end
        -- set padding for the content created if provided
        if arg.contentPadding then
            local padding = arg.contentPadding
            section:setPadding(getPadding(padding.all or padding[i], 1))
        else
            section:setPadding(table.unpack(GuiUtils.DEFAULT_PADDING))
        end
        -- easy size fetcher
        section.width = section:getWidth()
        section.height = section:getHeight()
        section.client_width = section:getClientWidth()
        section.client_height = section:getClientHeight()
        
        layouts[i] = section
    end

    return layouts
end

-- adds a line with label and value on a object
---@param arg? table[] table or arguments
-- arg.parent gui the gui object to add line
-- arg.alignLabel? number[] table of x & y value up to 1
-- arg.alignValue? number[] table of x & y value up to 1
-- arg.height number the height of layout to create
-- arg.icon number the frame for line icon
-- arg.label string the label for the line created
-- arg.value string the text that next with the label
-- arg.font number for the text font, default font will applied if not provided
-- arg.color? number[] table of rgb values
---@return GUI[] object
function GuiUtils.addLineValue(arg)
    local data = {}
    local lblX, lblY = 0.05, 0.5
    local valX, valY = 0.8, 0.5
    if arg.alignLabel then
        lblX, lblY = getAlignment(arg.alignLabel)
    end
    if arg.alignValue then
        valX, valY = getAlignment(arg.alignValue)
    end

    local line = arg.parent:addLayout { height = arg.height or nil }
    --icon
    if arg.icon then
        local icon = line:addIcon { icon = arg.icon or nil, w = 20 }
        icon:setAlignment(0.0, 0.5)
        data.icon = icon
    end
    --label
    if arg.label then
        local label = line:addLabel { text = arg.label, w = 50 }
        label:setAlignment(lblX, lblY)
        label:setColor(parseHexColor(arg.color, 0))
        if arg.font then label:setFont(arg.font) end
        data.label = label
    end
    --value
    if arg.value then
        local value = line:addLabel { text = arg.value, w = 50 }
        value:setAlignment(valX, valY)
        value:setColor(parseHexColor(arg.color, 0))
        if arg.font then value:setFont(arg.font) end
        data.value = value
    end
    return data
end

-- adds a line layout into the given gui object
---@param arg? table[] table of arguments
-- arg.x number the x offset of the created layout, default is 1 if not provided [optional]
-- arg.height number the height of the layout to create
-- arg.width number the width of the layout to create, default 30 if not provided [optional]
-- arg.label string the label for the created line
-- arg.addValue? function whether to add a value for the line [optional]
---@return GUI[], GUI[] the label & layout created after label
function GuiUtils.addLine(arg)
    local line = arg.parent:addLayout{x = arg.x or 1, height = arg.height}
    local label = line:addLabel{text = arg.label, w = arg.width or 30}
    local valueLine = line:addLayout{ x = (arg.width or 30) + (arg.valueX or 1) }
    if arg.addValue then
        arg.addValue(label, valueLine)
    end
   return label, valueLine
end

-- adds a modified item to a listbox
---@param arg table contain object value
-- arg.h number height of the item [optional]
-- arg.color? number[] or number table of rgb values or hex code [optional]
-- arg.frame number frame for item background [optional]
-- arg.background boolean whether to toggle default background [optional]
-- arg.padding? number[] table of padding for all the sides [optional]
-- arg.content? table[] table of arguments [optional]
-- arg.content.icon.icon number the icon or frame [optional]
-- arg.content.icon.align? number[] table of x & y alignment up to 1 for icon [optional]
-- arg.content.label.text string the label for the item created [optional]
-- arg.content.label.align? number[] table of x & y alignment up to 1 for label [optional]
-- arg.content.label.color? number[] or number table of rgb values or hex code [optional]
-- arg.content.value.text string the text next to the label created [optional]
-- arg.content.value.align number[] table of x & y alignment up to 1 for value [optional]
-- arg.content.value.colorize boolean set color same as label if has [optional]
-- arg.content.value.color? number[] or number table of rgb values or hex code [optional]
---@return GUI[] canvas or layout ih content was defined
function GuiUtils.addListboxItem(arg)
    local mainItem = arg.parent:addCanvas {
        h = arg.h or 26,
        listboxBackground = arg.background or false,
        onDraw = function(self, x, y, w, h)
            if arg.frame then
                Drawing.setAlpha(arg.opacity or 1.0)
                Drawing.setColor(parseHexColor(arg.color))
                Drawing.drawNinePatch(arg.frame or NinePatch.PANEL, x, y, w, h)
                Drawing.reset()
            end
        end
    }
    --set padding, 0 by default if not set
    mainItem:setPadding(getPadding(arg.padding))

    if arg.content then
        local layout = mainItem:addLayout {}
        local content = arg.content
        --icon
        if content.icon then
            local icon = content.icon
            local icon_obj = layout:addIcon { icon = icon.icon, w = icon.w or 26, h = icon.h or 26 }
            if icon.align then icon_obj:setAlignment(getAlignment(icon.align)) end
        end
        --label
        if content.label then
            local label = content.label
            local label_obj = layout:addLabel { text = label.text, w = label.w or 50 }
            label_obj:setColor(parseHexColor(label.color, 0))
            if label.align then label_obj:setAlignment(getAlignment(label.align)) end
        end
        --value
        if content.value then
            local value = content.value
            local value_obj = layout:addLabel { text = value.text, w = value.w or 50 }
            if value.align then value_obj:setAlignment(getAlignment(value.align)) end
            value_obj:setColor(parseHexColor(value.color))
            --state whether to set color for value same as label
            if value.colorize then value_obj:setColor(parseHexColor(content.label.color)) end
        end
        --returns the whole layout if has content
        return layout
    end
    --returns the whole canvas if content were not set
    return mainItem
end

function GuiUtils.addCheckBox(arg)
	local COLOR = arg.color or {255, 255, 255}
	
	local function getF(bool)
		if bool then
			return Vendor.v3_1_0.Icon.CHECKBOX_CHECK or Icon.OK
		end
		return Vendor.v3_1_0.Icon.CHECKBOX_UNCHECK or Icon.CANCEL
	end
	
	arg.parent:addLayout{
		x = arg.x, y = arg.y, w = arg.w or arg.width, h = arg.h or arg.height
	}:addCanvas{
		id = arg.id,
		onInit = function (s)
			s.value = arg.value()
			s.renderIcon = getF(s.value)
		end,
		onDraw = function (s, x, y, w, h)
			Drawing.setAlpha(arg.alpha or 1.0)
			Drawing.setColor(table.unpack(COLOR))
			Drawing.drawQuad(
				x, y,         -- v0
				x, y + h,     -- v1
				x + w, y + h, -- v2
				x + w, y,     -- v3
				s.renderIcon
			)
			Drawing.reset()
		end,
		onUpdate = function (s)
			s.value = arg.value()
			if s.value ~= nil then
				s.renderIcon = getF(s.value)
			end
		end,
		onClick = function (s)
			arg.onChange(not s.value)
		end
	}
end

-- adds a floating alert notification at the center of the screen
function GuiUtils.alertNotif(text, color, font)

    if not text then
        error('Attempt to display notification with an empty string')
    end

    local notif = {
        id = Runtime.getUuid(),
        text = text,
        color = color or {255, 255, 255},
        font = font or Font.DEFAULT
    }
    GuiUtils.floating_notifs:add(notif)
end

return GuiUtils