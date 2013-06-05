require 'yaml'
require 'uri'

namespace :vcr do
  desc "Sanitize Real Auth Tokens from VCR Cassettes"
  task :sanitize, [:cassette] => [:environment] do |t,args|

    begin
      file = YAML.load_file(args[:cassette])
    rescue => e
      puts e.message
      exit
    end

    file["http_interactions"].each do |interaction|
      uri = interaction["request"]["uri"]

      # Tested at Rubular http://rubular.com/r/OmuIHbkTOr
      # Optional Regex Lookaheads http://stackoverflow.com/a/7361087/1169547
      uri.gsub!(/(?<=access_token=)(.*?)(?=(?:&|$))/,
                Rails.application.config.vcr_tokens[:facebook][:auth_token])
      interaction["request"]["uri"]=uri
    end

    begin
      File.open(args[:cassette],"w+") {|f| f.write(file.to_yaml)}
    rescue => e
      puts e.message
    end
  end

end


