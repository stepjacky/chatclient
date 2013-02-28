package org.atomsoft.renderer
{
	import mx.collections.ArrayList;
	
	import spark.components.List;
	import spark.components.NavigatorContent;
	
	public class UserAccordionChild extends NavigatorContent
	{
		private var _userList:List = new List();
		
		public function UserAccordionChild(label:String,users:ArrayList)
		{
			this.label = label;
			_userList.dataProvider = users;			
			_userList.labelField = "localName";
			_userList.setStyle("width","100%");
			_userList.setStyle("height","100%");
			
			super();
		}
	}
}