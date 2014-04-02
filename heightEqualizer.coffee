###
高さ揃え
------------------------------------
target…グループの親要素
targetChildren…高さを揃えたい要素
columns…高さを揃えたい1グループあたりの要素数（デフォルトはtarget内のtargetChildrenの数）
------------------------------------

【使用例】
#高さ揃え
layout3col02 = $('.col-03-02')
layout3col03 = $('.col-03-03')
layout4col01 = $('.col-04-01')
$(window).load ->
	if layout3col02.length and $('.box-03').length
		heightEqualizer layout3col02, '.box-03'
	if layout3col03.length
		heightEqualizer layout3col03, '.segment'
	if layout4col01.length
		heightEqualizer layout4col01, '.segment'
	return

###
heightEqualizer = (target, targetChildren, columns) ->
	target.each ->
		count = 0
		maxHeight = 0
		childs = []
		equalizeTarget = $(this).find(targetChildren)
		last = equalizeTarget.length - 1
		if last > 0
			if columns is undefined
				columns = equalizeTarget.length
		return equalizeTarget.each (i) ->
			count = i % columns
			childs[count] = $(this)
			if count is 0 or $(this).height() > maxHeight
				maxHeight = $(this).height()
			if i is last or count == columns - 1
				$.each(childs, (i, t)-> t.height(maxHeight))
			return
		return
	return