package com.inchworm.util
{
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * A collection of easy to use sharing links. 
	 * @author Justin Gaussoin
	 * 
	 */	
	public class SharingUtil
	{
		/**
		 * Share a site to MySpace 
		 * @param url: Link to the site you are sharing
		 * @param title: Title of the post
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */		
		public static function myspace(url:String, title:String, window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://www.myspace.com/Modules/PostTo/Pages/?t='+escape(title)+'&c=&u='+escape(url)),window);
		}
		
		/**
		 * Share a site to StumbleUpon
		 * @param url: Link to the site you are sharing
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */		
		public static function stumbleupon(url:String, window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://www.stumbleupon.com/submit?url='+escape(url)),window);
		}
		
		/**
		 * Share a site to Digg 
		 * @param url: Link to the site you are sharing
		 * @param title: Title of the post
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */		
		public static function digg(url:String, title:String, window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://digg.com/submit?url='+escape(url)+'&title='+escape(title)),window);
		}
		
		/**
		 * Share a site to Delicious 
		 * @param url: Link to the site you are sharing
		 * @param title: Title of the post
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */	
		public static function delicious(url:String, title:String, window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://del.icio.us/loginName?url='+escape(url)+'&title='+escape(title)+'&v=4'),window);
		}
		
		/**
		 * Share a site to Facebook 
		 * @param url: Link to the site you are sharing
		 * @param title: Title of the post
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */	
		public static function facebook(url:String, title:String, window:String="_blank"):void
		{
			if(!url)return;
			var regExp:RegExp = /\//g;
			url = escape(url).replace(regExp,"%2F");
			
			title = escape(title);
			navigateToURL(new URLRequest('http://www.facebook.com/sharer.php?u='+url+'&t='+title),window);
		}
		
		/**
		 * Share a site to Reddit 
		 * @param url: Link to the site you are sharing
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */	
		public static function reddit(url:String, window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest("http://www.reddit.com/submit?url="+escape(url)),window);
		}
		
		/**
		 * Share a site to Furl 
		 * @param url: Link to the site you are sharing
		 * @param title: Title of the post
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */		
		public static function furl(url:String, title:String, window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://www.furl.net/storeIt.jsp?u='+escape(url)+'&keywords=&t='+escape(title)),window);
		}
		
		/**
		 * Share a site to WindowsLive 
		 * @param url: Link to the site you are sharing
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */	
		public static function winlive(url:String, window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('https://favorites.live.com/quickadd.aspx?url='+escape(url)),window);
		}
		
		/**
		 * Share a site to Technorati 
		 * @param url: Link to the site you are sharing
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */		
		public static function technorati(url:String, window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://www.technorati.com/faves/loginName?add='+escape(url)),window);
		}
		
		/**
		 * Share a site to Twitter 
		 * @param url: Link to the site you are sharing
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */		
		public static function twitter(url:String, window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://twitter.com/home?status='+(url)),window);
		}
		
		/**
		 * Share a site to Mister Wong 
		 * @param url: Link to the site you are sharing
		 * @param title: Title of the post
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */	
		public static function mrwong(url:String, description:String, window:String="_blank"):void
		{
			if(!url)return;
			if(!description)return;
			navigateToURL(new URLRequest('http://www.mister-wong.com/index.php?action=addurl&bm_url='+escape(url)+'&bm_description='+escape(description)),window);
		}
		
		/**
		 * Share a site to Sphinn 
		 * @param url: Link to the site you are sharing
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */		
		public static function sphinn(url:String, window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://sphinn.com/submit.php?url='+escape(url)),window);
		}
		
		/**
		 * Share a site to Ask 
		 * @param url: Link to the site you are sharing
		 * @param title: Title of the post
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */		
		public static function ask(url:String, title:String, window:String="_blank"):void
		{
			if(!url)return;
			if(!title)return;
			navigateToURL(new URLRequest('http://myjeeves.ask.com/mysearch/BookmarkIt?v=1.2&t=webpages&url='+escape(url)+'&title='+escape(title)),window);
		}
		
		/**
		 * Share a site to Slashdot 
		 * @param url: Link to the site you are sharing
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */		
		public static function slashdot(url:String, window:String="_blank"):void
		{
			if(!url)return;
			navigateToURL(new URLRequest('http://slashdot.org/bookmark.pl?url='+escape(url)),window);
		}
		
		/**
		 * Share a site to NewsVine 
		 * @param url: Link to the site you are sharing
		 * @param title: Title of the post
		 * @param window: Defines what type of window the request should open in. Defaults to '_blank'
		 * 
		 */	
		public static function newsvine(url:String, title:String, window:String="_blank"):void
		{
			if(!url)return;
			if(!title)return;
			navigateToURL(new URLRequest('http://www.newsvine.com/_tools/seed&save?u='+escape(url)+'&h='+escape(title)),window);
		}
	}
}