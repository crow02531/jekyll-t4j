local filter = require "make4ht-filter"
local domobj = require "luaxml-domobject"

local process = filter {
    function(str)
        local dom = domobj.parse(str):query_selector("body")[1]

        --inline svg
        for _, img in ipairs(dom:query_selector "img") do
            local filename = img:get_attribute "src" or ""

            if filename:match("svg$") then
                local file = io.open(filename, "r")

                if file then
                    local chs = domobj.parse(file:read("*all")):root_node():get_children()
                    img:replace_node(chs[#chs])
                    file:close()
                end
            end
        end

        str = dom:serialize()
        return str:sub(7, #str - 8) --trim '<body></body>'
    end
}

Make:match("html$", process)