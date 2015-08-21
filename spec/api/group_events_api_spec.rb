require 'rails_helper'

RSpec.describe GroupEventsController, type: :api do

   def today
      Date.today.to_date
   end
   let( :tomorrow ) { Date.today.to_date + 1 }
   let( :event ) { GroupEvent.where( start_at: today ).first_or_create }

   let( :url ) { "/group_events.json" }
   let( :event_url ) { "/group_events/#{ event.id }.json" }
   let( :nonexist_url ) do
      "/group_events/#{ GroupEvent.order( "id DESC" ).last.id + 1}.json"
   end
   let( :last ) { GroupEvent.last }

   describe "GET #index via json" do
      before( :all ) { GroupEvent.create( start_at: today ) }
      it "returns json list" do
         events = GroupEvent.all.to_json
         get url
         expect( last_response.status ).to be_eql( 200 )
         expect( last_response.body ).to be_json_eql( events )
      end
   end

   describe "POST #create" do
      it "creates an event, and returns no json" do
         post url, group_event: { start_at: today }
         e = GroupEvent.first.to_json
         expect( last_response.body ).to be_empty
         expect( last_response.status ).to be_eql( 204 )
      end
   end

   describe "DELETE #delete" do
      it "deletes the record, and returns no json" do
         delete event_url
         expect( last_response.body ).to be_empty
         expect( last_response.status ).to be_eql( 204 )
         expect( last.removed? ).to be_truthy
      end

      it "can't delete the non-exist record" do
         delete nonexist_url
         expect( last_response.status ).to be_eql( 404 )
      end
   end

   describe "GET #show" do
      it "returns json event" do
         get event_url
         expect( last_response.status ).to be_eql( 200 )
         expect( last_response.body ).to be_json_eql( last.to_json )
      end
   end

   describe "PATCH #update" do
      it "returns no json" do
         patch event_url, group_event: { start_at: tomorrow }
         expect( last_response.body ).to be_empty
         expect( last_response.status ).to be_eql( 204 )
         expect( GroupEvent.last.start_at.to_date ).to be_eql( tomorrow )
      end
   end

end
