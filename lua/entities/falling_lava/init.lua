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

AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/hunter/misc/sphere025x025.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMaterial( "models/shadertest/shader4" )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:PhysicsCollide(data, phys)
	if (data.HitEntity:GetClass() != "plasma_lava" and data.HitEntity:GetClass() != "scp_313") then
		local ent = ents.Create( "plasma_lava" )
		ent:SetPos( self:GetPos())
		ent:Spawn()
		ent:Activate()
		ent:Ignite(30, 200)
		self:Remove()
	end
end

hook.Add( "ShouldCollide", "ShouldCollide.SCP313Lava", function( ent1, ent2 )
	if (ent1:GetClass() == "falling_lava" and ent2:GetClass() == "scp_313") then return false end
	return true
end )