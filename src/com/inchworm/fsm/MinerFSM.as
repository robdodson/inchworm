package com.inchworm.fsm
{
	import com.inchworm.character.Miner;

	public class MinerFSM extends StateMachine
	{
		//-----------------------------------------------------------------
		// States
		public var enterMineState					:IState;
		public var visitBankState					:IState;
		
		//-----------------------------------------------------------------
		
		public function MinerFSM(owner:*)
		{
			super(owner);
			
			enterMineState = new EnterMineAndDigForNugget(owner as Miner);
			visitBankState = new VisitBankAndDepositGold(owner as Miner);
		}
	}
}