module Pagination
  extend ActiveSupport::Concern

  def paginate(collection, per_page: 25)
    page = (params[:page] || 1).to_i
    collection
      .offset((page - 1) * per_page)
      .limit(per_page)
      .extending(PaginationExtension)
      .tap { |items| items.instance_variable_set(:@page, page) }
      .tap { |items| items.instance_variable_set(:@per_page, per_page) }
      .tap { |items| items.instance_variable_set(:@total_count, collection.count) }
  end

  module PaginationExtension
    def current_page
      @page
    end

    def total_pages
      (@total_count.to_f / @per_page).ceil
    end

    def total_count
      @total_count
    end

    def next_page
      current_page < total_pages ? current_page + 1 : nil
    end

    def prev_page
      current_page > 1 ? current_page - 1 : nil
    end
  end
end
