# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "db_structure_ext/version"

Gem::Specification.new do |s|
  s.name        = "db_structure_ext"
  s.version     = DbStructureExt::VERSION
  s.authors     = ["Andriy Yanko"]
  s.email       = ["andriy.yanko@gmail.com"]
  s.homepage    = "https://github.com/railsware/db_structure_ext/"
  s.summary     = %q{ActiveRecord connection adapter extensions}
  s.description = %q{Extended rails tasks db:structure:dump/load methods that supports mysql views/triggers/routines}

  s.rubyforge_project = "db_structure_ext"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
