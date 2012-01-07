package com.inchworm.video.controls
{
	import com.inchworm.events.VideoContainerEvent;
	import com.inchworm.video.VideoContainer;
	
	import org.casalib.display.CasaSprite;

    public class VideoPlayProgress extends CasaSprite {
        protected var _videoContainer:VideoContainer;

        public function VideoPlayProgress(videoContainer:VideoContainer) {
            this.scaleX = 0;
            this._videoContainer = videoContainer;
            this._videoContainer.addEventListener(VideoContainerEvent.LOAD_START, this._onLoadStart);
            this._videoContainer.addEventListener(VideoContainerEvent.PLAY_PROGRESS, this._onPlayProgress);
            return;
        }
        override public function destroy() : void {
            this._videoContainer.removeEventListener(VideoContainerEvent.LOAD_START, this._onLoadStart);
            this._videoContainer.removeEventListener(VideoContainerEvent.PLAY_PROGRESS, this._onPlayProgress);
            super.destroy();
            return;
        }
        protected function _onLoadStart(event:VideoContainerEvent) : void {
            this.scaleX = 0;
            return;
        }
        protected function _onPlayProgress(event:VideoContainerEvent) : void {
            this.scaleX = event.playProgress.decimalPercentage;
            return;
        }
    }
}
