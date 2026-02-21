extends Node3D

const hexlib = preload("res://addons/HexLibrary.gd")

var Occupato: bool = false

# TODO
# Non so perchè ma i cicli a riga 29 e 36 aggiungono elementi all'array map. ciò rende necessario l'utilizzo di pop
# risolvere con priorità massima
#
# La funzione generate_map funziona ma non si può vedere, ci sarebbe da scomporla in diverse altre funzioni oltre che raggruppare la serie di cicli
# for in un altro ciclo for


@onready var StarActualCell: Object = $Erba
@onready var destinationCell: Object = $Erba
var map: Array = []
var rng = RandomNumberGenerator.new()



var Hexsize = 1.1557
static var ListaTiles = [
	preload("res://Scenes/acqua.tscn"),
	preload("res://Scenes/erba.tscn"),
	preload("res://Scenes/sabbia.tscn")
]


func _ready():
	
	print("Asset Credits:")
	print(" https://kaylousberg.itch.io/kaykit-medieval-builder-pack\n https://pixel-boy.itch.io/ninja-adventure-asset-pack/devlog/581579/update-4\n")
	print("Hex Grid documentation:")
	print(" https://www.redblobgames.com/grids/hexagons/\n")
	
	rng.seed = hash("Godottt") 
	# hashes: Godot, Godottt (da (-2,2,0) a (1,1,-2) trova un path migliore) 
	
	
	#variabili
	StarActualCell.CubeCoords = Vector3(0,0,0)
	StarActualCell.G_Cost = 0
	var r: int = 4
	var map_index: int = (r*2) + 1 #numero di rows
	map.resize(map_index)
	
	for i in range(r+1):
		var Arr = []
		Arr.resize(r+1+i)
		map.insert(i,Arr)
	for i in range(r):
		var Arr2 = []
		Arr2.resize(r*2 - i)
		map.insert(r+i+1,Arr2)
	
	for i in range(2*r + 1): #rimedio ai miei errori con delle pop
		map.pop_back()
	
	
	
	generate_grid(r,Hexsize, StarActualCell, map)
	
	
	for element in get_tree().get_nodes_in_group("CaselleEsagonaliGoalPossible"):
		element.hex_destination_selected.connect(SetDestination) #Shenanigans con .callable: passo le variabili giuste ma una volta passate le modifica apportatevi non si rispecchiano nelle variabili effettive. Che venga passata una copia? Un dettagli interessante è che nonostante abbiano il contenuto giusto, se una variabile è stata tipizzata viene ammesso che venga rotto questo vincolo. quindi boh  #https://stackoverflow.com/questions/77360041/how-to-connect-a-signal-with-extra-arguments-in-godot-4
	
	
	for array in map:
		for element in array:
			if element.tag != "Acqua":
				element.get_node("Label").text = str(element.CubeCoords)


func _process(_delta):
	if Input.is_action_just_pressed("MiddleMouseClick"):
		if StarActualCell.position != destinationCell.position and Occupato == false:
			a_star(StarActualCell,destinationCell,map)


func SetDestination(nodo):
	
	if nodo.Traversable == true:
		destinationCell = nodo
		StarActualCell.Heuristic = hexlib.distanzaHex(StarActualCell.CubeCoords,nodo.CubeCoords)




func add_tile(PositionVector:Vector3,CubeCoords): #Prende una posizione e ci mette una tile
	
	var Tile = ListaTiles[rng.randi()%3].instantiate()
	add_child(Tile)
	Tile.translate(PositionVector)
	Tile.CubeCoords = CubeCoords
	return Tile

func generate_grid(radius:int, size_, FirstH, grid):
	
	var current_hex = Vector3(0,0,0) #sarebbe la posizione in coordinate cubiche
	var PositionCoords
	var NewTileNode
	
	grid[radius][radius] = FirstH
	
	for ring in range(radius):
		
		current_hex =  hexlib.GetHexNeighbor(current_hex,"e")
		PositionCoords = hexlib.CubeToPosition(size_,current_hex)
		NewTileNode = add_tile(PositionCoords, current_hex)
		grid[radius][radius+1+ring] = NewTileNode
		
		for times in range(ring+1):
			current_hex =  hexlib.GetHexNeighbor(current_hex,"nw")
			PositionCoords = hexlib.CubeToPosition(size_,current_hex)
			NewTileNode = add_tile(PositionCoords, current_hex)
			grid[radius-times-1][radius+ring-times] = NewTileNode
		
		for times in range(ring+1):
			current_hex =  hexlib.GetHexNeighbor(current_hex,"w")
			PositionCoords = hexlib.CubeToPosition(size_,current_hex)
			NewTileNode = add_tile(PositionCoords, current_hex)
			grid[radius-1-ring][radius-1-times] = NewTileNode
		
		for times in range(ring+1):
			current_hex =  hexlib.GetHexNeighbor(current_hex,"sw")
			PositionCoords = hexlib.CubeToPosition(size_,current_hex)
			NewTileNode = add_tile(PositionCoords, current_hex)
			grid[radius-ring+times][radius-ring-1] = NewTileNode
		
		for times in range(ring+1):
			current_hex =  hexlib.GetHexNeighbor(current_hex,"se")
			PositionCoords = hexlib.CubeToPosition(size_,current_hex)
			NewTileNode = add_tile(PositionCoords, current_hex)
			grid[radius+1+times][radius-ring-1] = NewTileNode
		
		for times in range(ring+1):
			current_hex =  hexlib.GetHexNeighbor(current_hex,"e")
			PositionCoords = hexlib.CubeToPosition(size_,current_hex)
			NewTileNode = add_tile(PositionCoords, current_hex)
			grid[radius+ring+1][radius-ring+times] = NewTileNode
		
		for times in range(ring):
			current_hex =  hexlib.GetHexNeighbor(current_hex,"ne")
			PositionCoords = hexlib.CubeToPosition(size_,current_hex)
			NewTileNode = add_tile(PositionCoords, current_hex)
			grid[radius-times+ring][radius+times+1] = NewTileNode
		
		current_hex =  hexlib.GetHexNeighbor(current_hex,"ne")
	
	#si può risalire ai vicini di un esagono tramite la tabella. i vicini di un esagono in map[x][y] saranno map[x][y-1], map[x][y+1],map[x-1][y-1],map[x-1][y],map[x+1][y-1] e map[x+1][y]




