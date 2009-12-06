require "rubygems"
require "rake"

require "choctop"
require "ftp_sync"
require 'highline/import'

module ChocTop::Appcast
  def upload_appcast
    passwd = ask("Password for ftp server please: ") { |q| q.echo = "x"}
    ftp = FtpSync.new('ftp.huesler-informatik.ch', 'hallenprojekt@huesler-informatik.ch', passwd.chomp)
    ftp.sync(build_path, '/')
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

ChocTop.new do |s|
  s.info_plist_path = 'HallenprojektStatus-Info.plist'
  # Custom DMG
  # s.background_file = "background.jpg"
  # s.app_icon_position = [100, 90]
  # s.applications_icon_position =  [400, 90]
  # s.volume_icon = "dmg.icns"
  # s.applications_icon = "appicon.icns" # or "appicon.png"
end
