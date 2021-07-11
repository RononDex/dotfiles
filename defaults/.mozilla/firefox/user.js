// Don't allow websites to prevent use of right-click, 
// or otherwise messing with the context menu.
user_pref("dom.event.contextmenu.enabled", false);

// Don't allow websites to prevent copy and paste.
// Disable notifications of copy, paste, or cut functions. 
// Stop webpage knowing which part of the page had been selected.
user_pref("dom.event.clipboardevents.enabled", false);

// Show punycode. Help protect from character 'spoofing' eg:
// xn--80ak6aa92e.com -> аррӏе.com
// [IDN homograph attacks](https://www.xudongz.com/blog/2017/idn-phishing/)
user_pref("network.IDN_show_punycode", true);

// Disable site reading installed plugins.
user_pref("plugins.enumerable_names", "");

// Tells website where you came from. Disabling may break some sites.
// 0 = Disable referrer headers. 
// 1 = Send only on clicked links.
// 2 = (default) Send for links and image.
user_pref("network.http.sendRefererHeader", 0);
        
// Disable referrer headers between https websites.
user_pref("network.http.sendSecureXSiteReferrer", false);
		
// Send fake referrer (if choose to send referrers).
user_pref("network.http.referer.spoofSource", true);
		
// Mozilla’s built in tracking protection.
user_pref("privacy.trackingprotection.enabled", true);

// Disables geolocation and firefox logging geolocation requests.
user_pref("geo.enabled", false);
user_pref("geo.wifi.uri", "");
user_pref("browser.search.geoip.url", "");


// Disable Google Safe Browsing and malware and phishing protection.
// Stop sending links and downloading lists from google.	
// Security risk, but privacy improvement.
// Note: this list may be incomplete as firefox updates, be sure to search for browser.safebrowsing.provider.google*
// Also simply setting safebrowsing.*.enabled to false should make setting the URL's to "" redundant, but better to be safe.
// If you see anything pointing google, probably best to nuke it.
user_pref("browser.safebrowsing.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.safebrowsing.malware.enabled", false);	
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.provider.google4.dataSharing.enabled", "");
user_pref("browser.safebrowsing.provider.google4.updateURL", "");
user_pref("browser.safebrowsing.provider.google4.reportURL", "");
user_pref("browser.safebrowsing.provider.google4.reportPhishMistakeURL", "");
user_pref("browser.safebrowsing.provider.google4.reportMalwareMistakeURL", "");
user_pref("browser.safebrowsing.provider.google4.lists", "");
user_pref("browser.safebrowsing.provider.google4.gethashURL", "");
user_pref("browser.safebrowsing.provider.google4.dataSharingURL", "");
user_pref("browser.safebrowsing.provider.google4.dataSharing.enabled", false);
user_pref("browser.safebrowsing.provider.google4.advisoryURL", "");
user_pref("browser.safebrowsing.provider.google4.advisoryName", "");
user_pref("browser.safebrowsing.provider.google.updateURL", "");
user_pref("browser.safebrowsing.provider.google.reportURL", "");
user_pref("browser.safebrowsing.provider.google.reportPhishMistakeURL", "");
user_pref("browser.safebrowsing.provider.google.reportMalwareMistakeURL", "");
user_pref("browser.safebrowsing.provider.google.pver", "");
user_pref("browser.safebrowsing.provider.google.lists", "");
user_pref("browser.safebrowsing.provider.google.gethashURL", "");
user_pref("browser.safebrowsing.provider.google.advisoryURL", "");
user_pref("browser.safebrowsing.downloads.remote.url", "");


// Can call home to every time firefox is started or home page is visited.
// https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections
// http://kb.mozillazine.org/Connections_established_on_startup_-_Firefox
user_pref("browser.selfsupport.url", "");
user_pref("browser.aboutHomeSnippets.updateUrL", "");
user_pref("browser.startup.homepage_override.mstone", ignore);
user_pref("browser.startup.homepage_override.buildID", "");
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");
user_pref("startup.homepage_override_url", "");


user_pref("toolkit.telemetry.cachedClientID", "");

// Prevent website tracking clicks.
user_pref("browser.send_pings", false);
		
// Only send pings if send and receiving host match (same website).
user_pref("browser.send_pings.require_same_host", true);

// Disable website reading how much battery your mobile device or laptop has.
user_pref("dom.battery.enabled", false);

// Link prefetching is when a webpage hints to the browser that certain pages are likely to be visited, 
// so the browser downloads them immediately so they can be displayed immediately when the user requests it. 
user_pref("network.predictor.enabled", false);
user_pref("network.dns.disablePrefetch", true);   
user_pref("network.prefetch-next", false);

// Disable prefetch link on hover.
user_pref("network.http.speculative-parallel-limit", 0);
	
// WebSockets is a technology that makes it possible to open an interactive communication 
// session between the user's browser and a server. (May leak IP when using proxy/VPN)
user_pref("media.peerconnection.enabled", false);    
user_pref("network.websocket.enabled", false);

// Disable 3rd party closed-source Pocket integration.
// Note, this is browser.pocket.enabled for older versions of firefox
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.pocket.site", "");
user_pref("extensions.pocket.oAuthConsumerKey", "");
user_pref("extensions.pocket.api", "");
