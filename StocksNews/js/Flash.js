/// <reference path="Player.js"/>
var isIE = (navigator.appVersion.indexOf("MSIE") != -1) ? true : false;
var isWin = (navigator.appVersion.toLowerCase().indexOf("win") != -1) ? true : false;
var isOpera = (navigator.userAgent.indexOf("Opera") != -1) ? true : false;


var Flash = {
    FlashHelper: {
        AC_AddExtension: function (src, ext) {
            if (src.indexOf('?') != -1)
                return src.replace(/\?/, ext + '?');
            else
                return src + ext;
        },
        AC_Generateobj: function (objAttrs, params, embedAttrs) {
            var str = '<object ';
            for (var i in objAttrs)
                str += i + '="' + objAttrs[i] + '" ';
            str += '>';
            for (var i in params)
                str += '<param name="' + i + '" value="' + params[i] + '" /> ';
            str += '<embed ';
            for (var i in embedAttrs)
                str += i + '="' + embedAttrs[i] + '" ';
            str += ' ></embed></object>';

            return str;
            //  document.write(str);
        },
        AC_FL_RunContent: function () {
            var ret = this.AC_GetArgs(arguments, ".swf", "movie", "clsid:d27cdb6e-ae6d-11cf-96b8-444553540000", "application/x-shockwave-flash");
            return this.AC_Generateobj(ret.objAttrs, ret.params, ret.embedAttrs);
        },
        AC_SW_RunContent: function () {
            var ret = AC_GetArgs(arguments, ".dcr", "src", "clsid:166B1BCA-3F9C-11CF-8075-444553540000", null);
            this.AC_Generateobj(ret.objAttrs, ret.params, ret.embedAttrs);
        },
        AC_GetArgs: function (args, ext, srcParamName, classid, mimeType) {
            var ret = new Object();
            ret.embedAttrs = new Object();
            ret.params = new Object();
            ret.objAttrs = new Object();
            for (var i = 0; i < args.length; i = i + 2) {
                var currArg = args[i].toLowerCase();

                switch (currArg) {
                    case "classid":
                        break;
                    case "pluginspage":
                        ret.embedAttrs[args[i]] = args[i + 1];
                        break;
                    case "src":
                    case "movie":
                        args[i + 1] = this.AC_AddExtension(args[i + 1], ext);
                        ret.embedAttrs["src"] = args[i + 1];
                        ret.params[srcParamName] = args[i + 1];
                        break;
                    case "onafterupdate":
                    case "onbeforeupdate":
                    case "onblur":
                    case "oncellchange":
                    case "onclick":
                    case "ondblClick":
                    case "ondrag":
                    case "ondragend":
                    case "ondragenter":
                    case "ondragleave":
                    case "ondragover":
                    case "ondrop":
                    case "onfinish":
                    case "onfocus":
                    case "onhelp":
                    case "onmousedown":
                    case "onmouseup":
                    case "onmouseover":
                    case "onmousemove":
                    case "onmouseout":
                    case "onkeypress":
                    case "onkeydown":
                    case "onkeyup":
                    case "onload":
                    case "onlosecapture":
                    case "onpropertychange":
                    case "onreadystatechange":
                    case "onrowsdelete":
                    case "onrowenter":
                    case "onrowexit":
                    case "onrowsinserted":
                    case "onstart":
                    case "onscroll":
                    case "onbeforeeditfocus":
                    case "onactivate":
                    case "onbeforedeactivate":
                    case "ondeactivate":
                    case "type":
                    case "codebase":
                        ret.objAttrs[args[i]] = args[i + 1];
                        break;
                    case "width":
                    case "height":
                    case "align":
                    case "vspace":
                    case "hspace":
                    case "class":
                    case "title":
                    case "accesskey":
                    case "name":
                    case "id":
                    case "tabindex":
                        ret.embedAttrs[args[i]] = ret.objAttrs[args[i]] = args[i + 1];
                        break;
                    default:
                        ret.embedAttrs[args[i]] = ret.params[args[i]] = args[i + 1];
                }
            }
            ret.objAttrs["classid"] = classid;
            if (mimeType)
                ret.embedAttrs["type"] = mimeType;
            return ret;
        },
        ControlVersion: function () {
            var version;
            var axo;
            var e;
            try {
                axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7");
                version = axo.GetVariable("$version")
            }
            catch (e) {
            }
            if (!version) {
                try {
                    axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");
                    version = "WIN 6,0,21,0";
                    axo.AllowScriptAccess = "always";
                    version = axo.GetVariable("$version")
                }
                catch (e) {
                }
            }
            if (!version) {
                try {
                    axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.3");
                    version = axo.GetVariable("$version")
                }
                catch (e) {
                }
            }
            if (!version) {
                try {
                    axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.3");
                    version = "WIN 3,0,18,0"
                }
                catch (e) {
                }
            }
            if (!version) {
                try {
                    axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
                    version = "WIN 2,0,0,11"
                }
                catch (e) {
                    version = -1
                }
            }
            return version
        },
        GetSwfVer: function () {
            var flashVer = -1;
            if (navigator.plugins != null && navigator.plugins.length > 0) {
                if (navigator.plugins["Shockwave Flash 2.0"] || navigator.plugins["Shockwave Flash"]) {
                    var swVer2 = navigator.plugins["Shockwave Flash 2.0"] ? " 2.0" : "";
                    var flashDescription = navigator.plugins["Shockwave Flash" + swVer2].description;
                    var descArray = flashDescription.split(" ");
                    var tempArrayMajor = descArray[2].split(".");
                    var versionMajor = tempArrayMajor[0];
                    var versionMinor = tempArrayMajor[1];
                    var versionRevision = descArray[3];
                    if (versionRevision == "") {
                        versionRevision = descArray[4]
                    }
                    if (versionRevision[0] == "d") {
                        versionRevision = versionRevision.substring(1)
                    }
                    else
                        if (versionRevision[0] == "r") {
                            versionRevision = versionRevision.substring(1);
                            if (versionRevision.indexOf("d") > 0) {
                                versionRevision = versionRevision.substring(0, versionRevision.indexOf("d"))
                            }
                        }
                    var flashVer = versionMajor + "." + versionMinor + "." + versionRevision
                }
            }
            else
                if (navigator.userAgent.toLowerCase().indexOf("webtv/2.6") != -1)
                    flashVer = 4;
                else
                    if (navigator.userAgent.toLowerCase().indexOf("webtv/2.5") != -1)
                        flashVer = 3;
                    else
                        if (navigator.userAgent.toLowerCase().indexOf("webtv") != -1)
                            flashVer = 2;
                        else
                            if (isIE && isWin && !isOpera) {
                                flashVer = this.ControlVersion()
                            }
            return flashVer
        },
        DetectFlashVer: function (reqMajorVer, reqMinorVer, reqRevision) {
            versionStr = this.GetSwfVer();
            if (versionStr == -1) {
                return false
            }
            else
                if (versionStr != 0) {
                    if (isIE && isWin && !isOpera) {
                        tempArray = versionStr.split(" ");
                        tempString = tempArray[1];
                        versionArray = tempString.split(",")
                    }
                    else {
                        versionArray = versionStr.split(".")
                    }
                    var versionMajor = versionArray[0];
                    var versionMinor = versionArray[1];
                    var versionRevision = versionArray[2];
                    if (versionMajor > parseFloat(reqMajorVer)) {
                        return true
                    }
                    else
                        if (versionMajor == parseFloat(reqMajorVer)) {
                            if (versionMinor > parseFloat(reqMinorVer))
                                return true;
                            else
                                if (versionMinor == parseFloat(reqMinorVer)) {
                                    if (versionRevision >= parseFloat(reqRevision))
                                        return true
                                }
                        }
                    return false
                }
        },
        rightVersion: null,
        hasRightVersion: function () {
            if (this.rightVersion == null)
                this.rightVersion = this.DetectFlashVer(10, 0, 0);
            return this.rightVersion;
        }
    },
    CreateStocksWidget: function () {
        var p = '/GetStocksForWidget.aspx';
        //if (this.FlashHelper.hasRightVersion()) {
        //    return this.Create(
		//		'src', '/media/metoxes',
		//		'movie', '/media/metoxes',
		//		'id', 'metoxes',
		//		'name', 'metoxes',
		//		'width', '298',
		//		'height', '280',
		//		'align', 'lt',
		//		'salign', 'lt',
		//		'menu', 'false',
		//		'quality', 'high',
		//		'play', 'true',
		//		'loop', 'false',
		//		'scale', 'showall',
		//		'wmode', 'transparent',
		//		'devicefont', 'false',
		//		'flashvars', 'xmlPath=' + escape(p),
		//		'allowFullScreen', 'true',
		//		'allowScriptAccess', 'sameDomain',
		//		'pluginspage', 'http://www.macromedia.com/go/getflashplayer',
		//		'codebase', 'http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0'
		//		).replace(/metoxes\.swf/ig, 'metoxes.swf?v=1');
        //}
        //else {
        return '<div class="real-time">        <img alt="" src="media/real-on.png"></img>    </div> ' +
             '  <h1>        τιμές μετοχών</h1>                                                  ' +
             '  <div>    </div>                                                                 ' +
             '  <table width="100%" cellspacing="1" border="0" class="head">                    ' + 
             '     <tbody>                                                                      ' +
             '        <tr>                                                                      ' +
             '           <th>                    ΣΥΜΒΟΛΟ                </th>                   ' + 
             '           <th>                    ΤΙΜΗ                </th>                      ' +
             '           <th>                    ΜΕΤ.                </th>                      ' +
             '           <th>                    ΜΕΤ.%                </th>                     ' +
             '           <th>                    ΟΓΚΟΣ                </th>                     ' +
             '         </tr>                                                                       ' +
             '     </tbody>                                                                                             ' +
             '   </table>                ' +
             '   <a href="http://newsbeast.cantaloop.gr/xrimatistirio" ><div style="height: 179px; position: relative; overflow: hidden;" class="scroll-viewport">                ' +
             '      <div class="scrolled" style="position: absolute;">        </div>                                         ' +
             '  </div></a>  ' +
             '   <div class="stock-search">        <input type="text" /><input type="image" src="media/stock-search-input-img.png" />    </div>  ' + 
             '   <div class="stock-nav">             ' +
             '      <ul>                                                                                                                 ' +
             '        <li><a>                <img alt="" src="media/stock-search-arrow-down.png"></img></a></li>                        ' +
             '         <li><a>                <img alt="" src="media/stock-search-arrow-small-down.png"></img></a></li>                  ' +
             '         <li><a>                <img alt="" src="media/stock-search-reload.png"></img></a></li>                            ' +
             '         <li><a>                <img alt="" src="media/stock-search-arrow-small-up.png"></img></a></li>                    ' +
             '         <li class="last"><a>                <img alt="" src="media/stock-search-arrow-up.png"></img></a></li>             ' +
             '      </ul>        ' +
             '   </div>';



       // }
    },
    Create: function () {
        var alternateContent;
        alternateContent = '<p>Για να δείτε το περιεχόμενο της σελίδας, πρέπει να εγκαταστήσετε το <a href="http://get.adobe.com/flashplayer/">Adobe Flash Player v10.0<\/a><\/p>';

      //  if (this.FlashHelper.hasRightVersion()) {
      //      return this.FlashHelper.AC_FL_RunContent.apply(this.FlashHelper, arguments);
      //  }
      //  else {
            return alternateContent;
      //  }

    }
}

function BaseUrl() {
    return window.location.protocol + "//" + window.location.host;
}


