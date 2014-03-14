class AddSemesterToBookShelf < ActiveRecord::Migration
  def change
    add_column :book_shelves, :semester_id, :integer, index: true

    BookShelf.includes(sem_app: :semester).each do |bs|
      bs.semester = bs.sem_app.semester
      bs.save!(validate: false)
    end
  end
end
