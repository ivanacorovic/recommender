namespace :db do
  desc 'Send the data to PredictionIO'
  task predictionio: :environment do
    client = PredictionIO::EventClient.new(ENV['PIO_APP_ID'].to_i, ENV['PIO_EVENT_SERVER_URL'])

    # Send the users to PredictionIO.
    User.find_each do |user|
      begin
        client.set_user(user.id)
        puts "Sent user #{user.id} to PredictionIO."
      rescue => e
        puts "Error! User #{user.id} failed. #{e.message}"
      end
    end

    # Send the productes to PredictionIO.
    Product.find_each do |product|
      begin
        client.set_item(product.id, 'properties' => { 'pio_itypes' => ['product'] }) # TODO add in categories!
        # Display progress in the console.
        puts "Sent product #{product.id} to PredictionIO."
      rescue => e
        puts "Error! Product #{product.id} failed. #{e.message}"
      end
    end

    # Send the actions to predictionIO
    Favorite.train.find_each do |favorite|
      begin
        # Only send favorites that have a valid user and product.
        if favorite.user && favorite.product
          client.record_user_action_on_item(
            'like',
            favorite.user.id,
            favorite.product.id,
            'eventTime' => favorite.created_at
          )
          puts "Sent favorite #{favorite.id} from user #{favorite.user.id} of product #{favorite.product.id} PredictionIO."
        end
      rescue => e
        puts "Error! Review #{favorite.id} failed. #{e.message}"
      end
    end
  end
end