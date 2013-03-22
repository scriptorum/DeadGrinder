package com.scriptorum;

import com.haxepunk.HXP;

class Util
{
	public static function shuffle<T>(arr:Array<T>): Void
	{
        var i:Int = arr.length, j:Int, t:T;
        while (--i > 0)
        {
                t = arr[i];
                arr[i] = arr[j = rnd(0, i-1)];
                arr[j] = t;
        }
	}

	public static function anyOneOf<T>(arr:Array<T>): T
	{
		if(arr == null || arr.length == 0)
			return null;
		return arr[rnd(0, arr.length - 1)];
	}

	public static function rnd(min:Int,max:Int):Int
	{
		return Math.floor(Math.random() * (max - min + 1)) + min;
	}	

	public static function sign(v:Float): Int
	{
		if(v < 0.0)
			return -1;
		if(v > 0.0)
			return 1;
		return 0;
	}

    public static function assert( cond : Bool, ?pos : haxe.PosInfos )
    {
      if(!cond)
          haxe.Log.trace("Assert in " + pos.className + "::" + pos.methodName, pos);
    }

    // Same as String.split but empty strings result in an empty array
    public static function split(str:String, delim:String): Array<String>
    {
    	var arr = new Array<String>();
    	if(str == null || str.length == 0)
    		return arr;
    	return str.split(delim);
    }
}