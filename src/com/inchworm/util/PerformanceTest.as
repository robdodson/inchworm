package com.inchworm.util
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	public class PerformanceTest
	{
		//-----------------------------------------------------------------
		// CLASS MEMBERS
		private var outputText					:TextField;
		private var timeElapsed					:int;
		private var numberOfIterations			:int;
		
		//-----------------------------------------------------------------
		
		public function PerformanceTest(stage:Stage, color:uint = 0x000000, numberOfIterations:int = 10000)
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = color;
			
			outputText = new TextField;
			outputText.autoSize = TextFieldAutoSize.LEFT;
			outputText.defaultTextFormat = textFormat;
			stage.addChild(outputText);
		}
		
		public function log(value:String):void
		{
			if (outputText.height > 200)
			{
				outputText.text = '';
			}
			
			outputText.appendText(value + '\n');
		}
		
		public function startTest():void
		{
			timeElapsed = getTimer();
		}
		
		public function stopTest():void
		{
			timeElapsed = getTimer() - timeElapsed;
			log('Current test finished in:  ' + timeElapsed + ' ms');
		}
	}
}