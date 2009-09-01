require 'rubygems'
require 'json'
require 'json-mangler'

class CalaisExtractor < Object

    def initialize(input)
        @json_input = input
    end

    def prettify
        @extractor = JSONExtractor.new

        @num_fragments = 0

        grab_list = ["topics", "Person", "Organization", "IndustryTerm", "Company"]

        @results = '{ "results": {'

        grab_list.each do |g|
           do_extraction( g ) 
        end

        @results << "} }"
    end

  private

    def do_extraction(search_val)
        data = @extractor.extract(@json_input, "data", search_val, 2)

        case search_val
            when "topics"
                extract_topics( data )
            when "Person"
                extract_people( data )
            when "Organization"
                extract_organisations( data )
            when "IndustryTerm"
                extract_industryterms( data )
            when "Company"
                extract_industryterms( data )
        end
    end

    def extract_topics(data)
        obj = JSON.parse(data)
        t = obj['results']
        fragment = '"categories": ['
        first = true 
        t.each do |x|
            raw = x['categoryName']
            if !first
                fragment << ", "
            end
            fragment << '"' << raw.gsub(/_/, ' ') << '"'
            first = false
        end
        fragment << "]"
        add_fragment( fragment )
    end

    def extract_people(data)
        puts data
        obj = JSON.parse(data)
        res = obj['results']
        fragment = '"people": ['
        first = true
        res.each do |x|
            if !first
                fragment << ', '
            end
            fragment << '"' << x['exact'] << '"'
            first = false
        end
        fragment << ']'
        add_fragment( fragment )
    end

    def extract_organisations(data)
        puts data
        obj = JSON.parse(data)
        res = obj['results']
        fragment = '"organisations": ['
        first = true
        res.each do |x|
            if !first
                fragment << ', '
            end
            fragment << '"' << x['exact'] << '"'
            first = false
        end
        fragment << ']'
        add_fragment( fragment )
    end

    def extract_industryterms(data)
        puts data
        obj = JSON.parse(data)
        res = obj['results']
        fragment = '"industryterms": ['
        first = true
        res.each do |x|
            if !first
                fragment << ', '
            end
            fragment << '"' << x['exact'] << '"'
            first = false
        end
        fragment << ']'
        add_fragment( fragment )
    end

    def extract_companies(data)
        puts data
        obj = JSON.parse(data)
        res = obj['results']
        fragment = '"company": ['
        first = true
        res.each do |x|
            if !first
                fragment << ', '
            end
            fragment << '"' << x['exact'] << '"'
            first = false
        end
        fragment << ']'
        add_fragment( fragment )
    end
    def add_fragment(fragment)
        @num_fragments = @num_fragments + 1
        if (@num_fragments > 1)
            @results << ", "
        end
        @results << fragment
    end
end

