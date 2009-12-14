# HallenprojektStatus For OSX

Super alpha status bar app for [http://www.hallenprojekt.de](http://www.hallenprojekt.de)

This is my first cocoa app, which means it is hackish and its development involved a lot of trial and error. Help is appreciated.

## Download

The most recent version can be found [here.](http://hallenprojekt.huesler-informatik.ch/HallenprojektStatus.dmg)

## Requirements to build diskimage

* Xcode
* Ruby
* rubygems
* rake (gem install rake)
* choctop (gem install choctop)

## Building a disk image

1. run rake cleanup
2. run rake dmg
3. open appcast/build/HallenprojektStatus.dmg

## TODOS

Please check [here](http://github.com/phuesler/Hallenprojektstatus/issues)

* Add unit tests
* Reconnect to server if credentials were invalid
* Make the application background only. I couldn't figure out how to get it working
  with the preference window.
* User preferences for favorite locations
* Use WIFI SSID and/or core location to list the closest places first
* Create proper http post requests with content type set to 'application/json'

[hallenprojekt.de]: http://www.hallenprojekt.de
