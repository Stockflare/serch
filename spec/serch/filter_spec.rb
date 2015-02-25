class TestSearchIndex

  include Serch::Indexable

  include Serch::Mappable

  include Serch::Queryable

  search_fields :author

  map :author

  map :the_time

  def id
    @id ||= Time.now.to_i
  end

  def author
    "David"
  end

  def the_time
    1337
  end

end

describe Serch::Filter do

  let(:filters) { { fields: { author: "David" } } }

  before do
    @test_index = TestSearchIndex.new
    @test_index.create_index
    sleep 2
  end

  after { @test_index.destroy_index }

  subject { TestSearchIndex.filter(filters) }

  it { should respond_to(:index) }
  it { should respond_to(:body) }
  it { should respond_to(:ident) }
  it { should respond_to(:subject) }

  it { should respond_to(:query) }
  it { should respond_to(:execute) }
  it { should respond_to(:aggregations) }
  it { should respond_to(:results) }
  it { should respond_to(:records) }
  it { should respond_to(:|) }
  it { should respond_to(:total) }

  it "should have the correct subject" do
    expect(subject.subject).to eq TestSearchIndex
  end

  it "should have the correct body" do
    expect(subject.body).to eq Serch::Query.new(subject.index, filters).merge(:fields=>[:_id])
  end

  it "should have the correct ident" do
    expect(subject.ident).to eq :id
  end

  it "should have the correct index" do
    expect(subject.index).to eq TestSearchIndex.name.downcase
  end

  describe "return value of #aggregations" do

    describe "when an average is requested" do

      before { sleep 5 }

      it "should contain the correct aggregate value" do
        expect(TestSearchIndex.aggregate(:the_time, :average)).to eq 1337
      end

    end

  end

  describe "return value of #query" do

    subject { TestSearchIndex.filter(filters) }

    it "should be a hash" do
      expect(subject.query).to be_a Hash
    end

    it "should not be empty" do
      expect(subject.query).to_not be_empty
    end

    it "should contain the correct filter keys" do
      expect(subject.query.keys).to include :index, :body
    end

    it "should contain the correct index" do
      expect(subject.query[:index]).to eq subject.index
    end

    it "should contain the correct body" do
      expect(subject.query[:body]).to eq subject.body
    end

  end

  describe "return value of #execute" do

    subject { TestSearchIndex.filter(filters).execute }

    it { should be_a Hash }

    it { should_not be_empty }

    it "should include a hits key" do
      expect(subject.keys).to include "hits"
    end

  end

  describe "return value of intersection (|)" do

    before { sleep 3 }

    subject { TestSearchIndex.filter(filters) }

    it "should contain the correct id" do
      other_index = TestSearchIndex.filter(filters)
      expect(subject | other_index).to eq subject.records
    end

  end

  describe "return value of #records" do

    before(:all) { sleep 5 }

    describe "when a filter is applied" do

      before { sleep 3 }

      it "should contain the correct id" do
        expect(TestSearchIndex.filter(filters).records).to include @test_index.id.to_s
      end

    end

    describe "when a search is performed" do

      before { sleep 3 }

      it "should contain the correct id" do
        expect(TestSearchIndex.search("Dav").records).to include @test_index.id.to_s
      end

    end

  end

end
