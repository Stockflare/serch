class TestSearchIndex

  include Serch::Indexable

  include Serch::Mappable

  attr_accessor :author, :id

  map :author

  index :post

  def initialize
    @id = Time.now.to_i
    @author = "David"
  end

  def id
    Time.now.to_i
  end

end

describe Serch::Index do

  let(:id) { Time.now.to_i }
  let(:type) { "a_type" }
  let(:name) { "a_name" }
  let(:body) { { tag: "lol" } }

  before do
    @index = Serch::Index.new(name, type, id, body)
  end

  subject { @index }

  it { should respond_to(:name) }
  it { should respond_to(:type) }
  it { should respond_to(:id) }

  it { should respond_to(:save) }
  it { should respond_to(:destroy) }

  it { should be_a Hash }

  it { should_not be_empty }

  it "should have the correct type" do
    expect(subject.type).to eq type
  end

  it "should have the correct name" do
    expect(subject.name).to eq name
  end

  it "should have the correct id" do
    expect(subject.id).to eq id
  end

  it "should contain the correct body keys" do
    expect(subject.keys).to include :tag
  end

  it "should contain the correct body values" do
    expect(subject[:tag]).to eq "lol"
  end

  describe "return value of #index" do

    subject { @index.index }

    it { should be_a Hash }

    it { should include :index, :type, :id, :body }

    it "should contain the correct index" do
      expect(subject[:index]).to eq @index.name
    end

    it "should contain the correct type" do
      expect(subject[:type]).to eq @index.type
    end

    it "should contain the correct id" do
      expect(subject[:id]).to eq @index.id
    end

    it "should contain the correct body" do
      expect(subject[:body]).to eq @index.to_h
    end

    describe "when an update index is requested" do

      subject { @index.index(true) }

      it "should contain upsert in the body" do
        expect(subject[:body].keys).to include :doc
      end

    end

  end

  describe "when a valid class is indexed" do

    before do
      @test = TestSearchIndex.new
    end

    subject { @test }

    it { should respond_to(:create_index) }
    it { should respond_to(:update_index) }
    it { should respond_to(:destroy_index) }

    it "should create an index" do
      sleep 2
      expect(subject.create_index).to be_truthy
      subject.destroy_index
    end

    it "should update an index" do
      sleep 2
      subject.create_index
      subject.author = "Jonathan"
      expect(subject.update_index).to be_truthy
      subject.destroy_index
    end

    it "should destroy an index" do
      sleep 2
      subject.create_index
      expect(subject.destroy_index).to be_truthy
    end

  end

end
