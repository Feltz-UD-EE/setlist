class SheetInstrument < ApplicationRecord
  belongs_to :sheet
  belongs_to :instrument
end
