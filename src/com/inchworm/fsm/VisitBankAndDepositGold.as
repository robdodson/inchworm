/**
 * Created by IntelliJ IDEA.
 * User: RobDodson
 * Date: 9/8/11
 * Time: 7:22 PM
 */
package com.inchworm.fsm
{
import com.inchworm.character.Miner;

public class VisitBankAndDepositGold extends BaseState
{
	//-----------------------------------------------------------------
	// State Machine Owner
	private var _owner					:Miner;
	
	//-----------------------------------------------------------------
	
	public function VisitBankAndDepositGold(owner:Miner)
	{
		_owner = owner;
	}

	override public function enter():void
	{
		if (_owner.locationType != "bank")
		{
			_owner.changeLocation("bank");
			trace("\nMiner" + _owner.ID + "\nGoin' to the bank.");
		}
	}

	override public function execute():void
	{
		_owner.addToWealth(_owner.goldCarried);
		_owner.goldCarried = 0;
		trace("\nMiner" + _owner.ID + "\nDepositing gold. Total savings now: " + _owner.moneyInBank);

		_owner.fsm.changeState(_owner.fsm.enterMineState);
	}

	override public function exit():void
	{
	}
}
}
