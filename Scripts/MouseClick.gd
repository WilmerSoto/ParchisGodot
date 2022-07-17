extends Area2D

var ficha_seleccionada
var listaFichas = []
signal mouseClick(ficha)

#func _physics_process(delta):
#	if Input.is_mouse_button_pressed(1):
#		self.set_global_position(get_global_mouse_position())

func _input(event):
	if (event is InputEventMouseButton):
		self.set_global_position(get_global_mouse_position())

func _ready():
	self.set_process_input(false)

func set_listaFichas(lista):
	listaFichas = lista
	
func mouseClick():
	return ficha_seleccionada


func _on_MouseClick_area_entered(area):
	ficha_seleccionada = get_overlapping_areas()
	if not listaFichas.empty():
		if not ficha_seleccionada.empty():
			if ficha_seleccionada[0] in listaFichas:
				emit_signal("mouseClick", ficha_seleccionada[0])
