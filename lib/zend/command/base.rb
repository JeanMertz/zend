class Zend::Command::Base
  def api
    Zend::Auth.api
  end

  def terminal_width
    result = unix? ? dynamic_width : 80
    (result < 10) ? 80 : result
  rescue
    80
  end

  def truncate(text, length, options = {})
    options[:omission] ||= "..."

    length_with_room_for_omission = length - options[:omission].length
    chars = text
    stop = options[:separator] ?
      (chars.rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission) : length_with_room_for_omission

    (chars.length > length ? chars[0...stop] + options[:omission] : text).to_s
  end

  def is_num?(str)
    begin
      !!Integer(str)
    rescue ArgumentError, TypeError
      false
    end
  end

private

  def unix?
    RUBY_PLATFORM =~ /(aix|darwin|linux|(net|free|open)bsd|cygwin|solaris|irix|hpux)/i
  end

  def dynamic_width
    @dynamic_width ||= (dynamic_width_stty.nonzero? || dynamic_width_tput)
  end

  def dynamic_width_stty
    %x{stty size 2>/dev/null}.split[1].to_i
  end

  def dynamic_width_tput
    %x{tput cols 2>/dev/null}.to_i
  end

end
