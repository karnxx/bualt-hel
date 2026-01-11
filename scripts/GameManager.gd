extends Node

signal enemydmg(who)
signal bullettimeout(who)
signal bulletstarted(who)

enum DamageType {
	CHIP,
	IMPACT
}

var time_scale := 1.0
var global_loot_mult := 1.0
var global_enemy_bullet_spd := 600.0
var global_enemy_dmg_scale := 1.0
