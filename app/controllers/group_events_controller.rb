class GroupEventsController < ApplicationController
   before_filter :find_by_id, only: [ :edit, :destroy, :show, :update ]

   def index
      @events = GroupEvent.all
      respond_to do |format|
         format.json { render json: @events }
         format.html
      end
   end

   def new
   end

   def create
      @event = GroupEvent.create( event_params )
      respond_to do |format|
         format.json { head :no_content }
         format.html
      end
   end

   def edit
   end

   def destroy
      @event.destroy
      respond_to do |format|
         format.json { head :no_content }
         format.html { redirect_to action: :index }
      end
   end

   def show
      respond_to do |format|
         format.json { render json: @event }
         format.html
      end
   end

   def update
      @event.update_attributes( event_params )
      respond_to do |format|
         format.json { head :no_content }
         format.html
      end
   end

   private

   def find_by_id
      @event = GroupEvent.where( id: params[ :id ] ).first || render_404
   end

   def event_params
      params.require( :group_event ).permit( :start_at )
   end

   def render_404
      respond_to do |format|
         format.json { head :not_found }
         format.html { render :status => 404 }
      end
   end
end
