extends RefCounted


static func distanzaHex(FirstHex:Vector3, SecondHex:Vector3):
	var DistanceVector = FirstHex-SecondHex
	return max(abs(DistanceVector.x),abs(DistanceVector.y),abs(DistanceVector.z))
## potrebbe essere utile implementare una funzione che non sia un metodo della classe la quale calcoli la distanza
## fra due esagoni avendo in input solamente il loro "esagono distanza". casomai dovesse esser un qualcosa di cui 
## sentirai bisogno torna qui ed implementa

static var HexDirectionVectors = {
	"nw":Vector3(0,-1,1),
	"w":Vector3(-1,0,1),
	"sw":Vector3(-1,1,0),
	"se":Vector3(0,1,-1),
	"e": Vector3(1,0,-1),#    print(HexDirectionVectors.values()[2]) per accedere ad un valore specifico
	"ne": Vector3(1,-1,0)#    for value in HexDirectionVectors.values():  puoi scorrere fra i valori
	}

static func GetHexNeighbor(StartingHex: Vector3, Direction: String): #Prende un hex ed una direzione ("e","ne","nw","w","sw","se")
	return StartingHex+HexDirectionVectors[Direction]

static func CubeToPosition(size, HexVector: Vector3):
	var x = size * (sqrt(3) * HexVector.x  +  sqrt(3)/2 * HexVector.y)
	var z = size * (                                3/(1.99) * HexVector.y)
	return Vector3(x,0,z)
