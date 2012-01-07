package com.inchworm.events
{
    import flash.events.*;
    import org.casalib.math.*;

    public class VideoContainerEvent extends Event {
        protected var _buffer:Percent;
        protected var _loadProgress:Percent;
        protected var _playProgress:Percent;
        protected var _duration:Number;
        protected var _currentTime:Number;
        protected var _volume:Percent;
        public static const PLAY:String = "onPlay";
        public static const PAUSE:String = "onPause";
        public static const REWIND:String = "onRewind";
        public static const PLAY_PROGRESS:String = "onPlayProgress";
        public static const COMPLETE:String = "onComplete";
        public static const BUFFERED:String = "onBuffered";
        public static const REBUFFERING:String = "onRebuffering";
        public static const REBUFFERED:String = "onRebuffered";
        public static const LOAD_START:String = "onLoadStart";
        public static const LOAD_PROGRESS:String = "onLoadProgress";
        public static const LOADED:String = "onLoaded";
        public static const MUTE:String = "onMute";
        public static const UNMUTE:String = "onUnmute";
        public static const VOLUME_CHANGED:String = "onVolumeChanged";
        public static const META_DATA:String = "onMetaData";

        public function VideoContainerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
            this._buffer = new Percent();
            this._loadProgress = new Percent();
            this._playProgress = new Percent();
            return;
        }
        public function get buffer() : Percent {
            return this._buffer.clone();
        }
        public function set buffer(percent:Percent) : void {
            this._buffer = percent.clone();
            return;
        }
        public function get loadProgress() : Percent {
            return this._loadProgress.clone();
        }
        public function set loadProgress(percent:Percent) : void {
            this._loadProgress = percent.clone();
            return;
        }
        public function get playProgress() : Percent {
            return this._playProgress.clone();
        }
        public function set playProgress(percent:Percent) : void {
            this._playProgress = percent;
            return;
        }
        public function get currentTime() : Number {
            return this._currentTime;
        }
        public function set currentTime(time:Number) : void {
            this._currentTime = time;
            return;
        }
        public function get duration() : Number {
            return this._duration;
        }
        public function set duration(time:Number) : void {
            this._duration = time;
            return;
        }
        public function get volume() : Percent {
            return this._volume.clone();
        }
        public function set volume(percent:Percent) : void {
            this._volume = percent.clone();
            return;
        }
        override public function toString() : String {
            return this.formatToString("VideoContainerEvent", "type", "bubbles", "cancelable", "loadProgress", "playProgress", "buffer", "currentTime", "duration", "volume");
        }
        override public function clone() : Event {
            var event:VideoContainerEvent = new VideoContainerEvent(this.type, this.bubbles, this.cancelable);
            event.loadProgress = this.loadProgress;
            event.playProgress = this.playProgress;
            event.buffer = this.buffer;
            event.currentTime = this.currentTime;
            event.duration = this.duration;
            event.volume = this.volume;
            return event;
        }
    }
}
