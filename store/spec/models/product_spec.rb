require 'spec_helper'

describe Product do
  describe "#cheap?" do
    context "a cheap product" do
      before { subject.price = 0.99 }

      it "should return true" do
        subject.should be_cheap
      end
    end

    context "an expensive product" do
      before { subject.price = 1.00 }

      it "should return false" do
        subject.should_not be_cheap
      end
    end
  end
end

