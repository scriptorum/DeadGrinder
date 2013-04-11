package com.grinder.service;

import com.grinder.component.TiledImage;
import com.grinder.component.GridSize;

class ConfigService
{
	private static var tiledImage:TiledImage;
	private static var turn:Int = 0;

	public static function getTiledImage()
	{
		if(tiledImage == null)
			tiledImage = new TiledImage("art/grimoire.png", new GridSize(32, 32), 8);
		return tiledImage;
	}

	// This stuff should probably be moved to a TurnService
	public static function advanceTurn(): Int
	{
		return turn++;
	}

	public static function getTurn(): Int
	{
		return turn;
	}
}

