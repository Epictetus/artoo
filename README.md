# artoo

http://artoo.io/

Artoo is a micro-framework for robotics using Ruby.

Artoo provides a simple, yet powerful domain-specific language (DSL) for robotics and physical computing.

[![Code Climate](https://codeclimate.com/github/hybridgroup/artoo.png)](https://codeclimate.com/github/hybridgroup/artoo) [![Build Status](https://travis-ci.org/hybridgroup/artoo.png?branch=master)](https://travis-ci.org/hybridgroup/artoo)

## Examples:

### Basic

Arduino with an LED and a button, using the Firmata protocol.

```ruby
require 'artoo'

connection :arduino, :adaptor => :firmata, :port => '/dev/tty.usbmodemxxxxx'
device :led, :driver => :led, :pin => 13
device :button, :driver => :button, :pin => 2

work do
  on button, :push => proc {led.toggle}
end
```

Parrot ARDrone 2.0

```ruby
require 'artoo'

connection :ardrone, :adaptor => :ardrone
device :drone, :driver => :ardrone
  
work do
  drone.start
  drone.take_off
  
  after(25.seconds) { drone.hover.land }
  after(30.seconds) { drone.stop }
end
```

### Modular

```ruby
require 'artoo/robot'

SPHEROS = ["4567", "4568", "4569", "4570", "4571"]

class SpheroRobot < Artoo::Robot
  connection :sphero, :adaptor => :sphero
  device :sphero, :driver => :sphero
  
  work do
    every(3.seconds) do
      sphero.roll 90, rand(360)
    end
  end
end

robots = []
SPHEROS.each {|p|
  robots << SpheroRobot.new(:connections => 
                              {:sphero => 
                                {:port => p}})
}

SpheroRobot.work!(robots)
```

Ruby versions supported: Ruby 2.0, Ruby 1.9.3, JRuby 1.7.2, and Rubinius 2.0-rc1


Artoo is conceptualy influenced by Sinatra (https://github.com/sinatra/sinatra) as well as borrowing some code from it.

Artoo provides a robust actor-based messaging architecture, that can support fully multi-threaded operation and high-concurrency, as long as it is supported by the Ruby version in which it is executing. This means you will need to use JRuby or Rubinius for maximum concurrency. 

To a large extent, this is due to being built on top of Celluloid (https://github.com/celluloid/celluloid), Celluloid::IO (https://github.com/celluloid/celluloid-io), and Reel (https://github.com/celluloid/reel).

## API:

Artoo includes a RESTful API to query the status of any robot running within a group, including the connection and device status, and device streaming data via websockets.

To activate the API, use the `api` command like this:

```ruby
require 'artoo'

connection :loop
device :passthru
api :host => '127.0.0.1', :port => '4321'

work do
  puts "Hello from the API running at #{api_host}:#{api_port}..."
end
```

Once the robot or group is working, you can view the main API page at the host and port specified.

## CLI:

Artoo includes Robi, a Command Line Interface (CLI) based on Pry (http://pryrepl.org/) to allow you to interactively control your robot.

```
robi ./examples/hello.rb
I, [2013-03-16T18:14:22.281462 #61513]  INFO -- : Registering connection 'loop'...
I, [2013-03-16T18:14:22.283027 #61513]  INFO -- : Preparing work...
[1] pry(main)> start
I, [2013-03-16T18:14:23.836523 #61513]  INFO -- : Initializing connection loop...
I, [2013-03-16T18:14:23.842265 #61513]  INFO -- : Starting work...
I, [2013-03-16T18:14:23.842879 #61513]  INFO -- : Connecting to 'loop' on port '#<Artoo::Port:0xe3c0>'...
[2] pry(main)> list
#<Artoo::MainRobot:0xe5e4>
[3] pry(main)> exit
```

## Installing:

```ruby
gem install artoo
```

Then install the gems required by your specific supported hardware:

```ruby
gem install hybridgroup-firmata
gem install hybridgroup-argus
gem install hybridgroup-sphero
```

## Running:

```ruby
ruby myrobot.rb
```

