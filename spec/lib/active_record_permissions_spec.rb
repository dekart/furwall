require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "factory_helper")

ActiveRecord::Migration.create_table :furwall_base_models, :force => true do |t|
  t.string(:type)
end

class FurwallBaseModel < ActiveRecord::Base

end

class FurwallSomeModel < FurwallBaseModel
  
end

describe FurwallSomeModel do
  before :each do
    @p1 = Factory(:permission, :controllable_type => "FurwallSomeModel")
    @p2 = Factory(:permission, :controllable_type => "FurwallBaseModel", :action => "other")

    @p3 = Factory(:permission, :controllable_type => "FurwallBaseModel", :controllable_id => 1)
  end

  it "should have many permissions" do
    FurwallSomeModel.reflect_on_all_associations(:has_many).find { |a| a.name == :permissions }
  end

  describe "when fetching class permission by action" do
    it "should fetch permission by class" do
      FurwallSomeModel.permission_for(:test).should == @p1
    end

    it "should fetch permission from base class if there no permission for this class" do
      FurwallSomeModel.permission_for(:other).should == @p2
    end
  end

  describe "when fetching instance permission by action" do
    before :each do
      @model = FurwallSomeModel.create
    end

    it "should find permission for current instance" do
      @model.permission_for(:test).should == @p3
    end

    it "should fetch permission from class if there no instance permissions" do
      @p3.destroy

      @model.permission_for(:test).should == @p1
    end
  end
end