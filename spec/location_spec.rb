$parent_dir = File.expand_path("..", File.dirname(__FILE__))
$:.unshift $parent_dir

require 'location'

RSpec.describe Location, "#new" do
  it 'works with string' do
    expect("3.934540,43.94983".is_a? String).to be_truthy
    expect {Location.new("3.934540,43.94983")}.not_to raise_error
  end
  it 'works with 2el array' do
    expect {Location.new([3.934540, 43.94983])}.not_to raise_error
  end
  it 'does not work with 1 float' do
    expect {Location.new([3.934540])}.to raise_error(ArgumentError)
  end
end