func a_star(start_node, goal_node, ListOfNodes):
	
	Occupato = true
	
	var frontier: Array = [] #nodes to be evalueted
	var closed: Array = [] #nodes already evalueted
	var current_node: Object
	var CoordsOfHexNeighbor
	var NeighborNode: Object = null
	frontier.append(start_node)
	start_node.G_Cost = 0
	
	
	var ciclo = 0
	print("\n\n")
	while frontier.size() > 0:
		
		ciclo += 1
		
		print("in ciclo " + str(ciclo))
		if ciclo != 1:
			print("Sono in "+str(current_node.CubeCoords))
		else:
			print("Primo ciclo")
		print("Frontiera:")
		for element in frontier:
			print(str(element.CubeCoords) +" G:"+str(element.G_Cost)+" H:"+str(element.Heuristic))
		print("\n")
		
		current_node = GetLowestCostNode(frontier)
		frontier.erase(current_node)
		closed.append(current_node)
		
		
		if current_node == goal_node:
			RetracePath(start_node,current_node)
			CleanCosts(map)
			return
		
		for key in hexlib.HexDirectionVectors.keys(): #questa parte non credo sia ben ottimizzata
			CoordsOfHexNeighbor = hexlib.GetHexNeighbor(current_node.CubeCoords,key)
			
			var trovato = false
			for array in ListOfNodes:
				for element in array:
					if CoordsOfHexNeighbor == element.CubeCoords:
						NeighborNode = element
						trovato = true
						break
				
				if trovato == true:
					break
			
			if NeighborNode == null or NeighborNode.Traversable == false or closed.find(NeighborNode) != -1 : #il metodo find ritorna l'indice dell'elemento cercato se presente, -1 altrimenti. Quindi qui entriamo nell'if se il NeighborNode è presente
				pass
			else:
				var MovementCostToNeighbor: int = current_node.G_Cost + NeighborNode.Static_G_Cost #+ hexlib.distanzaHex(current_node.CubeCoords,NeighborNode.CubeCoords) #current_node.G_Cost + hexlib.distanzaHex(current_node.CubeCoords,NeighborNode.CubeCoords)
				if (MovementCostToNeighbor < NeighborNode.G_Cost) or (frontier.find(NeighborNode) == -1):
					if (MovementCostToNeighbor < NeighborNode.G_Cost):
						#Questa sostituzione sembra andare in contraddizione con la consistenza dell'eurisitca, ma in realtà un'euristica consistente non ci vieta di trovare percorsi migliori per un nodo nella frontiera. Ciò che impedisce è il trovare percorsi migliori per nodi già esplorati
						print("Ho trovato un path migliore per "+ str(NeighborNode.CubeCoords))
					NeighborNode.G_Cost = MovementCostToNeighbor
					#L'euristica è sia ammissibile che consistente. Consistente=>h(n)≤h(n')+c(n,n'). Qui è vero. h(n') sarà sempre o h(n)+1 o h(n)-1. c(n+n') sarà sempre o 1 o 3. nel caso più al limite, con h(n')=h(n)-1 (ossia ci avviciniamo al goal) e c(n,n')=1 avremo 1+h(n)-1 => h(n) quindi viene soddisfata la diseguaglianza h(n)≤h(n)
					NeighborNode.Heuristic = hexlib.distanzaHex(NeighborNode.CubeCoords,goal_node.CubeCoords)
					NeighborNode.parent = current_node
					if frontier.find(NeighborNode) == -1:
						frontier.append(NeighborNode)

	
	print("Cella irrangiungibile!\n")
	$AnimationPlayer.play("Unreachable")
	Occupato = false
	CleanCosts(map)
	return

func CleanCosts(Grid):
	for array in Grid:
		for node in array:
			if node.tag == "Erba":
				node.G_Cost = 1
			if node.tag == "Sabbia":
				node.G_Cost = 3


func RetracePath(NodoInizio, NodoFine) -> void:
	var Path: Array = []
	var CurrentNode: Object = NodoFine
	
	while CurrentNode != NodoInizio:
		Path.append(CurrentNode)
		CurrentNode = CurrentNode.parent
	
	#Posso includere anche il nodo iniziale se voglio, basta fare Path.append(CurrentNode)
	
	Path.reverse()
	
	
	for element in Path:
		$Star.position.x = element.position.x
		$Star.position.z = element.position.z 
		
		print("Going to cell " + str(element.CubeCoords))
		StarActualCell=element
		await get_tree().create_timer(1).timeout
	
	
	Occupato = false


func GetLowestCostNode(OpenNodes):
	
	var MinCostNode = OpenNodes[0]
	
	for i in range(OpenNodes.size()):
		if (OpenNodes[i].Heuristic + OpenNodes[i].G_Cost) < (MinCostNode.Heuristic + MinCostNode.G_Cost) or ( (OpenNodes[i].Heuristic + OpenNodes[i].G_Cost) == (MinCostNode.Heuristic + MinCostNode.G_Cost) and (OpenNodes[i].Heuristic < MinCostNode.Heuristic )):
			MinCostNode = OpenNodes[i]
	
	return MinCostNode


