extends Node2D

class_name FichasMoradas6J
var dadosInicio
var colorTurno = Color.purple
var organizandoFichas = true
var fichasEnCarcel = false
var listaSalidas
var carcelPos = []
var salidaPos = []
var turnoEnCurso = false
var listaFichasJuego
var fichasEnMeta = []
var juegoFinalizado = false
var contadorPares = 0
var posFichas = []
var curve2DFicha = []
var listaMovimientos
var movimientoDisponible = []
var movimientosPosibles = {
	0 : [7,12],
	1 : [5,10],
	2 : [5,12],
	3 : [5],
	4 : [8]
}

func get_nombre():
	return "Fichas Moradas"

func get_juegoFinalizado():
	return juegoFinalizado

func get_fichasEnMeta():
	return fichasEnMeta

func set_carcelPos(indice):
	carcelPos[indice] = true

func get_salidaPos():
	return salidaPos

func set_turnoEnCurso(boolean):
	turnoEnCurso = boolean

func get_listaFichasJuego():
	return listaFichasJuego

func get_listaMovimientos():
	return listaMovimientos

func _ready():
	for i in Variablesjuego.get_numFichas():
		movimientoDisponible.append([])
		posFichas.append(0)
		curve2DFicha.append(0)
		salidaPos.append(false)
		carcelPos.append(true)
	self.set_process_input(false)
	listaFichasJuego = get_children()
	listaMovimientos = get_parent().get_parent().get_node("Movimientos/MovimientosMorado").get_curve()

func play_turn(dado1, dado2, suma):
	listaFichasJuego = get_children()
	for i in listaFichasJuego:
		if curve2DFicha[i.get_index()] != 0:
			i.set_monitoring(true)
	var funcMouse = get_parent().get_parent().get_node("MouseClick")
	funcMouse.set_global_position(Vector2.ZERO)
	listaSalidas = get_parent().get_parent().get_node("Movimientos/SalidaMorado")
	if organizandoFichas:
		if dado1 == dado2:
			organizandoFichas = false
			get_parent().set_repetirTurno(false)
			var salidasFicha = listaSalidas.get_children()
			var contadorPos = 0
			for i in listaFichasJuego:
				salidaPos[contadorPos] = true
				carcelPos[contadorPos] = false
				i.set_position(salidasFicha[contadorPos].get_position())
				i.set_scale(Vector2(0.12, 0.12))
				contadorPos += 1
				var ficha = detectarFichas(salidasFicha[i.get_index()].get_position())
				if ficha != null:
					var parentEliminar = ficha.get_parent()
					parentEliminar.moverACarcel(ficha.get_index())
		else:
			get_parent().set_repetirTurno(true)

	if turnoEnCurso == true and organizandoFichas == false:
		if dado1 == dado2:
			if fichasEnCarcel:
				var lista = listaSalidas.get_children()
				for x in listaFichasJuego:
					var indiceFicha = x.get_index()
					if carcelPos[indiceFicha] == true:
						curve2DFicha[indiceFicha] = 0
						posFichas[indiceFicha] = 0
						salidaPos[indiceFicha] = true
						x.set_position(lista[indiceFicha].get_position())
						carcelPos[indiceFicha] = false
						x.set_scale(Vector2(0.12, 0.12))
					
					var ficha = detectarFichas(lista[x.get_index()].get_position())
					if ficha != null:
						var parentEliminar = ficha.get_parent()
						parentEliminar.moverACarcel(ficha.get_index())
				fichasEnCarcel = false
			contadorPares += 1
			get_parent().set_repetirTurno(true)
		else:
			contadorPares = 0
			get_parent().set_repetirTurno(false)
		if contadorPares == 3:
			var fichaAMover
			var indexFicha
			funcMouse.set_process_input(true)
			get_parent().dadoDeshabilitado(true)
			funcMouse.set_listaFichas(listaFichasJuego)
			
			for x in Variablesjuego.get_numFichas():
				get_child(x).get_node("Morado").texture = load("res://Fichas/Imagenes/MoradoMovimiento.png")
			
			fichaAMover = yield(funcMouse, "mouseClick")
			indexFicha = fichaAMover.get_index()
			var popupFicha = fichaAMover.get_node("Control/popupOpciones")
			popupFicha.get_child(0).set_visible(false)
			popupFicha.get_child(2).set_visible(false)
			
			popupFicha.get_child(1).set_visible(true)
			popupFicha.get_child(1).set_text("100")
			popupFicha.set_position(fichaAMover.get_position())
			popupFicha.popup()
			var arrayOpciones = yield(popupFicha, "btnOpcionClick")
			
			fichasEnMeta.append(fichaAMover)
			fichaAMover.set_visible(false)
			curve2DFicha[fichaAMover.get_index()] = 12

			get_parent().dadoDeshabilitado(false)
			for x in Variablesjuego.get_numFichas():
				get_child(x).get_node("Morado").texture = load("res://Fichas/Imagenes/Morado.png")
				
		elif posibilidadMovimiento(dado1, dado2, suma):
			funcMouse.set_process_input(true)
			get_parent().dadoDeshabilitado(true)
			var fichaAMover
			var dadosRestantes = suma
			var indexFicha
			funcMouse.set_listaFichas(listaFichasJuego)
			fichaAMover = yield(funcMouse, "mouseClick")
			indexFicha = fichaAMover.get_index()
			var popupFicha = fichaAMover.get_node("Control/popupOpciones")
			
			if dado1 in movimientoDisponible[indexFicha]:
				popupFicha.get_child(0).set_visible(true)
				popupFicha.get_child(0).set_text(str(dado1))
			else:
				popupFicha.get_child(0).set_visible(false)
				
			if dado2 in movimientoDisponible[indexFicha]:
				popupFicha.get_child(1).set_visible(true)
				popupFicha.get_child(1).set_text(str(dado2))
			else:
				popupFicha.get_child(1).set_visible(false)
				
			if suma in movimientoDisponible[indexFicha]:
				popupFicha.get_child(2).set_visible(true)
				popupFicha.get_child(2).set_text(str(suma))
			else:
				popupFicha.get_child(2).set_visible(false)
			popupFicha.set_position(fichaAMover.get_position())
			popupFicha.popup()
	
			
			var arrayOpciones = yield(popupFicha, "btnOpcionClick")
			var cantidadMovimiento = arrayOpciones[0]
			var indiceDado = arrayOpciones[1]
			
			var movPath2D
			if cantidadMovimiento == 5 or cantidadMovimiento == 7 or cantidadMovimiento == 8:
				movPath2D = 1
			elif cantidadMovimiento == 10 or cantidadMovimiento == 12:
				movPath2D = 2
			
			moverFicha(movPath2D, fichaAMover, indexFicha, listaMovimientos)
			dadosRestantes = dadosRestantes - cantidadMovimiento
			for x in Variablesjuego.get_numFichas():
				get_child(x).get_node("Morado").texture = load("res://Fichas/Imagenes/Morado.png")
			
			funcMouse.set_process_input(false)
			get_parent().dadoDeshabilitado(false)
			turnoEnCurso = false
		
	if fichasEnMeta.size() == Variablesjuego.get_numFichas():
		juegoFinalizado = true
	for i in listaFichasJuego:
		i.set_monitoring(false)
	yield(get_tree().create_timer(0.001), "timeout")
	

