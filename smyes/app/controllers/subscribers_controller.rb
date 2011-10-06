class SubscribersController < ApplicationController

	# Non-Users can only use new, create, unsubscribe and deletesubscriber
  skip_before_filter :authorize, :only => [:new, :create, :unsubscribe, :deletesubscriber]
  
	# Only admins can edit, destroy, index and show (not editors)
	before_filter :admin_only, :only => [:edit, :destory, :index, :show]
  
  def index

    @subscribers = Subscriber.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscribers }
      end
  end

  # GET /subscribers/1
  # GET /subscribers/1.json
  def show

    @subscriber = Subscriber.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subscriber }
    end
  end

  # GET /subscribers/new
  # GET /subscribers/new.json
  def new
    @subscriber = Subscriber.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subscriber }
    end
  end

  # GET /subscribers/1/edit
  def edit

    @subscriber = Subscriber.find(params[:id])

  end

  # POST /subscribers
  # POST /subscribers.json
  def create

    params["subscriber"]["phone"] = params["subscriber"]["phone"].gsub("\s","").gsub(/^0044/, "").gsub(/^\+44/, "")
	if params["subscriber"]["phone"].length == 10
		params["subscriber"]["phone"] = '0' + params["subscriber"]["phone"]
	end

    @subscriber = Subscriber.new(params[:subscriber])

    respond_to do |format|
      if @subscriber.save
        format.html { redirect_to new_subscriber_path, alert: 'Subscriber was successfully created.' }
        format.json { render json: @subscriber, status: :created, location: @subscriber }
      else
        format.html { render action: "new" }
        format.json { render json: @subscriber.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subscribers/1
  # PUT /subscribers/1.json
  def update
    @subscriber = Subscriber.find(params[:id])

    respond_to do |format|
      if @subscriber.update_attributes(params[:subscriber])
        format.html { redirect_to @subscriber, notice: 'Subscriber was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscriber.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscribers/1
  # DELETE /subscribers/1.json
  def destroy

    @subscriber = Subscriber.find(params[:id])
    @subscriber.destroy

    respond_to do |format|
      format.html { redirect_to subscribers_url }
      format.json { head :ok }
    end
  end

  def unsubscribe

    respond_to do |format|
      format.html # unsubscribe.html.erb
    end

  end

  # Kriton's Delete Method
  #
  # Takes phone number from form
  # Checks formatting
  # Checks to see if it exists in database
  # If so then remove and divert to acknowledge page
  # If not then shows message says phone number not found

  def deletesubscriber

	params["phone"] = params["phone"].gsub("\s","").gsub(/^0044/, "").gsub(/^\+44/, "")
	if params["phone"].length == 10
		params["phone"] = '0' + params["phone"]
	end

	if (Subscriber.exists?(:phone => params[:phone]))
		subscriber = Subscriber.where(:phone => params[:phone]).first
		subscriber.destroy

		respond_to do |format|
		  format.html # deletesubscriber.html.erb
		end
	else
		redirect_to :action => "unsubscribe", phone: params[:phone]
    end
  end

end
