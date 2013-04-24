package com.grinder.component;

import com.grinder.component.TiledImage;

class Animation
{
	public var frames:Array<Int>;
	public var speed:Float;
	public var looping:Bool;
	public var tiledImage:TiledImage;

	public function new(tiledImage:TiledImage, frames:Array<Int>, speed:Float, looping:Bool)
	{
		this.frames = frames;
		this.speed = speed;
		this.looping = looping;
		this.tiledImage = tiledImage;	
	}
}
