module Enumerable

  def to_xml_array(options = {})
    xml_doc = Nokogiri::XML::Document.new
    root = xml_doc.create_element(options[:root] || 'root', type: :array)
    options = options.reverse_merge(xml_doc: xml_doc)
    each do |obj|
      if (e = obj.try(:to_xml_element, options)).is_a?(Nokogiri::XML::Element)
        root << e
      end
    end
    xml_doc << root
    xml_doc.to_xml
  end

end

module OpenSSL
  class Digest
    class << self
      def new_sign(*args)
        args = args.collect { |a| a.capataz_proxy? ? a.capataz_slave : a }
        new(*args)
      end
    end
  end
end