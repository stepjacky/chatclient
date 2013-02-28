// ActionScript file
import com.atomsoft.ui.AlertWindow;

import de.polygonal.ds.HashMap;

import flash.desktop.*;
import flash.display.*;
import flash.events.*;
import flash.net.*;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.controls.*;
import mx.core.IFlexDisplayObject;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;

import org.atomsoft.air.chatclient.ChatSocket;
import org.atomsoft.air.event.*;

import spark.components.NavigatorContent;
import spark.components.WindowedApplication;
import spark.skins.spark.WindowedApplicationSkin;


private var _socket:ChatSocket;



[Embed(source='assets/qq.png')]
private var icon16:Class;
private var bitmap16:Bitmap = new icon16();  

[Embed(source="assets/qq-hide.png")]        
private var icon16Hide:Class;  
private var bitmap16Hide:Bitmap = new icon16Hide();


private var _notifyTimer:Timer;                                        //监听图标闪动  
private var _state:int=0;                                                //闪动状态  

private var logined:Boolean = false;
public var currentMaster:Object;

private var defaultSysDockIconBitmaps:Array = [bitmap16.bitmapData,bitmap16Hide.bitmapData];  
public static const chatWindow:HashMap = new HashMap();
public var loginWindow:LoginWindow;
protected function window1_creationCompleteHandler(event:FlexEvent):void{
	
	
	var h:Number = flash.system.Capabilities.screenResolutionY;  
	var w:Number = flash.system.Capabilities.screenResolutionX; 
	this.move(w/2-this.width/2,h/2-this.height/2); //（this当前窗体)
	this.addEventListener(LoginEvent.USER_LOGIN,userLogin);
	this.addEventListener(LoginEvent.LOGIN_SUCCESS,loginSuccess);
	this.addEventListener(LoginEvent.LOGIN_FAILED,loginFailed);
	if(!logined){
		
		var fpo:IFlexDisplayObject = PopUpManager.createPopUp(this,LoginWindow,true);
		loginWindow = fpo as LoginWindow;					
		
	}
	
	this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownAndDragHandler);
	this.addEventListener(MouseEvent.DOUBLE_CLICK,restoreWindow);
	this.addEventListener(UserEvent.USER_ONLINE,userOnlieHandler);
	this.addEventListener(UserEvent.USER_OFFLINE,userOfficeLineHandler);				
	
	_notifyTimer = new Timer(500);  
	_notifyTimer.addEventListener(TimerEvent.TIMER,onNotify);            //监听Timer触发有新消息时任务栏闪动事件
	
	
}


private function userLogin(evt:LoginEvent):void{
	trace("用户登陆中...");
	
	if(_socket==null){
		_socket = new ChatSocket(this,loginWindow);
	}else{
		if(!_socket.connected)
			_socket.reconnect();
	}
	
	_socket.dispatchEvent(evt);
	
	
}


private function restoreWindow(evt:MouseEvent):void{
	this.restore();
}
/**  
 *每隔500ms触发Timer状态栏闪动提醒事件 
 *  
 **/  
private function onNotify(evt:TimerEvent):void{  
	if (_state == 0)  
		_state = 1;  
	else  
		_state = 0; 

	NativeApplication.nativeApplication.icon.bitmaps = [defaultSysDockIconBitmaps[_state]];  
}

public function startNotify():void{
	_notifyTimer.start();
}

public function stopNotify():void{
	_notifyTimer.stop();
}

//////////////////////////////////////////////////////////////////////////////////////////////////

public function dockHandler():void{
	this.nativeWindow.visible = false;
	//添加任务栏图标
	addSysTrayIcon();
}
private function addSysTrayIcon():void{
	//icon16是一个图片文件，大小为16*16
	this.nativeApplication.icon.bitmaps = [new icon16()];
	if(NativeApplication.supportsSystemTrayIcon){
		
		var sti:SystemTrayIcon = SystemTrayIcon(this.nativeApplication.icon);
		sti.tooltip="OA在线";
		//创建菜单列表
		sti.menu = createSysTrayMenu();
		//单击系统托盘图标时恢复窗口
		sti.addEventListener(MouseEvent.CLICK,doubleClickUndock);
		//sti.addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickUndock);
	}
}

