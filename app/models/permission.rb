class Permission < ActiveRecord::Base
  belongs_to :controllable, :polymorphic => true

  validates_presence_of   :action, :rule
  validates_uniqueness_of :action, :scope => [:controllable_id, :controllable_type]

  named_scope :by_controllable_type, Proc.new{|type|
    {
      :conditions => {
        :controllable_id    => nil,
        :controllable_type  => type.to_s
      }
    }
  }

  def to_s
    self.rule.to_s
  end
end
