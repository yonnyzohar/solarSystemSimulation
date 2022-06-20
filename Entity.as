package  {
	import flash.display.Stage;
	public class Entity {

		public var name: String;
		public var x: Number;
		public var y: Number;
		public var radius: Number;
		public var color: uint;
		public var angle: Number;
		public var speed: Number;
		public var prevRow:int;
		public var prevCol:int;

		public var model:Model;
		public var stage:Stage;

		public function Entity(_model:Model,_stage:Stage ) {
			model = _model;
			stage = _stage;
		}

		public function draw(parentObj: Planet = null):void
		{
			var col:int = (x - Model.mapLeft) / Model.tileW;
			var row:int = (y - Model.mapTop) / Model.tileH;

			if(row != prevRow || col != prevCol)
			{
				var oldDictName:String = String(prevRow) + "_" + String(prevCol);
				var block:Object = Model.partition[oldDictName];
				if(block)
				{
					block.numPlanets--;
					delete block[name];
				}
				
				
				var newDictName:String = String(row) + "_" + String(col);
				if(!Model.partition[newDictName])
				{
					Model.partition[newDictName] = { color : 0xffffff * Math.random(), row : row, col:col ,numPlanets:0};
				}
				Model.partition[newDictName][name] = this;
				Model.partition[newDictName].numPlanets++;
				prevRow = row;
				prevCol = col;
			}
		}

	}
	
}
