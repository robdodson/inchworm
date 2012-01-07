package com.inchworm.video.controls
{
	import com.inchworm.video.VideoContainer;
	
	import flash.events.MouseEvent;

	public class VideoMute extends VideoButton {
		
		public function VideoMute(videoContainer:VideoContainer) {
			super(videoContainer);
			return;
		}
		
		override protected function _onClick(event:MouseEvent) : void {
			this._videoContainer.mute();
			super._onClick(event);
			return;
		}
	}
}