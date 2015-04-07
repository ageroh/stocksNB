jQuery(function () {
    if (typeof (stocks) != 'undefined') {
        var template = '<div class="stocks-popup" style="display:none;">    \
                            <div class="stocks-widget">                     \
                                <h1></h1>                                   \
                                <span style="display: none;" class="closebtn"></span>                      \
                                <table width="100%" cellspacing="1" border="0"> \
                                <tbody>                                         \
                                </tbody>                                         \
                                </table>                                          \
                            </div>                                              \
                         </div>';
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
            var margin = { left: 20, top: 20 };
            var location = {
                  x: margin.left + e.PageX
                , y: e.pageY + margin.top
            };
            var v = viewport();
            var t = template.find('> div');

            if (location.y + t.height() > v.y + v.cy) {
                location.y -= t.height() + 2 * margin.top;
            }
            if (location.y < v.y) {
                location.y += t.height() + 2 * margin.top;
            }

//            if (location.x + t.width() > v.x + v.cx) {
//                location.x -= t.width() + 2 * margin.left;
//            }

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
                            }
                            else if (v < 0) {
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
                        }
                        else if (value < 0) {
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



        /*
        $(' .closebtn').on('click', function (e) {
            template.hide();
        });
        

        $(' .stock-table-main table tr td').on('click', function (e) {
                var cell = jQuery(this);
                var key = cell.text();
                if (updateTemplate(key)) {
                    template.show();
                    positionTemplate(e);

                }

        });
        */
        


        jQuery(".stock-table-main td").hover(
			function (e) {
			    var cell = jQuery(this);
			    var key = cell.text();
			    if (updateTemplate(key)) {
			        template.show();
			        positionTemplate(e);

			    }

			},
			function () {

			    template.hide();
			}
		);
    }

    jQuery(".stocks-widget-for-others").each(function () {
        var Container = jQuery(this);
        var refreshURL = '/GetStocksForWidgetN.aspx';
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
                }
                else {
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
            }
            else if (top > scrollContainerHeight && scrollIncrement <= 0) {
                top = scrolledContainer.find('table').height() * -1;
            }
            else {
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

            html += '<thead><tr><th colspan="5">Τελευταία Ενημέρωση: ' + lastUpdate + '</th></tr></thead>';
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
                html += '<td class="valStock" style="display:none;">' + rowData['val'] + '</td>';
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
                        $(".scrolled .name a").on("click", function (ev) {
                            ev.preventDefault();
                            stopScroll();
                            
                            //redirect to correct page.
                            if( $(this).parent().parent().find(".valStock").text() != null)
                               window.top.location.href = "http://www.news.gr/stockdetails?symbol=" + $(this).parent().parent().find(".valStock").text();
                            
                        });
                    }
                },
                error: function (a, b, c, d) {

                }
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
        var k = { "A": "Α", "B": "Β", "C": "Ψ", "D": "Δ", "E": "Ε", "F": "Φ", "G": "Γ", "H": "Η", "I": "Ι", "J": "Ξ", "K": "Κ", "L": "Λ", "M": "Μ", "N": "Ν", "O": "Ο", "P": "Π", "Q": ";", "R": "Ρ", "S": "Σ", "T": "Τ", "U": "Θ", "V": "Ω", "W": "ς", "X": "Χ", "Y": "Υ", "Z": "Ζ" };
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
                    //stopScroll();
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
                }
                else {
                    scrolledContainer.find('table tr').show();
                    //resetScroll();
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
        }
        else {
            jQuery('.stock-footr a', Container).click(function (e) {
                e.preventDefault();
                if (stocksWidgetUrl) {
                    window.open(stocksWidgetUrl, 'sctockswindow', 'menubar=no,resizable=no,width=325,height=400');
                }
            });
        }
    });
});