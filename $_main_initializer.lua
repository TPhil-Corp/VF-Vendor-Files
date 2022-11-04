local prefixPath = 'vendor_files/'
local cmd = 'hdst.vendorMainController'

local Modules = {
    Env = 'vendor_env',
    GuiUtils = 'vendor_gui_utils',
    Ninepatch = 'vendor_nine_patch'
}
-- create custom lib
if Vendor or not Vendor then
    Vendor = Vendor or {}
    -- check whether sub modules was there
    for moduleName, fileName in pairs(Modules) do
        if not Vendor[moduleName] then
            Vendor[moduleName] = require(prefixPath..fileName)
        end
    end
end

-- append Ninepatch Raw Json
Vendor.Ninepatch.appendRaw(cmd)

function script:init()
    -- initialize/index all appended ninepatch
    Vendor.Ninepatch.init(false, cmd)
end

function script:buildCityGUI()
    if GUI.get('sidebarLine') then
        Vendor.GuiUtils.buildCityGui()
    end
end

function script:enterCity()
    Vendor.GuiUtils.enterCity(cmd)
end

function script:update()
    -- hide GuiUtils notif section if user was using tool
    GUI.get('hdst.vendor.guiutils.floating.notifs.section.gui00'):setVisible(
        not GUI.get('cmdCloseTool'):isVisible()
    )
end