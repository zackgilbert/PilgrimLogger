class Event < ActiveRecord::Base

  def method_missing(method_name, *args, &block)
    if self.data["json"][method_name.to_s].present?
      self.data["json"][method_name.to_s]
    else
      nil
    end
  end

  def data
    hash_text = self.raw_data
    # borrowed from: https://gist.github.com/gene1wood/bd8159ad90b0799d9436
    # Transform object string symbols to quoted strings
    hash_text.gsub!(/([{,]\s*):([^>\s]+)\s*=>/, '\1"\2"=>')
    # Transform object string numbers to quoted strings
    hash_text.gsub!(/([{,]\s*)([0-9]+\.?[0-9]*)\s*=>/, '\1"\2"=>')
    # Transform object value symbols to quotes strings
    hash_text.gsub!(/([{,]\s*)(".+?"|[0-9]+\.?[0-9]*)\s*=>\s*:([^,}\s]+\s*)/, '\1\2=>"\3"')
    # Transform array value symbols to quotes strings
    hash_text.gsub!(/([\[,]\s*):([^,\]\s]+)/, '\1"\2"')
    # Transform object string object value delimiter to colon delimiter
    hash_text.gsub!(/([{,]\s*)(".+?"|[0-9]+\.?[0-9]*)\s*=>/, '\1\2:')

    JSON.parse(hash_text)
  end

  def headers
    hash_text = self.raw_headers
    # borrowed from: https://gist.github.com/gene1wood/bd8159ad90b0799d9436
    # Transform object string symbols to quoted strings
    hash_text.gsub!(/([{,]\s*):([^>\s]+)\s*=>/, '\1"\2"=>')
    # Transform object string numbers to quoted strings
    hash_text.gsub!(/([{,]\s*)([0-9]+\.?[0-9]*)\s*=>/, '\1"\2"=>')
    # Transform object value symbols to quotes strings
    hash_text.gsub!(/([{,]\s*)(".+?"|[0-9]+\.?[0-9]*)\s*=>\s*:([^,}\s]+\s*)/, '\1\2=>"\3"')
    # Transform array value symbols to quotes strings
    hash_text.gsub!(/([\[,]\s*):([^,\]\s]+)/, '\1"\2"')
    # Transform object string object value delimiter to colon delimiter
    hash_text.gsub!(/([{,]\s*)(".+?"|[0-9]+\.?[0-9]*)\s*=>/, '\1\2:')

    JSON.parse(hash_text)
  end

  def has_user_info
    keys = self.data.keys
    keys.delete('json')
    keys.delete('secret')
    keys.length > 0
  end

  def arrival_at
    Time.at(self.arrivalTime / 1000.0) if self.arrivalTime.present?
  end

  def departure_at
    Time.at(self.departureTime / 1000.0) if self.departureTime.present?
  end

  def timestamp_at
    Time.at(self.timestamp / 1000.0)
  end

  def secret
    if self.headers.include?('HTTP_PILGRIM_SECRET') # v1 is in the raw data...
      puts "v2: #{self.headers['HTTP_PILGRIM_SECRET'].inspect}"
      self.headers['HTTP_PILGRIM_SECRET']
    else # v2 is in the headers...
      puts "v1: #{self.data['secret'].inspect}"
      self.data['secret']
    end
  end

end
