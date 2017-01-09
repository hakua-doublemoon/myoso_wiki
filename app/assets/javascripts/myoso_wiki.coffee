# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@count = 2

$ ->
  #test_roop()
  #alert(count)

@test_roop = () ->
    #@count = @count + 1
    #obj = document.getElementById("counter")
    #obj.textContent  = @count
    #setTimeout test_roop, 1000

# "javascript:void(0);",
# :onclick => "mwcf_onclick_menulist(\"#{data[:md_path]}\", );",

@mwcf_onclick_menulist = (filepath) ->
  $.ajax
    # 実行したいactionへのpath
    url:  '/myoso_wiki/mw_fileio'
    # GET, POST, PUT, DELETEなどを設定
    type: 'GET'
    # urlにつけるパラメータを指定
    data: {
      filename:     filepath
      ajax_request: true
    }
    dataType:  'html'
    # ↓実行後にやること
    success:   (data, status, xhr)   ->
      ("#page_fileio_filebuf").html(data)
      #obj = document.getElementById("ajax_test_text")
      #obj.textContent  = data
      #console.log(data)
      #console.log('きたー？')
      #console.log(status)
      false
    error:     (xhr,  status, error) ->
      console.log('だめっぽい')
      console.log(xhr)
      console.log(error)      
    complete:  (data, xhr,  status)  -> 


