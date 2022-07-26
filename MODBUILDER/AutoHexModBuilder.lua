--load mod definition file
dofile(arg[1] .. "mod.lua")

--extract MBIN
os.execute([[psarc.exe extract "]] .. MOD["MODIFICATIONS"]["PAK_SOURCE_PATH"] .. [[" "]] .. MOD["MODIFICATIONS"]["MBIN_FILE_SOURCE"] .. [[" --to="MOD" -y]])

--load MBIN data
local file = arg[1] .. [[MODBUILDER\MOD\]] .. MOD["MODIFICATIONS"]["MBIN_FILE_SOURCE"]
local filehandle = io.open(file, "rb")
local DATA = filehandle:read("a")
local filesize = filehandle:seek("end")
filehandle:close()

--convert to byte table
local bytes = { string.byte(DATA, 1,-1) }

--edit MBIN data
for i=1,#MOD["MODIFICATIONS"]["VALUE_CHANGE_TABLE"],1 do
	local value = MOD["MODIFICATIONS"]["VALUE_CHANGE_TABLE"][i][1]
	local new_value = MOD["MODIFICATIONS"]["VALUE_CHANGE_TABLE"][i][2]
	local order_of_occurence = MOD["MODIFICATIONS"]["VALUE_CHANGE_TABLE"][i][3]
	
	local byte_table 		= { string.pack("f", value):byte(1), string.pack("f", value):byte(2), string.pack("f", value):byte(3), string.pack("f", value):byte(4) }
	local byte_table_new 	= { string.pack("f", new_value):byte(1), string.pack("f", new_value):byte(2), string.pack("f", new_value):byte(3), string.pack("f", new_value):byte(4) }
	--print(string.format("%X",byte_table[1]).. " " .. string.format("%X",byte_table[2]) .. " " .. string.format("%X",byte_table[3]) .. " " .. string.format("%X",byte_table[4]))
	
	local order_of_occurence_count = 0
	
	for j=1,#bytes-3,1 do
		if byte_table[1] == bytes[j] and byte_table[2] == bytes[j+1] and byte_table[3] == bytes[j+2] and byte_table[4] == bytes[j+3] then
			order_of_occurence_count = order_of_occurence_count + 1
			if order_of_occurence_count == order_of_occurence then
				bytes[j] = byte_table_new[1]
				bytes[j+1] = byte_table_new[2]
				bytes[j+2] = byte_table_new[3]
				bytes[j+3] = byte_table_new[4]
				print("Changed bytes at postion: 0x" .. string.format("%X",j-1))
				break
			end
			--print(string.format("%X",j-1))
		end
	end
end

--convert back to string byte stream
local char_table = {}
for i=1,#bytes,1 do
	table.insert(char_table,string.char(bytes[i]))
end
DATA = table.concat(char_table)

--save MBIN data
local filehandle = io.open(file, "wb")
filehandle:write(DATA)
filehandle:flush()
filehandle:close()
  
--pack mod including mod.lua file
os.execute([[copy "]] .. arg[1] .. "mod.lua" .. [[" "]] .. arg[1] .. [[MODBUILDER\MOD\"]] .. [[ && cd mod && ..\psarc.exe create --overwrite --skip-missing-files --quiet "]] .. MOD["MODIFICATIONS"]["MBIN_FILE_SOURCE"] .. [[" ]] .. "mod.lua" .. [[ --output="]] .. arg[1] .. [[\]] .. MOD["MOD_FILENAME"] .. [["]])


