package  
{
	public class Astar 
	{
		private var path : Array;
		private var closedList : Array;
		private var openList : Array;
		public var visitedList : Array;

		private var numRows:int;
		private var numCols:int;

		
		public function Astar() 
		{
			
			
			
			/**/
			//use case example
			
			
		}
	
		public function printPath(map:Array, list:Array):void
		{
			for(var i:int = 0; i < list.length; i++)
			{
				var node:Object = list[i];
				map[node.row][node.col] = 5;
			}
		
			for(var row:int = 0; row < numRows; row++)
			{
				trace(map[row].toString());
			}
		
		}

		
		
		public function getPath( grid : Array, startNode : Object, endNode : Object ) : Array {

			path = [];
			visitedList = [];

			openList = [];
			closedList = [];
			startNode.g = 0;//cost from start node
			startNode.h = estimateDistance(startNode, endNode);//cost to end node
			startNode.f = startNode.g + startNode.h;//combination - global cost
			openList.push(startNode);
			while ( openList.length > 0 ) {
				var curNode:Object = removeSmallest( openList );
				closedList.push(curNode);
				if ( curNode == endNode ) {
					return createPath( startNode, endNode );
				}else {
					for each ( var neighbor : Object in getNeighbors( grid, curNode ) ) {
						visitedList.push(neighbor);
						var g: Number = curNode.g + getCost( curNode, neighbor );
						if ( closedList.indexOf(neighbor) >= 0 ||
						    openList.indexOf(neighbor) >= 0 ) {
							if ( neighbor.g > g ) {
								 neighbor.g = g;
								 neighbor.f = neighbor.h + g;
								 neighbor.parent = curNode;
							}
						}else {
								 neighbor.g = g;
								 neighbor.h = estimateDistance( neighbor, endNode );
								 neighbor.f = neighbor.h + g;
								 neighbor.parent = curNode;
								 openList.push(neighbor);
						}
					}
				}
			}
			path = [];
			return path;
		}
		
		private function createPath(startNode:Object, endNode:Object):Array
		{
			path = [];
			var curNode : Object = endNode;
			path.push( endNode );
			while (curNode != startNode) {
				curNode = curNode.parent;
				path.push(curNode);
			}
			path.reverse();
			return path;
		}
		
		private function getCost(curNode:Object, neighbor:Object):Number
		{
			var cost : Number = 1.0;
			if (( curNode.row != neighbor.row ) &&
			    ( curNode.col != neighbor.col ) ) {
				cost = 1.414;
			}
			return cost;
		}
		
		private function getNeighbors(grid:Array, curNode:Object):Array
		{
			var neighbors : Array = [];
			var startRow : uint = Math.max( 0, curNode.row - 1 );
			var startCol : uint = Math.max( 0, curNode.col - 1 );
			var endRow : uint = Math.min( numRows - 1, curNode.row + 1 );
			var endCol : uint = Math.min( numCols - 1, curNode.col + 1 );
			for ( var r : uint = startRow; r <= endRow; r++ ) {
				for ( var c : uint = startCol; c <= endCol; c++ ) {
					var neighbor:Object = grid[r][c];
					//&& neighbor.regionNum == curNode.regionNum
					if ( neighbor.walkable == true  ) {
						neighbors.push( neighbor );
					}
				}
			}
			return neighbors;
		}
		
		private function estimateDistance(curNode:Object, endNode:Object):Number
		{
			var distX : uint = Math.abs( curNode.col - endNode.col );
			var distY : uint = Math.abs( curNode.row - endNode.row );
			return Math.sqrt((distX * distX) + (distY *distY));

			/*
			var numDiagSteps : uint = Math.min( distX, distY );
			var numStraightSteps : uint = distX + distY - ( numDiagSteps << 1 );
			var diagLength : Number = 1.414 * numDiagSteps;
			return diagLength + numStraightSteps;
			*/
		}
		
		private function removeSmallest(array:Array):Object
		{
			array.sortOn(["f"], [Array.NUMERIC]);
			return array.shift();
		}

		public function createNodesBoard(map: Array, walkable:int) {
			numRows = map.length;
			numCols = map[0].length;
			var nodesBoard: Array = []
			for (var row: int = 0; row < numRows; row++) {
				nodesBoard[row] = [];
				for (var col: int = 0; col < numCols; col++) {
					nodesBoard[row][col] = {
						g:0,//distance from start node
						h:0,//huristic distnace to end node
						f:0,//combined cost of the two
						parent:null,
						row:row,
						col:col,
						walkable:map[row][col] == walkable
					}; //this is tricky
				}
			}

			return nodesBoard
		}
		
	}

}
