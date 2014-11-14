$ = require 'jquery' # bower経由
$ = require 'jquery.easing' # bower経由

###
RAFによるEasing分割でパラメータを更新する
------------------------------------
fps…1秒あたりのフレーム数
func…実行関数
------------------------------------

【使用例】
RAFeasingHandler = require('RAFeasingHandler');
RAFeasingOption =
  targetParam : hoge
  acTime : 2
  acEasing : $.easing.easeInSine
  deTime : 1
  deEasing : $.easing.easeOutSine
  minValue : 30
  maxValue : 200

rafEasingHandler = new RAFeasingHandler(RAFeasingOption)
rafEasingHandler.rafSpeedUp() #raf/加速開始
rafEasingHandler.rafSpeedDown() #減速開始、止まるとraf停止
###

#require()で返されるオブジェクト
module.exports = class RAFeasingHandler
#class RAFeasingHandler
  defaults:
    targetParam : null #増減させたいパラメータ
    acTime : 3 #フィルムの最大速度到達時間
    acEasing : $.easing.easeInSine #加速のEasing
    deTime : 2 #フィルムの停止到達時間
    deEasing : $.easing.easeOutSine #減速のEasing
    minValue : 0
    maxValue : 100

  constructor:->
    @options = $.extend {}, @defaults, options
    @requestId = null #RAFに使用するID
    @setTimerId = null #Timeoutに使用するID
    @fpsInterval = 1000 / @options.fps #RAFのfps調整に使用するフレーム間隔の変数
    @timeLog = Date.now() #RAFのfps調整に使用する変数
    @acSpeedArray = [] #フレーム分割した加速度を格納する配列
    @deSpeedArray = [] #フレーム分割した減速度を格納する配列
    @currentFrame = 0 #現在のフレーム位置
    @vector = 1 #反転のフラグ
    @stopping = false #減速中かどうかのフラグ

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

    @speedSpilt()

  speedSpilt: ->
    #フレーム分割した加速度の配列作成
    @acSpeedArray = []
    #（fps*到達までの時間）で全体フレーム数を算出
    max = @options.fps * @options.acTime - 1
    for i in [0..max]
      @acSpeedArray[i] = @options.acEasing 0, i, @options.minValue, @options.maxValue, max

    #フレーム分割した減速度の配列作成
    @deSpeedArray = []
    #（fps*到達までの時間）で全体フレーム数を算出
    max = @options.fps * @options.deTime - 1
    for i in [0..max]
      @deSpeedArray[i] = @options.deEasing 0, max - i, @options.minValue, @options.maxValue, max

    #console.log @acSpeedArray
    #console.log @deSpeedArray

  _rafInit: =>
    @requestId = @requestAnimationFrame(@rafInit)
    @_rafFunction

  rafSpeedUp: =>
    @stopping = false
    if !@requestId
      @_rafInit()

  rafSpeedDown: =>
    @stopping = true

  _rafFunction: ->
    now = Date.now()
    elapsed = now - @timeLog
    if elapsed > @fpsInterval
      @timeLog = now - (elapsed % @fpsInterval)

      @_rafParamChange

  _rafParamChange: ->
    if @stopping
      if @vector > 0
        @vector = -1

        if @currentFrame < @acSpeedArray.length
          val = @acSpeedArray[@currentFrame]
          for v, i in @deSpeedArray
            if val >= v
              @currentFrame = i
              break
        else
          @currentFrame = 0

      @currentFrame = @deSpeedArray.length - 1 if @currentFrame >= @deSpeedArray.length
      @options.targetParam = @deSpeedArray[@currentFrame]

      if @options.targetParam  == @options.minValue
        @vector = 1
        @options.targetParam  = @options.minValue
        @currentFrame = 0
        @stopping = false
        @rafRemove()
        return

    else
      if @vector < 0
        @vector = 1

        if @currentFrame < @deSpeedArray.length
          val = @deSpeedArray[@currentFrame]
          for v, i in @acSpeedArray
            if val <= v
              @currentFrame = i
              break
        else
          @currentFrame = @acSpeedArray.length - 1

      @currentFrame = @acSpeedArray.length - 1 if @currentFrame >= @acSpeedArray.length
      @options.targetParam  = @acSpeedArray[@currentFrame]

    @currentFrame++
