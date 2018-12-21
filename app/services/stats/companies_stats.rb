module Stats
  class CompaniesStats
    include BaseStats

    def main_query
      Company
        .joins(:visits)
        .where.not(facilities: { visits: { advisor: User.admin } })
    end

    def date_group_attribute
      'visits.created_at'
    end

    def filtered(query)
      if params.territory.present?
        query = query.merge(Territory.find(params.territory).companies)
      end
      if params.institution.present?
        query = query
          .joins(visits: [advisor: [antenne: :institution]])
          .where(facilities: { visits: { advisor: { antennes: { institution: params.institution } } } })
      end

      query
    end

    def category_group_attribute
      'substr(companies.legal_form_code,1,1)'
    end

    def category_name(category)
      CategorieJuridique.description(category)
    end
  end
end
