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
            } catch (e) { }
            if (!version) {
                try {
                    axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");
                    version = "WIN 6,0,21,0";
                    axo.AllowScriptAccess = "always";
                    version = axo.GetVariable("$version")
                } catch (e) { }
            }
            if (!version) {
                try {
                    axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.3");
                    version = axo.GetVariable("$version")
                } catch (e) { }
            }
            if (!version) {
                try {
                    axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash.3");
                    version = "WIN 3,0,18,0"
                } catch (e) { }
            }
            if (!version) {
                try {
                    axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
                    version = "WIN 2,0,0,11"
                } catch (e) {
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
                    } else
                        if (versionRevision[0] == "r") {
                            versionRevision = versionRevision.substring(1);
                            if (versionRevision.indexOf("d") > 0) {
                                versionRevision = versionRevision.substring(0, versionRevision.indexOf("d"))
                            }
                        }
                    var flashVer = versionMajor + "." + versionMinor + "." + versionRevision
                }
            } else
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
            } else
                if (versionStr != 0) {
                    if (isIE && isWin && !isOpera) {
                        tempArray = versionStr.split(" ");
                        tempString = tempArray[1];
                        versionArray = tempString.split(",")
                    } else {
                        versionArray = versionStr.split(".")
                    }
                    var versionMajor = versionArray[0];
                    var versionMinor = versionArray[1];
                    var versionRevision = versionArray[2];
                    if (versionMajor > parseFloat(reqMajorVer)) {
                        return true
                    } else
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
        var p = '/ajax.aspx?m=Nv.SqlModule&name=StocksWidget';
        if (this.FlashHelper.hasRightVersion()) {
            return this.Create('src', '/files/1/System/metoxes', 'movie', '/files/1/System/metoxes', 'id', 'metoxes', 'name', 'metoxes', 'width', '298', 'height', '280', 'align', 'lt', 'salign', 'lt', 'menu', 'false', 'quality', 'high', 'play', 'true', 'loop', 'false', 'scale', 'showall', 'wmode', 'transparent', 'devicefont', 'false', 'flashvars', 'xmlPath=' + escape(p), 'allowFullScreen', 'true', 'allowScriptAccess', 'sameDomain', 'pluginspage', 'http://www.macromedia.com/go/getflashplayer', 'codebase', 'http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0').replace(/metoxes\.swf/ig, 'metoxes.swf?v=1');
        } else {
            return '<div class="real-time">        <img alt="" src="Themes/1/Default/Media/real-on.png" />    </div>    <h1>        τιμές μετοχών</h1>    <div>    </div>    <table width="100%" cellspacing="1" border="0" class="head">        <tbody>            <tr>                <th>                    ΣΥΜΒΟΛΟ                </th>                <th>                    ΤΙΜΗ                </th>                <th>                    ΜΕΤ.                </th>                <th>                    ΜΕΤ.%                </th>                <th>                    ΟΓΚΟΣ                </th>            </tr>        </tbody>    </table>    <div style="height: 179px; position: relative; overflow: hidden;" class="scroll-viewport">        <div class="scrolled" style="position: absolute;">        </div>    </div>    <div class="stock-search">        <input type="text" /><input type="image" src="Themes/1/Default/Media/stock-search-input-img.png" />    </div>    <div class="stock-nav">        <ul>            <li><a>                <img alt="" src="Themes/1/Default/Media/stock-search-arrow-down.png" /></a></li>            <li><a>                <img alt="" src="Themes/1/Default/Media/stock-search-arrow-small-down.png" /></a></li>            <li><a>                <img alt="" src="Themes/1/Default/Media/stock-search-reload.png" /></a></li>            <li><a>                <img alt="" src="Themes/1/Default/Media/stock-search-arrow-small-up.png" /></a></li>            <li class="last"><a>                <img alt="" src="Themes/1/Default/Media/stock-search-arrow-up.png" /></a></li>        </ul>    </div>';
        }
    },
    Create: function () {
        var alternateContent;
        alternateContent = '<p>Για να δείτε το περιεχόμενο της σελίδας, πρέπει να εγκαταστήσετε το <a href="http://get.adobe.com/flashplayer/">Adobe Flash Player v10.0<\/a><\/p>';
        if (this.FlashHelper.hasRightVersion()) {
            return this.FlashHelper.AC_FL_RunContent.apply(this.FlashHelper, arguments);
        } else {
            return alternateContent;
        }
    }
}

