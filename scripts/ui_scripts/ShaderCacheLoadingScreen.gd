extends PanelContainer

signal cache_loaded

@onready var vfx_position: Marker3D = $VFXPosition

var vfx: Array[Basic_VFX]
var attack_vfx: Array[Attack]

func _ready() -> void:
	vfx = VfxManager.get_vfx_list()
	attack_vfx = VfxManager.get_attack_vfx_list()
	for vfx_instance in vfx:
		if not vfx_instance.vfx_finished.is_connected(vfx_finished):
			vfx_instance.vfx_finished.connect(vfx_finished)
	for attack_vfx_instance in attack_vfx:
		if attack_vfx_instance.finished.is_connected(attack_vfx_finished):
			attack_vfx_instance.finished.connect(attack_vfx_finished)
	_play_vfx()

func vfx_finished():
	if vfx:
		_play_vfx()
	else:
		_play_attack_vfx()

func attack_vfx_finished():
	if attack_vfx:
		_play_attack_vfx()
	else:
		cache_loaded.emit()

func _play_vfx():
	var _vfx: Basic_VFX = vfx.pop_back()
	_vfx.hide_if_missed_by_player = false
	_vfx.queue_free_on_finish = true
	vfx_position.add_child(_vfx)
	_vfx.play()

func _play_attack_vfx():
	var _attack_vfx: Basic_VFX = attack_vfx.pop_back()
	_attack_vfx.hide_if_missed_by_player = false
	_attack_vfx.queue_free_on_finish = true
	vfx_position.add_child(_attack_vfx)
	_attack_vfx.attack(vfx_position.global_transform, 0)
