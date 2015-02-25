describe Serch::Query::Sorting do

  let(:test) { { price: :asc, count: :desc, _score: nil } }

  before do
    @sorting = Serch::Query::Sorting.new(test)
  end

  subject { @sorting }

  it { should be_a Hash }

  it { should_not be_empty }

  it "should include the sort key" do
    expect(subject.keys).to include :sort
  end

  describe "contents of the sorting array" do

    subject { @sorting[:sort] }

    it { should be_a Array }

    it "should contain the correct sorting keys" do
      expect(subject.length).to eq 3
    end

    describe "when sorting by a hash" do

      let(:test) { { price: :asc } }

      before do
        @sorting = Serch::Query::Sorting.new(test)
      end

      subject { @sorting[:sort] }

      it "should be the correct length" do
        expect(subject.length).to eq 1
      end

      it "should contain the correct hash" do
        expect(subject[0]).to eq({ price: :asc })
      end

    end

    describe "when implying sorting by a key" do

      let(:test) { { :_score => nil } }

      before do
        @sorting = Serch::Query::Sorting.new(test)
      end

      subject { @sorting[:sort] }

      it "should be the correct length" do
        expect(subject.length).to eq 1
      end

      it "should contain the correct sorting" do
        expect(subject[0]).to eq(:_score)
      end

    end


  end

end
