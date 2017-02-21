module Searchers
  class Searcher
    attr_accessor :search_params

    def initialize(args = {})
      @search_params = Hashie::Mash.new args
    end

    def collection
      search.results
    end
  end

  class OrganizationSearcher < Searcher
    private
    def search
      search_params.list_items.reject!(&:empty?) if search_params.list_items
      search_params.hierarch_list_items.reject!(&:empty?) if search_params.hierarch_list_items
      Organization.search do

        with :category_id, search_params.category_id if search_params.category_id

        any_of do
          with :list_item_ids, search_params.list_items if search_params.list_items
          with :hierarch_list_item_ids, search_params.hierarch_list_items if search_params.hierarch_list_items
        end

        paginate page: search_params.page
      end
    end
  end
end
