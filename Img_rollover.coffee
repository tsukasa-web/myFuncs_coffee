###
ロールオーバー
------------------------------------
element…ロールオーバー対象要素
normalState…ロールオーバー前の画像の接尾辞
hoverState…ロールオーバー後の画像の接尾辞
currentClass…ロールオーバーイベントを起こしたくない際に付加するクラス（グロナビのカレント等）

【使用例】
#ロールオーバー設定
 hovertOptions =
    element: $('.roll')
	normalState: '_normal'
	hoverState: '_hover'
    currentClass: 'now'
imgHover = new Img_rollover(hovertOptions)

------------------------------------
###
class Img_rollover
	defaults:
		element: $('a')
		normalState: '_o'
		hoverState: '_h'
		currentClass: 'current'

	constructor: (options) ->
		@options = $.extend {}, @defaults, options
		@element = @options.element
		@img = @element.find('img')
		@normalState = @options.normalState
		@hoverState = @options.hoverState

		@img.each (index, element) =>
			@targetImage = $(element)
			@targetParent = @targetImage.parent(@element)
			if not @targetImage.hasClass(@options.currentClass)
				srcs = @_prepareSrcs(@targetImage)
				@_preload(srcs.src_on)
				@_eventify(@targetParent, @targetImage, srcs.src_off, srcs.src_on)
			return

	_prepareSrcs : (targetImage) ->
		src_off = targetImage.attr 'src'
		src =
			src_off : src_off
			src_on : src_off.replace @normalState, @hoverState
		return src

	_preload: (src_on) ->
		$('<img />').attr 'src', src_on
		return

	_eventify: (targetParent, targetImage, src_off, src_on) ->
		targetParent.on 'mouseenter focus', => @_toOver(targetImage, src_on)
		targetParent.on 'mouseleave blur', => @_toNormal(targetImage, src_off)
		return

	_toOver: (targetImage, src_on) ->
		targetImage.attr 'src', src_on
		return

	_toNormal: (targetImage, src_off) ->
		targetImage.attr 'src', src_off
		return