-- SCP 313, A representation of a paranormal object on a fictional series on the game Garry's Mod.
-- Copyright (C) 2023  MrMarrant aka BIBI.

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

SCP_313 = {}
SCP_313_CONFIG  = {}

SCP_313_CONFIG.PathPercentEffect = "data_scp_313/scp_313.json"
SCP_313_CONFIG.DisplayEffectClientSide = "SCP_313_CONFIG.DisplayEffectClientSide"

if (SERVER) then
    util.AddNetworkString( SCP_313_CONFIG.DisplayEffectClientSide )
end

/*
* Allows to return the data of a file.
* @string path File path.
*/
function SCP_313.GetDataFromFile(path)
    local fileFind = file.Read(path) or ""
    local dataFind = util.JSONToTable(fileFind) or {}
    return dataFind
end

/*
* Allows you to charge all the files in a folder.
* @string path of the folder to load.
*/
function SCP_313.LoadDirectory(pathFolder)
    local files, directories = file.Find(pathFolder.."*", "LUA")
    for key, value in pairs(files) do
        AddCSLuaFile(pathFolder..value)
        include(pathFolder..value)
    end
    for key, value in pairs(directories) do
        SCP_313.LoadDirectory(pathFolder..value)
    end
end

-- DIRECTORY DATA FOLDER
if not file.Exists("data_scp_313", "DATA") then
    file.CreateDir("data_scp_313")
end

if (SERVER) then
    if not file.Exists(SCP_313_CONFIG.PathPercentEffect, "DATA") then
        local SERVER_VALUES = {}
        SERVER_VALUES.PercentEffect = 1.5
        file.Write(SCP_313_CONFIG.PathPercentEffect, util.TableToJSON(SERVER_VALUES, true))
    end

    local data = SCP_313.GetDataFromFile(SCP_313_CONFIG.PathPercentEffect)
    SCP_313_CONFIG.PercentEffect = data.PercentEffect
end

SCP_313.LoadDirectory("scp_313/functions/")