package com.grinder.service;

import haxe.EnumFlags;
import com.scriptorum.Array2D;
import com.scriptorum.Util;
import com.grinder.render.Grimoire;
import com.grinder.component.Grid;

class MapGenerator
{
	public static inline var  NORTH:Int = 1 << 0;
	public static inline var   EAST:Int = 1 << 1;
	public static inline var  SOUTH:Int = 1 << 2;
	public static inline var   WEST:Int = 1 << 3;
	public static inline var  ENTRY:Int = 1 << 4;
	public static inline var   EXIT:Int = 1 << 5;

	public static inline var boardWidth:Int = 21;
	public static inline var boardHeight:Int = 21;
	public static inline var roadCrossing:Int = 3;
	public static inline var blockSize:Int = 9;
	public static inline var boardsAcross:Int = 6;
	public static inline var boardsDown:Int = 4;

	public var grid:Grid;

	public function new()
	{
		grid = new Grid(boardWidth * boardsAcross, boardHeight * boardsDown, [Grimoire.RUBBLE, Grimoire.RUBBLE2]);
	}

	public function generate(): Grid
	{
		// grid.setRect(2, 2, 7, 7, Grimoire.WALL);
		// grid.setRect(3, 3, 5, 5, Grimoire.FLOOR);

		// grid.set(5, 2, Grimoire.DOOR);
		// grid.set(5, 8, Grimoire.DOOR);
		// grid.set(2, 5, Grimoire.DOOR);
		// grid.set(8, 5, Grimoire.DOOR);

		var plan = createPlan(6, 4);
		for(y in 0...plan.height)
		for(x in 0...plan.width)
		{
			var board = plan.get(x, y);
			fillBoard(grid, x * boardWidth, y * boardHeight,
				board & NORTH > 0, board & EAST > 0, board & SOUTH > 0, board & WEST > 0, 
				board & ENTRY > 0, board & EXIT > 0);
		}

		return grid;
	}

	public function fillBoard(grid:Grid, xOff:Int, yOff:Int, north:Bool, east:Bool, south:Bool, west:Bool, 
		entry:Bool, exit:Bool): Void
	{
		var sides = (north ? 1 : 0) + (east ? 1 : 0) + (south ? 1 : 0) + (west ? 1 : 0);
		if(sides == 0)
		{
			grid.setRect(xOff, yOff, boardWidth, boardHeight, Grimoire.LAVA);
			return;
		}

		// Central road
		grid.setRect(xOff + blockSize, yOff + blockSize, roadCrossing, roadCrossing, Grimoire.ASPHALT);

		// Side roads
		if(north)
			grid.setRect(xOff + blockSize, yOff, roadCrossing, blockSize, Grimoire.ASPHALT);
		if(south)
			grid.setRect(xOff + blockSize, yOff + blockSize + roadCrossing, roadCrossing, blockSize, Grimoire.ASPHALT);
		if(west)
			grid.setRect(xOff, yOff + blockSize, blockSize, roadCrossing, Grimoire.ASPHALT);
		if(east)
			grid.setRect(xOff + blockSize + roadCrossing, yOff + blockSize, blockSize, roadCrossing, Grimoire.ASPHALT);

		// Buildings next....Sam
	}

	// Return the orientation of board i2 to board i1
	// Assumes adjacency
	public function orientation(plan:Array2D<Dynamic>, i1:Int, i2:Int): Int
	{
		switch(i2 - i1)
		{
			case 1: return EAST;
			case -1: return WEST;
			case plan.width: return SOUTH;
			case -plan.width: return NORTH;
		}
		throw ("Points " + i1 + " and " + i2 + " are not adjacent");
	}

	// The plan is the high level view of the map. The map consists of a number of boards 
	// arranged into a rectangle. This sets up a reasonable road pattern and determines
	// which boards should be used for entry and exit manholes.
	//
	// TODO This may be creating too many cul-de-sacs. Although I supposed its fine 
	// to have special contents on cul-de-sac boards, and I could also add some buildings
	// you can get on top off, alleyways, or additional manholes that lead to separate
	// branches or different spots on the same map.
	public function createPlan(boardsAcross:Int, boardsDown:Int): Array2D<Int>
	{
		// Create a plan
		var plan = new Array2D<Int>(boardsAcross, boardsDown, 0);

		// Create a list of all board indeces
		var picks = new Array<Int>();
		for(i in 0...plan.size)
			picks.push(i);

		// Choose a starter board
		var pick:Int = Std.random(plan.size); // choose board
		picks.remove(pick); // Remove board from picks
		plan.setIndex(pick, ENTRY); // Add entry point manhole

		while(picks.length > 0)
		{
			// Pick the next board: an unprocessed board that is adjacent to a processed board
			var candidates = Lambda.filter(picks, function(pick:Int) { 
				var neighbors = plan.getNeighboringIndeces(pick, true);
				return Lambda.exists(neighbors, function(neighbor:Int) {
					return !Lambda.has(picks, neighbor);
				});
			});
			pick = Util.anyOneOf(Lambda.array(candidates));

			// Pick a processed board that is adjacent to the pick (the connector)
			var neighbors = plan.getNeighboringIndeces(pick, true);
			candidates = Lambda.filter(neighbors, function(neighbor:Int) {
				return !Lambda.has(picks, neighbor);
			});
			var connector = Util.anyOneOf(Lambda.array(candidates));

			// Connect the current board with the connector board
			plan.setIndex(pick, plan.getIndex(pick) | orientation(plan, pick, connector));
			plan.setIndex(connector, plan.getIndex(connector) | orientation(plan, connector, pick));

			// Remove new pick from the unprocessed board list.
			picks.remove(pick);
		}

		// Add exit manhole
		plan.setIndex(pick, plan.getIndex(pick) | EXIT);

		debugPrintPlan(plan);

		return plan;
	}

	private function debugPrintPlan(plan:Array2D<Int>)
	{
		// Debug print plan
		for(y in 0...plan.height)
		{
			var str = "";
			for(x in 0...plan.width)
				str += "/" + (plan.get(x,y) & NORTH > 0 ? "#" : "-") + "\\";
			trace(str);

			str = "";
			for(x in 0...plan.width)
			{
				var ctr = (plan.get(x,y) & ENTRY > 0 ? "1" : (plan.get(x,y) & EXIT > 0 ? "2" : "#"));
				str += (plan.get(x,y) & WEST > 0 ? "#" : "|") + ctr + (plan.get(x,y) & EAST > 0 ? "#" : "|");
			}
			trace(str);

			str = "";
			for(x in 0...plan.width)
				str += "\\" + (plan.get(x,y) & SOUTH > 0 ? "#" : "-") + "/";
			trace(str);
		}		
	}
}
