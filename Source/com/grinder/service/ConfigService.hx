package com.grinder.service;

import com.grinder.component.TiledImage;
import com.grinder.component.GridSize;

class ConfigService
{
	private static var tiledImage:TiledImage;

	public static function getTiledImage()
	{
		if(tiledImage == null)
			tiledImage = new TiledImage("art/grimoire.png", new GridSize(32, 32), 8);
		return tiledImage;
	}
}

