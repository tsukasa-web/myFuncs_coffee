###
hashChange対応タブ生成
------------------------------------
optionsによる設定項目
targetContainer…タブのグループの親要素（デフォルトは'#tab-container'）
targetTablist…タブのナビゲーション（デフォルトは'.list-tab'）
targetTabcontent…表示を切り替えたいタブのコンテント要素（デフォルトは'.tab-content'）
animation…アニメーションの有無（デフォルトはtrue）
animSpeed…アニメーションスピード（デフォルトは500ms）
------------------------------------

【使用例】
#タブコンテンツ生成
tabOptions =
	targetContainer: '#tab-container-01'
	targetTablist: '.list-tab-01'
if tabOptions.targetContainer.length
	tabCreate = new Hashtab_controller(tabOptions)

###
class Hashtab_controller
	###デフォルトオプション###
	defaults:
		targetContainer: '#tab-container'
		targetTablist: '.list-tab'
		targetTabcontent: '.tab-content'
		animation: true
		animSpeed: 500

	constructor: (options) ->
		@options = $.extend {}, @defaults, options
		@targetContainer = $(@options.targetContainer)
		@targetTablist = @targetContainer.find(@options.targetTablist).find('a')
		@targetTabcontent = @targetContainer.find(@options.targetTabcontent)
		@tabLength = @targetTabcontent.length-1
		@indexArray = []
		@firstCorrespond = false

		@_tabInit()
		###hashイベントの登録###
		window.onhashchange = @_onhashChange

	_tabInit: ->
		###各タブのURLを格納###
		for n in [0..@tabLength]
			@indexArray.push(@targetTablist.eq(n).attr('href'))

		###初期表示調整###
		@firstIndex = window.location.hash
		if $.inArray(@firstIndex, @indexArray) isnt -1
			@_tabChange(@firstIndex)
		else
			@_tabChange(@indexArray[0])
		return

	###hashChange時のイベント###
	_onhashChange: =>
		@ChangedIndex = window.location.hash
		if $.inArray(@ChangedIndex, @indexArray) isnt -1
			@_tabChange(@ChangedIndex)
		return

	###tabの切り替え###
	_tabChange: (targetIndex) ->
		@targetTablist.each ->
			if targetIndex is $(this).attr('href')
				$(this).addClass('current')
			else
				$(this).removeClass('current')
			return
		@targetTabcontent.each (index, element) =>
			if targetIndex is '#'+$(element).attr('id')
				@_animationFadein($(element))
			else
				$(element).hide()
			return
		return

	###アニメーション設定###
	_animationFadein: (target) ->
		if @options.animation
			target.fadeIn(@options.animSpeed)
		else
			target.show()
		return