function BaseUrl() {
    return window.location.protocol + "//" + window.location.host;
}
jQuery(function () {
    if (typeof (stocks) != 'undefined') {
        var template = '<div class="stocks-popup" style="display:none;"><div class="stocks-widget"><h1></h1><table width="100%" cellspacing="1" border="0"><tbody></tbody></table></div></div>';
        template = jQuery(template).appendTo('body');

        function viewport() {
            return {
                x: $(window).scrollLeft(),
                y: $(window).scrollTop(),
                cx: $(window).width(),
                cy: $(window).height()
            };
        }

        function positionTemplate(e) {
            var margin = {
                left: 20,
                top: 20
            };
            var location = {
                x: e.pageX + margin.left,
                y: e.pageY + margin.top
            };
            var v = viewport();
            var t = template.find('> div');
            if (location.y + t.height() > v.y + v.cy) {
                location.y -= t.height() + 2 * margin.top;
            }
            if (location.y < v.y) {
                location.y += t.height() + 2 * margin.top;
            }
            if (location.x + t.width() > v.x + v.cx) {
                location.x -= t.width() + 2 * margin.left;
            }
            template.css('top', location.y).css('left', location.x);
        }

        function updateTemplate(key) {
            var data = stocks[key];
            if (!data)
                return false;
            template.find('h1').html(key);
            var table = template.find('table');
            table.find('tr').remove();
            var rowindex = 0;
            for (var name in data) {
                var row = jQuery('<tr/>').appendTo(table);
                if (rowindex % 2 == 0) {
                    row.addClass("color");
                }
                var titleCell = jQuery("<td/>").appendTo(row).addClass("name").html(name);
                var value;
                var valueCell = jQuery("<td/>").appendTo(row);
                var v;
                switch (data[name].type) {
                    case "currencychange":
                        valueCell.addClass('change');
                        valueCell.addClass('price');
                        if (v) {
                            if (v > 0) {
                                valueCell.addClass('up');
                            } else if (v < 0) {
                                valueCell.addClass('down');
                            }
                        }
                        value = parseFloat(data[name].value);
                        valueCell.html(data[name].value + "€");
                        break;
                    case "percentchange":
                        valueCell.addClass('percent');
                        value = parseFloat(data[name].value);
                        v = value;
                        if (value > 0) {
                            valueCell.addClass('up');
                            table.find('td.change').addClass('up');
                        } else if (value < 0) {
                            valueCell.addClass('down');
                            table.find('td.change').addClass('down');
                        }
                        valueCell.html(data[name].value + "%");
                        break;
                    case "currency":
                        valueCell.addClass('price');
                        valueCell.html(data[name].value + "€");
                        break;
                    case "percent":
                        valueCell.addClass('percent');
                        valueCell.html(data[name].value + "%");
                        break;
                    case "plain":
                        valueCell.html(data[name].value);
                        break;
                }
                rowindex++;
            }
            return true;
        }
        jQuery(".stock-table-main td").hover(function (e) {
            var cell = jQuery(this);
            var key = cell.text();
            if (updateTemplate(key)) {
                template.show();
                positionTemplate(e);
            }
        }, function () {
            template.hide();
        });
    }
    jQuery(".stocks-widget-for-others").each(function () {
        var Container = jQuery(this);
        var refreshURL = '/ajax.aspx?m=Nv.SqlModule&name=StocksWidget';
        var scrollContainer = jQuery('.scroll-viewport', Container);
        if (!scrollContainer.length)
            return;
        var scrolledContainer = jQuery('.scrolled', scrollContainer);
        var scrollIntervalId;
        var stocksWidgetUrl;
        var controls = {
            "upFast": jQuery(jQuery(".stock-nav li", Container).get(0)),
            "up": jQuery(jQuery(".stock-nav li a", Container).get(1)),
            "refresh": jQuery(jQuery(".stock-nav li a", Container).get(2)),
            "down": jQuery(jQuery(".stock-nav li a", Container).get(3)),
            "downFast": jQuery(jQuery(".stock-nav li a", Container).get(4)),
            "searchbutton": jQuery(".stock-search input[type=image]", Container),
            "searchtext": jQuery(".stock-search input[type=text]", Container)
        };
        var scrollSettings = {
            "normal": {
                "interval": 100,
                "increment": 2
            },
            "fast": {
                "interval": 100,
                "increment": 8
            },
            "superfast": {
                "interval": 100,
                "increment": 16
            }
        }
        var scrollInterval = 100;
        var scrollIncrement = 2;
        var scrolling = false;
        var maxScroll = 0;
        var scrollContainerHeight = scrollContainer.height();

        function setScrollSettings(name, incrementMultiplier) {
            if (!scrolling)
                return;
            if (!incrementMultiplier)
                incrementMultiplier = 1;
            var settings = scrollSettings[name];
            if (scrollInterval != settings.interval) {
                if (scrolling) {
                    stopScroll();
                    scrollInterval = settings.interval;
                    startScroll();
                } else {
                    scrollInterval = settings.interval;
                }
            }
            scrollIncrement = settings.increment * incrementMultiplier;
        }

        function startScroll() {
            if (!scrolling) {
                scrollIntervalId = setInterval(onScroll, scrollInterval);
                scrolling = true;
            }
        }

        function stopScroll() {
            if (scrolling) {
                if (scrollIntervalId) {
                    clearInterval(scrollIntervalId);
                }
                scrolling = false;
            }
        }

        function onScroll() {
            var top = scrolledContainer.get(0).top;
            if (!top) {
                resetScroll();
                top = scrolledContainer.get(0).top;
            }
            if (Math.abs(top) > maxScroll) {
                resetScroll();
                top = scrolledContainer.get(0).top;
            } else if (top > scrollContainerHeight && scrollIncrement <= 0) {
                top = scrolledContainer.find('table').height() * -1;
            } else {
                top -= scrollIncrement;
            }
            scrolledContainer.css('top', top);
            scrolledContainer.get(0).top = top;
        }

        function resetScroll() {
            scrolledContainer.get(0).top = scrollContainerHeight;
        }
        var searchIndex = {};

        function drawTable(data, url, lastUpdate) {
            resetScroll();
            var html = '<table width="100%" cellspacing="1" cellpadding="5" border="0" >';
            html += '<thead><tr><th colspan="5">τελευταία ενημέρωση: ' + lastUpdate + '</th></tr></thead>';
            html += '<tbody>';
            var rowindex = 0;
            for (var key in data) {
                var rowData = data[key];
                var v = parseFloat(rowData['b']);
                html += '<tr class="' + (rowindex % 2 == 0 ? 'color' : '') + '">';
                html += '<td class="name ' + (v < 0 ? 'down' : (v > 0 ? 'up' : '')) + '"><a href="' + url + '">' + key + '</a></td>';
                html += '<td class="price ' + (v < 0 ? 'down' : (v > 0 ? 'up' : '')) + '">' + rowData['a'] + '</td>';
                html += '<td class="change ' + (v < 0 ? 'down' : (v > 0 ? 'up' : '')) + '">' + rowData['c'] + '</td>';
                html += '<td class="percent ' + (v < 0 ? 'down' : (v > 0 ? 'up' : '')) + '">' + rowData['b'] + '%</td>';
                html += '<td class="change">' + rowData['d'] + '</td>';
                html += '</tr>';
                searchIndex[key] = rowindex;
                rowindex++;
            }
            html += '</tbody></table>';
            scrolledContainer.html(html);
            scrolledContainer.find('table').first().addClass("first");
            maxScroll = scrolledContainer.find('table').height();
            if (!scrolling) {
                lastKey = undefined;
                controls.searchtext.keyup();
            }
        }

        function refresh() {
            jQuery.ajax({
                url: refreshURL,
                dataType: 'json',
                cache: false,
                success: function (r) {
                    if (r) {
                        drawTable(r.s, r.u, r.d);
                        stocksWidgetUrl = r.w;
                    }
                },
                error: function (a, b, c, d) { }
            });
        }
        controls.downFast.hover(function () {
            setScrollSettings("superfast", -1);
        }, function () {
            setScrollSettings("normal");
        });
        controls.up.hover(function () {
            setScrollSettings("fast");
        }, function () {
            setScrollSettings("normal");
        });
        controls.down.hover(function () {
            setScrollSettings("fast", -1);
        }, function () {
            setScrollSettings("normal");
        });
        controls.upFast.hover(function () {
            setScrollSettings("superfast");
        }, function () {
            setScrollSettings("normal");
        });
        controls.searchbutton.click(function (e) {
            e.preventDefault();
        });
        var lastKey;
        var k = {
            "A": "Α",
            "B": "Β",
            "C": "Ψ",
            "D": "Δ",
            "E": "Ε",
            "F": "Φ",
            "G": "Γ",
            "H": "Η",
            "I": "Ι",
            "J": "Ξ",
            "K": "Κ",
            "L": "Λ",
            "M": "Μ",
            "N": "Ν",
            "O": "Ο",
            "P": "Π",
            "Q": ";",
            "R": "Ρ",
            "S": "Σ",
            "T": "Τ",
            "U": "Θ",
            "V": "Ω",
            "W": "ς",
            "X": "Χ",
            "Y": "Υ",
            "Z": "Ζ"
        };
        controls.searchtext.val('');
        controls.searchtext.keyup(function (e) {
            if (controls.searchtext.val()) {
                controls.searchtext.val(controls.searchtext.val().toUpperCase());
                for (var english in k) {
                    controls.searchtext.val(controls.searchtext.val().replace(new RegExp(english, 'g'), k[english]));
                }
                controls.searchtext.val(controls.searchtext.val().toUpperCase());
            }
            var key = controls.searchtext.val();
            if (lastKey != key) {
                lastKey = key;
                scrolledContainer.find('table tr td.name').css('text-decoration', '');
                if (key) {
                    var result;
                    scrolledContainer.find('table tr td.name').each(function () {
                        if (jQuery(this).text().indexOf(key) == 0) {
                            result = this;
                            return false;
                        }
                    });
                    if (result) {
                        jQuery(result).css('text-decoration', 'blink');
                        var t = result.offsetTop * -1 + scrollContainerHeight;
                        scrolledContainer.css('top', t);
                        scrolledContainer.get(0).top = t;
                    }
                } else {
                    scrolledContainer.find('table tr').show();
                    if (!scrolling)
                        startScroll();
                    setScrollSettings("normal");
                }
            }
        });
        controls.refresh.click(function (e) {
            e.preventDefault();
            refresh();
        });
        refresh();
        if (Container.parent().is('body')) {
            jQuery('.stock-footr').remove();
            Container.addClass('popup');
        } else {
            jQuery('.stock-footr a', Container).click(function (e) {
                e.preventDefault();
                if (stocksWidgetUrl) {
                    window.open(stocksWidgetUrl, 'sctockswindow', 'menubar=no,resizable=no,width=325,height=400');
                }
            });
        }
    });
});
