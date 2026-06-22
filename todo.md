# EXTENDED FIXES
- true orbit with physics projectiles is buggy?
- homonculous negative HP berserk attacks player?
- chaotic transmutation deactivates first luacomp
- intense concentrated light comp enabling
- quantum split deleting entities
- chaos die CoV doesnt have parity with regular CoV (doesnt apply heal nicely)
- fix orbit or whatever spams annoying-ass errors at me with cpand.
- fix duping player if possible?
- flyup/flydown becomes nan when stacked a bunch
- null altar basins can be filled consecutively rather than all at once
- tablet possession
- item trick kills
- digging bolt glimmers
- ? fix omega stateless iterator reference keep
- tentacle hitfx child -> parent nonsense?
- *sighhhh*, fix enlightened alchemist attacks working as illusions :(
  - actually it seems like other enemies might be able to do the same?
  - might also be intentional? investigate this.
- repulsion field isnt centred? (may be qol)
- stuff homes in on player invis dummy
- glass cannon on enemies is 20x strength
- boomerang on enemies sometiMES HOMES IN ON THE PLAYER NOLLA YOU RATS-
- fix High Mana perk revealing unidentified spell sprite
- ? lukki minion targets non-attackable targets (charmed enemies)
- Dynamite vs TNT, progress vs ingame
- ? spells not having correct related projectile?
- Fizzle does not fizzle orbiting projectiles
- Larpa Bounce Entity just checks nearby projectiles rather than actual host?
  - use `bounces_left` 
- Invisible Glimmer + Creature-spawning spell does not drop a corpse
- Creature spawning spells are limited by CameraBound despite disabling it
- Levitation Trail is nefarious and evil (harms allies)

# implemented fixes
- crit simulator needs more effects
  - particles
  - text


# cantfix
- can MW be fixed????
- Portals warp you to the centre
- Particles from Cursed Rock Aura and such do not appear if their core entity is not directly on-screen
  - this does not appear to have a fix