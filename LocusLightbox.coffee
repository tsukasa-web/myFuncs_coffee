$ = require('jquery')
_ = require('underscore')
UA = require('./UAhandler')

module.exports = class LocusLightbox
  defaults:
    targetClass: '.js_lightbox'
    targetData: 'href'
    resizeRate: 'both'
    album: false
    autoAlbum: true
    closeIconSize: 50

  constructor: (options)->
    @$window = $(window)
    @options = $.extend {}, @defaults, options
    @targetEl = $(@options.targetClass)
    @album = @options.album
    @nowImgNum = 0
    @closeIconHalf = @options.closeIconSize/2

    supportTouch = 'ontouchend' in window
    if supportTouch
      @EVENTNAME_TOUCHSTART = 'touchstart'
    else
      @EVENTNAME_TOUCHSTART = 'click'

    if @options.autoAlbum
      @album = {}
      _.each @targetEl,(element,index,list)=>
        $element = $(element)
        if $element.attr('data-album') isnt undefined
          albumName = $element.attr('data-album')
          if @album[albumName] is undefined
            @album[albumName] = []
          @album[albumName].push $element.attr('href')

    #lightboxTemplate
    $("
      <div class='lightboxOverlay'>
        <div class='lightboxContainer'>
          <figure class='lightboxImg'>
            <img src='' alt=''/>
            <i class='load-animation'>
              <span class='circle-01'></span>
              <span class='circle-02'></span>
              <span class='circle-03'></span>
            </i>
          </figure>
        </div>
        <a href='#' class='lightboxArrowRight'>
          <span class='icon-arrow-line-01'></span>
          <span class='icon-arrow-line-02'></span>
        </a>
        <a href='#' class='lightboxArrowLeft'>
          <span class='icon-arrow-line-01'></span>
          <span class='icon-arrow-line-02'></span>
        </a>
        <div class='lightboxClose' href='#'>
          <span class='close-line-01'></span>
          <span class='close-line-02'></span>
        </div>
      </div>
    ").appendTo $('body')

    @lightboxOverlay = $('.lightboxOverlay')
    @lightboxContainer = $('.lightboxContainer')
    @lightboxClosebtn = $('.lightboxClose')
    @lightboxLoadicon = $('.load-animation')
    @lightboxPrevBtn = $('.lightboxArrowLeft')
    @lightboxNextBtn = $('.lightboxArrowRight')
    @imgContainer = $('.lightboxImg')
    @lightboxImg = @imgContainer.find('img')

    if @options.resizeRate is 'width'
      @lightboxContainer.addClass 'width-rate'
    else if @options.resizeRate is 'height'
      @lightboxContainer.addClass 'height-rate'

    #MoveCloseBtnAnimation(not iphone and android)
    if UA.isPC is true
      @lightboxClosebtn.addClass 'lightboxClose-move'
    else
      @lightboxClosebtn.hide()

  addEvent: ->
    #各種イベントの設定
    @targetEl.each (id, object) =>
      $(object).on @EVENTNAME_TOUCHSTART, @openLightbox
    @lightboxOverlay.on @EVENTNAME_TOUCHSTART, @closeLightbox
    if @album
      @lightboxPrevBtn.on 'click', @prevImg
      @lightboxNextBtn.on 'click', @nextImg

  mouseCloseBtnMove: (e) =>
    e.preventDefault()
    mouse = @getPagePos(e)
    @lightboxClosebtn.css @changeTranslate(0,0,mouse.x-@closeIconHalf,mouse.y-@closeIconHalf,0)
  #console.log('mouseX = ' + mouse.x + ', mouseY = ' + mouse.y)

  getPagePos: (e) ->
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

  #transform追加関数
  changeTranslate: (degX,degY,transX,transY,transZ) ->
    css3 = "rotateX("+degX+"deg) rotateY("+degY+"deg) translateX("+transX+"px) translateY("+transY+"px) translateZ("+transZ+"px)"

    return {
    "-webkit-transform" : css3
    "-moz-transform"	: css3
    "-o-transform"		: css3
    "-ms-transform"		: css3
    "transform"			: css3
    }

  openLightbox: (e) =>
    e.preventDefault()
    #albumの初期化
    targetUrl = null
    @lightboxOverlay.addClass 'open'
    @lightboxContainer.addClass 'open'
    @lightboxClosebtn.addClass 'open'

    #eventのcurrentTargetがもつdata-large-imgを取得し、ロード関数へ
    targetUrl = $(e.currentTarget).attr @options.targetData
    targetAlbum = $(e.currentTarget).attr('data-album')
    @loadImg targetUrl, targetAlbum

    #MoveCloseBtnAnimation(not iphone and android)
    if UA.isPC is true
      mouse = @getPagePos(e)
      @lightboxClosebtn.css @changeTranslate(0, 0, mouse.x-@closeIconHalf, mouse.y-@closeIconHalf, 0)
      @$window.on 'mousemove.lightbox', _.throttle (e)=>
        @mouseCloseBtnMove(e)
      , 10

      if @album
        @lightboxPrevBtn.on 'mouseenter', @closeBtnFadeOut
        @lightboxNextBtn.on 'mouseenter', @closeBtnFadeOut
        @lightboxPrevBtn.on 'mouseleave', @closeBtnFadeIn
        @lightboxNextBtn.on 'mouseleave', @closeBtnFadeIn

  closeLightbox: (e) =>
    e.preventDefault()
    @lightboxOverlay.addClass 'close'

    @lightboxOverlay.on 'webkitAnimationEnd oanimationend msAnimationEnd animationend',
      (e) =>
        @lightboxOverlay.removeClass 'open close'
        @lightboxContainer.removeClass 'open load-finish'
        if @options.resizeRate is 'both'
          @lightboxContainer.removeClass 'width-rate height-rate'
        @lightboxClosebtn.removeClass 'open'
        @lightboxLoadicon.removeClass 'load-finish'
        @lightboxImg.attr 'src', ''

        if @options.album
          @lightboxPrevBtn.hide()
          @lightboxNextBtn.hide()

        #MoveCloseBtnAnimation(not iphone and android)
        if UA.isPC is true
          @$window.off 'mousemove.lightbox'
          if @album
            @lightboxPrevBtn.off 'mouseenter'
            @lightboxNextBtn.off 'mouseenter'
            @lightboxPrevBtn.off 'mouseleave'
            @lightboxNextBtn.off 'mouseleave'
        if @options.resizeRate is 'both'
          @$window.off 'resize.lightbox'
        @lightboxOverlay.off 'webkitAnimationEnd oanimationend msAnimationEnd animationend'

  loadImg: (targetImg, targetAlbum=false, albumMove=false) ->
    if targetAlbum
      @nowImgAlbum = targetAlbum
      @nowImgIndex = _.indexOf(@album[targetAlbum], targetImg)
    preloader = new Image()
    preloader.onload = =>
      @lightboxImg.attr 'src', targetImg
      @lightboxLoadicon.fadeOut()

      if albumMove
        @imgContainer.addClass 'load-finish'
        @imgContainer.on 'webkitAnimationEnd oanimationend msAnimationEnd animationend',
          (e) =>
            @imgContainer.removeClass 'load-start load-finish'
            @imgContainer.off 'webkitAnimationEnd oanimationend msAnimationEnd animationend'

      else
        @lightboxContainer.addClass 'load-finish'

      if targetAlbum
        if @nowImgIndex isnt 0
          @lightboxPrevBtn.fadeIn()
        if @nowImgIndex isnt @album[targetAlbum].length-1
          @lightboxNextBtn.fadeIn()

      if @options.resizeRate is 'both'
        @$window.on('resize.lightbox', @resizeLightbox).trigger 'resize'
    preloader.src = targetImg

  resizeLightbox: (e) =>
    windowWidth = @$window.width()
    windowHeight = @$window.height()
    windwRate = windowWidth/windowHeight
    imgWidth = @lightboxImg.width()
    imgHeight = @lightboxImg.height()
    imgRate = imgWidth/imgHeight

    @lightboxContainer.removeClass 'height-rate'
    @lightboxContainer.removeClass 'width-rate'

    if imgRate > windwRate
      @lightboxContainer.removeClass 'height-rate'
      @lightboxContainer.addClass 'width-rate'
    else
      @lightboxContainer.removeClass 'width-rate'
      @lightboxContainer.addClass 'height-rate'

  #closeBtn Rollover FadeIn
  closeBtnFadeIn: =>
    @lightboxOverlay.on 'click', (e)=>
      e.preventDefault()
      @closeLightbox(e)
    @lightboxClosebtn.fadeIn()

  #closeBtn Rollover FadeOut
  closeBtnFadeOut: =>
    @lightboxOverlay.off 'click'
    @lightboxClosebtn.fadeOut()

  nextImg: (e) =>
    if UA.isPC is true
      e.preventDefault()
    else
      e.stopPropagation()
    @lightboxLoadicon.fadeIn()
    if @nowImgIndex+1 is @album[@nowImgAlbum].length-1
      @lightboxNextBtn.hide()
    @imgContainer.addClass 'load-start'
    @imgContainer.on 'webkitAnimationEnd oanimationend msAnimationEnd animationend',
      (e) =>
        @loadImg @album[@nowImgAlbum][@nowImgIndex+1], @nowImgAlbum, true
        @imgContainer.off 'webkitAnimationEnd oanimationend msAnimationEnd animationend'

  prevImg: (e) =>
    if UA.isPC is true
      e.preventDefault()
    else
      e.stopPropagation()
    @lightboxLoadicon.show()
    if @nowImgIndex-1 is 0
      @lightboxPrevBtn.hide()
    @imgContainer.addClass 'load-start'
    @imgContainer.on 'webkitAnimationEnd oanimationend msAnimationEnd animationend',
      (e) =>
        @loadImg @album[@nowImgAlbum][@nowImgIndex-1], @nowImgAlbum, true
        @imgContainer.off 'webkitAnimationEnd oanimationend msAnimationEnd animationend'