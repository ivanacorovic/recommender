module ApplicationHelper

  def sign(x)
    if x == 0
      return 0
    else
      if x < 0 
        return -1
      else return 1
      end
    end
  end

  def entropy(elements)
    sum = 0.0
    elements.each do |element|
      sum += element

    end
    result = 0.0
    elements.each do |x|
      zeroFlag = (x == 0 ? 1 : 0)
      result += x * Math.log((x + zeroFlag) / sum)
    end
    return -result
  end

  def logLikelihoodRatio(k11, k12, k21, k22)
    rowEntropy = entropy([k11, k12]) + entropy([k21, k22])
    columnEntropy = entropy([k11, k21]) + entropy([k12, k22])
    matrixEntropy = entropy([k11, k12, k21, k22])
    return 2 * (matrixEntropy - rowEntropy - columnEntropy)
  end

  def similarity(summedAggregations, normA, normB, numberOfColumns)
    logLikelihood = logLikelihoodRatio(summedAggregations.to_f,
      (normA.to_f - summedAggregations),
      (normB.to_f - summedAggregations),
      (numberOfColumns - normA - normB + summedAggregations).to_f)
    return 1.0 - 1.0 / (1.0 + logLikelihood)
  end

  def nearestN(arr, n=10)
    return arr.sort_by { |k| k[:similarity] }.reverse.take(n)
  end

  def duplicate(arr)
    arr.map{ |e| e if arr.count(e) > 1 }
  end

  def recommend(user, treshold = 0.6)
    user_products = user.products.ids
    result = []
    recommended = Product.all
    total = Favorite.count
    puts "1"
    User.all_except(user).each do |other_user|
      other_user_products = other_user.products.ids
      common = user_products & other_user_products
      sim = similarity(common.size, user_products.size, other_user_products.size, total)
      if sim > treshold
        result << {user_id: other_user.id, similarity: sim}
      end
    end
    result = nearestN(result)
    puts "2, result #{result}"
    result.each do |r|
      products = User.find(r[:user_id]).products.ids
      # products.each do |p|
      #   recommended << p
      # end
      puts "products #{products}"
      recommended = recommended & products
    end
    recommended = recommended.uniq - user_products
    return recommended.map { |r| Product.find(r).name }
  end
end
