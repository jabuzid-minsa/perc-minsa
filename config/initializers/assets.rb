# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += [ 'appviews.css', 'cssanimations.css', 'dashboards.css', 'forms.css', 'gallery.css', 'graphs.css', 'mailbox.css', 'miscellaneous.css', 'pages.css', 'tables.css', 'uielements.css', 'widgets.css', 'commerce.css', 'checkios.css', 'select2/select2.min.css', 'jasny/jasny-bootstrap.min.css', 'datatable.css', 'sweetalert.css', 'dual_listbox.css', 'dual-select.css', 'iCheck/custom.css', 'c3charts.css' ]
Rails.application.config.assets.precompile += [ 'appviews.js', 'cssanimations.js', 'dashboards.js', 'forms.js', 'gallery.js', 'graphs.js', 'mailbox.js', 'miscellaneous.js', 'pages.js', 'tables.js', 'uielements.js', 'widgets.js', 'commerce.js', 'metrics.js', 'checkios.js', 'select2/select2.full.min.js', 'jasny/jasny-bootstrap.min.js', 'datatable.js', 'sweetalert.js', 'moduls/geography.search.js', 'moduls/ajax.validations.js', 'dual_listbox.js', 'dual-select.js', 'iCheck/icheck.min.js', 'amcharts.js', 'c3charts.js' ]
