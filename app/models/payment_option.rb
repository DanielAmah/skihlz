class PaymentOption < ApplicationRecord
  has_many :orders
end
