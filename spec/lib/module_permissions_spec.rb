require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "factory_helper")

module SomeModule
  def self.some_method
    :result
  end
end

module OtherModule
end

describe SomeModule do
  before :each do
    @p1 = Factory(:permission, :controllable_type => "SomeModule")
    @p2 = Factory(:permission, :controllable_type => "SomeModule", :action => "some")
  end

  it "should be able to store permission reference for each module" do
    SomeModule.permission_references.should be_nil
    OtherModule.permission_references.should be_nil

    SomeModule.permission_reference :some
    OtherModule.permission_reference "other"

    SomeModule.permission_references.should == [:some]
    OtherModule.permission_references.should == [:other]
  end

  it "should be able to fetch permission by action" do
    SomeModule.permission_for(:test).should == @p1
    SomeModule.permission_for(:some).should == @p2
  end

  describe "when fetching reference by key" do
    before :each do
      SomeModule.permission_reference :some_method
    end

    it "should return self if passed key is blank" do
      SomeModule.permission_reference_by_key("").should == SomeModule
    end

    it "should return result of method execution if passed reference is in the reference list" do
      SomeModule.permission_reference_by_key(:some_method).should == :result
    end

    it "should return nil if passed reference is not in the reference list" do
      SomeModule.permission_reference_by_key(:other_method).should be_nil
    end
  end
end