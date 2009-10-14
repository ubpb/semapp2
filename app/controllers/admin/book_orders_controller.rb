class Admin::BookOrdersController < Admin::ApplicationController

  resource_controller
  belongs_to :sem_app

  update do
    wants.html { redirect_to :action => 'index' }
    flash "Buchauftrag erfolgreich aktualisiert"
  end

  destroy do
    wants.html { redirect_to :action => 'index' }
    flash "Buchauftrag erfolgreich gelöscht"
  end

end