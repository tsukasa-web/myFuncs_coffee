###
ファイルサイズ取得
------------------------------------
extension…取得したいファイル形式配列
------------------------------------
fork from filesizeGetter
http://mashimonator.weblike.jp/storage/library/20091118_001/demo/fileSizeGetter/js/fileSizeGetter.js

【使用例】
#ファイルサイズ取得
filesizeOption =
	extension: ['.pdf']
filesizeGet = new Filesize_expression(filesizeOption)
###
class Filesize_expression
	defaults :
		###サイズを取得する対象の拡張子###
		extension : [ '.png', '.gif', '.jpg', '.jpeg', '.pdf', '.xlsx', '.xls', '.docx', '.doc', '.pptx', '.ppt', '.zip', '.lzh', '.cab', '.txt', '.exe' ]

	###初期処理###
	constructor : (options) ->
		@options = $.extend {}, @defaults, options
		@extension = @options.extension
		@elements = $('a')
		@len = @elements.length
		@len2 = @extension.length
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
			return false
		###結果を取得###
		if !httpObj.getResponseHeader 'Content-Length'
			###No Content-Length###
			return false
		else
			###Return Content-Length###
			if httpObj.readyState is 4 and httpObj.status is 200
				return httpObj.getResponseHeader 'Content-Length'
			else
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