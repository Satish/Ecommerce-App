class Admin::CurrenciesController < Admin::BaseController
  
  before_filter :find_currency, :except => [:index, :new, :create]
  before_filter :set_metas, :only => [:show]
  
  def index
    options = { :page => params[:page] }
    @currencies = @store.currencies.search( params[:search], options )
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.rjs
      format.xml  { render :xml => @currencies }
    end
  end

  def new
    @currency = Currency.new
  end

  def create
    @currency = Currency.new(params[:currency])
    if @store.currencies << @currency
      flash[:message] = "Currency <em>'#{ @currency.name }'</em> created successfully"
      redirect_to_currencies_home
    else
      render :action => :new
    end
  end

  def edit; end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @currency }
    end
  end

  def update
    if params[:state] == 'active'
      flash[:message] = "Currency <em>'#{ @currency.name }'</em> activated successfully"
      @currency.activate!
    else
      if @currency.update_attributes((params[:currency]))
        flash[:message] = "Currency <em>'#{ @currency.name }'</em> updated successfully"
      else
        render :action => :edit and return
      end
    end
    redirect_to_currencies_home
  end

  def destroy
    respond_to do |format|
      format.html do
        flash[:message] = "Currency <em>'#{ @currency.name }'</em> deleted successfully"# if @currency.destroy
        redirect_to_currencies_home
      end
      format.js do
        render :update do |page|
          #page.remove("currency_#{ @currency.id }")
        end
      end
    end
  end

  private #######################
  
  def find_currency
    @currency = @store.currencies.find_by_id(params[:id])
    redirect_to_currencies_home and flash[:error] = PAGE_NOT_FOUND_ERROR_MESSAGE and return unless @currency
  end
  
  def redirect_to_currencies_home
    redirect_to [:admin, Currency.new] and return
  end
  
  def set_metas
    @meta_title = @currency.name.titleize if @currency
  end

end
