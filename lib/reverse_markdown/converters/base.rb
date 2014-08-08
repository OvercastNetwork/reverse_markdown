module ReverseMarkdown
  module Converters
    class Base
      def treat_children(node)
        node.children.inject('') do |memo, child|
          memo << treat(child)
        end
      end

      def treat(node)
        atr = node.attributes
        atr.delete("href")
        atr.delete("src")
        atr.delete("target")
        atr.delete("alt")
        atr.delete("title")
        atr.delete("rel")

        if atr.empty?
          converter = ReverseMarkdown::Converters.lookup(node.name)
        else
          converter = ReverseMarkdown::Converters::PassThrough.new
        end

        converter.convert(node)
      end

      def escape_keychars(string)
        string.gsub(/[\*\_]/, '*' => '\*', '_' => '\_')
      end

      def extract_title(node)
        title = escape_keychars(node['title'].to_s)
        title.empty? ? '' : %[ "#{title}"]
      end
    end
  end
end
