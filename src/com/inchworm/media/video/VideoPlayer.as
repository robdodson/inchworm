package com.inchworm.media.video
{
	import com.inchworm.display.DestroyableSprite;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.osflash.signals.Signal;
	
	/**
	 * A full featured, stateful, Video Player
	 * 
	 * @author Justin Gaussoin
	 * @author Rob Dodson
	 * 
	 */	
	public class VideoPlayer extends DestroyableSprite
	{
		//————————————————————————————————————————————————————————————————
		// VIDEO STATES
		internal var initState				:InitState;
		internal var playState				:PlayState;
		internal var stopState				:StopState;
		internal var pauseState				:PauseState;
		internal var bufferState			:BufferState;
		
		internal var state					:IVideoState;
		
		// CLASS MEMBERS
		protected var _stream				:NetStream;
		protected var _connection			:NetConnection;
		protected var _streamURI			:String;
		protected var _isStreaming			:Boolean;
		protected var _internalConnection	:Boolean;
		protected var _checkPolicyFile		:Boolean;
		
		protected var _video				:Video;
		
		protected var _autoPlay				:Boolean = true;
		protected var _source				:String;
		
		protected var _bufferTime			:Number = 5;
		protected var _duration				:Number = 0.1;
		protected var _volume				:Number = 1;
		
		// CUSTOM WIDTH & HEIGHT
		protected var _width				:Number;
		protected var _height				:Number;
		
		// SIGNALS
		public var error					:Signal = new Signal(String);
		public var connected				:Signal = new Signal();
		public var started					:Signal = new Signal();
		public var paused					:Signal = new Signal();
		public var resumed					:Signal = new Signal();
		public var stopped					:Signal = new Signal();
		public var completed				:Signal = new Signal();
		public var bufferFull				:Signal = new Signal();
		public var bufferEmpty				:Signal = new Signal();
		public var cuePoint					:Signal = new Signal(Object);
		public var xmpData					:Signal = new Signal(Object);
		public var metaData					:Signal = new Signal(Object);
		
		//————————————————————————————————————————————————————————————————

		/**
		 * The current state of the video player as an IVideoState Object 
		 * @return Returns an IVideoState object which indicates the current
		 * state of the player.
		 * 
		 */		
		public function get currentState():IVideoState
		{
			// TODO: This probably violates rules of encapsulation
			// allowing the internal state objects to be passed in this way.
			return this.state;
		}
		
		/**
		 * Put the player in the init state 
		 * 
		 */		
		public function init():void		{ state.init(); }
		
		/**
		 * Put the player in the play state 
		 * 
		 */		
		public function play():void 	{ state.play(); }
		
		/**
		 * Put the player in the stop state 
		 * 
		 */		
		public function stop():void 	{ state.stop(); }
		
		/**
		 * Put the player in the pause state 
		 * 
		 */		
		public function pause():void 	{ state.pause(); }
		
		/**
		 * Put the player in the buffer state 
		 * 
		 */		
		public function buffer():void 	{ state.buffer(); }
		
		
		/**
		 * Get the currently active NetStream 
		 * @return Returns the player's NetStream object
		 * 
		 */		
		public function get stream():NetStream
		{
			return _stream;
		}

		/**
		 * Check for a stream and seek it to the beginning 
		 * 
		 */		
		public function reset():void
		{
			trace(this + ' reset()');
			if(_stream) _stream.seek(0);
		}

		/**
		 * Seek the stream to the specified time 
		 * @param seconds: Seek point in seconds
		 * 
		 */		
		public function seek(seconds:Number):void
		{
			trace(this + ' seek()');
			var st:Number = Math.min(timeLoaded, seconds);
			if (_stream) _stream.seek(st);
		}

		/**
		 * Seek the stream to a percentage of its total duration 
		 * @param percent: Percentage of the stream's duration which
		 * will be used to seek the stream
		 * 
		 */		
		public function seekPercent(percent:Number):void
		{
			trace(this + ' seekPercent()');
			var sp:Number = percent*_duration;
			seek(sp);
		}

		/**
		 * Get the player's volume 
		 * @return Returns the volume of the currently playing NetStream
		 * 
		 */		
		public function get volume():Number
		{
			return _volume;
		}

		/**
		 * Set the player's volume
		 * @param value: The volume, in a range from 0 - 1, to set the player to
		 * 
		 */		
		public function set volume(value:Number):void
		{
			_volume = value;
			if (_stream != null)
			{
				var transform:SoundTransform = _stream.soundTransform;
				transform.volume = _volume;
				_stream.soundTransform = transform;
			}
		}

		/**
		 * Get the time of the currently playing NetStream 
		 * @return Returns the time of the currently playing NetStream 
		 * 
		 */		
		public function get time():Number
		{
			return (_stream != null) ? _stream.time : 0;
		}

		/**
		 * Get the player's progress as a percentage of the total duration of
		 * the stream. 
		 * @return Returns a percentage of the player's time / duration
		 * 
		 */		
		public function get progress():Number
		{
			if(time <= 0 || _duration <= 0) return 0;
			return Math.max(0, Math.min(1, time / _duration));
		}

		/**
		 * Get a percentage indicating how much of the stream has finished loading 
		 * @return Returns a percentage of the stream's loaded bytes / total bytes.
		 * 
		 */		
		public function get percentLoaded():Number
		{
			if(_stream==null || _stream.bytesLoaded<=0 || _stream.bytesTotal<=0) return 0;
			return Math.max(0, Math.min(1, _stream.bytesLoaded / _stream.bytesTotal) );
		}
		
		/**
		 * Get a percentage indicating how much of the stream's total time has already been loaded 
		 * @return Returns a percentage of the loading stream's loaded percent * the stream's total duration
		 * 
		 */		
		public function get timeLoaded():Number
		{
			return percentLoaded * _duration;
		}

		/**
		 * Indicates whether or not the video is progressively downloaded or streamed 
		 * @return Returns a Boolean, indicating whether the current video is progressive or streaming
		 * 
		 */		
		public function get isStreaming():Boolean
		{
			return _isStreaming;
		}
		
		/**
		 * The current Video object
		 * @return Returns the current Video Object 
		 * 
		 */		
		public function get video():Video
		{
			return _video;
		}

		/**
		 * The source path for the NetStream's content 
		 * @return Returns a String path to the currently playing video 
		 * 
		 */		
		public function get source():String
		{
			return _source;
		}

		/**
		 * Get the duration of the currently loaded video 
		 * @return Returns the current video's duration in milliseconds
		 * 
		 */		
		public function get duration():Number
		{
			return _duration;
		}

		/**
		 * Indicator of how long the stream will buffer if playback exceeds
		 * download rate.
		 * 
		 * @return Returns a buffer time in seconds 
		 * 
		 */		
		public function get bufferTime():Number
		{
			return _bufferTime;
		}

		/**
		 * Indicates how long the stream will buffer if playback exceeds
		 * download rate.
		 *  
		 * @param value: The desired buffer time in seconds.
		 * 
		 */		
		public function set bufferTime(value:Number):void
		{
			_bufferTime = value;
			if (_stream) _stream.bufferTime = this._bufferTime;
		}

		/**
		 * Determines if the video has played all the way through. Some video
		 * encodings won't properly fire their Complete events so this flag
		 * is just used as a precaution
		 *  
		 * @return Returns a Boolean indicating that the video or stream has reached
		 * its end. 
		 * 
		 */		
		protected function get isEnd():Boolean
		{
			return ( ((Math.round(_duration)-Math.round(time)) <= 0.1) && (_duration > 0));
		}
		
		/**
		 * A full featured, stateful, Video Player 
		 * 
		 */		
		public function VideoPlayer(width:Number = 640, height:Number = 480, connection:NetConnection = null, connectionURI:String = null)
		{
			super();
			
			playState = new PlayState(this);
			stopState = new StopState(this);
			pauseState = new PauseState(this);
			initState = new InitState(this);
			bufferState = new BufferState(this);
			this.state = initState;
			
			// Set the user accessible player width and height
			_width = width;
			_height = height;
			
			// Create and add a new video object
			_video = new Video(_width, _height);
			_video.smoothing=true;
			addChild(_video);
			
			// Check if the user passed in their own NetConnection, otherwise create a new one
			// If the user did pass in their own URI set the isStreming flag to true
			this._connection = _createConnection(connection);
			if(connectionURI)
			{
				this._streamURI = connectionURI;
				this._isStreaming = true;
			}
		}

		/**
		 * Optionally defines a new NetConnection for the player and adds listeners to it. 
		 * @param connection An optional paramater, if the client has a preexisting Netconnection
		 * they can pass it in here. Otherwise it will be created for them.
		 * 
		 * @return Returns the NetConnection which the player will use for its NetStreams 
		 * 
		 */		
		protected function _createConnection(connection:NetConnection = null):NetConnection
		{
			trace(this + ' createConnection()');
			// Check to see if the user has passed in a net connection, otherwise create a new one
			var nc:NetConnection;
			if (connection)
			{
				nc = connection;
			}
			else
			{
				nc = new NetConnection();
				// Use the _internalConnection var to tell the player that
				// it's ok to destroy this NetConnection when it's done. Otherwise
				// it will preserve the NetConnection in case the Client wishes
				// to keep using it.
				_internalConnection = true;
			}
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _handleError);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, _handleError);
			nc.addEventListener(IOErrorEvent.IO_ERROR, _handleError);
			return nc;
		}

		/**
		 * Loads a movie source path into the player and optionally begins to auto-play it.
		 * 
		 * @param source: The path to the video as a String
		 * @param autoPlay: Boolean indicating whether or not the video will begin playing as soon
		 * as its loaded.
		 * @param checkPolicyFile: Boolean indicating whether or not a policy file should be checked for
		 * when loading a video.
		 * 
		 */		
		public function load(source:String, autoPlay:Boolean = true, checkPolicyFile:Boolean = true):void
		{
			// TODO: Allow source to also be a URLRequest
			
			trace(this + ' load()');
			// Run the init method of the current state
			this.init();
			
			this._source = source;
			this._autoPlay = autoPlay;
			this._checkPolicyFile = checkPolicyFile;
			
			// Check if the current connection is already connected and create the NetStream
			// If the connection is not connected go ahead and connect it
			if (!_connection.connected)
			{
				_connection.addEventListener(NetStatusEvent.NET_STATUS, _handleNetStatus);
				_connection.connect(_streamURI); 	// If the user has passed in a URI this will connect to a streaming server
														//  otherwise it will connect to null for progressive downloads
			}
			else
			{
				createStream();
			}
		}

		/**
		 * Loads a preexisting NetStream into the player and optionally begins to auto-play it.
		 *  
		 * @param stream: The NetStream which should be loaded into the player
		 * @param autoPlay: Boolean indicating whether or not the video will begin playing as soon
		 * as its loaded.
		 * 
		 */		
		public function loadStream(stream:NetStream, autoPlay:Boolean = true):void
		{
			trace(this + ' loadStream()');
			
			// Run the init method of the current state
			this.init();
			
			this._stream = stream;
			this._autoPlay = autoPlay;
			
			createStream();
		}
		
		/**
		 * Creates a NetStream, attaches it to the Video object and checks to see if
		 * it should auto-play. 
		 * 
		 */		
		protected function createStream():void
		{
			trace(this + ' createStream()');
			if (_stream == null) _stream = new NetStream(_connection);
			_stream.checkPolicyFile = _checkPolicyFile;
			_stream.bufferTime = 1;
			_stream.client = this;
			_stream.addEventListener(NetStatusEvent.NET_STATUS, _handleNetStatus);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, _handleError);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, _handleError);
			
			_video.attachNetStream(_stream);
			
			if (this._autoPlay) play();
		}

		/**
		 * Respond to NetStatusEvents from the connection or stream. 
		 * @param event: A NetStatusEvent dispatched from the NetConnection or NetStream
		 * 
		 */		
		protected function _handleNetStatus(event:NetStatusEvent):void
		{
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
					_connection.removeEventListener(NetStatusEvent.NET_STATUS, _handleNetStatus);
					createStream();
					break;
				
				case "NetConnection.Connect.Failed":
					this.destroy();
					error.dispatch("VideoPlayerError: Connection Failed.");
					break;
				
				case "NetStream.Buffer.Full":
					bufferFull.dispatch();
					play();
					break;
				
				case "NetStream.Buffer.Empty":
					_stream.bufferTime = this._bufferTime;
					bufferEmpty.dispatch();
					if (this.isEnd)
					{
						this.stop();
						completed.dispatch();
						return;
					}
					else
					{
						buffer();
					}
					break;
				
				case "NetStream.Play.StreamNotFound":
					var url:String = (_streamURI) ? _streamURI+_source : _source;
					throw new Error("VideoPlayer Error: FLV or Stream not Found", url);
					break;
				
				case "NetStream.Play.Start":
					volume = _volume;
					break;
				
				case "NetStream.Play.Stop":
					stop();
					if (this.isEnd)
					{
						completed.dispatch();
						return;
					}
					else
					{
						stopped.dispatch();
						return
					}
					break;
			}
		}

		/**
		 * Empty overridable function which handles XMPData 
		 * @param data: XMPData object
		 * 
		 */		
		public function onXMPData(data:Object):void
		{
			trace(this,"onXMPData:", data);
			xmpData.dispatch(data);
		}

		/**
		 * Required video metadata handler.  
		 * @param info: Metadata pertaining to the video.
		 * 
		 */		
		public function onMetaData(info:Object):void
		{
			_duration = Number(info.duration);
			metaData.dispatch(info);
		}

		/**
		 * Handler for video cue points 
		 * @param cuePointData: An embedded cue point data object
		 * 
		 */		
		public function onCuePoint(cuePointData:Object):void
		{
			cuePoint.dispatch(cuePointData);
		}

		/**
		 * Handler for IOErrorEvent with redispatches the event allowing the client to establish
		 * their own failsafes. 
		 * @param event: An IOErrorEvent
		 * 
		 */		
		protected function _handleError(e:Event):void
		{
			error.dispatch(e.type);
		}

		/**
		 * Clear the Video object and destroy any NetStreams/NetConnections 
		 * 
		 */		
		override public function destroy():void
		{
			trace(this + ' destroy()');
			_video.attachNetStream(null);
			_video.clear();
			
			if (_connection) {
				_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _handleError);
				_connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, _handleError);
				_connection.removeEventListener(IOErrorEvent.IO_ERROR, _handleError);
				
				if(_internalConnection) _connection = null;
			}
			
			if (_stream) {
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, _handleNetStatus);
				_stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, _handleError);
				_stream.removeEventListener(IOErrorEvent.IO_ERROR, _handleError);
				_stream=null;
			}
			
			super.destroy();
		}

	}
}