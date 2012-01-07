package com.inchworm.display.buttons
{
    import com.inchworm.events.*;
    import flash.events.*;
    import org.casalib.display.*;

    public class BaseButton extends CasaSprite {
        protected var _isMouseDown:Boolean;
        protected var _isLocked:Boolean;

        public function BaseButton() {
            this.mouseChildren = false;
            this._isLocked = true;
            this.unlock();
            return;
        }
        public function get mouseDown() : Boolean {
            return this._isMouseDown;
        }
        public function get locked() : Boolean {
            return this._isLocked;
        }
        public function lock() : void {
            if (this._isLocked){
                return;
            }
            this._lock();
            return;
        }
        public function unlock() : void {
            if (!this._isLocked){
                return;
            }
            this._unlock();
            return;
        }
        public function checkForMouseOver() : void {
            if (this.locked){
                return;
            }
            if (this.getBounds(this).contains(this.mouseX, this.mouseY)){
                this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
            }
            return;
        }
        protected function _lock() : void {
            this._isLocked = true;
            this.removeEventListener(MouseEvent.DOUBLE_CLICK, this._onDoubleClick);
            this.removeEventListener(MouseEvent.MOUSE_DOWN, this._onMouseDown);
            this.removeEventListener(MouseEvent.MOUSE_OVER, this._onMouseOver);
            this.removeEventListener(MouseEvent.MOUSE_OUT, this._onMouseOut);
            this.removeEventListener(MouseEvent.MOUSE_UP, this._onMouseUp);
            this.removeEventListener(MouseEvent.CLICK, this._onClick);
            if (this.stage != null){
                this.stage.removeEventListener(MouseEvent.MOUSE_UP, this._onMouseUp);
            }
            var _loc_1:* = this.mouseDown;
            this._isMouseDown = false;
            this.buttonMode = false;
            this.mouseEnabled = false;
            if (_loc_1){
                this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
            }
            return;
        }
        protected function _unlock() : void {
            this._isLocked = false;
            this.addEventListener(MouseEvent.DOUBLE_CLICK, this._onDoubleClick);
            this.addEventListener(MouseEvent.MOUSE_DOWN, this._onMouseDown);
            this.addEventListener(MouseEvent.MOUSE_OVER, this._onMouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, this._onMouseOut);
            this.addEventListener(MouseEvent.MOUSE_UP, this._onMouseUp);
            this.addEventListener(MouseEvent.CLICK, this._onClick);
            this.buttonMode = true;
            this.mouseEnabled = true;
            return;
        }
        protected function _onClick(event:MouseEvent) : void {
            return;
        }
        protected function _onDoubleClick(event:MouseEvent) : void {
            return;
        }
        protected function _onMouseOver(event:MouseEvent) : void {
            return;
        }
        protected function _onMouseOut(event:MouseEvent) : void {
            return;
        }
        protected function _onMouseDown(event:MouseEvent) : void {
            this._isMouseDown = true;
            this.stage.addEventListener(MouseEvent.MOUSE_UP, this._onMouseUpOutside);
            return;
        }
        protected function _onMouseUp(event:MouseEvent) : void {
            this._onMouseUpOrUpOutside();
            return;
        }
        protected function _onMouseUpOutside(event:MouseEvent) : void {
            this._onMouseUpOrUpOutside();
            this.dispatchEvent(new BaseButtonEvent(BaseButtonEvent.MOUSE_UP_OUTSIDE));
            return;
        }
        protected function _onMouseUpOrUpOutside() : void {
            this._isMouseDown = false;
            this.stage.removeEventListener(MouseEvent.MOUSE_UP, this._onMouseUpOutside);
            return;
        }
        override public function destroy() : void {
            this.lock();
            super.destroy();
            return;
        }
    }
}
