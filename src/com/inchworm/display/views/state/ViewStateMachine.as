package com.inchworm.display.views.state
{
	import com.inchworm.display.views.AbstractView;
	import com.inchworm.util.Sequencer;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import org.osflash.signals.Signal;
	
	/**
	 * ViewStateMachine serves as a view manager and handles changing application view states.
	 * The view state machine acts as the parent view and contains classes which subclass AbstractView 
	 * 
	 * @author Rob Dodson
	 * @author Manuel Gonzalez
	 * 
	 */	
	public class ViewStateMachine extends AbstractView implements IViewStateMachine
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		private var _addViewsStarted			:Signal;
		private var _addViewsCompleted			:Signal;
		private var _removeViewsStarted			:Signal;
		private var _removeViewsCompleted		:Signal;
		
		protected var _container				:DisplayObjectContainer;
		protected var _state					:String;
		
		protected var _viewList					:Array; 
		protected var _viewsToBeRemoved			:Array;
		protected var _viewsToBeAdded			:Array;
		protected var _removeSequence			:Sequencer;
		protected var _addSequence				:Sequencer;
		protected var _sequence					:String;
		
		//————————————————————————————————————————————————————————————————
		
		public function ViewStateMachine()
		{
			super();
			
			_container = this;
			_viewList = [];
		}
		
		public function addView(ViewClass:Class, states:Array, viewDepth:int = -1):void // TODO: Add alwaysOnTop/Bottom param
		{
			trace("adding view with states:", states);
			
			// Ensure that the Class being submitted extends AbstractView. This 
			// guarantees that it will have in/out Signals as well as proper callback functions and
			// animateIn/Out methods.
			
			// TODO: This should probably use an interface instead of an abstract class
			var classDescription:XML = describeType(ViewClass);
			var requiredAbstractClass:String = getQualifiedClassName(AbstractView);
			if(!classDescription.factory.extendsClass.(@type == requiredAbstractClass).length() != 0)
			{
				throw new Error('View of type: ' + ViewClass.toString() + 'must extend com.inchworm.display.views.AbstractView');
			}
			
			// Make sure that the Class being submitted does not
			// already have an entry in the view list.
			var isClassAlreadyListed:Boolean = false;
			var len:int = _viewList.length;
			for(var i:int=0; i < len; i++) 
			{
				if(_viewList[i].viewClass == ViewClass) 
				{
					isClassAlreadyListed = true;
					trace(this, ' Warning: Class is already in view list: ' + ViewClass.toString());
					break;
				}
			}
			
			// If the Class does not already exist in the view list go ahead
			// and add it as a property of an anonymous Object.
			if(!isClassAlreadyListed) 
			{
				_viewList.push(new ViewState(ViewClass, states, viewDepth));
			}
		}
		
		public function updateViewState(updateParams:Object):void 
		{
			// Verify that a valid state was passed in and set it as the target state
			if(!updateParams.hasOwnProperty('state')) throw new ArgumentError("Method requires a valid state property in its argument Object. Example: updateViewState({state: 'SomeState'})");
			
			_state = updateParams.state;
			
			// Check if the user passed in a sequence param. The sequence param determines how the transition sequencers 
			// will run (either sequentially or in parallel);
			if(updateParams.hasOwnProperty('sequence'))
			{
				if(updateParams.sequence == ViewSequence.SEQUENTIAL || updateParams.sequence == ViewSequence.PARALLEL)
				{
					_sequence = updateParams.sequence;
				}
				else
				{
					throw new ArgumentError('Invalid sequence parameter of: '+ "'" + updateParams.sequence + "'" +'. Sequence parameter must be either SEQUENTIAL or PARALLEL. See ViewSequence.as');
				}
			}
			else
			{
				// If the user didn't bother to pass in a sequence argument then just default to sequential
				_sequence = ViewSequence.SEQUENTIAL;
			}
			
			_viewsToBeRemoved = [];
			_viewsToBeAdded = [];
			
			// Go through the viewList and for each view determine if it should be 'IN'
			// during the state which we're transitioning to. If not, then push it into
			// the list of views to be removed else push it into the list of
			// views to be added. When adding views the state machine will check to see
			// if the view is already on stage. If it is, then it is left alone. 
			var len:int = _viewList.length;
			for(var i:int = 0; i < len; i++) 
			{
				var viewState:ViewState = _viewList[i];
				
				if(viewState.doesViewBelongToState(_state)) 
				{
					_viewsToBeAdded.push(_viewList[i]);
				}
				else
				{
					_viewsToBeRemoved.push(_viewList[i])
				}
			}
			
			_createNewViews();
			_removeOldViews();
			if(_sequence == ViewSequence.PARALLEL) _addNewViews();
		}
		
		protected function _removeOldViews():void
		{
			_removeSequence = new Sequencer();
			_removeSequence.completed.addOnce(_onRemoveViewsCompleted);
			
			// Check to see if the view is already on stage.
			// If so remove it.
			var len:int = _viewsToBeRemoved.length;
			for(var i:int = 0; i < len; i++)
			{
				var viewState:ViewState = _viewsToBeRemoved[i]; 
				if(_isViewOnStage(viewState.viewClass))
				{
					var index:Number = _getViewChildIndex(viewState.viewClass);
					if(!isNaN(index))
					{
						var oldView:AbstractView = AbstractView(_container.getChildAt(index));
						_removeSequence.addStep(1, oldView, oldView.animateOut, oldView.outComplete, this.destroyView); // FIXME: AbstractView doesn't actually dispatch outComplete signals. It is up to the implementation to do that. So this could potentially eff things up.
					}
				}
			}
			
			_removeSequence.start();
			removeViewsStarted.dispatch();
		}
		
		protected function _isViewOnStage(ViewClass:Class):Boolean
		{
			// Utility function which checks to see if a view is on stage.
			var childrenLength:int = _container.numChildren;
			for(var i:int = 0; i < childrenLength; i++) 
			{
				if(_container.getChildAt(i) is ViewClass )
				{
					return true;
				}
			}
			
			return false;
		}
		
		protected function _getViewChildIndex(ViewClass:Class):Number
		{
			var index:Number;
			var len:int = _container.numChildren;
			for(var i:int = 0; i < len; i++) 
			{
				if(_container.getChildAt(i) is ViewClass)
				{
					index = i;
				}
			}
			
			if(isNaN(index))
			{
				trace(this, ' Warning: Attempt to remove Class but Class is not on DisplayList: ' + ViewClass.toString());
			}
			
			return index;
		}
		
		protected function _onRemoveViewsCompleted():void
		{
			_removeSequence = null;
			removeViewsCompleted.dispatch();
			if(_sequence == ViewSequence.SEQUENTIAL) _addNewViews();
		}
		
		protected function _createNewViews():void
		{
			_addSequence = new Sequencer();
			_addSequence.completed.addOnce(_onAddViewsCompleted);
			
			// Check to see if the view is already on stage.
			// If not add it.
			var len:int = _viewsToBeAdded.length;
			for(var i:int = 0; i < len; i++)
			{
				var viewState:ViewState = _viewsToBeAdded[i]; 
				if(!_isViewOnStage(viewState.viewClass))
				{
					var ViewClass:Class = viewState.viewClass;
					var newView:AbstractView = new ViewClass();
					if(viewState.depth > -1)
					{
						_container.addChildAt(newView, viewState.depth);
					}
					else
					{
						_container.addChild(newView);	
					}
					_addSequence.addStep(1, newView, newView.animateIn, newView.inComplete); // FIXME: AbstractView doesn't actually dispatch inComplete signals. It is up to the implementation to do that. So this could potentially eff things up.
				}
			}
		}
		
		protected function _addNewViews():void
		{
			_addSequence.start();
			addViewsStarted.dispatch();
		}
		
		protected function _onAddViewsCompleted():void
		{
			_addSequence = null;
			addViewsCompleted.dispatch();
		}
		
		public function destroyView(view:AbstractView):void
		{
			trace(this, ' destroying view: ', view);
			view.destroy();
			view = null;
		}

		public function get state():String
		{
			return _state;
		}

		public function get addViewsStarted():Signal
		{
			return _addViewsStarted ||= new Signal();
		}

		public function get addViewsCompleted():Signal
		{
			return _addViewsCompleted ||= new Signal();
		}

		public function get removeViewsStarted():Signal
		{
			return _removeViewsStarted ||= new Signal();
		}

		public function get removeViewsCompleted():Signal
		{
			return _removeViewsCompleted ||= new Signal();
		}
	}
}