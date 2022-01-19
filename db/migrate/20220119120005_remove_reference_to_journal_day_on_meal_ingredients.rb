class RemoveReferenceToJournalDayOnMealIngredients < ActiveRecord::Migration[7.0]
  def up
    remove_reference :meal_ingredients, :journal_day
  end

  def down
    # not gonna happen
  end
end
