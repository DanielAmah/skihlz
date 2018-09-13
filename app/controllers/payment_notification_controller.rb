class PaymentNotificationController < ApplicationController
  protect_from_forgery except: [:create]

  def create
    if PaymentNotification.create!(params: params, order_id: params[:invoice], status: params[:payment_status], transaction_id: params[:txn_id], amount: params[:payment_gross])
      redirect_to preorder_path, notice: 'Notification created'
    end
  end
end
