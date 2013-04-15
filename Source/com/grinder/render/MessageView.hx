package com.grinder.render;

import com.haxepunk.graphics.Graphiclist;
import com.grinder.render.FancyText;
import com.grinder.component.Position;
import com.grinder.component.Message;

class MessageView extends View
{
	private var queue:Array<String>;
	public var fontSize:Int = 18;
	public var lineOffset:Int = 14;
	public var maxQueueSize:Int = 4;
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;

	override public function begin()
	{
		clearQueue();
	}

	override public function nodeUpdate()
	{
		var position = getComponent(Position);
		offsetX = position.x;
		offsetY = position.y;
	}

	public function clearQueue()
	{
		graphic = null;
		queue = new Array<String>();
	}

	public function updateTexts()
	{
		if(queue.length > maxQueueSize)
			queue.pop();

		var list = new Graphiclist();
		for(i in 0...queue.length)
		{
			var size = (i == 0 ? fontSize : fontSize - 4);
			var view = new FancyText(queue[i], 
				(i == 0 ? 0x18ED00 : 0x11A800), size, 
				offsetX, offsetY + i * lineOffset + (i > 0 ? 4 : 0), 0, 
				"font/vademecu.ttf");
			view.setAlpha(i == 0 ? 1 : .65);
			list.add(view);
		}
		graphic = list; 
	}

	public function addMessage(message:Message)
	{
		switch(message.type)
		{
			case Message.TEXT:
				queue.unshift(message.text);
				updateTexts();

			case Message.SHOW:
				visible = true;

			case Message.HIDE:
				visible = false;

			case Message.CLEAR:			
				clearQueue();
		}
	}
}