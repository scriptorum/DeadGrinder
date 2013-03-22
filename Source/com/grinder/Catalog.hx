package com.grinder;

import nme.Assets;
import haxe.xml.Fast;

class Catalog
{
	private static inline var catalogFilename:String = "dat/catalog.xml";
	private static var instance:Catalog;

	private var data:Hash<CatalogObject>;

	public function new()
	{
		var str = Assets.getText(catalogFilename);
		var xml = new Fast(Xml.parse(str).firstElement());
		data = new Hash<CatalogObject>();

		for(obj in xml.nodes.object)
			data.set(obj.att.id, new CatalogObject(obj));
	}

	public function getObject(id:Dynamic): CatalogObject
	{		
		var lookup:String = Std.is(id,String) ? id : Std.string(id);	
		// trace("Looking up object with id " + lookup + "; data is " + (data == null ? "null" : "available"));
		return data.get(lookup);
	}

	public static function getInstance(): Catalog
	{
		if(instance == null)
			instance = new Catalog();

		return instance;
	}
}

class CatalogObject
{
	public static inline var DEFAULT_STATE:String = "default";
	public static inline var DEFAULT_BEHAVIOR:String = null;
	public static inline var DEFAULT_DESC:String = "It is nondescript.";

	public var id:String;
	public var name:String;
	public var states:Hash<CatalogObjectState>;
	public var defaultStateStr:String = DEFAULT_STATE;

	public function new(data:Fast)
	{
		id = data.att.id;
		name = data.att.id;
		states = new Hash<CatalogObjectState>();

		var defaultState:CatalogObjectState;
		if(data.hasNode.state)
		{
			for(xml in data.nodes.state)
			{
				var state = new CatalogObjectState(
					xml.node.tile.innerData, 
					xml.hasNode.desc ? xml.node.desc.innerData : DEFAULT_DESC,
					xml.hasNode.behavior ? xml.node.behavior.innerData : DEFAULT_BEHAVIOR);
				states.set(xml.att.id, state);
			}
			if(data.has.state)
				defaultStateStr = data.att.state;
			defaultState = states.get(defaultStateStr);
		}		
		else defaultState = new CatalogObjectState(
			data.att.tile, 
			data.has.desc ? data.att.desc : DEFAULT_DESC,
			data.has.behavior ? data.att.behavior : DEFAULT_BEHAVIOR);

		states.set(DEFAULT_STATE, defaultState);
	}

	public function getState(?state:String = DEFAULT_STATE): CatalogObjectState
	{
		return states.get(state);
	}

	public function getDefaultState(): CatalogObjectState
	{
		return getState();
	}

	public function getDefaultStateStr(): String
	{
		return defaultStateStr;
	}
}

// Refit so an object/object-state can be assigned multiple behaviors

class CatalogObjectState
{
	public var tile:Int;
	public var desc:String;
	public var behavior:String;	

	public function new(tile:Dynamic, desc:String, behavior:String)
	{
		this.tile = Std.is(tile, Int) ? tile : Std.parseInt(tile);
		this.desc = desc;
		this.behavior = behavior;
	}
}


