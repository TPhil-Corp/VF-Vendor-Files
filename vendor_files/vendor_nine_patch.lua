local Parser = require'module/parser'
local Ninepatch = {}

Ninepatch.VERSION = 0.1
Ninepatch.AUTHOR = 'Hadestia'

function Ninepatch.__tostring()
    return 'Custom NinePatches By Hadestia'
end

Ninepatch.appended_draft = {}
Ninepatch.available_ninepatch = {}

-- appends all the ninepatch as draft
function Ninepatch.appendRaw(data, cmd)
    Parser.log('Ninepatch - appendRaw()')
    Vendor.secure(cmd)
    for id, draftSTR in pairs(data.ninepatch) do
        Parser.log('Ninepatch - appending draft(%s)', id)
        if not Draft.getDraft(id) then
            Draft.append(draftSTR)
            Vendor[data.VERSION].Ninepatch.appended_draft[id] = true
        else
            Vendor[data.VERSION].Ninepatch.appended_draft[id] = true
        end
    end
end

-- get all the frames of all appended drafts
function Ninepatch.init(cmd, vf_version)
    Parser.log('Ninepatch - init')
    Vendor.secure(cmd)
    for id in pairs(Vendor[vf_version].Ninepatch.appended_draft) do
        Parser.log('Ninepatch - getting frame[s] of draft(%s)', id)
        local scc = pcall(function ()
            local np = Draft.getDraft(id)
            local meta = np:getMeta()
            local frame = np:getFrame(1)
            Vendor[vf_version].Ninepatch[meta.name] = frame
            --Vendor[vf_version].Ninepatch.available_ninepatch[meta.name] = frame
        end)
        if not scc then
            Parser.log('Ninepatch - could not find frames of draft(%s), skipping...', id)
        end
    end
end

return Ninepatch