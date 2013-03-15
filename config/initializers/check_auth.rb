puts "#"*30
puts ""*5
if !Rails.application.config.auth[:google].empty?
  puts "\e[31mYou don't have google auth codes! get them at https://code.google.com/apis/console/\e[0m"
end
puts ""*5
puts "#"*30
