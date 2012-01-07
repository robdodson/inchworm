package com.inchworm.video
{
    import com.inchworm.events.*;
    import flash.events.*;
    import flash.media.*;
    import org.casalib.display.*;
    import org.casalib.events.*;
    import org.casalib.load.*;
    import org.casalib.math.*;
    import org.casalib.util.*;

    public class VideoContainer extends CasaSprite {
        protected var _videoLoad:VideoLoad;
        protected var _video:Video;
        protected var _width:uint;
        protected var _height:uint;
        protected var _duration:Number;
        protected var _volume:Percent;
        protected var _isPlaying:Boolean;
        protected var _isMute:Boolean;
        protected var _isBufferEmpty:Boolean;
        protected var _isPlaybackComplete:Boolean;

        public function VideoContainer() {
            this._volume = new Percent(1);
            return;
        }
        public function get video() : Video {
            return this._video;
        }
        public function set video(video:Video) : void {
            this.reset();
            this._video = video;
            return;
        }
        public function get duration() : Number {
            return this._duration;
        }
        public function loadVideo(path:String, completeWhenBuffered:Boolean = false) : void {
            this.reset();
            this._videoLoad = new VideoLoad(path, completeWhenBuffered);
            this._videoLoad.pauseStart = true;
            this._videoLoad.addEventListener(VideoInfoEvent.META_DATA, this._onMetaData);
            this._videoLoad.addEventListener(VideoLoadEvent.PROGRESS, this._onProgress);
            this._videoLoad.addEventListener(LoadEvent.COMPLETE, this._onComplete);
            this._videoLoad.addEventListener(VideoLoadEvent.BUFFERED, this._onBuffered);
            this._videoLoad.addEventListener(NetStatusEvent.NET_STATUS, this._onNetStatus);
            this._video = this._videoLoad.video;
            this._video.smoothing = true;
            if (this._width != 0){
                this.video.width = this._width;
                this.video.height = this._height;
            }
            this.addChild(this.video);
            this.volume = this.volume;
            this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.LOAD_START);
            this._videoLoad.start();
            return;
        }
        public function get videoLoad() : VideoLoad {
            return this._videoLoad;
        }
        public function setVideoSize(width:uint, height:uint) : void {
            this._width = width;
            this._height = height;
            if (this._video != null){
                this.video.width = this._width;
                this.video.height = this._height;
            }
            this._drawPlaceholder(this._width, this._height);
            return;
        }
        public function reset() : void {
            if (this.video == null){
                return;
            }
            this._isPlaying = false;
            this.removeEventListener(Event.ENTER_FRAME, this._onPlayProgress);
            this.removeChild(this.video);
            this._video = null;
            this._videoLoad.netStream.close();
            this._videoLoad.destroy();
            this._isPlaybackComplete = false;
            this._isBufferEmpty = false;
            return;
        }
        public function play() : void {
            if (this._isPlaying){
                return;
            }
            if (this._isBufferEmpty){
                this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.REBUFFERING);
            }
            if (this._isPlaybackComplete){
                this.rewind();
            }
            this._isPlaying = true;
            this._videoLoad.netStream.resume();
            this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.PLAY);
            this.addEventListener(Event.ENTER_FRAME, this._onPlayProgress);
            return;
        }
        public function pause() : void {
            if (!this._isPlaying){
                return;
            }
            this._isPlaying = false;
            this._videoLoad.netStream.pause();
            if (this._isBufferEmpty){
                this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.REBUFFERED);
            }
            this.removeEventListener(Event.ENTER_FRAME, this._onPlayProgress);
            this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.PAUSE);
            return;
        }
        public function get isPlaying() : Boolean {
            return this._isPlaying;
        }
        public function rewind() : void {
            this.seek(0);
            this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.REWIND);
            return;
        }
        public function seek(seekPoint:Number) : void {
            this._isPlaybackComplete = false;
            this._videoLoad.netStream.seek(Math.min(Math.floor(this.duration) - 0.5, seekPoint));
            this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.PLAY_PROGRESS, new Percent(seekPoint / this._videoLoad.duration), seekPoint);
            return;
        }
        public function seekPercent(percent:Percent) : void {
            this.seek(this.duration * Math.min(0.99, percent.decimalPercentage));
            return;
        }
        public function mute() : void {
            this._isMute = true;
            this._videoLoad.netStream.soundTransform = new SoundTransform(0);
            this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.MUTE);
            return;
        }
        public function unmute() : void {
            this._isMute = false;
            this._videoLoad.netStream.soundTransform = new SoundTransform(this._volume.decimalPercentage);
            this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.UNMUTE);
            return;
        }
        public function get volume() : Percent {
            return this._volume.clone();
        }
        public function set volume(volume:Percent) : void {
            this._volume = volume.clone();
            if (this._videoLoad == null){
                return;
            }
            this._videoLoad.netStream.soundTransform = new SoundTransform(this._volume.decimalPercentage);
            if (this.isMute){
                this.unmute();
            }
            this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.VOLUME_CHANGED);
            return;
        }
        public function get isMute() : Boolean {
            return this._isMute;
        }
        public function get isPlaybackComplete() : Boolean {
            return this._isPlaybackComplete;
        }
        override public function destroy() : void {
            this.reset();
            super.destroy();
            return;
        }
        protected function _onMetaData(event:VideoInfoEvent) : void {
            this._duration = event.infoObject.duration;
            if (this._width == 0){
                this.video.width = uint(event.infoObject.width);
                this.video.height = uint(event.infoObject.height);
            }
            this._drawPlaceholder(this.video.width, this.video.height);
            this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.META_DATA);
            return;
        }
        private function _onNetStatus(event:NetStatusEvent) : void {
            switch(event.info.code){
                case "NetStream.Buffer.Empty":{
                    this._isBufferEmpty = true;
                    this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.REBUFFERING);
                    break;
                }
                case "NetStream.Buffer.Full":
                case "NetStream.Buffer.Flush":{
                    if (this._isBufferEmpty){
                        this._isBufferEmpty = false;
                        this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.REBUFFERED);
                    }
                    break;
                }
                case "NetStream.Play.Stop":{
                    if (this._isPlaying && NumberUtil.isEqual(this._videoLoad.netStream.time, this._videoLoad.duration, 0.1)){
                        this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.COMPLETE);
                        this.pause();
                        this._isPlaybackComplete = true;
                    }
                    break;
                }
                default:{
                    break;
                }
            }
            return;
        }
        protected function _onProgress(event:VideoLoadEvent) : void {
            this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.LOAD_PROGRESS);
            return;
        }
        protected function _onBuffered(event:VideoLoadEvent) : void {
            this.rewind();
            this._videoLoad.netStream.bufferTime = 5;
            this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.BUFFERED);
            return;
        }
        protected function _onPlayProgress(event:Event) : void {
            this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.PLAY_PROGRESS);
            return;
        }
        protected function _onComplete(event:LoadEvent) : void {
            this._dispatchDefinedVideoContainerEvent(VideoContainerEvent.LOADED);
            return;
        }
        protected function _dispatchDefinedVideoContainerEvent(eventName:String, progress:Percent = null, time:Number = -1) : void {
            var event:VideoContainerEvent = new VideoContainerEvent(eventName);
            new VideoContainerEvent(eventName).loadProgress = this._videoLoad.progress;
            event.playProgress = progress == null ? (new Percent(this._videoLoad.netStream.time / this._videoLoad.duration)) : (progress);
            event.buffer = this._videoLoad.buffer;
            event.currentTime = time == -1 ? (this._videoLoad.netStream.time) : (time);
            event.duration = this._videoLoad.duration;
            event.volume = this.volume;
            this.dispatchEvent(event);
            return;
        }
        protected function _drawPlaceholder(width:uint, height:uint) : void {
            this.graphics.clear();
            this.graphics.beginFill(0, 1);
            this.graphics.drawRect(0, 0, width, height);
            this.graphics.endFill();
            return;
        }
    }
}
