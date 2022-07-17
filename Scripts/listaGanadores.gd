extends ItemList

func _ready():
	var lista = Variablesjuego.get_listaGanadores()
	var contador = 1
	for i in Variablesjuego.get_numJugadores():
		add_item(str(contador,".",lista[i]), null, false)
		contador += 1


func _on_btnCerrar_pressed():
	get_tree().quit()
