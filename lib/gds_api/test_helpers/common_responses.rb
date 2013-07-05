module GdsApi
  module TestHelpers
    module CommonResponses
      def titleize_slug(slug, options = {})
        if options[:title_case]
          slug.gsub("-", " ").gsub(/\b./) {|m| m.upcase }
        else
          slug.gsub("-", " ").capitalize
        end
      end

      def response_base
        {
          "_response_info" => {
            "status" => "ok"
          }
        }
      end
      alias_method :singular_response_base, :response_base

      def plural_response_base
        response_base.merge(
          {
            "description" => "Tags!",
            "total" => 100,
            "start_index" => 1,
            "page_size" => 100,
            "current_page" => 1,
            "pages" => 1,
            "results" => []
          }
        )
      end
    end
  end
end