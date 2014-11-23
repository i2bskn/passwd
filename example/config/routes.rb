Rails.application.routes.draw do
  resource :profile, only: %i(show edit update) do
    patch :update_password, to: :update_password, as: :update_password
  end

  controller :sessions do
    get :signin, to: :new, as: :signin
    post :signin, to: :create, as: :create_session
    delete :signout, to: :destroy, as: :signout
  end

  controller :root do
    root to: :index
  end
end

