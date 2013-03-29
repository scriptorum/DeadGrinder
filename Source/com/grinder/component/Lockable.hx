package com.grinder.component;

import com.grinder.component.Action;

class Lockable implements Actionable
{
	public var type:String = Action.LOCK;
	
	public function new()
	{
	}
}