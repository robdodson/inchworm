package com.inchworm.video.controls
{
    import com.inchworm.video.*;
    import com.inchworm.video.controls.VideoButton;
    
    import flash.events.*;

    public class VideoPause extends VideoButton {

        public function VideoPause(videoContainer:VideoContainer) {
            super(videoContainer);
            return;
        }
        override protected function _onClick(event:MouseEvent) : void {
            this._videoContainer.pause();
            super._onClick(event);
            return;
        }
    }
}
