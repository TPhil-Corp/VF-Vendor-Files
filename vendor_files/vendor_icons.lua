local Parser = require'module/parser'
local Icons = {}
Icons.appendedDraft = {}
Icons.available_icon = {}

function Icons.appendRaw(data, cmd) ---@param data meta
    Parser.log('Icon - appendRaw()')
	Vendor.secure(cmd)
	for id, draftSTR in pairs(data.gui_icon) do
		Parser.log('Icons - appending draft(%s)', id)
		if not Draft.getDraft(id) then
			-- append if no such draft exist
			Draft.append(draftSTR)
			Vendor[data.VERSION].Icon.appendedDraft[id] = true
		else
			Vendor[data.VERSION].Icon.appendedDraft[id] = true
		end
	end
end

function Icons.init(cmd, vf_version)
	Parser.log('Icons - init')
	Vendor.secure(cmd)
	for id in pairs(Vendor[vf_version].Icon.appendedDraft) do
		Parser.log('Icon - getting frame[s] of draft(%s)', id)
		local scc = pcall( function ()
			local draft = Draft.getDraft(id)
			local meta = draft:getMeta()
			if type(meta.name) == 'table' then
				for name, frame in pairs(meta.name) do
					if not Vendor[vf_version].Icon[name] then
					    Vendor[vf_version].Icon[name] = draft:getFrame(frame)
					end
				end
			elseif type(meta.name) == 'string' then
				if not Vendor[vf_version].Icon[meta.name] then
				    Vendor[vf_version].Icon[meta.name] = draft:getFrame(1)
				end
			end
		end)
		if not scc then
			Parser.log('Icon - could not find frame[s] of draft(%s), skipping...', id)
		end
	end
end

return Icons