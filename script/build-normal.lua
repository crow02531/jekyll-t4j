local filter = require "make4ht-filter"
local domobj = require "luaxml-domobject"

local process = filter {
    function(str)
        str = domobj.parse(str):query_selector("body")[1]:serialize()
        return str:sub(7, #str - 8) --trim '<body></body>'
    end
}

Make:match("html$", process)