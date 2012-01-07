package com.inchworm.display.views
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.inchworm.display.animation.AnimationInOut;
	import com.inchworm.display.animation.AnimationState;
	
	import flash.events.Event;
	
	/**
	 * A destroyable view which implements an AnimationInOut object to keep track of its state.
	 * The InOutTweenView is meant to be the base class for one of your view classes created
	 * in the Flash IDE. Rather than relying on the MovieClip's timeline, the InOutTweenView
	 * uses a TimelineMax timeline to help easily automate transitions. In and Out animations are
	 * defined by overriding the _buildTimeline method. Otherwise a default fade in/out animation
	 * is used.
	 * 
	 * @author Rob Dodson
	 * 
	 */	
	public class InOutTweenView extends AbstractView
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		
		protected var _inOut					:AnimationInOut;
		
		protected var _timeline					:TimelineMax;
		protected var _timelineInDefined		:Boolean;
		protected var _timelineOutDefined		:Boolean;
		
		internal var animationInStart			:Event;
		internal var animationIn				:Event;
		internal var animationOutStart			:Event;
		internal var animationOut				:Event;
		
		//————————————————————————————————————————————————————————————————
		
		/**
	 	 * A destroyable view which implements an AnimationInOut object to keep track of its state.
		 * The InOutTweenView is meant to be the base class for one of your view classes created
		 * in the Flash IDE. Rather than relying on the MovieClip's timeline, the InOutTweenView
		 * uses a TimelineMax timeline to help easily automate transitions. In and Out animations are
		 * defined by overriding the _buildTimeline method. Otherwise a default fade in/out animation
		 * is used.
		 * 
		 */		
		public function InOutTweenView()
		{
			super();
			
			// These Signals are used by the TimelineMax
			// to mimic the actual timeline signals/events
			// of a MovieClip built in the Flash IDE
			_timeline = new TimelineMax();
			animationInStart = new Event(AnimationState.IN_START);
			animationIn = new Event(AnimationState.IN);
			animationOutStart = new Event(AnimationState.OUT_START);
			animationOut = new Event(AnimationState.OUT);
			
			_inOut = new AnimationInOut(this);
			_inOut.animationInStart.add(_onAnimationInStart);
			_inOut.animationIn.add(_onAnimationIn);
			_inOut.animationOutStart.add(_onAnimationOutStart);
			_inOut.animationOut.add(_onAnimationOut);
		}
		
		public function defineIn(tl:TimelineMax = null):void
		{
			if (!tl) {
				tl = new TimelineMax();
				tl.append(new TweenMax(this, 1, { autoAlpha: 1 }));
			}
			
			_timeline.addLabel('INIT', 0);
			_timeline.addLabel('IN_START', 1);
			_timeline.addLabel('IN', tl.duration + 3);
			_timeline.addCallback(dispatchEvent, 'IN_START', [animationInStart]);
			_timeline.addCallback(dispatchEvent, 'IN', [animationIn]);
			tl.vars.onComplete = _gotoLabel;
			tl.vars.onCompleteParams = ['IN']; 
			_timeline.insert(tl, 'IN_START');
			_timeline.gotoAndStop('INIT');
			_timelineInDefined = true;
		}
		
		public function defineOut(tl:TimelineMax = null):void
		{
			if (!tl) {
				tl = new TimelineMax();
				tl.append(new TweenMax(this, 1, { autoAlpha: 0 }));
			}
			
			// DONT_COMPLETE label prevents the TimelineMax 
			// from completing. There's a bug in TimelineMax which
			// prevents the callback functions for the last label from executing
			// if the timelie completes on that label. DONT_COMPLETE is just used
			// as a spacer so that the TimelineMax can properly reach its
			// OUT label.
			_timeline.addLabel('OUT_START', _timeline.duration + 1);
			_timeline.addLabel('OUT', _timeline.duration + tl.duration + 3);
			_timeline.addLabel('DONT_COMPLETE', _timeline.duration + 3);
			_timeline.addCallback(dispatchEvent, 'OUT_START', [animationOutStart]);
			_timeline.addCallback(dispatchEvent, 'OUT', [animationOut]);
			tl.vars.onComplete = _gotoLabel;
			tl.vars.onCompleteParams = ['OUT']; 
			_timeline.insert(tl, 'OUT_START');
			_timeline.insert(new TweenMax(this, 1, { autoAlpha: 0 }), 'DONT_COMPLETE');
			_timelineOutDefined = true;
		}
		
		/**
		 * @private 
		 * @param label
		 * 
		 */		
		protected function _gotoLabel(label:String):void
		{
			_timeline.gotoAndStop(label, false);
		}
		
		/**
		 * Overriding gotoAndPlay to delegate the action to the TimelineMax timeline
		 * rather than the MovieClip's actual timeline. 
		 * @param frame
		 * @param scene
		 * 
		 */		
		override public function gotoAndPlay(frame:Object, scene:String=null):void
		{
			if (frame == "IN_START" && !_timelineInDefined)
			{
				defineIn();
			}
			else if (frame == "OUT_START" && !_timelineOutDefined)
			{
				defineOut();
			}
			
			
			_timeline.gotoAndPlay(frame, false);
		}
		
		/**
		 * Overriding gotoAndStop to delegate the action to the TimelineMax timeline
		 * rather than the MovieClip's actual timeline.
		 * @param frame
		 * @param scene
		 * 
		 */		
		override public function gotoAndStop(frame:Object, scene:String=null):void
		{
			_timeline.gotoAndStop(frame, false);
		}
		
		/**
		 * Instruct the view to animate in. This will send the TimelineMax object to its
		 * 'IN_START' frame. 
		 * 
		 */		
		override public function animateIn(callback:Function = null):void
		{
			super.animateIn(callback);
			_inOut.animateIn();
		}
		
		/**
		 * Instruct the view to animate out. This will send the TimelineMax object to its
		 * 'OUT_START' frame. 
		 * 
		 */		
		override public function animateOut(callback:Function = null):void
		{
			super.animateOut(callback);
			_inOut.animateOut();
		}
		
		/**
		 * Protected function which can be overriden if additional behavior is required 
		 * 
		 */		
		protected function _onAnimationInStart():void
		{
			trace(this, "inStart dispatching");
			this.inStart.dispatch();
		}
		
		/**
		 * Protected function which can be overriden if additional behavior is required 
		 * 
		 */		
		protected function _onAnimationIn():void
		{
			trace(this, "inComplete dispatching");
			this.inComplete.dispatch();
			if (_inCallback != null) _inCallback.call(null, this);
		}
		
		/**
		 * Protected function which can be overriden if additional behavior is required 
		 * 
		 */		
		protected function _onAnimationOutStart():void
		{
			trace(this, "outStart dispatching"); 
			this.outStart.dispatch();
		}
		
		/**
		 * Protected function which can be overriden if additional behavior is required 
		 * 
		 */		
		protected function _onAnimationOut():void
		{
			trace(this, "outComplete dispatching");
			this.outComplete.dispatch();
			if (_outCallback != null) _outCallback.call(null, this);
		}
		
		override public function destroy():void
		{
			_timeline.clear();
			_timeline = null;
			super.destroy();
		}
	}
}