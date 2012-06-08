require 'video_info'

before_broadcast_filter do |m|
  regex = /(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?(?=.*v=((\w|-){11}))(?:\S)*/
  if matches = regex.match(m.xhtml_body)
    info = VideoInfo.new(matches[0])
    m.xhtml_body.gsub!(regex, "<a href=\"http://youtube.com/watch?v=#{matches[1]}\">Video: #{info.title}</a>")
  end
end
