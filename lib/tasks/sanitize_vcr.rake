require 'yaml'
require 'uri'

namespace :vcr do
  desc "Sanitize Real Auth Tokens from VCR Cassettes"
  task :sanitize => [:environment] do |t,args|
    Dir.glob("test/vcr_cassettes/**/*.yml") do |cassete|
      begin
        file = YAML.load_file(cassete)
      rescue => e
        puts e.message
        exit
      end

      file["http_interactions"].each do |interaction|
        uri = interaction["request"]["uri"]
        parsedURI = URI.parse(uri);

        # Tested at Rubular http://rubular.com/r/OmuIHbkTOr
        # Optional Regex Lookaheads http://stackoverflow.com/a/7361087/1169547
        service = Rails.application.config.auth.keys.select{|v| Rails.application.config.auth[v][:host]==parsedURI.host}
        service = service.first

        if !service.nil?
          puts cassete
          puts service
          search = Rails.application.config.vcr_tokens[service][:sanitize_search]
          puts search
          uri.gsub!(/(?<=#{Regexp.escape(search)})(.*?)(?=(?:&|$))/,
                    Rails.application.config.vcr_tokens[service][:auth_token])
          interaction["request"]["uri"]=uri
        end
      end

      begin
        File.open(cassete,"w+") {|f| f.write(file.to_yaml)}
      rescue => e
        puts e.message
      end
    end
  end

end


