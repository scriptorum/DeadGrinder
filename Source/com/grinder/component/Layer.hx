package com.grinder.component;

class Layer
{
	public static var MAP:Int = 60;
	public static var BELOW:Int = 50;
	public static var PLAYER:Int = 40;
	public static var ABOVE:Int = 30;
	public static var HUD:Int = 20;
	public static var POPUP:Int = 10;
	public var layer:Int;

	public function new(layer:Int)
	{
		this.layer = layer;
	}
}