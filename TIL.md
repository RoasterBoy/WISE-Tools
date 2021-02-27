# TIL - Things I've learned

## WA Javascript, CSS, 'n stuff

Idea for members-only content block
```.publicContentView or .memberContentView``` is what you'll need for the CSS selector along with your custom element's class like...
```.membersOnly {display:none;}```
```.memberContentView .membersOnly {display:block;}```

See ```var bonaPage_PageView = { isAnonymousView : false,isMemberView : true,isAdminView : false };``` on logged-in page type.
