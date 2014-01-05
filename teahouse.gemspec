# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require "teahouse"

Gem::Specification.new do |s|
  s.name        = "teahouse"
  s.version     = '0.0.1'
  s.authors     = ["zires"]
  s.email       = ["zshuaibin@gmail.com"]
  s.homepage    = "https://github.com/zires/teahouse"
  s.summary     = "Teahouse is a lightweight chat app."
  s.description = "Teahouse is a lightweight chat app."

  #s.files      = Dir["{lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.files      = Dir["{lib}/**/*"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "sinatra"
  s.add_dependency "faye"
  s.add_dependency "ohm", "~> 2.0.0.rc1"

  s.add_development_dependency "pry"
  s.add_development_dependency "thin"
end
