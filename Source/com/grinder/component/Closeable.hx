package com.grinder.component;

import com.grinder.component.Action;

class Closeable implements Actionable
{
	public var type:String = Action.CLOSE;
	
	public function new()
	{
	}
}