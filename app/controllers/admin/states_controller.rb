class Admin::StatesController < Admin::BaseController

  before_filter :find_store_country
  before_filter :find_state, :only => [:edit, :update, :destroy]

  def index
    options = { :page => params[:page] }
    @states = @store_country.states.search(params[:search], options)
  end

  def new
    @state = @store_country.states.new
  end

  def create
    respond_to do |format|
      format.html do
        @state = State.new(params[:state])
        @state.country = @store_country.country
        if @store_country.states << @state
          flash[:message] = "State created successfully."
          redirect_to [:admin, @store_country, State.new] and return
        else
          render :action => 'new'
        end
      end
      format.js
    end
  end

  def edit; end

  def update
    respond_to do |format|
      format.html do
        if @state.update_attributes(params[:state])
          flash[:message] = "State updated successfully."
          redirect_to [:admin, @store_country, State.new] and return
        else
          render :action => 'edit'
        end
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @store_country, State.new] and return }
      format.js do
        @success = (@state and @state.destroy) ? true : false
      end
    end
    
  end

  def find_store_country
    @store_country = @store.store_countries.find_by_id(params[:store_country_id])
    flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and redirect_to [:admin, StoreCountry.new] and  return unless @store_country
  end

  def find_state
    @state = @store_country.states.find_by_id(params[:id])
    flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and redirect_to [:admin, @store_country, State.new] and return unless @state
  end

end
