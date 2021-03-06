class StorageControllersController < ApplicationController
  # sets the @auth object and @object
  before_filter :get_obj_auth
  before_filter :modelperms

  # GET /storage_controllers
  # GET /storage_controllers.xml
  def index
    ## BUILD MASTER HASH WITH ALL SUB-PARAMS ##
    allparams = {}
    allparams[:mainmodel] = StorageController
    allparams[:webparams] = params
    results = Search.new(allparams).search

    flash[:error] = results[:errors].join('<br />') unless results[:errors].empty?
    includes = results[:includes]
    results[:requested_includes].each_pair{|k,v| includes[k] = v}
    @objects = results[:search_results]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @objects.to_xml(:include => convert_includes(includes), :dasherize => false) }
    end
  end

  # GET /storage_controllers/1
  # GET /storage_controllers/1.xml
  def show
    @storage_controller = @object

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @storage_controller.to_xml(:include => convert_includes(includes), :dasherize => false) }
    end
  end

  # GET /storage_controllers/new
  def new
    @storage_controller = @object
  end

  # GET /storage_controllers/1/edit
  def edit
    @storage_controller = @object
  end

  # POST /storage_controllers
  # POST /storage_controllers.xml
  def create
    @storage_controller = StorageController.new(params[:storage_controller])

#    # If the user specified some IP address info then handle that
#    if params.include?(:ip_addresses)
#      # Neat trick from http://www.stephenchu.com/2008/03/paramsfu-3-using-fieldsfor-and-index.html
#      if params[:ip_addresses].kind_of?(Hash)
#        @storage_controller.ip_addresses.build params[:ip_addresses].values
#      elsif params[:ip_addresses].kind_of?(Array)
#        @storage_controller.ip_addresses.build params[:ip_addresses]
#      end
#    end

    respond_to do |format|
      if @storage_controller.save
        flash[:notice] = 'StorageController was successfully created.'
        format.html { redirect_to storage_controller_url(@storage_controller) }
        format.xml  { head :created, :location => storage_controller_url(@storage_controller) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @storage_controller.errors.to_xml, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /storage_controllers/1
  # PUT /storage_controllers/1.xml
  def update
    @storage_controller = @object

#    # If the user specified some IP address info then handle that
#    if params.include?(:ip_addresses)
#      logger.info "User included IP info, handling it"
#
#      authoritative = false
#      iphashes = []
#      if params[:ip_addresses].kind_of?(Hash)
#        # Pull out the authoritative flag if the user specified it
#        if params[:ip_addresses].include?(:authoritative)
#          authoritative = params[:ip_addresses][:authoritative]
#          params[:ip_addresses].delete(:authoritative)
#        end
#        iphashes = params[:ip_addresses].values
#      elsif params[:ip_addresses].kind_of?(Array)
#        iphashes = params[:ip_addresses]
#      end
#      
#      iphashes.each do |iphash|
#        logger.info "Search for IP #{iphash[:address]}"
#        ip = @storage_controller.ip_addresses.find_by_address(iphash[:address])
#        if ip.nil?
#          logger.info "IP #{ipash[:address]} doesn't exist, creating it" + iphash.to_yaml
#          IpAddress.create(iphash)
#        else
#          logger.info "IP #{ipash[:address]} exists, updating it" + iphash.to_yaml
#          ip.update_attributes(iphash)
#        end
#      end
#
#      # If the client indicated that they were sending us an authoritative
#      # set of info for this NIC then remove any IPs stored in the database
#      # which the client didn't include in the info it sent
#      if authoritative
#        ips_from_client = []
#        iphashes.each { |iphash| ips_from_client.push(iphash[:address]) }
#        @storage_controller.ip_addresses.each do |ip|
#          if !ips_from_client.include?(ip.address)
#            ip.destroy
#          end
#        end
#      end
#
#    end # if params.include?(:ip_addresses)
    
    respond_to do |format|
      if @storage_controller.update_attributes(params[:storage_controller])
        flash[:notice] = 'StorageController was successfully updated.'
        format.html { redirect_to storage_controller_url(@storage_controller) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @storage_controller.errors.to_xml, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /storage_controllers/1
  # DELETE /storage_controllers/1.xml
  def destroy
    @storage_controller = @object
    @storage_controller.destroy

    respond_to do |format|
      format.html { redirect_to storage_controllers_url }
      format.xml  { head :ok }
    end
  end
  
  # GET /storage_controllers/1/version_history
  def version_history
    @storage_controller = StorageController.find(params[:id])
    render :action => "version_table", :layout => false
  end
  
  # GET /storage_controllers/field_names
  def field_names
    super(StorageController)
  end

  # GET /storage_controllers/search
  def search
    @storage_controller = StorageController.find(:first)
    render :action => 'search'
  end
  
end
