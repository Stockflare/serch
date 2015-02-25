describe Serch do

  it { should respond_to(:debug) }
  it { should respond_to(:debug=) }
  it { should respond_to(:host) }
  it { should respond_to(:host=) }
  it { should respond_to(:port) }
  it { should respond_to(:port=) }

  describe "return value of #host" do

    let(:host) { "host" }

    before { subject.host = host }

    subject { subject.host }

    it "should not be nil" do
      expect(subject).to be_a String
    end

    it "should set the correct value" do
      expect(subject).to eq host
    end

  end

  describe "return value of #port" do

    let(:port) { "port" }

    before { subject.port = port }

    subject { subject.port }

    it "should not be nil" do
      expect(subject).to be_a String
    end

    it "should set the correct value" do
      expect(subject).to eq port
    end

  end

  describe "return value of #debug" do

    before { subject.debug = true }

    subject { subject.debug }

    it "should not be nil" do
      expect(subject).to_not be nil
    end

    it "should set the correct value" do
      expect(subject).to eq true
    end

  end

end
