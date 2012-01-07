package com.inchworm.video.controls
{
	import com.inchworm.display.DestroyableMovieClip;
	import com.inchworm.events.VideoContainerEvent;
	import com.inchworm.video.VideoContainer;
	
	public class VideoMuteToggle extends DestroyableMovieClip {
		protected var _videoContainer:VideoContainer;
		protected var _mute:VideoMute;
		protected var _unmute:VideoUnmute;
		
		public function VideoMuteToggle(videoContainer:VideoContainer) {
			this._videoContainer = videoContainer;
			return;
		}
		
		public function setMuteUnmute(videoMute:VideoMute, videoUnmute:VideoUnmute) : void {
			this._mute = videoMute;
			this._unmute = videoUnmute;
			if (this._videoContainer.isMute){
				this._onMute();
			}
			else{
				this._onUnmute();
			}
			this._videoContainer.addEventListener(VideoContainerEvent.MUTE, this._onMute);
			this._videoContainer.addEventListener(VideoContainerEvent.UNMUTE, this._onUnmute);
			return;
		}
		
		override public function destroy() : void {
			this._videoContainer.removeEventListener(VideoContainerEvent.MUTE, this._onMute);
			this._videoContainer.removeEventListener(VideoContainerEvent.UNMUTE, this._onUnmute);
			super.destroy();
			return;
		}
		
		protected function _onMute(event:VideoContainerEvent = null) : void {
			if (this.contains(this._mute)){
				this.removeChild(this._mute);
			}
			this.addChild(this._unmute);
			return;
		}
		
		protected function _onUnmute(event:VideoContainerEvent = null) : void {
			if (this.contains(this._unmute)){
				this.removeChild(this._unmute);
			}
			this.addChild(this._mute);
			return;
		}
	}
}
