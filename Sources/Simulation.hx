package ;

import Input;
import Resource;
import kha.Canvas;
import kha.Scheduler;
import kha.System;


import GameState;

class Simulation 
{
	private  var mCurrentState:GameState;
	private var mPause:Bool;
	private var mNextState:GameState;
	private var mChangeState:Bool;
	
	private  var initialState:Class<GameState>;
	
	var mResources:Resources;
	
	public static var i:Simulation;
	
	//////////////////////////////////////////////////////////////////////		
	public function new(aInitialState:Class<GameState>) 
	{
		initialState=aInitialState;
		i = this;
		/// Register services
		mResources = new Resources();
		//mCurrentState = new GameState();
		Input.init();

		init();
		
	}
	
	private function init():Void 
	{
		changeState(Type.createInstance(initialState, []));
		initialState = null;
		
		
		//stage.addEventListener(Event.ACTIVATE, onActive);
		//stage.addEventListener(Event.DEACTIVATE, onDeactivate);
		
	}
	
	
	
	private function onDeactivate():Void 
	{
		if (mCurrentState != null)
		{
			mCurrentState.onDesactivate();
		}
	}
	
	private function onActive():Void 
	{
		if (mCurrentState != null)
		{
			mCurrentState.onActivate();
		}
	}
	
	private var mFrameByFrameTime:Float = 0;
	private var mLastFrameTime:Float=0;
	public function onEnterFrame():Void 
	{
		if (!mPause) {
			var time = Scheduler.realTime();
			mFrameByFrameTime =  time- mLastFrameTime;
			mLastFrameTime = time;
			
			if (mFrameByFrameTime <= 0||mFrameByFrameTime>0.06666)
			{
				mFrameByFrameTime = 1 / 60;
			}
			TimeManager.setDelta(mFrameByFrameTime);
			update( mFrameByFrameTime );
			
		
			Input.i.update();
		}
	}
	public function onRender(aFramebuffer:Canvas) 
	{	
		if (uploadTextures)
		{
			mCurrentState.init();
			uploadTextures = false;
			initialized = true;
			return;
		}
		if (mChangeState)
		{
			mChangeState = false;
			loadState(mNextState);
			mNextState = null;
			return;
			
		}
		if (!initialized) return;
		mCurrentState.render();
		mCurrentState.draw(aFramebuffer);
	}

	private function update(aDt:Float):Void
	{
		if (!initialized) return;
		
		mCurrentState.update(aDt);
	}
	
	//////////////////////////////////////////////////////////////////////
	private function loadState(state:GameState):Void
	{
			initialized = false;
			if (mCurrentState!=null)
			{
				mCurrentState.destroy();
				mResources.unload();
			}
			mCurrentState = state;
			mCurrentState.load(mResources);
			if (!mResources.isAllLoaded())
			{
				mResources.load(initState);
			}else {
				initState();
			}
		//	mResources.checkFinishLoading();
	}
	private var initialized:Bool = false;
	private var uploadTextures:Bool = false;
	private function initState():Void
	{
		uploadTextures = true;
		//mCurrentState.init();
	}
	
	public function changeState(state:GameState):Void
	{
		mChangeState = true;
		mNextState = state;
		
	}
	public function pause():Void
	{
		mPause = true;
	}
	public function unpause():Void
	{
		mPause = false;
	}
	
}