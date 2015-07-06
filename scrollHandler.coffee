$ = require('jquery')
_ = require('underscore')

###
  ScrollHandler
  Copyright(c) 2014 SHIFTBRAIN - Tsukasa Tokura
  This software is released under the MIT License.
  http://opensource.org/licenses/mit-license.php
###

# require()で返されるオブジェクト
module.exports = class ScrollHandler
  constructor : ($scrollTarget, throttletime = 50) ->
    @scrollTarget = $scrollTarget
    @throttletime = throttletime
    @$window = $(window)

  setShowEvent : ($target, func, margin=0, id=null, index=null) ->
    contextObj =
      target: $target
      height: $target.height()
      method: func
      id: id
      index: index
      margin: margin
    throttled = _.throttle (=>@showscrollEvent(contextObj)), @throttletime
    @scrollTarget.on 'scroll.'+id+'show', throttled

  showscrollEvent: (contextObj) =>
    nowTargetTop = contextObj.target.position().top
    windowHeight = @$window.height()
    if nowTargetTop > -contextObj.height and nowTargetTop < windowHeight
      contextObj.method()

  removeShowEvent : (id=null) ->
    @scrollTarget.off 'scroll.'+id+'show'

  setHideEvent : ($target, func, margin=0, id=null, index=null) ->
    contextObj =
      target: $target
      height: $target.height()
      position: $target.position().top
      method: func
      id: id
      index: index
      margin: margin
    throttled = _.throttle (=> @hidescrollEvent(contextObj)), @throttletime
    @scrollTarget.on 'scroll.'+id+'hide', throttled

  hidescrollEvent: (contextObj)=>
    nowTargetTop = contextObj.target.position().top
    windowHeight = @$window.height()
    if nowTargetTop < -contextObj.height or nowTargetTop > windowHeight
      console.log nowTargetTop, -contextObj.height, windowHeight
      contextObj.method()

  removeHideEvent : (id=null) ->
    @scrollTarget.off 'scroll.'+id+'hide'

  removeAllEvent : (id=null) ->
    @scrollTarget.off 'scroll.'+id+'hide'
    @scrollTarget.off 'scroll.'+id+'show'
