-- source https://gist.github.com/yuhanz/6688d474a3c391daa6d6

TableUtils = {}

function TableUtils.serialize(table)
	return "return"..TableUtils.serializeTable(table)
end

function TableUtils.deserialize(str)
	local f = loadstring(str)
	return f()
end

function TableUtils.serializeTable(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)
    if name then 
    	if not string.match(name, '^[a-zA-z_][a-zA-Z0-9_]*$') then
    		name = string.gsub(name, "'", "\\'")
    		name = "['".. name .. "']"
    	end
    	tmp = tmp .. name .. " = "
     end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. TableUtils.serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end