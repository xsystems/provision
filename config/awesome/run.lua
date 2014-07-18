local awful = require("awful")

-- A script to run your apps only once and not every time awesome is restarted. It ignores commands running as other users 
-- than yourself, permits to use command line options and to specify on which screen to launch your programs. It also allows 
-- for the case when the name of the process is different from the name of the command used to launch it.
function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end
                
    if not pname then
        pname = prg
    end
                               
    if not arg_string then 
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end
