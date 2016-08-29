# vi:ft=

use Test::Nginx::Socket::Lua;

repeat_each(2);
no_long_string();

plan tests => repeat_each() * (3 * blocks());

our $HttpConfig = <<'_EOC_';
    lua_package_path 'lib/?.lua;;';
_EOC_

#log_level 'warn';

run_tests();

__DATA__

=== TEST 1: sanity
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            local zip = require "resty.zip"

            local txt = string.rep("abcd", 1000)
            ngx.say("Uncompressed size: ", #txt)

            local c = zip.compress(txt, 1)
            ngx.say("Compressed size on level 1: ", #c)

            local c = zip.compress(txt, 9)
            ngx.say("Compressed size on level 9: ", #c)

            local txt2 = zip.uncompress(c, #txt)
            assert(txt2 == txt)

            collectgarbage()
        ';
    }
--- request
GET /t
--- response_body
Uncompressed size: 4000
Compressed size on level 1: 49
Compressed size on level 9: 32
--- no_error_log
[error]
