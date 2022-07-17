extends Node2D

var turno_jugador = 0
var numero_jugadores = 4
var fichasSinSalir = numero_jugadores
var ordenInicioJuego = true
var dados_inicio = 0

func _ready():
	$Fichas6Jugadores.remove_child($Fichas6Jugadores/FichasVerdes6J)
	$Fichas6Jugadores.remove_child($Fichas6Jugadores/FichasRojas6J)
	$Fichas6Jugadores.remove_child($Fichas6Jugadores/FichasAzules6J)
	$Fichas6Jugadores.remove_child($Fichas6Jugadores/FichasAmarillas6J)
	$Fichas6Jugadores.remove_child($Fichas6Jugadores/FichasMoradas6J)
	$Fichas6Jugadores.remove_child($Fichas6Jugadores/FichasNaranjas6J)
	
	for j in Variablesjuego.get_numJugadores():
		var childFichas
		match j:
			0:
				childFichas = load("res://Fichas/6 Jugadores/FichasVerdes6J.tscn").instance()
			1:
				childFichas = load("res://Fichas/6 Jugadores/FichasRojas6J.tscn").instance()
			2:
				childFichas = load("res://Fichas/6 Jugadores/FichasAzules6J.tscn").instance()
			3:
				childFichas = load("res://Fichas/6 Jugadores/FichasAmarillas6J.tscn").instance()
			4:
				childFichas = load("res://Fichas/6 Jugadores/FichasMoradas6J.tscn").instance()
			5:
				childFichas = load("res://Fichas/6 Jugadores/FichasNaranjas6J.tscn").instance()
		$Fichas6Jugadores.add_child(childFichas)
		anadirFichas(j)
		
func anadirFichas(indice):
	var ficha = $Fichas6Jugadores.get_child(indice)
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
		4:
			fichaAnadir = load("res://Fichas/6 Jugadores/Morado.tscn").instance()
		5:
			fichaAnadir = load("res://Fichas/6 Jugadores/Naranja.tscn").instance()
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
		4:
			posIniciales = $PosIniciales/Morado.get_children()
		5:
			posIniciales = $PosIniciales/Naranja.get_children()
	var contPosInicial = 0
	for f in childrenFicha:
		f.set_position(posIniciales[contPosInicial].get_position())
		contPosInicial += 1
