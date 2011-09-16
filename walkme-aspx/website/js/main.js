
var g_popupBG = document.getElementById("popupbg");

function showPopup(strID){
    var popup = document.getElementById(strID);
    g_popupBG.style.display = "block";    
    popup.style.display = "block"; 
    sizePopupBG();
}

function hidePopup(strID){
    var popup = document.getElementById(strID);
    g_popupBG.style.display = "none";    
    popup.style.display = "none"; 
}
function targetURL(strURL)
{
    window.location.href=strURL;
}
function sizePopupBG(){
    g_popupBG.style.height = getWindowHeight() + "px";
    g_popupBG.style.width = getWindowWidth() + "px";
}

function changeCssClass(obj, cssClass){
    obj.className = cssClass;
}

var g_ismouseover = false;
function doNavMousover(obj){
     if (!g_ismouseover){
        
        if (obj.className.indexOf("-on") == -1){
            if (obj.className.indexOf("rt") == -1)
                changeCssClass(obj,'nav-item-hvr');
            else
                changeCssClass(obj,'nav-item-hvr rt');
        }    
        
        g_ismouseover = true;
     }
}
function doStrtNavMousover(obj){
     if (!g_ismouseover){
        
        if (obj.className.indexOf("-on") == -1){
                changeCssClass(obj,'nav-item-strt-hvr');
        }    
        
        g_ismouseover = true;
     }
}
function doStrtNavMousout(obj)
{
    if (obj.className.indexOf("-on") == -1){
            changeCssClass(obj,'nav-item-strt');
    }
    g_ismouseover = false;

}

function doEndNavMousover(obj){
     if (!g_ismouseover){
        
        if (obj.className.indexOf("-on") == -1){
                changeCssClass(obj,'nav-item-end-hvr');
        }    
        
        g_ismouseover = true;
     }
}
function doEndNavMousout(obj)
{
    if (obj.className.indexOf("-on") == -1){
            changeCssClass(obj,'nav-item-end');
    }
    g_ismouseover = false;

}

function doNavMousout(obj){
    if (obj.className.indexOf("-on") == -1){
        if (obj.className.indexOf("rt") == -1)
            changeCssClass(obj,'nav-item');
        else
            changeCssClass(obj,'nav-item rt');
    }
    g_ismouseover = false;
}

var g_delayTimer = null;

function delayHide(objId)
{
    g_delayTimer = setTimeout(function(){hideObj(document.getElementById(objId))},5000);
}
function hideObj(obj)
{
    obj.style.display = "none";
}

function getWindowHeight(){
    if (typeof window.innerHeight!='undefined'){
        return window.innerHeight;
    }
    if (document.documentElement && typeof document.documentElement.clientWidth!='undefined' && document.documentElement.clientHeight!=0){
        return document.documentElement.clientHeight;
    }
    if (document.body && typeof document.body.clientWidth!='undefined'){
        return document.body.clientHeight;
    }
    return (800);
}

function getWindowWidth(){
    if (typeof window.innerWidth!='undefined'){
        return window.innerWidth;
    }
    if (document.documentElement && typeof document.documentElement.clientWidth!=0 && document.documentElement.clientHeight!='undefined'){
        return document.documentElement.clientWidth;
    }
    if (document.body && typeof document.body.clientHeight!='undefined'){
        return document.body.clientWidth;
    }
    return (600);
}
function confirmation(strUrl,strText) {
	var answer = confirm(strText)
	if (answer){
		window.location = strUrl;
		return;
	}
	else{
		return;
	}
}


function showPopup(obj,evt,strText)
{
    var popup = document.getElementById("hvmdl_popup");   
    
   
    var popup_cntnt = document.getElementById("popup_cntnt");
    var pos = getPos(obj);
    
    //document.documentElement.insertBefore(popup,document.documentElement.firstChild);
    
    popup.style.top =  pos[1] - 20 + "px";
    popup.style.left = pos[0] + obj.offsetWidth + 20 + "px";
    
    popup_cntnt.innerHTML = strText;
    
    popup.style.display = "block"; 
}

function getPos(obj)
{
    var x = 0;
    var y = 0;
    if (obj.offsetParent) {
        do {
            x += obj.offsetLeft;
            y += obj.offsetTop;
        } while (obj = obj.offsetParent);
    }
    return [x,y];
}
          