private function createSysTrayMenu():NativeMenu{
	var menu:NativeMenu = new NativeMenu();
	var labels:Array = ["恢复","打开OA","","退出"];
	var names:Array = ["mnuOpen","menuOa","mnuSep1","mnuExit"];
	for (var i:int = 0;i<labels.length;i++){
		//如果标签为空的话，就认为是分隔符
		var menuItem:NativeMenuItem = new NativeMenuItem( labels[i],labels[i]=="");
		menuItem.name = names[i];
		menuItem.addEventListener(Event.SELECT,sysTrayMenuHandler );//菜单处理事件
		menu.addItem( menuItem );                
	}
	
	return menu;
}

private function sysTrayMenuHandler(event:Event):void{
	switch(event.target.name){
		case "mnuOpen"://打开菜单
			undockHandler();
			break;
		case "mnuExit"://退出菜单
			exitHandler();
			break;
		case "menuOa"://
		
			var req:URLRequest = new URLRequest("http://localhost");
			flash.net.navigateToURL(req,"oawin");
			break;
		
		
	}
	
}

private function undockHandler():void{
	this.nativeWindow.visible = true;
	this.nativeApplication.icon.bitmaps = [];
	//窗口提到最前面
	this.nativeWindow.orderToFront();
	//激活当前窗口
	this.activate();
}
private function doubleClickUndock(event:MouseEvent):void{
	undockHandler();
	stopNotify();
}
private function exitHandler():void{
	this.exit();
}

protected function image1_clickHandler(event:MouseEvent):void
{
	cleanclose();				
}

protected function image2_clickHandler(event:MouseEvent):void
{
	
	
	this.dockHandler();
	
	
}
private function cleanclose():void{
	if(_socket.connected){
		_socket.offline();
		_socket.close();
	}
	_socket=null;
	
	this.close();
}


public function createAlert(msg:String):void{
	var a:AlertWindow = new AlertWindow("系统提示",msg,10,300,200);
	
	a.activate();
	
}






protected function mouseDownAndDragHandler(event:MouseEvent):void
{
	if(event.target is WindowedApplicationSkin)
		this.nativeWindow.startMove();
	
}




/**
 * 响应用户上线事件
 * */
protected function userOnlieHandler(event:UserEvent):void
{
	this.createAlert("我上线了!");
	
}

/**
 * 响应用户离线事件
 * */
protected function userOfficeLineHandler(event:UserEvent):void
{
	// TODO Auto-generated method stub
	
}



protected function loginSuccess(event:LoginEvent):void
{
	this.loginWindow.enabled=true;
	PopUpManager.removePopUp(this.loginWindow);
	var obj:* = event.messageBody;
	var depts:ArrayCollection = obj.depts as ArrayCollection;
	var user:Object = obj.user;
	this.currentMaster = user;
	deptUI.dataProvider = depts;
	userId.label=user.localName+"["+user.username+"]";
	
}

protected function loginFailed(event:LoginEvent):void
{
	trace("login failed handler :"+event.loginMessage);
	this.loginWindow.enabled=true;
	this.loginWindow.errmsg.text=event.loginMessage;
	createAlert("登陆失败");				
}


protected function deptUI_itemDoubleClickHandler(event:ListEvent):void
{
	var node:Object=Tree(event.currentTarget).selectedItem;
	trace(node);
	if(node.parentable){
		
		deptUI.expandItem(node,!deptUI.isItemOpen(node));
		
	}else{
		
		//mx.controls.Alert.show(node.hasOwnProperty("other")+"");
        //var map:HashMap = new HashMap();
	    var cw:UserChatClient = new UserChatClient;
		cw.open();
		var levt:ChatEvent = new ChatEvent();
		levt.Master = this.currentMaster;
		levt.Slaver = node.other;
		levt.Channel = this._socket;
		//cw.dispatchEvent(levt);
		cw.initilize(this.currentMaster,node.other,this._socket);
	}
}
