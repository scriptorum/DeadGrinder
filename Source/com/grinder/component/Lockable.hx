package com.grinder.component;

class Lockable implements Actionable
{
	public var description:String;
	
	public function new()
	{
		description = "Unlock";
	}
}