class Request
  private
  @@parameters = ['-A', '-e', '-R', '-z']

  public
  def initialize request
    @request = Array.new request
  end

  def result
    case @request.length
    when 0
      return ['Incorrect command format. Use grep [PARAMETER] TEMPLATE [FILE]…']
    when 1
      if(Request.is_parameter @request.first)
        return ["Parameter #{@request.first} need arguments",
                'Incorrect command format. Use grep [PARAMETER] TEMPLATE [FILE]…']
      end
      return Request.stream_search @request.first
    else
      return Request.file_search @request.first, @request[1..-1] unless (Request.is_parameter @request.first)
      case Request.is_parameter @request.first
      when 0
        begin
          n = Integer @request[1]
          raise ArgumentError if n < 0
        rescue ArgumentError
          return ["#{@request[1]}: invalid argument. Argument of length must be a positive integer"]
        end

        return ["Parameter #{@request.first} must have three or more arguments"] if @request.length < 4
        return Request.file_search_neighbors @request[2], n, @request[3..-1]
      when 1
        begin
          exp = Regexp.new @request[1]
        rescue RegexpError
          return ["#{@request[1]}: invalid regular expression"]
        end

        return ["Parameter #{@request.first} must have two or more arguments"] if @request.length < 3
        return Request.file_search exp, @request[2..-1]
      when 2
        return ["Parameter #{@request.first} must have one argument"] unless @request.length == 2
        return Request.folder_search @request[1]
      when 3
        return ["Parameter #{@request.first} must have two or more arguments"] if @request.length < 3
        return Request.gzip_file_search @request[1], @request[2..-1]
      end
    end
  end

  class << self
    def is_parameter exp
      @@parameters.index exp
    end

    def stream_search mask
      puts 'Search in the keyboard stream. To exit use #close'.blue
      loop do
        s = gets
        break if s[/#close$/]
        if s[mask] then puts s.gsub s[mask], s[mask].green end
      end
      return nil
    end

    def file_search mask, files
      results = []
      files.each do |name|
        if (!File.exist? name or File.directory? name)
          results << "#{name}: No such file".blue
          next
        end
        file = File.open name
        file.each {|s| if s[mask] then results << "#{name}: ".blue + (s.gsub s[mask], s[mask].green) end}
        file.close
      end
      return results
    end

    def file_search_neighbors mask, n, files
      results = []
      files.each do |name|
        unless File.exist? name
          results << "#{name}: No such file".blue
          next
        end
        file = File.open name
        lines = file.readlines
        lines.each_with_index do |line, i|
          if line[mask]
            begin_index = (i - n) < 0 ? 0 : i - n
            end_index = (i + n) > (lines.length - 1) ? lines.length - 1 : i + n
            for index in begin_index..end_index
              unless index == i
                results << "#{name}: ".blue + lines[index]
              else
                results << "#{name}: ".blue + line.gsub(line[mask], line[mask].green)
              end
            end
          end
        end
        file.close
      end
      return results
    end

    def gzip_file_search mask, files
      results = []
      files.each do |name|
        if (!File.exist? name or File.directory? name)
          results << "#{name}: No such file".blue
          next
        end
        file = File.open name
        begin
        	gunz = Zlib::GzipReader.new(file)
        rescue Zlib::GzipFile::Error
        	results << "#{name}: gzip file header is incorrect".blue
        else
        	gunz.each {|s| if s[mask] then results << "#{name}: ".blue + (s.gsub s[mask], s[mask].green) end}
    	end
        file.close
      end
      return results
    end

    def folder_search mask
      files = Dir.entries('./').select { |name| File.file?(name) }
      Request.file_search mask, files
    end
  end
end