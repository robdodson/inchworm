package com.inchworm.events
{
    import flash.events.*;

    public class BaseButtonEvent extends Event {
        public static const MOUSE_UP_OUTSIDE:String = "onMouseUpOutside";
        public static const MOUSE_OVER:String = "onMouseOver";
        public static const MOUSE_OUT:String = "onMouseOut";

        public function BaseButtonEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
            return;
        }
        override public function toString() : String {
            return formatToString("BaseButtonEvent", "type", "bubbles", "cancelable");
        }
        override public function clone() : Event {
            var _loc_1:* = new BaseButtonEvent(this.type, this.bubbles, this.cancelable);
            return _loc_1;
        }
    }
}
