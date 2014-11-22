Rails.application.routes.draw do
  controller :sessions do
    get :signin, to: :new, as: :signin
    post :signin, to: :create, as: :create_session
    delete :signout, to: :destroy, as: :signout
  end

  controller :root do
    root to: :index
  end
end

