module SourcesHelper
  def source_tag? tag
    @source.tags.include?(tag) unless @source.nil?
  end
end
