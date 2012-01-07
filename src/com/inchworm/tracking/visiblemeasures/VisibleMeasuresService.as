package com.inchworm.tracking.visiblemeasures
{
	import com.vmc.lib.VMCUtility;
	
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.net.NetStream;

	/**
	 * A service class which wraps the functionality of setting up a Visible Measures tracker
	 * @author Rob Dodson
	 * 
	 */	
	public class VisibleMeasuresService extends EventDispatcher
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		private var _stream						:NetStream;
		private var _playerName					:String;
		private var _accountKey					:String;
		
		//————————————————————————————————————————————————————————————————
	

		/**
		 * A service class which wraps the functionality of setting up a Visible Measures tracker 
		 * @param stream: The NetStream of the video to be tracked
		 * @param playerName: 
		 * @param accountKey
		 * 
		 */		
		public function VisibleMeasuresService(stream:NetStream, playerName:String, accountKey:String) 
		{
			super();
			
			if(stream == null || playerName == null || accountKey == null)
			{
				throw new IllegalOperationError('Parameter passed in must be non-null');
			}
				
			_stream = stream;
			_playerName = playerName;
			_accountKey = accountKey;
		}

		/**
		 * Activate the tracking service 
		 * @param units
		 * @param hostPage
		 * @param hostReferrer
		 * @param countryCode
		 * @param encoding
		 * 
		 */		
		public function initTracking(units:String = 'seconds', hostPage:String = null, hostReferrer:String = null, countryCode:String = null, encoding:String = null):void
		{
			trace(this + ' initTracking');
			
			// Define the player info object which is used to
			// identify the player in the tracking dashboard
			var playerInfo:Object = { name: _playerName };
			
			// Check for optional parameters
			if(hostPage) playerInfo.hostPage = hostPage; // This will override the host URL which the API attempts to determine automatically.
			if(hostReferrer) playerInfo.hostReferrer = hostReferrer; // Similar to hostPage, this is the URL of the page that linked the current viewer to you video’s hostPage.
			if(countryCode) playerInfo.countryCode = countryCode; // The 2-letter ISO standard country code. Allows you to override Visible Measures own IP-to-Geo lookup process.
			if(encoding) playerInfo.encoding = encoding; // The default, if not specified, is UTF-8, but you can specify a “1” for ISO-8859-1/latin-1 encoding.
			
			// Define the config info object which is used to
			// initiate the tracking class
			var configInfo:Object = {
    			playerInfo: playerInfo,
    			accountKey: _accountKey,
    			genericTimerInfo: {
        			property: getPosition, 	// a function that returns the current playhead position
        			target: this,          	// the scope to be applied when "getPosition()" is called
        			units: units  			// "seconds" or "milliseconds" depending on your function's return value
    			}
			};
			
			VMCUtility.getInstance().configure(configInfo);
		}

		/**
		 * Track the currently playing video 
		 * @param id
		 * @param title
		 * @param duration
		 * @param description
		 * @param flvSourceUrl
		 * @param thumbnailUrl
		 * @param category
		 * @param additionalProps
		 * 
		 */		
		public function trackClipView(id:String, 
									  title:String, 
									  duration:Number, 
									  description:String = null, 
									  flvSourceUrl:String = null, 
									  thumbnailUrl:String = null, 
									  category:String = null, 
									  additionalProps:Object = null):void
		{
			trace(this + ' trackClipView()');
			
			// Create the clipInfo obj and set required properties
			var clipInfo:Object = new Object();
			clipInfo.id = id;
			clipInfo.title = title;
			clipInfo.duration = duration;
			
			if(description) clipInfo.description = description; // Longer descriptive text for your video. Appears in the dashboard between the video title and KPI statistics. Facilitates search.
			if(category) clipInfo.category = category; // A category name that you can assign to your video.
			if(flvSourceUrl) clipInfo.flvSourceUrl = flvSourceUrl; // The absolute URL to your video. When set properly, allows you to view the video interactively in the Dashboard Engagement Report.
			if(thumbnailUrl) clipInfo.thumbnailUrl = thumbnailUrl; // The absolute URL to an thumbnail image file for your video. When set properly, appears next to your video title in the Dashboard.
			
			// Check for additional properties. For a full list of additional properties see: http://overdrive.visiblemeasures.com/doc/latest/clipInfo.html
			if(additionalProps)
			{
				for (var prop:String in additionalProps)
				{ 
					clipInfo[prop] = additionalProps[prop]; 
				}
			}
			
			VMCUtility.getInstance().getRemoteNode().clipViewed(clipInfo);
		}

		/**
		 * Get the player's position in the video 
		 * @return 
		 * 
		 */		
		public function getPosition():Number
		{
			if (_stream) return _stream.time;	
			
			// If the player is not currently returning a netstream object then just return 0
			trace(this + ' no stream found');
			return 0;
		}

		/**
		 * Set the currently tracked video's duration 
		 * @param duration
		 * 
		 */		
		public function setDuration(duration:Number):void
		{
			trace(this + ' setDuration()');
			VMCUtility.getInstance().getRemoteNode().setClipDuration(duration);
		}
		
		/**
		 * Track a custom event 
		 * @param customEventName
		 * 
		 */		
		public function trackCustomEvent(customEventName:String):void
		{
			trace(this + ' trackCustomEvent()');
			VMCUtility.getInstance().getRemoteNode().logCustomEvent(customEventName);
		}

		/**
		 * Sets a NetStream for the service to track 
		 * @param value
		 * 
		 */		
		public function set stream(value:NetStream):void
		{
			_stream = value;
		}
	}
}