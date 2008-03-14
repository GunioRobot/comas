class AdminTasks < ActiveRecord::Migration
  def self.up
    create_catalogs :admin_tasks
    create_habtm :admin_tasks, :people
  end

  def self.down
    drop_habtm :admin_tasks, :people
    drop_catalogs :admin_tasks
  end
end
