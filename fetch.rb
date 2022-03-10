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

command :download do |c|
  c.syntax = 'fetch'
  c.description = 'Download Webpages'
  c.option '--metadata STRING', String, 'Get Website metadata'
  c.action do |args, options|
    options.default :metadata => nil
    if options.metadata.present?
      website = Website.find_by(name: options.metadata)
      if website.present?
        puts "site: #{website.host}"
        puts "num_links: #{website.links_count}"
        puts "images: #{website.images_count}"
        puts "last_fetch: #{website.last_fetched_at}"
      else
        puts "Website #{arg} haven't fetched yet"
      end
    else
      args.each do |arg|
        uri = URI.parse(arg)
        response = Net::HTTP.get_response uri
        file_name = "#{uri.hostname}.html"
        File.open(file_name, 'w') do |f|
          f.write(response.body)
        end
        say "Webpage #{arg} downloaded in #{file_name}"
        Website.record(arg, uri.hostname, response.body)
      rescue Exception => e
        puts "Failed to download webpage: #{arg}"
        puts "Error: #{e.message}"
      end
    end
  end
end

default_command :download
