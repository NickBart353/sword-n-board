class_name CombatMath

static func calulcate_damage(damage_resource: DamageResource, resistance_resource: ResistanceResource, _modifiers: Array = []) -> float:
	var damage_taken: float = 0.0
	match damage_resource.primary_damage_type:
		WeaponData.UPGRADE_TYPE.NORMAL:
			damage_taken += _get_damage(damage_resource.primary_damage, resistance_resource.normal_resistance)
		WeaponData.UPGRADE_TYPE.FIRE:
			damage_taken += _get_damage(damage_resource.primary_damage, resistance_resource.fire_resistance)
		WeaponData.UPGRADE_TYPE.COLD:
			damage_taken += _get_damage(damage_resource.primary_damage, resistance_resource.cold_resistance)
		WeaponData.UPGRADE_TYPE.LIGHTNING:
			damage_taken += _get_damage(damage_resource.primary_damage, resistance_resource.lightning_resistance)
		WeaponData.UPGRADE_TYPE.NATURE:
			damage_taken += _get_damage(damage_resource.primary_damage, resistance_resource.nature_resistance)
		WeaponData.UPGRADE_TYPE.CHAOS:
			damage_taken += _get_damage(damage_resource.primary_damage, resistance_resource.chaos_resistance)
	
	if not damage_resource.secondary_damage:
		return damage_taken
	
	match damage_resource.secondary_damage_type:
		WeaponData.UPGRADE_TYPE.NORMAL:
			damage_taken += _get_damage(damage_resource.secondary_damage, resistance_resource.normal_resistance)
		WeaponData.UPGRADE_TYPE.FIRE:
			damage_taken += _get_damage(damage_resource.secondary_damage, resistance_resource.fire_resistance)
		WeaponData.UPGRADE_TYPE.COLD:
			damage_taken += _get_damage(damage_resource.secondary_damage, resistance_resource.cold_resistance)
		WeaponData.UPGRADE_TYPE.LIGHTNING:
			damage_taken += _get_damage(damage_resource.secondary_damage, resistance_resource.lightning_resistance)
		WeaponData.UPGRADE_TYPE.NATURE:
			damage_taken += _get_damage(damage_resource.secondary_damage, resistance_resource.nature_resistance)
		WeaponData.UPGRADE_TYPE.CHAOS:
			damage_taken += _get_damage(damage_resource.secondary_damage, resistance_resource.chaos_resistance)
	
	return damage_taken

static func _get_damage(damage: float, resistance: float) -> float:
	var damage_taken: float = 0.0
	if damage >= resistance:
		damage_taken = damage * 2 - resistance
	else:
		damage_taken = damage * (damage / resistance)
	return damage_taken
