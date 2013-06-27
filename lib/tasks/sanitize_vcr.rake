require 'yaml'
require 'uri'

namespace :vcr do
  desc "Sanitize Real Auth Tokens from VCR Cassettes"
  task :sanitize => [:environment] do |t,args|
    Dir.glob("test/vcr_cassettes/**/*.yml") do |cassette|
      begin
        file = File.open(cassette,"rb")
        contents = file.read
        file.close
      rescue => e
        puts e.message
        exit
      end
      service = /test\/vcr_cassettes\/(.+)\//.match(cassette)[1]

      if !cassette.match(/auth_callback.yml/)
        contents.gsub!(/#{Rails.application.config.auth[service][:auth_token]}/,
                      Rails.application.config.vcr_tokens[service][:auth_token])
      end

      begin
        File.open(cassette,"w+") {|f| f.write(contents)}
      rescue => e
        puts e.message
      end
    end
  end

end


