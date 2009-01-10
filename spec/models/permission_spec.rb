require File.join(File.dirname(__FILE__), "..", "spec_helper")
require File.join(File.dirname(__FILE__), "..", "factory_helper")

describe Permission do
  it "should belong to controllable" do
    Permission.reflect_on_all_associations(:belongs_to).find { |a| a.name == :controllable }
  end

  it "should not save without action" do
    @permission = Factory.build(:permission, :action => nil)

    lambda do
      @permission.save
      
      @permission.should_not be_valid
      @permission.errors.on(:action).should_not be_blank
    end.should_not change(Permission, :count)
  end

  it "should not save without rule" do
    @permission = Factory.build(:permission, :rule => nil)

    lambda do
      @permission.save

      @permission.should_not be_valid
      @permission.errors.on(:rule).should_not be_blank
    end.should_not change(Permission, :count)
  end

  it "should not save if action is not unique for controllable" do
    @first_permission   = Factory.create(:permission)
    @second_permission  = Factory.build(:permission)

    lambda do
      @second_permission.save

      @second_permission.should_not be_valid
      @second_permission.errors.on(:action).should_not be_blank
    end.should_not change(Permission, :count)

    @first_permission.destroy

    lambda do
      @second_permission.save
    end.should change(Permission, :count).by(1)
  end

  describe "when scoping by controllable type" do
    it "should fetch only permissions linked to classes" do
      @p1 = Factory.create(:permission, :controllable_type => "Some", :action => "one")
      @p2 = Factory.create(:permission, :controllable_type => "Some", :action => "two")
      @p3 = Factory.create(:permission, :controllable_type => "Some", :controllable_id => 123)
      @p4 = Factory.create(:permission, :controllable_type => "Other")

      Permission.by_controllable_type("Some").should have_exactly(2).items
      Permission.by_controllable_type("Some").should include(@p1, @p2)
      Permission.by_controllable_type("Some").should_not include(@p3)
    end
  end

  it "should return rule when converting to string" do
    Factory(:permission).to_s.should == "test_rule"
  end
end