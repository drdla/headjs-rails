module Headjs

  module TagHelper

    def headjs_include_tag(*javascripts)
      content_tag :script, { type: Mime::JS }, false do
        raw 'head.js(' + process_javascripts_to_load(*javascripts) + ');'
      end
    end

    private

    def process_javascripts_to_load(*javascripts)
      keys = []

      "#{javascript_include_tag(*javascripts).scan(/src="([^"]+)"/).flatten.map { |src|
        key = URI.parse(src).path[%r{[^/]+\z}].gsub(/\.js$/, '').gsub(/\.min$/, '').gsub(/\_min$/, '')
        while keys.include? key do
          key += '_' + key
        end
        keys << key
        "{ '#{key}': '#{src}' }"
      }.join(', ')}"

      # javascript_include_tag(*javascripts)
      # .scan(/src="([^"]+)"/)
      # .flatten
      # .map { |src|
      #   key = URI.parse(src).path[%r{[^/]+\z}].gsub(/\.js$/, '').gsub(/\.min$/, '').gsub(/\_min$/, '')
      #   while keys.include? key { key += '_' + key }
      #   keys << key
      #   "{ '#{key}': '#{src}' }"
      # }
      # .join(',')
    end

  end

end