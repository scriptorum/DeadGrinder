package com.grinder.service;

import com.grinder.render.Grimoire;
import com.grinder.component.Grid;

class DemoMapGenerator
{
	public var grid:Grid;

	public function new()
	{
		grid = new Grid(11, 11, Grimoire.ASPHALT);
	}

	public function generate(): Grid
	{
		grid.setRect(2, 2, 7, 7, Grimoire.WALL);
		grid.setRect(3, 3, 5, 5, Grimoire.FLOOR);

		grid.set(5, 2, Grimoire.DOOR);
		grid.set(5, 8, Grimoire.DOOR);
		grid.set(2, 5, Grimoire.DOOR);
		grid.set(8, 5, Grimoire.DOOR);

		grid.changed = true;
		return grid;
	}
}
