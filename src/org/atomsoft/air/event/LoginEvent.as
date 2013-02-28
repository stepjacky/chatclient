package org.atomsoft.air.event
{
	import flash.events.Event;
	
	public class LoginEvent extends Event
	{
		public static const USER_LOGIN:String = "user_login_to_system";
		public static const LOGIN_SUCCESS:String = "login_success";
		public static const LOGIN_FAILED:String = "login_failed";
		private var _loginMessage:String;
		private var _userName:String;
		private var _passWord:String;
		private var _messageBody:*;
		
		public function LoginEvent(type:String=USER_LOGIN, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
				
		
		
		public function get passWord():String
		{
			return _passWord;
		}

		public function set passWord(value:String):void
		{
			_passWord = value;
		}

		public function get userName():String
		{
			return _userName;
		}

		public function set userName(value:String):void
		{
			_userName = value;
		}
		
		override public function clone():Event
		{
			
            var evt:LoginEvent = new LoginEvent();
			evt.userName = this.userName;
			evt.passWord = this.passWord;
			return evt;
		}
		
		override public function toString():String
		{
			// TODO Auto Generated method stub
			return super.toString()+"["+userName+","+passWord+"]";
		}		

		public function get loginMessage():String
		{
			return _loginMessage;
		}

		public function set loginMessage(value:String):void
		{
			_loginMessage = value;
		}

		public function get messageBody():*
		{
			return _messageBody;
		}

		public function set messageBody(value:*):void
		{
			_messageBody = value;
		}


	}
}