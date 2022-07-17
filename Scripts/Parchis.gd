extends Node2D

var turno_jugador = 0
var numero_jugadores = 4
var fichasSinSalir = numero_jugadores
var ordenInicioJuego = true
var dados_inicio = 0

func _ready():
	$Fichas.remove_child($Fichas/FichasAmarillas)
	$Fichas.remove_child($Fichas/FichasVerdes)
	$Fichas.remove_child($Fichas/FichasRojas)
	$Fichas.remove_child($Fichas/FichasAzules)

	
	for j in Variablesjuego.get_numJugadores():
		var childFichas
		match j:
			0:
				childFichas = load("res://Fichas/Scenes/FichasVerdes.tscn").instance()
			1:
				childFichas = load("res://Fichas/Scenes/FichasRojas.tscn").instance()
			2:
				childFichas = load("res://Fichas/Scenes/FichasAzules.tscn").instance()
			3:
				childFichas = load("res://Fichas/Scenes/FichasAmarillas.tscn").instance()
		$Fichas.add_child(childFichas)
		anadirFichas(j)
		
func anadirFichas(indice):
	var ficha = $Fichas.get_child(indice)
	for i in Variablesjuego.get_numFichas():
		var fichaInstanciada = instanceFichas(indice)
		ficha.add_child(fichaInstanciada)
	posInicialFichas(ficha.get_children(), indice)

func instanceFichas(indice):
	var fichaAnadir
	match indice:
		0:
			fichaAnadir = load("res://Fichas/Verde.tscn").instance()
		1:
			fichaAnadir = load("res://Fichas/Rojo.tscn").instance()
		2:
			fichaAnadir = load("res://Fichas/Azul.tscn").instance()
		3:
			fichaAnadir = load("res://Fichas/Amarillo.tscn").instance()
	return fichaAnadir

func posInicialFichas(childrenFicha, indice):
	var posIniciales
	match indice:
		0:
			posIniciales = $PosIniciales/Verde.get_children()
		1:
			posIniciales = $PosIniciales/Rojo.get_children()
		2:
			posIniciales = $PosIniciales/Azul.get_children()
		3:
			posIniciales = $PosIniciales/Amarillo.get_children()
	var contPosInicial = 0
	for f in childrenFicha:
		f.set_position(posIniciales[contPosInicial].get_position())
		contPosInicial += 1
