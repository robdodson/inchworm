package com.inchworm.video.controls
{
	import com.inchworm.events.VideoContainerEvent;
	import com.inchworm.shapes.Box;
	import com.inchworm.video.VideoContainer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.casalib.math.Percent;

	public class VideoTrack extends VideoButton
	{
		protected var _progressBar:Sprite;
		protected var _hitArea:Sprite;
		protected var _scrubber:Sprite;
		protected var _margin:Number = 0;
		
		public function VideoTrack(videoContainer:VideoContainer)
		{
			super(videoContainer);
			_videoContainer.addEventListener(VideoContainerEvent.PLAY_PROGRESS, _onPlayProgress, false, 0, true);
			//this.buttonMode = true;
			return;
		}
		
		public function setProgressBar(progressBar:Sprite):void
		{
			_progressBar = progressBar;
			_hitArea = new Box(_progressBar.width, _progressBar.height);
			_hitArea.x = _progressBar.x;
			_hitArea.y = _progressBar.y - (progressBar.height / 2);
			_hitArea.alpha = 0;
			addChild(_hitArea);
		}
		
		public function setScrubber(scrubber:Sprite):void
		{
			_scrubber = scrubber;
			_margin = _scrubber.width / 2;
		}
		
		protected function _onPlayProgress(event:VideoContainerEvent):void
		{
			_progressBar.scaleX = event.playProgress.decimalPercentage;
			if (_scrubber)
			{
				_progressBar.width = Math.max(0, _progressBar.width - _margin);
				_scrubber.x = _progressBar.width;
				_scrubber.y = _progressBar.y;
			}
		}
		
		override protected function _onClick(event:MouseEvent):void
		{
			/*
			var loadPercent:Number = this._videoContainer.videoLoad.bytesLoaded / this._videoContainer.videoLoad.bytesTotal;
			if (isNaN(loadPercent)){
				loadPercent = 0;
			}
			else if (loadPercent >= 1){
				loadPercent = 0.98;
			}
			else{
				loadPercent = Math.max(loadPercent - 0.15, 0);
			}
			*/
			this._videoContainer.seekPercent(new Percent(event.localX / this.width));
			super._onClick(event);
			_videoContainer.addEventListener(VideoContainerEvent.PLAY_PROGRESS, _onPlayProgress, false, 0, true);
			event.updateAfterEvent();
			return;
		}
		
		override protected function _onMouseDown(event:MouseEvent):void
		{
			_videoContainer.removeEventListener(VideoContainerEvent.PLAY_PROGRESS, _onPlayProgress);
			
			if (_scrubber)
			{
				this.addEventListener(MouseEvent.MOUSE_MOVE, _onStartDrag, false, 0, true);
				this.addEventListener(MouseEvent.MOUSE_UP, _onStopDrag, false, 0, true);
			}
		}
		
		protected function _onStartDrag(event:MouseEvent):void
		{
			_scrubber.x = Math.max(_margin, Math.min(_hitArea.width - _margin, event.localX));
			_progressBar.width = Math.max(0, _scrubber.x);
		}

		protected function _onStopDrag(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE, _onStartDrag);
			this.removeEventListener(MouseEvent.MOUSE_UP, _onStopDrag);
		}
	}
}