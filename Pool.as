package  {
	
	public class Pool {

		private var dict:Object = {};

		private static var instance:Pool = new Pool();
		
		public function Pool()
		{
			if (instance)
			{
				throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
			}
		}
		
		public static function getInstance():Pool
		{
			return instance;
		}

		public function init(_numElements : int, _CLS:Class, type:String, fnctn:Function = null):void 
		{
			
			dict[type] = {
				curIndex : 0,
				numElements : _numElements,
				CLS : CLS,
				pool : new Array(_numElements),
				fnctn:fnctn
			};

			var CLS:Class = _CLS;
			//the current index of the pool
			var pool:Array = dict[type].pool;//the actual pool storing the elements
			for(var i:int = 0; i < _numElements; i++)
			{
				pool[i] = new CLS();
				if(fnctn != null) 
				{
					fnctn(pool[i]);
				}
			}
		}

		public function clear(type:String):void
		{
			
			if(dict[type])
			{
				var obj:Object = dict[type];
				obj.curIndex = 0;
			}
			else{
				throw new Error("pool " + type + " does not exit in pool");
			}
			
		}

		public function get(type:String):*
		{
			if(dict[type])
			{
				var obj:Object = dict[type];
				var pool:Array = obj.pool;
				var e:* = pool[obj.curIndex];
				if(e == null)
				{
					throw new Error("pool " + type + " limit exceeded " + obj.curIndex);
				}
				if(obj.fnctn)
				{
					obj.fnctn(e);
				}
				obj.curIndex++;
				return e;
			}
			else{
				throw new Error("pool " + type + " does not exit in pool");
			}
			return null;
			
		}

		public function putBack(e:*, type:String):void
		{
			if(dict[type])
			{
				var obj:Object = dict[type];
				var pool:Array = obj.pool;
				obj.curIndex--;
				pool[obj.curIndex] = e;
			}
			else{
				throw new Error("pool " + type + " does not exit in pool");
			}
			
		}


	}
	
}
