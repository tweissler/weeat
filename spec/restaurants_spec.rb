describe Restaurant do
  context “When testing the Restaurant class” do

    it "should say 'Hello World' when we call the say_hello method" do
      rest = Restaurant.new
      message = rest.
      expect(message).to eq "Hello World!"
    end

  end
end