-- mainly from http://luajit.org/ext_ffi_tutorial.html


local ffi = require "ffi"
local ffi_new = ffi.new
local ffi_str = ffi.string


local _M = { _VERSION = '0.01' }

local mt = { __index = _M }


ffi.cdef[[
    unsigned long compressBound(unsigned long sourceLen);
    int compress2(uint8_t *dest, unsigned long *destLen,
        const uint8_t *source, unsigned long sourceLen, int level);
    int uncompress(uint8_t *dest, unsigned long *destLen,
        const uint8_t *source, unsigned long sourceLen);
]]

local zlib = ffi.load(ffi.os == "Windows" and "zlib1" or "z")

local buflen = ffi_new("unsigned long[1]", 0)


-- level: 0 - 9
function _M.compress(txt, level)
    local n = zlib.compressBound(#txt)
    local buf = ffi.new("uint8_t[?]", n)

    buflen[0] = n
    local res = zlib.compress2(buf, buflen, txt, #txt, level or 1)

    if res == 0 then
        return ffi_str(buf, buflen[0])
    else
        return nil
    end
end


function _M.uncompress(comp, n)
    local buf = ffi_new("uint8_t[?]", n)

    buflen[0] = n
    local res = zlib.uncompress(buf, buflen, comp, #comp)

    if res == 0 then
        return ffi_str(buf, buflen[0])
    else
        return nil
    end
end


return _M
