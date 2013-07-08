require 'spec_helper'

describe SimplePresenter::Base do
  subject { SimplePresenter::Base.new(obj) }
  let(:obj) { OpenStruct.new(test_data: "# pants", children: ["child1", "child2"], only_child: "Child 3") }

  describe "#initialize" do
    it "should delegate to the object passed to it" do
      subject.test_data.should == obj.test_data
    end
  end

  describe ".presents" do
    before { SimplePresenter::Base.presents :obj }
    it "should create a version of the object" do
      subject.obj.should == obj
    end
  end

  context "dynamically creating finder for relationships" do
    before(:all) do
      class ChildPresenter; def initialize(o);end;end;
      class OnlyChildPresenter; def initialize(o);end;end;

      SimplePresenter::Base.presents_many :children
      SimplePresenter::Base.presents_one :only_child
    end

    describe "#relation_presenter_class" do
      it "should return a presenter class based on the relation name" do
        obj.children.first.stub_chain(:class, :name).and_return("Children")

        subject.relation_presenter_class(obj.children.first).should == ChildPresenter
      end
    end

    describe "#apply_presenter" do
      it "should return a new instance of a presenter class" do
        obj.children.first.stub_chain(:class, :name).and_return("Children")

        subject.apply_presenter(obj.children.first).should be_a(ChildPresenter)
      end
    end

    describe ".presents_many" do
      it { should respond_to(:children) }
      it "should return a collection of ChildPresenters" do
        obj.children.map {|o| o.stub_chain(:class, :name).and_return("Children") }

        subject.children.first.should be_a(ChildPresenter)
      end
    end

    describe '.presents_one' do
      it { should respond_to(:only_child) }
      it 'should return a presenter class based on the singular relation name' do
        obj.only_child.stub_chain(:class, :name).and_return("OnlyChild")
        subject.only_child.should be_a(OnlyChildPresenter)
      end
    end

  end

end
