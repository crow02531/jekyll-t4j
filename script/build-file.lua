local filter = require "make4ht-filter"
local domobj = require "luaxml-domobject"

local process = filter {
    function(str)
        local dom = domobj.parse(str):query_selector("body")[1]

        --inline the svg
        for _, img in ipairs(dom:query_selector "img") do
            local filename = img:get_attribute "src" or ""

            if filename:match("svg$") then
                local file = io.open(filename, "r")
                img:replace_node(domobj.parse(file:read("*all")):root_node())
                file:close()
            end
        end

        str = dom:serialize()
        return str:sub(7, #str - 8) --trim the '<body></body>'
    end
}

Make:match("html$", process)