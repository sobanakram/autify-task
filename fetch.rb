#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'net/http'
require 'uri'
require 'fileutils'
require './website.rb'

program :name, 'fetch'
program :version, '0.0.1'
program :description, 'Download Webpages'

def download_website(website)
  uri = URI.parse(website)
  response = Net::HTTP.get_response uri
  file_name = "#{uri.hostname}.html"
  File.open(file_name, 'w') do |f|
    f.write(response.body)
  end
  say "Webpage #{website} downloaded in #{file_name}"
  Website.record(website, uri.hostname, response.body)
rescue Exception => e
  puts "Failed to download webpage: #{website}"
  puts "Error: #{e.message}"
end

def show_metadata(website)
  website = Website.find_by(name: website)
  if website.present?
    puts "site: #{website.host}"
    puts "num_links: #{website.links_count}"
    puts "images: #{website.images_count}"
    puts "last_fetch: #{website.last_fetched_at}"
  else
    puts "Website #{arg} haven't fetched yet"
  end
end

command :download do |c|
  c.syntax = 'fetch'
  c.description = 'Download Webpages'
  c.option '--metadata STRING', String, 'Get Website metadata'
  c.action do |args, options|
    options.default :metadata => nil
    if options.metadata.present?
      show_metadata(options.metadata)
    else
      args.each do |arg|
        download_website(arg)
      end
    end
  end
end

default_command :download
