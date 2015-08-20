require 'rails_helper'

RSpec.describe GroupEvent, type: :model do

   def today
      Date.today.to_date
   end

   describe 'Group event model' do
      let( :its ) { GroupEvent }

      it { should have_a_bitfield :flags }
      it { should validate_presence_of( :start_at ) }
      it { should validate_presence_of( :end_at ) }

      # NOTE The event also has a name, description (which supports formatting) and
      # location.
      it { should have_db_column( :name ) }
      it { should have_db_column( :description ) }
      it { should have_db_column( :location ) }
   end

   describe 'Group event duration' do
      # NOTE: The group event should run for a whole number of days e.g.. 30 or 60.
      context 'when have long' do
         let( :long_event ) { GroupEvent.create( start_at: today, long: true ) }

         it { expect( long_event ).to be_long }
         it { expect( long_event.start_at.to_date ).to eq( today ) }
         it { expect( long_event.end_at.to_date ).to eq( today + 60 ) }
      end

      context 'when duration is changed' do
         def changed_event
            GroupEvent.where( start_at: today ).first_or_create
         end

         before( :each ) { changed_event.update_attribute( :long, true ) }
         it { expect( changed_event ).not_to be_long }
         it { expect( changed_event.start_at.to_date ).to eq( today ) }
         it { expect( changed_event.end_at.to_date ).to eq( today + 30 ) }
      end
   end

   describe 'Group event time fields' do
      # NOTE: There should be attributes to set the start, end or duration
      # of the event (and calculate the other value).

      context 'when begin_at and short duration' do
         let( :event_started_at ) { GroupEvent.create( start_at: today ) }

         it { expect( event_started_at.start_at.to_date ).to eq( today ) }
         it { expect( event_started_at.end_at.to_date ).to eq( today + 30) }
      end

      context 'when end_at and short duration' do
         let( :event_ended_at ) { GroupEvent.create( end_at: today + 30 ) }

         it { expect( event_ended_at.start_at.to_date ).to eq( today ) }
         it { expect( event_ended_at.end_at.to_date ).to eq( today + 30 ) }
      end
   end

   describe 'Group event behaviour' do
      # NOTE The event should be draft or published. To publish all of the fields are
      # required, it can be saved with only a subset of fields before it’s published.
      context "if is published" do
         before { allow( subject ).to receive( :published? ).and_return( true ) }
         it { should validate_presence_of( :name ) }
         it { should validate_presence_of( :description ) }
         it { should validate_presence_of( :location ) }
      end
   end

   describe 'Group event behaviour' do
      context "if is removed" do
         # NOTE: When the event is deleted/remove it should be kept in the database and
         # marked as such.
         before( :all ) do
            @event = GroupEvent.create( start_at: today )
            @event.destroy
         end

         it { expect( @event ).to be_removed }
         it do
            expect do
               @event.update_attribute( :name, "Name" )
            end.to raise_error( ActiveRecord::ReadOnlyRecord )
         end
      end
   end

end
