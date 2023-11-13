class RoomsController < ApplicationController
  CACHE_EXPIRATION_TIME = 1.hour
  before_action :set_room, only: %i[ show edit update destroy ]
  # Function to process a single ID
  def process_id(id, duplicate_set, mutex)
    page = 1
    loop do
      uri = "https://solved.ac/api/v3/search/problem?query=@" + id + "&page=" + page.to_s
      response = HTTParty.get(uri)
      if response.code == 200
        result = JSON.parse(response.body)
        items = result['items']
        if items.length == 0
          break
        end
        items.each do |item|
          mutex.synchronize do
            duplicate_set.add(item["problemId"])
          end
        end
        page += 1
      else
        break
      end
    end
  end

  def duplicate
    name = params[:name]
    result = Room.exists?(name: name)
    respond_to do |format|
      Rails.logger.info(result)
      format.json { render json: { exist: result } }
    end
  end
  def exist
    result = Room.where(name: params[:name]).first
    Rails.logger.info result.inspect
    if result
      redirect_to room_url(result)
    else
      @error_message = "존재하지 않는 스터디입니다!"
      render 'index'
    end
  end
  # GET /rooms or /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1 or /rooms/1.json
  def show
    require 'set'
    require 'thread'
    @room = Room.find(params[:id])
    ids_array = JSON.parse(@room.ids) rescue []
    roomProblem = RoomProblem.find_by(room_id: params[:id])
    if roomProblem && roomProblem.timeExpired > Time.now
      @duplicatedList = roomProblem.ids
      return
    end
    Rails.logger.info "not cahced.."
    # Number of threads to use
    num_threads = ids_array.length  # Adjust this based on your requirements
    if num_threads==0
      num_threads = 1
    end
    # Synchronize access to shared data using Mutex
    mutex = Mutex.new

    duplicate_set = Set.new
    threads = []
    ids_array.each_slice(ids_array.length / num_threads) do |ids_chunk|
      thread = Thread.new do
        ids_chunk.each do |id|
          process_id(id, duplicate_set, mutex)
        end
      end
      threads << thread
    end

    threads.each(&:join)
    @duplicatedList = duplicate_set.to_a


    # Check if the RoomProblem record already exists for the duplicate_id
    room_problem = RoomProblem.find_or_initialize_by(room_id: params[:id])
    room_problem.update(ids: @duplicatedList, timeExpired: Time.now + CACHE_EXPIRATION_TIME)
    room_problem.save!  # Save the record
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms or /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to room_url(@room), notice: "Room was successfully created." }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    password = params[:room][:password]
    respond_to do |format|
      if Room.find(params[:id]).password == password
        Rails.logger.info "password 일치"

        room_problem = RoomProblem.find_by(room_id: params[:id])
        room_problem.destroy if room_problem.present?

        if @room.update(room_params)
          format.html { redirect_to room_url(@room), notice: "Room was successfully updated." }
          format.json { render :show, status: :ok, location: @room }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @room.errors, status: :unprocessable_entity }
        end
      else
        Rails.logger.info "password 불일치"
        format.html { render :edit, status: :unauthorized }
        format.json { render json: @room.errors, status: :unauthorized }
      end
    end
  end

  # DELETE /rooms/1 or /rooms/1.json
  def destroy
    @room.destroy!
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: "Room was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.require(:room).permit(:name, :ids, :password)
    end
end
