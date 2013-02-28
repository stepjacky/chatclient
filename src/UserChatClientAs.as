// ActionScript file
import com.atomsoft.ui.AlertWindow;

import flash.events.*;

import flashx.textLayout.events.UpdateCompleteEvent;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.events.*;

import org.atomsoft.air.chatclient.ChatSocket;
import org.atomsoft.air.event.*;

import spark.components.Window;
import spark.skins.spark.WindowedApplicationSkin;

private var _socket:ChatSocket;
public var master:Object;
public var slaver:Object;

protected function button1_clickHandler(event:MouseEvent):void
{
	
	this._socket.speak();
	this.sayBox.text="";
	
}

protected function windowedapplication1_creationCompleteHandler(event:FlexEvent):void
{
	
	messageBox.addEventListener(FlexEvent.UPDATE_COMPLETE,textAreaScrollToBottom);
	var h:Number = flash.system.Capabilities.screenResolutionY;  
	var w:Number = flash.system.Capabilities.screenResolutionX; 
	//2.窗口初始化时，用move()方法移动到中心
	this.move(w/2-this.width/2,h/2-this.height/2); //（this当前窗体)
	this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownAndDragHandler);	
	this.addEventListener(MessageEvent.MESSAGE_RECEIVED,messageReceivedHandler);
	this.addEventListener(MessageEvent.MESSAGE_SENT,messageSentHandler);
	//_notifyTimer.start();  
	this.addEventListener(ChatEvent.CHAT_INIT,chatInitilize);
	
	trace("组件创建完成");
	
	
}

public function initilize(m:Object,s:Object,sk:ChatSocket):void{
	trace("聊天初始化方法"+this.hasEventListener(ChatEvent.CHAT_INIT));
	
	this.master = m;
	this.slaver = s;
	this._socket = sk;
	
	muid.text+=master.localName+"["+master.username+"]";
	mdid.text+=master.deptName;
	mrid.text+=master.roleName;
	masteracegis.dataProvider = master.secRoles;
	
	suid.text+=slaver.localName+"["+slaver.username+"]";
    sdid.text+=slaver.deptName;
	srid.text+=slaver.roleName;
	slaveracegis.dataProvider = slaver.secRoles;
}

protected function chatInitilize(event:ChatEvent):void
{
	
	slaveracegis.dataProvider = slaver.secRoles;
	
	
}

private function mouseDownAndDragHandler(evt:MouseEvent):void{
	
	if(evt.target is WindowedApplicationSkin){
		this.nativeWindow.startMove();	
		
	}
}



protected function windowedapplication1_closeHandler(event:Event):void
{
	this.close();
	
	
}

private function textAreaScrollToBottom(event:Event):void { 
	//trace("textAreaScrollToBottom﻿"); 
	messageBox.scroller.verticalScrollBar.value = messageBox.scroller.verticalScrollBar.maxHeight+20;
	
	
}﻿

protected function button2_clickHandler(event:MouseEvent):void
{
	this.close();
	
}


protected function image1_clickHandler(event:MouseEvent):void
{
	this.minimize();
}

protected function image2_clickHandler(event:MouseEvent):void
{
	this.close();
	
	
}

protected function messageBox_clickHandler(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	
}		

/**
 * 响应用户收到消息事件
 * */
protected function messageReceivedHandler(event:MessageEvent):void
{
	// TODO Auto-generated method stub
	
}

/**
 * 响应用户发送消息事件
 * */
protected function messageSentHandler(event:MessageEvent):void
{
	// TODO Auto-generated method stub
	
}