local DT = {}

DT.VERSION = '0.1'
DT.AUTHOR = 'Hadestia'
DT.DESCRIPTION = 'Developer Tools, Include some error handling function you can use to execute your code smoothly'

local function showErrorMssg(MSSG, subText)
	local dialog = GUI.createDialog{
		icon = Icon.OK, w = 250, h = 175,
		title = "Oops, Unexpected Error :(",
		pause = true
	}
	
	local content = dialog.content:addLayout{ spacing = 1, vertical = true }
	-- error section
	local errSec = content:addCanvas{ h = 75,
		onInit = function (s)
			s:setPadding(1, 1, 1, 1)
		end,
		onDraw = function(s, x, y, w, h)
			Drawing.setAlpha(1.0)
			Drawing.setColor(230, 230, 230)
			Drawing.drawNinePatch(NinePatch.PANEL, x, y, w, h)
			Drawing.reset()
		end
	}:addLayout{spacing = 1, vertical = true}
	
	errSec:addLabel{
		h = 20, text = 'Error Message:',
		onInit = function (s)
			s:setFont(Font.DEFAULT)
			s:setColor(80, 80, 80)
		end
	}
	
	errSec:addTextFrame{
		h = 50, text = MSSG,
		onInit = function (s)
			s:setColor(50, 50, 50)
		end
	}
	
	content:addTextFrame{
		h = 50, text = subText or 'Kindly contact the author if this kind of error keeps on occurring'
	}
end

-- a function that executes a function provided in the arguments
-- this function pop up an alert dialog if the execution fails.
---@param func Function() a function to execute
function DT.pcallAlert(func, subText, ...)
	local subArgs = {...}
	local status, err
	
	if #subArgs > 0 then
		status, err = pcall(func, ...)
	else
		status, err = pcall(func)
	end
	
	-- raise and show error if something wenr wrong
	if not status then
		showErrorMssg(err, subText)
		return
	end
	
	-- return value if success
	return err
end

function DT.deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
    		v = DT.deepCopy(v)
    	end
		copy[k] = v
    end
	return copy
end

return DT