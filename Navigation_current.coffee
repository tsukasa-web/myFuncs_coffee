###
ナビゲーションカレント設定
------------------------------------
target…ターゲットのナビゲーションとなる大枠の対象
currentParent…クラスの付け外しをしたい対象の親要素
currentTarget…クラスの付け外しをしたい対象要素
currentDirectClass…現在地となるcurrentTargetに付加されるクラス名
currentParentClass…現在地となるcurrentTargetの親になるcurrentTargetに付加されるクラス名
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
    currentDirectClass: '.now'
	currentParentClass: '.now-parent'
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
		currentDirectClass: 'current-direct'
		currentParentClass: 'current'
		indexNum: 1

	constructor: (options) ->
		@options = $.extend {}, @defaults, options
		@url = window.location.pathname
		@targetNavi = @options.targetNavi
		@currentParent  = @options.currentParent
		@currentTarget = @options.currentTarget
		@classTarget = $(@targetNavi).find(@currentTarget)
		@currentDirectClass = @options.currentDirectClass
		@currentParentClass = @options.currentParentClass
		@indexNum = @options.indexNum
		@nowindexNum

		@urlArray = @_urlSpilt()
		@classTarget.find(@currentTarget).hide()
		@_currentAdd()

	_urlSpilt: ->
		urlArray = []
		urlString = new String()
		for n in [1..@indexNum]
			for i in [1..n]
				if @url.split('/')[i] isnt '' and @url.split('/')[i] isnt undefined
					urlString += '/' + @url.split('/')[i]
			if @url.split('/')[n] isnt '' and @url.split('/')[n] isnt undefined
				urlString += '/'
				urlArray.push(urlString)
				urlString = ""
		@nowindexNum = urlArray.length
		if @nowindexNum < @indexNum
			@indexNum = @nowindexNum
		return urlArray

	_currentAdd: ->
		@classTarget.each (index, element) =>
			targetElements = $(element)
			@hasUrl = targetElements.find('a').attr('href')
			if @urlArray[@indexNum - 1] is @hasUrl
				targetElements.addClass(@currentDirectClass)
				targetElements.children(@currentParent).children(@currentTarget).show()
				targetElements.parents(@currentTarget).each (index, element) =>
					elements = $(element)
					for n in [0..@indexNum]
						if @urlArray[@indexNum-1] is @hasUrl
							elements.addClass(@currentParentClass)
		$('.'+@currentParentClass).children(@currentParent).children(@currentTarget).show()
		return