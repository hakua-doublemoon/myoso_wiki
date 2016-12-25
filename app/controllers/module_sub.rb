#! ruby -Ku
# -*- mode:ruby; coding:utf-8 -*-

# This is released under the MIT License, see "LICENSE".

#require 'rdiscount'
# Use rdiscount to Markdown
# The core Discount C sources are Copyright (C) 2007 David Loren Parsons.
# The Discount Ruby extension sources are Copyright (C) 2008 Ryan Tomayko.
# https://github.com/davidfstr/rdiscount/blob/master/COPYING

module MWIKI_Contant
  # 定数定義してみる。constant.rbはどこ？
  FOLDER_NOT   = 0
  FOLDER_START = 1
  FOLDER_END   = 2
end

module MWIKI_SubMod

  # @param  [String] file 読み込みたいファイルのパス
  # @return [String] ファイルの中身（改行は<br>で置換してつなげてある）
  # @note   今は使われていない
  # @todo   そのうち消す
  def mw_fileread(file)
    outbuf = " "
    #File.open(f_name) do |file|
        file.each_line do |labmen|
            outbuf = outbuf + labmen + "<br>"
        end
    #end
    return outbuf
  end #mw_fileread
  #public :mw_fileread

  # @param  [String] img_tag ![～](～)という文字列
  # @return [String] なんか画像のHTML
  # @note   機能：自分のmdに埋め込める画像のパスに変える
  # @todo   ……作ってみたけど要らなかった。そのうち消す   
  def mw_convert_image_tag(img_tag)
    return view_context.image_tag(img_tag.gsub(/.*\!\[.*\]\(/, "").gsub(/\).*/, ""))
  end
  #public :mw_convert_image_tag

  # @param  [File Pointer] file 読み込みたいファイルのファイルポインタ
  # @return [String] HTML
  # @note   機能：MDファイルを読み、rdiscountを使ってHTMLに変換する。
  # @note   rdiscountの利用についてはrdiscountのライセンスに従うこと。
  # @todo   
  def mw_file2html(file, public_name = "public")
    outbuf = " "
    file.each_line do |labmen|
        # 画像タグは先に作る
        #if labmen =~ /.*\!\[.*\]\(.*\).*/ then
        #    labmen = mw_convert_image_tag(labmen)
        #end
        # 出力バッファにくっつける
        outbuf = outbuf + labmen# + "  "
    end

    markdown = RDiscount.new(outbuf)
    return markdown.to_html
  end
  public :mw_file2html

  # @param  [nil] 
  # @return [String] uriのfilename部分
  # @note   機能：
  # URIの:filename部分を抽出する。
  # :filename部分がない場合は"welcome"を返す。
  # @todo    
  def mw_parse_home_uri
    #uri = request.fullpath
    uri = params[:filename]
    if (uri.nil? || uri.empty?) then
        return "welcome"
    end
    #return uri.gsub(/\/home\//, "\/")
    return uri.gsub(/:/, "\/")
  end
  #public :mw_parse_home_uri

  # @param  [nil] 
  # @return [String] uriのfilename部分。セミコロンはスラッシュに置換される。
  # @note   機能：
  # URIの:filename部分を抽出する。
  # :filename部分がない場合は"nopage"を返す。
  # @todo
  def mw_get_filepath()
    uri = params[:filename]
    if (uri.nil? || uri.empty?) then
        return "nopage"
    end
    return uri.gsub(/:/, "\/")
  end
  public :mw_get_filepath

  # @param  [String] html_buf    ディレクトリ構成を<ul>で箇条書きしたHTML
  # @param  [String] dirname     走査するディレクトリ名
  # @param  [String] index_url   URIのホスト名を除いて"index"をつけた部分。ちゃんとした説明はあとで考える……
  # @return [String] public_name 走査するディレクトリの一番上位
  # @note   機能：
  # public_name以下のディレクトリ構成を箇条書きHTMLで書き出す。
  # @todo   controllerでHTMLをごりごり作るのは格好悪いのでそのうちどうにかする。
  def mw_search_dir_html(html_buf, dirname, index_url, public_name)
    html_buf << "<ul class=\"dir_list\">"
    Dir.glob(dirname+"*").each do |name|
        if FileTest.directory?(name) then
            html_buf << "<li>#{name.gsub(dirname, "")}</li>"
            mw_search_dir_html(html_buf, name+"\/", index_url, public_name)
        else
          if name =~ /.md/ then
            md_name = name.gsub(public_name, "").gsub("\/", ":")
            html_buf << <<-HTML
              <li>
                <a href=\"#{index_url+md_name}\" target=\"_top\">
                    #{name.gsub(dirname, "")}
                </a>
              </li>
            HTML
          else
            html_buf << "<li>#{name.gsub(dirname, "")}</li>"
          end
        end
    end
    html_buf << "</ul>"
  end
  public :mw_search_dir_html

  # @param  [String] html_buf    ディレクトリ構成を<ul>で箇条書きしたHTML
  # @param  [String] dirname     走査するディレクトリ名
  # @param  [String] index_url   URIのホスト名を除いて"index"をつけた部分。ちゃんとした説明はあとで考える……
  # @return [String] public_name 走査するディレクトリの一番上位
  # @note   機能：
  # public_name以下のディレクトリ構成を箇条書きHTMLで書き出す。
  # @todo   
  def mw_search_dir(data_buf, dirname, public_name)
    Dir.glob(dirname+"*").each do |name|
        adata = [{:name    => name.gsub(dirname, ""), 
                  :folder  => MWIKI_Contant::FOLDER_NOT,
                  :md_path => ""
                 }]
        if FileTest.directory?(name) then
            adata[0][:folder] = MWIKI_Contant::FOLDER_START
            mw_search_dir(adata, name+"\/", public_name)
        else
          if name =~ /.md/ then
            md_path = name.gsub(public_name, "").gsub("\/", ":")
            adata[0][:md_path] = md_path
          end
        end
        data_buf.concat(adata)
    end
    data_buf.last[:folder] = MWIKI_Contant::FOLDER_END
  end
  public :mw_search_dir
  
  private
  
  protected
  
end