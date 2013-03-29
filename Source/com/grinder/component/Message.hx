package com.grinder.component;

class Message
{
	public static inline var TEXT:String = "text";
	public static inline var HIDE:String = "hide";
	public static inline var SHOW:String = "show";
	public static inline var CLEAR:String = "clear";

	public var text:String;
	public var type:String;

	public function new(text:String, type:String = Message.TEXT)
	{
		this.text = text;
		this.type = type;
	}

	public static function hide(): Message
	{
		return new Message(null, HIDE);
	}

	public static function show(): Message
	{
		return new Message(null, SHOW);
	}

	public static function clear(): Message
	{
		return new Message(null, CLEAR);
	}
}