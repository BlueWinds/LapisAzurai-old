/* 
	DraggScroll is a JQuery extension for scrolling by clicking and dragging from within a container.
	Author: James Climer (http://climers.com)
	Released under the Apache V2 License: http://www.apache.org/licenses/LICENSE-2.0.html
	Requires JQuery: http://jquery.com	
	Get latest version from: https://github.com/jaclimer/JQuery-DraggScroll
	
    options: Currently not used
*/
; (function ($) {
    $.fn.dragScroll = function (options) {
        /* Mouse dragg scroll */
        var x, y, top, left, down;
        var $scrollArea = $(this);

        $($scrollArea).attr("onselectstart", "return false;");   // Disable text selection in IE8

        $($scrollArea).mousedown(function (e) {
            e.preventDefault();
            down = true;
            x = e.pageX;
            y = e.pageY;
            top = $(this).scrollTop();
            left = $(this).scrollLeft();
        });
        $($scrollArea).mouseleave(function (e) {
            down = false;
        });
        $("body").mousemove(function (e) {
            if (down) {
                var newX = e.pageX;
                var newY = e.pageY;
                $($scrollArea).scrollTop(top - newY + y);
                $($scrollArea).scrollLeft(left - newX + x);
            }
        });
        $("body").mouseup(function (e) { down = false; });
    };
})(jQuery);