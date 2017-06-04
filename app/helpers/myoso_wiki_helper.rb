module MyosoWikiHelper
  def evil_icon_call(icon_name, size)
    case (size)
      when "middle" then
        evil_icon icon_name, size: :m
      when "small" then
        evil_icon icon_name, size: :s
      else
    end
  end

  def qiita_markdown(markdown)
    inst = Qiita::Markdown::Processor.new(hostname: "example.com")
    inst.call(markdown)[:output].to_s.html_safe
  end

end
