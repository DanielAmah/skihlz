class Order < ApplicationRecord
  before_validation :generate_uuid!, :on => :create
  belongs_to :user
  belongs_to :payment_option
  scope :completed, -> { where(completed: "true") }
  self.primary_key = 'uuid'

  # This is where we create our Caller Reference for Amazon Payments, and prefill some other information.
  def self.prefill!(options = {})
    @order                = Order.new
    @order.name           = options[:name]
    @order.user_id        = options[:user_id]
    @order.price          = options[:price]
    @order.number         = Order.next_order_number
    @order.payment_option = options[:payment_option] if !options[:payment_option].nil?
    @order.save!

    @order
  end

  def self.paypal_checkout!(options = {})
    values = {
      :business => "daniel_amah@gmail.com", #test email
      :cmd => '_cart',
      :upload => 1,
      :return => options[:return_url],
      :rm => 2,
      :invoice => options[:uuid],
      :notify_url => options[:notify_url]
      }

      values.merge!({
      "amount_1" => options[:price],
      "item_name_1" => options[:name],
      "item_number_1" =>  options[:uuid],
      "quantity_1" => '1'
      })

      # This is a paypal sandbox url and should be changed for production.
      # Better define this url in the application configuration setting on environment
      # basis.
      "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end


  # After authenticating with Amazon, we get the rest of the details
  def self.postfill!(options = {})
    @order = Order.find_by!(:uuid => options[:callerReference])
    @order.token             = options[:tokenID]
    if @order.token.present?
      @order.address_one     = options[:addressLine1]
      @order.address_two     = options[:addressLine2]
      @order.city            = options[:city]
      @order.state           = options[:state]
      @order.status          = options[:status]
      @order.zip             = options[:zip]
      @order.phone           = options[:phoneNumber]
      @order.country         = options[:country]
      @order.expiration      = Date.parse(options[:expiry])
      @order.save!

      @order
    end
  end

  def self.next_order_number
    if Order.count > 0
      Order.order("number DESC").limit(1).first.number.to_i + 1
    else
      1
    end
  end

  def generate_uuid!
    begin
      self.uuid = SecureRandom.hex(16)
    end while Order.find_by(:uuid => self.uuid).present?
  end

  # goal is a dollar amount, not a number of backers, beause you may be using the multiple payment options component
  # by setting Settings.use_payment_options == true
  def self.goal
    Settings.project_goal
  end

  def self.percent
    (Order.revenue.to_f / Order.goal.to_f) * 100.to_f
  end

  # See what it looks like when you have some backers! Drop in a number instead of Order.count
  def self.backers
    Order.completed.count
  end

  def self.revenue
    if Settings.use_payment_options
      Order.where(completed: "true").pluck(:price).map(&:to_f).inject(0, :+)
    else
      Order.completed.pluck(:price).map(&:to_f).inject(0, :+)
    end
  end

  validates_presence_of :name, :price, :user_id
end
