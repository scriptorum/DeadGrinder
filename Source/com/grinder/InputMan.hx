package com.grinder;

import com.haxepunk.HXP;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import nme.events.MouseEvent;

class InputMan
{
	public static inline var NW:String = "northwest";
	public static inline var NE:String = "northeast";
	public static inline var SW:String = "southwest";
	public static inline var SE:String = "southeast";
	public static inline var N:String = "north";
	public static inline var S:String = "south";
	public static inline var E:String = "east";
	public static inline var W:String = "west";
	public static inline var WAIT:String = "wait";
	public static inline var SELECT:String = "select";
	public static inline var ACTION:String = "action";
	public static inline var ABORT:String = "escape";
	public static inline var DEBUG:String = "debug";

	public static function init()
	{
		Input.define(N, [Key.UP, Key.DIGIT_8, Key.NUMPAD_8]);
		Input.define(S, [Key.DOWN, Key.DIGIT_2, Key.NUMPAD_2]);
		Input.define(W, [Key.LEFT, Key.DIGIT_4, Key.NUMPAD_4]);
		Input.define(E, [Key.RIGHT, Key.DIGIT_6, Key.NUMPAD_6]);
		Input.define(NE, [Key.DIGIT_9, Key.NUMPAD_9]);
		Input.define(NW, [Key.DIGIT_7, Key.NUMPAD_7]);
		Input.define(SE, [Key.DIGIT_3, Key.NUMPAD_3]);
		Input.define(SW, [Key.DIGIT_1, Key.NUMPAD_1]);
		Input.define(WAIT, [".".charCodeAt(0), Key.NUMPAD_DECIMAL, Key.ENTER]);
		Input.define(ACTION, [Key.SPACE, Key.DIGIT_5, Key.NUMPAD_5]);
		Input.define(ABORT, [Key.ESCAPE]);
		Input.define(DEBUG, [Key.TAB]);
	}

	public static function onRightClick(cb:Dynamic->Void)
	{
		HXP.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, cb);
	}

	public static function onRightClickRemove(cb:Dynamic->Void)
	{
		HXP.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, cb);
	}

	// Convenience methods
	public static var mouseX(getMouseX, null):Int;
	private static function getMouseX():Int { return Input.mouseX; }
	public static var mouseY(getMouseY, null):Int;
	private static function getMouseY():Int { return Input.mouseY; }
	public static var clicked(getClicked, null):Bool;
	private static function getClicked():Bool { return Input.mouseReleased; }

	public static function check(input:Dynamic):Bool { return Input.check(input); }
	public static function pressed(input:Dynamic):Bool { return Input.pressed(input); }
	public static function released(input:Dynamic):Bool { return Input.released(input); }
}