extends Area2D
var areasDetectadas = []
var posMov = Vector2.ZERO

func _ready():
	self.set_global_position(Vector2.ZERO)

func get_areasDetectadas():
	return areasDetectadas

func _on_CheckEspacio_area_entered(area):
	areasDetectadas = get_overlapping_areas()
	print("AREA DETECTADA")
	print(areasDetectadas)

func checkAreas(pos):
	self.set_global_position(pos)
	yield(get_tree().create_timer(0.0001), "timeout")
