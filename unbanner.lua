key_value1 = 178016311 -- value in " Computer\HKEY_CURRENT_USER "
key_value2 = 15180 -- value in " Computer\HKEY_CURRENT_USER\Software\Microsoft "

function delete_machine_guid()
    reg_key = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Cryptography"
    value_name = "MachineGuid"

    batch_content = [[
        @echo off
        reg delete "]] .. reg_key .. [[" /v ]] .. value_name .. [[ /f
        if %errorlevel% == 0 (
            echo Deleted registry value: ]] .. reg_key .. [[\]] .. value_name .. [[
        ) else (
            echo Failed to delete registry value: ]] .. reg_key .. [[\]] .. value_name .. [[
        )
    ]]

    batch_file = io.open("delete_machine_guid.bat", "w")
    batch_file:write(batch_content)
    batch_file:close()

    output_file = io.popen("delete_machine_guid.bat")
    output = output_file:read("*all")
    output_file:close()

    print(output)

    os.remove("delete_machine_guid.bat")
end

function delete_specific_registry_key(key_location, key_name)
    registry_key = key_location .. key_name
        
    check_command = 'reg query "' .. registry_key .. '" /s'
    temp_file = io.popen(check_command)
    if temp_file then
        for line in temp_file:lines() do
            print(line)
        end
        temp_file:close()
    else
        print("Failed to read registry key:", registry_key)
        return
    end
    
    delete_command = 'reg delete "' .. registry_key .. '" /f > nul 2>&1'
    delete_status = os.execute(delete_command)

    if delete_status == true or delete_status == 0 then
        print("Successfully deleted:", registry_key)
    else
        print("Failed to delete:", registry_key)
    end
end

delete_specific_registry_key("HKEY_CURRENT_USER\\", key_value1)
delete_specific_registry_key("HKEY_CURRENT_USER\\Software\\Microsoft\\", key_value2)
print("")
delete_machine_guid()