#! ruby -Ku
# -*- mode:ruby; coding:utf-8 -*-

require "module_sub.rb"

class MyosoWikiController < ApplicationController
  include MWIKI_SubMod

  def home
    render :layout => "app_home"
  end

  def home_main
    @str_home_main = "お帰りなさいお兄ちゃん！"
  end

  def index
    # URIの処理
    @str_uri = self.parse_home_uri()

    render :layout => "app_index"
  end

##############################
# main  
##############################
  def main
    mw_fileio()
    #render :layout => "func"
  end

  def mw_fileio
    begin
      # URIから読むファイルを決める
      # uri = "http://" + ENV['HTTP_HOST'] + ENV['REQUEST_URI']
      @str_uri = params[:filename]
    
      # ファイルの所在を確認
      @str_find = "なかった"
      filepath = self.get_filepath()
        
      if !File.exist?("public/#{filepath}.md") then
          raise " ていうかなかった。"
      end
      @str_find = "あった"
      fp = File.open("public/#{filepath}.md")
      
      # ファイル読み込み
      #@filebuf_html = "<p> [begin] <br>" + self.mw_fileread(fp) + "<br> [end] </p>"
      @filebuf_html = "<!--HR size=\"5\"-->" + 
                      self.file2html(fp) + 
                      "<!--HR size=\"5\"-->"
      
      #render :locals => {:filebuf_html => local_filebuf
      #                  }
      
    rescue => e
      render :text => "なんか起きた。" + e.message
      #@str_find = "なんか起きた: " + e.message
    
    ensure
      @origin_path = "here is " + File.expand_path(File.dirname($0));    # for view
    end
  end #test_fileio

##############################
# menu  
##############################
  def menu

    @menu_str = "めにゅー"

    menu_list()

  end
  
  def menu_list
    @pubdir_name_str  = "public\/"
    @pubdir_list_html = ""
    self.search_dir_html(@pubdir_list_html, 
                         @pubdir_name_str, 
                         request.original_url.gsub(request.fullpath, "")+"/index/",
                         @pubdir_name_str
                        )
  end
  
end
