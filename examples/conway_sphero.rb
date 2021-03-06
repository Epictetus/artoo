require 'artoo/robot'

class ConwaySpheroRobot < Artoo::Robot
  connection :sphero, :adaptor => :sphero
  device :sphero, :driver => :sphero
  
  #api :host => '127.0.0.1', :port => '8080'

  work do
    birth

    every(3.seconds) { movement if alive? }
    every(10.seconds) { birthday if alive? }
  end

  def alive?; (@alive == true); end

  def birth
    sphero.detect_collisions
    @age = 0
    life
    movement
  end

  def life
    @alive = true
    sphero.set_color :green
  end

  def death
    puts "Death."
    @alive = false
    sphero.set_color :red
    sphero.stop
    terminate
  end

  def birthday
    @age += 1
    contacts = sphero.collisions.size
    sphero.clear_collisions
    
    puts "Happy birthday, #{name}, you are #{@age} and had #{contacts} contacts."
    #return if @age <= 3
    death unless contacts >= 3 && contacts < 5
  end

  def movement
    sphero.roll 90, rand(360)
  end
end

SPHEROS = {"127.0.0.1:4560" => "/dev/tty.Sphero-BRG-RN-SPP",
           "127.0.0.1:4561" => "/dev/tty.Sphero-YBW-RN-SPP",
           "127.0.0.1:4562" => "/dev/tty.Sphero-BWY-RN-SPP",
           "127.0.0.1:4563" => "/dev/tty.Sphero-YRR-RN-SPP",
           "127.0.0.1:4564" => "/dev/tty.Sphero-OBG-RN-SPP",
           "127.0.0.1:4565" => "/dev/tty.Sphero-GOB-RN-SPP",
           "127.0.0.1:4566" => "/dev/tty.Sphero-PYG-RN-SPP"}
robots = []
SPHEROS.each_key {|p|
  robots << ConwaySpheroRobot.new(:connections => 
                              {:sphero => 
                                {:port => p}})
}

ConwaySpheroRobot.work!(robots)
