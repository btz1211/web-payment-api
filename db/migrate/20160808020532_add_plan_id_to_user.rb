class AddPlanIdToUser < ActiveRecord::Migration
  def change
  	add_column :users, :planId, :integer, default: 1
  end
end
