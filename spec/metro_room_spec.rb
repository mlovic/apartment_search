$parent_dir = File.expand_path("..", File.dirname(__FILE__))
$:.unshift $parent_dir

require 'lib/metro_room'
require 'spec/helpers'
require 'spec/test_data'

RSpec.configure do |c|
  c.include Helpers
  c.include TestData
end

RSpec.describe MetroRoom, ".get_properties_from_line" do
  before(:all) do
    @bocas = (1..3).collect do |x| 
      Boca.new(Location.new([-x, x]), "estacion#{x}", "salida#{x}")
    end
    @properties = (1..3).collect { Property.new }
    #TODO proper test data?
  end
  it 's' do
    [:db_host, :db_user, :db_password, :db_name].each do |arg|
      allow(MetroRoom.configuration).to receive(arg) { 'test_string' }
    end
    allow(MetroDB).to receive(:new)
    allow(MetroRoom).to receive(:init_db)
    allow(MetroRoom.metro_db).to receive(:get_bocas_from_line).with(12) { @bocas }
    allow(MetroRoom).to receive(:get_properties_from_boca) { @properties }

    default_configure
    MetroRoom.init #TODO stub logging? in helpers module?
    properties = MetroRoom.get_properties_from_line({"query" => "test"}, 12)

    puts properties.first.class.name
    expect(properties).to be_an Array
    expect(properties.first.is_a? Property).to be true
    expect(properties.all? { |p| p.is_a? Property }).to be true
  end
end

RSpec.describe MetroRoom, "#get_properties_from_boca" do
  before(:all) do
    @properties = (1..3).collect { Property.new }
    @boca = Boca.new(Location.new([-3, 4]), "Tribunal", "Fuencarral")
  end
  context 'no spike arrest' do
    it 't' do
      allow(Idealista).to receive(:request) { idealista_response_body }
      allow(IdealistaParser).to receive(:get_listings) { @properties }

      properties = MetroRoom.get_properties_from_boca({"query" => "test"}, @boca)
      expect(MetroRoom).not_to receive(:sleep)
      expect { MetroRoom.get_properties_from_boca({"query" => "test"}, @boca) }.not_to raise_error(SpikeArrestError)
      expect(properties).to be_an Array
      expect(properties.first.is_a? Property).to be true
      expect(properties.all? { |p| p.is_a? Property }).to be true
    end
  end
  context 'after spike arrest' do
    it 'raises error' do
      allow(Idealista).to receive(:request) { idealista_spike_arrest}
      allow(IdealistaParser).to receive(:get_listings).and_raise(SpikeArrestError)

      expect(MetroRoom).to receive(:sleep)
      expect { MetroRoom.get_properties_from_boca({"query" => "test"}, @boca) }.to raise_error(SpikeArrestError)
    end
  end
end
