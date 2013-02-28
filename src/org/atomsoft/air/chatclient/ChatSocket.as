package org.atomsoft.air.chatclient
{
	import flash.errors.IOError;
	import flash.events.*;
	import flash.net.Socket;
	import flash.net.dns.AAAARecord;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayList;
	
	import org.atomsoft.air.event.*;
	
	public final class ChatSocket extends Socket
	{
		private var _readFlag:int = 0;
		private var _mainChatClient:MainChatClient;	
		private var _loginWin:LoginWindow;
		
		private var msgType:int;
		private var msgLen:int;                        //消息长度
		                    //收到的消息最大长度
		private var headLen:int;                        //消息头长度
		private var isReadHead:Boolean;                //是否已经读了消息头
		private var bytes:ByteArray;                //所读数据的缓冲数据，读出的数据放在这里
		private var host:String = SystemEnvironment.REMOVE_HOST;
		private var port:int    = SystemEnvironment.REMOVE_PORT;
		
		
		
		public function ChatSocket(mcc:MainChatClient=null,lw:LoginWindow=null)			
		{
			this._mainChatClient = mcc;
			_loginWin = lw;			
			
			headLen = 4;                //4个字节
			bytes = new ByteArray();
			isReadHead = false;
			super(host, port);			
			configureListeners();
			if (host && port)  {
				_loginWin.errmsg.text="正在连接...";
				_loginWin.enabled=false;
				super.connect(host, port);
			}
			
			
		}
		private function connectHandler(event:Event):void {
			trace("connectHandler: " + event);
			_loginWin.errmsg.text="连接成功!";
			_buffer = new ByteArray();
			_header = new ByteArray();
			_length = -1;
			_readOffset = 0;
			_writeOffset = 0;

			
			
		}
		public function reconnect():void{
			if(!connected)super.connect(host, port);
		}
		protected function loginHandler(evt:LoginEvent):void
		{
			
			var obj:Object = new Object;
			obj.mtype=MessageType.LOGIN;
			obj.userName = evt.userName;
			obj.passWord = evt.passWord;
			trace("用户登陆事件 : "+evt);
			var objByte:ByteArray= new ByteArray();  
			objByte.writeObject(obj);
			// objByte.compress();   //压缩，可以省略  
			var msgByte:ByteArray = new ByteArray(); 		
			msgByte.writeInt(objByte.length);  
			msgByte.writeBytes(objByte, 0, objByte.length);  
			writeBytes(msgByte);  
			flush();    
			
		}
		
		private function configureListeners():void {
			
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			addEventListener(MessageEvent.MESSAGE_RECEIVED,processMessage);
			addEventListener(LoginEvent.USER_LOGIN,loginHandler);
		}
		protected function writeln(str:String):void {
			if(!this.connected) return;
			str += "\n";
			try {
				if(str=="\n")return;
				writeUTFBytes(str);
			}
			catch(e:IOError) {
				trace(e);
			}
		}
		
		private function closeHandler(event:Event):void {
			trace("closeHandler: " + event);
			_loginWin.enabled=true;
			_mainChatClient.statusText.text="请稍候登陆...";
			
		}
		
		
		
	
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
			_loginWin.errmsg.text="网络错误,未能连接服务器!";
			_loginWin.enabled = true;
		   
			
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
			_loginWin.errmsg.text="网络安全错误,未能连接服务器!";
		}
		
		private function socketDataHandler(event:ProgressEvent):void {
			trace("socketDataHandler: " + event);
			readData();
			//readResponse();
		}
				
		private function readResponse():void {
			//_readFlag:int;//0表示全部读完了，1表示长度读取完毕 2表示正在读取数据
		    trace("接收到服务器反馈消息 isReadHead:"+this.isReadHead+", bytesAvailable:"+bytesAvailable);
			
			
			var message:Object = null;
			
			//如果需要读信息头
			if(!isReadHead && bytesAvailable>=4)
			{
				var lenByte:ByteArray = new ByteArray();
				readBytes(lenByte,0,4);
				msgLen = lenByte.readUnsignedInt();
				trace("新消息长度 "+msgLen);
				this.isReadHead = true;
			}
			
			//如果已经读了信息头,则看能不能收到满足条件的字节数
			if(isReadHead && bytesAvailable >= this.msgLen)
			{
				
				trace("主体数据"+bytesAvailable+","+this.msgLen);
				var objByte:ByteArray = new ByteArray;
				readBytes(objByte,0,this.msgLen);
				this.isReadHead = false;
				var obj:Object = objByte.readObject();
				
				this.useMessage(obj);
				trace("读取对象后可用数据值:"+bytesAvailable);
				
			}
			
		    (bytesAvailable>0 && this.readResponse())
			
					
		}
		
		private function useMessage(msg:*):void{
			if(msg!=null){
				this.isReadHead = false;
				var evt:MessageEvent = new MessageEvent(MessageEvent.MESSAGE_RECEIVED,msg);
				　       dispatchEvent(evt);
				
			}
		}
		
		private function processMessage(evt:MessageEvent):void
		{
			var obj:Object = evt.messageBody;
			var mtype:int = obj.mtype;
			var levt:LoginEvent;
			trace("收到消息类型: "+mtype);
			if(mtype==3){
				levt = new LoginEvent(LoginEvent.LOGIN_SUCCESS);
				levt.loginMessage = obj.textMessage;
				levt.messageBody = obj;
			}else if(mtype==4){
				levt = new LoginEvent(LoginEvent.LOGIN_FAILED);
			    levt.loginMessage=obj.textMessage;
			}
			
			_mainChatClient.dispatchEvent(levt);
			
		}		
		
		public function speak():void{
			
		}
		
		public function offline():void{
			
		}
		
		private var _queue:Array = [];
		private var _dataTimer:Timer;
		private var _header:ByteArray;
		private var _length:int = -1;
		private var _buffer:ByteArray;
		private var _readOffset:int;
		private var _writeOffset:int;
		private static const HEADER_SIZE:int = 4;
		private function readData():void {
			trace("接收到服务器反馈消息  bytesAvailable:"+bytesAvailable);
			
			var len:int = bytesAvailable;
			if(len > 0) {
				readBytes(_buffer,_writeOffset,len);
				_writeOffset += len;
				if(_writeOffset > 1) {
					_buffer.position = 0;
					_readOffset = 0;
					if(_buffer.bytesAvailable >= 4) {
						readPacket();
					}
				}
			}
		}
		private function readPacket():void {
			var t1:int = getTimer();
			var dataLeft:int = _writeOffset - _readOffset;
			var d:int = dataLeft;
			//trace('===== dataLeft :',dataLeft);
			var c:int = 0;
			do
			{
				//trace('loop :',c++);
				c++;
				if(_length < 0) {
					while(_header.length < HEADER_SIZE) {
						_header.writeByte(_buffer.readByte());
						_readOffset++;
					}
					_header.position = 0;
					_length = _header.readInt();
					_header.length = 0;
				}
				var len:int = _length;
				dataLeft = _writeOffset - _readOffset;
				if(dataLeft >= len && len > 0) {
					_length = -1;
					_buffer.position = _readOffset;				
					_readOffset += len;
					dataLeft = _writeOffset - _readOffset;
					var bytes:ByteArray = new ByteArray();
					_buffer.readBytes(bytes,0,len);
					//_queue.push(bytes);
					//trace('length:',len,dataLeft,bytes.length);
					try {
						var obj:Object = bytes.readObject();
						this.useMessage(obj);
						//trace('time:',new Date().time - obj.time,', value:',obj.value);
					}
					catch(e:Error) {
						trace(e);
					}
				}
				else {
					break;
				}
				if(c > 5) {
					//break;
				}
			}
			while(dataLeft >= HEADER_SIZE);	
			
			_buffer.position = 0;
			if(dataLeft > 0)
			{
				_buffer.writeBytes(_buffer,_readOffset,dataLeft);
			}
			_readOffset = 0;
			_writeOffset = dataLeft;
			var t2:int = getTimer();
			var t:int = t2 - t1;
			//if(c > 10)
			//trace('#######  readPacket() : ',t,c,d);
		}

		
	}
	
	
	
	
}