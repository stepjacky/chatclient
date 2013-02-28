package org.atomsoft.renderer
{
	import spark.components.Label;
	import spark.components.supportClasses.ItemRenderer;
	
	public class MyListItemRenderer extends ItemRenderer
	{
		
		private var _label:Label;
		public function MyListItemRenderer()
		{
			
			super();
            _label = new Label();
			_label.setStyle("fontSize",15);
			this.addChild(_label);
		}
		
		override public function set label(value:String):void
		{
			// TODO Auto Generated method stub
			super.label = value;
			
		}
		
		override public function set data(value:Object):void
		{
			// TODO Auto Generated method stub
			super.data = value;
			_label.text = value.localName;
			if(value.online=='y'){
				_label.setStyle("color",0x00ff00);
			}else{
				_label.setStyle("color",0xcccccc);
			}
		}
		
		
	}
}