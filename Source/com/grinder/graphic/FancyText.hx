package com.grinder.graphic;

import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Graphiclist;

class FancyText extends Graphiclist
{
	private var texts:Array<Text>;

	public function new(str:String, color:Int, size:Int, x:Float, y:Float)
	{
		super();
		texts = new Array<Text>();

		texts.push(makeText(str, 0x000000, size, x + 2, y + 2));
		texts.push(makeText(str, color, size, x, y));

		for(t in texts)
			add(t);
	}

	public function setString(str:String): Void
	{
		for(t in texts)
			t.text = str;
	}

	private function makeText(str:String, color:Int, size:Int, x:Float, y:Float): Text
	{
		var options = { color:color, font:"fnt/arial-rounded.ttf", size:size, resizable:true };
		var t = new Text(str, x, y, 0, 0, options);
		t.scrollX = t.scrollY = 0;
		add(t);
		return t;
	}
}