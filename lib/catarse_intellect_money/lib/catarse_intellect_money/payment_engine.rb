module CatarseIntellectMoney
  class PaymentEngine

    def name
      'IntellectMoney'
    end

    def review_path contribution
      Engine.routes.url_helpers.review_path(contribution)
    end

    def can_do_refund?
      false
    end

    def direct_refund(contribution) end

    def locale
      'en'
    end

  end
end
