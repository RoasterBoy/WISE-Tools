# TIL - Things I've learned

## Idea for members-only content block
```.publicContentView or .memberContentView``` is what you'll need for the CSS selector along with your custom element's class like...
```.membersOnly {display:none;}```
```.memberContentView .membersOnly {display:block;}```

See ```var bonaPage_PageView = { isAnonymousView : false,isMemberView : true,isAdminView : false };``` on logged-in page type.

## Zoom metrics

Can't use ```https://api.zoom.us/v2/metrics/meetings``` to retrieve future sessions. Grr.

## 301 Redirects
We might want to use a 301 redirect from our WordPress hosting site to Wild Apricot so that certain links still work, such as links to managing Zoom meetings, etc. See [Google Developers SEO Guide](https://developers.google.com/search/docs/advanced/crawling/301-redirects)
More to come

## Pre-filled links in Google Forms
As nice as it would be to use pre-filled links to let us set the course title and instructor names in evaluations, Forms doesn't let us restrict editing on fields, even in the pre-filled ones. So, there's a chance that the member will edit or choose something unintended.
Best to stay away from this.

## Token is expired
When ```zm``` returns results that look like this, it means that my clock is out of sync. 
```
{
  "code": 124,
    "message": "Access token is expired."
    }
```
This can happen on WSL because I don't have nts running. I can force time synchronization with the following:
```sudo ntpdate -sb time.nist.gov```
an alternative is to restart WSL.

## A tool in search of a problem
Adobe has released [Adobe PDF Embed API](https://www.adobe.io/apis/documentcloud/dcsdk/pdf-pricing.html), letting us create PDF files. This seems like a good thing, but does it do anything better that Pandoc or [wkhtmltopdf](https://wkhtmltopdf.org/)?
