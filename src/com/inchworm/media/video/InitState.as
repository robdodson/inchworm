package com.inchworm.media.video
{
	/**
	 * Internal state which governs the player's behvior as it is initializing
	 * @author Justin Gaussoin
	 * @author Rob Dodson
	 * 
	 */	
	public class InitState implements IVideoState
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		private var _player				:VideoPlayer;
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * Internal state which governs the player's behvior as it is initializing 
		 * @param player: The parent VideoPlayer object
		 * 
		 */		
		public function InitState(player:VideoPlayer)
		{
			this._player = player;
		}
	
		/**
		 * Empty function call which just verifies that the current
		 * state is the InitState 
		 * 
		 */		
		public function init():void
		{
			trace(this + ' init()');
		}
	
		/**
		 * Tells the stream to start playing and sends the player to
		 * its PlayState
		 * 
		 */		
		public function play():void
		{
			trace(this + ' play()');
			
			// Make sure the netstream exists before we attemp to play it
			if(!this._player.stream)
			{
				throw new Error("VideoPlayer Error: NetStream Not Found");
				return;
			}
			
			_player.stream.play(_player.source);
			_player.state = this._player.playState;
			_player.started.dispatch();
		}
		
		/**
		 * @private
		 * 
		 */		
		public function stop():void
		{
			trace(this + ' stop()');
		}
		
		/**
		 * @private
		 * 
		 */		
		public function pause():void
		{
			trace(this + ' pause()');
		}
		
		/**
		 * @private
		 * 
		 */		
		public function buffer():void
		{
			trace(this + ' buffer()');
		}
	}
}