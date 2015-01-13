module WTK
  class Post < Grape::API
    desc 'Creates a spline that can be reticulated.'
    resource :spline do
      post do
        { reticulated: params[:reticulated] }
      end
    end


    #   desc 'Returns pong.'
    #   get :members do
    #     Member.where('name is not null').limit(10)
    #   end

    #   desc 'Returns pong.'
    #   get :users do
    #     User.where('name is not null').limit(10)
    #   end

    # desc 'Returns pong.'
    # get :product do
    #   Product.where('name is not null').limit(10)
    # end

    # desc 'Returns pong.'
    # get :organization do
    #   Organization.where('name is not null').limit(10)
    # end
 
  end
end