#! ruby -Ku
# -*- mode:ruby; coding:utf-8 -*-

#require 'rdiscount'
# Use rdiscount to Markdown
# The core Discount C sources are Copyright (C) 2007 David Loren Parsons.
# The Discount Ruby extension sources are Copyright (C) 2008 Ryan Tomayko.
# https://github.com/davidfstr/rdiscount/blob/master/COPYING

class DirFile
  attr_accessor :next_dir
  attr_accessor :head_child_dir
  attr_accessor :next_child_dir
  attr_accessor :name
  attr_accessor :files

  def initialize()
    @next_dir = nil
    @head_child_dir = nil
    @next_child_dir = nil
    @name  = ""
    @files = []
  end

end

module MWIKI_SubMod

  public

  def mw_fileread(file)
    outbuf = " "
    #File.open(f_name) do |file|
        file.each_line do |labmen|
            outbuf = outbuf + labmen + "<br>"
        end
    #end
    return outbuf
  end #mw_fileread
  public :mw_fileread
  
  def file2html(file)
    outbuf = " "
    file.each_line do |labmen|
        outbuf = outbuf + labmen# + "  "
    end

    markdown = RDiscount.new(outbuf)
    return markdown.to_html
  end
  public :file2html
  
  def parse_home_uri
    #uri = request.fullpath
    uri = params[:filename]
    if (uri.nil? || uri.empty?) then
        return "welcome"
    end
    #return uri.gsub(/\/home\//, "\/")
    return uri
  end
  public :parse_home_uri

  def get_filepath
    uri = params[:filename]
    if (uri.nil? || uri.empty?) then
        return "nopage"
    end
    return uri.gsub(/:/, "\/")
  end
  public :get_filepath
  
  def search_dir_html(html_buf, dirname, index_url, public_name)
    html_buf << "<ul class=\"dir_list\">"
    Dir.glob(dirname+"*").each do |name|
        if FileTest.directory?(name) then
            html_buf << "<li>#{name.gsub(dirname, "")}</li>"
            search_dir_html(html_buf, name+"\/", index_url, public_name)
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
  public :search_dir_html
  
  private
  
  protected
  
end