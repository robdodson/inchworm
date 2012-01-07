package com.inchworm.media.camera
{
	import com.inchworm.display.DestroyableSprite;
	
	import flash.events.ActivityEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import org.osflash.signals.Signal;
	
	/**
	 * 
	 * @author Justin Gaussoin
	 * @author Rob Dodson
	 * 
	 */	
	public class WebCam extends DestroyableSprite
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		public var detectionError				:Signal = new Signal(String);
		public var accessDeniedError			:Signal = new Signal(String);
		public var inactivityError				:Signal = new Signal(String);
		public var initialized					:Signal = new Signal();
		
		protected var _width					:Number;
		protected var _height					:Number;
		protected var _fps						:Number;
		
		protected var _cam						:Camera;
		protected var _video					:Video;
		protected var _timeout					:Number;
		
		protected var _cameraIndex				:int;
		protected var _isCameraActivated		:Boolean = false;
		protected var _camStatus				:String;
		protected var _activityInterval			:int;
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * A Video object with the webcam capture in it
		 * @return Returns a video object which displays the current webcam capture 
		 * 
		 */		
		public function get video():Video
		{
			return _video;
		}
		
		/**
		 * Boolean indicating whether or not the current Camera is
		 * actively in use. 
		 * @return Returns a Boolean flag of true if the current Camera
		 * is active, otherwise it returns false.
		 * 
		 */		
		public function get isCameraActivated():Boolean
		{
			return _isCameraActivated;
		}
		
		/**
		 * Handles setup and detection of a user's WebCam
		 * @param width: The width of the webcam's area 
		 * @param height: The height of the webcam's area
		 * @param fps: The frames per second that the video should output
		 * 
		 */		
		public function WebCam(width:int, height:int, fps:Number = 20)
		{
			super();
			
			_width = width;
			_height = height;
			_fps = fps;
		}
		
		/**
		 * Start the process to setup the webcam
		 * @param timeout: Determines how long to wait before checking for camera acivity
		 * 
		 */		
		public function start(timeout:Number = 3000):void
		{
			_timeout = timeout;
			
			if (Camera.names.length < 1)
			{
				// Failed to detect any usable cameras...
				detectionError.dispatch('Failed to detect any usable cameras');
				return;
			}
			
			_detectCamera();
		}
		
		/**
		 * @private
		 * Moves through the list of available cameras and attempts to
		 * connect to one.
		 * 
		 */		
		protected function _detectCamera():void
		{
			trace(this, " trying camera:", Camera.names[_cameraIndex]);
			_cam = Camera.getCamera(_cameraIndex.toString());
			
			if (_cam == null)
			{
				_nextCamera();
			}
			
			trace(this, ' camera found!');
			
			_cam.setMotionLevel(0, 500);
			_cam.setMode( _width, _height, _fps, true );
			_video = new Video(_width, _height);
			_video.smoothing = true;
			_attachCamListeners(true);
			_video.attachCamera(_cam);
		}
		
		/**
		 * @private
		 * Increments the cameraIndex and attempts to connect
		 * to a new camera.
		 * 
		 */		
		protected function _nextCamera():void
		{
			if(_cameraIndex < Camera.names.length - 1)
			{
				++_cameraIndex;
				_detectCamera();
			}
			else
			{
				inactivityError.dispatch('Activity cannot be detected for any camera');
			}
		}
		
		/**
		 * @private
		 * Add/Remove listeners on the Camera object
		 * @param attach: Boolean indicating whether to add or remove the listeners.
		 * 
		 */		
		protected function _attachCamListeners(attach:Boolean):void
		{
			if(attach)
			{
				_cam.addEventListener(StatusEvent.STATUS, _camStatusHandler);
				_cam.addEventListener(ActivityEvent.ACTIVITY, _camActivityHandler);
			}
			else
			{
				_cam.removeEventListener(StatusEvent.STATUS, _camStatusHandler);
				_cam.removeEventListener(ActivityEvent.ACTIVITY, _camActivityHandler);
			}
		}
		
		/**
		 * @private
		 * Check the status of the Camera. If it is 'Muted' then the user has
		 * made it unavailable and a accessDeniedError Signal will be dispatched.
		 * 
		 * @param e: StatusEvent returned by the Camera object
		 * 
		 */		
		protected function _camStatusHandler(e:StatusEvent):void
		{
			_camStatus = e.code;

			if(_camStatus == "Camera.Muted")
			{
				_attachCamListeners(false);
				accessDeniedError.dispatch('User denied camera access');
			}
			else
			{
				_activityInterval = setTimeout(_checkActivity, _timeout);
			}
		}

		/**
		 * @private
		 * Checks the Camera for any activity. If no activity has been reported
		 * then it attempts to connect to a different Camera.
		 * 
		 */		
		protected function _checkActivity():void
		{
			if(_isCameraActivated)
			{
				_attachCamListeners(false);
				clearTimeout(_activityInterval);
				addChild(_video);
				initialized.dispatch();
			}
			else
			{
				// Try another camera
				_nextCamera();
			}
		}
		
		/**
		 * @private
		 * When Camera activity is detected it will set a flag so
		 * the WebCam object knows that its camera is working.
		 * @param e: ActivityEvent dispatched by the Camera object
		 * 
		 */		
		protected function _camActivityHandler(e:ActivityEvent):void
		{
			_isCameraActivated = e.activating;
		}
		
		/**
		 * Remove any event listeners and signals, stop all internal process, destroy all
		 * children which implement IDestroyable and remove the DisplayObject from its
		 * parent. 
		 * 
		 * @see com.inchworm.core.IDestroyable
		 * 
		 */		
		override public function destroy():void
		{
			_video.clear();
			_video = null;
			_cam = null;
			super.destroy();
		}
	}
}