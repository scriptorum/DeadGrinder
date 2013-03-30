package com.grinder.component;

class Spawn
{
	public var type:String;
	public var parameters:Dynamic;

	public function new(type:String, parameters:Dynamic = null)
	{
		this.type = type;
		this.parameters = parameters;
	}
}