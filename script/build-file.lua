local filter = require "make4ht-filter"
local domobj = require "luaxml-domobject"

math.randomseed(os.clock() ^ 5)

local function rename_file(filename)
    local charset = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$@"
    local extname = filename:match "%.[^/.]+$" or ""
    local dstname

    local s = { "_" }
	for i = 1, 22 do
	    local r = math.random(1, #charset)
	    table.insert(s, charset:sub(r, r))
	end
    table.insert(s, extname)
    dstname = table.concat(s)

    os.rename(filename, dstname)
    return dstname
end

local process = filter {
    function(str)
        local dom = domobj.parse(str):query_selector("body")[1]

        --rename all external files
        for _, img in ipairs(dom:query_selector "img") do
            local filename = img:get_attribute "src" or ""

            if filename:match "[^/\\]*.svg$" then
                img:set_attribute("src", rename_file(filename)) --rename svg
            end
        end
        rename_file(settings.tex_file:gsub("%.[^/.]+$", ".css")) --rename css

        str = dom:serialize()
        return str:sub(7, #str - 8) --trim '<body>...</body>'
    end
}

Make:enable_extension "detect_engine"
Make:enable_extension "dvisvgm_hashes"
Make:match("html$", process)