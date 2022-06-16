package {

	public class MathUtils {

		public function MathUtils() {
			// constructor code
		}

		public static function fixAngle(angle: Number): Number {
			if (angle > Math.PI * 2) {
				angle -= Math.PI * 2;
			} else if (angle < 0) {
				angle += Math.PI * 2;
			}
			return angle;
		}

		public static function getDistance(p1X: Number, p1Y: Number, p2X: Number, p2Y: Number): Number {
			var dX: Number = p1X - p2X;
			var dY: Number = p1Y - p2Y;
			var dist: Number = Math.sqrt(dX * dX + dY * dY);
			return dist;
		}

		public static function getAngle(p1X: Number, p1Y: Number, p2X: Number, p2Y: Number): Number {
			var dX: Number = p1X - p2X;
			var dY: Number = p1Y - p2Y;
			return Math.atan2(dY, dX);
		}

		public static function getVector(x1:Number, y1:Number, x2:Number, y2:Number):Object
		{
			return {x : x2 - x2, y : y2 - y1};
		}

		public static function dotPruduct(vec1:Object, vec2:Object):Number
		{
			return vec1.x * vec2.x + vec1.y * vec2.y;
		}

		public static function normalize(vec:Object):Object
		{
			var distance = getDistance(vec.x, vec.y, vec.x, vec.y);
			return {
				x : vec.x / distance,
				y : vec.y / distance
			}
		}
		//var v1 = getVector();
		//var v2 = getVector();
		//var dot = dotPruduct(normalize(getVector(x1,y1,x2,y2)), normalize(getVector(x1,y1,x2,y2)))


	}

}