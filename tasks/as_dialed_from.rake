require 'rake'
require File.dirname(__FILE__) + '/../lib/as_dialed_from.rb'

desc "Downloads and parses country metadata from Google's libphonenumber project"
task :update do
  AsDialedFrom::Metadata.download
  AsDialedFrom::Metadata.parse
end

namespace :update do
  desc "Downloads XML file from Google"
  task :download do
    AsDialedFrom::Metadata.download
  end
  
  desc "Parses XML into YAML files"
  task :parse do
    AsDialedFrom::Metadata.parse
  end
end
