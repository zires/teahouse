# config.ru
$:.push File.expand_path("../lib", __FILE__)
require 'teahouse'

run Teahouse::App
