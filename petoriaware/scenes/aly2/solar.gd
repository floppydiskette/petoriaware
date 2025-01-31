class_name Solar

var demo_s: int
var twin_s: int

func _init(
	starting_demo_s: int,
	starting_twin_s: int
):
	demo_s = starting_demo_s
	twin_s = starting_twin_s

func verify(
	abilities: Array,
	slot_holders: Array
) -> bool:
	if slot_holders.find(null) != -1:
		return false
	
	var twin_idx = slot_holders.find(abilities[1])
	var demo_idx = slot_holders.find(abilities[2])
	
	if twin_idx == -1 || demo_idx == -1:
		return false
	
	var twin_good = (twin_s - (2 * twin_idx) == 0)
	var demo_good = (demo_s - (2 * demo_idx) == 1)
	return twin_good && demo_good

func update_twin_timer(
	abilities: Array,
	slot_holders: Array,
	open_slot: int,
	twin_image: Sprite2D,
	twin_label: Label
) -> void:
	var twin_idx = slot_holders.find(abilities[1])
	
	var twin_time_left = twin_s - (2 * open_slot)
	if twin_idx != -1 && twin_idx < open_slot:
		twin_time_left = 16 - (2 * (open_slot - twin_idx))
	
	if twin_time_left < 0:
		twin_image.visible = false
		twin_label.visible = false
	else:
		twin_image.visible = true
		twin_label.visible = true
		twin_label.text = str(twin_time_left)

func update_demo_timer(
	abilities: Array,
	slot_holders: Array,
	open_slot: int,
	demo_image: Sprite2D,
	demo_label: Label
) -> void:
	var demo_idx = slot_holders.find(abilities[2])
	
	var demo_time_left = demo_s - (2 * open_slot)
	if demo_idx != -1 && demo_idx < open_slot:
		demo_time_left = 20 - (2 * (open_slot - demo_idx))
	
	if demo_time_left < 0:
		demo_image.visible = false
		demo_label.visible = false
	else:
		demo_image.visible = true
		demo_label.visible = true
		demo_label.text = str(demo_time_left)
