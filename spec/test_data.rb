$parent_dir = File.expand_path("..", File.dirname(__FILE__))
$:.unshift $parent_dir

require 'lib/metro_room'

module TestData
  #TODO metaprogramming to dry up
  def idealista_response_body
    File.read("#{MetroRoom.root}/spec/response_sample.json")
  end

  def idealista_spike_arrest
    File.read("#{MetroRoom.root}/spec/spike_arrest_response_sample.json")
  end

  def idealista_response_no_properties
    File.read("#{MetroRoom.root}/spec/no_properties_response_sample.json")
  end
end
