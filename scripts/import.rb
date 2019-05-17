require 'mechanize'

def time_obj(str)
	str.gsub!("+07", "JST")
	str.match(/([0-9]{4})-([0-9]{2})-([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2}) (JST|HST)/)
	year = $1
	month = $2
	date = $3
	hour = $4
	min = $5
	sec = $6
	Time.new(year, month, date, hour, min, sec)
end

def save_message(pg)
	path_dir = "/home/vagrant/path/"
	m = Message.new

	time_str = pg.at(".time").text
	begin
		time_obj = time_obj(time_str)
	rescue
		return false
	end
	m.created_at = time_obj
	text = pg.at(".text_content").text
	m.content = text
	if img = pg.at(".area_media").presence and img.at('.photo_img').present?
		img_path = "#{ path_dir }#{ img.at('.photo_img')['src'] }"
		m.image = Pathname.new( img_path ).open
	end
	m.user_id = 1
	begin
		m.save!
	rescue
		return false
	end
end

def main
	file = "/home/vagrant/path/index.html"
	agent = Mechanize.new
	page = agent.get("file://#{ file }")
	page.search(".box_feed").each do |pg|
		save_message(pg)
	end
	loop do
		if page.at(".pagination_next").present? and 
			page = agent.page.link_with(:text => "Next >").click
			page.search(".box_feed").each do |pg|
				save_message(pg)
			end
		else
			exit
		end
	end
end
main()
