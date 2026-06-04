extends PanelContainer

signal cache_loaded

@onready var vfx_position: Marker3D = $VFXPosition

var vfx: Array = []
var attack_vfx: Array = []

func _ready() -> void:
	vfx = VfxManager.get_vfx_list()
	attack_vfx = VfxManager.get_attack_vfx_list()
	
	for vfx_instance in vfx:
		if not vfx_instance.vfx_finished.is_connected(vfx_finished):
			vfx_instance.vfx_finished.connect(vfx_finished)
	for attack_vfx_instance in attack_vfx:
		if not attack_vfx_instance.finished.is_connected(attack_vfx_finished):
			attack_vfx_instance.finished.connect(attack_vfx_finished)

func start() -> void:
	vfx_finished()

func vfx_finished() -> void:
	if vfx.size() > 0:
		_play_vfx()
	else:
		_play_attack_vfx()

func attack_vfx_finished(attack: Attack) -> void:
	attack.queue_free()
	if attack_vfx.size() > 0:
		_play_attack_vfx()
	else:
		cache_loaded.emit()

func _play_vfx() -> void:
	var _vfx: Basic_VFX = vfx.pop_back()
	_vfx.hide_if_missed_by_player = false
	_vfx.queue_free_on_finish = true
	vfx_position.add_child(_vfx)
	_vfx.play()

func _play_attack_vfx() -> void:
	var _attack_vfx: Attack = attack_vfx.pop_back()
	vfx_position.add_child(_attack_vfx)
	_attack_vfx.attack(vfx_position.global_transform, 0)
