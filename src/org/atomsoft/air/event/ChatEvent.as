package org.atomsoft.air.event
{
	import flash.events.Event;
	
	import org.atomsoft.air.chatclient.ChatSocket;
	
	public class ChatEvent extends Event
	{
		public static const  CHAT_INIT:String = "chat_init";
		private var _master:Object;
		private var _slaver:Object;
		private var _channel:ChatSocket;
		public function ChatEvent(type:String=CHAT_INIT, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		/**
		 * 聊天发起用户
		 * */
		public function get Master():Object
		{
			return _master;
		}

		public function set Master(value:Object):void
		{
			_master = value;
		}

		/**
		 * 聊天受邀用户
		 * */
		public function get Slaver():Object
		{
			return _slaver;
		}

		public function set Slaver(value:Object):void
		{
			_slaver = value;
		}

		/**
		 * 数据发送通道
		 * */
		public function get Channel():ChatSocket
		{
			return _channel;
		}

		public function set Channel(value:ChatSocket):void
		{
			_channel = value;
		}
		
		override public function clone():Event
		{
			var evt:ChatEvent = new ChatEvent();
			evt.Master = this.Master;
			evt.Slaver = this.Slaver;
			evt.Channel = this.Channel;
			return evt;
		}
		
		override public function toString():String
		{
			// TODO Auto Generated method stub
			return super.toString()+" [chatEvent]";
		}
		
		

	}
}