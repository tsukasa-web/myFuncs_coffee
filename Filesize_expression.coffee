$ = require 'jquery' # bower経由

###
fileSizeGetter module.ver
---------------------------------
aタグでリンクされたfileのサイズをテキストとして挿入するjQuery依存モジュール

fork from filesizeGetter
http://mashimonator.weblike.jp/storage/library/20091118_001/demo/fileSizeGetter/js/fileSizeGetter.js
---------------------------------
【使用例】
extensionに取得したいファイル形式を配列で格納します。
テキストを挿入したい各種ファイルをリンクしているaタグ（jQueryオブジェクト）を指定します。defaultは$('a')になってます。
挿入するテキストのテンプレ内容をいじりたい時は#{@_convUnit(size)}部分を修正してください。

filesizeGet = require('filesizeOption');
filesizeOption =
  target: $('.size-show')
	extension: ['.pdf']
filesizeGet = new Filesize_expression(filesizeOption)
filesizeGet.init()
###

#require()で返されるオブジェクト
module.exports = class CanvasMovieSpritter
#class fileSizeGetter
	defaults :
		target : $('a')
		###サイズを取得する対象の拡張子###
		extension : [ '.png', '.gif', '.jpg', '.jpeg', '.pdf', '.xlsx', '.xls', '.docx', '.doc', '.pptx', '.ppt', '.zip', '.lzh', '.cab', '.txt', '.exe' ]

	###サイズ記入処理###
	constructor : (options) ->
		@options = $.extend {}, @defaults, options
		@extension = @options.extension
		@elements = @options.target
		@len = @elements.length
		@len2 = @extension.length

	init : ->
		for i in [0..@len]
			for x in [0..@len2]
				href = @elements.eq(i).attr('href')
				reg = new RegExp @extension[x] + '$', 'i'
				if href and href.match reg
					###サイズ取得###
					size = @_getFileSize(href)
					###サイズを挿入###
					if size
						@elements[i].innerHTML += "[#{@_convUnit(size)}]"
					break

	###ファイルサイズを取得する###
	_getFileSize : (href) ->
		###HTTP通信用オブジェクト生成###
		httpObj = @_createXMLHttpRequest()
		if !httpObj
			return false
		###同期通信###
		httpObj.open 'HEAD', href, false
		try
			httpObj.send null
		catch error
			###404 Not Found###
			console.log('404 Not Found ' + href)
			return false
		###結果を取得###
		if !httpObj.getResponseHeader 'Content-Length'
			###No Content-Length###
			console.log('No Content Length ' + href)
			return false
		else
			###Return Content-Length###
			if httpObj.readyState is 4 and httpObj.status is 200
				return httpObj.getResponseHeader 'Content-Length'
			else
				console.log('No Content Length ' + href)
				return false

	###単位を変換する###
	_convUnit : (num) ->
		if num > 1073741824
			###GByte単位変換###
			num = num / (1024*1024*1024)
			return Math.ceil(num) + 'GB'
		else if num > 1048576
			###MByte単位変換###
			num = num / (1024*1024)
			return Math.ceil(num) + 'MB'
		else if num > 1024
			###KByte単位変換###
			num = num / 1024
			return Math.ceil(num) + 'KB'
		else
			###Byteの時###
			return Math.ceil(num) + 'B'

	###HTTP通信用オブジェクト生成###
	_createXMLHttpRequest : ->
		XMLhttpObject = null
		try
			XMLhttpObject = new XMLHttpRequest()
		catch error
			progids = new Array 'MSXML2.XMLHTTP.5.0', 'MSXML2.XMLHTTP.4.0', 'MSXML2.XMLHTTP.3.0', 'MSXML2.XMLHTTP', 'Microsoft.XMLHTTP'
			len = progids.length
			for i in [0..len]
				try
					XMLhttpObject = new ActiveXObject progids[i]
				catch error
					XMLhttpObject = null
		return XMLhttpObject