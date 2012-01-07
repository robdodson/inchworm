/**
 * Created by IntelliJ IDEA.
 * User: RobDodson
 * Date: 9/8/11
 * Time: 6:38 PM
 * To change this template use File | Settings | File Templates.
 */
package com.inchworm.character
{
import com.inchworm.fsm.EnterMineAndDigForNugget;
import com.inchworm.fsm.MinerFSM;
import com.inchworm.fsm.StateMachine;
import com.inchworm.game.*;

import flash.geom.Point;

public class Miner extends BaseGameEntity
{
	//--------------------------------------------
	private var _fsm					:MinerFSM;
	private var _locationType			:String;
	private var _goldCarried			:int;
	private var _maxGold				:int = 5;
	private var _moneyInBank			:int;
	private var _thirst					:int;
	private var _maxThirst				:int = 4;
	private var _fatigue                :int;
	private var _maxFatigue				:int = 6;

	//--------------------------------------------

	public function Miner()
	{
		super(new Point(0,0), 1.0);

		_locationType = "shack";
		_goldCarried = 0;
		_moneyInBank = 0;
		_thirst = 0;
		_fatigue = 0;

		_fsm = new MinerFSM(this);
		_fsm.setCurrentState(_fsm.enterMineState);
	}

	override public function update():void
	{
		_thirst += 1;
		_fsm.update();
	}

	public function changeLocation(location:String):void
	{
		_locationType = location;
	}

	public function get locationType():String
	{
		return _locationType;
	}

	public function get goldCarried():int
	{
		return _goldCarried;
	}

	public function get moneyInBank():int
	{
		return _moneyInBank;
	}

	public function get thirst():int
	{
		return _thirst;
	}

	public function get fatigue():int
	{
		return _fatigue;
	}

	public function addToGoldCarried(value:int):void
	{
		_goldCarried += value;
	}

	public function increaseFatigue():void
	{
		_fatigue++;
	}

	public function pocketsFull():Boolean
	{
		return (_goldCarried >= _maxGold);
	}

	public function thirsty():Boolean
	{
		return (_thirst >= _maxThirst);
	}

	public function get fsm():MinerFSM
	{
		return _fsm;
	}

	public function buyAndDrinkWhiskey():void
	{
		_thirst = 0;
	}

	public function fatigued():Boolean
	{
		return (_fatigue >= _maxFatigue);
	}

	public function decreaseFatigue():void
	{
		_fatigue--;
	}

	public function set goldCarried(goldCarried:int):void
	{
		_goldCarried = goldCarried;
	}

	public function addToWealth(value:int):void
	{
		_moneyInBank += value;
	}
}
}
