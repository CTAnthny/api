class CredTransactionsController < ApplicationController
  def index
    user = User.find(params[:user_id])
    render json: user.cred_transactions.order(created_at: :desc)
  end
end
