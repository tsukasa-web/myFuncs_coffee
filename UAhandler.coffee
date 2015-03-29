###
UA判定

【使用例】
UAHandler = require('UAHandler');

UAHandler.UA #UA
UAHandler.ios #ios ver
###

UAreturn = ->
  e = null
  r = navigator.userAgent.toLowerCase()
  nv = window.navigator
  t = {
    isIE : false,
    isIE6 : false,
    isIE7 : false,
    isIE8 : false,
    isIE9 : false,
    isLtIE9 : false,
    isIE11 : false,
    isIOS : false,
    isIPhone : false,
    isIPad : false,
    isIPhone4 : false,
    isIPad3 : false,
    isAndroid : false,
    isAndroidMobile : false,
    isChrome : false,
    isSafari : false,
    isMozilla : false,
    isWebkit : false,
    isOpera : false,
    isPC : false,
    isTablet : false,
    isSmartPhone : false,
    browser : r,
    isMac : /mac/i.test(nv['platform']),
    isWin : /win/i.test(nv['platform'])
  }

  if t.isIE = /msie\s(\d+)/.test r
    n = RegExp.$1
    n *= 1
    t.isIE6 = n is 6
    t.isIE7 = n is 7
    t.isIE8 = n is 8
    t.isIE9 = n is 9
    t.isLtIE9 = n < 9
  if t.isIE7 && r.indexOf("trident/4.0") isnt -1
    t.isIE7 = false
    t.isIE8 = true
  if r.indexOf("trident/7.0") isnt -1
    t.isIE = true
    t.isIE11 = true
  if t.isIPhone = /i(phone|pod)/.test r
    t.isIPhone4 = window.devicePixelRatio is 2
  if t.isIPad = /ipad/.test r
    e = window.devicePixelRatio is 2
  t.isIOS = t.isIPhone or t.isIPad
  t.isAndroid = /android/.test r
  t.isAndroidMobile = /android(.+)?mobile/.test r
  t.isPC = !t.isIOS && !t.isAndroid
  t.isTablet = t.isIPad or t.isAndroid and t.isAndroidMobile
  t.isSmartPhone = t.isIPhone or t.isAndroidMobile
  t.isChrome = /chrome/.test r
  t.isWebkit = /webkit/.test r
  t.isOpera = /opera/.test r
  t.isMozilla = r.indexOf("compatible") < 0 and /mozilla/.test r
  t.isSafari = !t.isChrome and t.isWebkit

  return t

#require()で返されるオブジェクト
module.exports = UAreturn()