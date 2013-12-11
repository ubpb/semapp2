class DropStoredFunctions < ActiveRecord::Migration
  def up
    execute("DROP FUNCTION reorder(integer, integer[])")
    execute("DROP FUNCTION update_positions()")
  end
end
