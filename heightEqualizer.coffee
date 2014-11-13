$ = require 'jquery' # bower経由

###
高さ揃え
------------------------------------
target…グループの親要素
targetChildren…高さを揃えたい要素
columns…高さを揃えたい1グループあたりの要素数（デフォルトはtarget内のtargetChildrenの数）
------------------------------------

【使用例】
heightEqualizer = require('heightEqualizer');
$(window).load ->
	if $('.col-03-02').length and $('.box-03').length
		heightEqualize = new heightEqualizer($('.col-03-02'),$('.box-03'), 3)
  	heightEqualize.equalize() #リサイズ
  	heightEqualize.resizeOn() #リサイズをonで登録
  	heightEqualize.resizeOff() #リサイズをoffで解除
	return
###

#require()で返されるオブジェクト
module.exports = class heightEqualizer
#class heightEqualizer
	constructor : ($target, $targetChildren, columns) ->
		@target = $target
		@targetChildren = $targetChildren
		@columNum = columns
		return

	equalize : ->
		@target.each ->
			count = 0
			maxHeight = 0
			childs = []
			equalizeTarget = @.find(@targetChildren[0])
			last = equalizeTarget.length - 1
			if last > 0
				#columnが無い時（null）
				@columNum = equalizeTarget.length  if @columNum is undefined

				#ウインドウリサイズ時を想定して一度付加スタイルをリセットしています
				equalizeTarget.each (index, element) =>
					count = index % @columNum
					childs[count] = $(element)
					$(element).removeAttr "style"
					maxHeight = $(this).height()  if count is 0 or $(this).height() > maxHeight
					if index is last or count is columns - 1
						$.each childs, (i, t) ->
							t.height maxHeight
							return
					return
		return

	resizeOn : ->
		$(window).on 'resize', ()=> @equalizeFunc()
		return

	resizeOff : ->
		$(window).off 'resize', ()=> @equalizeFunc()
		return