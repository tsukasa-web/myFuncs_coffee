###
RWD対応高さ揃え
------------------------------------
target…グループの親要素
targetChildren…高さを揃えたい要素
columns…高さを揃えたい1グループあたりの要素数（デフォルトはtarget内のtargetChildrenの数）
breakPointTarget…高さ揃えを消去する条件
------------------------------------

【使用例】
#高さ揃え
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

###
RWDheightEqualizer = (target, targetChildren, columns, breakPointTarget) ->
	equalizeFunc = ->
		$(target).each ->
			count = 0
			maxHeight = 0
			childs = []
			equalizeTarget = $(this).find(targetChildren)
			last = equalizeTarget.length - 1
			if last > 0
				#columnが無い時（null）
				columns = equalizeTarget.length  if columns is undefined

				#ウインドウリサイズ時を想定して一度付加スタイルをリセットしています
				equalizeTarget.each (i) ->
					count = i % columns
					childs[count] = $(this)
					$(this).removeAttr "style"
					maxHeight = $(this).height()  if count is 0 or $(this).height() > maxHeight
					if i is last or count is columns - 1
						$.each childs, (i, t) ->
							t.height maxHeight
					return
		return


	#ウインドウリサイズ時にspサイズ時は付加スタイル消去、他は再度リサイズ
	$(window).resize ->
		if not breakPointTarget
			equalizeFunc()
		else
			$(target).find(targetChildren).removeAttr "style"
		return

	#最初に一回高さ揃えを行う
	if not breakPointTarget
		equalizeFunc()
	return