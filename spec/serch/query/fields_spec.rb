describe Serch::Query::Field do

  let(:test) {{
    price: 1,
    stock: { greater_than: 10 },
    count: { less_than: 20, greater_than: 1 },
    pe_ratio: nil
  }}

  let(:index) { "test::index" }

  before do
    @fields = Serch::Query::Field.new(test, index)
  end

  subject { @fields }

  it { should be_a Hash }

  it { should_not be_empty }

  it "should include the query key" do
    expect(subject.keys).to include :query
  end

  describe "contents of the query key" do

    subject { @fields[:query] }

    it { should be_a Hash }

    it "should contain bool matches" do
      expect(subject[:bool][:must]).to be_a Array
    end

    describe "contents of the bool matches array" do

      subject { @fields[:query][:bool][:must] }

      it { should be_a Array }

      it { should_not be_empty }

      it "should contain the correct price" do
        expect(subject).to include({
          query_string: {
            default_field: "#{index}.price",
            query: 1
          }
        })
      end

      it "should contain the correct stock" do
        expect(subject).to include({
          range: {
            "#{index}.stock" => { gt: 10 }
          }
        })
      end

      it "should contain the correct count" do
        expect(subject).to include({
          range: {
            "#{index}.count" => { gt: 1, lt: 20 }
          }
        })
      end

      it "should contain the correct nil filter" do
        expect(subject).to include({
          filtered: {
            filter: {
              missing: {
                field: "#{index}.pe_ratio",
                null_value: true
              }
            }
          }
        })
      end

    end

  end

end
