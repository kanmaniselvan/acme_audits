# Custom index page to display all schools with Category Value.
ActiveAdmin.register_page 'CSV Uploads' do
  content do
    render partial: 'index'
  end
end
