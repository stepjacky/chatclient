package org.atomsoft.air.event
{
	import com.atomsoft.net.MessageBody;
	
	import flash.events.Event;
	
	public dynamic class MessageEvent extends Event
	{
		public static const MESSAGE_RECEIVED:String ="message_received";
		public static const MESSAGE_SENT:String ="message_sent";
		private var _messageBody:*;
		public function MessageEvent(type:String,msg:*)
			
		{
		
			super(type, false,false);
		    this._messageBody = msg;
		}
		
		override public function clone():Event
		{
			var mv:MessageEvent = new MessageEvent(this.type,this.messageBody);
			return mv;
		}
		
		override public function toString():String
		{
			return super.toString();
		}

		public function get messageBody():*
		{
			return _messageBody;
		}	
		
	}
	
}