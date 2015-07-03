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
  constructor : ->
    @$window = $(window)
    @throttletime = 50

  setShowEvent : ($target, func, id, margin) ->
    contextObj =
      target: $target
      height: $target.height()
      position: $target.offset().top
      method: func
      id: id
      margin: margin
    throttled = _.throttle((=>@showscrollEvent(contextObj)), @throttletime)
    @$window.on('scroll.'+id+'show', throttled)

  showscrollEvent: (contextObj) =>
    nowScrollPoint = @$window.scrollTop()
    windowHeight = @$window.height()
    if nowScrollPoint >= contextObj.position - windowHeight + contextObj.margin && nowScrollPoint <= contextObj.position + contextObj.height
      contextObj.method()

  removeShowEvent : (id) ->
    @$window.off('scroll.'+id+'show')

  setHideEvent : ($target, func, id) ->
    contextObj =
      target: $target
      height: $target.height()
      position: $target.offset().top
      method: func
    throttled = _.throttle((=> @hidescrollEvent(contextObj)), @throttletime)
    @$window.on('scroll.'+id+'hide', throttled)

  hidescrollEvent: (contextObj)=>
    nowScrollPoint = @$window.scrollTop()
    windowHeight = @$window.height()
    if nowScrollPoint < contextObj.position - windowHeight || nowScrollPoint > contextObj.position + contextObj.height
      contextObj.method()

  removeHideEvent : (id) ->
    @$window.off('scroll.'+id+'hide')
