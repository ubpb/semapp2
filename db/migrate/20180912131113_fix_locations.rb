class FixLocations < ActiveRecord::Migration[5.1]
  def change
    Location.all.each do |l|
      new_title = case l.id
      when 1 then "Ebene 1, Gebäude J (Zugang über Eingangsebene)"
      when 2 then "Ebene 2"
      when 3 then "Ebene 3"
      when 4 then "Ebene 4"
      when 5 then "Ebene 5"
      when 8 then "Ebene 2, Gebäude I (Zugang über Ebene 4)"
      end

      l.update_attributes(title: new_title)
    end

    ebene2i  = Location.find(7)
    ebene2i.insert_at(3)
  end
end
