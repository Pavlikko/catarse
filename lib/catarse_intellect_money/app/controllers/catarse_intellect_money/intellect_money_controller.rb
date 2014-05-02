module CatarseIntellectMoney
  class IntellectMoneyController < ApplicationController

    layout false

    STATUS_CREATED      = 3
    STATUS_CONFIRMED    = 5

    def review
      @contribution = ::Contribution.find_by(id: params[:contribution_id])
      @title = t(
        'projects.contributions.edit.intellectmoney_title',
        project_name: @contribution.project.name,
      )
      @hash = Digest::MD5.hexdigest(
        [
          CatarseSettings[:intellectmoney_eshopid],
          @contribution.id,
          @title,
          @contribution.value,
          'TST',
          CatarseSettings[:intellectmoney_secret],
        ].join('::')
      )
    end

    def notification
      check_shop_id
      payment_status = allowed_params[:paymentStatus].to_i
      check_payment_status payment_status
      check_hash
      contribution = ::Contribution.find_by(:id => allowed_params[
        :orderId
      ].to_i)
      check_contribution_value contribution
      if payment_status == STATUS_CONFIRMED
        contribution.confirm
      elsif payment_status == STATUS_CREATED
        contribution.pendent
      end
    end

    private
    def allowed_params
      params.permit(
        :eshopId, :paymentId, :orderId, :eshopAccount, :serviceName,
        :recipientAmount, :recipientCurrency, :paymentStatus, :userName,
        :userEmail, :paymentData, :hash,
      )
    end

    def check_shop_id
      raise unless allowed_params[:eshopId] == ::CatarseSettings[
        :intellectmoney_eshopid
      ]
    end

    def check_payment_status payment_status
      raise unless [STATUS_CREATED, STATUS_CONFIRMED, ].include?(
        payment_status
      )
    end

    def check_hash
      raise unless Digest::MD5.hexdigest(
        [
          [
            :eshopId, :orderId, :serviceName, :eshopAccount, :recipientAmount,
            :recipientCurrency, :paymentStatus, :userName, :userEmail,
            :paymentData,
          ].collect { |el| allowed_params[el] } + [
            ::CatarseSettings[:intellectmoney_secret],
          ]
        ].join('::')
      ) == allowed_params[:hash]
    end

    def check_contribution_value contribution
      raise unless contribution.value.to_i == allowed_params[
        :recipientAmount
      ].to_i
    end
  end
end
