package com.inchworm.media.video
{
	/**
	 * Internal state which governs the player's behavior as it is pausing
	 * @author Justin Gaussoin
	 * @author Rob Dodson
	 * 
	 */	
	public class PauseState implements IVideoState
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		private var _player				:VideoPlayer;
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * Internal state which governs the player's behvior as it is pausing 
		 * @param player: The parent VideoPlayer object
		 * 
		 */		
		public function PauseState(player:VideoPlayer)
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
			if(_player.stream) _player.stream.close();
			
			_player.state = _player.initState;
		}
		
		/**
		 * Resumes the stream and sends the player to its PlaySate. Also
		 * dispatches a resumed Signal from the player.
		 * 
		 */	
		public function play():void
		{
			trace(this + ' play()');
			
			_player.stream.resume();
			_player.state = _player.playState;
			_player.resumed.dispatch();
		}
	
		/**
		 * Seek's the stream back to the beginning, pauses it, and
		 * sends the player to its StopState 
		 * 
		 */		
		public function stop():void
		{
			_player.stream.seek(0);
			_player.state = _player.stopState;
			_player.stopped.dispatch();
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