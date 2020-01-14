class CartController < ApplicationController

  before_action :authenticate_user!, except: [:add_to_cart, :view_order]
  before_action :products

  def add_to_cart
    line_item = Lineitem.create(product_id: params[:product_id], quantity: params[:quantity])
  
    line_item.update(line_item_total: (line_item.quantity * line_item.product.price))
  
    redirect_back(fallback_location: root_path)
  end

  def products
    @product = Product.all
  end
  def view_order
    @line_items = Lineitem.all
  end

  def kill_lineitem
    @line_items = Lineitem.find(params[:id])
    @line_items.destroy
    redirect_to view_order
  end

  def checkout
    line_items = Lineitem.all
    @order = Order.create(user_id: current_user.id, subtotal: 0)
  
    line_items.each do |line_item|
      line_item.product.update(quantity: (line_item.product.quantity - line_item.quantity))
      @order.order_items[line_item.product_id] = line_item.quantity 
      @order.subtotal += line_item.line_item_total
    end
    @order.save
  
    @order.update(sales_tax: (@order.subtotal * 0.08))
    @order.update(grand_total: (@order.sales_tax + @order.subtotal))
  
    line_items.destroy_all
  end
end
