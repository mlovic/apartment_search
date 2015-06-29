$parent_dir = File.expand_path("..", File.dirname(__FILE__))
$:.unshift $parent_dir

require 'lib/metro_room'
require 'spec/helpers'

#RSpec.configure(&:include(Helpers))
RSpec.configure do |c|
  c.include Helpers
end

# TODO somehow fake db?

RSpec.describe MetroDB, "#get_bocas_from_line" do
  before(:all) do
    default_configure
    MetroRoom.init
    @db = init_db
  end
  # TODO check convention for language in docs
  context 'when bocas are retrieved' do
    before(:all) { @line = 11 }
    it 'retrieves all rows from database' do
      rs = @db.query("SELECT Y, X, estacion, salida FROM bocas_metro \
                         WHERE linea RLIKE '[[:<:]]#{@line}[[:>:]]';")
      expect(rs.num_rows).to eq 21
      expect(@db.get_bocas_from_line(@line).size).to eq 21
    end
    it 'returns array of Boca objects' do
      bocas = @db.get_bocas_from_line(@line)
      expect(bocas).to be_an Array
      expect(bocas.all? { |b| b.is_a? Boca }).to be true
    end
    it 'does not raise RuntimeError' do
      expect { @db.get_bocas_from_line(@line) }.not_to raise_error(RuntimeError)
    end
  end

  context 'when no bocas are retrieved' do
    before(:all) { @line = 13 }
    it 'raises RuntimeError' do
      expect { @db.get_bocas_from_line(@line) }.to raise_error(RuntimeError)
    end
  end
  
end

