# make sure our ./lib directory is added to the ruby search path
$: << File.expand_path(File.join(File.dirname(__FILE__),"lib"))

require 'ostruct'
require 'rubygems'
require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/rdoctask'
require 'rake/contrib/sshpublisher'
require 'rubyforge'
require 'spec/rake/spectask'
require 'webgen/rake/webgentask'
require 'keybox'

#-----------------------------------------------------------------------
# most of this is out of hoe, but I needed more flexibility in directory
# structures, publishing options for docs and such
#
# Once the build, and runtime dependency issues are resolved with gems
# and hoe has the ability to change the directory that rdocs are
# published to I'll migrate this to using hoe.
#-----------------------------------------------------------------------
PKG_INFO = OpenStruct.new
PKG_INFO.rubyforge_name = 'keybox'
PKG_INFO.summary        = Keybox::DESCRIPTION
PKG_INFO.description    = Keybox::DESCRIPTION
PKG_INFO.url            = Keybox::HOMEPAGE
PKG_INFO.email          = Keybox::AUTHOR_EMAIL
PKG_INFO.author         = Keybox::AUTHOR
PKG_INFO.version        = Keybox::VERSION.join(".")

PKG_INFO.rdoc_dir       = "doc/rdoc"
PKG_INFO.rdoc_main      = "README"
PKG_INFO.rdoc_title     = "#{PKG_INFO.name} - #{PKG_INFO.version}"
PKG_INFO.rdoc_options   = [ "--line-numbers", "--inline-source" ]
PKG_INFO.rdoc_files     = FileList['README', 'CHANGES', 'lib/**/*.rb']
PKG_INFO.file_list      = FileList['bin/**', 
                                   'resource/**',
                                   'spec/**/*.rb'] + PKG_INFO.rdoc_files

PKG_INFO.publish_dir    = "doc"
PKG_INFO.message        = "Try `keybox --help` for more information"

#-----------------------------------------------------------------------
# setup an initial task
#-----------------------------------------------------------------------
desc "Default task"
task :default => :spec

#-----------------------------------------------------------------------
# Packaging and Installation
#-----------------------------------------------------------------------
spec = Gem::Specification.new do |s|
    s.name                  = PKG_INFO.rubyforge_name
    s.rubyforge_project     = PKG_INFO.rubyforge_name
    s.version               = PKG_INFO.version
    s.summary               = PKG_INFO.summary
    s.description           = PKG_INFO.description

    s.author                = PKG_INFO.author
    s.email                 = PKG_INFO.email
    s.homepage              = PKG_INFO.url

    s.files                 = PKG_INFO.file_list
    s.require_paths         << "lib"

    s.extra_rdoc_files      = FileList["*.txt"]
    s.has_rdoc              = true 
    s.rdoc_options          = PKG_INFO.rdoc_options

    s.post_install_message  = PKG_INFO.message
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
    pkg.need_zip = true
end

desc "Install as a gem"
task :install_gem => [:clean, :package] do
    sh "sudo gem install pkg/*.gem"
end


#-----------------------------------------------------------------------
# Testing - using rspec instead of unit testing
#-----------------------------------------------------------------------
rspec = Spec::Rake::SpecTask.new do |r|
    r.warning   = true
    r.rcov      = true
    r.rcov_dir  = "doc/coverage"
    r.libs      << "./lib" 
end

#CLOBBER << rspec.rcov_dir

#-----------------------------------------------------------------------
# Documentation
#-----------------------------------------------------------------------

rd = Rake::RDocTask.new => [:changelog] do |rdoc|
    rdoc.rdoc_dir   = PKG_INFO.rdoc_dir
    rdoc.title      = PKG_INFO.rdoc_title
    rdoc.main       = PKG_INFO.rdoc_main
    rdoc.options    << PKG_INFO.rdoc_options
    rdoc.rdoc_files = PKG_INFO.rdoc_files
end

# defaults are good here
Webgen::Rake::WebgenTask.new

desc "Generate all docs"
task :docs => [:rdoc,:webgen,:spec] 

