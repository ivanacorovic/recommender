class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    # Find the correct user.
    @user = User.find(params[:id])

    # Find 10 recent favorites by the user. We use eager loading here to reduce database queries.
    @recent_favorites = @user.favorites.includes(:product).order('created_at DESC').limit(10)

    # Create new PredictionIO client.
    client = PredictionIO::EngineClient.new(ENV['PIO_DEPLOY_URL'])

    # Query PredictionIO for 5 recommendations!
    object = client.send_query('uid' => @user.id, 'n' => 5)

    # Initialize empty recommendations array.
    @recommendations = []

    # Loop though item recommendations returned from PredictionIO.
    object['items'].each do |item|
      # Initialize empty recommendation hash.
      recommendation = {}

      # Each item hash has only one key value pair so the first key is the item ID (in our case the product ID).
      product_id = item.keys.first

      # Find the product.
      product = Product.find(product_id)
      recommendation[:product] = product

      # Add to the array of recommendations.
      @recommendations << recommendation
    end
  end
end