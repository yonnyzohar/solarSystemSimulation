package
{
    import flash.events.Event;
    import flash.utils.getTimer;
    import flash.text.TextField;
     
    public class FPSDemo
    {
        public var startTime:Number;
        public var framesNumber:Number = 0;
        //public var fps:TextField = new TextField();
     
        public function FPSDemo()
        {
            startTime = getTimer();
        }
 
        public function checkFPS(tf:TextField):void
        {
            var currentTime:Number = (getTimer() - startTime) / 1000;
 
            framesNumber++;
             
            if (currentTime > 1)
            {
                tf.text = ("FPS: " + (Math.floor((framesNumber/currentTime)*10.0)/10.0)) ;
                startTime = getTimer();
                framesNumber = 0;
            }
        }
    }
}