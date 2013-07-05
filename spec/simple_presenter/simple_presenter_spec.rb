require 'spec_helper'

describe SimplePresenter::Base do
  subject { SimplePresenter::Base.new(obj) }
  let(:obj) { OpenStruct.new(test_data: "# pants", children: ["child1", "child2"]) }

  describe "#initialize" do
    it "should delegate to the object passed to it" do
      subject.test_data.should == obj.test_data
    end
  end


end
