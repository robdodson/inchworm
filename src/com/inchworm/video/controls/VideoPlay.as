package com.inchworm.video.controls
{
    import com.inchworm.video.VideoContainer;
    
    import flash.events.*;

    public class VideoPlay extends VideoButton
	{

        public function VideoPlay(videoContainer:VideoContainer)
		{
            super(videoContainer);
            return;
        }

        override protected function _onClick(event:MouseEvent):void
		{
            this._videoContainer.play();
            super._onClick(event);
            return;
        }
    }
}
