--///////////////////////////////////////////////////////////////////////////
--FUNCTION
--///////////////////////////////////////////////////////////////////////////

--logfile (/<CurrentPath>/YYYYMMDD_script.log)
function Logs(savedat)

    local date_YYYYMMDD=os.date("%Y%m%d")
    local date_hhnn=os.date("%H:%M:%S")

    f = io.open(scriptPath()..date_YYYYMMDD.."_script.log","a")

    if f then
        f:write(date_hhnn.." - "..savedat.."\n")
        f:close()
    else
        f = io.open(scriptPath()..date_YYYYMMDD.."_script.log","w")
        f:write(date_hhnn.." - "..savedat.."\n")
        f:close()
    end

end