--NXML is a very helpful Noita library maintained and largely written by https://github.com/NathanSnail used to parse Noita's custom XML format.
local nxml = dofile_once("mods/userk.extended_fixes/nxml/nxml.lua") ---@type nxml

--De-patterning function for dealing with string.gsub() and other pattern-utilising Lua functions.
local function escape(str) return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1") end

--Convenient function to simplify modifying files, gsub \r\n to \n to edit multiple lines at a time.
local function modifile(file, target, sub)
	ModTextFileSetContent(file, ModTextFileGetContent(file):gsub("\r\n", "\n"):gsub(escape(target), sub))
end


---LIST OF FIXES:
--[[ VOMIT INHERITANCE FIX ]]
--[[ DROPPER BOLT CHARGES FIX ]]
--[[ TELEKINETIC KICK REMOVAL FIX ]]
--[[ MIST PROJECTILES FIX ]]
--[[ CURSED ROCK GAP FIX ]]
--[[ WHITEHOLE OUT SPRITE FIX ]]
--[[ DISABLE SCRIPT_KICK FIX ]]


local settings_names = {
	"material_inheritance",
	"dropper_bolt_charges",
	"telekick_not_removed",
	"mist_projectile_tags",
	"curse_rock_biome_gap",
	"whitehole_out_sprite",
	"disable_kick_luacomp",
}
local settings = {}

for _,name in ipairs(settings_names) do
	settings[name] = ModSettingGet("userk.extended_fixes." .. name)
end

settings.material_inheritance = true
settings.dropper_bolt_charges = true
settings.telekick_not_removed = true
settings.mist_projectile_tags = true
settings.curse_rock_biome_gap = true
settings.whitehole_out_sprite = true
settings.disable_kick_luacomp = true




--[[ VOMIT INHERITANCE FIX ]]
--Vomit material was intended to inherit properties from Green Slime, this fails however because it is designated as a <CellData/> rather than <CellDataChild/>.

-- I currently fix all material that appear to be broken in this way, but Vomit is the only one this is really relevant for.
if settings.material_inheritance then
	for xml in nxml.edit_file("data/materials.xml") do
		for elem in xml:each_of("CellData") do
			if elem.attr._parent then elem.name = "CellDataChild" end
		end
	end
end




--[[ DROPPER BOLT CHARGES FIX ]]
--Dropper Bolt spell starts with 25/35 charges. This is because of some nonsense where it's custom card entity is shared with Firebolt and Odd Firebolt.

-- I actually don't fully understand this bug that much since it seems reliant on a bizarre system I don't fully understand and don't think I need to.
if settings.dropper_bolt_charges then
	-- Removing the overrides from the first <Base/> component appears to fix this, I don't know why they're there or if they do anything helpful??
	-- It seems to work, if something breaks go pester me and I'll go fix it.
	for xml in nxml.edit_file("data/entities/misc/custom_cards/grenade.xml") do
		local base = xml:first_of("Base")
		if base then
			base:clear_children()
		end
	end
end




--[[ TELEKINETIC KICK REMOVAL FIX ]]
--The Nullifying Altar does not properly strip the player of their telekinetic powers despite removing the perk.

if settings.telekick_not_removed then
	-- Add `telekinetic_kick` tag to all components on the telekinesis entity.
	for xml in nxml.edit_file("data/entities/misc/perk_telekinesis.xml") do
		for elem in xml:each_child() do
			local tags = elem.attr._tags or ""
			if #tags > 0 then tags = tags .. ",telekinetic_kick" else tags = "telekinetic_kick" end
			elem.attr._tags = tags
		end
	end

	-- Remove all components with the `telekinetic_kick` tag.
	modifile("data/scripts/perks/perk_list.lua", [[-- TODO( Petri ): Remove the perk_telekinesis.xml stuff from the entity]],
				[[-- TODO( Petri ): Remove the perk_telekinesis.xml stuff from the entity
				-- TODONE( UserK ): Removed the perk_telekinesis.xml stuff from the entity
				for _,component in ipairs(EntityGetAllComponents(entity_who_picked) or {}) do
					if ComponentHasTag(component, "telekinetic_kick") then EntityRemoveComponent(entity_who_picked, component) end
				end]]
	)
end




--[[ MIST PROJECTILES FIX ]]
--The Mist spells do not have the `projectile` tag because `tags` is defined on the entity twice. This causes them to not be properly identified by things like StX or shields.

if settings.mist_projectile_tags then
	local mists = {
		"data/entities/projectiles/deck/mist_alcohol.xml",
		"data/entities/projectiles/deck/mist_blood.xml",
		"data/entities/projectiles/deck/mist_radioactive.xml",
		"data/entities/projectiles/deck/mist_slime.xml",
	}

	for _,mist in ipairs(mists) do
		modifile(mist, [[tags=""]], [[]]) --Remove redundant tags definition.
	end
end




--[[ CURSED ROCK GAP FIX ]]
-- The Cursed Rock biome has a 12 pixel gap on account of the AreaDamageComponent on the biome's per-chunk damage entity only covers a 500x500 area (chunks are 512x512).

-- fun fact: Nolla considered fixing this in Epilogue 2 judging by a comment dated 15/5/2023, but it seems like they decided against it
if settings.curse_rock_biome_gap then
	for xml in nxml.edit_file("data/entities/misc/rock_curse.xml") do
		local adc = xml:first_of("AreaDamageComponent")
		if not adc then return end
		--I've verified there's no pixel coordinate which has you take damage from multiple, this works.
		adc.attr["aabb_min.x"] = "-256"
		adc.attr["aabb_min.y"] = "-256"
		adc.attr["aabb_max.x"] = "256"
		adc.attr["aabb_max.y"] = "256"

		local pec = xml:first_of("ParticleEmitterComponent")
		if not pec then return end
		pec.attr.x_pos_offset_min = "-256"
		pec.attr.x_pos_offset_max = "256"
		pec.attr.y_pos_offset_min = "-256"
		pec.attr.y_pos_offset_max = "256"
	end
end




---[[ WHITEHOLE OUT SPRITE FIX ]]
-- Whitehole uses Blackhole's fade-out animation despite having a different colour palette.

if settings.whitehole_out_sprite then
	modifile("data/entities/projectiles/deck/white_hole.xml", [[data/particles/black_hole_out.xml]], [[mods/userk.extended_fixes/files/gfx/white_hole_out.xml]])
end




--[[ DISABLE SCRIPT_KICK FIX ]]
-- <LuaComponent::script_kick/> does not respect the component being disabled.

-- This only affects the Tannerkivi in vanilla I think, normally the earthquake on kick should only apply when held or in-world.
if settings.disable_kick_luacomp then
	ModLuaFileAppend("data/scripts/items/stonestone.lua", "mods/userk.extended_fixes/files/appends/script_kick_disable.lua")
end