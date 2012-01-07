package com.inchworm.net
{
	import flash.utils.ByteArray;

	/**
	 * A data value object for uploading images
	 * @author Justin Gaussoin
	 * 
	 */	
	public class FileUploadData
	{
		public var name:String;
		public var filename:String;
		public var data:ByteArray;
		
		public function FileUploadData()
		{
			
		}
	}
}