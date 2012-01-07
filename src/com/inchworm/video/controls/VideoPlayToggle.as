package com.inchworm.video.controls
{
	import com.inchworm.display.DestroyableMovieClip;
	import com.inchworm.events.VideoContainerEvent;
	import com.inchworm.video.VideoContainer;

    public class VideoPlayToggle extends DestroyableMovieClip {
        protected var _videoContainer:VideoContainer;
        protected var _play:VideoPlay;
        protected var _pause:VideoPause;

        public function VideoPlayToggle(videoContainer:VideoContainer) {
            this._videoContainer = videoContainer;
            return;
        }
        public function setPlayPause(videoPlay:VideoPlay, videoPause:VideoPause) : void {
            this._play = videoPlay;
            this._pause = videoPause;
            if (this._videoContainer.isPlaying){
                this._onPlay();
            }
            else{
                this._onPause();
            }
            this._videoContainer.addEventListener(VideoContainerEvent.PLAY, this._onPlay);
            this._videoContainer.addEventListener(VideoContainerEvent.PAUSE, this._onPause);
            this._videoContainer.addEventListener(VideoContainerEvent.LOAD_START, this._onPause);
            return;
        }
        override public function destroy() : void {
            this._videoContainer.removeEventListener(VideoContainerEvent.PLAY, this._onPlay);
            this._videoContainer.removeEventListener(VideoContainerEvent.PAUSE, this._onPause);
            this._videoContainer.removeEventListener(VideoContainerEvent.LOAD_START, this._onPause);
            super.destroy();
            return;
        }
        protected function _onPlay(event:VideoContainerEvent = null) : void {
            if (this.contains(this._play)){
                this.removeChild(this._play);
            }
            this.addChild(this._pause);
            return;
        }
        protected function _onPause(event:VideoContainerEvent = null) : void {
            if (this.contains(this._pause)){
                this.removeChild(this._pause);
            }
            this.addChild(this._play);
            return;
        }
    }
}
