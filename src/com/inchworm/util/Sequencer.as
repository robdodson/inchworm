/**
 * Modified version of Big Spaceship's SimpleSequencer. Sequencer works on Signals instead of Event strings.
 * This allows other objects to Sequence their actions without having to extend EventDispatcher 
 */

 /**
 * SimpleSequencer by Big Spaceship. 2008-2010
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2008-2010 Big Spaceship, LLC
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
package com.inchworm.util
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;
	
	public class Sequencer extends Object
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		public var completed								:Signal;
		
		private var _sequenceSteps							:Array;
		private var _currentStep							:int;
		
		private var _parallelActions						:Array;
		private var _timers									:Dictionary;
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * Sequencer creates a series of steps which execute sequentially
		 * to aid in stringing together complex actions. A sequence step
		 * can optionally contain multiple actions to be executed in parallel. 
		 * 
		 */		
		public function Sequencer()
		{
			completed = new Signal();
			_sequenceSteps = new Array();
			_timers = new Dictionary();
		}
		
		// TODO: Add getNextID method which returns the next highest ID.
		
		/**
		 * Add a step to the sequence. Sequence steps can contain single actions or
		 * multiple actions which will all be executed in parallel.
		 *  
		 * @param stepId A unique ID for the step. Steps are executed in numeric order going from smallest to largest.
		 * Optionally one can pass in the same ID for multiple steps to have all the actions in that step executed at once.
		 * @param target Target Object which is performing some kind of action during the sequence step. Usually this will
		 * be a DisplayObject which is doing some kind of animation.
		 * @param functionToCall The trigger function inside the target Object which will result in the dispatch of the
		 * signalToListen. Typically this will be a function within a DisplayObject which kicks off some kind of animation.
		 * @param signalToListen The Signal coming out of the target Object which indicates that it has completed its action.
		 * If the action is some kind of animation then this is going to be the completed Signal fired at the end of that animation.
		 * @param args Optional paramaters which can be passed to the functionToCall
		 * 
		 */		
		public function addStep(stepId:Number, target:Object, functionToCall:Function, signalToListen: Signal, args:Object = null):void
		{
			var sequenceAction:Object = {target: target, functionToCall: functionToCall, signalToListen: signalToListen, args: args};
			
			// add a sequenceAction to the prexisting sequence step if the IDs match
			var stepExists:Boolean = false;
			for(var i:int=0; i < _sequenceSteps.length; ++i)
			{
				if(_sequenceSteps[i].stepId == stepId)
				{
					_sequenceSteps[i].array.push(sequenceAction);
					stepExists = true;
				}
			}
			
			// else create a new ID & step and add the sequenceAction to it
			if(!stepExists)
			{
				_sequenceSteps.push({stepId: stepId, array: new Array(sequenceAction)});
			}
		}
		
		/**
		 * Starts the sequence.  
		 * 
		 */		
		public function start():void
		{
			if(_sequenceSteps.length > 0)
			{
				// sort sequence steps by stepId:
				_sequenceSteps.sortOn('stepId', Array.NUMERIC);

				_parallelActions = new Array();
				var i:int;
				var animObj:Object;
				var len:uint = _sequenceSteps[_currentStep].array.length;
				// go through each step in the current sequence and add a callback to its target's completed Signal
				for(i = 0; i < len; ++i)
				{
					animObj = _sequenceSteps[_currentStep].array[i];
					animObj.signalToListen.addOnce(_onAnimationComplete);
					_generateSemaphore(); // generates a locking semaphore so that steps don't execute out of sequence
				}

				// check to see if the sequenceActions have any delays, if so add them to the timer dictionary.
				// then call the sequenceActions' trigger functions, optionally passing any params.
				for(i = 0; i < len; ++i)
				{
					animObj = _sequenceSteps[_currentStep].array[0];
					(_sequenceSteps[_currentStep].array as Array).splice(0, 1); // make sure to pull the object out to prevent memory leaks
					if(animObj.args && animObj.args.hasOwnProperty('delay'))
					{
						var timer:Timer = new Timer(animObj.args.delay, 1);
						timer.addEventListener(TimerEvent.TIMER, _onTimer);
						_timers[timer] = animObj;
						timer.start();
					}
					else
					{
 						if(animObj.args)
						{
							animObj.functionToCall(animObj.args);
							//animObj.functionToCall.apply(null, animObj.args.functionToCallParams);
						}
						else
						{
							animObj.functionToCall();
						}
					}
				}
			}
			else
			{
				// If there are no step IDs left then run the sequence onComplete function
				_onComplete();
			}
		}
		
		/**
		 * @private
		 * If a previous sequenceAction had a 'delay' param then it was assigned a Timer in the _timer dictionary.
		 * Call the sequenceAction's trigger function, optionally passing any params.
		 * Remove the Timer listener and delete the Timer from the dictionary
		 * @param e TimerEvent object
		 * 
		 */		
		private function _onTimer(e:Event):void
		{
			if(_timers[e.target].args && _timers[e.target].args.hasOwnProperty('functionToCallParams'))
			{
				_timers[e.target].functionToCall.apply(null, _timers[e.target].args.functionToCallParams);
			}
			else
			{
				_timers[e.target].functionToCall();
			}
			
			e.target.removeEventListener(e.type, _onTimer);
			delete _timers[e.target];
		}
		
		/**
		 * @private
		 * Creates a semaphore lock and passes it into the parallelActions array.
		 * @return A unique Semaphore lock ID
		 * 
		 */		
		private function _generateSemaphore():String
		{
			var lock:String;
			// Create a unique ID and check to see if it already exists in the paralleActions array.
			// If it does then generate a new one and try again. If not, then push it into the array.
			do
			{ 
				lock = String(Math.random());
			}
			while(_parallelActions.indexOf(lock)>-1);
			_parallelActions.push(lock);
			return lock;
		}
		
		/**
		 * @private
		 * Called when the individual sequenceAction's fired its complete Signal.
		 * Handler is removed after execution since it was added using addOnce()
		 */		
		private function _onAnimationComplete():void
		{
			_parallelActions.pop();
			_checkSemaphores();
		}
		
		/**
		 * @private
		 * Determines if all parallel actions within a step have executed. 
		 * If so the sequence will be advanced to the next step
		 */		
		private function _checkSemaphores():void
		{
			if(_parallelActions.length < 1)
			{
				if(_currentStep + 1 < _sequenceSteps.length)
				{
					_currentStep += 1;
					//start next step
					start();
				}
				else
				{
					//all animations complete
					_onComplete();
				}
			}
		}
		
		/**
		 * @private
		 * Once all the steps in the sequence have been exhausted 
		 * dispatch a complete Signal.
		 */		
		private function _onComplete():void
		{
			completed.dispatch();
		}
	}
}