require 'active_copy'

# Add the Markdown template handler.
ActionView::Template.register_template_handler :md, ActiveCopy::Template
