describe Serch::Query::Pagination do

  let(:test) { { per_page: 10, page: 1 } }

  before do
    @pagination = Serch::Query::Pagination.new(test)
  end

  subject { @pagination }

  it { should be_a Hash }

  it { should_not be_empty }

  describe "contents of the pagination hash" do

    it "should contain the from and size keys" do
      expect(subject.keys).to include :from, :size
    end

    it "should have the correct size" do
      expect(subject[:size]).to eq 10
    end

    it "should have the correct offset" do
      expect(subject[:from]).to eq 0
    end

  end

  describe "when the page is 0" do

    let(:test) { { per_page: 10, page: 0 } }

    before do
      @pagination = Serch::Query::Pagination.new(test)
    end

    subject { @pagination }

    it "should have the correct offset" do
      expect(subject[:from]).to eq 0
    end

  end

  describe "when the page is 1" do

    let(:test) { { per_page: 10, page: 1 } }

    before do
      @pagination = Serch::Query::Pagination.new(test)
    end

    subject { @pagination }

    it "should have the correct offset" do
      expect(subject[:from]).to eq 0
    end

  end

  describe "when the page is 2" do

    let(:test) { { per_page: 10, page: 2 } }

    before do
      @pagination = Serch::Query::Pagination.new(test)
    end

    subject { @pagination }

    it "should have the correct offset" do
      expect(subject[:from]).to eq 10
    end

  end

end
