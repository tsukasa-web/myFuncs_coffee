$ = require 'jquery' # bower経由
RAFhandler = require 'RAFhandler'

###
RAFとMouseMoveによるマウス移動と連動したアニメーション用モジュール
------------------------------------
stage…mouse位置を取るターゲット
target…パラメータを変更するターゲット（処理内容次第では不要となる）
maxMrX…X座標計算値の最大値
maxMrY…Y座標計算値の最大値
transOffset…計算時の補間値（処理内容次第では不要となる）
newRatio…計算時のマウス位置補正のレート
stageRatio…計算時のステージサイズのレート
fps…1秒あたりのフレーム数
------------------------------------

【使用例】
MouseMoveParamChange = require('MouseMoveParamChange');
MouseMoveParamChangeOption =
  stage: $('hoge')
  target: [$('hoge'),$('hogehoge')]
  maxMrX: 0.4
  maxMrY: 0.3
  transOffset: 100
  newRatio: 0.02
  stageRatio: 0.8
  fps: 60

MMPC = new MouseMoveParamChange(MouseMoveParamChangeOption)
MMPC.addTarget([hoge,hogehoge]) #targetの配列に追加
MMPC.stopEvent([hoge,hogehoge]) #targetの配列から削除
MMPC.startEvent() #RAF開始
MMPC.stopEvent() #RAF停止
MMPC.changeFPS() #FPS変更
###

#require()で返されるオブジェクト
module.exports = class MouseMoveParamChange
#class MouseMoveParamChange
  defaults:
    stage: $(window)
    target: [] #不要な場合は削除推奨
    maxMrX: 0.4
    maxMrY: 0.3
    transOffset: 100
    newRatio: 0.02
    stageRatio: 0.8
    fps: 60

  constructor: ->
    @window = $(window)
    @options = $.extend {}, @defaults, options
    @mouse =
      x: 0
      y: 0
      ratio_x: 0
      ratio_y: 0
    @mouse_new =
      x: 0
      y: 0
      ratio_x: 0
      ratio_y: 0
    @RAFOption =
      fps: @options.fps
      func: @_changeParam()
    @rafHandler = new RAFhandler(@RAFOption)

  _onMouseMove: (e)->
    @mouse = @_getPagePos(e)
    @mouse.x -= @options.stage.width * 0.5
    @mouse.y -= @options.stage.height * 0.5
    @mouse.ratio_x = @mouse.x / @options.stage.width * 0.5
    @mouse.ratio_y = @mouse.y / @options.stage.height * 0.5

  _getPagePos: (e)->
    pos =
      x: 0
      y: 0
    if "ontouchstart" in window
      if e.touches != null
        touch = e.touches[0]
      else
        touch = e.originalEvent.touches[0]
      pos.x = touch.clientX
      pos.y = touch.clientY
    else
      pos.x = e.clientX
      pos.y = e.clientY
    return pos

  _changeParam: ->
    @mouse_new.x += (@mouse.x - @mouse_new.x) * @option.newRatio
    @mouse_new.y += (@mouse.y - @mouse_new.y) * @option.newRatio
    @mouse_new.ratio_x = @mouse_new.x / @option.stage.width * @option.stageRatio
    @mouse_new.ratio_y = @mouse_new.y / @option.stage.height * @option.stageRatio

    mrx  = Math.min(@mouse_new.ratio_x , @option.maxMrX)
    mry  = Math.min(@mouse_new.ratio_y , @option.maxMrY)

    #------------処理内容を記述------------
    for i in [0...@option.target.length]
      @option.target[i].css(@_changeTranslate(mry * 5, -mrx * 3, mrx * -@option.transOffset, mry * -@option.transOffset, 0))
    #/------------処理内容を記述------------

  #transform追加関数（不要な場合は削除推奨）
  _changeTranslate: (degX,degY,transX,transY,transZ) ->
    css3 = "rotateX("+degX+"deg) rotateY("+degY+"deg) translateX("+transX+"px) translateY("+transY+"px) translateZ("+transZ+"px)"

    return {
      "-webkit-transform" : css3
      "-moz-transform"	: css3
      "-o-transform"		: css3
      "-ms-transform"		: css3
      "transform"			: css3
    }

  #target追加関数（不要な場合は削除推奨）
  addTarget: (targetArray)->
    for i in [0...targetArray.length]
      @option.target.push(targetArray[i])

  #target削除関数（不要な場合は削除推奨）
  removeTarget: (targetArray)->
    for i1 in [0...targetArray.length]
      for i2 in [0...@option.target.length]
        if @option.target[i2] is targetArray[i1]
          @option.target.splice(i1, 1)

  startEvent: ->
    @rafHandler.rafAdd()
    @window.on("mousemove.MMPC", @_onMouseMove)

  stopEvent: ->
    @rafHandler.rafRemove()
    @window.off("mousemove.MMPC", @_onMouseMove)

  changeFPS: (fps)->
    @rafHandler.rafFPSChange(fps)