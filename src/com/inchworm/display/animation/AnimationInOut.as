/**
 * Modified version of Big Spaceship's StandardInOut.
 * Updated to work with AS3 Signals and removed
 * coupling to the Timeline so that TimelineLite/Max
 * dependent classes could be used as well. 
 */

 /**
 * Copyright (c) 2007-2010 Big Spaceship, LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 **/
package com.inchworm.display.animation
{
	import com.inchworm.display.views.AbstractView;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	/**
	 * Modified version of Big Spaceship's StandardInOut.
	 * Updated to work with AS3 Signals and removed
	 * coupling to the Timeline so that TimelineLite/Max
	 * dependent classes could be used as well. 
	 */
	public class AnimationInOut
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		/**
		 * Dispatched when the view begins animating in 
		 */		
		public var animationInStart							:Signal;
		
		/**
		 * Dispatched when the view has finished animating in 
		 */		
		public var animationIn								:Signal;
		
		/**
		 * Dispatched when the view begins animating out 
		 */		
		public var animationOutStart						:Signal;
		
		/**
		 * Dispatched when the view has finished animating out 
		 */		
		public var animationOut								:Signal;
		
		/**
		 * Indicates whether a Signal should be dispatched if a state
		 * change request is made which targets the current state 
		 */		
		public var dispatchCompleteOnUnchangedState			:Boolean;
		
		/**
		 * @private 
		 */		
		protected var _view									:MovieClip;
		
		/**
		 * @private 
		 */		
		protected var _curState								:String;
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * Modified version of Big Spaceship's StandardInOut.
		 * Updated to work with AS3 Signals and removed
		 * coupling to the Timeline so that TimelineLite/Max
		 * dependent classes could be used as well. 
		 */
		public function AnimationInOut(view:AbstractView)
		{
			_view = view;
			
			_curState = AnimationState.OUT;
			dispatchCompleteOnUnchangedState = true;
			
			animationInStart = new Signal();
			animationIn = new Signal();
			animationOutStart = new Signal();
			animationOut = new Signal();
			
			// Listen for events coming from the view's timeline
			_view.addEventListener(AnimationEvent.IN_START, _onAnimationInStart, false, 0, true);
			_view.addEventListener(AnimationEvent.IN, _onAnimationIn, false, 0, true);
			_view.addEventListener(AnimationEvent.OUT_START, _onAnimationOutStart, false, 0, true);
			_view.addEventListener(AnimationEvent.OUT, _onAnimationOut, false, 0, true);
		}
		
		/**
		 * Tell the view to start animating in.
		 * @param forceAnimation Regardless of the current state of the MovieClip, force
		 * it to animate to the IN_START state
		 * 
		 */		
		public function animateIn(forceAnimation:Boolean = false):void
		{
			_view.visible = true;
			if((_curState != AnimationState.IN_START && _curState != AnimationState.IN) || forceAnimation )
			{
				_delegateInAnimation();
				_curState = AnimationState.IN_START;
			}
			else if(_curState == AnimationState.IN && dispatchCompleteOnUnchangedState)
			{
				animationIn.dispatch();
			}		
		}
		
		/**
		 * Tell the view to start animating out.
		 * @param forceAnimation Regardless of the current state of the MovieClip, force
		 * it to transition to the OUT_START state
		 * 
		 */			
		public function animateOut(forceAnimation:Boolean=false):void
		{
			if((_curState == AnimationState.IN && _curState != AnimationState.OUT_START && _curState != AnimationState.OUT) || forceAnimation)
			{
				_curState = AnimationState.OUT_START;
				_delegateOutAnimation();
			}
			else if(_curState == AnimationState.OUT && dispatchCompleteOnUnchangedState)
			{
				animationOut.dispatch();
			}
		}
		
		/**
		 * @private 
		 * 
		 */		
		protected function _delegateInAnimation():void { _view.gotoAndPlay('IN_START'); }
		
		/**
		 * @private 
		 * 
		 */		
		protected function _delegateOutAnimation():void { _view.gotoAndPlay('OUT_START'); }
		
		/**
		 * @private 
		 * 
		 */		
		protected function _onAnimationInStart(e:Event):void
		{ 
			_curState = AnimationState.IN_START;
			animationInStart.dispatch();
		}
	
		/**
		 * @private 
		 * 
		 */		
		protected function _onAnimationIn(e:Event):void
		{
			_view.stop();
			_curState = AnimationState.IN;
			animationIn.dispatch();
		}
	
		/**
		 * @private 
		 * 
		 */		
		protected function _onAnimationOutStart(e:Event):void
		{ 
			_curState = AnimationState.OUT;
			animationOutStart.dispatch();
		}
		
		/**
		 * @private 
		 * 
		 */		
		protected function _onAnimationOut(e:Event):void
		{ 
			//_view.stop();
			//_view.visible = false;
			_curState = AnimationState.OUT;
			animationOut.dispatch();
		}
		
		/**
		 * Determine if the view is in the process of animating 
		 * @return A Boolean indicating whether or not the view is in the process of animating
		 * 
		 */		
		public function get isAnimating():Boolean
		{
			return (_curState == AnimationState.IN_START || _curState == AnimationState.OUT_START) ? true : false;
		}
	}
}