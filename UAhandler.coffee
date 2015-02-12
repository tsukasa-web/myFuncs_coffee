###
UA判定

【使用例】
UAHandler = require('UAHandler');

UAHandler.UA #UA
UAHandler.ios #ios ver
###

###
if.useragent.js v0.9
info: http://company.miyanavi.net/archives/987
auther: miyanavi
licence: MIT
###

#require()で返されるオブジェクト
module.exports = UAreturn

UAreturn = ->
  uaName = 'unknown'
  userAgent = window.navigator.userAgent.toLowerCase()
  appVersion = window.navigator.appVersion.toLowerCase()

  if userAgent.indexOf('msie') != -1
    uaName = 'ie'
  if appVersion.indexOf('msie 6.') != -1
    uaName = 'ie6'
  else if appVersion.indexOf('msie 7.') != -1
    uaName = 'ie7'
  else if appVersion.indexOf('msie 8.') != -1
    uaName = 'ie8'
  else if appVersion.indexOf('msie 9.') != -1
    uaName = 'ie9'
  else if appVersion.indexOf('msie 10.') != -1
    uaName = 'ie10'
  else if userAgent.indexOf('chrome') != -1
    uaName = 'chrome'
  else if userAgent.indexOf('ipad') != -1
    uaName = 'ipad'
  else if userAgent.indexOf('ipod') != -1
    uaName = 'ipod'
  else if userAgent.indexOf('iphone') != -1
    uaName = 'iphone'
    ios = (navigator.appVersion).match(/OS (\d+)_(\d+)_?(\d+)?/)
    uaName = [parseInt(ios[1], 10), parseInt(ios[2], 10), parseInt(ios[3] || 0, 10)]
  else if userAgent.indexOf('safari') != -1
    uaName = 'safari'
  else if userAgent.indexOf('gecko') != -1
    uaName = 'gecko'
  else if userAgent.indexOf('opera') != -1
    uaName = 'opera'
  else if userAgent.indexOf('android') != -1
    uaName = 'android'
  else if userAgent.indexOf('mobile') != -1
    uaName = 'mobile'

  uaObj =
    UA: uaName
    ios: ios

  return uaObj