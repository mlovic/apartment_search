$parent_dir = File.expand_path("..", File.dirname(__FILE__))
$:.unshift $parent_dir

require 'lib/metro_room'
require 'spec/test_data'

RSpec.configure do |c|
  c.include TestData
end

RSpec.describe IdealistaParser, ".getlistings" do

  before(:all) do
    @json = idealista_response_body
    MetroRoom.configure {}
    MetroRoom.init #take care of this, logging
  end
  context 'When request is successful' do
    before(:all) do
      @json = idealista_response_body
    end
    it 'returns properties' do
      expect(@json.is_a? String).to be true 
      obj = JSON.parse(@json)
      expect(obj["elementList"]).to be_an Array
      expect(obj["elementList"].size).to eq 2
      expect { IdealistaParser.get_listings(@json) }.not_to raise_error
      properties = IdealistaParser.get_listings(@json)
      expect(properties).to be_an Array
      expect(properties.first).to be_a Property
      expect(properties.size).to eq 2
    end
  context 'When zero properties found' do
    before(:all) { @json = idealista_response_no_properties }
    it 'returns empty array' do
      properties = IdealistaParser.get_listings(@json)
      expect(properties).to eq []
      #warning?
    end

  end
  end
end

RSpec.describe IdealistaParser, ".check_spike_arrest" do
  before(:all) do
    MetroRoom.configure {}
    MetroRoom.init #take care of this, logging
  end
  context 'request is successful' do
    it 'does nothing' do
      @json = idealista_response_body
      obj = JSON.parse(@json)
      expect(obj).not_to have_key("fault")
      expect { IdealistaParser.send(:check_spike_arrest, obj) }.not_to raise_exception
    end
  end
  context 'when request is successful' do
    it 'raises SpikeArrestError' do
      @json = idealista_spike_arrest
      obj = JSON.parse(@json)
      expect(obj).to have_key("fault")
      expect(obj["fault"]).to be_truthy
      expect(obj["fault"]["faultstring"]).to eq "Spike arrest violation. Allowed rate : 1ps"
      expect { IdealistaParser.send(:check_spike_arrest, obj) }.to raise_exception(SpikeArrestError)
    end
  end
end
