package com.inchworm.net
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import org.osflash.signals.Signal;
	
	/**
	 * A URLRequest which will use POST to pass binary data (JPG, PNG, etc)
	 * 
	 * @author Justin Gaussoin
	 * 
	 */			
	public class FileUploadRequest extends EventDispatcher
	{
		//————————————————————————————————————————————————————————————————
		// CLASS MEMBERS
		private static var BOUNDARY					:String = "m3k4n1kb0und4ry";
		
		public var complete							:Signal = new Signal();
		public var error							:Signal = new Signal();
		
		private var _url							:String;
		private var _request						:URLRequest;
		
		private var _headers						:Vector.<URLRequestHeader>;
		private var _params							:Object;
		private var _fileData						:Vector.<FileUploadData>;
		
		private var _bodyData						:ByteArray;
		
		//————————————————————————————————————————————————————————————————
		
		/**
		 * A URLRequest which will use POST to pass binary data (JPG, PNG, etc)
		 * 
		 * @param url: URL where the upload should be directed
		 * 
		 */		
		public function FileUploadRequest(url:String = null)
		{
			_url = url;
			_request  = new URLRequest(url);
			_request.contentType = 'multipart/form-data; boundary=' + BOUNDARY;
			_request.method = URLRequestMethod.POST;
			_headers = new Vector.<URLRequestHeader>();
			_params = new Object();
			_fileData = new Vector.<FileUploadData>();
		}
		
		/**
		 * The request url 
		 * @return Returns the URL where the request is directed
		 * 
		 */		
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * The URLRequest object 
		 * @return Returns the actual URLRequest object
		 * 
		 */		
		public function get request():URLRequest
		{
			return _request;
		}

		/**
		 * Add an HTTP header to the URLRequest object 
		 * @param header: An HTTP header
		 * 
		 */		
		public function addHeader(header:URLRequestHeader):void
		{
			_headers.push( header );
		}
		
		/**
		 * Append optional parameters to the URLRequest 
		 * @param key: Parameter's key name
		 * @param value: Value to be stored with the associated key
		 * 
		 */		
		public function addParameter(key:String, value:*):void
		{
			_params[key] = String(value);
		}
		
		/**
		 * Add a file to the FileUploadRequest. This file must be passed in as a ByteArray.
		 * Use this method to add JPGs, PNGs, etc. to the request
		 *  
		 * @param fileData: Binary data of the file you wish to upload
		 * @param name: Name of the binary object being passed to the request
		 * @param filename: Optional filename of the binary object being passed to the request.
		 * If no filename is provided then the 'name' argument will be used in its place.
		 * 
		 */		
		public function addFileData(fileData:ByteArray, name:String, filename:String=""):void
		{
			var fileUploadData:FileUploadData = new FileUploadData();
			fileUploadData.name = name;
			fileUploadData.filename = (filename=="") ? name : filename;
			fileUploadData.data = fileData;
			_fileData.push(fileUploadData);
		}
		
		/**
		 * Instructs the FileUploadRequest to post to the HTTP upload service. This
		 * will send the binary data and listen for any errors. 
		 * 
		 */		
		public function post():void
		{
			var i:int=0;
			var bytes:String;
			
			_bodyData = new ByteArray();
			_bodyData.endian = Endian.BIG_ENDIAN;
			
			_writeHeaders();
			_writeParameters();
			_writeFiles();
			_writeEndBoundaries();
			
			_request.data = _bodyData;

			var urlLoader:URLLoader = new URLLoader();
			_addListeners(urlLoader);
			urlLoader.load(_request);
		}

		/**
		 * @private 
		 * @param loader
		 * 
		 */		
		private function _addListeners(loader:URLLoader):void
		{
			loader.addEventListener(IOErrorEvent.IO_ERROR, _onError);
			loader.addEventListener(Event.COMPLETE, _onComplete);
		}

		/**
		 * @private 
		 * @param loader
		 * 
		 */		
		private function _removeListeners(loader:URLLoader):void
		{
			loader.removeEventListener(IOErrorEvent.IO_ERROR, _onError);
			loader.removeEventListener(Event.COMPLETE, _onComplete);
		}
		
		/**
		 * @private 
		 * @param e
		 * 
		 */		
		private function _onError(e:Event):void
		{
			trace(this,"loader error:",e);
			var _loader:URLLoader = URLLoader(e.target);
			_removeListeners(_loader);
			error.dispatch();
		}
		
		/**
		 * @private 
		 * @param e
		 * 
		 */		
		private function _onComplete(e:Event):void
		{
			trace(this,"loader complete:",e);
			var _loader:URLLoader = URLLoader(e.target);
			_removeListeners(_loader);
			complete.dispatch(_loader.data);
		}
		
		/**
		 * @private 
		 * 
		 */		
		private function _writeHeaders():void
		{
			var i:int, len:int = _headers.length;
			for (i=0;i<len;i++) {
				_request.requestHeaders.push(_headers[i]);
			}
		}
		
		/**
		 * @private 
		 * 
		 */		
		private function _writeParameters():void
		{
			for(var key:String in _params) {
				_bodyData.writeUTFBytes( _getBoundary()+
					'Content-Disposition: form-data; name="' + key +
					'"\n\n'+_params[key]+'\n' );
			}
		}
		
		/**
		 * @private 
		 * @return 
		 * 
		 */		
		private function _getBoundary():String
		{
			return "--"+BOUNDARY+"\n";
		}
		
		/**
		 * @private 
		 * 
		 */		
		private function _writeFiles():void	
		{
			var i:int=0, len:int = _fileData.length;
			for (i=0;i<len;i++) {
				//Content-Disposition: form-data; name="uploadFile2"; filename="Screen shot 2010-07-30 at 1.13.17 PM.png"

				_bodyData.writeUTFBytes(_getBoundary()+'Content-Disposition: form-data; name="'+_fileData[i].name+'"; filename="'+_fileData[i].filename+'"\n');
				_bodyData.writeUTFBytes(_getContentType(_fileData[i].filename));
				_bodyData.writeBytes(_fileData[i].data, 0, _fileData[i].data.length);
				_bodyData.writeUTFBytes('\n');
				
			}
		}
		
		/**
		 * @private 
		 * @param filename
		 * @return 
		 * 
		 */		
		private function _getContentType(filename:String):String
		{
			if (filename.toLowerCase().indexOf("jpg")>0)  return 'Content-Type: image/jpeg\n\n';
			if (filename.toLowerCase().indexOf("png")>0)  return 'Content-Type: image/png\n\n';
			return 'Content-Type: application/octet-stream\n\n';
		}
		
		/**
		 * @private 
		 * 
		 */		
		private function _writeEndBoundaries():void
		{
			
			_bodyData.writeUTFBytes('--'+BOUNDARY+'--');
		}
	}
}