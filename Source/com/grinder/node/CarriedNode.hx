package com.grinder.node;

import ash.core.Node;

import com.grinder.component.Carriable;
import com.grinder.component.Carried;
import com.grinder.component.Name;

class CarriedNode extends Node<CarriedNode>
{
	public var carriable:Carriable;
	public var carried:Carried;
	public var name:Name;
}