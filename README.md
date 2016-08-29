Name
=============

lua-resty-zip - zip functions(compress/uncompress) for LuaJIT

Status
======

This library is considered experimental.


Description
===========

The code mainly from http://luajit.org/ext_ffi_tutorial.html.


Synopsis
========

```lua
    # nginx.conf:

    lua_package_path "/path/to/lua-resty-zip/lib/?.lua;;";

    server {
        location = /test {
            content_by_lua_block {
                local zip = require "resty.zip"

                local txt = string.rep("abcd", 1000)
                ngx.say("Uncompressed size: ", #txt)

                local c = zip.compress(txt, 1)
                ngx.say("Compressed size on level 1: ", #c)

                local c = zip.compress(txt, 9)
                ngx.say("Compressed size on level 9: ", #c)

                local txt2 = zip.uncompress(c, #txt)
                assert(txt2 == txt)
            }
        }
    }
```


Methods
=======

compress
----
`syntax: c = resty.compress(txt, level?)`


uncompress
----
`syntax: txt = resty.uncompress(c)`


Author
======

Dejiang Zhu (doujiang24) <doujiang24@gmail.com>
