package com.inchworm.media.video
{
	/**
	 * Interal state which governs the Player's behavior as it is stopping
	 * @author Justin Gaussoin
	 * @author Rob Dodson
	 * 
	 */	
	public class StopState implements IVideoState
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		private var _player				:VideoPlayer;
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * Interal state which governs the Player's behavior as it is stopping 
		 * @param player: The parent VideoPlayer object
		 * 
		 */		
		public function StopState(player:VideoPlayer)
		{
			_player = player;
		}
	
		/**
		 * Clears the Video and NetStream and returns the player to
		 * its InitState
		 * 
		 */		
		public function init():void
		{
			trace(this + ' init()');
			
			_player.video.clear();
			_player.video.attachNetStream(null);
			//if(_player.stream) _player.stream.close();
			
			this._player.state = this._player.initState;
		}
	
		/**
		 * Resumes the stream and sends the player to its PlaySate. Also
		 * dispatches a started Signal from the player.
		 * 
		 */		
		public function play():void
		{
			trace(this + ' play()');
			
			this._player.stream.resume();
			this._player.state = this._player.playState;
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