func moverFicha(cantidad, fichaAMover, indiceFicha, listaMovimientos):
	var posActual = curve2DFicha[indiceFicha]
	var indiceBusqueda = 0
	if posActual == 0:
		salidaPos[indiceFicha] = false
	
	if not posActual in [0,3,6,9,12,15]:
		for ficha in curve2DFicha:
			if ficha == curve2DFicha[indiceFicha]:
				if indiceBusqueda != indiceFicha:
					get_child(indiceBusqueda).set_position(listaMovimientos.get_point_position(ficha))
			indiceBusqueda += 1
	
	if posActual+cantidad in [3,6,9,12,15]:
		var posSalidas
		var interseccion
		var space = get_world_2d().direct_space_state
		match posActual+cantidad:
			3:
				posSalidas = get_parent().get_parent().get_node("Movimientos/SalidaAmarillo").get_children()
			6:
				posSalidas = get_parent().get_parent().get_node("Movimientos/SalidaAzul").get_children()
			9:
				posSalidas = get_parent().get_parent().get_node("Movimientos/SalidaRojo").get_children()
			12:
				posSalidas = get_parent().get_parent().get_node("Movimientos/SalidaVerde").get_children()
			15:
				posSalidas = get_parent().get_parent().get_node("Movimientos/SalidaNaranja").get_children()
		for i in Variablesjuego.get_numFichas():
			interseccion = space.intersect_point(posSalidas[i].get_position(), 3, [], 2147483647, false, true)
			if interseccion.empty():
				fichaAMover.set_position(posSalidas[i].get_position())
				curve2DFicha[indiceFicha] = posActual + cantidad
				posFichas[indiceFicha] = (posFichas[indiceFicha] + cantidad) % 3
				break
	else:
		var fichaEliminar
		fichaAMover.set_position(listaMovimientos.get_point_position(posActual + cantidad))
		curve2DFicha[indiceFicha] = posActual + cantidad
		posFichas[indiceFicha] = (posFichas[indiceFicha] + cantidad) % 3
		indiceBusqueda = 0
		for ficha in curve2DFicha:
			if ficha == curve2DFicha[indiceFicha]:
				if indiceBusqueda != indiceFicha:
					match curve2DFicha[indiceFicha]:
						4,5,6,13,14,15:
							fichaAMover.set_position(fichaAMover.get_position() - Vector2(5,-9))
							get_child(indiceBusqueda).set_position(get_child(indiceBusqueda).get_position() + Vector2(5,-9))
						1,2,3,10,11,12:
							fichaAMover.set_position(fichaAMover.get_position() - Vector2(15,0))
							get_child(indiceBusqueda).set_position(get_child(indiceBusqueda).get_position() + Vector2(15,0))
						7,8,9,16,17:
							fichaAMover.set_position(fichaAMover.get_position() - Vector2(5,9))
							get_child(indiceBusqueda).set_position(get_child(indiceBusqueda).get_position() + Vector2(5,9))
			indiceBusqueda += 1
			
		fichaEliminar = detectarFichas(listaMovimientos.get_point_position(posActual + cantidad))
		if fichaEliminar != null:
			var parentEliminar = fichaEliminar.get_parent()
			parentEliminar.moverACarcel(fichaEliminar.get_index())
			
	if cantidad == 0:
		curve2DFicha[indiceFicha] = 0
		posFichas[indiceFicha] = 0
		var lista = listaSalidas.get_children()
		salidaPos[indiceFicha] = true
		fichaAMover.set_position(lista[indiceFicha].get_position())
	
	if curve2DFicha[indiceFicha] == 16:
		posFichas[indiceFicha] = 3
	if curve2DFicha[indiceFicha] == 17:
		posFichas[indiceFicha] = 4
	if curve2DFicha[indiceFicha] == 18:
		fichasEnMeta.append(fichaAMover)
		fichaAMover.set_visible(false)

