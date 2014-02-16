class LibraryWorker
  include Sidekiq::Worker

   def perform(library_id)
    url = Library.find(library_id).url
          response1 = Typhoeus.get( url + "/adventures.json")
          answer = response1.body.as_json
          result = {}
          result['adventures'] = answer["adventures"]
          result["adventures"].each do |adventure|
            library_to_search.adventures << Adventure.create(adventure)
          end



          response2 = Typhoeus.get(url +"/libraries.json")
          answer = response2.body.as_json
          result["libraries"] = answer["libraries"]
          @libraries = Library.all
          result['libraries'].each do |library|
            if !@libraries.include?(library.url)
              Library.create(url:  library.url)
            end
          end
          
   end
end

