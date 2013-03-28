package com.grinder.component;

import ash.fsm.EntityStateMachine;

class State
{
	public var current:String;
	public var next:String;
	public var fsm:EntityStateMachine;	

	public function new(fsm:EntityStateMachine, current:String = "init", next:String = null)
	{
		this.fsm = fsm;
		this.current = current;
		this.next = next;
	}
}