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


	}

}