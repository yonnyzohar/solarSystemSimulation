package  {
	
	public class AngledBody {
		public var left:Number;
		public var right:Number;
		public var dist:Number;
		public var added:Boolean;
		
		public function AngledBody() {
			// constructor code
			added = false;
		}

		public function reset():void{
			added = false;
			left = 0;
			right = 0;
			dist = 0;
		}

	}
	
}