function valRequiredForm(source, arguments)
{
    if (arguments.Value.length > 0)
    {
       arguments.IsValid  = true;
       highlightTableRow(source,arguments);
    }
    else
    {
       arguments.IsValid  = false;
       highlightTableRow(source,arguments);
    }
}
function valRegexForm(source, arguments)
{
    var allowNull = eval(source.getAttribute("AllowNull"));
    var errs = source.getElementsByTagName("DIV");
   
    
    if (allowNull == false)
    {
        if (arguments.Value.length == 0)
        {
            
            arguments.IsValid = false;
            highlightTableRow(source,arguments);
            errs[0].style.display = "block";
            errs[1].style.display = "none";
            return;
        }
        else
        {
            var isMatch = checkRegexMatch(arguments, source.getAttribute("ValidationExpression"));
    
            if (isMatch)
            {
                arguments.IsValid  = true;
                highlightTableRow(source,arguments);
                errs[0].style.display = "none";
                errs[1].style.display = "none";
            }
            else
            {
                arguments.IsValid  = false;
                highlightTableRow(source,arguments);
                errs[0].style.display = "none";
                errs[1].style.display = "block";
            }
        }
    }
    else
    {
            var isMatch = checkRegexMatch(arguments, source.getAttribute("ValidationExpression"));
    
            if (isMatch)
            {
                arguments.IsValid  = true;
                highlightTableRow(source,arguments);
                errs[0].style.display = "none";
                errs[1].style.display = "none";
            }
            else
            {
                arguments.IsValid  = false;
                highlightTableRow(source,arguments);
                errs[0].style.display = "none";
                errs[1].style.display = "block";
            }
    }
}



function checkRegexMatch(args, regex) {
  var re = new RegExp(regex);
  if (args.Value.match(re)) {
    return true;
  } else {
    return false;
  }
}

function highlightTableRow(source,arguments)
{
    var src = source.parentNode;
    var highlightTarget = source.HighlightTarget.toUpperCase();
    
    if (highlightTarget == null)
        highlightTarget = "TR";
    
    
    while(src.tagName != highlightTarget)
    {
        src = src.parentNode;
    }
    
    if (arguments.IsValid)
        src.className = "tr";
    else
        src.className = "error-tr";
    
}
function validateForm(source, arguments)
{
  
  var obj = document.getElementById(source.id);
  var oTR = obj.parentNode.parentNode.parentNode;
  
  if (!obj.parentNode.isvalid)
    oTR.style.backgroundColor = "#FFFBD3";
  else
    oTR.style.backgroundColor = "#FFF";

}




var g_menuMouseOutTimer = null;
var g_isMouseover = false;
var g_menuFrame = null;

function bookMarkClick(obj)
{
    g_menuFrame = obj;
    var objMenu = document.getElementById("bookmark_menu");
    if (objMenu.className == "bookmark-menu-on")
    {
        objMenu.className = "bookmark-menu";
        obj.className = "dropdown-frame";
        g_isMouseover = true;
    }
    else
    {
        objMenu.className = "bookmark-menu-on";
        g_isMouseover = true;
    }
}


function bookMarkMenuMouseOver(obj)
{
    if (!g_isMouseover)
    {
        changeCssClass(obj,"dropdown-frame-hvr");
        g_isMouseover = true;
    }
    
        
        
}
function bookMarkMenuMouseOut(evt,obj)
{
    
    var objMenu = document.getElementById("bookmark_menu");
    if (objMenu.className != "bookmark-menu-on")
    {
        changeCssClass(obj,'dropdown-frame')
        g_isMouseover = false;
    }
    else
    {
        menuMouseOut(evt,obj);
    }
   
}

var g_isMenuMouseover = false;

function menuMouseOver(evt,obj)
{
    evt.cancelBubble = true;
    
    if (!g_isMenuMouseover)
    {
        if (g_menuMouseOutTimer != null)
            clearTimeout(g_menuMouseOutTimer);
            
        g_isMenuMouseover = true;
    }     
}


function menuMouseOut(evt,obj)
{
    evt.cancelBubble = true;
    
    var objMenu = document.getElementById("bookmark_menu");
    g_menuMouseOutTimer = setTimeout(function(){changeCssClass(objMenu,"bookmark-menu")},1000);
    changeCssClass(g_menuFrame,'dropdown-frame');
    g_isMenuMouseover = false;
    
}
       
       
       
var g_hvmdl_popup = document.getElementById("hvmdl_popup_1");
var g_hvmdl = document.getElementById("hvmdl_1");
var g_evntElement;
var g_t = null;
var g_isMouseover = false;

