require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "factory_helper")

class SomeClass
  def some_method
    return :result
  end
end

describe SomeClass do
  before :each do
    @p1 = Factory(:permission, :controllable_type => "SomeClass")
    @p2 = Factory(:permission, :controllable_type => "SomeClass", :action => "some")
  end

  describe "as class" do
    it "should be able to fetch permissions by action" do
      SomeClass.permission_for(:test).should == @p1
      SomeClass.permission_for(:some).should == @p2
    end

    it "should be able to store permission references" do
      SomeClass.permission_references.should be_nil

      SomeClass.permission_reference :some, "other"

      SomeClass.permission_references.should == [:some, :other]
    end
  end

  describe "as instance" do
    before :each do
      @object = SomeClass.new
    end

    it "should fetch class permission when fetching permission by action" do
      @object.permission_for(:test).should == @p1
    end

    describe "when fetching permission reference by key" do
      before :each do
        SomeClass.permission_reference(:some_method)
      end

      it "should return self if passed key is blank" do
        @object.permission_reference_by_key("").should == @object
      end

      it "should return result of method execution if passed reference is in the reference list" do
        @object.permission_reference_by_key(:some_method).should == :result
      end

      it "should return nil if passed reference is not in the reference list" do
        @object.permission_reference_by_key(:other_method).should be_nil
      end
    end
  end
end