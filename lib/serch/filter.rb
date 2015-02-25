module Serch
  class Filter

    attr_reader :index, :body, :ident, :subject

    def initialize(index, body, ident, subject)
      @index = index
      @ident = ident
      @id = ident.downcase.to_sym != :id ? ident : :_id
      @body = body.merge!({ fields: [@id] })
      @subject = subject
    end

    def query
      { index: index, body: body }
    end

    def execute
      @results ||= Serch.search(query)
    end

    def results
      subject.find(records)
    end

    def records
      execute["hits"]["hits"].map { |hit| hit[@id.to_s] }
    end

    def total
      execute["hits"]["total"]
    end

    def |(filter)
      records | filter.records
    end

    def aggregations
      aggs = {}
      execute["aggregations"].each do |key, val|
        aggs[key.to_sym] = val["value"]
      end
      aggs
    rescue
      {}
    end

  end
end
