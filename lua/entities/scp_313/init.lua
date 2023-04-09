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

local HardImpactSoundList = {
	"physics/metal/metal_sheet_impact_hard2.wav",
	"physics/metal/metal_sheet_impact_hard6.wav",
	"physics/metal/metal_sheet_impact_hard7.wav",
	"physics/metal/metal_sheet_impact_hard8.wav"
}

function ENT:Precache()
	PrecacheParticleSystem( "Explosion" )
end

--TODO : Faire un effet d'explosion quand ça pète
function ENT:Initialize()
	self:Precache()
	self.NextLava = CurTime()
	self.LavaCoolDown = 0.3
	self.NextUse = CurTime()
	self.UseCoolDown = 18
	self:SetModel( "models/hand_dryer/hand_dryer.mdl" )
	self:SetModelScale( 1 )
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS ) 
	self:SetUseType(SIMPLE_USE)
	self:SetUnFreezable( true )
	self:AddEffects( EF_NOINTERP )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(ply)
	if CurTime() < self.NextUse then return end
	self.NextUse = CurTime() + self.UseCoolDown
	if (ply:IsValid()) then
		if (SCP_313.IsArmed()) then
			self:BurnBabyBurn()
		else
			self:EmitSound("scp_313/hand_dryer.mp3")
		end
	end
end

function ENT:PhysicsCollide(data, phys)
	if data.DeltaTime > 0.2 then
		if data.Speed > 250 then
			self:EmitSound(table.Random( HardImpactSoundList ), 75, math.random(90,110), 0.5)
		else
			self:EmitSound("physics/metal/metal_solid_impact_soft" .. math.random(1, 3) .. ".wav", 75, math.random(90,110), 0.2)
		end
	end
end

function ENT:Think()
	if (self.SendFarAway) then
		local phys = self:GetPhysicsObject()
		local angle = self:GetAngles()
		-- TODO : Orienté dans le même sens de poussé l'entité
		--self:SetAngles(Angle(angle.x,angle.y,180))
		phys:SetVelocity( phys:GetVelocity() * 10000 )
		if CurTime() < self.NextLava then return end
		self.NextLava = CurTime() + self.LavaCoolDown
		local ent = ents.Create( "falling_lava" )
		ent:SetPos( self:GetPos())
		ent:Spawn()
		ent:Activate()
	end
end

function ENT:BurnBabyBurn()
	SCP_313.DisplayEffectClientSide("Explosion", self:GetPos())
	self:GetPhysicsObject():SetVelocity( self:GetUp() * 10000 )
	self.SendFarAway = true
	self:EmitSound( "scp_313/lauch_sound.mp3")
	self:StartLoopingSound("scp_313/booster_sound.wav")
	timer.Simple( 30, function() if (self:IsValid()) then 
		self.SendFarAway = false
		self:StopSound("scp_313/booster_sound.wav")
	end end )
end