function hvmdl_showPopUp(evntElement){
    if (evntElement != null)
        g_evntElement = evntElement;
    
    if (g_t != null)
        clearTimeout(g_t);
    
    if (!g_isMouseover){
        g_hvmdl_popup.style.display = "block";
        g_hvmdl_popup.style.top = hvmdl_getTop();
        g_hvmdl_popup.style.left = hvmdl_getLeft();
        g_isMouseover = true;
    }
}

function hvmdl_getLeft(){
    var popup_w = g_hvmdl_popup.offsetWidth;
    var mod_w = g_hvmdl.offsetWidth;
        return g_evntElement.clientWidth - (popup_w - 70)  + "px";
   
}
function hvmdl_getTop(){
    return g_evntElement.clientTop + "px";
}
function hvmdl_hidePopUp(){
    g_t = setTimeout(hvmdl_hide,100);
}
function hvmdl_hide(){
    g_hvmdl_popup.style.display = "none";
    clearTimeout(g_t);
    g_isMouseover = false;
}


/*
function handlePageLoad() {
    renderRightBarHeight();
}
function renderRightBarHeight() {
    var rb = document.getElementById("right_bar");
    var mb = document.getElementById("main_body");
    var rbc = document.getElementById("right_bar_content");
    
    if (rbc.offsetHeight > mb.offsetHeight)
        rb.style.height = rbc.offsetHeight + "px";
    else
        rb.style.height = mb.offsetHeight + "px";

}

var g_isNavHover = false;

function handleNavMouseover(obj) {
    var linkText = obj.innerHTML.toLowerCase();
    if (!g_isNavHover && obj.className.indexOf("nav-on") == -1) {
        if (linkText == "home"){
            obj.className = "txt-wht txt-14 nav-home-hvr";
        }
        else if (linkText == "help") {
            obj.className = "txt-wht txt-14 nav-help-hvr";
        }
        else
            obj.className = "txt-wht txt-14 nav-hvr";

        g_isNavHover = true;
    }

}

function handleNavMouseout(obj) {
    if (obj.className.indexOf("nav-on") == -1)
        obj.className = "txt-wht txt-14";


    g_isNavHover = false;
}


function handleBodyLinkMouseover(obj) {
    obj.className = "setup-steps-frame bodylink-hvr";
}
function handleBodyLinkMouseout(obj) {
    obj.className = "setup-steps-frame bodylink";
}
function gotoURL(strURL) {
    window.location.href = strURL;
}

function showDialog(strID) {
    var dlg = document.getElementById(strID);
    dlg.style.display = "block";

}
*/

document.write("\r\n  <style type=\"text\/css\">\r\n    a#uservoice-feedback-tab {\r\n      position: fixed;\r\n      left: 0;\r\n      top: 40%;\r\n      display: block;\r\n      background: #F5EEEE url(images\/feedback_tab_black.png) -2px 50% no-repeat;\r\n      text-indent: -4000px;\r\n      width: 25px;\r\n      height: 90px;\r\n      margin-top: -45px;\r\n      border: outset 1px #F5EEEE;\r\n      border-left: none;\r\n      z-index: 100001;\r\n    }\r\n    \r\n    a#uservoice-feedback-tab:hover {\r\n      background-color: #06c;\r\n      border: outset 1px #06c;\r\n      border-left: none;\r\n      cursor: pointer;\r\n    }\r\n\r\n    * html a#uservoice-feedback-tab {\r\n      position: absolute;\r\n      background-image: none;\r\n      filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='http:\/\/walkme.uservoice.com\/images\/feedback_tab_black.png');\r\n    }\r\n  <\/style>\r\n  \r\n  <a id=\"uservoice-feedback-tab\" href=\"http:\/\/walkme.uservoice.com\" target=\"_blank\">Feedback<\/a>\r\n  \r\n")

/** web trends **/

//Tag Version: MS Health Solutions 09-11-07
var gTagVer = "MS Health Solutions 09-11-07";
var gService = true;
var gTimeZone = -8;


