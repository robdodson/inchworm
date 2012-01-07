package com.inchworm.video.controls
{
	import com.inchworm.video.VideoContainer;
	
	import flash.events.MouseEvent;
	
	public class VideoUnmute extends VideoButton {
		
		public function VideoUnmute(videoContainer:VideoContainer) {
			super(videoContainer);
			return;
		}
		
		override protected function _onClick(event:MouseEvent) : void {
			this._videoContainer.unmute();
			super._onClick(event);
			return;
		}
	}
}