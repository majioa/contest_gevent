class GroupEvent < ActiveRecord::Base
   include Bitfields

   bitfield :flags,
            1 => :published,
            2 => :removed,
            4 => :long

   before_validation :fix_dates

   validates :start_at, :end_at, presence: true
   validates :name, :description, :location, presence: true, if: :published?

   def destroy
      self.removed = true
      save
   end

   def readonly?
      if self.bitfield_changes[ 'removed' ] == [ false, true ]
         super
      else
         self.removed? || super
      end
   end

   private

   def duration
      self.long? && 60 || 30
   end

   def fix_dates
      if self.start_at?
         write_attribute( :end_at, self.start_at.to_date + duration )
      elsif self.end_at?
         write_attribute( :start_at, self.end_at.to_date - duration )
      end
   end
end
