package com.grinder.component;

import nme.geom.Rectangle;

class TileImage
{
	public var path:String;
	public var clip:Rectangle;

	public function new(path:String, clip:Rectangle)
	{
		this.path = path;
		this.clip = clip;
	}
}