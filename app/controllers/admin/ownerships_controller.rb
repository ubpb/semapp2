class Admin::OwnershipsController < Admin::ApplicationController

  resource_controller
  belongs_to :sem_app

  index.before do
  end

  index do
    wants.html
    wants.js   { render :partial => 'admin/ownerships/listing' }
  end

  create do
    wants.html { redirect_to :action => 'index' }
    wants.js   { redirect_to :action => 'index', :format => 'js' }
    flash "Besitzer erfolgreich zugeordnet"
  end

  destroy do
    wants.html { redirect_to :action => 'index' }
    wants.js   { redirect_to :action => 'index', :format => 'js' }
    flash "Besitzer erfolgreich entfernt"
  end

end
