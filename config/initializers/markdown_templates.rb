class MarkdownTemplateHandler
  OPTIONS = {
    escape_html: true,
    link_attributes: { rel: 'nofollow', target: '_blank' },
    safe_links_only: true
  }.freeze

  EXTENSIONS = {
    autolink: true,
    fenced_code_blocks: true,
    tables: true
  }.freeze

  def call(template)
    "MarkdownTemplateHandler.render(begin;#{erb.call(template)};end).html_safe"
  end

  def self.render(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(OPTIONS), EXTENSIONS).render(text)
  end

  def erb
    @erb ||= ActionView::Template.registered_template_handler(:erb)
  end
end

ActionView::Template.register_template_handler(:md, MarkdownTemplateHandler.new)
