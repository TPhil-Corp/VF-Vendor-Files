local Parser = {}
Parser.version = 'unknown version'

function Parser.log(str, ...)
    local mssg = str
    local args = {...}
    if #args > 0 then
        mssg = string.format(str, ...)
    end

    Debug.log(string.format('[Vendor-Files[%s]] %s', Parser.version, mssg))
end

return Parser