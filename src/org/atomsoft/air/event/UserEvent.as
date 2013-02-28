package org.atomsoft.air.event
{
	import flash.events.Event;
	
	public dynamic class UserEvent extends Event
	{
		public static const USER_ONLINE:String  = "user_online";
		public static const USER_OFFLINE:String = "user_office";
		public static const USER_LOGIN_SUCCESS:String = "user_login_success";
		public static const USER_LOGIN_FAILED:String = "user_login_failure";
		public function UserEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}