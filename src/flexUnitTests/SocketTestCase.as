package flexUnitTests
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.atomsoft.air.chatclient.ChatSocket;
	import org.atomsoft.air.event.LoginEvent;
	
	public class SocketTestCase
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		
		[Test]
		public function testSocket():void{
			
			
		
			
			var socket:ChatSocket = new ChatSocket();
			var timer:Timer = new Timer(20,50);
		
			timer.addEventListener(TimerEvent.TIMER,function(evt:TimerEvent):void{
				
				trace("当前测试第 "+timer.currentCount+"/"+timer.repeatCount+"次");
				var loginEvent:LoginEvent = new LoginEvent();
				loginEvent.userName = "qujiakang";
				loginEvent.passWord = "789456";
				socket.dispatchEvent(loginEvent);
			});
			timer.start();
		}
		
	}
}