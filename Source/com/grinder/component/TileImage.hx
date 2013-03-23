package com.grinder.component;

import nme.geom.Rectangle;

class TileImage
{
	public var image:String;
	public var rect:Rectangle;

	public function new(image:String, rect:Rectangle)
	{
		this.image = image;
		this.rect = rect;
	}
}