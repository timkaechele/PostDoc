module Search
  class EmailSearch
    def call(collection, search_query)
      collection.where(where_statement,
                       search_query_parts: search_query_parts(search_query))
    end

    alias search call

    private

    def search_query_parts(search_query)
      return [] if search_query.blank?
      search_query.split(/\s+/)
                  .map { |query| "%#{query}%" }
    end

    def where_statement
        <<~SQL
          request_payload->'personalizations'->>personalization_id
            ILIKE
              ANY(ARRAY[:search_query_parts])
          OR
          subject ILIKE ANY(ARRAY[:search_query_parts])
          OR
          template_id ILIKE ANY(ARRAY[:search_query_parts])
          OR
          rendered_plain_text ILIKE ANY(ARRAY[:search_query_parts])
        SQL
    end
  end
end
