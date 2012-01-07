package com.inchworm.video.controls
{
	import com.inchworm.events.VideoContainerEvent;
	import com.inchworm.video.VideoContainer;
	
	import org.casalib.display.CasaSprite;
	import org.casalib.util.NumberUtil;

    public class VideoTime extends CasaSprite {
        protected var _videoContainer:VideoContainer;
        protected var _currentTime:String;
        protected var _currentTimeLeadingZero:String;
        protected var _totalTime:String;
        protected var _totalTimeLeadingZero:String;

        public function VideoTime(videoContainer:VideoContainer) {
            this._videoContainer = videoContainer;
            this._videoContainer.addEventListener(VideoContainerEvent.META_DATA, this._onPlayProgress);
            this._videoContainer.addEventListener(VideoContainerEvent.PLAY_PROGRESS, this._onPlayProgress);
            return;
        }
        override public function destroy() : void {
            this._videoContainer.removeEventListener(VideoContainerEvent.META_DATA, this._onPlayProgress);
            this._videoContainer.removeEventListener(VideoContainerEvent.PLAY_PROGRESS, this._onPlayProgress);
            super.destroy();
            return;
        }
        protected function _onPlayProgress(event:VideoContainerEvent) : void {
            var _loc_2:* = ":" + NumberUtil.addLeadingZero(Math.floor(event.currentTime % 60));
            var _loc_3:* = Math.floor(event.currentTime / 60);
            var _loc_4:* = ":" + NumberUtil.addLeadingZero(Math.floor(event.duration % 60));
            var _loc_5:* = Math.floor(event.duration / 60);
            this._currentTime = _loc_3 + _loc_2;
            this._currentTimeLeadingZero = NumberUtil.addLeadingZero(_loc_3) + _loc_2;
            this._totalTime = _loc_5 + _loc_4;
            this._totalTimeLeadingZero = NumberUtil.addLeadingZero(_loc_5) + _loc_4;
            return;
        }
    }
}
