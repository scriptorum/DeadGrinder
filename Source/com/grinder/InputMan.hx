package com.grinder;

import com.haxepunk.HXP;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import nme.events.MouseEvent;

class InputMan
{
	public static inline var MOVE_NW:String = "northwest";
	public static inline var MOVE_NE:String = "northeast";
	public static inline var MOVE_SW:String = "southwest";
	public static inline var MOVE_SE:String = "southeast";
	public static inline var MOVE_N:String = "north";
	public static inline var MOVE_S:String = "south";
	public static inline var MOVE_E:String = "east";
	public static inline var MOVE_W:String = "west";
	public static inline var WAIT:String = "wait";
	public static inline var SELECT:String = "select";
	public static inline var ACTION:String = "action";
	public static inline var ABORT:String = "escape";
	public static inline var DEBUG:String = "debug";
	public static inline var OPEN:String = "open";
	public static inline var CLOSE:String = "close";
	public static inline var LOCK:String = "lock";
	public static inline var UNLOCK:String = "unlock";

	public static inline var altKeyCodes:Bool = true;
	public static inline var NumPad0:Int = altKeyCodes ? 48 : Key.NUMPAD_0;
	public static inline var NumPad1:Int = altKeyCodes ? 49 : Key.NUMPAD_1;
	public static inline var NumPad2:Int = altKeyCodes ? 50 : Key.NUMPAD_2;
	public static inline var NumPad3:Int = altKeyCodes ? 51 : Key.NUMPAD_3;
	public static inline var NumPad4:Int = altKeyCodes ? 52 : Key.NUMPAD_4;
	public static inline var NumPad5:Int = altKeyCodes ? 53 : Key.NUMPAD_5;
	public static inline var NumPad6:Int = altKeyCodes ? 54 : Key.NUMPAD_6;
	public static inline var NumPad7:Int = altKeyCodes ? 55 : Key.NUMPAD_7;
	public static inline var NumPad8:Int = altKeyCodes ? 56 : Key.NUMPAD_8;
	public static inline var NumPad9:Int = altKeyCodes ? 57 : Key.NUMPAD_9;
	public static inline var NumPadDECIMAL:Int = Key.NUMPAD_DECIMAL;

	public static function init()
	{
		Input.define(MOVE_N, [Key.UP, Key.DIGIT_8, NumPad8]);
		Input.define(MOVE_S, [Key.DOWN, Key.DIGIT_2, NumPad2]);
		Input.define(MOVE_W, [Key.LEFT, Key.DIGIT_4, NumPad4]);
		Input.define(MOVE_E, [Key.RIGHT, Key.DIGIT_6, NumPad6]);
		Input.define(MOVE_NE, [Key.DIGIT_9, NumPad9]);
		Input.define(MOVE_NW, [Key.DIGIT_7, NumPad7]);
		Input.define(MOVE_SE, [Key.DIGIT_3, NumPad3]);
		Input.define(MOVE_SW, [Key.DIGIT_1, NumPad1]);
		Input.define(WAIT, [".".charCodeAt(0), NumPadDECIMAL, Key.ENTER]);
		Input.define(ACTION, [Key.SPACE, Key.DIGIT_5, NumPad5]);
		Input.define(ABORT, [Key.ESCAPE]);
		Input.define(DEBUG, [Key.TAB]);
		Input.define(OPEN, [Key.O]);
		Input.define(CLOSE, [Key.C]);
		Input.define(LOCK, [Key.L]);
		Input.define(UNLOCK, [Key.U]);
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