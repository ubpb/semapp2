# encoding: utf-8

ActionController::Routing::RouteSet::Mapper.class_eval do

  protected

    #
    # Setup routes for +AlephAuthenticatable+.
    #
    alias :aleph_authenticatable :authenticatable

end