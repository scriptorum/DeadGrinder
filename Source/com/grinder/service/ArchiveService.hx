package com.grinder.service;

import ash.core.Entity;

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
}

