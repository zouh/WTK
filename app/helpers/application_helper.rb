module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "微推客"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block) 
  end

  def invite_codes(options = { time: Time.now, count: 1 })
    codes = Array.new(options[:count], '')
    options[:count].times do |n|
    	num = to_base35(duration_in_milliseconds(options[:time]))
    	#mapping ||= '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
      mapping ||= '0123456789ABCDEFGHIJKLMNPQRSTUVWXYZ'
    	duration = num.map {|digit| mapping[digit].to_s }
      # code = Array.new(8, '0')
      # code[0] = duration.fetch(0, '0')
      # code[1] = duration.fetch(1, '0')
      # code[2] = duration.fetch(2, '0')
      # code[3] = duration.fetch(3, '0')
      # code[4] = duration.fetch(4, '0')
      # code[5] = duration.fetch(5, '0')
      # code[6] = duration.fetch(6, '0')
      # code[7] = duration.fetch(7, '0')
      codes[n] = duration.reverse.join
    end
    return codes
  end

  # def error_messages_for(object_name, options = {}) 
  #   options = options.symbolize_keys 
  #   object = instance_variable_get("@#{object_name}") 
  #   unless object.errors.empty? 
  #     error_lis = [] 
  #     object.errors.each{ |key, msg| error_lis << content_tag("li", msg) } 
  #     content_tag("div", content_tag(options[:header_tag] || "h2", "发生#{object.errors.count}个错误" ) + content_tag("ul", error_lis), "id" => options[:id] || "errorExplanation", "class" => options[:class] || "errorExplanation" ) 
  #   end
  # end

  #private

  	def duration_in_milliseconds(time)
  		time ||= Time.now
  		epoch = Time.new(2014, 8, 8)
  		return (time.to_i - epoch.to_i) * 1000 + time.usec / 1000
  	end

    def to_base35(num)
      return [0] if num.zero?
      num = num.abs
      [].tap do |digits|
          while num > 0
            digits.unshift num % 35
            num /= 35
          end
      end
    end

  	def to_base60(num)
  		return [0] if num.zero?
    	num = num.abs
    	[].tap do |digits|
	      	while num > 0
	        	digits.unshift num % 60
	        	num /= 60
	      	end
    	end
  	end

end
