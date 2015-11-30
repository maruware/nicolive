#!/usr/bin/env rake

require "bundler/gem_tasks"

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|

  test.test_files = FileList["test/*.rb"].exclude("test/test_helper.rb")
  test.verbose = false
end