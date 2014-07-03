// Generated by CoffeeScript 1.7.1

/*
RWD対応高さ揃え
------------------------------------
target…グループの親要素
targetChildren…高さを揃えたい要素
columns…高さを揃えたい1グループあたりの要素数（デフォルトはtarget内のtargetChildrenの数）
breakPointTarget…高さ揃えを消去する条件（特に無い場合はflaseを渡してください）
------------------------------------

【使用例】
 *高さ揃え
layout3col02 = $('.col-03-02')
layout3col03 = $('.col-03-03')
layout4col01 = $('.col-04-01')
breakPointTarget = $('hogehoge').is(':visible')
$(window).load ->
	if layout3col02.length and $('.box-03').length
		heightEqualizer layout3col02, '.box-03', breakPointTarget
	if layout3col03.length
		heightEqualizer layout3col03, '.segment', breakPointTarget
	if layout4col01.length
		heightEqualizer layout4col01, '.segment', breakPointTarget
	return
 */

(function() {
  var RWDheightEqualizer;

  RWDheightEqualizer = function(target, targetChildren, columns, breakPointTarget) {
    var equalizeFunc;
    equalizeFunc = function() {
      $(target).each(function() {
        var childs, count, equalizeTarget, last, maxHeight;
        count = 0;
        maxHeight = 0;
        childs = [];
        equalizeTarget = $(this).find(targetChildren);
        last = equalizeTarget.length - 1;
        if (last > 0) {
          if (columns === void 0) {
            columns = equalizeTarget.length;
          }
          return equalizeTarget.each(function(i) {
            count = i % columns;
            childs[count] = $(this);
            $(this).removeAttr("style");
            if (count === 0 || $(this).height() > maxHeight) {
              maxHeight = $(this).height();
            }
            if (i === last || count === columns - 1) {
              $.each(childs, function(i, t) {
                return t.height(maxHeight);
              });
            }
          });
        }
      });
    };
    $(window).resize(function() {
      if (!breakPointTarget) {
        equalizeFunc();
      } else {
        $(target).find(targetChildren).removeAttr("style");
      }
    });
    if (!breakPointTarget) {
      equalizeFunc();
    }
  };

}).call(this);