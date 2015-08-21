require 'rails_helper'

RSpec.describe GroupEventsController, type: :controller do

   let( :today ) { Date.today.to_date }
   let( :tomorrow ) { Date.today.to_date + 1 }
   let( :event ) { GroupEvent.where( start_at: today ).first_or_create }

   describe "GET #index" do
      it "returns http success" do
         get :index
         expect(response).to have_http_status(:success)
      end
   end

   describe "GET #new" do
      it "returns http success" do
         get :new
         expect(response).to have_http_status(:success)
      end
   end

   describe "POST #create" do
      it "returns http success" do
         post :create, group_event: { start_at: today }
         expect(response).to have_http_status(:success)
      end
   end

   describe "GET #edit" do
      it "returns http success" do
         get :edit, id: event.id
         expect(response).to have_http_status(:success)
      end
   end

   describe "DELETE #delete" do
      it "deletes the record, and returns http success" do
         e = event
         delete :destroy, id: e.id
         expect( response ).to redirect_to( action: :index )
         expect( e.reload.removed? ).to be_truthy
      end
   end

   describe "GET #show" do
      it "returns http success" do
         get :show, id: event.id
         expect(response).to have_http_status(:success)
      end
   end

   describe "PATCH #update" do
      it "returns http success" do
         e = event
         patch :update, id: event.id, group_event: { start_at: tomorrow }
         expect( response ).to have_http_status( :success )
         expect( e.reload.start_at.to_date ).to be_eql( tomorrow )
      end
   end

end
