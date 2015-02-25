class TestSearchMapping

  include Serch::Mappable

  map :author, :a, [:b, true], [:c, 'David']

  map [:now, :time], :a, :b

  map :d

  map_from :a, :nested_map

  def a
    self
  end

  def b(c = false)
    if c
      self.class
    else
      self
    end
  end

  def self.c(name)
    name
  end

  def d
    "lol"
  end

  def now
    Time.now.to_i
  end

  def time
    self.now
  end

  def nested_map
    AnotherTestSearchMapping.new
  end

end

class AnotherTestSearchMapping

  include Serch::Mappable

  map :special

  def special
    1
  end

end

describe Serch::Mapping do

  before do
    @test = TestSearchMapping.new
  end

  subject { @test.to_map }

  it { should be_a Hash }

  it { should_not be_empty }

  it "should contain the correct keys" do
    expect(subject.keys).to include :author, :now, :time, :d, :special
  end

  it "should contain the correct author value" do
    expect(subject[:author]).to include "David"
  end

  it "should contain the now value" do
    expect(subject[:now]).to_not be_nil
  end

  it "should contain the time value" do
    expect(subject[:time]).to_not be_nil
  end

  it "should contain the correct time values" do
    expect(subject[:now]).to eq subject[:time]
  end

  it "should contain the correct value for d" do
    expect(subject[:d]).to eq "lol"
  end

  it "should contain the correct value for special" do
    expect(subject[:special]).to eq 1
  end

end
