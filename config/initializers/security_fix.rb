#
# Fixes params parsing security bug that was fixed in 2.3.15.
# We can't upgrade to 2.3.15 so we fix it by hand as decribed here:
#
# https://groups.google.com/forum/#!topic/rubyonrails-security/61bkgvnSGTQ/discussion
#

ActionController::Base.param_parsers.delete(Mime::XML)