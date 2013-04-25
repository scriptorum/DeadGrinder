package com.grinder.service;

import ash.core.Entity;
import com.scriptorum.Util;

class ArchiveService
{
	public static function serializeEntity(e:Entity): String
	{
		haxe.Serializer.USE_CACHE = true;

		var result = "";
		var cSep ="";
		for(c in e.getAll())
		{
			var name = Type.getClassName(Type.getClass(c));
			name = StringTools.replace(name, "com.grinder.component.", "");
			result += cSep + name + "(";
			var fSep = "";
			// for(f in Reflect.fields(c))
			for(f in Type.getClassFields(c))
			{
				if(f == "fsm")
					continue;

				// result += fSep + f + ":" + haxe.Serializer.run(c[f]);
				result += fSep + f + ":" + Reflect.field(c, f);
				// result += fSep + f + ":" + Reflect.field(c, f);
				// result += fSep + f + ":" + Reflect.getProperty(c, f);
				fSep = " ";
			}
			result += ")";
			cSep = " ";
		}
		return result;
	}

	public static function dump(o:Dynamic, depth:Int = 1, preventRecursion = true): String
	{
		var recursed = (preventRecursion == false ? null : new Array<Dynamic>());
		return internalDump(o, recursed, depth);
	}

	public static function internalDump(o:Dynamic, recursed:Array<Dynamic>, depth:Int): String
	{
		if (o == null)
			return "<null>";

		if(Std.is(o, Int) || Std.is(o, Float) || Std.is(o, Bool) || Std.is(o, String))
			return Std.string(o);

		if(recursed != null && Util.find(recursed, o) != -1)
		 	return "<recursion>";

		var clazz = Type.getClass(o);
		if(clazz == null)
			return "<" + Std.string(Type.typeof(o)) + ">";
		
		if(recursed != null)
			recursed.push(o);

		if(depth == 0)
			return "<limit>";

		var result = Type.getClassName(clazz) + ":{";
		var sep = "";

		for(f in Reflect.fields(o))
		{
			result += sep + f + ":" + internalDump(Reflect.field(o, f), recursed, depth - 1);
			sep = ", ";
		}
		return result + "}";
	}
}

