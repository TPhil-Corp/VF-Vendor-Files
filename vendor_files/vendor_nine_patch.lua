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
            Parser.log('Ninepatch - draft(%s) already exist, skipping...', id)
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
            local name_type = type(meta.name)
            if name_type == 'table' then
                for name, frame in pairs(meta.name) do
                    if not Vendor[vf_version].Ninepatch[name] then
                        Parser.log('Ninepatch - NP.%s indexed', name)
                        Vendor[vf_version].Ninepatch[name] = np:getFrame(frame)
                    end
                end
            elseif name_type == 'string' then
                if not Vendor[vf_version].Ninepatch[meta.name] then
                    Parser.log('Ninepatch - NP.%s indexed', meta.name)
                    Vendor[vf_version].Ninepatch[meta.name] = np:getFrame(1)
                end
            end
        end)
        if not scc then
            Parser.log('Ninepatch - could not find frames of draft(%s), skipping...', id)
        end
    end
end

return Ninepatch