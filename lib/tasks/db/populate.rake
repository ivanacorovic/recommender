namespace :db do 

  task populate_products: :environment do
    Product.destroy_all
    File.open("public/products.txt") do |products|
      products.read.each_line do |product|
        Product.create(name: product)
      end
    end
  end

  task populate_users: :environment do
    User.destroy_all
    File.open("public/users.txt") do |users|
      users.read.each_line do |user|
        User.create(name: user)
      end
    end
  end

  task populate_favorites: :environment do
    Favorite.destroy_all
    i = 0
    while i < 20000 do
      product = Product.offset(rand(Product.count)).first.id
      user = User.offset(rand(User.count)).first.id
      Favorite.create(product_id: product, user_id: user, label: true) if Favorite.all.where(user_id: user, product_id: product).empty?
      i = i + 1
    end
    # while i < 20100 do
    #   product = Product.offset(rand(Product.count)).first.id
    #   user = User.offset(rand(User.count)).first.id
    #   Favorite.create(product_id: product, user_id: user, label: false) if Favorite.all.where(user_id: user, product_id: product).empty?
    #   i = i + 1
    # end
  end

  task :populate => [
    :populate_products,
    :populate_users,
    :populate_favorites
  ]
end