defmodule FinancialAppWeb.Router do
  use FinancialAppWeb, :router

  import FinancialAppWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FinancialAppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FinancialAppWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/despesa/list/:id", DespesaController, :index
    get "/despesa/new/:id", DespesaController, :new
    get "/despesa/:id", DespesaController, :show
    post "/despesa/create", DespesaController, :create
    get "/despesa/edit/:id", DespesaController, :edit
    put "/despesa/update", DespesaController, :update
    delete "/despesa/delete/:id", DespesaController, :delete

    get "/receita/:id", ReceitaController, :index
    get "/receita/new/:id", ReceitaController, :new
    get "/receita/:id", ReceitaController, :show
    post "/receita/create/:id", ReceitaController, :create
    get "/receita/edit/:id", ReceitaController, :edit
    put "/receita/update/:id", ReceitaController, :update
    delete "/receita/delete/:id", ReceitaController, :delete
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FinancialAppWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", FinancialAppWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", FinancialAppWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", FinancialAppWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
