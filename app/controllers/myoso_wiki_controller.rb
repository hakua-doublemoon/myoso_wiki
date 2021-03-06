#! ruby -Ku
# -*- mode:ruby; coding:utf-8 -*-

require "module_sub.rb"

class MyosoWikiController < ApplicationController
  include MWIKI_SubMod

  def home
    @str_uri = self.mw_parse_home_uri()
    menu()
    main("welcome")
    #render :layout => "app_home"
  end

  def home_main
    @str_home_main = "お帰りなさいお兄ちゃん！"
  end

  def index
    # URIの処理
    @str_uri = self.mw_parse_home_uri()
    menu()
    main(@str_uri)
    #render :layout => "app_index"
  end

##############################
# main  
##############################
  def main(str_uri=nil)
    mw_fileio_main(str_uri, false)
    #render :layout => "func"
  end

  def mw_fileio()
    mw_fileio_main(nil, params[:ajax_request])
  end

  def mw_fileio_main(str_uri, ajax_request)
    begin
      if str_uri.nil? then
          str_uri = self.mw_parse_home_uri()
          if str_uri.nil? then
              str_uri = "nopage"
          end
      end
    
      # ファイルの所在を確認
      @str_find = "なかった"
      #filepath = self.mw_get_filepath()
      filepath = str_uri
        
      if !File.exist?("public/#{filepath}.md") then
          #raise " ていうかなかった。"
          filepath = "nopage"
      end
      @str_find = "あった"
      fp = File.open("public/#{filepath}.md")
      
      # ファイル読み込み
      @filebuf_html = self.mw_file2html(fp)

      #render :locals => {:filebuf_html => local_filebuf
      #                  }
      fp.close()

    rescue => e
      @filebuf_html = "なんか起きた。" + e.message + " file: #{filepath}"
      #ToDo: retryさせてもいいけどとりあえずデバッグ目的でこのままにしておく
      #@str_find = "なんか起きた: " + e.message
    
    ensure
      @origin_path = "here is " + File.expand_path(File.dirname($0));    # for view
      # ファイル名を抜きだす
      md_title_head = filepath.slice(/^.+\//)
      if md_title_head.nil? then
          @md_title = filepath
      else
          @md_title = filepath.gsub(md_title_head, "")
      end
    end
  end #test_fileio

##############################
# menu  
##############################
  def menu

    @menu_str = "めにゅー"# + #{request.fullpath}"

    mw_menu_list()

  end
  
  def mw_menu_list
    @pubdir_name_str  = "public\/"
    @pubdir_list_html = ""
    @pubdir_list_data = []
    #self.mw_search_dir_html(@pubdir_list_html, 
    #                        @pubdir_name_str, 
    #                        request.original_url.gsub(request.fullpath, "")+"/index/",
    #                        @pubdir_name_str
    #                       )
    self.mw_search_dir(@pubdir_list_data, 
                       @pubdir_name_str, 
                       @pubdir_name_str
                      )
  end
  
end
