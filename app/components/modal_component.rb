class ModalComponent < ViewComponent::Base
  with_content_areas :body, :footer
  attr_reader :title

  def initialize(title: nil)
    @title = title
  end

  def has_title?
    title.present?
  end
end
