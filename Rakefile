require 'rubygems'
require 'bundler'
Bundler.setup
require 'rake'
require 'rake/clean'
require 'spec/rake/spectask'

CLEAN.include("*~")

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['specs/**/*_spec.rb']
  t.spec_opts = ['--colour', '--format progress', '--loadby mtime']
end

task :default => :spec

