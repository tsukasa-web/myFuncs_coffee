###
ナビゲーションカレント設定
------------------------------------
target…ターゲットのナビゲーションとなる大枠の対象
currentParent…クラスの付け外しをしたい対象の親要素
currentTarget…クラスの付け外しをしたい対象要素
indexNum…ナビゲーションの階層数（グロナビだと1に相当・デフォルトは1）
------------------------------------

【使用例】
#ナビゲーションカレント
globalnaviOptions =
	targetNavi: '.global-list'
	currentParent: 'ul'
	currentTarget: 'li'
	indexNum: 1
localnaviOptions =
	targetNavi: '.side-list'
	currentParent: 'ul'
	currentTarget: 'li'
	indexNum: 3
globalSet = new Navigation_current(globalnaviOptions)
localSet = new Navigation_current(localnaviOptions)

###
class Navigation_current
	###デフォルトオプション###
	defaults :
		targetNavi: '.global-navigation'
		currentParent: 'ul'
		currentTarget: 'li'
		indexNum: 1

	constructor: (options) ->
		@options = $.extend {}, @defaults, options
		@url = window.location.pathname
		@urlArray = []
		@urlString = new String()
		@targetNavi = @options.targetNavi
		@currentParent  = @options.currentParent
		@currentTarget = @options.currentTarget
		@classTarget = $(@targetNavi).find(@currentTarget)
		@indexNum = @options.indexNum

		@_urlSpilt()
		@classTarget.find(@currentTarget).hide()
		@_currentAdd()

	_urlSpilt: ->
		for n in [1..@indexNum]
			for i in [1..n]
				@urlString += '/' + @url.split('/')[i]
			@urlString += '/'
			@urlArray.push(@urlString)
			@urlString = ""
		return

	_currentAdd: ->
		@classTarget.each (index, element) =>
			targetElements = $(element)
			@hasUrl = targetElements.find('a').attr('href')
			if @urlArray[@indexNum - 1] is @hasUrl
				targetElements.addClass('current-direct')
				targetElements.parents(@currentTarget).each (index, element) =>
					elements = $(element)
					for n in [0..@indexNum]
						if @urlArray[@indexNum-1] is @hasUrl
							elements.addClass('current')
					return
			return
		$('.current').children(@currentParent).children(@currentTarget).show()
		return