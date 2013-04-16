package com.grinder.service;

import com.grinder.service.MapGenerator;
import com.grinder.component.Grid;

typedef MG = MapGenerator;

class DemoMapGenerator extends MapGenerator
{
	public function new()
	{
		super(11, 11, MG.ASPHALT);
	}

	override public function generate(): Grid
	{
		grid.setRect(2, 2, 7, 7, MG.WALL);
		grid.setRect(3, 3, 5, 5, MG.FLOOR);

		grid.set(5, 2, MG.DOOR);
		grid.set(5, 8, MG.DOOR);
		grid.set(2, 5, MG.DOOR);
		grid.set(8, 5, MG.DOOR);

		return grid;
	}
}
