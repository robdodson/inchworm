package com.inchworm.video.controls
{
    import com.inchworm.display.buttons.BaseButton;
    import com.inchworm.events.*;
    import com.inchworm.video.*;

    public class VideoButton extends BaseButton {
        protected var _videoContainer:VideoContainer;

        public function VideoButton(videoContainer:VideoContainer) {
            this.lock();
            this._videoContainer = videoContainer;
            this._videoContainer.addEventListener(VideoContainerEvent.LOAD_START, this._onLoadStart);
            this._videoContainer.addEventListener(VideoContainerEvent.BUFFERED, this._onBuffered);
            return;
        }
		
        override public function destroy() : void {
            this._videoContainer.removeEventListener(VideoContainerEvent.LOAD_START, this._onLoadStart);
            this._videoContainer.removeEventListener(VideoContainerEvent.BUFFERED, this._onBuffered);
            super.destroy();
            return;
        }
		
        protected function _onLoadStart(event:VideoContainerEvent) : void {
            this.lock();
            return;
        }
		
        protected function _onBuffered(event:VideoContainerEvent) : void {
            this.unlock();
            return;
        }
    }
}