func detectarFichas(movimiento):
	var fichaEliminar
	var interseccion
	var space = get_world_2d().direct_space_state
	interseccion = space.intersect_point(movimiento, 3, [], 2147483647, false, true)
	if not interseccion.empty():
		if not interseccion[0]["collider"] in listaFichasJuego:
			fichaEliminar = interseccion[0]["collider"]
			return fichaEliminar
	return null
	
func checkEspacio(indexFicha, dado1, dado2, suma):
	var posActual = curve2DFicha[indexFicha]
	var movimientosPermitidos = []
	var mov1Pos = listaMovimientos.get_point_position(posActual + 1)
	var mov2Pos = listaMovimientos.get_point_position(posActual + 2)

	if dado1 in movimientosPosibles[posFichas[indexFicha]]:
		var contadorIntersecciones = intersecciones(posActual+1, mov1Pos)
		if not posActual+1 in [3,6,9,12,15]:
			if contadorIntersecciones < 2:
				movimientosPermitidos.append(dado1)
		else:
			if contadorIntersecciones < Variablesjuego.get_numFichas():
				movimientosPermitidos.append(dado1)
				
	if dado2 in movimientosPosibles[posFichas[indexFicha]]:
		var contadorIntersecciones = intersecciones(posActual+1, mov1Pos)
		if not posActual+1 in [3,6,9,12,15]:
			if contadorIntersecciones < 2:
				movimientosPermitidos.append(dado2)
		else:
			if contadorIntersecciones < Variablesjuego.get_numFichas():
				movimientosPermitidos.append(dado2)
			
	if suma in movimientosPosibles[posFichas[indexFicha]]:
		if suma == 7 or suma == 5:
			var contadorIntersecciones = intersecciones(posActual+1, mov1Pos)
			if not posActual+1 in [3,6,9,12,15]:
				if contadorIntersecciones < 2:
					movimientosPermitidos.append(suma)
			else:
				if contadorIntersecciones < Variablesjuego.get_numFichas():
					movimientosPermitidos.append(suma)
		else:
			var contadorIntersecciones = intersecciones(posActual+2, mov2Pos)
			if not posActual+2 in [3,6,9,12,15]:
				if contadorIntersecciones < 2:
					movimientosPermitidos.append(suma)
			else:
				if contadorIntersecciones < Variablesjuego.get_numFichas():
					movimientosPermitidos.append(suma)
				
	return movimientosPermitidos
	
