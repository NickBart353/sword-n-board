class_name CombatMath

static func calulcate_damage(damage_container: DamageContainer, resistance_resource: ResistanceResource, _modifiers: Array = []) -> float:
	if damage_container == null or resistance_resource == null:
		push_warning("damage or resource was null, potentially intended")
		return 0.0
		
	var damage_taken: float = 0.0
	
	damage_taken += match_damage(damage_container.primary_damage, resistance_resource)
	
	for additional_damage_resource in damage_container.additional_damage:
		damage_taken += match_damage(additional_damage_resource, resistance_resource)
	
	return damage_taken

static func match_damage(damage_resource: DamageResource, resistance_resource: ResistanceResource) -> float:
	var damage: float = 0.0
	match damage_resource.damage_type:
		WeaponData.UPGRADE_TYPE.NORMAL:
			damage = _get_damage(damage_resource.damage_amount, resistance_resource.normal_resistance)
		WeaponData.UPGRADE_TYPE.FIRE:
			damage = _get_damage(damage_resource.damage_amount, resistance_resource.fire_resistance)
		WeaponData.UPGRADE_TYPE.COLD:
			damage = _get_damage(damage_resource.damage_amount, resistance_resource.cold_resistance)
		WeaponData.UPGRADE_TYPE.LIGHTNING:
			damage = _get_damage(damage_resource.damage_amount, resistance_resource.lightning_resistance)
		WeaponData.UPGRADE_TYPE.NATURE:
			damage = _get_damage(damage_resource.damage_amount, resistance_resource.nature_resistance)
		WeaponData.UPGRADE_TYPE.CHAOS:
			damage = _get_damage(damage_resource.damage_amount, resistance_resource.chaos_resistance)
	return damage

static func _get_damage(damage: float, resistance: float) -> float:
	var damage_taken: float = 0.0
	if damage >= resistance:
		damage_taken = damage * 2 - resistance
	else:
		damage_taken = damage * (damage / resistance)
	return damage_taken
