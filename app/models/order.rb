class Order < ApplicationRecord

    has_many :lineitems
    belongs_to :user, optional: true

    serialize :order_items, Hash
end
