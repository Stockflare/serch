describe Serch::Query::Aggregation do

  let(:test) { { field: :pe_ratio, type: :average } }

  before do
    @aggregation = Serch::Query::Aggregation.new(test)
  end

  subject { @aggregation }

  it { should be_a Hash }

  it { should_not be_empty }

  describe "contents of the aggregation hash" do

    it "should contain the aggs key" do
      expect(subject.keys).to include :aggs
    end

    it "should include the correct aggregation key" do
      expect(subject[:aggs].keys).to include :pe_ratio
    end

    it "should include the correct aggregation type" do
      expect(subject[:aggs][:pe_ratio].keys).to include :avg
    end

    it "should be creating aggregations on the correct field" do
      expect(subject[:aggs][:pe_ratio][:avg][:field]).to eq :pe_ratio
    end

  end

end