function dcsCookie(){
	if (typeof(dcsOther)=="function"){
		dcsOther();
	}
	else if (typeof(dcsPlugin)=="function"){
		dcsPlugin();
	}
	else if (typeof(dcsFPC)=="function"){
		dcsFPC(gTimeZone);
	}
}
function dcsGetCookie(name){
	var pos=document.cookie.indexOf(name+"=");
	if (pos!=-1){
		var start=pos+name.length+1;
		var end=document.cookie.indexOf(";",start);
		if (end==-1){
			end=document.cookie.length;
		}
		return unescape(document.cookie.substring(start,end));
	}
	return null;
}
function dcsGetCrumb(name,crumb){
	var aCookie=dcsGetCookie(name).split(":");
	for (var i=0;i<aCookie.length;i++){
		var aCrumb=aCookie[i].split("=");
		if (crumb==aCrumb[0]){
			return aCrumb[1];
		}
	}
	return null;
}
function dcsGetIdCrumb(name,crumb){
	var cookie=dcsGetCookie(name);
	var id=cookie.substring(0,cookie.indexOf(":lv="));
	var aCrumb=id.split("=");
	for (var i=0;i<aCrumb.length;i++){
		if (crumb==aCrumb[0]){
			return aCrumb[1];
		}
	}
	return null;
}
function dcsFPC(offset){
	if (typeof(offset)=="undefined"){
		return;
	}
	if (document.cookie.indexOf("WTLOPTOUT=")!=-1){
		return;
	}
	var name=gFpc;
	var dCur=new Date();
	var adj=(dCur.getTimezoneOffset()*60000)+(offset*3600000);
	dCur.setTime(dCur.getTime()+adj);
	var dExp=new Date(dCur.getTime()+7776000000);
	var dSes=new Date(dCur.getTime());
	if (document.cookie.indexOf(name+"=")==-1){
		if ((typeof(gWtId)!="undefined")&&(gWtId!="")){
			WT.co_f=gWtId;
		}
		else if ((typeof(gTempWtId)!="undefined")&&(gTempWtId!="")){
			WT.co_f=gTempWtId;
			WT.vt_f="1";
		}
		else{
			WT.co_f="2";
			var cur=dCur.getTime().toString();
			for (var i=2;i<=(32-cur.length);i++){
				WT.co_f+=Math.floor(Math.random()*16.0).toString(16);
			}
			WT.co_f+=cur;
			WT.vt_f="1";
		}
		if (typeof(gWtAccountRollup)=="undefined"){
			WT.vt_f_a="1";
		}
		WT.vt_f_s="1";
		WT.vt_f_d="1";
		WT.vt_f_tlh=WT.vt_f_tlv="0";
	}
	else{
		var id=dcsGetIdCrumb(name,"id");
		var lv=parseInt(dcsGetCrumb(name,"lv"));
		var ss=parseInt(dcsGetCrumb(name,"ss"));
		if ((id==null)||(id=="null")||isNaN(lv)||isNaN(ss)){
			return;
		}
		
		if (isGuid(id)) {
		    WT.co_f=id;
		} else {
		    WT.co_f="2";
		    var cur=dCur.getTime().toString();
		    for (var i=2;i<=(32-cur.length);i++){
			    WT.co_f+=Math.floor(Math.random()*16.0).toString(16);
		    }
		    WT.co_f+=cur;
		}
		
		var dLst=new Date(lv);
		WT.vt_f_tlh=Math.floor((dLst.getTime()-adj)/1000);
		dSes.setTime(ss);
		if ((dCur.getTime()>(dLst.getTime()+1800000))||(dCur.getTime()>(dSes.getTime()+28800000))){
			WT.vt_f_tlv=Math.floor((dSes.getTime()-adj)/1000);
			dSes.setTime(dCur.getTime());
			WT.vt_f_s="1";
		}
		if ((dCur.getDay()!=dLst.getDay())||(dCur.getMonth()!=dLst.getMonth())||(dCur.getYear()!=dLst.getYear())){
			WT.vt_f_d="1";
		}
	}
	WT.co_f=escape(WT.co_f);
	WT.vt_sid=WT.co_f+"."+(dSes.getTime()-adj);
	var expiry="; expires="+dExp.toGMTString();
	document.cookie=name+"="+"id="+WT.co_f+":lv="+dCur.getTime().toString()+":ss="+dSes.getTime().toString()+expiry+"; path=/"+(((typeof(gFpcDom)!="undefined")&&(gFpcDom!=""))?("; domain="+gFpcDom):("")) + ";secure";
	if (document.cookie.indexOf(name+"=")==-1){
		WT.co_f=WT.vt_sid=WT.vt_f_s=WT.vt_f_d=WT.vt_f_tlh=WT.vt_f_tlv="";
		WT.vt_f=WT.vt_f_a="2";
	}
}
function isGuid(id) {
    if (id.length == 32 && id.indexOf(".") == -1) {
        return true;
    }
    return false;
}
function dcsEvt(evt,tag){
	var e=evt.target||evt.srcElement;
	while (e.tagName&&(e.tagName!=tag)){
		e=e.parentElement||e.parentNode;
	}
	return e;
}
function dcsBind(event,func){
	if ((typeof(window[func])=="function")&&document.body){
		if (document.body.addEventListener){
			document.body.addEventListener(event, window[func], true);
		}
		else if(document.body.attachEvent){
			document.body.attachEvent("on"+event, window[func]);
		}
	}
}
function dcsET(){
	var e=(navigator.appVersion.indexOf("MSIE")!=-1)?"click":"mousedown";
	dcsBind(e,"dcsDownload");
	dcsBind(e,"dcsFormButton");
	dcsBind("keypress","dcsFormButton");
	dcsBind(e,"dcsImageMap");
}	
function dcsMultiTrack(){
	WT.si_n=WT.si_x=DCSext.hs_modind=DCSext.hs_artret=DCSext.hs_modret=DCSext.hs_wrret=DCSext.hs_dashret=DCSext.hs_scrapret=DCSext.hs_actmod="";
	if (arguments.length%2==0){
		for (var i=0;i<arguments.length;i+=2){
			if (arguments[i].indexOf('WT.')==0){
				WT[arguments[i].substring(3)]=arguments[i+1];
			}
			else if (arguments[i].indexOf('DCS.')==0){
				DCS[arguments[i].substring(4)]=arguments[i+1];
			}
			else if (arguments[i].indexOf('DCSext.')==0){
				DCSext[arguments[i].substring(7)]=arguments[i+1];
			}
		}
		var dCurrent=new Date();
		DCS.dcsdat=dCurrent.getTime();
		dcsTag();
	}
}
function dcsSetVar(){
    if ((arguments.length%2==0)&&(navigator.appVersion.indexOf("MSIE")!=-1)){
			for (var i=0;i<arguments.length;i+=2){
				if (arguments[i].indexOf('WT.')==0){
					WT[arguments[i].substring(3)]=arguments[i+1];
				}
				else if (arguments[i].indexOf('DCS.')==0){
					DCS[arguments[i].substring(4)]=arguments[i+1];
				}
				else if (arguments[i].indexOf('DCSext.')==0){
        	DCSext[arguments[i].substring(7)]=arguments[i+1];
				}
			}
    }
}
function dcsSetVarCap(e){
	var gCap = e.onclick.toString();
  var gStart = gCap.substring(gCap.indexOf("dcsSetVar(")+10,gCap.length);
  var gEnd = gStart.substring(0,gStart.indexOf(");")).replace(/\s"/gi,"").replace(/"/gi,"");
  var gSplit = gEnd.split(",");
  if (gSplit.length!=-1){
		for (var i=0;i<gSplit.length;i+=2){
    	if (gSplit[i].indexOf('WT.')==0){
				WT[gSplit[i].substring(3)]=gSplit[i+1];
			}
			else if (gSplit[i].indexOf('DCS.')==0){
				DCS[gSplit[i].substring(4)]=gSplit[i+1];
			}
			else if (gSplit[i].indexOf('DCSext.')==0){
      	DCSext[gSplit[i].substring(7)]=gSplit[i+1];
			}
		}
  }
}
function dcsDownload(evt){
	evt=evt||(window.event||"");
	if (evt){
		var e=dcsEvt(evt,"A");
		var f=dcsEvt(evt,"IMG");
		if(e){
			if (e.hostname&&e.href&&e.protocol&&((e.protocol.indexOf("http")!=-1)||(e.protocol=="javascript:"))){
				dcsNavigation(e);
        if((navigator.appVersion.indexOf("MSIE")==-1)&&(e.onclick)){dcsSetVarCap(e);}
        var gPath=e.pathname?((e.pathname.indexOf("/")!=0)?"/"+e.pathname:e.pathname):"/";				
				if(f.alt){gTitle=f.alt;}
				else{if(document.all){gTitle=e.innerText||e.innerHTML||"";}else{gTitle=e.text||e.innerHTML||"";}}
				dcsMultiTrack("DCS.dcssip",e.hostname,"DCS.dcsuri",gPath,"DCS.dcsqry",e.search||"","WT.ti","Link:"+gTitle,"WT.dl","1","WT.ad","","WT.mc_id","","WT.sp","");
				DCS.dcssip=DCS.dcsuri=DCS.dcsqry=WT.ti=WT.dl=gTitle=gPath="";
			}
		}
	}
}
function dcsNavigation(wtnode){
	try{
	var wtCount=0;
	while(wtCount!=1){
		if(wtnode.parentNode.tagName!="DIV"){
			wtnode=wtnode.parentNode;
		}
		if(wtnode.parentNode.tagName=="DIV"){
			if((wtnode.parentNode.getAttribute('id'))||(wtnode.parentNode.className)){
				DCSext.wtNavigation = wtnode.parentNode.getAttribute("id")||wtnode.parentNode.className;
				wtCount=1;
			}
			else{
				wtnode=wtnode.parentNode;
			}		
		}
	}}
	catch(error){}				
}
function dcsImageMap(evt){
	evt=evt||(window.event||"");
	if (evt){
		var f=dcsEvt(evt,"AREA");
		if(f){
			if (f.hostname&&f.href&&f.protocol&&(f.protocol.indexOf("http")!=-1)){
				var gPath=f.pathname?((f.pathname.indexOf("/")!=0)?"/"+f.pathname:f.pathname):"/";
				dcsMultiTrack("DCS.dcssip",f.hostname,"DCS.dcsuri",gPath,"DCS.dcsqry",f.search||"","WT.ti","Link:Image Map","WT.dl","1","WT.ad","","WT.mc_id","","WT.sp","");
				DCS.dcssip=DCS.dcsuri=DCS.dcsqry=WT.ti=gPath=WT.dl="";
			}			
		}
	}
}
function dcsFormButton(evt){
	evt=evt||(window.event||"");
	if (evt){
		var e=dcsEvt(evt,"INPUT");
		var type=e.type||"";
		if (type&&((type=="submit")||(type=="image")||(type=="button")||(type=="reset"))||((type=="text")&&((evt.which||evt.keyCode)==13))){
			var gUri=gTitle=gMethod=qry="";
			if(e.form){
				var elems=e.form.elements;
				for (var i=0;i<elems.length;i++){
					var etype=elems[i].type;
					if (etype=="text"){
						qry+=((qry=="")?"":"&")+escape(elems[i].name)+"="+escape(elems[i].value);
					}
				}
				gUri=e.form.action||window.location.pathname;
				gTitle=e.form.id||e.form.className||e.form.name||"Unknown";
				gMethod=e.form.method||"Unknown";
			}
			else{
				gUri=window.location.pathname;
				gTitle=e.name||e.id||"Unknown";
				gMethod="Input";
			}
			if((gUri!="")&&(gTitle!="")&&(gMethod!="")&&(evt.keyCode!=9)){
				dcsMultiTrack("DCS.dcsuri",gUri,"DCS.dcsqry",qry,"WT.ti","FormButton:"+gTitle,"WT.dl","2","WT.fm",gMethod,"WT.ad","","WT.mc_id","","WT.sp","");
			}
			DCS.dcsuri=DCS.dcsqry=qry=WT.ti=WT.dl=WT.fm=gUri=gTitle=gMethod="";
		}
	}
}
function dcsAdSearch(){
	if (document.links){
		for (var i=0;i<document.links.length;i++){
			var anch=document.links[i].href+"";
			var pos=anch.toUpperCase().indexOf("WT.AC=");
			if (pos!=-1){
				var start=pos+6;
				var end=anch.indexOf("&",start);
				var value=anch.substring(start,(end!=-1)?end:anch.length);
				WT.ad=WT.ad?(WT.ad+";"+value):value;
			}
		}
	}
}

