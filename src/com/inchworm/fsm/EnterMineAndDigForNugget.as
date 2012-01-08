/**
 * Created by IntelliJ IDEA.
 * User: RobDodson
 * Date: 9/8/11
 * Time: 7:03 PM
 * To change this template use File | Settings | File Templates.
 */
package com.inchworm.fsm
{
import com.inchworm.character.Miner;

public class EnterMineAndDigForNugget extends BaseState
{
	//-----------------------------------------------------------------
	private var _owner					:Miner;
	
	//-----------------------------------------------------------------
	
	public function EnterMineAndDigForNugget(owner:Miner)
	{
		_owner = owner;
	}

	override public function enter():void
	{
		if (_owner.locationType != "goldmine")
		{
			trace("\nMiner" + _owner.ID + "\nWalkin' to the gold mine");
			_owner.changeLocation("goldmine");
		}
	}

	override public function execute():void
	{
		// The miner digs for gold until he's carrying in excess
		// of the maxNuggets. If he gets thirsty during his digging he
		// stops work and goes to the saloon for a whiskey.
		_owner.addToGoldCarried(1);

		// diggin' is hard work
		_owner.increaseFatigue();

		trace("\nMiner" + _owner.ID + "\nPickin' up a nugget");

		// if enough gold has been mined, then take it to the bank
		if (_owner.pocketsFull())
		{
			_owner.fsm.changeState(_owner.fsm.visitBankState);
		}
	}

	override public function exit():void
	{
		trace("\nMiner" + _owner.ID + "\nAh'm leavin' the goldmine with mah pockets full o' sweet gold");
	}
}
}
