describe Serch::Query::Term do

  let(:test) {{
    query: "TWTR",
    fields: [{ a: 2, b: 3}, "c"]
  }}

  let(:index) { "test::index" }

  before do
    @term = Serch::Query::Term.new(test, index)
  end

  subject { @term }

  it { should be_a Hash }

  it { should_not be_empty }

  it "should include the query key" do
    expect(subject.keys).to include :query
  end

  describe "contents of the query key" do

    subject { @term[:query] }

    it { should be_a Hash }

    it "should include the multi_match key" do
      expect(subject.keys).to include :multi_match
    end

    describe "contents of the multi_match hash" do

      subject { @term[:query][:multi_match] }

      it { should be_a Hash }

      it { should_not be_empty }

      it "should include the query key" do
        expect(subject.keys).to include :query
      end

      it "should include the fields key" do
        expect(subject.keys).to include :fields
      end

      describe "contents of query" do

        subject { @term[:query][:multi_match][:query] }

        it "should be the correct search query" do
          expect(subject).to eq "TWTR"
        end

      end

      describe "contents of fields" do

        subject { @term[:query][:multi_match][:fields] }

        it { should be_a Array }

        it { should_not be_empty }

        it "should contain the correct fields" do
          expect(subject).to include "#{index}.a^2", "#{index}.b^3", "#{index}.c^1"
        end

      end

    end

  end

end
