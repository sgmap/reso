module IframeCustomCssHelper
  def martinique_custom_css
    "section.section, section.section-grey, .section-grey, #section-thankyou {
      background-color: #ECF3FC !important;
    }
    .card, .landing-topic.block-link {
      background-color: #ffffff !important;
    }
    .landing-topic.block-link {
      margin-right: 2rem !important;
      flex: 0 0 45% !important;
      padding: 20px !important
    }
    "
  end
end