function dcsAdv(){
	if ((typeof(gTrackEvents)!="undefined")&&gTrackEvents){
		WT.wtsv=1;
		if(typeof(WT.sp)!="undefined"){WT.sv_sp=WT.sp;}
		dcsFunc("dcsET");	
	}
	dcsFunc("dcsCookie");
	dcsFunc("dcsAdSearch");
	DCSext.wtEvtSrc=DCS.dcssip+DCS.dcsuri;
}

var gImages=new Array;
var gIndex=0;
var DCS=new Object();
var WT=new Object();
var DCSext=new Object();
var gQP=new Array();
var gI18n=false;
if (window.RegExp){
	var RE={"%09":/\t/g,"%20":/ /g,"%23":/\#/g,"%26":/\&/g,"%2B":/\+/g,"%3F":/\?/g,"%5C":/\\/g};
	var I18NRE={"%25":/\%/g};
}

function dcsVar(){
	var dCurrent=new Date();
	WT.tz=dCurrent.getTimezoneOffset()/60*-1;
	if (WT.tz==0){
		WT.tz="0";
	}
	WT.bh=dCurrent.getHours();
	WT.ul=navigator.appName=="Netscape"?navigator.language:navigator.userLanguage;
	if (typeof(screen)=="object"){
		WT.cd=navigator.appName=="Netscape"?screen.pixelDepth:screen.colorDepth;
		WT.sr=screen.width+"x"+screen.height;
	}
	if (typeof(navigator.javaEnabled())=="boolean"){
		WT.jo=navigator.javaEnabled()?"Yes":"No";
	}
	if (document.title){
		WT.ti=gI18n?dcsEscape(dcsEncode(document.title),I18NRE):document.title;
	}
	WT.js="Yes";
	WT.jv=dcsJV();
	if (document.body&&document.body.addBehavior){
		document.body.addBehavior("#default#clientCaps");
		if (document.body.connectionType){
			WT.ct=document.body.connectionType;
		}
		document.body.addBehavior("#default#homePage");
		WT.hp=document.body.isHomePage(location.href)?"1":"0";
	}
	if (parseInt(navigator.appVersion)>3){
		if ((navigator.appName=="Microsoft Internet Explorer")&&document.body){
			WT.bs=document.body.offsetWidth+"x"+document.body.offsetHeight;
		}
		else if (navigator.appName=="Netscape"){
			WT.bs=window.innerWidth+"x"+window.innerHeight;
		}
	}
	WT.fi="No";
	if (window.ActiveXObject){
		for(var i=10;i>0;i--){
			try{
				var flash = new ActiveXObject("ShockwaveFlash.ShockwaveFlash."+i);
				WT.fi="Yes";
				WT.fv=i+".0";
				break;
			}
			catch(e){
			}
		}
	}
	else if (navigator.plugins&&navigator.plugins.length){
		for (var i=0;i<navigator.plugins.length;i++){
			if (navigator.plugins[i].name.indexOf('Shockwave Flash')!=-1){
				WT.fi="Yes";
				WT.fv=navigator.plugins[i].description.split(" ")[2];
				break;
			}
		}
	}
	if (gI18n){
		WT.em=(typeof(encodeURIComponent)=="function")?"uri":"esc";
		if (typeof(document.defaultCharset)=="string"){
			WT.le=document.defaultCharset;
		} 
		else if (typeof(document.characterSet)=="string"){
			WT.le=document.characterSet;
		}
	}
	WT.dl="0";
	DCS.dcsdat=dCurrent.getTime();
	DCS.dcssip=window.location.hostname;
	DCS.dcsuri=window.location.pathname;
	var gDirLevels = 5;
	var gFpath = window.location.pathname.substring(window.location.pathname.indexOf('/')+1,window.location.pathname.lastIndexOf('/')+1).toLowerCase();
	if(gFpath==''){gFpath="/";}	
	else{	
		var gSplit=gFpath.split("/");
		gFpath="";
		for(var i=1;i<gSplit.length&&i<=gDirLevels;i++){
			gFpath+="/";
			for(var b=0;b<i;b++){
					gFpath+=gSplit[b]+"/";
			}
			if(i!=gDirLevels&&i!=gSplit.length-1){
				gFpath+=";";
			}		
		}
	}
	DCSext.wtDrillDir=gFpath;
    if (window.location.search){
		DCS.dcsqry=window.location.search;
		if (gQP.length>0){
			for (var i=0;i<gQP.length;i++){
				var pos=DCS.dcsqry.indexOf(gQP[i]);
				if (pos!=-1){
					var front=DCS.dcsqry.substring(0,pos);
					var end=DCS.dcsqry.substring(pos+gQP[i].length,DCS.dcsqry.length);
					DCS.dcsqry=front+end;
				}
			}
		}
	}
	if ((window.document.referrer!="")&&(window.document.referrer!="-")){
		if (!(navigator.appName=="Microsoft Internet Explorer"&&parseInt(navigator.appVersion)<4)){
			DCS.dcsref=gI18n?dcsEscape(window.document.referrer, I18NRE):window.document.referrer;
		}
	}
}
function dcsA(N,V){
	return "&"+N+"="+dcsEscape(V, RE);
}
function dcsEscape(S, REL){
	if (typeof(REL)!="undefined"){
		var retStr = new String(S);
		for (R in REL){
			retStr = retStr.replace(REL[R],R);
		}
		return retStr;
	}
	else{
		return escape(S);
	}
}
function dcsEncode(S){
	return (typeof(encodeURIComponent)=="function")?encodeURIComponent(S):escape(S);
}
function dcsCreateImage(dcsSrc){
    if (!gWebTrendsCheck) return;
	if (document.images){
		gImages[gIndex]=new Image;
		gImages[gIndex].src=dcsSrc;
		gIndex++;
	}
	else{
		document.write('<IMG ALT="" BORDER="0" NAME="DCSIMG" WIDTH="1" HEIGHT="1" SRC="'+dcsSrc+'">');
	}
}
function dcsMeta(){
	var elems;
	if (document.all){
		elems=document.all.tags("meta");
	}
	else if (document.documentElement){
		elems=document.getElementsByTagName("meta");
	}
	if (typeof(elems)!="undefined"){
		for (var i=1;i<=elems.length;i++){
			var meta=elems.item(i-1);
			if (meta.name){
				if (meta.name.indexOf('WT.')==0){
					WT[meta.name.substring(3)]=(gI18n&&(meta.name.indexOf('WT.ti')==0))?dcsEscape(dcsEncode(meta.content),I18NRE):meta.content;
				}
				else if (meta.name.indexOf('DCSext.')==0){
					DCSext[meta.name.substring(7)]=meta.content;
				}
				else if (meta.name.indexOf('DCS.')==0){
					DCS[meta.name.substring(4)]=(gI18n&&(meta.name.indexOf('DCS.dcsref')==0))?dcsEscape(meta.content,I18NRE):meta.content;
				}
			}
		}
	}
}
function dcsTag(){
	if (document.cookie.indexOf("WTLOPTOUT=")!=-1){
		return;
	}
	var P="http"+(window.location.protocol.indexOf('https:')==0?'s':'')+"://"+gDomain+(gDcsId==""?'':'/'+gDcsId)+"/dcs.gif?";
	for (N in DCS){
		if (DCS[N]) {
			P+=dcsA(N,DCS[N]);
		}
	}
	for (N in WT){
		if (WT[N]) {
			P+=dcsA("WT."+N,WT[N]);
		}
	}
	for (N in DCSext){
		if (DCSext[N]) {
			P+=dcsA(N,DCSext[N]);
		}
	}
	if (P.length>2048&&navigator.userAgent.indexOf('MSIE')>=0){
		P=P.substring(0,2040)+"&WT.tu=1";
	}
	dcsCreateImage(P);
}
function dcsJV(){
	var agt=navigator.userAgent.toLowerCase();
	var major=parseInt(navigator.appVersion);
	var mac=(agt.indexOf("mac")!=-1);
	var nn=((agt.indexOf("mozilla")!=-1)&&(agt.indexOf("compatible")==-1));
	var nn4=(nn&&(major==4));
	var nn6up=(nn&&(major>=5));
	var ie=((agt.indexOf("msie")!=-1)&&(agt.indexOf("opera")==-1));
	var ie4=(ie&&(major==4)&&(agt.indexOf("msie 4")!=-1));
	var ie5up=(ie&&!ie4);
	var op=(agt.indexOf("opera")!=-1);
	var op5=(agt.indexOf("opera 5")!=-1||agt.indexOf("opera/5")!=-1);
	var op6=(agt.indexOf("opera 6")!=-1||agt.indexOf("opera/6")!=-1);
	var op7up=(op&&!op5&&!op6);
	var jv="1.1";
	if (nn6up||op7up){
		jv="1.5";
	}
	else if ((mac&&ie5up)||op6){
		jv="1.4";
	}
	else if (ie5up||nn4||op5){
		jv="1.3";
	}
	else if (ie4){
		jv="1.2";
	}
	return jv;
}
function dcsFunc(func){
	if (typeof(window[func])=="function"){
		window[func]();
	}
}
function dcsDebug()
{
	var wtVars="\nTag Version = "+gTagVer+"\nDomain = "+gDomain+"\nDCSId = "+gDcsId;
	for(N in DCS){wtVars+="\nDCS."+N+" = "+DCS[N];}
	for(N in WT){wtVars+="\nWT."+N+" = "+WT[N];}
	for(N in DCSext){wtVars+="\nDCSext."+N+" = "+DCSext[N];}
	alert(wtVars);
}
 
dcsVar();
dcsMeta();
dcsFunc("dcsAdv");
dcsTag();
DCSext.hs_msncenter=DCSext.hs_actmod=DCSext.hs_modind=DCSext.hs_scrapret=DCSext.hs_dashret=DCSext.hs_wrret=DCSext.hs_modret=DCSext.hs_artret=WT.si_x=WT.si_n=WT.seg_1=DCSext.hs_fnf=DCSext.hs_modind=DCSext.hs_comp="";
