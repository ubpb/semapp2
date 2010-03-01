#
#  mysql --default-character-set=utf8 -u miless -pmiless miless -B -e "select DOC_LE_ID, RIGHTX, NAME, PASSWD  from RIGHTS as r, USERORGROUP as u where r.DOC_LE_ID like 'Document-%' AND u.USERID=r.USERID;" | sed 's/\t/","/g;s/^/"/;s/$/"/;s/\n//g' > miless_rights.csv
#
#

class UbdokRightsImporter

  def import_rights
    import_rights!
  end

  private

  def import_rights!
    MilessPassword.destroy_all
    
    File.open(File.join(RAILS_ROOT, 'import', 'miless_rights.csv')).each_with_index do |line, i|
      next if i == 0 # skip the first line (CSV header)
      
      if line.present? and line.strip!.present?
        rights = line.split(";")
        document_id = rights[0].slice(/"Document-(.+)"/, 1)
        right       = rights[1].slice(/"(w|r)"/, 1)
        username    = rights[2].slice(/"(.+)"/, 1)
        password    = rights[3].slice(/"(.+)"/, 1)

        if right.present? and username.present? and password.present?
          if right == "r" and username.downcase != "ubdozent" and username.downcase != "semapp"
            add_password(document_id, password)
          end
        else
          puts "Error: Null value document #{document_id}"
        end
      end
    end

    return true
  end

  def add_password(document_id, password)
    sem_app = SemApp.find_by_miless_document_id(document_id)
    if sem_app.present?
      MilessPassword.create!(:sem_app => sem_app, :password => password)
    else
      puts "Error: No SemApp for miless document #{document_id}"
    end
  end

end