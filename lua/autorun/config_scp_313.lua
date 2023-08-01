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
SCP_313_CONFIG.PercentEffect = CreateConVar( "SCP_313_PercentEffect", 1.5, {FCVAR_PROTECTED, FCVAR_ARCHIVE}, "Percentage chance to trigger the effect of SCP-313.", 0, 100 )

if (SERVER) then
    util.AddNetworkString( SCP_313_CONFIG.DisplayEffectClientSide )
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

SCP_313.LoadDirectory("scp_313/functions/")