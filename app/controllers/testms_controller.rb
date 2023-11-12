class TestmsController < ApplicationController
  before_action :set_testm, only: %i[ show edit update destroy ]

  # GET /testms or /testms.json
  def index
    @testms = Testm.all
  end

  # GET /testms/1 or /testms/1.json
  def show
  end

  # GET /testms/new
  def new
    @testm = Testm.new
  end

  # GET /testms/1/edit
  def edit
  end

  # POST /testms or /testms.json
  def create
    @testm = Testm.new(testm_params)

    respond_to do |format|
      if @testm.save
        format.html { redirect_to testm_url(@testm), notice: "Testm was successfully created." }
        format.json { render :show, status: :created, location: @testm }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @testm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /testms/1 or /testms/1.json
  def update
    respond_to do |format|
      if @testm.update(testm_params)
        format.html { redirect_to testm_url(@testm), notice: "Testm was successfully updated." }
        format.json { render :show, status: :ok, location: @testm }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @testm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /testms/1 or /testms/1.json
  def destroy
    @testm.destroy!

    respond_to do |format|
      format.html { redirect_to testms_url, notice: "Testm was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_testm
      @testm = Testm.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def testm_params
      params.require(:testm).permit(:name, :ids, :password)
    end
end