func posibilidadMovimiento(dado1, dado2, suma):
		for x in Variablesjuego.get_numFichas():
			if not dado1 or not dado2 or not suma in movimientosPosibles[posFichas[x]]:
				movimientoDisponible[x] = []
			else:
				if carcelPos[x] == true:
					movimientoDisponible[x] = []
				else:
					if get_child(x) in fichasEnMeta:
						movimientoDisponible[x] = []
					else:
						movimientoDisponible[x] = self.checkEspacio(x, dado1, dado2, suma)
						if not movimientoDisponible[x].empty():
							get_child(x).get_node("Morado").texture = load("res://Fichas/Imagenes/MoradoMovimiento.png")
		
		
		var contadorFalse = 0
		for y in movimientoDisponible:
			if y.empty():
				contadorFalse += 1

		if contadorFalse == movimientoDisponible.size():
			turnoEnCurso = false
			return false
		else:
			return true

func intersecciones(posMov, mov):
	var space = get_world_2d().direct_space_state
	var interseccion
	var contadorIntersecciones = 0
	
	match posMov:
		4,5,13,14:
			interseccion = space.intersect_point(mov + Vector2(5,-9), 3, [], 2147483647, false, true)
			if not interseccion.empty():
				contadorIntersecciones += 1
				interseccion = space.intersect_point(mov - Vector2(5,-9), 3, [], 2147483647, false, true)
				if not interseccion.empty():
					contadorIntersecciones += 1
		1,2,10,11:
			interseccion = space.intersect_point(mov + Vector2(15,0), 3, [], 2147483647, false, true)
			if not interseccion.empty():
				contadorIntersecciones += 1
				interseccion = space.intersect_point(mov - Vector2(15,0), 3, [], 2147483647, false, true)
				if not interseccion.empty():
					contadorIntersecciones += 1
		7,8,16,17:
			interseccion = space.intersect_point(mov + Vector2(5,9), 3, [], 2147483647, false, true)
			if not interseccion.empty():
				contadorIntersecciones += 1
				interseccion = space.intersect_point(mov - Vector2(5,9), 3, [], 2147483647, false, true)
				if not interseccion.empty():
					contadorIntersecciones += 1
		3:
			var salidasAzul = get_parent().get_parent().get_node("Movimientos/SalidaAmarillo").get_children()
			for i in Variablesjuego.get_numFichas():
				interseccion = space.intersect_point(salidasAzul[i].get_position(), 1, [], 2147483647, false, true)
				if not interseccion.empty():
					contadorIntersecciones += 1
		6:
			var salidasAzul = get_parent().get_parent().get_node("Movimientos/SalidaAzul").get_children()
			for i in Variablesjuego.get_numFichas():
				interseccion = space.intersect_point(salidasAzul[i].get_position(), 1, [], 2147483647, false, true)
				if not interseccion.empty():
					contadorIntersecciones += 1
		9:
			var salidasRojo = get_parent().get_parent().get_node("Movimientos/SalidaRojo").get_children()
			for i in Variablesjuego.get_numFichas():
				interseccion = space.intersect_point(salidasRojo[i].get_position(), 1, [], 2147483647, false, true)
				if not interseccion.empty():
					contadorIntersecciones += 1
		12:
			var salidasAzul = get_parent().get_parent().get_node("Movimientos/SalidaVerde").get_children()
			for i in Variablesjuego.get_numFichas():
				interseccion = space.intersect_point(salidasAzul[i].get_position(), 1, [], 2147483647, false, true)
				if not interseccion.empty():
					contadorIntersecciones += 1
		15:
			var salidasAzul = get_parent().get_parent().get_node("Movimientos/SalidaNaranja").get_children()
			for i in Variablesjuego.get_numFichas():
				interseccion = space.intersect_point(salidasAzul[i].get_position(), 1, [], 2147483647, false, true)
				if not interseccion.empty():
					contadorIntersecciones += 1
	return contadorIntersecciones

func moverACarcel(indice):
	var ficha = get_child(indice)
	var listaSalida = get_parent().get_parent().get_node("PosIniciales/Morado").get_children()
	curve2DFicha[indice] = 0
	posFichas[indice] = 0
	fichasEnCarcel = true
	
	carcelPos[indice] = true
	ficha.set_position(listaSalida[indice].get_position())
	ficha.set_scale(Vector2(0.3, 0.3))


func get_colorTurno():
	return colorTurno

func set_dadosInicio(resultado):
	dadosInicio = resultado
	
func get_dadosInicio():
	return dadosInicio
