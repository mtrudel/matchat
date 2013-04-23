require 'uri'
require 'video_info'
require 'chronic_duration'

#before_broadcast_filter do |m|
  #URI.extract(m.body).each do |url|
    #if (info = VideoInfo.get(url))
      #duration = ChronicDuration.output(info.duration, :format => :chrono)
      #m.body.gsub!(url, "#{url} (#{info.title} #{duration})")
      #m.xhtml_body.gsub!(url, "<a href=\"#{url}\">Video: #{info.title} (#{duration})</a>")
    #end
  #end
#end
