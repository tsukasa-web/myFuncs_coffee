$ = require 'jquery' # bower経由

###
RAF設定
------------------------------------
fps…1秒あたりのフレーム数
func…実行関数
------------------------------------

【使用例】
RAFhandler = require('RAFhandler');
RAFOption =
  fps: 30
	func: hogehoge()

rafHandler = new RAFhandler(RAFOption)
rafHandler.rafInit() #RAF開始
rafHandler.rafRemove() #RAF停止
rafHandler.rafFuncChange(fuga()) #RAFの実行関数変更
###

#require()で返されるオブジェクト
module.exports = class RAFhandler
#class RAFhandler
  defaults:
    fps: 60
    func: () -> console.log("RAF working.")

  constructor:->
    @options = $.extend {}, @defaults, options
    @requestId = null #RAFに使用するID
    @setTimerId = null #Timeoutに使用するID
    @fpsInterval = 1000 / @options.fps #RAFのfps調整に使用するフレーム間隔の変数
    @timeLog = Date.now() #RAFのfps調整に使用する変数

    #RAFの宣言（fallback付）
    @requestAnimationFrame =
      (window.requestAnimationFrame and window.requestAnimationFrame.bind(window)) or
        (window.webkitRequestAnimationFrame and window.webkitRequestAnimationFrame.bind(window)) or
        (window.mozRequestAnimationFrame and window.mozRequestAnimationFrame.bind(window)) or
        (window.oRequestAnimationFrame and window.oRequestAnimationFrame.bind(window)) or
        (window.msRequestAnimationFrame and window.msRequestAnimationFrame.bind(window)) or
        (callback,element) ->
          @setTimerId = window.setTimeout(callback, 1000 / 60)

    #キャンセル用RAFの宣言（fallback付）
    @cancelAnimationFrame =
      (window.cancelAnimationFrame and window.cancelAnimationFrame.bind(window)) or
        (window.webkitCancelAnimationFrame and window.webkitCancelAnimationFrame.bind(window)) or
        (window.mozCancelAnimationFrame and window.mozCancelAnimationFrame.bind(window)) or
        (window.oCancelAnimationFrame and window.oCancelAnimationFrame.bind(window)) or
        (window.msCancelAnimationFrame and window.msCancelAnimationFrame.bind(window)) or
        (callback,element) ->
          window.clearTimeout(@setTimerId)

  rafInit: =>
    @requestId = @requestAnimationFrame(@rafInit)
    @rafFunction

  rafRemove: ->
    @cancelAnimationFrame(@requestId)
    @requestId = null

  rafFuncChange: (func)->
    @options.func = func

  rafFunction: ->
    #RAFのフレーム調整
    now = Date.now()
    elapsed = now - @timeLog
    if elapsed > @fpsInterval
      @timeLog = now - (elapsed % @fpsInterval)

      @options.func