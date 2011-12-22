begin
  require_library_or_gem 'RMagick' unless Object.const_defined?(:Magick)
rescue LoadError
  # RMagick is not available
end

