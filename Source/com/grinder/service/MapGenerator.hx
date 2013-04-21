package com.grinder.service;

import haxe.EnumFlags;
import com.scriptorum.Array2D;
import com.scriptorum.Point;
import com.scriptorum.Util;
import com.grinder.render.Grimoire;
import com.grinder.component.Grid;

private enum Direction {north; east; south; west; }
private enum Orientation {vertical; horizontal; }

class BoardBlock 
{
	public var door:Direction; 
	public var street:Orientation; //orientation of street if street
	public var floor:Bool; // true = street

	public function new(door:Direction, street:Orientation, floor:Bool)
	{
		this.door = door;
		this.street = street;
		this.floor = floor;
	}
}

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
	public static inline var roomsAcross:Int = 5;
	public static inline var roomsDown:Int = 5;

	public var grid:Grid;

	public function new()
	{
		grid = new Grid(boardWidth * boardsAcross, boardHeight * boardsDown, Grimoire.ASPHALT);
	}

	public function generate(): Grid
	{
		var plan = createPlan(boardsAcross, boardsDown);
		for(y in 0...plan.height)
		for(x in 0...plan.width)
		{
			var board = plan.get(x, y);
			if(board & ENTRY > 0) trace("Entry at " + x + "," + y);
			fillBoard(grid, x * boardWidth, y * boardHeight,
				board & NORTH > 0, board & EAST > 0, board & SOUTH > 0, board & WEST > 0, 
				board & ENTRY > 0, board & EXIT > 0);
		}

		grid.changed = true;
		return grid;
	}

	public function fillBoard(grid:Grid, xOff:Int, yOff:Int, north:Bool, east:Bool, south:Bool, west:Bool, 
		entry:Bool, exit:Bool): Void
	{
		if(entry) trace("Entry found");

		var sides = (north ? 1 : 0) + (east ? 1 : 0) + (south ? 1 : 0) + (west ? 1 : 0);
		if(sides == 0)
		{
			grid.setRect(xOff, yOff, boardWidth, boardHeight, Grimoire.ASPHALT);
			return;
		}

		// Split board into 25 "blocks"
		var blockPlan = createBoardBlocks(north, east, south, west);

		// Lay out floors, streets, and walls
		for(i in 0...blockPlan.size)
		{
			var plan = blockPlan.getIndex(i);
			var pt = blockPlan.fromIndex(i);
			var roomOffset = new Point(xOff + pt.x * 4, yOff + pt.y * 4);

			// Building room
			if(plan.floor)
			{
				grid.setRect(roomOffset.x, roomOffset.y, 5, 5, Grimoire.WALL);
				grid.setRect(roomOffset.x + 1, roomOffset.y + 1, 3, 3, Grimoire.FLOOR);
			}

			// Street
			else
			{
				grid.setRect(roomOffset.x + 1, roomOffset.y + 1, 3, 3, Grimoire.ASPHALT);
			}
		}

		// Lay out doors and manholes
		for(i in 0...blockPlan.size)
		{
			var plan = blockPlan.getIndex(i);
			var pt = blockPlan.fromIndex(i);
			var roomOffset = new Point(xOff + pt.x * 4, yOff + pt.y * 4);
			if(plan.door == null)
			 	continue;
			switch(plan.door)
			{
				case Direction.north: roomOffset.add(2,0);
				case Direction.south: roomOffset.add(2,4);
				case Direction.east:  roomOffset.add(4,2);
				case Direction.west:  roomOffset.add(0,2);
			}

			if(plan.door != null)
				grid.set(roomOffset.x, roomOffset.y, Grimoire.DOOR);
		}

		if(entry)
		{
			var spawnBlock = Std.random(blockPlan.size);
			var pt = blockPlan.fromIndex(spawnBlock);
			var pos = new Point(xOff + pt.x * 4 + 2, yOff + pt.y * 4 + 2);
			var spawner = (grid.get(pos.x, pos.y) == Grimoire.FLOOR ? Grimoire.SPAWN_FLOOR : Grimoire.SPAWN_STREET);
			grid.set(pos.x, pos.y, spawner);
			trace("Adding entry spawn block to " + pos.x + "," + pos.y + " at block " + spawnBlock + " with spawner " + spawner); 
		}
	}

	public function createBoardBlocks(north:Bool, east:Bool, south:Bool, west:Bool): Array2D<BoardBlock>
	{
		var blockPlan = new Array2D<BoardBlock>(roomsAcross, roomsDown, null);

		// Handle roads		
		var roadExitCount = 0;
		if(north)
		{
			blockPlan.set(2, 0, new BoardBlock(null, Orientation.vertical, false));
			blockPlan.set(2, 1, new BoardBlock(null, Orientation.vertical, false));
			roadExitCount++;
		}
		if(south)
		{
			blockPlan.set(2, 3, new BoardBlock(null, Orientation.vertical, false));
			blockPlan.set(2, 4, new BoardBlock(null, Orientation.vertical, false));
			roadExitCount++;
		}
		if(east)
		{
			blockPlan.set(3, 2, new BoardBlock(null, Orientation.horizontal, false));
			blockPlan.set(4, 2, new BoardBlock(null, Orientation.horizontal, false));
			roadExitCount++;
		}
		if(west)
		{
			blockPlan.set(0, 2, new BoardBlock(null, Orientation.horizontal, false));
			blockPlan.set(1, 2, new BoardBlock(null, Orientation.horizontal, false));
			roadExitCount++;
		}
		if(roadExitCount > 0)
			blockPlan.set(2,2, new BoardBlock(null, null, false));

		// Add rooms with arbitrary doors
		for(num in 0...blockPlan.size)
			if(blockPlan.getIndex(num) == null)
			{
				switch(num)
				{
					case 10,15,17,18,21: 
						blockPlan.setIndex(num, new BoardBlock(Direction.north, null, true));
					case 3,6,7,9,12,14: 
						blockPlan.setIndex(num, new BoardBlock(Direction.south, null, true));
					case 0,1,2,5,11,16,20: 
						blockPlan.setIndex(num, new BoardBlock(Direction.east, null, true));
					case 4,8,13,19,22,23,24: 
						blockPlan.setIndex(num, new BoardBlock(Direction.west, null, true));
				};				
			}

		return blockPlan;
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
