local Parser = require'module/parser'
local prefixPath = 'vendor_files/'
local cmd = 'hdst.vendorMainController'
local errMssg = 'Unauthorize use of Function'

-- ***************************************************************** --
-- HADESTIA! DON'T FORGET TO INCREASE META VERSION IN EVERY CHANGES.
-- ***************************************************************** --

local sDRAFT = script:getDraft()
local META = sDRAFT:getMeta()
Parser.version = META.VERSION

local dateF = '%m/%d'

local Modules = {
	DT = 'vendor_dt',
    Env = 'vendor_env',
    Icon = 'vendor_icons',
    GuiUtils = 'vendor_gui_utils',
    Ninepatch = 'vendor_nine_patch'
}

if not Vendor then
    Vendor = {}   
end
Vendor.supportLink = 'https://recutt.com/xcI/59112949'

-- vendor file versions to avoid conflict with other plugins
Vendor[META.VERSION] = Vendor[META.VERSION] == nil and {} or Vendor[META.VERSION]

-- secure function
if not Vendor.secure then
    Vendor.secure = function (cid)
        if not cid == cmd then
        	error(errMssg)
        end
    end
end

-- initialize cake
if not Draft.getDraft('$hdst-cake-flame00') and not Draft.getDraft('$hdst.HadestiasCake') then
    local scc = pcall(function ()
    	Draft.append(META.cake)
    	if os.date(dateF) == '12/01' and not Draft.getDraft('hdst-greeat-text') then
        	Draft.append('[{"id":"hdst-greeat-text", "type":"topic", "text":"Tomorrow is Hadestia\'s Day, Advance Happy birthday! :)","weight":10}]')
        end
    end)
    if not scc then
        Parser.log('Couldn\'t append Hadestia\'s cake, skipping...')
    end
end

-- append Modules
for moduleName, fileName in pairs(Modules) do
    if not Vendor[META.VERSION][moduleName] then
        Parser.log('Preparing module: %s', moduleName)
        local success, err = pcall(function() Vendor[META.VERSION][moduleName] = require(prefixPath..fileName) end)
        if not success then
            Parser.log(err)
        end
    end
end

-- append module raw jsons
for moduleName in pairs(Modules) do
    if Vendor[META.VERSION][moduleName].appendRaw then
        local success, err = pcall(function() Vendor[META.VERSION][moduleName].appendRaw(META, cmd) end)
        if not success then
            Parser.log(err)
        end
    end
end

function script:init()

    Parser.log('main - init')
    -- cake visible state
    if os.date(dateF) == '12/02' then
    	pcall(function() Draft.getDraft('$hdst.HadestiasCake'):setVisible(true) end)
    end
    
    -- initialize/index all appended types
    for moduleName in pairs(Modules) do
        if Vendor[META.VERSION][moduleName].init then
            local success, err = pcall(function() Vendor[META.VERSION][moduleName].init(cmd, META.VERSION) end)
            if not success then
                Parser.log(err)
            end
        end
    end
end

function script:buildCityGUI()
    if GUI.get('sidebarLine') then
    	if Vendor[META.VERSION].GuiUtils.buildCityGui then
       	 Vendor[META.VERSION].GuiUtils.buildCityGui()
        end
    end
end

function script:enterCity()
    if Vendor[META.VERSION].GuiUtils.enterCity then
        Vendor[META.VERSION].GuiUtils.enterCity(cmd)
    end
end

function script:update()
    -- hide GuiUtils notif section if user was using tool
    local guiFN = GUI.get('hdst.vendor.guiutils.floating.notifs.section.gui00')
    if guiFN then
        guiFN:setVisible( not GUI.get('cmdCloseTool'):isVisible() )
    end
end