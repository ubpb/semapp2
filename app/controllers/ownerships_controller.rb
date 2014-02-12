class OwnershipsController < ApplicationController

  include OwnershipsConcern

  def create
    sem_app = do_create
    redirect_to edit_sem_app_path(sem_app, :anchor => 'users')
  end

  def destroy
    sem_app = do_destroy
    redirect_to edit_sem_app_path(sem_app, :anchor => 'users')
  end

end
