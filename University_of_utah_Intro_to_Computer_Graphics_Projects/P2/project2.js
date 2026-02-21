// Returns a 3x3 transformation matrix as an array of 9 values in column-major order.
// The transformation first applies scale, then rotation, and finally translation.
// The given rotation value is in degrees.
function ToRad( Degrees){
	return Degrees * Math.PI / 180;
}

function MatrixToArray(matrix) {
    let rows = matrix.length;
    let columns = matrix[0].length;
    let result = [];

    for (let j = 0; j < columns; j++) {
        for (let i = 0; i < rows; i++) {
            result.push(matrix[i][j]);
        }
    }

    return result;
}

function MatrixMult (Matrix1, RowsM1, ColumnsM1, Matrix2, RowsM2, ColumnsM2){

	let ProductMatrix = Array(RowsM1).fill().map(() => Array(ColumnsM2).fill(0));
  
	  if (RowsM2 != ColumnsM1){
		  throw new Error("Multiplication is impossible")
	  }
  
	  for ( i = 0; i < RowsM1; i++){
		  for ( j = 0; j < ColumnsM2; j++){
			  for (k = 0; k < ColumnsM1; k++){
					  ProductMatrix[i][j] += (Matrix1[i][k] * Matrix2[k][j])
			  }
		  }
	  }
  
	  return ProductMatrix
  
}
  


function GetTransform( positionX, positionY, rotation, scale )
{

	let TranslationMatrix = [
		[1,0,positionX],
		[0,1,positionY],
		[0,0,1]
	];

	let rotationRad = ToRad(rotation);

	let RotationMatrix = [
		[Math.cos(rotationRad),- Math.sin(rotationRad),0],
		[Math.sin(rotationRad),Math.cos(rotationRad),0],
		[0,0,1]
	];

	let ScaleMatrix = [
		[scale,0,0],
		[0,scale,0],
		[0,0,1]
	];


	let IntermediateMatrix = MatrixMult(TranslationMatrix,3,3,RotationMatrix,3,3);

	let FinalMatrix = MatrixMult(IntermediateMatrix,3,3,ScaleMatrix,3,3);
	
	

	return MatrixToArray(FinalMatrix);
}

// Returns a 3x3 transformation matrix as an array of 9 values in column-major order.
// The arguments are transformation matrices in the same format.
// The returned transformation first applies trans1 and then trans2.
function ApplyTransform( trans1, trans2 ){
	return MatrixToArray( MatrixMult(trans2,3,3,trans1,3,3) );
}
