require 'sinatra'
require 'twitter'

$client = Twitter::REST::Client.new do |config|
  config.consumer_key =  ENV['CONSUMER_KEY']
    config.consumer_secret = ENV['CONSUMER_SECRET']
    config.access_token = ENV['ACCESS_TOKEN']
    config.access_token_secret = ENV['TOKEN_SECRET']
  end

$last_update = Time.new(1984)
$tpm = 0 # tweets per minute

get '/' do
  if Time.now - $last_update > 60
    tweets = $client.home_timeline
    $last_update = Time.now
    dt = tweets[0].created_at - tweets[-1].created_at
    $tpm = (tweets.size / dt) * 60
  end
  "分速#{'%.2f' % $tpm}ツイート at #{$last_update}\n"
end
