RailsAdmin.config do |config|


  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end


  
  config.authenticate_with {} # leave it to authorize
  config.authorize_with do
    redirect_to main_app.root_path unless current_admin
  end
end