describe Serch do

  it { should respond_to(:debug) }
  it { should respond_to(:debug=) }
  it { should respond_to(:host) }
  it { should respond_to(:host=) }
  it { should respond_to(:port) }
  it { should respond_to(:port=) }

  describe "return value of #host" do

    let(:host) { "host" }

    before { Serch.host = host }

    specify  { expect(Serch.host).to be_a String }

    specify  { expect(Serch.host).to eq host }

  end

  describe "return value of #port" do

    let(:port) { "port" }

    before { Serch.port = port }

    specify  { expect(Serch.port).to be_a String }

    specify  { expect(Serch.port).to eq port }

  end

  describe "return value of #debug" do

    before { Serch.debug = true }

    specify  { expect(Serch.debug).to_not be_falsey }

    specify  { expect(Serch.debug).to eq true }

  end

end
