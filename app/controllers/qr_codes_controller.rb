class QrCodesController < ApplicationController
  before_action :fetch_qr_code, only: [:edit, :update, :destroy]
  before_action :authorize, only: [:index, :create]

  def new
  end

  def show
    @qr_code = QrCode.find(params[:id])
    @qr_code.scans = @qr_code.scans + 1
    @qr_code.save
    redirect_to @qr_code.url
  end
  
  def index
    if current_user.admin?
      @qr_codes = QrCode.all.page(params[:page])
    else  
      @qr_codes = current_user.qr_codes.page(params[:page])
      #  @qr_codes = QrCode.all.where({user_id: current_user.id}).page(params[:page])
    end
  end

  def create
    qr_code = QrCode.new
    qr_code.name = params[:name]
    qr_code.url = params[:url]
    qr_code.user_id = current_user.id
    if qr_code.save
      redirect_to qr_codes_path, { notice: 'Qr Code was successfully created'}
    else
      redirect_to root_path, { alert: 'Qr Code не был создан. Попробуйте ещё раз'}
    end
  end

  def edit
  end

  def update
    @qr_code.name = params[:name]
    if @qr_code.save
      redirect_to qr_codes_path, { notice: 'Qr Code was successfully update'}
    else
      redirect_to edit_qr_codes_path, { alert: 'Qr Code was NOT updated'}
    end
  end

  def destroy
    @qr_code.destroy

    redirect_to qr_codes_path   # , { notice: 'Qr Code was successfully delete'}
  end

  private
  
  def fetch_qr_code
    @qr_code = QrCode.find_by(id: params[:id])
  end

end