package com.inchworm.media.video
{
	/**
	 * Interal state which governs the Player's behavior as it is playing
	 * @author Justin Gaussoin
	 * @author Rob Dodson
	 * 
	 */	
	public class PlayState implements IVideoState
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		private var _player				:VideoPlayer;
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * Interal state which governs the Player's behavior as it is playing 
		 * @param player: The parent VideoPlayer object
		 * 
		 */		
		public function PlayState(player:VideoPlayer)
		{
			this._player = player;
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
		 * @private
		 * 
		 */		
		public function play():void
		{
			trace(this + ' play()');
		}
	
		/**
		 * Seek's the stream back to the beginning, pauses it, and
		 * sends the player to its StopState 
		 * 
		 */		
		public function stop():void
		{
			trace(this + ' stop()');
			
			_player.stream.seek(0);
			_player.stream.pause();
			_player.state = this._player.stopState;
			_player.stopped.dispatch();
		}
	
		/**
		 * Pauses the stream and sends the player to its PauseState. Also
		 * dispatches a paused Signal from the player. 
		 * 
		 */	
		public function pause():void
		{
			trace(this + ' pause()');
			
			_player.stream.pause();
			_player.state = _player.pauseState;
			_player.paused.dispatch();
		}
	
		/**
		 * Pauses the stream and sends the player to its BufferState. Also
		 * dispatches a bufferEmpty Signals from the player. 
		 * 
		 */		
		public function buffer():void
		{
			trace(this + ' buffer()');
			
			_player.stream.pause();
			_player.state = this._player.bufferState;
			_player.bufferEmpty.dispatch();
		}
	}
}