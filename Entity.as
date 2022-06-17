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

		public var model:Model;
		public var stage:Stage;

		public function Entity(_model:Model,_stage:Stage ) {
			model = _model;
			stage = _stage;
		}

	}
	
}
