class TestSearchQuery
  include Serch::Queryable
  query_index :test
end

describe Serch::Query do

  let(:index_name) { "test::index" }

  let(:test) {{
    sorting: {
      price: :asc,
      rating: :desc
    },
    pagination: {
      per_page: 30,
      page: 2
    },
    fields: {
      rating: { greater_than: 3 },
      cheaper: true
    },
    aggregation: {
      field: :pe_ratio,
      type: :average
    }
  }}

  before do
    @query = Serch::Query.new(index_name, test)
  end

  subject { @query }

  it { should respond_to(:index) }
  it { should respond_to(:index=) }
  it { should respond_to(:append!) }

  it { should be_a Hash }
  it { should_not be_empty }

  it "should contain the correct keys" do
    expect(subject.keys).to include :sort, :from, :size, :query
  end

  it "should contain a non-empty sort key" do
    expect(subject[:sort]).to be_a Array
  end

  it "should contain a non-empty from key" do
    expect(subject[:from]).to be_a Fixnum
  end

  it "should contain a non-empty size key" do
    expect(subject[:size]).to be_a Fixnum
  end

  it "should contain a non-empty query key" do
    expect(subject[:query]).to be_a Hash
  end

  describe "when a Queryable class is used" do

    subject { TestSearchQuery }

    it { should respond_to(:filter) }
    it { should respond_to(:search) }

  end

end
