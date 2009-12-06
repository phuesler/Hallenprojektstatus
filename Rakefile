require "rubygems"
require "rake"

require "choctop"
require "deploy/ftp_sync"
require 'deploy/version_helper'
require 'highline/import'

module ChocTop::Appcast
  def upload_appcast
    passwd = ask("Password for ftp server please: ") { |q| q.echo = "x"}
    ftp = FtpSync.new('ftp.huesler-informatik.ch', 'hallenprojekt@huesler-informatik.ch', passwd.chomp)
    ftp.sync(build_path, '/')
  end
end

info_plist_path = 'HallenprojektStatus-Info.plist'
ChocTop.new do |s|
  s.info_plist_path = info_plist_path
  # Custom DMG
  # s.background_file = "background.jpg"
  # s.app_icon_position = [100, 90]
  # s.applications_icon_position =  [400, 90]
  # s.volume_icon = "dmg.icns"
  # s.applications_icon = "appicon.icns" # or "appicon.png"
end

namespace :version do
  task :current do
    puts VersionHelper.new(info_plist_path).to_s
  end
  
  namespace :bump do
    desc "Bump the gemspec by a major version."
    task :major do
      VersionHelper.new(info_plist_path) do |version|
        version.bump_major
      end
    end

    desc "Bump the gemspec by a minor version."
    task :minor do
      VersionHelper.new(info_plist_path) do |version|
        version.bump_minor
      end
    end

    desc "Bump the gemspec by a patch version."
    task :patch do
      VersionHelper.new(info_plist_path) do |version|
        version.bump_patch
      end
    end
  end
end

desc "Cleanup"
task :cleanup do
  puts "Cleaning up directories"
  `rm -Rf appcast`
  `rm -Rf build/Release/dmg`
end


desc "Release"
task :release => [:cleanup,:build,:dmg,:feed,:upload] do
end