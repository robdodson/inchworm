package com.inchworm.fsm
{
	import com.inchworm.character.Miner;
	
	public interface IState
	{
		function enter():void;
		function execute():void;
		function exit():void;
	}
}
