$parent_dir = File.expand_path("..", File.dirname(__FILE__))
$:.unshift $parent_dir

require 'property'
require 'idealista_parser'

RSpec.describe Property, "#print" do
  before do
    filename = File.expand_path("test_response.json", $parent_dir)
    json = File.read(filename)
    @properties = IdealistaParser.get_listings(json)
    @coord = [40.4229014, -3.6976351]
  end
  it "works" do
    pending
    prop = @properties[0]
    expect(prop.distance(@coord).round(0).integer?).to be_truthy
    prop.print(@coord)
  end
end
