class IframesController < PagesController
  before_action :find_iframe
  include IframePrefix
  layout 'iframes'

  def index
    format = @iframe.format
  #  TODO rediriger vers la bonne vue si le format n'est pas 360
  end

  def show
    @landing = @iframe.landings.find_by_slug(params[:slug])
  end

  def new_solicitation
    @solicitation = @iframe.solicitations.new(landing_options_slugs: [params[:option_slug]].compact)
  end

  private

  def find_iframe
    @iframe = Iframe.find(params[:iframe_id])
  end
end
