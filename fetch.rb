#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'net/http'
require 'uri'
require 'fileutils'

program :name, 'fetch'
program :version, '0.0.1'
program :description, 'Download Webpages'

command :download do |c|
  c.syntax = 'fetch'
  c.description = 'Download Webpages'
  c.action do |args, _options|
    args.each do |arg|
      uri = URI.parse(arg)
      response = Net::HTTP.get_response uri
      file_name = "#{uri.hostname}.html"
      File.open(file_name, 'w') do |f|
        f.write(response.body)
      end
      say "Webpage #{arg} downloaded in #{file_name}"

    rescue Exception => e
      puts "Failed to download webpage: #{arg}"
      puts "Error: #{e.message}"
    end
  end
end

default_command :download
