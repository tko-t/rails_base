require 'active_record'
require 'yaml'
require 'erb'

# mysqldが起動されるまでジッと待つ
config_database =
  YAML.load(
    ERB.new(
      File.read(
        File.join(__dir__, '../', 'config', 'database.yml')
      ) # raw config/database.yml
    ).result # parse ERB
  ) # to_hash

development = config_database.dig('development')

begin
  ActiveRecord::Base.establish_connection(development)
  ActiveRecord::Base.connection

  puts 'database connected!'
rescue
  sleep 0.5
  retry if (@retry ||= 0).tap { print "\r#{@retry += 1}" } < 20 # 最大10秒

  raise $!
end
