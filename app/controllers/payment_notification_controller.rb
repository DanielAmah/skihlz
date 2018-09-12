class PaymentNotificationController < ApplicationController
  protect_from_forgery except: [:create]

  def create
    if PaymentNotification.create!(params: params, order_id: params[:invoice], status: params[:payment_status], transaction_id: params[:txn_id])
      redirect_to root_path, notice: 'Notification created'
    end
  end
end
